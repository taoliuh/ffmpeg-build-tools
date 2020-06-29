ANDROID_API=android-14

SYSROOT=$NDK_HOME/platforms/$ANDROID_API/arch-arm
TOOLCHAIN=$NDK_HOME/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64
PREFIX=./android/arm-v7a

function build_android
{
	./configure \
	--prefix=$PREFIX \
	--enable-static \
	--enable-shared \
	--disable-asm \
	--enable-pic \
	--enable-strip \
	--host=arm-linux \
	--cross-prefix=$TOOLCHAIN/bin/arm-linux-androideabi- \
	--sysroot=$SYSROOT \
	--extra-cflags="-Os -fpic" \
	--extra-ldflags="" 

	make clean
	make -j16
	make install
}
build_android