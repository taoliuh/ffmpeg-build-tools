#!/bin/bash

HOST_TAG=darwin-x86_64
TOOLCHAIN=$NDK_HOME/toolchains/llvm/prebuilt/$HOST_TAG

ANDROID_LIB_PATH="$(dirname "$PWD")/build/fdk-aac"

API=26

if [ ! -f "configure" ]; then
	chmod a+x autogen.sh
	sh autogen.sh
fi

function build_android_arm
{
	echo "build for android $CPU"
	./configure \
	--host=$HOST \
	--enable-shared \
	--disable-static \
	--prefix="$ANDROID_LIB_PATH/$CPU" \
	CPPFLAGS="-fPIC"

	make clean
	make -j8
	make install
	echo "building for android $CPU completed"
}

# armv7-a
CPU=armv7-a
HOST=arm-linux-android
export AR=$TOOLCHAIN/bin/arm-linux-androideabi-ar
export AS=$TOOLCHAIN/bin/arm-linux-androideabi-as
export LD=$TOOLCHAIN/bin/arm-linux-androideabi-ld
export RANLIB=$TOOLCHAIN/bin/arm-linux-androideabi-ranlib
export STRIP=$TOOLCHAIN/bin/arm-linux-androideabi-strip
export CC=$TOOLCHAIN/bin/armv7a-linux-androideabi$API-clang
export CXX=$TOOLCHAIN/bin/armv7a-linux-androideabi$API-clang++
build_android_arm

# armv8-a
CPU=armv8-a
HOST=aarch64-linux-android
export AR=$TOOLCHAIN/bin/aarch64-linux-android-ar
export AS=$TOOLCHAIN/bin/aarch64-linux-android-as
export LD=$TOOLCHAIN/bin/aarch64-linux-android-ld
export RANLIB=$TOOLCHAIN/bin/aarch64-linux-android-ranlib
export STRIP=$TOOLCHAIN/bin/aarch64-linux-android-strip
export CC=$TOOLCHAIN/bin/aarch64-linux-android$API-clang
export CXX=$TOOLCHAIN/bin/aarch64-linux-android$API-clang++
build_android_arm