# https://cmake.org/cmake/help/latest/policy/CMP0077.html
set(CMAKE_POLICY_DEFAULT_CMP0077 NEW)
include(FetchContent)
set(FETCHCONTENT_QUIET FALSE)

# TODO: use https://github.com/KhronosGroup/OpenCL-SDK

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
endif()

if((WITH_OPENCL_SDK) AND (NOT WITH_SYSTEM_LIBS))
  # OpenCLICDLoader
  FetchContent_Declare(
    OpenCLICDLoader
    SYSTEM
    GIT_REPOSITORY https://github.com/KhronosGroup/OpenCL-ICD-Loader
    GIT_TAG v2023.12.14
    GIT_SHALLOW TRUE
    OVERRIDE_FIND_PACKAGE)
  FetchContent_MakeAvailable(OpenCLICDLoader)
endif()

if(WITH_OPENCL_SDK)
  # OpenCL-CLHPP
  FetchContent_Declare(
    OpenCLHeadersCpp
    SYSTEM
    GIT_REPOSITORY https://github.com/KhronosGroup/OpenCL-CLHPP
    GIT_TAG v2023.12.14
    GIT_SHALLOW TRUE
    OVERRIDE_FIND_PACKAGE)
  set(BUILD_EXAMPLES OFF)
  FetchContent_MakeAvailable(OpenCLHeadersCpp)
endif()
