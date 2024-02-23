micromamba install -y pocl

# no system icd-loader is used when `-DWITH_OPENCL_SDK=ON`
# # for mac or windows
# micromamba install -y khronos-opencl-icd-loader clhpp
# # for linux
# micromamba install -y ocl-icd clhpp

# config
# no cts included
# cmake --preset minimum
# with cts
cmake --preset cts

# build
cmake --build build --target all
