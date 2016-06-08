FROM ubuntu

MAINTAINER Ryan Kurte <ryankurte@gmail.com>
LABEL Description="Qemu based emulation for raspberry pi using loopback images"

# Update package repository
RUN apt-get update 

# Install required packages
RUN apt-get install -y --allow-unauthenticated \
    qemu \
    qemu-user-static \ 
    binfmt-support \
    parted

# Clean up after apt
RUN apt-get clean && \
	rm -rf /var/lib/apt

# Setup working directory
RUN mkdir -p /usr/rpi
WORKDIR /usr/rpi

COPY expand.sh \
	mount.sh \
	qemu-setup.sh \
	qemu-cleanup.sh \
	unmount.sh \
	run.sh \
	/usr/rpi/


