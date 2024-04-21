FROM desktopcontainers/base-debian

#MAINTAINER MarvAmBass (https://github.com/DesktopContainers)

RUN apt-get -q -y update && \
    apt-get -q -y install wget \
                          telnet \
                          unzip \
                          qemu-system-arm \
                          util-linux && \
    apt-get -q -y clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY scripts/* /usr/local/bin/

RUN wget -O raspbian-lite.zip https://downloads.raspberrypi.org/raspbian_lite_latest && \
    unzip raspbian-lite.zip && \
    rm raspbian-lite.zip && \
    mv *.img /raspberry.img && \
    mkdir /images && \
    wget -O /kernel "https://github.com/dhruvvyas90/qemu-rpi-kernel/blob/master/kernel-qemu-4.4.34-jessie?raw=true" && \
    sed -i 's/starting services"/starting services"\n\npatch-image.sh \/raspberry.img || exit 1\n\n/g' /usr/local/bin/entrypoint.sh && \
    chmod a+rw /raspberry.img /kernel && \
    echo "rpi.sh \$*" >> /usr/local/bin/ssh-app.sh

EXPOSE 2222
VOLUME ["/images"]

HEALTHCHECK CMD ["/usr/local/bin/docker-healthcheck"]
