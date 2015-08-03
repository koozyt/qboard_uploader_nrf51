PACKAGE_JSON=package_qboard_uploader_nrf51.json
ARCHIVE_WINDOWS=dfutil-nrf51-qboard-0.8.1-windows.tar.bz2
ARCHIVE_MAC=dfutil-nrf51-qboard-0.8.1-mac.tar.bz2

all: build/${PACKAGE_JSON}

build/${ARCHIVE_MAC}: dfutil-nrf51-koozyt-mac/flash_ble
	tar cjf build/${ARCHIVE_MAC} dfutil-nrf51-koozyt-mac

build/${ARCHIVE_WINDOWS}: dfutil-nrf51-koozyt/flash_ble.exe
	tar cjf build/${ARCHIVE_WINDOWS} dfutil-nrf51-koozyt

build/shsum-mac: build/${ARCHIVE_MAC}
	cd build && shasum -a 256 ${ARCHIVE_MAC} | cut -d' ' -f1 > shsum-mac

build/size-mac: build/${ARCHIVE_MAC}
	cd build && ls -l ${ARCHIVE_MAC} | cut -d' ' -f5 > size-mac

build/shsum-win: build/${ARCHIVE_WINDOWS}
	cd build && shasum -a 256 ${ARCHIVE_WINDOWS} | cut -d' ' -f1 > shsum-win

build/size-win: build/${ARCHIVE_WINDOWS}
	cd build && ls -l ${ARCHIVE_WINDOWS} | cut -d' ' -f5 > size-win

build/${PACKAGE_JSON}: packaging/${PACKAGE_JSON} build/shsum-win build/shsum-mac build/size-win build/size-mac
	sed -e "s/%%CHECKSUM-MAC%%/`cat build/shsum-mac`/" -e "s/%%SIZE-MAC%%/`cat build/size-mac`/" < packaging/${PACKAGE_JSON} > a
	sed -e "s/%%CHECKSUM-WIN%%/`cat build/shsum-win`/" -e "s/%%SIZE-WIN%%/`cat build/size-win`/" < a > build/${PACKAGE_JSON}

dfutil-nrf51-koozyt/flash_ble.exe: dfu_ble/src/flash_ble.exe
	cd dfu_ble && make && cp src/flash_ble.exe ../dfutil-nrf51-koozyt/
