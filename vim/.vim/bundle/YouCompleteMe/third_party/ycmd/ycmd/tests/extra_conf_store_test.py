# Copyright (C) 2016 ycmd contributors
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

import inspect
from mock import patch

from hamcrest import ( assert_that, calling, equal_to, has_length, none, raises,
                       same_instance )
from ycmd import extra_conf_store
from ycmd.responses import UnknownExtraConf
from ycmd.tests import IsolatedYcmd, PathToTestFile
from ycmd.tests.test_utils import TemporarySymlink, UnixOnly


GLOBAL_EXTRA_CONF = PathToTestFile( 'extra_conf', 'global_extra_conf.py' )
ERRONEOUS_EXTRA_CONF = PathToTestFile( 'extra_conf', 'erroneous_extra_conf.py' )
NO_EXTRA_CONF = PathToTestFile( 'extra_conf', 'no_extra_conf.py' )
PROJECT_EXTRA_CONF = PathToTestFile( 'extra_conf', 'project',
                                     '.ycm_extra_conf.py' )


@IsolatedYcmd()
def ExtraConfStore_ModuleForSourceFile_UnknownExtraConf_test( app ):
  filename = PathToTestFile( 'extra_conf', 'project', 'some_file' )
  assert_that(
    calling( extra_conf_store.ModuleForSourceFile ).with_args( filename ),
    raises( UnknownExtraConf, 'Found .*\.ycm_extra_conf\.py\. Load?' )
  )


@IsolatedYcmd( { 'confirm_extra_conf': 0 } )
def ExtraConfStore_ModuleForSourceFile_NoConfirmation_test( app ):
  filename = PathToTestFile( 'extra_conf', 'project', 'some_file' )
  module = extra_conf_store.ModuleForSourceFile( filename )
  assert_that( inspect.ismodule( module ) )
  assert_that( inspect.getfile( module ), equal_to( PROJECT_EXTRA_CONF ) )


@IsolatedYcmd( { 'extra_conf_globlist': [ PROJECT_EXTRA_CONF ] } )
def ExtraConfStore_ModuleForSourceFile_Whitelisted_test( app ):
  filename = PathToTestFile( 'extra_conf', 'project', 'some_file' )
  module = extra_conf_store.ModuleForSourceFile( filename )
  assert_that( inspect.ismodule( module ) )
  assert_that( inspect.getfile( module ), equal_to( PROJECT_EXTRA_CONF ) )


@IsolatedYcmd( { 'extra_conf_globlist': [ '!' + PROJECT_EXTRA_CONF ] } )
def ExtraConfStore_ModuleForSourceFile_Blacklisted_test( app ):
  filename = PathToTestFile( 'extra_conf', 'project', 'some_file' )
  assert_that( extra_conf_store.ModuleForSourceFile( filename ), none() )


@UnixOnly
@IsolatedYcmd( { 'extra_conf_globlist': [
    PathToTestFile( 'extra_conf', 'symlink', '*' ) ] } )
def ExtraConfStore_ModuleForSourceFile_SupportSymlink_test( app ):
  with TemporarySymlink( PathToTestFile( 'extra_conf', 'project' ),
                         PathToTestFile( 'extra_conf', 'symlink' ) ):
    filename = PathToTestFile( 'extra_conf', 'project', 'some_file' )
    module = extra_conf_store.ModuleForSourceFile( filename )
    assert_that( inspect.ismodule( module ) )
    assert_that( inspect.getfile( module ), equal_to( PROJECT_EXTRA_CONF ) )


@IsolatedYcmd( { 'global_ycm_extra_conf': GLOBAL_EXTRA_CONF } )
def ExtraConfStore_ModuleForSourceFile_GlobalExtraConf_test( app ):
  filename = PathToTestFile( 'extra_conf', 'some_file' )
  module = extra_conf_store.ModuleForSourceFile( filename )
  assert_that( inspect.ismodule( module ) )
  assert_that( inspect.getfile( module ), equal_to( GLOBAL_EXTRA_CONF ) )


@IsolatedYcmd( { 'global_ycm_extra_conf': NO_EXTRA_CONF } )
@patch( 'ycmd.extra_conf_store._logger', autospec = True )
def ExtraConfStore_CallGlobalExtraConfMethod_NoGlobalExtraConf_test( app,
                                                                     logger ):
  extra_conf_store._CallGlobalExtraConfMethod( 'SomeMethod' )
  assert_that( logger.method_calls, has_length( 1 ) )
  logger.debug.assert_called_with( 'No global extra conf, not calling method '
                                   'SomeMethod' )


@IsolatedYcmd( { 'global_ycm_extra_conf': GLOBAL_EXTRA_CONF } )
@patch( 'ycmd.extra_conf_store._logger', autospec = True )
def CallGlobalExtraConfMethod_NoMethodInGlobalExtraConf_test( app, logger ):
  extra_conf_store._CallGlobalExtraConfMethod( 'MissingMethod' )
  assert_that( logger.method_calls, has_length( 1 ) )
  logger.debug.assert_called_with( 'Global extra conf not loaded or '
                                   'no function MissingMethod' )


@IsolatedYcmd( { 'global_ycm_extra_conf': GLOBAL_EXTRA_CONF } )
@patch( 'ycmd.extra_conf_store._logger', autospec = True )
def CallGlobalExtraConfMethod_NoExceptionFromMethod_test( app, logger ):
  extra_conf_store._CallGlobalExtraConfMethod( 'NoException' )
  assert_that( logger.method_calls, has_length( 1 ) )
  logger.info.assert_called_with( 'Calling global extra conf method '
                                  'NoException on conf file '
                                  '{0}'.format( GLOBAL_EXTRA_CONF ) )


@IsolatedYcmd( { 'global_ycm_extra_conf': GLOBAL_EXTRA_CONF } )
@patch( 'ycmd.extra_conf_store._logger', autospec = True )
def CallGlobalExtraConfMethod_CatchExceptionFromMethod_test( app, logger ):
  extra_conf_store._CallGlobalExtraConfMethod( 'RaiseException' )
  assert_that( logger.method_calls, has_length( 2 ) )
  logger.info.assert_called_with( 'Calling global extra conf method '
                                  'RaiseException on conf file '
                                  '{0}'.format( GLOBAL_EXTRA_CONF ) )
  logger.exception.assert_called_with(
    'Error occurred while calling global extra conf method RaiseException '
    'on conf file {0}'.format( GLOBAL_EXTRA_CONF ) )


@IsolatedYcmd( { 'global_ycm_extra_conf': ERRONEOUS_EXTRA_CONF } )
@patch( 'ycmd.extra_conf_store._logger', autospec = True )
def CallGlobalExtraConfMethod_CatchExceptionFromExtraConf_test( app, logger ):
  extra_conf_store._CallGlobalExtraConfMethod( 'NoException' )
  assert_that( logger.method_calls, has_length( 1 ) )
  logger.exception.assert_called_with( 'Error occurred while '
                                       'loading global extra conf '
                                       '{0}'.format( ERRONEOUS_EXTRA_CONF ) )


@IsolatedYcmd()
def Load_DoNotReloadExtraConf_NoForce_test( app ):
  with patch( 'ycmd.extra_conf_store._ShouldLoad', return_value = True ):
    module = extra_conf_store.Load( PROJECT_EXTRA_CONF )
    assert_that( inspect.ismodule( module ) )
    assert_that( inspect.getfile( module ), equal_to( PROJECT_EXTRA_CONF ) )
    assert_that(
      extra_conf_store.Load( PROJECT_EXTRA_CONF ),
      same_instance( module )
    )


@IsolatedYcmd()
def Load_DoNotReloadExtraConf_ForceEqualsTrue_test( app ):
  with patch( 'ycmd.extra_conf_store._ShouldLoad', return_value = True ):
    module = extra_conf_store.Load( PROJECT_EXTRA_CONF )
    assert_that( inspect.ismodule( module ) )
    assert_that( inspect.getfile( module ), equal_to( PROJECT_EXTRA_CONF ) )
    assert_that(
      extra_conf_store.Load( PROJECT_EXTRA_CONF, force = True ),
      same_instance( module )
    )
