BUILDDIR=$(PWD)/build
FRAMEWORKPATH=$(PWD)/Python.framework

SQLITE3_MANIFEST_UUID=884b4b7e502b4e991677b53971277adfaf0a04a284f8e483e2553d0f83156b50

.PHONY : all python openssl sqlite3 zlib bzip2 xz clean-python clean-openssl clean-sqlite3 clean-zlib clean-bzip2 clean-xz clean

all : python

python : openssl sqlite3 zlib bzip2 xz
	cd python && LDFLAGS=-L$(BUILDDIR)/lib CFLAGS=-I$(BUILDDIR)/include MACOSX_DEPLOYMENT_TARGET=10.12 \
			OPENSSL_INCLUDES=$(BUILDDIR)/include OPENSSL_LDFLAGS=$(BUILDDIR)/lib \
			./configure --prefix=$(BUILDDIR) --enable-framework --without-ensurepip
	sudo $(MAKE) -C python -j$(NUM_PROCESSORS) install
	cp -R /Library/Frameworks/Python.framework $(PWD)/Python.framework
	cd $(PWD)/Python.framework/Versions && mv 3.7 A
	cd $(PWD)/Python.framework/Versions && ln -s A 3.7
	install_name_tool -id @executable_path/../Frameworks/Python.framework/Python $(PWD)/Python.framework/Python

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
