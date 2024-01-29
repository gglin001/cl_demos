# https://cmake.org/cmake/help/latest/policy/CMP0077.html
set(CMAKE_POLICY_DEFAULT_CMP0077 NEW)
include(FetchContent)
set(FETCHCONTENT_QUIET FALSE)

# spdlog
FetchContent_Declare(
  spdlog
  SYSTEM
  GIT_REPOSITORY https://github.com/gabime/spdlog
  GIT_TAG v1.13.0
  GIT_SHALLOW TRUE
  OVERRIDE_FIND_PACKAGE)
FetchContent_MakeAvailable(spdlog)

if(WITH_OPENCL_SDK)
  # OpenCLHeaders
  FetchContent_Declare(
    OpenCLHeaders
    SYSTEM
    GIT_REPOSITORY https://github.com/KhronosGroup/OpenCL-Headers
    GIT_TAG v2023.12.14
    GIT_SHALLOW TRUE
    OVERRIDE_FIND_PACKAGE)
  FetchContent_MakeAvailable(OpenCLHeaders)

  # OpenCLICDLoader
  FetchContent_Declare(
    OpenCLICDLoader
    SYSTEM
    GIT_REPOSITORY https://github.com/KhronosGroup/OpenCL-ICD-Loader
    GIT_TAG v2023.12.14
    GIT_SHALLOW TRUE
    OVERRIDE_FIND_PACKAGE)
  FetchContent_MakeAvailable(OpenCLICDLoader)

  # TODO: use https://github.com/KhronosGroup/OpenCL-SDK OpenCL-CLHPP
  FetchContent_Declare(
    OpenCLHeadersCpp
    SYSTEM
    GIT_REPOSITORY https://github.com/KhronosGroup/OpenCL-CLHPP
    GIT_TAG v2023.12.14
    GIT_SHALLOW TRUE
    OVERRIDE_FIND_PACKAGE)
  FetchContent_MakeAvailable(OpenCLHeadersCpp)
endif()
