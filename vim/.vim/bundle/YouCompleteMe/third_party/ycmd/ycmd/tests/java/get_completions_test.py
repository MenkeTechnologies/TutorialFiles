# Copyright (C) 2017 ycmd contributors
# encoding: utf-8
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

from __future__ import print_function
from __future__ import absolute_import
from __future__ import unicode_literals
from __future__ import division
# Not installing aliases from python-future; it's unreliable and slow.
from builtins import *  # noqa

from hamcrest import ( assert_that,
                       contains,
                       contains_inanyorder,
                       empty,
                       matches_regexp,
                       has_entries,
                       has_item )
from nose.tools import eq_

from pprint import pformat
import requests

from ycmd import handlers
from ycmd.tests.java import DEFAULT_PROJECT_DIR, PathToTestFile, SharedYcmd
from ycmd.tests.test_utils import ( BuildRequest,
                                    ChunkMatcher,
                                    CompletionEntryMatcher,
                                    LocationMatcher )
from ycmd.utils import ReadFile
from mock import patch


def _CombineRequest( request, data ):
  return BuildRequest( **_Merge( request, data ) )


def _Merge( request, data ):
  kw = dict( request )
  kw.update( data )
  return kw


def ProjectPath( *args ):
  return PathToTestFile( DEFAULT_PROJECT_DIR,
                         'src',
                         'com',
                         'test',
                         *args )


def RunTest( app, test ):
  """
  Method to run a simple completion test and verify the result

  test is a dictionary containing:
    'request': kwargs for BuildRequest
    'expect': {
       'response': server response code (e.g. httplib.OK)
       'data': matcher for the server response json
    }
  """

  contents = ReadFile( test[ 'request' ][ 'filepath' ] )

  app.post_json( '/event_notification',
                 _CombineRequest( test[ 'request' ], {
                                  'event_name': 'FileReadyToParse',
                                  'contents': contents,
                                  } ),
                 expect_errors = True )

  # We ignore errors here and we check the response code ourself.
  # This is to allow testing of requests returning errors.
  response = app.post_json( '/completions',
                            _CombineRequest( test[ 'request' ], {
                               'contents': contents
                            } ),
                            expect_errors = True )

  print( 'completer response: {0}'.format( pformat( response.json ) ) )

  eq_( response.status_code, test[ 'expect' ][ 'response' ] )

  assert_that( response.json, test[ 'expect' ][ 'data' ] )


PUBLIC_OBJECT_METHODS = [
  CompletionEntryMatcher( 'equals', 'Object', { 'kind': 'Function' } ),
  CompletionEntryMatcher( 'getClass', 'Object', { 'kind': 'Function' } ),
  CompletionEntryMatcher( 'hashCode', 'Object', { 'kind': 'Function' } ),
  CompletionEntryMatcher( 'notify', 'Object', { 'kind': 'Function' } ),
  CompletionEntryMatcher( 'notifyAll', 'Object', { 'kind': 'Function' } ),
  CompletionEntryMatcher( 'toString', 'Object', { 'kind': 'Function' } ),
  CompletionEntryMatcher( 'wait', 'Object', {
    'menu_text': matches_regexp( 'wait\\(long .*, int .*\\) : void' ),
    'kind': 'Function',
  } ),
  CompletionEntryMatcher( 'wait', 'Object', {
    'menu_text': matches_regexp( 'wait\\(long .*\\) : void' ),
    'kind': 'Function',
  } ),
  CompletionEntryMatcher( 'wait', 'Object', {
    'menu_text': 'wait() : void',
    'kind': 'Function',
  } ),
]


# The zealots that designed java made everything inherit from Object (except,
# possibly Object, or Class, or whichever one they used to break the Smalltalk
# infinite recursion problem). Anyway, that means that we get a lot of noise
# suggestions from the Object Class interface. This allows us to write:
#
#   contains_inanyorder( *WithObjectMethods( CompletionEntryMatcher( ... ) ) )
#
# and focus on what we care about.
def WithObjectMethods( *args ):
  return list( PUBLIC_OBJECT_METHODS ) + list( args )


@SharedYcmd
def GetCompletions_NoQuery_test( app ):
  RunTest( app, {
    'description': 'semantic completion works for builtin types (no query)',
    'request': {
      'filetype'  : 'java',
      'filepath'  : ProjectPath( 'TestFactory.java' ),
      'line_num'  : 27,
      'column_num': 12,
    },
    'expect': {
      'response': requests.codes.ok,
      'data': has_entries( {
        'completions': contains_inanyorder(
          *WithObjectMethods(
            CompletionEntryMatcher( 'test', 'TestFactory.Bar', {
              'kind': 'Field'
            } ),
            CompletionEntryMatcher( 'testString', 'TestFactory.Bar', {
              'kind': 'Field'
            } )
          )
        ),
        'errors': empty(),
      } )
    },
  } )


@SharedYcmd
def GetCompletions_WithQuery_test( app ):
  RunTest( app, {
    'description': 'semantic completion works for builtin types (with query)',
    'request': {
      'filetype'  : 'java',
      'filepath'  : ProjectPath( 'TestFactory.java' ),
      'line_num'  : 27,
      'column_num': 15,
    },
    'expect': {
      'response': requests.codes.ok,
      'data': has_entries( {
        'completions': contains_inanyorder(
            CompletionEntryMatcher( 'test', 'TestFactory.Bar', {
              'kind': 'Field'
            } ),
            CompletionEntryMatcher( 'testString', 'TestFactory.Bar', {
              'kind': 'Field'
            } )
        ),
        'errors': empty(),
      } )
    },
  } )


@SharedYcmd
def GetCompletions_Package_test( app ):
  RunTest( app, {
    'description': 'completion works for package statements',
    'request': {
      'filetype'  : 'java',
      'filepath'  : ProjectPath( 'wobble', 'Wibble.java' ),
      'line_num'  : 1,
      'column_num': 18,
    },
    'expect': {
      'response': requests.codes.ok,
      'data': has_entries( {
        'completion_start_column': 9,
        'completions': contains(
          CompletionEntryMatcher( 'com.test.wobble', None, {
            'kind': 'Module'
          } ),
        ),
        'errors': empty(),
      } )
    },
  } )


@SharedYcmd
def GetCompletions_Import_Class_test( app ):
  RunTest( app, {
    'description': 'completion works for import statements with a single class',
    'request': {
      'filetype'  : 'java',
      'filepath'  : ProjectPath( 'TestLauncher.java' ),
      'line_num'  : 4,
      'column_num': 34,
    },
    'expect': {
      'response': requests.codes.ok,
      'data': has_entries( {
        'completion_start_column': 34,
        'completions': contains(
          CompletionEntryMatcher( 'Tset;', None, {
            'menu_text': 'Tset - com.youcompleteme.testing',
            'kind': 'Class',
          } )
        ),
        'errors': empty(),
      } )
    },
  } )


@SharedYcmd
def GetCompletions_Import_Classes_test( app ):
  filepath = ProjectPath( 'TestLauncher.java' )
  RunTest( app, {
    'description': 'completion works for imports with multiple classes',
    'request': {
      'filetype'  : 'java',
      'filepath'  : filepath,
      'line_num'  : 3,
      'column_num': 52,
    },
    'expect': {
      'response': requests.codes.ok,
      'data': has_entries( {
        'completion_start_column': 52,
        'completions': contains(
          CompletionEntryMatcher( 'A;', None, {
            'menu_text': 'A - com.test.wobble',
            'kind': 'Class',
          } ),
          CompletionEntryMatcher( 'A_Very_Long_Class_Here;', None, {
            'menu_text': 'A_Very_Long_Class_Here - com.test.wobble',
            'kind': 'Class',
          } ),
          CompletionEntryMatcher( 'Waggle;', None, {
            'menu_text': 'Waggle - com.test.wobble',
            'kind': 'Class',
          } ),
          CompletionEntryMatcher( 'Wibble;', None, {
            'menu_text': 'Wibble - com.test.wobble',
            'kind': 'Class',
          } ),
        ),
        'errors': empty(),
      } )
    },
  } )


@SharedYcmd
def GetCompletions_Import_ModuleAndClass_test( app ):
  filepath = ProjectPath( 'TestLauncher.java' )
  RunTest( app, {
    'description': 'completion works for imports of classes and modules',
    'request': {
      'filetype'  : 'java',
      'filepath'  : filepath,
      'line_num'  : 3,
      'column_num': 26,
    },
    'expect': {
      'response': requests.codes.ok,
      'data': has_entries( {
        'completion_start_column': 26,
        'completions': contains(
          CompletionEntryMatcher( 'testing.*;', None, {
            'menu_text': 'com.youcompleteme.testing',
            'kind': 'Module',
          } ),
          CompletionEntryMatcher( 'Test;', None, {
            'menu_text': 'Test - com.youcompleteme',
            'kind': 'Class',
          } ),
        ),
        'errors': empty(),
      } )
    },
  } )


@SharedYcmd
def GetCompletions_WithFixIt_test( app ):
  filepath = ProjectPath( 'TestFactory.java' )
  RunTest( app, {
    'description': 'semantic completion with when additional textEdit',
    'request': {
      'filetype'  : 'java',
      'filepath'  : filepath,
      'line_num'  : 19,
      'column_num': 25,
    },
    'expect': {
      'response': requests.codes.ok,
      'data': has_entries( {
        'completion_start_column': 22,
        'completions': contains_inanyorder(
          CompletionEntryMatcher( 'CUTHBERT', 'com.test.wobble.Wibble',
          {
            'kind': 'Field',
            'extra_data': has_entries( {
              'fixits': contains( has_entries( {
                'chunks': contains(
                  # For some reason, jdtls feels it's OK to replace the text
                  # before the cursor. Perhaps it does this to canonicalise the
                  # path ?
                  ChunkMatcher( 'Wibble',
                                LocationMatcher( filepath, 19, 15 ),
                                LocationMatcher( filepath, 19, 21 ) ),
                  # When doing an import, eclipse likes to add two newlines
                  # after the package. I suppose this is config in real eclipse,
                  # but there's no mechanism to configure this in jdtl afaik.
                  ChunkMatcher( '\n\n',
                                LocationMatcher( filepath, 1, 18 ),
                                LocationMatcher( filepath, 1, 18 ) ),
                  # OK, so it inserts the import
                  ChunkMatcher( 'import com.test.wobble.Wibble;',
                                LocationMatcher( filepath, 1, 18 ),
                                LocationMatcher( filepath, 1, 18 ) ),
                  # More newlines. Who doesn't like newlines?!
                  ChunkMatcher( '\n\n',
                                LocationMatcher( filepath, 1, 18 ),
                                LocationMatcher( filepath, 1, 18 ) ),
                  # For reasons known only to the eclipse JDT developers, it
                  # seems to want to delete the lines after the package first.
                  ChunkMatcher( '',
                                LocationMatcher( filepath, 1, 18 ),
                                LocationMatcher( filepath, 3, 1 ) ),
                ),
              } ) ),
            } ),
          } ),
        ),
        'errors': empty(),
      } )
    },
  } )


@SharedYcmd
def GetCompletions_RejectMultiLineInsertion_test( app ):
  filepath = ProjectPath( 'TestLauncher.java' )
  RunTest( app, {
    'description': 'completion item discarded when not valid',
    'request': {
      'filetype'      : 'java',
      'filepath'      : filepath,
      'line_num'      : 28,
      'column_num'    : 16,
      'force_semantic': True
    },
    'expect': {
      'response': requests.codes.ok,
      'data': has_entries( {
        'completion_start_column': 16,
        'completions': contains(
          CompletionEntryMatcher( 'TestLauncher', 'com.test.TestLauncher', {
            'kind': 'Constructor'
          } )
          # Note: There would be a suggestion here for the _real_ thing we want,
          # which is a TestLauncher.Launchable, but this would generate the code
          # for an anonymous inner class via a completion TextEdit (not
          # AdditionalTextEdit) which we don't support.
        ),
        'errors': empty(),
      } )
    },
  } )


@SharedYcmd
def GetCompletions_UnicodeIdentifier_test( app ):
  filepath = PathToTestFile( DEFAULT_PROJECT_DIR,
                             'src',
                             'com',
                             'youcompleteme',
                             'Test.java' )
  RunTest( app, {
    'description': 'Completion works for unicode identifier',
    'request': {
      'filetype'      : 'java',
      'filepath'      : filepath,
      'line_num'      : 16,
      'column_num'    : 35,
      'force_semantic': True
    },
    'expect': {
      'response': requests.codes.ok,
      'data': has_entries( {
        'completion_start_column': 35,
        'completions': contains_inanyorder( *WithObjectMethods(
          CompletionEntryMatcher( 'a_test', 'Test.TéstClass', {
            'kind': 'Field',
            'detailed_info': 'a_test : int\n\n',
          } ),
          CompletionEntryMatcher( 'testywesty', 'Test.TéstClass', {
            'kind': 'Field',
          } ),
        ) ),
        'errors': empty(),
      } )
    },
  } )


@SharedYcmd
def GetCompletions_ResolveFailed_test( app ):
  filepath = PathToTestFile( DEFAULT_PROJECT_DIR,
                             'src',
                             'com',
                             'youcompleteme',
                             'Test.java' )

  from ycmd.completers.language_server import language_server_protocol as lsapi

  def BrokenResolveCompletion( request_id, completion ):
    return lsapi.BuildRequest( request_id, 'completionItem/FAIL', completion )

  with patch( 'ycmd.completers.language_server.language_server_protocol.'
              'ResolveCompletion',
              side_effect = BrokenResolveCompletion ):
    RunTest( app, {
      'description': 'Completion works for unicode identifier',
      'request': {
        'filetype'      : 'java',
        'filepath'      : filepath,
        'line_num'      : 16,
        'column_num'    : 35,
        'force_semantic': True
      },
      'expect': {
        'response': requests.codes.ok,
        'data': has_entries( {
          'completion_start_column': 35,
          'completions': contains_inanyorder( *WithObjectMethods(
            CompletionEntryMatcher( 'a_test', 'Test.TéstClass', {
              'kind': 'Field',
              'detailed_info': 'a_test : int\n\n',
            } ),
            CompletionEntryMatcher( 'testywesty', 'Test.TéstClass', {
              'kind': 'Field',
            } ),
          ) ),
          'errors': empty(),
        } )
      },
    } )


@SharedYcmd
def Subcommands_ServerNotReady_test( app ):
  filepath = PathToTestFile( 'simple_eclipse_project',
                             'src',
                             'com',
                             'test',
                             'AbstractTestWidget.java' )

  completer = handlers._server_state.GetFiletypeCompleter( [ 'java' ] )

  with patch.object( completer, 'ServerIsReady', return_value = False ):
    RunTest( app, {
      'description': 'Completion works for unicode identifier',
      'request': {
        'filetype'      : 'java',
        'filepath'      : filepath,
        'line_num'      : 16,
        'column_num'    : 35,
        'force_semantic': True
      },
      'expect': {
        'response': requests.codes.ok,
        'data': has_entries( {
          'errors': empty(),
          'completions': empty(),
          'completion_start_column': 6
        } ),
      }
    } )


@SharedYcmd
def GetCompletions_MoreThan100NoResolve_test( app ):
  RunTest( app, {
    'description': 'We guess the right start codepoint without resolving',
    'request': {
      'filetype'  : 'java',
      'filepath'  : ProjectPath( 'TestLauncher.java' ),
      'line_num'  : 4,
      'column_num': 15,
    },
    'expect': {
      'response': requests.codes.ok,
      'data': has_entries( {
        'completions': has_item(
          CompletionEntryMatcher( 'com.youcompleteme', None, {
            'kind': 'Module'
          } ),
        ),
        'completion_start_column': 8,
        'errors': empty(),
      } )
    },
  } )
