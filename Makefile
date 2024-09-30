
all:
	echo started compiling
	docker run --rm -it --privileged \
		-v /dev:/dev \
		-w /qmk_firmware \
		-v .:/qmk_firmware/keyboards/crkbd/keymaps/osbm-config:z \
		-e SKIP_GIT= \
		-e SKIP_VERSION= \
		-e MAKEFLAGS= \
		qmk-cli make crkbd/rev1:osbm-config:flash

flash-rp2040:
	docker run --rm -it --privileged \
		-v /dev:/dev \
		-w /qmk_firmware \
		-v .:/output \
		-v .:/qmk_firmware/keyboards/crkbd/keymaps/osbm-config:z \
		-e USER=root \
		-e SKIP_GIT= \
		-e SKIP_VERSION= \
		-e MAKEFLAGS= \
		-e CONVERT_TO=rp2040_ce \
		qmk-cli bash -c "make crkbd/rev1:osbm-config && cp /qmk_firmware/.build/crkbd_rev1_osbm-config_rp2040_ce.uf2 /output"
build-image:
	docker build -t qmk-cli .
