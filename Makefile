PKGNAME := yowcow_erlang
PKGVERSION := 25.3.2
PKGRELEASE := 1
ARCH := amd64

REPOSITORY := https://github.com/erlang/otp.git
TAG := OTP-$(PKGVERSION)

SOURCE_DIR := src/$(PKGNAME)-$(PKGVERSION)
ARTIFACT_DIR := $(abspath dist/$(PKGNAME)-$(PKGVERSION)-$(PKGRELEASE).ubuntu$(shell lsb_release -r -s).$(ARCH))
ARTIFACT := $(ARTIFACT_DIR).deb

all: JOBS := $(shell grep -c '^processor\>' /proc/cpuinfo)
all: $(SOURCE_DIR)
	cd $< \
		&& ./configure --prefix=/usr \
		&& make -j $(JOBS)

$(SOURCE_DIR):
	mkdir -p $(dir $@)
	git clone -b $(TAG) --depth 1 -- $(REPOSITORY) $@

build: $(ARTIFACT)

$(ARTIFACT): $(ARTIFACT_DIR) $(ARTIFACT_DIR)/DEBIAN/control
	dpkg-deb --build $<

$(ARTIFACT_DIR): $(SOURCE_DIR)
	cd $< \
		&& make DESTDIR=$@ install

$(ARTIFACT_DIR)/DEBIAN/%: ./DEBIAN/%
	mkdir -p $(dir $@)
	cat $< \
		| sed -e 's/{{PKGVERSION}}/$(PKGVERSION)/g' \
		| sed -e 's/{{PKGRELEASE}}/$(PKGRELEASE)/g' \
		| sed -e 's/{{ARCH}}/$(ARCH)/g' \
		> $@

clean:
	rm -rf dist

realclean: clean
	rm -rf src

.PHONY: all build clean realclean
