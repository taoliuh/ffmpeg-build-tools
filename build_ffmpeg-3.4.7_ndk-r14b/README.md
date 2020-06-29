# 编译ffmpeg, fdk-aac, x264
## 1. 准备工作
下载ffmpeg,fdk-aac,x264源码

1)ffmpeg:
https://www.ffmpeg.org/releases/ffmpeg-3.4.7.tar.bz2

2)fdk-aac:
https://github.com/mstorsjo/fdk-aac/archive/v0.1.6.tar.gz

3)x264
https://code.videolan.org/videolan/x264/-/archive/master/x264-master.tar.bz2

ndk版本号为r14b，验证通过。r13应该也能编过，不过没有试验。r17c不能编过。ndk版本大于r17之后由于移除了gcc, 使用clang编译。如果ndk版本较低，可以使用r14b编译，已测试通过，不要再折腾！

编译脚本：
buildscript
  \
   arm-v7a
   \
    arm64-v8a
    
包含x264, fdk-aac, ffmpeg的编译脚本，支持arm-v7a, arm64-v8a.

## 2. 编译x264
解压并拷贝build_x264_arm_v7a.sh文件到x264源码目录。

$ chmod a+x build_x264_arm_v7a.sh

$ ./build_x264_arm_v7a.sh
生成产出到android目录

## 3. 编译fdk-aac
解压并拷贝build_fdk_aac_arm_v7a.sh文件到fdk-aac-0.1.6源码目录。

由于没有configure文件，需要运行autogen.sh生成。你可能需要安装automake软件：

$ brew install automake libtool

$ ./autogen.sh

生成configure文件后执行，编译脚本已集成。

$ ./build_fdk_aac_arm_v7a.sh

生成产出到android目录

使用高于0.1.6版本的fdk-aac软件虽然编译产出了，但是集成ffmpeg会找不到对应头文件导致打包失败。请注意。

## 4. 编译ffmpeg
1)如果只想编译一个ffmpeg产出，使用build_ffmpeg_arm_v7a_clean.sh编译脚本

$ chmod a+x build_ffmpeg_arm_v7a_clean.sh

$ ./build_ffmpeg_arm_v7a_clean.sh

生成产出到android目录，包含ffmpeg的多个静态库和链接合成的一个libffmpeg.so动态库。

2)如果要编译一个支持fdk-aac及x264的ffmpeg产出，使用build_ffmpeg_arm_v7a.sh编译脚本
首先将编译成功的libx264和fdk-aac-0.1.6文件夹移入到ffmpeg-3.4.7目录中，接着执行

$ chmod a+x build_ffmpeg_arm_v7a.sh

$ ./build_ffmpeg_arm_v7a.sh

生成产出到android目录，尝试链接多个静态库打成一个完整的动态库，失败告终。最终产出为多个拆分的so库，包括依赖的第三方库x264, fdk-aac.

## 5. 其它
ffmpeg-3.4.7包含已编译完成的so库。
产出目录：
ffmpeg-3.4.7/android/
ffmpeg-3.4.7/fdk-aac-0.1.6/android
ffmpeg-3.4.7/libx264/android

注意：编译环境
macOS
NDK: r14b
Ffmpeg: 3.4.7
fdk-aac: 0.1.6
x264: 官网下载最新master软件包(750kb)

