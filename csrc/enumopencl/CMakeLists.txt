set(TARGET_NAME "cl_enumopencl")
add_executable(${TARGET_NAME} main.c)
target_link_libraries(${TARGET_NAME} ${OPENCL_LIBS})

if(WITH_CLCPP)
  set(TARGET_NAME "cl_enumopenclcpp")
  add_executable(${TARGET_NAME} main.cpp)
  target_link_libraries(${TARGET_NAME} ${OPENCL_LIBS})
endif()
