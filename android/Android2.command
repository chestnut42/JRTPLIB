#!/bin/bash

path="$(cd "$(dirname "$0")" && pwd)"

cat << EOF > "$path/toolchain.txt"
set(CMAKE_SYSTEM_NAME Android)
set(CMAKE_SYSTEM_VERSION 21)
set(CMAKE_ANDROID_ARCH_ABI armeabi-v7a)
set(CMAKE_ANDROID_NDK $ANDROID_NDK_HOME)
set(CMAKE_ANDROID_STL_TYPE gnustl_static)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
EOF

generate_make() {
	ccmake "$path/../CMakeLists.txt" \
		-DCMAKE_INSTALL_PREFIX="$path/$1" \
		-DCMAKE_SYSTEM_NAME=Android \
		-DCMAKE_SYSTEM_VERSION=21 \
		-DCMAKE_ANDROID_ARCH_ABI="$1" \
		-DCMAKE_ANDROID_NDK="$ANDROID_NDK_HOME" \
		-DCMAKE_ANDROID_STL_TYPE=gnustl_static \
		-DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER \
		-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
		-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
		-DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE=ONLY \
		-DCMAKE_FIND_ROOT_PATH="$path/$1"
}

# generate_make "armeabi-v7a"
# generate_make "arm64-v8a"
cmake "$path/.." \
	-DCMAKE_TOOLCHAIN_FILE="$path/toolchain.txt" \
	-DCMAKE_INSTALL_PREFIX="$path/" \
	-DCMAKE_FIND_ROOT_PATH="$path/"

# ndk-build NDK_PROJECT_PATH="$path" NDK_APPLICATION_MK="$path/Application.mk" APP_BUILD_SCRIPT="$path/Android.mk" NDK_LIBS_OUT="$path/.externalNativeBuild/libs" NDK_OUT="$path/.externalNativeBuild/obj" -j8