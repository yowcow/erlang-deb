IMAGE := yowcow/ubuntu-erlang-build

all:
	docker build -t $(IMAGE) .

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

.PHONY: all build shell
