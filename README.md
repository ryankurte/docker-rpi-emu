# Docker emulation environment for Raspberry Pi

Are you sick of long compile times on your Raspberry Pi?  
How much time have you spent loading Raspbian images from raspberrypi.org and hand customising them?  
Do you too wish you could run Raspberry Pi apps in a docker container against a persistant .img file inside xhyve on macOS?
Then this is the project for you!  

This project provides a dockerised (err, containerised) Qemu based emulated environment for the Raspberry Pi, useful for building Raspberry Pi based projects on x64 computers, and for customising Raspbian images for distribution.  

Please note that this is very new. It works pretty well uner linux and OSX for emulation and for creating images to deploy, but YMMV.  
It's also not a very good docker container, requiring priveledged mode to mount loopback adaptors and qemu on the docker host. All the scripts here can be run on native linux if you're that way inclined.

Check it out on [Github](https://github.com/ryankurte/docker-rpi-emu/) or [Dockerhub](https://hub.docker.com/r/ryankurte/docker-rpi-emu/)  

![Example](https://raw.github.com/ryankurte/docker-rpi-emu/gh_pages/screenshots/02.png)

## Usage

Note that your docker host machine must have qemu installed. Using Docker for Mac the host environment includes this as standard (OSX docker-machines however do not come with qemu), in Debian you will need to install the qemu and qemu-user-static packages.  

### From the Repo

To get started with an Emulated CLI:

1. Run `git clone git@github.com:ryankurte/docker-rpi-emu.git` check out this repository
2. Run `cd docker-rpi-emu` to change into the directory
3. Run `make run-emu` to launch the emulated environment

This will bootstrap a Raspbian image from raspberrypi.org, build the docker image, and launch the emulated environment.  

For examples of how to customise this, checkout the [Makefile](Makefile).  

### From Dockerhub

To get started with Docker, first pull the image with `docker pull ryankurte/docker-rpi-emu`.  

Ensure you have a Raspbian image handy (and you may want to back this up, it will be modified by anything you do in the emulated environment), then run the following command.  

`docker run -it --rm --privileged=true -v IMAGE_LOCATION:/usr/rpi/images -w /usr/rpi ryankurte/docker-rpi-emu /bin/bash -c './run.sh images/IMAGE_NAME [COMMAND]'`  

Where IMAGE_LOCATION is the directory containing your Raspbian image to be mounted, IMAGE_NAME is the name of the image to be used, and [COMMAND] is the optional command to be executed (inside the image).  

For example:  

`docker run -it --rm --privileged=true -v /Users/ryan/projects/docker-rpi-emu/images:/usr/rpi/images -w /usr/rpi ryankurte/docker-rpi-emu /bin/bash -c './run.sh images/2016-05-27-raspbian-jessie-lite.img /bin/bash'`  

Will mount the image directory `/Users/ryan/projects/docker-rpi-emu/images` and the image `2016-05-27-raspbian-jessie-lite.img` then run the command `/bin/bash` in the emulated environment.  


## Components

The docker container includes the required Qemu components to support emulation. This must be launched in privileged mode to allow mounting of loopback devices.  

The container also includes a set of scripts to streamline the loading/customization/launch/unloading of Qemu environments, which are installed into the `/usr/rpi` directory on the device.  


## Commands

Commands are installed into the `/usr/rpi` directory of the docker image.  

`./mount.sh IMAGE DIR` identifies the partition sizes in the image and mounts the raspbian image to the location specified by DIR (both root and boot partitions).  
`./unmount.sh DIR` unmounts both partitions mounted to DIR using the above script.  
`./qemu-setup.sh DIR` adds Qemu components to the image at the mount point specified by DIR.  
`./qemu-cleanup.sh DIR` removes Qemu components from the image at the mount point specified by DIR.  
`./qemu-launch.sh DIR` runs Qemu instance from the directory specified by DIR  
`./run.sh IMAGE [COMMAND]` wires all the above commands together to simplify launching an emulated environment with the provided IMAGE and optional COMMAND to execute.

If you have any questions, comments, or suggestions, feel free to open an issue or a pull request.  

