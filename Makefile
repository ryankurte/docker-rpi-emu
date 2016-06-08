# Helper makefile to demonstrate the use of the rpi-emu docker environment

DATE=2016-05-27

DIST=$(DATE)-raspbian-jessie-lite
ZIP=$(DIST).zip
IMAGE=$(DIST).img

PATH=http://vx2-downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2016-05-31/$(ZIP)
CWD=$(shell pwd)

RUN_ARGS=-it --rm --privileged=true -v $(CWD)/images:/usr/rpi/images -w /usr/rpi ryankurte/rpi-emu
MOUNT_DIR=/media/rpi

# Build the docker image
build:
	docker build -t ryankurte/rpi-emu .

# Bootstrap a RPI image into the images directory
bootstrap: images/$(IMAGE)

# Fetch the RPI image from the path above
images/$(IMAGE):
	wget -O images/$ZIP -c $(PATH)
	unzip -O images/ images/$(ZIP)
	touch $@

# Expand the image by a specified size
expand: build bootstrap
	dd if=/dev/zero bs=1M count=1024 >> images/$(IMAGE)
	docker run $(RUN_ARGS) ./expand.sh images/$(IMAGE) 1024

# Launch the docker image without running any of the utility scripts
run: build bootstrap
	docker run $(RUN_ARGS) /bin/bash 

# Launch the docker image into an emulated session
run-emu: build bootstrap
	docker run $(RUN_ARGS) /bin/bash -c './run.sh images/$(IMAGE)'

