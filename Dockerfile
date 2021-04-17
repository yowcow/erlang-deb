FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    apt-get update && \
    apt-get install -yq \
        build-essential \
        git \
        autoconf \
        libncurses-dev \
        libssl-dev
