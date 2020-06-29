# 说明
一键编译ffmpeg脚本，集成x264, fdk-aac, lame. 可使用当前最新NDK 21版本编译ffmpeg 4.2.3版本。

# 编译：
1. 设置NDK_HOME：export NDK_HOME="your/ndk/path"，方便切换不同的ndk版本进行编译。ndk版本r14b使用gcc编译，对应目录build_ffmpeg-3.4.7_ndk-r14b。ndk版本r20b, r21b对应的编译脚本一样，使用clang独立工具链编译。

2. 当前目录执行 chmod a+x *.sh

3. 编辑build.sh文件的头部的软件版本号，可对应下载到不同版本的源码进行编译。当前目录中匹配的编译环境和软件版本能正常编译，有可能你使用其他软件版本不能成功编译。

4. 执行sh build.sh ffmpeg进行ffmpeg编译。可选参数包括x264, fdk-aac, lame, ffmpeg. 参数不能缺省。选择ffmpeg会编译所有依赖，使用其余参数可独立编译对应软件。

5. 编译过程中会将下载的软件包和解压后的源码放到source目录中，并在source目录中生成build文件，包含所有产出。编译完成后会将产出复制到编译脚本所在根目录。 

6. 解压过程中会提示用户修改x264 configure文件，找到echo "SONAME=libx264.so.$API" >> config.mak，修改为echo "SONAME=libx264.x.so" >> config.mak。否则生成后缀带版本号的so库不能在android平台中使用。


