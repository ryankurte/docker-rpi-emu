# Docker emulation environment for Raspberry Pi

Are you sick of long compile times on your Raspberry Pi?  
How much time have you spent loading Raspbian images from raspberrypi.org and hand customising them?  
Have you been burned before by Ansible, setting up jobs that require too much human intervention to be useful?  
Then this is the project for you!  

This project provides a dockerised (err, containerised) Qemu based emulated environment for the Raspberry Pi, useful for building Raspberry Pi based projects on x86/x64 computers, and for customising Raspbian images for distribution.  

Check it out on [Github](https://github.com/ryankurte/docker-rpi-emu/) or [Dockerhub](https://hub.docker.com/r/ryankurte/docker-rpi-emu/)  

## Components

The docker container includes the required Qemu components to support emulation. This must be launched in privileged mode to allow mounting of loopback devices.  

The container also includes a set of scripts to streamline the loading/customization/launch/unloading of Qemu environments, which are installed into the `/usr/rpi` directory on the device.  

## Usage

### From the Repo

To get started with an Emulated CLI, check out this repository with `git clone git@github.com:ryankurte/docker-rpi-emu.git`, change directories with `cd docker-rpi-emu` and run `make run-emu`.  

This will bootstrap a Raspbian image from raspberrypi.org, build the docker image, and launch the emulated environment.  

For examples of how to customise this, checkout the [Makefile](Makefile).  

### From Dockerhub

To get started with Docker, first pull the image with `docker pull ryankurte/docker-rpi-emu`.  
Ensure you have a Raspbian image handy (and you may want to back this up, it will be modified by anything you do in the emulated environment), then run the following command.  

`docker run -it --rm --privileged=true -v IMAGE_LOCATION:/usr/rpi/images -w /usr/rpi ryankurte/rpi-emu /bin/bash -c './run.sh images/IMAGE_NAME [COMMAND]'`  

Where IMAGE_LOCATION is the directory containing your Raspbian image to be mounted, IMAGE_NAME is the name of the image to be used, and [COMMAND] is the optional command to be executed (inside the image).  

For example:  

`docker run -it --rm --privileged=true -v /Users/ryan/projects/docker-rpi-emu/images:/usr/rpi/images -w /usr/rpi ryankurte/rpi-emu /bin/bash -c './run.sh images/2016-05-27-raspbian-jessie-lite.img /bin/bash'`  

Will mount the image directory `/Users/ryan/projects/docker-rpi-emu/images` and the image `2016-05-27-raspbian-jessie-lite.img` then run the command `/bin/bash` in the emulated environment.  

## Commands

Commands are installed into the `/usr/rpi` directory of the docker image.  

`./mount.sh IMAGE DIR` identifies the partition sizes in the image and mounts the raspbian image to the location specified by DIR (both root and boot partitions).  
`./unmount.sh DIR` unmounts both partitions mounted to DIR using the above script.  
`./qemu-setup.sh DIR` adds Qemu components to the image at the mount point specified by DIR.  
`./qemu-cleanup.sh DIR` removes Qemu components from the image at the mount point specified by DIR.  
`./qemu-launch.sh DIR` runs Qemu instance from the directory specified by DIR  
`./run.sh IMAGE [COMMAND]` wires all the above commands together to simplify launching an emulated environment with the provided IMAGE and optional COMMAND to execute.

If you have any questions, comments, or suggestions, feel free to open an issue or a pull request.  

