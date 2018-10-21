#!/bin/bash

path="$(cd "$(dirname "$0")" && pwd)"

# /path/to/ndk-bundle/
path_ndk="$ANDROID_NDK_HOME"
path_build="$path/build.android"

# cleanup build
rm -rf "$path_build"

build_library() {

	path_install="$path_build/$1"
	path_temp="$path_install/temp"

	path_jthread="$path/android/jthread/$1"

	# cleanup install
	rm -rf "$path_install"
	mkdir -p "$path_temp"

	# cmake
	cd "$path_temp"
	cmake "../../.." \
		-DCMAKE_SYSTEM_NAME=Android \
		-DCMAKE_SYSTEM_VERSION=23 \
		-DCMAKE_ANDROID_ARCH_ABI="$1" \
		-DCMAKE_ANDROID_NDK="$path_ndk" \
		-DCMAKE_ANDROID_STL_TYPE=c++_static \
		-DJRTPLIB_USE_IFADDRS=NO \
		-DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER \
		-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
		-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
		-DCMAKE_FIND_ROOT_PATH="$path_install;$path_jthread" \
		-DCMAKE_INSTALL_PREFIX="$path_install" \
		-DCMAKE_BUILD_TYPE=Release 
	make -j8
	make install
	cd "$path"

	# cleanup temp
	rm -rf "$path_temp"

	# cleanup lib	
	path_lib="$path_install/lib"
	if [ -d "$path_lib" ] 
	then
		cd "$path_lib"
		find . ! -name "*.so" ! -name "*.a" -delete
	fi
}

build_library "armeabi-v7a"
build_library "arm64-v8a"
