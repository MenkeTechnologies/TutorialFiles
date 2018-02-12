# Copyright (C) 2016-2018 YouCompleteMe contributors
#
# This file is part of YouCompleteMe.
#
# YouCompleteMe is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# YouCompleteMe is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with YouCompleteMe.  If not, see <http://www.gnu.org/licenses/>.

from __future__ import unicode_literals
from __future__ import print_function
from __future__ import division
from __future__ import absolute_import
# Not installing aliases from python-future; it's unreliable and slow.
from builtins import *  # noqa

from ycm.tests.test_utils import MockVimModule, MockVimBuffers, VimBuffer
MockVimModule()

from hamcrest import assert_that, contains, has_entries
from mock import patch

from ycm.tests import YouCompleteMeInstance


@YouCompleteMeInstance( { 'extra_conf_vim_data': [ 'tempname()' ] } )
def SendCommandRequest_ExtraConfVimData_Works_test( ycm ):
  current_buffer = VimBuffer( 'buffer' )
  with MockVimBuffers( [ current_buffer ], current_buffer ):
    with patch( 'ycm.youcompleteme.SendCommandRequest' ) as send_request:
      ycm.SendCommandRequest( [ 'GoTo' ], 'python', False, 1, 1 )
      assert_that(
        # Positional arguments passed to SendCommandRequest.
        send_request.call_args[ 0 ],
        contains(
          contains( 'GoTo' ),
          'python',
          has_entries( {
            'options': has_entries( {
              'tab_size': 2,
              'insert_spaces': True,
            } ),
            'extra_conf_data': has_entries( {
              'tempname()': '_TEMP_FILE_'
            } ),
          } )
        )
      )


@YouCompleteMeInstance( { 'extra_conf_vim_data': [ 'undefined_value' ] } )
def SendCommandRequest_ExtraConfData_UndefinedValue_test( ycm ):
  current_buffer = VimBuffer( 'buffer' )
  with MockVimBuffers( [ current_buffer ], current_buffer ):
    with patch( 'ycm.youcompleteme.SendCommandRequest' ) as send_request:
      ycm.SendCommandRequest( [ 'GoTo' ], 'python', False, 1, 1 )
      assert_that(
        # Positional arguments passed to SendCommandRequest.
        send_request.call_args[ 0 ],
        contains(
          contains( 'GoTo' ),
          'python',
          has_entries( {
            'options': has_entries( {
              'tab_size': 2,
              'insert_spaces': True,
            } )
          } )
        )
      )


@YouCompleteMeInstance()
def SendCommandRequest_BuildRange_NoVisualMarks_test( ycm, *args ):
  current_buffer = VimBuffer( 'buffer', contents = [ 'first line',
                                                     'second line' ] )
  with MockVimBuffers( [ current_buffer ], current_buffer ):
    with patch( 'ycm.youcompleteme.SendCommandRequest' ) as send_request:
      ycm.SendCommandRequest( [ 'GoTo' ], 'python', True, 1, 2 )
      send_request.assert_called_once_with(
        [ 'GoTo' ],
        'python',
        {
          'options': {
            'tab_size': 2,
            'insert_spaces': True
          },
          'range': {
            'start': {
              'line_num': 1,
              'column_num': 1
            },
            'end': {
              'line_num': 2,
              'column_num': 12
            }
          }
        }
      )


@YouCompleteMeInstance()
def SendCommandRequest_BuildRange_VisualMarks_test( ycm, *args ):
  current_buffer = VimBuffer( 'buffer',
                              contents = [ 'first line',
                                           'second line' ],
                              visual_start = [ 1, 4 ],
                              visual_end = [ 2, 8 ] )
  with MockVimBuffers( [ current_buffer ], current_buffer ):
    with patch( 'ycm.youcompleteme.SendCommandRequest' ) as send_request:
      ycm.SendCommandRequest( [ 'GoTo' ], 'python', True, 1, 2 )
      send_request.assert_called_once_with(
        [ 'GoTo' ],
        'python',
        {
          'options': {
            'tab_size': 2,
            'insert_spaces': True
          },
          'range': {
            'start': {
              'line_num': 1,
              'column_num': 5
            },
            'end': {
              'line_num': 2,
              'column_num': 9
            }
          }
        }
      )
