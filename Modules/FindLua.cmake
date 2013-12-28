# - Try to find the Lua library
# Once done this will define
#
#  LUA_FOUND - System has Lua
#  LUA_INCLUDE_DIR - The Lua include directory
#  LUA_LIBRARIES - The libraries needed to use Lua
#  LUA_DEFINITIONS - Compiler switches required for using Lua
#  LUA_EXECUTABLE - The Lua command line shell
#  LUA_VERSION_STRING - the version of Lua found (since CMake 2.8.8)

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
PKG_CHECK_MODULES(PC_LUA QUIET Lua)
set(LUA_DEFINITIONS ${PC_LUA_CFLAGS_OTHER})

find_path(LUA_INCLUDE_DIR NAMES lua.h
   HINTS
   ${PC_LUA_INCLUDEDIR}
   ${PC_LUA_INCLUDE_DIRS}
   )

find_library(LUA_LIBRARIES NAMES lua lua5.2 lua52 lua5.1 lua51 lua5.0 lua50
   HINTS
   ${PC_LUA_LIBDIR}
   ${PC_LUA_LIBRARY_DIRS}
   )
find_program(LUA_EXECUTABLE lua)

if(PC_LUA_VERSION)
    set(LUA_VERSION_STRING ${PC_LUA_VERSION})
elseif(LUA_INCLUDE_DIR AND EXISTS "${LUA_INCLUDE_DIR}/lua.h")
    file(STRINGS "${LUA_INCLUDE_DIR}/Lua.h" lua_version_str
         REGEX "^#define[\t ]+LUA_RELEASE[\t ]+\".*\"")

    string(REGEX REPLACE "^#define[\t ]+LUA_RELEASE[\t ]+\"Lua ([^\"]*)\".*" "\\1"
           LUA_VERSION_STRING "${lua_version_str}")
    unset(lua_version_str)
endif()

# handle the QUIETLY and REQUIRED arguments and set LUA_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Lua
                                  REQUIRED_VARS LUA_LIBRARIES LUA_INCLUDE_DIR
                                  VERSION_VAR LUA_VERSION_STRING)

mark_as_advanced(LUA_INCLUDE_DIR LUA_LIBRARIES LUA_EXECUTABLE)
