// Copyright (C) 2011, 2012, 2013 Google Inc.
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

#include "PythonSupport.h"
#include "Result.h"
#include "Candidate.h"
#include "CandidateRepository.h"
#include "ReleaseGil.h"
#include "Utils.h"

#include <algorithm>
#include <vector>
#include <locale>
#include <utility>

using std::any_of;
using boost::python::len;
using boost::python::str;
using boost::python::extract;
using boost::python::object;
typedef boost::python::list pylist;

namespace YouCompleteMe {

namespace {

std::vector< const Candidate * > CandidatesFromObjectList(
  const pylist &candidates,
  const std::string &candidate_property ) {
  int num_candidates = len( candidates );
  std::vector< std::string > candidate_strings;
  candidate_strings.reserve( num_candidates );

  for ( int i = 0; i < num_candidates; ++i ) {
    if ( candidate_property.empty() ) {
      candidate_strings.push_back( GetUtf8String( candidates[ i ] ) );
    } else {
      object holder = extract< object >( candidates[ i ] );
      candidate_strings.push_back( GetUtf8String(
                                     holder[ candidate_property.c_str() ] ) );
    }
  }

  return CandidateRepository::Instance().GetCandidatesForStrings(
           candidate_strings );
}

} // unnamed namespace


boost::python::list FilterAndSortCandidates(
  const boost::python::list &candidates,
  const std::string &candidate_property,
  const std::string &query ) {
  pylist filtered_candidates;

  if ( query.empty() )
    return candidates;

  if ( !IsPrintable( query ) )
    return boost::python::list();

  int num_candidates = len( candidates );
  std::vector< const Candidate * > repository_candidates =
    CandidatesFromObjectList( candidates, candidate_property );

  std::vector< ResultAnd< int > > result_and_objects;
  {
    ReleaseGil unlock;
    Bitset query_bitset = LetterBitsetFromString( query );
    bool query_has_uppercase_letters = any_of( query.cbegin(),
                                               query.cend(),
                                               IsUpper );

    for ( int i = 0; i < num_candidates; ++i ) {
      const Candidate *candidate = repository_candidates[ i ];

      if ( !candidate->MatchesQueryBitset( query_bitset ) )
        continue;

      Result result = candidate->QueryMatchResult( query,
                                                   query_has_uppercase_letters );

      if ( result.IsSubsequence() ) {
        ResultAnd< int > result_and_object( result, i );
        result_and_objects.push_back( std::move( result_and_object ) );
      }
    }

    std::sort( result_and_objects.begin(), result_and_objects.end() );
  }

  for ( const ResultAnd< int > &result_and_object : result_and_objects ) {
    filtered_candidates.append( candidates[ result_and_object.extra_object_ ] );
  }

  return filtered_candidates;
}


std::string GetUtf8String( const boost::python::object &string_or_unicode ) {
  extract< std::string > to_string( string_or_unicode );

  if ( to_string.check() )
    return to_string();

  return extract< std::string >( str( string_or_unicode ).encode( "utf8" ) );
}

} // namespace YouCompleteMe
