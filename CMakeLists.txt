cmake_minimum_required(VERSION 4.0)
project(FzP C)

set(CMAKE_C_STANDARD 11)

find_package(PkgConfig REQUIRED)
pkg_check_modules(NOTCURSES REQUIRED notcurses)

include_directories(${NOTCURSES_INCLUDE_DIRS})
link_directories(${NOTCURSES_LIBRARY_DIRS})

add_executable(FzP interface.c)
target_link_libraries(FzP ${NOTCURSES_LIBRARIES})
