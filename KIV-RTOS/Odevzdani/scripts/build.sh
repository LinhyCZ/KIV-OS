#!/bin/bash
cd ../src

#Compile kernel for the first time
mkdir -p build >/dev/null 2>&1
cd build

cmake -G "Unix Makefiles" -DCMAKE_TOOLCHAIN_FILE="../misc/cmake/toolchain-arm-none-eabi-rpi0.cmake" ..

cmake --build . --parallel

#Compile userspace task
cd ../userspace
mkdir -p build >/dev/null 2>&1
cd build

cmake -G "Unix Makefiles" -DCMAKE_TOOLCHAIN_FILE="../../misc/cmake/toolchain-arm-none-eabi-rpi0.cmake" ..

cmake --build . --parallel

#Compile kernel with the task
cd ../..
mkdir -p build >/dev/null 2>&1
cd build

cmake -G "Unix Makefiles" -DCMAKE_TOOLCHAIN_FILE="../misc/cmake/toolchain-arm-none-eabi-rpi0.cmake" ..

cmake --build . --parallel
