# Set the required cmake version. 2.8 is a widely used version, however there are a lot of usefull features in later versions
CMAKE_MINIMUM_REQUIRED(VERSION 3.3)

PROJECT(CUDA_tutorial1)

#set(CUDA_TOOLKIT_ROOT_DIR )

# This invoces script that locates NVIDIA CUDA tools.
FIND_PACKAGE(CUDA REQUIRED)

# We search for all *.cu and append file paths to variable CUDA_SOURCES
FILE(GLOB CUDA_SOURCES "*.cu")

# Here we append to a variable CUDA_NVCC_FLAGS lines "-G;-gencode arch=compute_30,code=compute_30"
# All variables in CMake are string. We take existing variable and append parameters that we need
# CUDA_NVCC_FLAGS already exists and has all needed flags. Thay are set by the script, that we've invoked 
# by placing line "FIND_PACKAGE(CUDA REQUIRED)"
# We set only virtual and real architexture to version 3.0 (Kepler)
# Flag -G enables debugging using NSight
LIST(APPEND CUDA_NVCC_FLAGS -G;-gencode arch=compute_30,code=compute_30)

# CUDA_ADD_EXECUTABLE is a macros defined in script from "FIND_PACKAGE(CUDA REQUIRED)"
# It creates an executable target out of CUDA sources.
CUDA_ADD_EXECUTABLE(CUDA_tutorial1 ${CUDA_SOURCES})
