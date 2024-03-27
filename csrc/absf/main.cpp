#include <cstdio>
#include <cstdlib>
#include <vector>

#define CL_TARGET_OPENCL_VERSION 120
#include "CL/cl.h"

#define CHECK_CL_ERRCODE(err)                                                  \
  do {                                                                         \
    if (err != CL_SUCCESS) {                                                   \
      fprintf(stderr, "%s:%d error after CL call: %d\n", __FILE__, __LINE__,   \
              err);                                                            \
      return EXIT_FAILURE;                                                     \
    }                                                                          \
  } while (0)

static const size_t buffer_size = 4 * sizeof(float);
static const char *kerenel_name = "absf";

static const char *program_source = R"(
kernel void
absf (global const float *in,
      global float *out)
{
  printf("gid: %d, lid: %d, gid: %d \n",
    get_global_id(0), get_local_id(0), get_group_id(0));
  size_t gid = get_global_id(0);
  out[gid] = in[gid] * -1;
}
)";

int main() {
  cl_platform_id platform;
  cl_device_id device;
  cl_int err;

  // Get the first GPU device of the first platform
  err = clGetPlatformIDs(1, &platform, nullptr);
  CHECK_CL_ERRCODE(err);

  char platform_name[128];
  err = clGetPlatformInfo(platform, CL_PLATFORM_NAME, sizeof(platform_name),
                          platform_name, nullptr);
  CHECK_CL_ERRCODE(err);
  printf("Platform: %s\n", platform_name);

  err = clGetDeviceIDs(platform, CL_DEVICE_TYPE_ALL, 1, &device, nullptr);
  CHECK_CL_ERRCODE(err);

  char device_name[128];
  err = clGetDeviceInfo(device, CL_DEVICE_NAME, sizeof(device_name),
                        device_name, nullptr);
  CHECK_CL_ERRCODE(err);
  printf("Device: %s\n", device_name);

  auto context = clCreateContext(nullptr, 1, &device, nullptr, nullptr, &err);
  CHECK_CL_ERRCODE(err);

  // Create program
  auto program =
      clCreateProgramWithSource(context, 1, &program_source, nullptr, &err);
  CHECK_CL_ERRCODE(err);

  // Build program
  err = clBuildProgram(program, 1, &device, nullptr, nullptr, nullptr);
  CHECK_CL_ERRCODE(err);

  // Create kernel
  auto kernel = clCreateKernel(program, kerenel_name, &err);
  CHECK_CL_ERRCODE(err);

  // Create command queue
  auto queue = clCreateCommandQueue(context, device, 0, &err);
  CHECK_CL_ERRCODE(err);

  // Create buffer
  auto buffer_in =
      clCreateBuffer(context, CL_MEM_WRITE_ONLY | CL_MEM_ALLOC_HOST_PTR,
                     buffer_size, nullptr, &err);
  CHECK_CL_ERRCODE(err);

  std::vector<float> vec_in = {-1.0f, -2.0f, -3.0f, -4.0f};
  err = clEnqueueWriteBuffer(queue, buffer_in, CL_TRUE, 0, buffer_size,
                             (const void *)vec_in.data(), 0, nullptr, nullptr);
  CHECK_CL_ERRCODE(err);

  auto buffer_out =
      clCreateBuffer(context, CL_MEM_WRITE_ONLY | CL_MEM_ALLOC_HOST_PTR,
                     buffer_size, nullptr, &err);
  CHECK_CL_ERRCODE(err);

  // Set kernel arguments
  err = clSetKernelArg(kernel, 0, sizeof(cl_mem), &buffer_in);
  CHECK_CL_ERRCODE(err);
  err = clSetKernelArg(kernel, 1, sizeof(cl_mem), &buffer_out);
  CHECK_CL_ERRCODE(err);

  size_t gws = buffer_size / sizeof(cl_float);
  size_t lws = 2;

  err = clEnqueueNDRangeKernel(queue, kernel, 1, nullptr, &gws, &lws, 0,
                               nullptr, nullptr);
  CHECK_CL_ERRCODE(err);

  // Complete execution
  err = clFinish(queue);
  CHECK_CL_ERRCODE(err);

  // Map the buffer
  auto ptr = clEnqueueMapBuffer(queue, buffer_out, CL_TRUE, CL_MAP_READ, 0,
                                buffer_size, 0, nullptr, nullptr, &err);
  CHECK_CL_ERRCODE(err);

  // Print the input
  for (auto v : vec_in) {
    printf("%f ", v);
  }
  printf("\n-->\n");

  // Print the result
  auto buffer_data = static_cast<cl_float *>(ptr);
  for (cl_uint i = 0; i < buffer_size / sizeof(cl_float); ++i) {
    printf("%f ", buffer_data[i]);
  }
  printf("\n");

  // Unmap the buffer
  err = clEnqueueUnmapMemObject(queue, buffer_out, ptr, 0, nullptr, nullptr);
  CHECK_CL_ERRCODE(err);
  err = clFinish(queue);
  CHECK_CL_ERRCODE(err);

  // Cleanup
  clReleaseMemObject(buffer_in);
  clReleaseMemObject(buffer_out);
  clReleaseCommandQueue(queue);
  clReleaseKernel(kernel);
  clReleaseProgram(program);
  clReleaseContext(context);
}
