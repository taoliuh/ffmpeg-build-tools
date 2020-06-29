ANDROID_API=android-21

SYSROOT=$NDK_HOME/platforms/$ANDROID_API/arch-arm64
TOOLCHAIN=$NDK_HOME/toolchains/aarch64-linux-android-4.9/prebuilt/darwin-x86_64
PREFIX=./android/arm64-v8a

function build_android
{
	./configure \
	--prefix=$PREFIX \
	--enable-shared \
	--enable-static \
	--disable-asm \
	--enable-pic \
	--enable-strip \
	--host=arm-linux \
	--cross-prefix=$TOOLCHAIN/bin/aarch64-linux-android- \
	--sysroot=$SYSROOT \
	--extra-cflags="-Os -fpic" \
	--extra-ldflags="" 

	make clean
	make -j16
	make install
}
build_android
