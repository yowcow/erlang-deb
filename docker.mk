TAG := 22.04
DOCKERFILE := ubuntu-$(TAG).Dockerfile
IMAGE := yowcow/erlang-build:ubuntu-$(TAG)

all:
	docker pull ubuntu:$(TAG)
	cat $(DOCKERFILE) | docker build -t $(IMAGE) -

build:
	docker run --rm -it \
		-v `pwd`:/work \
		-w /work \
		$(IMAGE) make all build

shell:
	docker run --rm -it \
		-v `pwd`:/work \
		-w /work \
		$(IMAGE) bash

clean:
	docker rmi $(IMAGE)

.PHONY: all build shell clean
