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

/*
 * iostream is included because there's a bug with python
 * earlier than 2.7.12 and 3.5.3 on OSX and FreeBSD.
 * When either no one else is using earlier versions of python
 * or ycmd drops support for those, this include statement can be removed.
 * Needs to be the absolute first header, so that it is imported
 * before anything python related.
 */
#include <iostream>
#include "IdentifierCompleter.h"
#include "PythonSupport.h"
#include "versioning.h"

#ifdef USE_CLANG_COMPLETER
#  include "ClangCompleter.h"
#  include "ClangUtils.h"
#  include "CompletionData.h"
#  include "Diagnostic.h"
#  include "Location.h"
#  include "Range.h"
#  include "UnsavedFile.h"
#  include "CompilationDatabase.h"
#  include "Documentation.h"
#endif // USE_CLANG_COMPLETER

#include <boost/python.hpp>
#include <boost/python/suite/indexing/vector_indexing_suite.hpp>

bool HasClangSupport() {
#ifdef USE_CLANG_COMPLETER
  return true;
#else
  return false;
#endif // USE_CLANG_COMPLETER
}


BOOST_PYTHON_MODULE(ycm_core)
{
  using namespace boost::python;
  using namespace YouCompleteMe;

  // Necessary because of usage of the ReleaseGil class
  PyEval_InitThreads();

  def( "HasClangSupport", HasClangSupport );
  def( "FilterAndSortCandidates", FilterAndSortCandidates );
  def( "YcmCoreVersion", YcmCoreVersion );

  // This is exposed so that we can test it.
  def( "GetUtf8String", GetUtf8String );

  class_< IdentifierCompleter, boost::noncopyable >( "IdentifierCompleter" )
    .def( "AddIdentifiersToDatabase",
          &IdentifierCompleter::AddIdentifiersToDatabase )
    .def( "ClearForFileAndAddIdentifiersToDatabase",
          &IdentifierCompleter::ClearForFileAndAddIdentifiersToDatabase )
    .def( "AddIdentifiersToDatabaseFromTagFiles",
          &IdentifierCompleter::AddIdentifiersToDatabaseFromTagFiles )
    .def( "CandidatesForQueryAndType",
          &IdentifierCompleter::CandidatesForQueryAndType );

  class_< std::vector< std::string >,
      std::shared_ptr< std::vector< std::string > > >( "StringVector" )
    .def( vector_indexing_suite< std::vector< std::string > >() );

#ifdef USE_CLANG_COMPLETER
  def( "ClangVersion", ClangVersion );

  // CAREFUL HERE! For filename and contents we are referring directly to
  // Python-allocated and -managed memory since we are accepting pointers to
  // data members of python objects. We need to ensure that those objects
  // outlive our UnsavedFile objects.
  class_< UnsavedFile >( "UnsavedFile" )
    .add_property( "filename_",
      make_getter( &UnsavedFile::filename_ ),
      make_setter( &UnsavedFile::filename_,
                   return_value_policy< reference_existing_object >() ) )
    .add_property( "contents_",
      make_getter( &UnsavedFile::contents_ ),
      make_setter( &UnsavedFile::contents_,
                   return_value_policy< reference_existing_object >() ) )
    .def_readwrite( "length_", &UnsavedFile::length_ );

  class_< std::vector< UnsavedFile > >( "UnsavedFileVector" )
    .def( vector_indexing_suite< std::vector< UnsavedFile > >() );

  class_< ClangCompleter, boost::noncopyable >( "ClangCompleter" )
    .def( "GetDeclarationLocation", &ClangCompleter::GetDeclarationLocation )
    .def( "GetDefinitionLocation", &ClangCompleter::GetDefinitionLocation )
    .def( "DeleteCachesForFile", &ClangCompleter::DeleteCachesForFile )
    .def( "UpdatingTranslationUnit", &ClangCompleter::UpdatingTranslationUnit )
    .def( "UpdateTranslationUnit", &ClangCompleter::UpdateTranslationUnit )
    .def( "CandidatesForLocationInFile",
          &ClangCompleter::CandidatesForLocationInFile )
    .def( "GetTypeAtLocation", &ClangCompleter::GetTypeAtLocation )
    .def( "GetEnclosingFunctionAtLocation",
          &ClangCompleter::GetEnclosingFunctionAtLocation )
    .def( "GetFixItsForLocationInFile",
          &ClangCompleter::GetFixItsForLocationInFile )
    .def( "GetDocsForLocationInFile",
          &ClangCompleter::GetDocsForLocationInFile );

  enum_< CompletionKind >( "CompletionKind" )
    .value( "STRUCT", STRUCT )
    .value( "CLASS", CLASS )
    .value( "ENUM", ENUM )
    .value( "TYPE", TYPE )
    .value( "MEMBER", MEMBER )
    .value( "FUNCTION", FUNCTION )
    .value( "VARIABLE", VARIABLE )
    .value( "MACRO", MACRO )
    .value( "PARAMETER", PARAMETER )
    .value( "NAMESPACE", NAMESPACE )
    .value( "UNKNOWN", UNKNOWN )
    .export_values();

  class_< CompletionData >( "CompletionData" )
    .def( "TextToInsertInBuffer", &CompletionData::TextToInsertInBuffer )
    .def( "MainCompletionText", &CompletionData::MainCompletionText )
    .def( "ExtraMenuInfo", &CompletionData::ExtraMenuInfo )
    .def( "DetailedInfoForPreviewWindow",
          &CompletionData::DetailedInfoForPreviewWindow )
    .def( "DocString", &CompletionData::DocString )
    .def_readonly( "kind_", &CompletionData::kind_ );

  class_< std::vector< CompletionData >,
      std::shared_ptr< std::vector< CompletionData > > >( "CompletionVector" )
    .def( vector_indexing_suite< std::vector< CompletionData > >() );

  class_< Location >( "Location" )
    .def_readonly( "line_number_", &Location::line_number_ )
    .def_readonly( "column_number_", &Location::column_number_ )
    .def_readonly( "filename_", &Location::filename_ )
    .def( "IsValid", &Location::IsValid );

  class_< Range >( "Range" )
    .def_readonly( "start_", &Range::start_ )
    .def_readonly( "end_", &Range::end_ );

  class_< std::vector< Range > >( "RangeVector" )
    .def( vector_indexing_suite< std::vector< Range > >() );

  class_< FixItChunk >( "FixItChunk" )
    .def_readonly( "replacement_text", &FixItChunk::replacement_text )
    .def_readonly( "range", &FixItChunk::range );

  class_< std::vector< FixItChunk > >( "FixItChunkVector" )
    .def( vector_indexing_suite< std::vector< FixItChunk > >() );

  class_< FixIt >( "FixIt" )
    .def_readonly( "chunks", &FixIt::chunks )
    .def_readonly( "location", &FixIt::location )
    .def_readonly( "text", &FixIt::text );

  class_< std::vector< FixIt > >( "FixItVector" )
    .def( vector_indexing_suite< std::vector< FixIt > >() );

  enum_< DiagnosticKind >( "DiagnosticKind" )
    .value( "ERROR", ERROR )
    .value( "WARNING", WARNING )
    .value( "INFORMATION", INFORMATION )
    .export_values();

  class_< Diagnostic >( "Diagnostic" )
    .def_readonly( "ranges_", &Diagnostic::ranges_ )
    .def_readonly( "location_", &Diagnostic::location_ )
    .def_readonly( "location_extent_", &Diagnostic::location_extent_ )
    .def_readonly( "kind_", &Diagnostic::kind_ )
    .def_readonly( "text_", &Diagnostic::text_ )
    .def_readonly( "long_formatted_text_", &Diagnostic::long_formatted_text_ )
    .def_readonly( "fixits_", &Diagnostic::fixits_ );

  class_< std::vector< Diagnostic > >( "DiagnosticVector" )
    .def( vector_indexing_suite< std::vector< Diagnostic > >() );

  class_< DocumentationData >( "DocumentationData" )
    .def_readonly( "comment_xml", &DocumentationData::comment_xml )
    .def_readonly( "raw_comment", &DocumentationData::raw_comment )
    .def_readonly( "brief_comment", &DocumentationData::brief_comment )
    .def_readonly( "canonical_type", &DocumentationData::canonical_type )
    .def_readonly( "display_name", &DocumentationData::display_name );

  class_< CompilationDatabase, boost::noncopyable >(
      "CompilationDatabase", init< boost::python::object >() )
    .def( "DatabaseSuccessfullyLoaded",
          &CompilationDatabase::DatabaseSuccessfullyLoaded )
    .def( "AlreadyGettingFlags",
          &CompilationDatabase::AlreadyGettingFlags )
    .def( "GetCompilationInfoForFile",
          &CompilationDatabase::GetCompilationInfoForFile )
    .def_readonly( "database_directory",
                   &CompilationDatabase::GetDatabaseDirectory );

  class_< CompilationInfoForFile,
      std::shared_ptr< CompilationInfoForFile > >(
          "CompilationInfoForFile", no_init )
    .def_readonly( "compiler_working_dir_",
                   &CompilationInfoForFile::compiler_working_dir_ )
    .def_readonly( "compiler_flags_",
                   &CompilationInfoForFile::compiler_flags_ );

#endif // USE_CLANG_COMPLETER
}
