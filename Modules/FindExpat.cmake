# - Try to find the Expat library
# Once done this will define
#
#  EXPAT_FOUND - System has Expat
#  EXPAT_INCLUDE_DIR - The Expat include directory
#  EXPAT_LIBRARIES - The libraries needed to use Expat
#  EXPAT_DEFINITIONS - Compiler switches required for using Expat
#  EXPAT_VERSION_STRING - the version of Expat found (since CMake 2.8.8)

#=============================================================================
# Copyright 2006-2009 Kitware, Inc.
# Copyright 2006 Alexander Neundorf <neundorf@kde.org>
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of CMake, substitute the full
#  License text for the above reference.)

# use pkg-config to get the directories and then use these values
# in the find_path() and find_library() calls
find_package(PkgConfig QUIET)
PKG_CHECK_MODULES(PC_EXPAT QUIET expat)
set(EXPAT_DEFINITIONS ${PC_EXPAT_CFLAGS_OTHER})

find_path(EXPAT_INCLUDE_DIR NAMES expat.h
   HINTS
   ${PC_EXPAT_INCLUDEDIR}
   ${PC_EXPAT_INCLUDE_DIRS}
   )

find_library(EXPAT_LIBRARIES NAMES expat libexpat
   HINTS
   ${PC_EXPAT_LIBDIR}
   ${PC_EXPAT_LIBRARY_DIRS}
   )

if(PC_EXPAT_VERSION)
    set(EXPAT_VERSION_STRING ${PC_EXPAT_VERSION})
elseif(EXPAT_INCLUDE_DIR AND EXISTS "${EXPAT_INCLUDE_DIR}/expat.h")
    file(STRINGS "${EXPAT_INCLUDE_DIR}/expat.h" expat_version_str
         REGEX "^#define[\t ]+XML_MAJOR_VERSION[\t ]+\".*\"")

    string(REGEX REPLACE "^#define[\t ]+XML_MAJOR_VERSION[\t ]+\"([^\"]*)\".*" "\\1"
           EXPAT_VERSION_STRING "${expat_version_str}")
    unset(expat_version_str)
endif()

# handle the QUIETLY and REQUIRED arguments and set EXPAT_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Expat
                                  REQUIRED_VARS EXPAT_LIBRARIES EXPAT_INCLUDE_DIR
                                  VERSION_VAR EXPAT_VERSION_STRING)

mark_as_advanced(EXPAT_INCLUDE_DIR EXPAT_LIBRARIES)
