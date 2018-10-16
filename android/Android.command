#!/bin/bash

path="$(cd "$(dirname "$0")" && pwd)"
target=jrtp

# /path/to/ndk-bundle/
path_ndk="$ANDROID_NDK_HOME"

build_library() {

	path_install="$path/$target/$1"
	path_build="$path_install/build"

	path_jthread="$path/jthread/$1"

	rm -rf "$path_install"
	mkdir -p "$path_build"
	cd "$path_build"
	cmake "../../../.." \
		-DCMAKE_SYSTEM_NAME=Android \
		-DCMAKE_SYSTEM_VERSION=23 \
		-DCMAKE_ANDROID_ARCH_ABI="$1" \
		-DCMAKE_ANDROID_NDK="$path_ndk" \
		-DCMAKE_ANDROID_STL_TYPE=c++_static \
		-DJRTPLIB_USE_IFADDRS=NO \
		-DJRTPLIB_USE_BIGENDIAN=NO \
		-DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER \
		-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
		-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
		-DCMAKE_FIND_ROOT_PATH="$path_install;$path_ndk;$path_jthread" \
		-DCMAKE_INSTALL_PREFIX="$path_install" \
		-DCMAKE_BUILD_TYPE=Release
	make -j8
	make install
	cd "$path"

	# cleanup temp
	rm -rf "$path_build"
	# cleanup lib
	path_lib="$path_install/lib"
	mv "$path_lib/lib$target.so" "$path_install/lib$target.so"
	rm -rf "$path_lib"
	mkdir -p "$path_lib"
	mv "$path_install/lib$target.so" "$path_lib/lib$target.so"
}

build_library "armeabi-v7a"
build_library "arm64-v8a"
