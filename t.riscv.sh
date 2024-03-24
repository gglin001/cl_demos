# https://github.com/gglin001/Dockerfiles/blob/master/pocl/Dockerfile.riscv

export POCL_INSTALL_PATH=/home/pocl/build/install

cmake --preset minimum \
  -DOpenCL_INCLUDE_DIR=$POCL_INSTALL_PATH/include \
  -DOpenCL_LIBRARY=$POCL_INSTALL_PATH/lib/libOpenCL.so

cmake --build build --target all

build/bin/cl_enumopencl
# eg:
#
# root# build/bin/cl_enumopencl
# Enumerated 1 platforms.
# Platform[0]:
#         Name:           Portable Computing Language
#         Vendor:         The pocl project
#         Driver Version: OpenCL 3.0 PoCL 6.0-pre main-0-g7f568a4  Linux, Release, without LLVM, POCL_DEBUG
# Device[0]:
#         Type:           CPU
#         Name:           cpu
#         Vendor:         PoCL Project
#         Device Version: OpenCL 3.0 PoCL HSTR: cpu-00000000-(null)
#         Device Profile: FULL_PROFILE
#         Driver Version: 6.0-pre main-0-g7f568a4
# Done.
#
