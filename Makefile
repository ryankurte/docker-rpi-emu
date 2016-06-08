
DATE=2016-05-27

DIST=$(DATE)-raspbian-jessie-lite
ZIP=$(DIST).zip
IMAGE=$(DIST).img

PATH=http://vx2-downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2016-05-31/$(ZIP)

RUN_ARGS="-it --rm -v .:/usr/rpi ryankurte/rpi-emu"
MOUNT_DIR="/media/rpi"

build:
	docker build -t ryankurte/rpi-emu .

bootstrap: $(IMAGE)

$(IMAGE):
	wget -c $(PATH)
	unzip $(ZIP)
	touch $@

run: build bootstrap
	docker run $(RUN_ARGS) /bin/bash

expand: build
	dd if=/dev/zero bs=1M count=1024 >> $IMAGE
	docker run $(RUN_ARGS) ./expand.sh $IMAGE

run: build
	docker run $(RUN_ARGS) /bin/bash -c \
		"./mount.sh $IMAGE $(MOUNT_DIR) \
		&& ./qemu-setup.sh $(MOUNT_DIR) \
		&& cd $(MOUNT_DIR) \
		&& chroot . bin/bash; \
		./unmount.sh $(MOUNT_DIR)"