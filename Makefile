
all:
	echo started compiling
	docker run --rm -it --privileged -v /dev:/dev -w /qmk_firmware -v .:/qmk_firmware/keyboards/crkbd/keymaps/osbm-config:z -e SKIP_GIT= -e SKIP_VERSION= -e MAKEFLAGS= qmk-cli make crkbd/rev1:osbm-config:flash

build-image:
	docker build -t qmk-cli .
