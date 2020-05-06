set(CMAKE_LEGACY_CYGWIN_WIN64 0)
cmake_minimum_required(VERSION 2.8.4)  # CMake version check
project(sublime)               # Create project "simple_example"
set(CMAKE_CXX_STANDARD 14)            # Enable c++14 standard

# Add executable target with source files
add_executable(sublime tcpserver.c Common.c Common.h)