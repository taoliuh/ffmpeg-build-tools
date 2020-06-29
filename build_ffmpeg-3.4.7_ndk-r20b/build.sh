#!/bin/bash

SHELL_PATH=$(pwd)

FFMPEG_VERSION=3.4.7
X264_VERSION=master
FDK_AAC_VERSION=2.0.0
LAME_VERSION=3.100

FFMPEG_SOURCE=ffmpeg-$FFMPEG_VERSION
X264_SOURCE=x264-$X264_VERSION
FDK_AAC_SOURCE=fdk-aac-$FDK_AAC_VERSION
LAME_SOURCE=lame-$LAME_VERSION

FFMPEG_PATH=$SHELL_PATH/source/$FFMPEG_SOURCE
X264_PATH=$SHELL_PATH/source/$X264_SOURCE
FDK_AAC_PATH=$SHELL_PATH/source/$FDK_AAC_SOURCE
LAME_PATH=$SHELL_PATH/source/$LAME_SOURCE

if [ "$#" -ne "1" ]; then
	echo "请添加编译参数，x264, fdk-aac, lame, ffmpeg可选其一"
	exit
fi

if [ ! -d "source" ]; then
	mkdir source
fi

cd source

downloadFfmpeg() {
	echo "下载$FFMPEG_SOURCE"
    curl -O http://ffmpeg.org/releases/${FFMPEG_SOURCE}.tar.bz2
}

unzipFfmpeg() {
	echo "解压$FFMPEG_SOURCE"
	tar zxvf ${FFMPEG_PATH}.tar.bz2 -C $SHELL_PATH/source/
	cp $SHELL_PATH/buildscript/build_ffmpeg.sh $FFMPEG_PATH
}

downloadX264() {
	echo "下载$X264_SOURCE"
    curl -O https://code.videolan.org/videolan/x264/-/archive/master/${X264_SOURCE}.tar.bz2
}

unzipX264() {
	echo "解压$X264_SOURCE"
	tar zxvf ${X264_PATH}.tar.bz2 -C $SHELL_PATH/source/
	cp $SHELL_PATH/buildscript/build_x264.sh $X264_PATH
}

downloadFdkaac() {
	echo "下载$FDK_AAC_SOURCE"
    curl -O https://jaist.dl.sourceforge.net/project/opencore-amr/fdk-aac/${FDK_AAC_SOURCE}.tar.gz
}

unzipFdkaac() {
	echo "解压$FDK_AAC_SOURCE"
	tar zxvf ${FDK_AAC_PATH}.tar.gz -C $SHELL_PATH/source/
	cp $SHELL_PATH/buildscript/build_fdk-aac.sh $FDK_AAC_PATH
}

downloadLame() {
	echo "下载$LAME_SOURCE"
    curl -O https://nchc.dl.sourceforge.net/project/lame/lame/$LAME_VERSION/${LAME_SOURCE}.tar.gz
}

unzipLame() {
	echo "解压$LAME_SOURCE"
	tar zxvf ${LAME_PATH}.tar.gz -C $SHELL_PATH/source/
	cp $SHELL_PATH/buildscript/build_lame.sh $LAME_PATH
}

if [ "$1" = "ffmpeg" ]; then
	if [ ! -f "${FFMPEG_SOURCE}.tar.bz2" ]; then
		downloadFfmpeg
    	unzipFfmpeg
	else
		unzipFfmpeg
	fi

	if [ ! -f "${X264_SOURCE}.tar.bz2" ]; then
		downloadX264
    	unzipX264
	else
		unzipX264
	fi

	if [ ! -f "${FDK_AAC_PATH}.tar.gz" ]; then
		downloadFdkaac
		unzipFdkaac
	else
		unzipFdkaac
	fi

	if [ ! -f "${LAME_PATH}.tar.gz" ]; then
		downloadLame
		unzipLame
    else
    	unzipLame
	fi
fi

if [ "$1" = "x264" ]; then
	if [ ! -f "${X264_SOURCE}.tar.bz2" ]; then
		downloadX264
    	unzipX264
    else
    	unzipX264
    fi
fi

if [ "$1" = "fdk-aac" ]; then
	if [ ! -f "${FDK_AAC_PATH}.tar.gz" ]; then
		downloadFdkaac
		unzipFdkaac
	else
		unzipFdkaac
	fi
fi

if [ "$1" = "lame" ]; then
	if [ ! -f "${LAME_PATH}.tar.gz" ]; then
		downloadLame
		unzipLame
	else
		unzipLame
	fi
fi

if [ "$1" = "ffmpeg" -o "$1" = "x264" ]; then
	echo -n "请按照README修改x264 configure文件，如果已修改完成，按任意键继续..."
	read yes
fi

case "$1" in
"ffmpeg")
	# 避免重复编译依赖的第三方库
	if [ ! -d "$SHELL_PATH/build/x264" ]; then
		cd $X264_PATH
		sh build_x264.sh
	fi
	
	if [ ! -d "$SHELL_PATH/build/fdk-aac" ]; then
		cd $FDK_AAC_PATH
		sh build_fdk-aac.sh	
	fi

	if [ ! -d "$SHELL_PATH/build/lame" ]; then
		cd $LAME_PATH
		sh build_lame.sh
	fi

	cd $FFMPEG_PATH
	sh build_ffmpeg.sh
;;
"x264")
	cd $X264_PATH
	sh build_x264.sh
;;
"fdk-aac")
	cd $FDK_AAC_PATH
	sh build_fdk-aac.sh
;;
"lame")
	cd $LAME_PATH
	sh build_lame.sh
;;
esac

cd $SHELL_PATH

if [ ! -d "build" ]; then
	mkdir build
fi

rm -rf $SHELL_PATH/build
cp -R $SHELL_PATH/source/build/ $SHELL_PATH/build

echo "Build Success!"