ANDROID_API=android-21
SYSROOT=$NDK_HOME/platforms/$ANDROID_API/arch-arm64
TOOLCHAIN=$NDK_HOME/toolchains/aarch64-linux-android-4.9/prebuilt/darwin-x86_64

CPU=arm64-v8a
OPTIMIZE_CFLAGS="-march=armv8-a "
ADDI_CFLAGS=""

base_path=$(cd `dirname $0`; pwd)
echo $base_path

FDK_INCLUDE=$base_path/fdk-aac-0.1.6/android/arm64-v8a/include

FDK_LIB=$base_path/fdk-aac-0.1.6/android/arm64-v8a/lib

X264_INCLUDE=$base_path/libx264/android/arm64-v8a/include

X264_LIB=$base_path/libx264/android/arm64-v8a/lib

PREFIX=./android/$CPU

build_android() {
	./configure \
	--prefix=$PREFIX \
	--enable-cross-compile \
	--disable-runtime-cpudetect \
	--disable-asm \
	--arch=aarch64 \
	--target-os=android \
	--cc=$TOOLCHAIN/bin/aarch64-linux-android-gcc \
	--cross-prefix=$TOOLCHAIN/bin/aarch64-linux-android- \
	--disable-stripping \
	--nm=$TOOLCHAIN/bin/aarch64-linux-android-nm \
	--sysroot=$SYSROOT \
	--extra-cflags="-I$X264_INCLUDE  -I$FDK_INCLUDE " \
	--extra-ldflags="-L$X264_LIB -L$FDK_LIB " \
	--enable-gpl \
	--enable-shared \
	--disable-static \
	--enable-version3 \
	--enable-pthreads \
	--enable-small \
	--disable-vda \
	--disable-iconv \
	--disable-encoders \
	--enable-libx264 \
	--enable-neon \
	--enable-yasm \
	--enable-libfdk_aac \
	--enable-encoder=libx264 \
	--enable-encoder=libfdk_aac \
	--enable-encoder=mjpeg \
	--enable-encoder=png \
	--enable-nonfree \
	--enable-muxers \
	--enable-muxer=mov \
	--enable-muxer=mp3 \
	--enable-muxer=mp4 \
	--enable-muxer=h264 \
	--enable-muxer=avi \
	--disable-decoders \
	--enable-decoder=aac \
	--enable-decoder=mp3 \
	--enable-decoder=aac_latm \
	--enable-decoder=h264 \
	--enable-decoder=mpeg4 \
	--enable-decoder=mjpeg \
	--enable-decoder=png \
	--disable-demuxers \
	--enable-demuxer=image2 \
	--enable-demuxer=h264 \
	--enable-demuxer=aac \
	--enable-demuxer=mp3 \
	--enable-demuxer=avi \
	--enable-demuxer=mpc \
	--enable-demuxer=mpegts \
	--enable-demuxer=mov \
	--disable-parsers \
	--enable-parser=aac \
	--enable-parser=mp3 \
	--enable-parser=ac3 \
	--enable-parser=h264 \
	--enable-protocols \
	--enable-zlib \
	--enable-avfilter \
	--disable-outdevs \
	--disable-ffserver \
	--disable-debug \
	--disable-ffprobe \
	--disable-ffplay \
	--disable-ffmpeg \
	--disable-postproc \
	--disable-avdevice \
	--disable-symver \
	--extra-cflags="-Os -fpic ${OPTIMIZE_CFLAGS}" \
	--extra-ldflags="${ADDI_LDFLAGS}"
}

build_android

make clean
make -j16
make install

