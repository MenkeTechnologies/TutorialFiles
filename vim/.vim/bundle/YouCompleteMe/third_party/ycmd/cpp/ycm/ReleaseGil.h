// Copyright (C) 2013 Google Inc.
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

#ifndef RELEASEGIL_H_RDIEBSQ1
#define RELEASEGIL_H_RDIEBSQ1

#include <boost/python.hpp>

namespace YouCompleteMe {

class ReleaseGil {
public:
  ReleaseGil() {
    thread_state_ = PyEval_SaveThread();
  }

  ~ReleaseGil() {
    PyEval_RestoreThread( thread_state_ );
  }

private:
  PyThreadState *thread_state_;
};

} // namespace YouCompleteMe

#endif /* end of include guard: RELEASEGIL_H_RDIEBSQ1 */

