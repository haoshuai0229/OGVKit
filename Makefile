.FAKE : all clean

all : build/out/libogg.a

clean:
	rm -rf build
	test -f libogg/Makefile && (cd libogg && make distclean) || true
	rm -f libogg/configure
	test -f libvorbis/Makefile && (cd libvorbis && make distclean) || true
	rm -f libvorbis/configure
	test -f libtheora/Makefile && (cd libtheora && make distclean) || true
	rm -f libtheora/configure

build/out/libogg.a : compileOgg.sh
	./compileOgg.sh i386
	./compileOgg.sh x86_64
	./compileOgg.sh armv7
	./compileOgg.sh armv7s
	./compileOgg.sh arm64
	#
	test -d build/out/include || mkdir -p build/out/include
	rsync -av build/i386/include/ build/out/include/
	#
	test -d build/out/lib || mkdir -p build/out/lib
	lipo -create \
	  -output build/out/lib/libogg.a \
	  -arch i386 build/i386/lib/libogg.a \
	  -arch x86_64 build/x86_64/lib/libogg.a \
	  -arch armv7 build/armv7/lib/libogg.a \
	  -arch armv7s build/armv7s/lib/libogg.a \
	  -arch arm64 build/arm64/lib/libogg.a