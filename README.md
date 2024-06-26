# Raspberry Pi
_Raspberry Pi virtual machine in Qemu_

This is a container for emulating the raspbian lite distribution inside a qemu emulated raspberry pi.

You can get the QEMU Window via _ssh -X/VNC/noVNC (http)_. You can also directly connect to the qemu raspberry on port 2222.

You can only connect once to one container. if you want multiple raspberrys, run the docker container multiple times.

You can preserve the image by mounting the volume /images to an persistent volume.
Also if you supply it with a qemu patched raspberry pi image with the name __raspberry.img__ qemu will start this image right away.

_Attention: If you use ssh -X to get the qemu window - running instances of the qemu raspberry will be killed and boot again (which takes some time), better use novnc or vnc if you want raspberry with gui_

_The Docker Healthcheck checks if ssh of raspberry is reachable_

It's based on __DesktopContainers/base-mate__

## Usage: Run the Client


### Simple SSH X11 Forwarding

You can either connect via ssh to the qemu raspberry rasbian system or get the qemu X11 GUI, here is how you use it:

  1. Run a background container as server or start existing one.

        docker start raspberrypi || docker run -d --name raspberrypi -p 2222:2222 -p 80:80 -p 443:443 --privileged desktopcontainers/raspberrypi
     
  2.1 Connect directly to the qemu raspberry via ssh. (Keep an eye on docker healthcheck status - ssh is available when it's healthy)
  
        ssh -p 2222 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no pi@localhost
        
  2.2 See the qemu environment (window) on http://localhost

## Options and Configuration

### Volumes

* __/images__ _place where the raspberry pi image will be stored as_ __raspberry.img__


### Exposed Ports

* __2222__ _for ssh connection to the qemu raspberry pi (raspbian lite)_

### Passwords

* __User:__ pi
* __Password:__ raspberry

### Environment variables and defaults

* __FS\_EXTEND\_GB__
 * default: _8_ - can be any number to increase fs size of rootfs.
* __RC\_LOCAL\_COMAND__
 * no default - bash comands to include in rc.local

# optionally, once connected as user pi (use ssh or use QEMU console on http://localhost ), ypu can execute commands on the rpi:
# first modify apt sources to legacy, then
# sudo apt update; sudo apt install xserver-xorg raspberrypi-ui-mods
# sudo apt upgrade
# sudo apt install fwbuilder fwbuilder-common
#useful links
# https://www.qemu.org/
# https://hub.docker.com/r/desktopcontainers/raspberrypi
# https://github.com/DesktopContainers/raspberrypi/blob/master/README.md
# https://github.com/dhruvvyas90/qemu-rpi-kernel/tree/master
# https://debian.pkgs.org/11/debian-main-amd64/fwbuilder_5.3.7-4.1_amd64.deb.html
# https://github.com/DesktopContainers/base-debian
# https://github.com/lukechilds/dockerpi
# https://github.com/DesktopContainers

#if vnc doesn't start, remove the lock files
docker exec raspberrypi rm -rf /tmp/.X1-lock
docker exec -it raspberrypi rm -rf /tmp/.X11-unix/X1