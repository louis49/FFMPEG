#!/bin/sh
export PATH=/opt/local/bin:/usr/bin:/bin:/opt/local/bin:/usr/local/bin

CONFIGURE_FLAGS="--enable-static --disable-cli --disable-asm"

ARCHS="arm64 armv7s x86_64 i386 armv7"
#ARCHS="x86_64 i386"

# directories
SOURCE="x264"
FAT="fat"

SCRATCH="scratch-x264"
# must be an absolute path
THIN=`pwd`/"thin-x264"

COMPILE="y"
LIPO="y"

if [ "$*" ]
then
	if [ "$*" = "lipo" ]
	then
		# skip compile
		COMPILE=
	else
		ARCHS="$*"
		if [ $# -eq 1 ]
		then
			# skip lipo
			LIPO=
		fi
	fi
fi

if [ ! -r $SOURCE ]
then
echo 'x264 source not found. Trying to download...'
git clone git://git.videolan.org/x264.git
fi

if [ "$COMPILE" ]
then
	CWD=`pwd`
	for ARCH in $ARCHS
	do
		echo "building $ARCH..."
		mkdir -p "$SCRATCH/$ARCH"
		cd "$SCRATCH/$ARCH"

		if [ "$ARCH" = "i386" -o "$ARCH" = "x86_64" ]
		then
		    PLATFORM="iPhoneSimulator"
		    CPU=
		    if [ "$ARCH" = "x86_64" ]
		    then
		    	SIMULATOR="-mios-simulator-version-min=7.0"
		    	HOST=
		    else
		    	SIMULATOR="-mios-simulator-version-min=5.0"
			HOST="--host=i386-apple-darwin"
		    fi
		else
		    PLATFORM="iPhoneOS"
		    if [ $ARCH = "armv7s" ]
		    then
		    	CPU="--cpu=swift"
		    else
		    	CPU=
		    fi
		    SIMULATOR=
		    HOST="--host=arm-apple-darwin"
		fi

		XCRUN_SDK=`echo $PLATFORM | tr '[:upper:]' '[:lower:]'`
		CC="xcrun -sdk $XCRUN_SDK clang -Wno-error=unused-command-line-argument-hard-error-in-future"
		AS="$CWD/$SOURCE/extras/gas-preprocessor.pl $CC"
		CFLAGS="-arch $ARCH $SIMULATOR"
		CXXFLAGS="$CFLAGS"
		LDFLAGS="$CFLAGS"

		CC=$CC $CWD/$SOURCE/configure \
		    $CONFIGURE_FLAGS \
		    $HOST \
		    $CPU \
		    --extra-cflags="$CFLAGS" \
		    --extra-ldflags="$LDFLAGS" \
		    --prefix="$THIN/$ARCH"

		make -j3 install
		cd $CWD
	done
fi

if [ "$LIPO" ]
then
	echo "building fat binaries..."
    rm -rf "$FAT"
	mkdir -p $FAT/lib
	set - $ARCHS
	CWD=`pwd`
	cd $THIN/$1/lib
	for LIB in *.a
	do
		cd $CWD
		lipo -create `find $THIN -name $LIB` -output $FAT/lib/$LIB
        xcrun -sdk iphoneos lipo -info $FAT/lib/$LIB
	done

	cd $CWD
	cp -rf $THIN/$1/include $FAT

fi

rm -rf "$SOURCE"
rm -rf "$SCRATCH"
rm -rf "$THIN"
