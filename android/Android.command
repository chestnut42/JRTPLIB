#!/bin/bash

path="$(cd "$(dirname "$0")" && pwd)"

generate_make() {
	cmake "$path/../CMakeLists.txt" \
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

generate_make "armeabi-v7a"
# generate_make "arm64-v8a"

# ndk-build NDK_PROJECT_PATH="$path" NDK_APPLICATION_MK="$path/Application.mk" APP_BUILD_SCRIPT="$path/Android.mk" NDK_LIBS_OUT="$path/.externalNativeBuild/libs" NDK_OUT="$path/.externalNativeBuild/obj" -j8