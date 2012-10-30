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


# Targets

add_executable (
	compiler
	compiler-parser.tab.cpp
	compiler-tokens.cpp
)

add_custom_command(
	OUTPUT compiler-parser.tab.cpp
	COMMAND ${BISON_EXECUTABLE}
	ARGS -v -d -o ${PROJECT_SOURCE_DIR}/compiler-parser.tab.cpp compiler-parser.y
	DEPENDS compiler-parser.y
)

add_custom_command(
	OUTPUT compiler-tokens.cpp
	COMMAND ${FLEX_EXECUTABLE} 
	ARGS -o ${PROJECT_SOURCE_DIR}/compiler-tokens.cpp compiler-tokens.l
	DEPENDS compiler-tokens.l
)

# target_link_libraries (ailc adreno)
