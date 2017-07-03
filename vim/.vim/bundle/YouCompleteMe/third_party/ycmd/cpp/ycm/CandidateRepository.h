// Copyright (C) 2011, 2012 Google Inc.
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

#ifndef CANDIDATEREPOSITORY_H_K9OVCMHG
#define CANDIDATEREPOSITORY_H_K9OVCMHG

#include "DLLDefines.h"

#include <vector>
#include <string>
#include <unordered_map>
#include <mutex>

namespace YouCompleteMe {

class Candidate;

typedef std::unordered_map< std::string, const Candidate * >
CandidateHolder;


// This singleton stores already built Candidate objects for candidate strings
// that were already seen. If Candidates are requested for previously unseen
// strings, new Candidate objects are built.
//
// This is shared by the identifier completer and the clang completer so that
// work is not repeated.
//
// This class is thread-safe.
class CandidateRepository {
public:
  YCM_DLL_EXPORT static CandidateRepository &Instance();
  // Make class noncopyable
  CandidateRepository( const CandidateRepository& ) = delete;
  CandidateRepository& operator=( const CandidateRepository& ) = delete;

  int NumStoredCandidates();

  YCM_DLL_EXPORT std::vector< const Candidate * > GetCandidatesForStrings(
    const std::vector< std::string > &strings );

  // This should only be used to isolate tests and benchmarks.
  YCM_DLL_EXPORT void ClearCandidates();

private:
  CandidateRepository() {};
  ~CandidateRepository();

  const std::string &ValidatedCandidateText( const std::string &text );

  std::mutex holder_mutex_;

  static std::mutex singleton_mutex_;
  static CandidateRepository *instance_;

  const std::string empty_;

  // This data structure owns all the Candidate pointers
  CandidateHolder candidate_holder_;
};

} // namespace YouCompleteMe

#endif /* end of include guard: CANDIDATEREPOSITORY_H_K9OVCMHG */
