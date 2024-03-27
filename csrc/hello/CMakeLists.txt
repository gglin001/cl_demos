set(TARGET_NAME "cl_hello")
add_executable(${TARGET_NAME} main.c)
target_link_libraries(${TARGET_NAME} ${OPENCL_LIBS})
