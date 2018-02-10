// Copyright (C) 2011-2018 ycmd contributors
//
// This file is part of ycmd.
//
// ycmd is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// ycmd is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with ycmd.  If not, see <http://www.gnu.org/licenses/>.

#ifndef TESTUTILS_H_G4RKMGUD
#define TESTUTILS_H_G4RKMGUD

#include <vector>
#include <string>

#include <boost/filesystem.hpp>

namespace YouCompleteMe {

boost::filesystem::path PathToTestFile( const std::string &filepath );

} // namespace YouCompleteMe

#endif /* end of include guard: TESTUTILS_H_G4RKMGUD */

