FROM ubuntu:18.04
MAINTAINER Dmitry Lavnikevich <dmitry.lavnikevich@scalys.com>


# Use proxy if it is provided
ARG http_proxy
ENV http_proxy $http_proxy
ARG https_proxy
ENV https_proxy $https_proxy
ARG no_proxy
ENV no_proxy $no_proxy
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
RUN echo "Acquire::http::proxy \"$http_proxy\";" | tee -a /etc/apt/apt.conf && \
    echo "Acquire::https::proxy \"$https_proxy\";" | tee -a /etc/apt/apt.conf && \
    echo 'export PS1="\h:\W# "' | tee -a /root/.bashrc 1>/dev/null
RUN mkdir -p /home/builder && \
    echo 'export PS1="\h:\W$ "' | tee -a /home/builder/.bashrc 1>/dev/null

RUN rm -rf /var/lib/apt/lists/*

# Build/crossbuild/yocto essential packages
RUN apt-get update && \
    apt-get install -y \
    u-boot-tools device-tree-compiler autoconf automake dh-autoreconf zip kmod \
    libssl-dev openssl python-pip flex bison bc git gcc vim ethtool wget ftp   \
    make makedev tclsh binfmt-support qemu-system-common qemu-user-static      \
    debootstrap sudo ncurses-dev build-essential gdb u-boot-tools binutils-dev \
    gcc-arm-linux-gnueabihf crossbuild-essential-arm64 gcc-aarch64-linux-gnu   \
    file device-tree-compiler python python-dev curl libxml2-dev libelf-dev    \
    libsensors4-dev libssl-dev libedit-dev liblzma-dev tree libnuma-dev rsync  \
    libpcap-dev libtool mtd-utils libncurses5-dev net-tools libcunit1-dev cpio \
    pkg-config autotools-dev crossbuild-essential-armhf openssh-server ruby    \
    openssh-client crossbuild-essential-armhf qemu-utils g++-aarch64-linux-gnu \
    cpp-arm-linux-gnueabihf dosfstools iputils-ping libtclap-dev parted        \
    android-tools-fsutils rpm2cpio lsb-release xutils-dev libwayland-bin ssh   \
    cmake texinfo chrpath diffstat gawk binutils bzip2 gawk patch xz-utils     \
    python libsdl1.2-dev vim python3
RUN pip install six

# Set up user
RUN apt-get update && apt-get install -y sudo
RUN useradd --uid 1000 --no-log-init -r -g users builder && \
    echo "builder:users" | chpasswd && \
    adduser builder sudo
RUN sed -i 's/^%sudo.*/%sudo	ALL=(ALL:ALL) NOPASSWD:ALL/' /etc/sudoers

# Locales are needed for yocto build
RUN apt-get update && \
    apt-get install -y locales && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen
ENV LC_ALL "en_US.UTF-8"
ENV LANG "en_US.UTF-8"
ENV LANGUAGE "en_US.UTF-8"

USER builder
