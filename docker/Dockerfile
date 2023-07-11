FROM ubuntu:22.04
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
    echo "Acquire::https::proxy \"$https_proxy\";" | tee -a /etc/apt/apt.conf

RUN echo 'export PS1="\h:\W# "' | tee -a "/root/.bashrc" > /dev/null
RUN echo 'export PS1="\h:\W$ "' | tee -a "/home/${USER}/.bashrc" > /dev/null

RUN rm -rf /var/lib/apt/lists/*

# Build/crossbuild/yocto essential packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    sudo build-essential curl libcurl4-openssl-dev libssl-dev wget python3 \
    python3-pip python3-dev git tar libatlas-base-dev cmake bison flex \
    python3-pip bc kmod chrpath cpio diffstat gawk file vim

# Set up user
RUN apt-get update && apt-get install -y sudo
ARG USER
ARG UID
ARG GID
RUN groupadd "$USER" --gid "$GID"
RUN useradd -m ${USER} --uid=${UID} --gid=${GID}
RUN echo "ALL ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Set up prompt
RUN echo 'export PS1="\h:\W# "' | tee -a "/root/.bashrc" > /dev/null
RUN echo 'export PS1="\h:\W$ "' | tee -a "/home/${USER}/.bashrc" > /dev/null

# Locales are needed for yocto build
RUN apt-get update && \
    apt-get install -y locales && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen
ENV LC_ALL "en_US.UTF-8"
ENV LANG "en_US.UTF-8"
ENV LANGUAGE "en_US.UTF-8"

USER "$USER"

