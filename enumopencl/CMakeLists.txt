add_executable(enumopencl main.c)
if(WITH_OPENCL_SDK)
  target_link_libraries(enumopencl OpenCL::Headers OpenCL::OpenCL)
else()
  target_link_libraries(enumopencl OpenCL::OpenCL)
endif()

# TODO: make it works on macos
if(WITH_OPENCL_SDK)
  add_executable(enumopenclcpp main.cpp)
  target_link_libraries(enumopenclcpp OpenCL::Headers OpenCL::OpenCL
                        OpenCL::HeadersCpp)
endif()
