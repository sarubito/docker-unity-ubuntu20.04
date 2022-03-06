FROM nvidia/cuda:11.2.0-cudnn8-devel-ubuntu20.04

ARG CUDA_VERSION=cuda-11.2
ARG ROS_VERSION=noetic
ARG PYTHON_VERSION=python3
ARG TZ=Asia/Tokyo

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ ${TZ}

# ENV NVIDIA_VISIBLE_DEVICES=all
# ENV NVIDIA_DRIVER_CAPABILITIES=all

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update -y \
    && apt upgrade -y \
    && apt install -y --no-install-recommends \
    mesa-utils \
    x11-apps \
    git \
    vim \
    build-essential \
    curl \
    ca-certificates \
    wget \
    gnupg2 \
    lsb-release \ 
    mesa-utils \
    net-tools \
    iputils-ping \
    python3-pip \
    python3-tk \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
    libglvnd-dev libglvnd-dev \
    libgl1-mesa-dev \
    libegl1-mesa-dev \
    libgles2-mesa-dev \
    && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/python3.8 /usr/bin/python

ENV PATH="/usr/local/${CUDA_VERSION}/bin:${PATH}"
ENV LD_LIBRARY_PATH="/usr/local/${CUDA_VERSION}/lib64:$LD_LIBRARY_PATH"

## install cmake
WORKDIR /root/cmake
RUN wget https://github.com/Kitware/CMake/releases/download/v3.21.4/cmake-3.21.4.tar.gz
RUN tar -xvf cmake-3.21.4.tar.gz && rm -f cmake-3.21.4.tar.gz
WORKDIR /root/cmake/cmake-3.21.4
RUN bash bootstrap && make && make install

## Setting working directry
WORKDIR /root/WORKDIR

## install Unity
RUN sh -c 'echo "deb https://hub.unity3d.com/linux/repos/deb stable main" > /etc/apt/sources.list.d/unityhub.list'
RUN wget -qO - https://hub.unity3d.com/linux/keys/public | apt-key add -
RUN apt update -y && apt install -y --no-install-recommends unityhub