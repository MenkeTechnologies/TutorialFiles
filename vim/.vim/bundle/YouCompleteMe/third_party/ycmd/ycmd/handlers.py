# Copyright (C) 2013 Google Inc.
#               2017 ycmd contributors
#
# This file is part of ycmd.
#
# ycmd is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ycmd is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with ycmd.  If not, see <http://www.gnu.org/licenses/>.

from __future__ import absolute_import
from __future__ import unicode_literals
from __future__ import print_function
from __future__ import division
# Not installing aliases from python-future; it's unreliable and slow.
from builtins import *  # noqa

import bottle
import json
import logging
import platform
import sys
import time
import traceback
from bottle import request
from threading import Thread

import ycm_core
from ycmd import extra_conf_store, hmac_plugin, server_state, user_options_store
from ycmd.responses import ( BuildExceptionResponse, BuildCompletionResponse,
                             UnknownExtraConf )
from ycmd.request_wrap import RequestWrap
from ycmd.bottle_utils import SetResponseHeader
from ycmd.completers.completer_utils import FilterAndSortCandidatesWrap


# num bytes for the request body buffer; request.json only works if the request
# size is less than this
bottle.Request.MEMFILE_MAX = 10 * 1024 * 1024

_server_state = None
_hmac_secret = bytes()
_logger = logging.getLogger( __name__ )
app = bottle.Bottle()
wsgi_server = None


@app.post( '/event_notification' )
def EventNotification():
  _logger.info( 'Received event notification' )
  request_data = RequestWrap( request.json )
  event_name = request_data[ 'event_name' ]
  _logger.debug( 'Event name: %s', event_name )

  event_handler = 'On' + event_name
  getattr( _server_state.GetGeneralCompleter(), event_handler )( request_data )

  filetypes = request_data[ 'filetypes' ]
  response_data = None
  if _server_state.FiletypeCompletionUsable( filetypes ):
    response_data = getattr( _server_state.GetFiletypeCompleter( filetypes ),
                             event_handler )( request_data )

  if response_data:
    return _JsonResponse( response_data )
  return _JsonResponse( {} )


@app.post( '/run_completer_command' )
def RunCompleterCommand():
  _logger.info( 'Received command request' )
  request_data = RequestWrap( request.json )
  completer = _GetCompleterForRequestData( request_data )

  return _JsonResponse( completer.OnUserCommand(
      request_data[ 'command_arguments' ],
      request_data ) )


@app.post( '/completions' )
def GetCompletions():
  _logger.info( 'Received completion request' )
  request_data = RequestWrap( request.json )
  ( do_filetype_completion, forced_filetype_completion ) = (
                    _server_state.ShouldUseFiletypeCompleter( request_data ) )
  _logger.debug( 'Using filetype completion: %s', do_filetype_completion )

  errors = None
  completions = None

  if do_filetype_completion:
    try:
      completions = ( _server_state.GetFiletypeCompleter(
                                  request_data[ 'filetypes' ] )
                                 .ComputeCandidates( request_data ) )

    except Exception as exception:
      if forced_filetype_completion:
        # user explicitly asked for semantic completion, so just pass the error
        # back
        raise
      else:
        # store the error to be returned with results from the identifier
        # completer
        stack = traceback.format_exc()
        _logger.error( 'Exception from semantic completer (using general): ' +
                        "".join( stack ) )
        errors = [ BuildExceptionResponse( exception, stack ) ]

  if not completions and not forced_filetype_completion:
    completions = ( _server_state.GetGeneralCompleter()
                                 .ComputeCandidates( request_data ) )

  return _JsonResponse(
      BuildCompletionResponse( completions if completions else [],
                               request_data[ 'start_column' ],
                               errors = errors ) )


@app.post( '/filter_and_sort_candidates' )
def FilterAndSortCandidates():
  _logger.info( 'Received filter & sort request' )
  # Not using RequestWrap because no need and the requests coming in aren't like
  # the usual requests we handle.
  request_data = request.json

  return _JsonResponse( FilterAndSortCandidatesWrap(
    request_data[ 'candidates'],
    request_data[ 'sort_property' ],
    request_data[ 'query' ],
    _server_state.user_options[ 'max_num_candidates' ] ) )


@app.get( '/healthy' )
def GetHealthy():
  _logger.info( 'Received health request' )
  if request.query.subserver:
    filetype = request.query.subserver
    completer = _server_state.GetFiletypeCompleter( [ filetype ] )
    return _JsonResponse( completer.ServerIsHealthy() )
  return _JsonResponse( True )


@app.get( '/ready' )
def GetReady():
  _logger.info( 'Received ready request' )
  if request.query.subserver:
    filetype = request.query.subserver
    completer = _server_state.GetFiletypeCompleter( [ filetype ] )
    return _JsonResponse( completer.ServerIsReady() )
  return _JsonResponse( True )


@app.post( '/semantic_completion_available' )
def FiletypeCompletionAvailable():
  _logger.info( 'Received filetype completion available request' )
  return _JsonResponse( _server_state.FiletypeCompletionAvailable(
      RequestWrap( request.json )[ 'filetypes' ] ) )


@app.post( '/defined_subcommands' )
def DefinedSubcommands():
  _logger.info( 'Received defined subcommands request' )
  completer = _GetCompleterForRequestData( RequestWrap( request.json ) )

  return _JsonResponse( completer.DefinedSubcommands() )


@app.post( '/detailed_diagnostic' )
def GetDetailedDiagnostic():
  _logger.info( 'Received detailed diagnostic request' )
  request_data = RequestWrap( request.json )
  completer = _GetCompleterForRequestData( request_data )

  return _JsonResponse( completer.GetDetailedDiagnostic( request_data ) )


@app.post( '/load_extra_conf_file' )
def LoadExtraConfFile():
  _logger.info( 'Received extra conf load request' )
  request_data = RequestWrap( request.json, validate = False )
  extra_conf_store.Load( request_data[ 'filepath' ], force = True )

  return _JsonResponse( True )


@app.post( '/ignore_extra_conf_file' )
def IgnoreExtraConfFile():
  _logger.info( 'Received extra conf ignore request' )
  request_data = RequestWrap( request.json, validate = False )
  extra_conf_store.Disable( request_data[ 'filepath' ] )

  return _JsonResponse( True )


@app.post( '/debug_info' )
def DebugInfo():
  _logger.info( 'Received debug info request' )
  request_data = RequestWrap( request.json )

  has_clang_support = ycm_core.HasClangSupport()
  clang_version = ycm_core.ClangVersion() if has_clang_support else None

  filepath = request_data[ 'filepath' ]
  try:
    extra_conf_path = extra_conf_store.ModuleFileForSourceFile( filepath )
    is_loaded = bool( extra_conf_path )
  except UnknownExtraConf as error:
    extra_conf_path = error.extra_conf_file
    is_loaded = False

  response = {
    'python': {
      'executable': sys.executable,
      'version': platform.python_version()
    },
    'clang': {
      'has_support': has_clang_support,
      'version': clang_version
    },
    'extra_conf': {
      'path': extra_conf_path,
      'is_loaded': is_loaded
    },
    'completer': None
  }

  try:
    response[ 'completer' ] = _GetCompleterForRequestData(
        request_data ).DebugInfo( request_data )
  except Exception as error:
    _logger.exception( error )

  return _JsonResponse( response )


@app.post( '/shutdown' )
def Shutdown():
  _logger.info( 'Received shutdown request' )
  ServerShutdown()

  return _JsonResponse( True )


# The type of the param is Bottle.HTTPError
def ErrorHandler( httperror ):
  body = _JsonResponse( BuildExceptionResponse( httperror.exception,
                                                httperror.traceback ) )
  hmac_plugin.SetHmacHeader( body, _hmac_secret )
  return body


# For every error Bottle encounters it will use this as the default handler
app.default_error_handler = ErrorHandler


def _JsonResponse( data ):
  SetResponseHeader( 'Content-Type', 'application/json' )
  return json.dumps( data, default = _UniversalSerialize )


def _UniversalSerialize( obj ):
  try:
    serialized = obj.__dict__.copy()
    serialized[ 'TYPE' ] = type( obj ).__name__
    return serialized
  except AttributeError:
    return str( obj )


def _GetCompleterForRequestData( request_data ):
  completer_target = request_data.get( 'completer_target', None )

  if completer_target == 'identifier':
    return _server_state.GetGeneralCompleter().GetIdentifierCompleter()
  elif completer_target == 'filetype_default' or not completer_target:
    return _server_state.GetFiletypeCompleter( request_data[ 'filetypes' ] )
  else:
    return _server_state.GetFiletypeCompleter( [ completer_target ] )


def ServerShutdown():
  def Terminator():
    if wsgi_server:
      wsgi_server.Shutdown()

  # Use a separate thread to let the server send the response before shutting
  # down.
  terminator = Thread( target = Terminator )
  terminator.daemon = True
  terminator.start()


def ServerCleanup():
  if _server_state:
    _server_state.Shutdown()
    extra_conf_store.Shutdown()


def SetHmacSecret( hmac_secret ):
  global _hmac_secret
  _hmac_secret = hmac_secret


def UpdateUserOptions( options ):
  global _server_state

  if not options:
    return

  # This should never be passed in, but let's try to remove it just in case.
  options.pop( 'hmac_secret', None )
  user_options_store.SetAll( options )
  _server_state = server_state.ServerState( options )


def KeepSubserversAlive( check_interval_seconds ):
  def Keepalive( check_interval_seconds ):
    while True:
      time.sleep( check_interval_seconds )

      _logger.debug( 'Keeping subservers alive' )
      loaded_completers = _server_state.GetLoadedFiletypeCompleters()
      for completer in loaded_completers:
        completer.ServerIsHealthy()

  keepalive = Thread( target = Keepalive,
                      args = ( check_interval_seconds, ) )
  keepalive.daemon = True
  keepalive.start()
