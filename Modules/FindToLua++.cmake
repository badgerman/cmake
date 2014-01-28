# - Try to find the ToLua library
# Once done this will define
#
#  TOLUA++_FOUND - System has ToLua
#  TOLUA++_INCLUDE_DIR - The ToLua include directory
#  TOLUA++_LIBRARIES - The libraries needed to use ToLua
#  TOLUA++_DEFINITIONS - Compiler switches required for using ToLua
#  TOLUA++_EXECUTABLE - The ToLua command line shell
#  TOLUA++_VERSION_STRING - the version of ToLua found (since CMake 2.8.8)

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
PKG_CHECK_MODULES(PC_TOLUA QUIET ToLua)
set(TOLUA++_DEFINITIONS ${PC_TOLUA++_CFLAGS_OTHER})

find_path(TOLUA++_INCLUDE_DIR NAMES tolua++.h
   HINTS
   ${PC_TOLUA++_INCLUDEDIR}
   ${PC_TOLUA++_INCLUDE_DIRS}
   )
MESSAGE(STATUS "${TOLUA++_INCLUDE_DIR}")
find_library(TOLUA++_LIBRARIES NAMES tolua++
   HINTS
   ${PC_TOLUA++_LIBDIR}
   ${PC_TOLUA++_LIBRARY_DIRS}
   )
find_program(TOLUA++_EXECUTABLE tolua++)

if(PC_TOLUA++_VERSION)
    set(TOLUA++_VERSION_STRING ${PC_TOLUA++_VERSION})
elseif(TOLUA++_INCLUDE_DIR AND EXISTS "${TOLUA++_INCLUDE_DIR}/tolua++.h")
    file(STRINGS "${TOLUA++_INCLUDE_DIR}/tolua++.h" tolua_version_str
         REGEX "^#define[\t ]+TOLUA_VERSION[\t ]+\".*\"")

    string(REGEX REPLACE "^#define[\t ]+TOLUA_VERSION[\t ]+\"tolua[^0-9]*([^\"]*)\".*" "\\1"
           TOLUA++_VERSION_STRING "${tolua_version_str}")
    unset(tolua_version_str)
endif()

# handle the QUIETLY and REQUIRED arguments and set TOLUA++_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(ToLua++
                                  REQUIRED_VARS TOLUA++_LIBRARIES TOLUA++_INCLUDE_DIR TOLUA++_EXECUTABLE
                                  VERSION_VAR TOLUA++_VERSION_STRING)

mark_as_advanced(TOLUA++_INCLUDE_DIR TOLUA++_LIBRARIES TOLUA++_EXECUTABLE)
