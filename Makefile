BUILDDIR=$(PWD)/build
FW_PREFIX=$(BUILDDIR)/Framework
FW_PATH=$(FW_PREFIX)/Python.framework
FW_RPATH=$(FW_PATH)/Versions/3.7

SQLITE3_MANIFEST_UUID=884b4b7e502b4e991677b53971277adfaf0a04a284f8e483e2553d0f83156b50

.PHONY : all slim python openssl sqlite3 zlib bzip2 xz clean-python clean-openssl clean-sqlite3 clean-zlib clean-bzip2 clean-xz clean

all : python

slim :
	rm -rf $(PWD)/Python.framework/Versions/Current/bin
	rm -rf $(PWD)/Python.framework/Versions/Current/lib/pkgconfig
	rm -rf $(PWD)/Python.framework/Versions/Current/share
	find $(PWD)/Python.framework/Versions/Current/lib/python3.7 | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf
	cd $(PWD)/Python.framework/Versions/Current/lib/python3.7 && \
		zip -r ../python37.zip * \
			-x lib-dynload/* -x config-3.7m-darwin/* -x turtledemo/* -x idlelib/*
	find $(PWD)/Python.framework/Versions/Current/lib/python3.7 -depth 1 | grep -v lib-dynload | grep -v config-3.7m-darwin | xargs rm -rf

python : openssl sqlite3 zlib bzip2 xz
	cd python && LDFLAGS=-L$(BUILDDIR)/lib CFLAGS=-I$(BUILDDIR)/include MACOSX_DEPLOYMENT_TARGET=10.12 \
			OPENSSL_INCLUDES=$(BUILDDIR)/include OPENSSL_LDFLAGS=$(BUILDDIR)/lib \
			./configure --prefix=$(BUILDDIR) --enable-framework --without-ensurepip
	$(MAKE) -C python -j$(NUM_PROCESSORS)
	$(MAKE) -C python install PYTHONFRAMEWORKPREFIX=$(FW_PREFIX) PYTHONFRAMEWORKINSTALLDIR=$(FW_PATH) prefix=$(FW_RPATH)
	cp -R $(FW_PATH) $(PWD)/Python.framework
	cd $(PWD)/Python.framework/Versions && ln -s 3.7 A && rm Current && ln -s A Current
	install_name_tool -id @executable_path/../Frameworks/Python.framework/Python $(PWD)/Python.framework/Python
	install_name_tool -change /Library/Frameworks/Python.framework/Versions/3.7/Python @executable_path/../../../../Python $(FW_PATH)/Resources/Python.app/Contents/MacOS/Python

openssl : 
	# https://wiki.openssl.org/index.php/Compilation_and_Installation
	cd openssl && ./Configure darwin64-x86_64-cc no-shared enable-ec_nistp_64_gcc_128 no-ssl2 no-ssl3 no-comp --prefix=$(BUILDDIR)
	$(MAKE) -C openssl depend
	$(MAKE) -C openssl -j$(NUM_PROCESSORS) install_dev

sqlite3 : zlib
	cd sqlite3 && echo $(SQLITE3_MANIFEST_UUID) > manifest.uuid
	cd sqlite3 && curl "https://sqlite.org/src/raw/`cut -c 1-8 manifest.uuid`.txt?name=${SQLITE3_MANIFEST_UUID}" -Lo manifest
	cd sqlite3 && \
		LDFLAGS=-L$(BUILDDIR)/lib CFLAGS=-I$(BUILDDIR)/include \
			./configure --prefix=$(BUILDDIR) --enable-static --disable-shared \
				--disable-tcl --disable-readline --disable-amalgamation
	$(MAKE) -C sqlite3 -j$(NUM_PROCESSORS) install

zlib :
	cd zlib && ./configure --prefix=$(BUILDDIR) --static
	$(MAKE) -C zlib -j$(NUM_PROCESSORS) install

bzip2 :
	$(MAKE) -C bzip2 -j$(NUM_PROCESSORS) install PREFIX=$(BUILDDIR)

xz :
	cd xz && PATH="/usr/local/opt/gettext/bin:$(PATH)" ./autogen.sh
	cd xz && ./configure --prefix=$(BUILDDIR) --enable-small --disable-shared --disable-doc \
		--disable-scripts --disable-xz --disable-xzdec --disable-lzmadec --disable-lzmainfo
	$(MAKE) -C xz -j$(NUM_PROCESSORS) install

clean-python :
	-$(MAKE) -C python clean

clean-openssl :
	-$(MAKE) -C openssl clean


clean-sqlite3 :
	-$(MAKE) -C sqlite3 clean

clean-zlib :
	-$(MAKE) -C zlib clean

clean-bzip2 :
	-$(MAKE) -C bzip2 clean

clean-xz :
	-$(MAKE) -C xz clean

clean : clean-openssl clean-sqlite3 clean-zlib clean-bzip2 clean-xz
	-rm -rf $(BUILDDIR)
