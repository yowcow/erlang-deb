UBUNTU_RELEASE = 22.04
DOCKER_IMAGE = yowcow/erlang-build:ubuntu-$(UBUNTU_RELEASE)

all: Dockerfile
	docker build \
		--build-arg="UBUNTU_RELEASE=$(UBUNTU_RELEASE)" \
		-t $(DOCKER_IMAGE) \
		-f $< \
		.

build:
	docker run --rm \
		-v `pwd`/otp:/app:rw \
		-w /app \
		$(DOCKER_IMAGE) make all build

clean:
	docker run --rm \
		-v `pwd`/otp:/app:rw \
		-w /app \
		$(DOCKER_IMAGE) make clean

shell:
	docker run --rm -it \
		-v `pwd`/otp:/app:rw \
		-w /app \
		$(DOCKER_IMAGE) bash

.PHONY: all build clean shell
