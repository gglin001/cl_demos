cmake_minimum_required(VERSION 3.27.0 FATAL_ERROR)

project(cl_demos C CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_EXTENSIONS ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin/)

# using KhronosGroup/OpenCL-ICD-Loader
option(WITH_OPENCL_SDK "WITH_OPENCL_SDK, with icd loader" OFF)
# pocl is built outside, without ocl-icd enabled
option(WITH_POCL "WITH_POCL, without icd loader" OFF)
# by default, opencl from system will be used

# need git submodules
option(WITH_OPENCL_CTS "WITH_OPENCL_CTS" OFF)
option(WITH_CLINFO "WITH_CLINFO" OFF)

if (WITH_OPENCL_SDK AND WITH_POCL)
  message(FATAL_ERROR "only one should be enabled")
endif()

# FetchContent
include(fetch.cmake)

if(WITH_OPENCL_SDK)
  find_package(OpenCLHeaders REQUIRED)
  find_package(OpenCLICDLoader REQUIRED)
  find_package(OpenCLHeadersCpp REQUIRED)
  set(OPENCL_LIBS OpenCL::Headers OpenCL::OpenCL OpenCL::HeadersCpp)
elseif(WITH_POCL)
  # TODO: use PkgConfig ?
  # TODO: solve rpath issue
  include_directories(SYSTEM ${POCL_INCLUDE_DIR})
  link_directories(${POCL_LIB_DIR})
  set(OPENCL_LIBS OpenCL)
else()
  find_package(OpenCL REQUIRED)
  set(OPENCL_LIBS OpenCL::OpenCL)
endif()

find_package(Python3 REQUIRED COMPONENTS Interpreter)
# Development is optional
find_package(Python3 COMPONENTS Development)
message("Python3_EXECUTABLE: ${Python3_EXECUTABLE}")
message("Python3_INCLUDE_DIRS: ${Python3_INCLUDE_DIRS}")
message("Python3_LIBRARIES: ${Python3_LIBRARIES}")

add_subdirectory(csrc)

if(WITH_OPENCL_CTS)
  execute_process(
    COMMAND git apply ${CMAKE_SOURCE_DIR}/cts_patch/OpenCL-CTS.patch -q
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/OpenCL-CTS)

  set(CL_INCLUDE_DIR "${openclheaders_SOURCE_DIR}")
  set(CL_HPP_INCLUDE_DIR "${openclheaderscpp_SOURCE_DIR}")
  set(OPENCL_LIBRARIES "OpenCL::OpenCL")

  add_subdirectory(OpenCL-CTS)
endif()

if(WITH_CLINFO)
  add_executable(cl_clinfo clinfo/src/clinfo.c)
  target_link_libraries(cl_clinfo ${OPENCL_LIBS})
endif()
