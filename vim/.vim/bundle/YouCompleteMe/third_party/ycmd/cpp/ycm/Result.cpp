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

#include "Result.h"
#include "Utils.h"

namespace YouCompleteMe {

namespace {

int LongestCommonSubsequenceLength( const std::string &first,
                                    const std::string &second ) {
  const std::string &longer  = first.size() > second.size() ? first  : second;
  const std::string &shorter = first.size() > second.size() ? second : first;

  int longer_len  = longer.size();
  int shorter_len = shorter.size();

  std::vector<int> previous( shorter_len + 1, 0 );
  std::vector<int> current(  shorter_len + 1, 0 );

  for ( int i = 0; i < longer_len; ++i ) {
    for ( int j = 0; j < shorter_len; ++j ) {
      if ( Uppercase( longer[ i ] ) == Uppercase( shorter[ j ] ) )
        current[ j + 1 ] = previous[ j ] + 1;
      else
        current[ j + 1 ] = std::max( current[ j ], previous[ j + 1 ] );
    }

    for ( int j = 0; j < shorter_len; ++j ) {
      previous[ j + 1 ] = current[ j + 1 ];
    }
  }

  return current[ shorter_len ];
}


int NumWordBoundaryCharMatches( const std::string &query,
                                const std::string &word_boundary_chars ) {
  return LongestCommonSubsequenceLength( query, word_boundary_chars );
}

} // unnamed namespace

Result::Result( bool is_subsequence )
  :
  query_is_empty_( true ),
  is_subsequence_( is_subsequence ),
  first_char_same_in_query_and_text_( false ),
  ratio_of_word_boundary_chars_in_query_( 0 ),
  word_boundary_char_utilization_( 0 ),
  query_is_candidate_prefix_( false ),
  text_is_lowercase_( false ),
  char_match_index_sum_( 0 ),
  text_( NULL ),
  case_swapped_text_( NULL ) {
}


Result::Result( bool is_subsequence,
                const std::string *text,
                const std::string *case_swapped_text,
                bool text_is_lowercase,
                int char_match_index_sum,
                const std::string &word_boundary_chars,
                const std::string &query )
  :
  query_is_empty_( true ),
  is_subsequence_( is_subsequence ),
  first_char_same_in_query_and_text_( false ),
  ratio_of_word_boundary_chars_in_query_( 0 ),
  word_boundary_char_utilization_( 0 ),
  query_is_candidate_prefix_( false ),
  text_is_lowercase_( text_is_lowercase ),
  char_match_index_sum_( char_match_index_sum ),
  text_( text ),
  case_swapped_text_( case_swapped_text ) {
  if ( is_subsequence )
    SetResultFeaturesFromQuery( word_boundary_chars, query );
}


bool Result::operator< ( const Result &other ) const {
  // Yes, this is ugly but it also needs to be fast.  Since this is called a
  // bazillion times, we have to make sure only the required comparisons are
  // made, and no more.

  if ( !query_is_empty_ ) {
    if ( first_char_same_in_query_and_text_ !=
         other.first_char_same_in_query_and_text_ ) {
      return first_char_same_in_query_and_text_;
    }

    bool equal_wb_ratios = AlmostEqual(
                             ratio_of_word_boundary_chars_in_query_,
                             other.ratio_of_word_boundary_chars_in_query_ );

    bool equal_wb_utilization = AlmostEqual(
                                  word_boundary_char_utilization_,
                                  other.word_boundary_char_utilization_ );

    if ( AlmostEqual( ratio_of_word_boundary_chars_in_query_, 1.0 ) ||
         AlmostEqual( other.ratio_of_word_boundary_chars_in_query_, 1.0 ) ) {
      if ( !equal_wb_ratios ) {
        return ratio_of_word_boundary_chars_in_query_ >
               other.ratio_of_word_boundary_chars_in_query_;
      }

      else {
        if ( !equal_wb_utilization )
          return word_boundary_char_utilization_ >
                 other.word_boundary_char_utilization_;
      }
    }

    if ( query_is_candidate_prefix_ != other.query_is_candidate_prefix_ )
      return query_is_candidate_prefix_;

    if ( !equal_wb_ratios ) {
      return ratio_of_word_boundary_chars_in_query_ >
             other.ratio_of_word_boundary_chars_in_query_;
    }

    else {
      if ( !equal_wb_utilization )
        return word_boundary_char_utilization_ >
               other.word_boundary_char_utilization_;
    }

    if ( char_match_index_sum_ != other.char_match_index_sum_ )
      return char_match_index_sum_ < other.char_match_index_sum_;

    if ( text_->length() != other.text_->length() )
      return text_->length() < other.text_->length();

    if ( text_is_lowercase_ != other.text_is_lowercase_ )
      return text_is_lowercase_;
  }

  // Lexicographic comparison, but we prioritize lowercase letters over
  // uppercase ones. So "foo" < "Foo".
  return *case_swapped_text_ < *other.case_swapped_text_;
}


void Result::SetResultFeaturesFromQuery(
  const std::string &word_boundary_chars,
  const std::string &query ) {
  query_is_empty_ = query.empty();

  if ( query.empty() || text_->empty() )
    return;

  first_char_same_in_query_and_text_ =
    Uppercase( query[ 0 ] ) == Uppercase( ( *text_ )[ 0 ] );
  int num_wb_matches = NumWordBoundaryCharMatches( query,
                                                   word_boundary_chars );
  ratio_of_word_boundary_chars_in_query_ =
    num_wb_matches / static_cast< double >( query.length() );
  word_boundary_char_utilization_ =
    num_wb_matches / static_cast< double >( word_boundary_chars.length() );
  query_is_candidate_prefix_ = QueryIsPrefix( *text_, query );

}


bool Result::QueryIsPrefix( const std::string &text,
                            const std::string &query ) {
  for ( size_t i = 0; i < query.length(); ++i )
    if ( Uppercase( query[ i ] ) != Uppercase( text[ i ] ) )
      return false;

  return true;
}

} // namespace YouCompleteMe
