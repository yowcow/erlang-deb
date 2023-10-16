ARG UBUNTU_RELEASE=22.04
FROM ubuntu:${UBUNTU_RELEASE}

ENV DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    apt-get update && \
    apt-get install -yq \
        build-essential \
        git \
        autoconf \
        libncurses-dev \
        libssl-dev \
        lsb-release
