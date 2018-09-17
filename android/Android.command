#!/bin/bash

path="$(cd "$(dirname "$0")" && pwd)"

build_library() {
	rm -rf "$path/$1"
	mkdir -p "$path/$1/build"
	cd "$path/$1/build"
	cmake "../../.." \
		-DCMAKE_INSTALL_PREFIX="$path/$1" \
		-DCMAKE_SYSTEM_NAME=Android \
		-DCMAKE_SYSTEM_VERSION=21 \
		-DCMAKE_ANDROID_ARCH_ABI="$1" \
		-DCMAKE_ANDROID_NDK="$ANDROID_NDK_HOME" \
		-DCMAKE_ANDROID_STL_TYPE=gnustl_static \
		-DJRTPLIB_USE_IFADDRS=NO \
		-DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER \
		-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
		-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
		-DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE=ONLY \
		-DCMAKE_FIND_ROOT_PATH="$path/$1"
	make -j8
	make install
	cd "$path"
	rm -rf "$path/$1/build"	
}

build_library "armeabi-v7a"
build_library "arm64-v8a"
