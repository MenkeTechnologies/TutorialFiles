#     Copyright 2015 Cedraro Andrea <a.cedraro@gmail.com>
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
#    limitations under the License.

from jedihttp import utils
utils.AddVendorFolderToSysPath()

import logging
import json
import os
import sys
from base64 import b64decode
from argparse import ArgumentParser
from waitress import serve
from jedihttp import handlers
from jedihttp.hmac_plugin import HmacPlugin


def ParseArgs():
  parser = ArgumentParser()
  parser.add_argument( '--host', type = str, default = '127.0.0.1',
                       help = 'server host' )
  parser.add_argument( '--port', type = int, default = 0,
                       help = 'server port' )
  parser.add_argument( '--log', type = str, default = 'info',
                       choices = [ 'debug', 'info', 'warning',
                                   'error', 'critical' ],
                       help = 'log level' )
  parser.add_argument( '--hmac-file-secret', type = str,
                       help = 'file containing hmac secret' )
  return parser.parse_args()


def SetUpLogging( log_level ):
  numeric_level = getattr( logging, log_level.upper(), None )
  if not isinstance( numeric_level, int ):
    raise ValueError( 'Invalid log level: {0}'.format( log_level ) )

  # Has to be called before any call to logging.getLogger().
  logging.basicConfig( format = '%(asctime)s - %(levelname)s - %(message)s',
                       level = numeric_level )


def GetSecretFromTempFile( tfile ):
  key = 'hmac_secret'
  with open( tfile ) as hmac_file:
    try:
      data = json.load( hmac_file )
      if key not in data:
        sys.exit( "A json file with a key named 'secret' was expected for "
                  "the secret exchange, but wasn't found" )
      hmac_secret = data[ key ]
    except ValueError:
      sys.exit( "A JSON was expected for the secret exchange" )
  os.remove( tfile )
  return hmac_secret


def Main():
  args = ParseArgs()

  SetUpLogging( args.log )

  if args.hmac_file_secret:
    hmac_secret = GetSecretFromTempFile( args.hmac_file_secret )
    handlers.app.config[ 'jedihttp.hmac_secret' ] = b64decode( hmac_secret )
    handlers.app.install( HmacPlugin() )

  serve( handlers.app,
         host = args.host,
         port = args.port )

if __name__ == "__main__":
  Main()
