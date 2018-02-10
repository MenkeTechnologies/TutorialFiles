# Copyright (C) 2017 ycmd contributors
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

from __future__ import unicode_literals
from __future__ import print_function
from __future__ import division
from __future__ import absolute_import
# Not installing aliases from python-future; it's unreliable and slow.
from builtins import *  # noqa

from mock import patch
from hamcrest import ( assert_that,
                       calling,
                       equal_to,
                       contains,
                       has_entries,
                       has_items,
                       raises )

from ycmd.completers.language_server import language_server_completer as lsc
from ycmd.completers.language_server import language_server_protocol as lsp
from ycmd.tests.language_server import MockConnection
from ycmd.request_wrap import RequestWrap
from ycmd.tests.test_utils import ( BuildRequest,
                                    ChunkMatcher,
                                    DummyCompleter,
                                    LocationMatcher )
from ycmd import handlers, utils, responses


class MockCompleter( lsc.LanguageServerCompleter, DummyCompleter ):
  def __init__( self ):
    self._connection = MockConnection()
    super( MockCompleter, self ).__init__(
      handlers._server_state._user_options )


  def GetConnection( self ):
    return self._connection


  def HandleServerCommand( self, request_data, command ):
    return super( MockCompleter, self ).HandleServerCommand( request_data,
                                                             command )


  def ServerIsHealthy( self ):
    return True


def LanguageServerCompleter_Initialise_Aborted_test():
  completer = MockCompleter()
  request_data = RequestWrap( BuildRequest() )

  with patch.object( completer.GetConnection(),
                     'ReadData',
                     side_effect = RuntimeError ):

    assert_that( completer.ServerIsReady(), equal_to( False ) )

    completer.SendInitialize( request_data )

    with patch.object( completer, '_HandleInitializeInPollThread' ) as handler:
      completer.GetConnection().run()
      handler.assert_not_called()

    assert_that( completer._initialize_event.is_set(), equal_to( False ) )
    assert_that( completer.ServerIsReady(), equal_to( False ) )


  with patch.object( completer, 'ServerIsHealthy', return_value = False ):
    assert_that( completer.ServerIsReady(), equal_to( False ) )


def LanguageServerCompleter_Initialise_Shutdown_test():
  completer = MockCompleter()
  request_data = RequestWrap( BuildRequest() )

  with patch.object( completer.GetConnection(),
                     'ReadData',
                     side_effect = lsc.LanguageServerConnectionStopped ):

    assert_that( completer.ServerIsReady(), equal_to( False ) )

    completer.SendInitialize( request_data )

    with patch.object( completer, '_HandleInitializeInPollThread' ) as handler:
      completer.GetConnection().run()
      handler.assert_not_called()

    assert_that( completer._initialize_event.is_set(), equal_to( False ) )
    assert_that( completer.ServerIsReady(), equal_to( False ) )


  with patch.object( completer, 'ServerIsHealthy', return_value = False ):
    assert_that( completer.ServerIsReady(), equal_to( False ) )


def LanguageServerCompleter_GoToDeclaration_test():
  if utils.OnWindows():
    filepath = 'C:\\test.test'
    uri = 'file:///c:/test.test'
  else:
    filepath = '/test.test'
    uri = 'file:/test.test'

  contents = 'line1\nline2\nline3'

  completer = MockCompleter()
  request_data = RequestWrap( BuildRequest(
    filetype = 'ycmtest',
    filepath = filepath,
    contents = contents
  ) )

  @patch.object( completer, 'ServerIsReady', return_value = True )
  def Test( response, checker, throws, *args ):
    with patch.object( completer.GetConnection(),
                       'GetResponse',
                       return_value = response ):
      if throws:
        assert_that(
          calling( completer.GoToDeclaration ).with_args( request_data ),
          raises( checker )
        )
      else:
        result = completer.GoToDeclaration( request_data )
        print( 'Result: {0}'.format( result ) )
        assert_that( result, checker )


  location = {
    'uri': uri,
    'range': {
      'start': { 'line': 0, 'character': 0 },
      'end': { 'line': 0, 'character': 0 },
    }
  }

  goto_response = has_entries( {
    'filepath': filepath,
    'column_num': 1,
    'line_num': 1,
    'description': 'line1'
  } )

  cases = [
    ( { 'result': None }, RuntimeError, True ),
    ( { 'result': location }, goto_response, False ),
    ( { 'result': {} }, RuntimeError, True ),
    ( { 'result': [] }, RuntimeError, True ),
    ( { 'result': [ location ] }, goto_response, False ),
    ( { 'result': [ location, location ] },
      contains( goto_response, goto_response ),
      False ),
  ]

  for response, checker, throws in cases:
    yield Test, response, checker, throws


  with patch(
    'ycmd.completers.language_server.language_server_protocol.UriToFilePath',
    side_effect = lsp.InvalidUriException ):
    yield Test, {
      'result': {
        'uri': uri,
        'range': {
          'start': { 'line': 0, 'character': 0 },
          'end': { 'line': 0, 'character': 0 },
        }
      }
    }, has_entries( {
      'filepath': '',
      'column_num': 1,
      'line_num': 1,
    } ), False

  with patch( 'ycmd.completers.completer_utils.GetFileContents',
              side_effect = lsp.IOError ):
    yield Test, {
      'result': {
        'uri': uri,
        'range': {
          'start': { 'line': 0, 'character': 0 },
          'end': { 'line': 0, 'character': 0 },
        }
      }
    }, has_entries( {
      'filepath': filepath,
      'column_num': 1,
      'line_num': 1,
    } ), False


def GetCompletions_RejectInvalid_test():
  if utils.OnWindows():
    filepath = 'C:\\test.test'
  else:
    filepath = '/test.test'

  contents = 'line1.\nline2.\nline3.'

  request_data = RequestWrap( BuildRequest(
    filetype = 'ycmtest',
    filepath = filepath,
    contents = contents,
    line_num = 1,
    column_num = 7
  ) )

  text_edit = {
    'newText': 'blah',
    'range': {
      'start': { 'line': 0, 'character': 6 },
      'end': { 'line': 0, 'character': 6 },
    }
  }

  assert_that( lsc._GetCompletionItemStartCodepointOrReject( text_edit,
                                                             request_data ),
               equal_to( 7 ) )

  text_edit = {
    'newText': 'blah',
    'range': {
      'start': { 'line': 0, 'character': 6 },
      'end': { 'line': 1, 'character': 6 },
    }
  }

  assert_that(
    calling( lsc._GetCompletionItemStartCodepointOrReject ).with_args(
      text_edit, request_data ),
    raises( lsc.IncompatibleCompletionException ) )

  text_edit = {
    'newText': 'blah',
    'range': {
      'start': { 'line': 0, 'character': 20 },
      'end': { 'line': 0, 'character': 20 },
    }
  }

  assert_that(
    lsc._GetCompletionItemStartCodepointOrReject( text_edit, request_data ),
    equal_to( 7 ) )

  text_edit = {
    'newText': 'blah',
    'range': {
      'start': { 'line': 0, 'character': 6 },
      'end': { 'line': 0, 'character': 5 },
    }
  }

  assert_that(
    lsc._GetCompletionItemStartCodepointOrReject( text_edit, request_data ),
    equal_to( 7 ) )


def WorkspaceEditToFixIt_test():
  if utils.OnWindows():
    filepath = 'C:\\test.test'
    uri = 'file:///c:/test.test'
  else:
    filepath = '/test.test'
    uri = 'file:/test.test'

  contents = 'line1\nline2\nline3'

  request_data = RequestWrap( BuildRequest(
    filetype = 'ycmtest',
    filepath = filepath,
    contents = contents
  ) )


  # We don't support versioned documentChanges
  assert_that( lsc.WorkspaceEditToFixIt( request_data,
                                         { 'documentChanges': [] } ),
               equal_to( None ) )

  workspace_edit = {
    'changes': {
      uri: [
        {
          'newText': 'blah',
          'range': {
            'start': { 'line': 0, 'character': 5 },
            'end': { 'line': 0, 'character': 5 },
          }
        },
      ]
    }
  }

  response = responses.BuildFixItResponse( [
    lsc.WorkspaceEditToFixIt( request_data, workspace_edit, 'test' )
  ] )

  print( 'Response: {0}'.format( response ) )
  print( 'Type Response: {0}'.format( type( response ) ) )

  assert_that(
    response,
    has_entries( {
      'fixits': contains( has_entries( {
        'text': 'test',
        'chunks': contains( ChunkMatcher( 'blah',
                                          LocationMatcher( filepath, 1, 6 ),
                                          LocationMatcher( filepath, 1, 6 ) ) )
      } ) )
    } )
  )


def LanguageServerCompleter_DelayedInitialization_test():
  completer = MockCompleter()
  request_data = RequestWrap( BuildRequest( filepath = 'Test.ycmtest' ) )

  with patch.object( completer, '_UpdateServerWithFileContents' ) as update:
    with patch.object( completer, '_PurgeFileFromServer' ) as purge:
      completer.SendInitialize( request_data )
      completer.OnFileReadyToParse( request_data )
      completer.OnBufferUnload( request_data )
      update.assert_not_called()
      purge.assert_not_called()

      # Simulate recept of response and initialization complete
      initialize_response = {
        'result': {
          'capabilities': {}
        }
      }
      completer._HandleInitializeInPollThread( initialize_response )

      update.assert_called_with( request_data )
      purge.assert_called_with( 'Test.ycmtest' )


def LanguageServerCompleter_ShowMessage_test():
  completer = MockCompleter()
  request_data = RequestWrap( BuildRequest() )
  notification = {
    'method': 'window/showMessage',
    'params': {
      'message': 'this is a test'
    }
  }
  assert_that( completer.ConvertNotificationToMessage( request_data,
                                                       notification ),
               has_entries( { 'message': 'this is a test' } ) )


def LanguageServerCompleter_GetCompletions_List_test():
  completer = MockCompleter()
  request_data = RequestWrap( BuildRequest() )

  completion_response = { 'result': [ { 'label': 'test' } ] }

  resolve_responses = [
    { 'result': { 'label': 'test' } },
  ]

  with patch.object( completer, 'ServerIsReady', return_value = True ):
    with patch.object( completer.GetConnection(),
                       'GetResponse',
                       side_effect = [ completion_response ] +
                                     resolve_responses ):
      assert_that( completer.ComputeCandidatesInner( request_data ),
                   has_items( has_entries( { 'insertion_text': 'test' } ) ) )


def FindOverlapLength_test():
  tests = [
    ( '', '', 0 ),
    ( 'a', 'a', 1 ),
    ( 'a', 'b', 0 ),
    ( 'abcdef', 'abcdefg', 6 ),
    ( 'abcdefg', 'abcdef', 0 ),
    ( 'aaab', 'aaab', 4 ),
    ( 'abab', 'ab', 2 ),
    ( 'aab', 'caab', 0 ),
    ( 'abab', 'abababab', 4 ),
    ( 'aaab', 'baaa', 1 ),
    ( 'test.', 'test.test', 5 ),
    ( 'test.', 'test', 0 ),
    ( 'test', 'testtest', 4 ),
    ( '', 'testtest', 0 ),
    ( 'test', '', 0 ),
    ( 'Some CoCo', 'CoCo Beans', 4 ),
    ( 'Have some CoCo and CoCo', 'CoCo and CoCo is here.', 13 ),
    ( 'TEST xyAzA', 'xyAzA test', 5 ),
  ]

  def Test( line, text, overlap ):
    assert_that( lsc.FindOverlapLength( line, text ), equal_to( overlap ) )

  for test in tests:
    yield Test, test[ 0 ], test[ 1 ], test[ 2 ]
