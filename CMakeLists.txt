cmake_minimum_required(VERSION 3.27.0 FATAL_ERROR)

project(cl_demos C CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_EXTENSIONS ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin/)

option(WITH_OPENCL_SDK "WITH_OPENCL_SDK" OFF)
option(WITH_OPENCL_CTS "WITH_OPENCL_CTS" OFF)

# TODO: add a opencl (cpu)runtime src to build

# FetchContent
include(fetch.cmake)

if(WITH_OPENCL_SDK)
  find_package(OpenCLHeaders REQUIRED)
  find_package(OpenCLICDLoader REQUIRED)
  find_package(OpenCLHeadersCpp REQUIRED)
else()
  find_package(OpenCL REQUIRED)
endif()

find_package(Python3 REQUIRED COMPONENTS Interpreter)
# Development is optional
find_package(Python3 COMPONENTS Development)
message("Python3_EXECUTABLE: ${Python3_EXECUTABLE}")
message("Python3_INCLUDE_DIRS: ${Python3_INCLUDE_DIRS}")
message("Python3_LIBRARIES: ${Python3_LIBRARIES}")

add_subdirectory(enumopencl)

if(WITH_OPENCL_CTS)
  execute_process(COMMAND git apply ${CMAKE_SOURCE_DIR}/OpenCL-CTS.patch -q
                  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/OpenCL-CTS)
  set(CL_INCLUDE_DIR "${openclheaders_BINARY_DIR}")
  message("CL_INCLUDE_DIR: ${CL_INCLUDE_DIR}")
  add_subdirectory(OpenCL-CTS)
endif()
