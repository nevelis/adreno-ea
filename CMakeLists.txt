cmake_minimum_required (VERSION 2.6)
project (AdrenoEA)

if (NOT FLEX_EXECUTABLE)
  message (STATUS "Looking for flex")
  find_program (FLEX_EXECUTABLE flex)
  if (FLEX_EXECUTABLE)
    message (STATUS "Looking for flex -- ${FLEX_EXECUTABLE}")
  endif ()
endif ()

if (NOT BISON_EXECUTABLE)
  message (STATUS "Looking for bison")
  find_program (BISON_EXECUTABLE bison)
  if (BISON_EXECUTABLE)
    message (STATUS "Looking for bison -- ${BISON_EXECUTABLE}")
  endif ()
endif ()

set_directory_properties (PROPERTIES ADDITIONAL_MAKE_CLEAN_FILES "compiler-parser.output")

# Targets

add_executable (
	compiler
	compiler-parser.tab.cpp
	compiler-tokens.cpp
	compiler-parser.tab.hpp
)

add_custom_command(
	OUTPUT compiler-parser.tab.cpp
	COMMAND ${BISON_EXECUTABLE}
	ARGS -v -d -o ${PROJECT_SOURCE_DIR}/compiler-parser.tab.cpp compiler-parser.y
	DEPENDS compiler-parser.y
)

add_custom_command(
	OUTPUT compiler-parser.tab.hpp
	COMMAND ${CMAKE_COMMAND} -E touch compiler-parser.tab.hpp
	DEPENDS compiler-parser.y
)

add_custom_command(
	OUTPUT compiler-tokens.cpp
	COMMAND ${FLEX_EXECUTABLE} 
	ARGS -o ${PROJECT_SOURCE_DIR}/compiler-tokens.cpp compiler-tokens.l
	DEPENDS compiler-tokens.l
)

# target_link_libraries (ailc adreno)

# Compile with maximum warnings
if (MSVC)
  if (CMAKE_CXX_FLAGS MATCHES "/W[0-4]")
    string (REGEX REPLACE "/W[0-4]" "/W4" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
  else ()
    set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W4")
  endif ()

  # Except M$ only deprecations and warnings
  add_definitions (/D_SCL_SECURE_NO_WARNINGS)
  add_definitions (/D_CRT_SECURE_NO_WARNINGS)
  add_definitions (/D_CRT_SECURE_NO_DEPRECATE)
  add_definitions (/D_CRT_NONSTDC_NO_DEPRECATE)
elseif (CMAKE_COMPILER_IS_GNUCC)
  set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -W -Wall -Wextra -Wno-unused-parameter -g -std=c++11 -O3")
endif ()

if (CMAKE_BUILD_TYPE EQUAL Debug)
  add_definitions (-D_DEBUG)
endif ()
