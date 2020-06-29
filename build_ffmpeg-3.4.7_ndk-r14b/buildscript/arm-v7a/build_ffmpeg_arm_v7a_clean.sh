ANDROID_API=android-14
SYSROOT=$NDK_HOME/platforms/$ANDROID_API/arch-arm
TOOLCHAIN=$NDK_HOME/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64

CPU=arm-v7a
OPTIMIZE_CFLAGS="-march=armv7-a "
ADDI_CFLAGS=""

base_path=$(cd `dirname $0`; pwd)
echo $base_path

PREFIX=./android/$CPU

build_android() {
	./configure \
	--prefix=$PREFIX \
	--enable-cross-compile \
	--disable-runtime-cpudetect \
	--disable-asm \
	--arch=arm \
	--target-os=android \
	--cc=$TOOLCHAIN/bin/arm-linux-androideabi-gcc \
	--cross-prefix=$TOOLCHAIN/bin/arm-linux-androideabi- \
	--disable-stripping \
	--nm=$TOOLCHAIN/bin/arm-linux-androideabi-nm \
	--sysroot=$SYSROOT \
	--enable-gpl \
	--disable-shared \
	--enable-static \
	--enable-version3 \
	--enable-pthreads \
	--enable-small \
	--disable-vda \
	--disable-iconv \
	--disable-encoders \
	--enable-neon \
	--enable-yasm \
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
	--enable-decoder=aac_latm \
	--enable-decoder=mp3 \
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

# 合并到libffmpeg.so
${TOOLCHAIN}/bin/arm-linux-androideabi-ld \
-rpath-link=${SYSROOT}/usr/lib \
-L${SYSROOT}/usr/lib \
-L${PREFIX}/lib \
-soname libffmpeg.so -shared -nostdlib -Bsymbolic --whole-archive --no-undefined -o \
${PREFIX}/libffmpeg.so \
libavcodec/libavcodec.a \
libavfilter/libavfilter.a \
libswresample/libswresample.a \
libavformat/libavformat.a \
libavutil/libavutil.a \
libswscale/libswscale.a \
-lc -lm -lz -ldl -llog --dynamic-linker=/system/bin/linker \
${TOOLCHAIN}/lib/gcc/arm-linux-androideabi/4.9.x/libgcc.a

