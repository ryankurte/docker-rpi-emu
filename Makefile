
DATE=2016-05-27

DIST=$(DATE)-raspbian-jessie-lite
ZIP=$(DIST).zip
IMAGE=$(DIST).img

PATH=http://vx2-downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2016-05-31/$(ZIP)

RUN_ARGS=-it --rm --privileged=true -v `pwd`/images:/usr/rpi/images -w /usr/rpi ryankurte/rpi-emu
MOUNT_DIR=/media/rpi

build:
	docker build -t ryankurte/rpi-emu .

bootstrap: images/$(IMAGE)

images/$(IMAGE):
	wget -O images/$ZIP -c $(PATH)
	unzip -O images/ images/$(ZIP)
	touch $@

expand: build
	dd if=/dev/zero bs=1M count=1024 >> images/$(IMAGE)
	docker run $(RUN_ARGS) ./expand.sh images/$(IMAGE)

run:
	echo docker run $(RUN_ARGS) /bin/bash 

run-emu:
	echo docker run $(RUN_ARGS) /bin/bash -c ./run.sh