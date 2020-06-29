ANDROID_API=android-21

SYSROOT=$NDK_HOME/platforms/$ANDROID_API/arch-arm64
TOOLCHAIN=$NDK_HOME/toolchains/aarch64-linux-android-4.9/prebuilt/darwin-x86_64
CROSS_COMPILE=${TOOLCHAIN}/bin/aarch64-linux-android-

base_path=$(cd `dirname $0`; pwd)
echo "$base_path"

chmod a+x autogen.sh
./autogen.sh

CPU=arm64-v8a

CFLAGS=""

FLAGS="--enable-static --enable-shared --host=aarch64-linux --target=android --disable-asm "

export CXX="${CROSS_COMPILE}g++ --sysroot=${SYSROOT}"

export LDFLAGS=" -L$SYSROOT/usr/lib  $CFLAGS "

export CXXFLAGS=$CFLAGS

export CFLAGS=$CFLAGS

export CC="${CROSS_COMPILE}gcc --sysroot=${SYSROOT}"

export AR="${CROSS_COMPILE}ar"

export LD="${CROSS_COMPILE}ld"

export AS="${CROSS_COMPILE}gcc"


./configure $FLAGS \
--enable-pic \
--enable-strip \
--prefix=${base_path}/android/$CPU

make clean
make -j16
make install
