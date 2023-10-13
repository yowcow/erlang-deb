FROM ubuntu:23.10

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
