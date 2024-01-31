# install opencl-icd & pocl
micromamba install -y pocl
# for mac or windows
micromamba install -y khronos-opencl-icd-loader clhpp
# for linux
micromamba install -y ocl-icd clhpp

# config
cmake --preset pocl

# build
cmake --build build --target all
