PKGNAME := yowcow-erlang
PKGVERSION := 24.3.3
PKGRELEASE := 2
ARCH := amd64

REPOSITORY := https://github.com/erlang/otp.git
TAG := OTP-$(PKGVERSION)

PACKAGE := $(PKGNAME)_ubuntu$(shell lsb_release -r -s)_$(PKGVERSION)
SOURCE_DIR := $(PACKAGE)-src
ARTIFACT_DIR := $(abspath $(PACKAGE)-$(PKGRELEASE)_$(ARCH))
ARTIFACT := $(ARTIFACT_DIR).deb

all: JOBS := $(shell grep -c '^processor\>' /proc/cpuinfo)
all: $(SOURCE_DIR)

$(SOURCE_DIR):
	git clone -b $(TAG) --depth 1 -- $(REPOSITORY) $@

build: $(ARTIFACT)

$(ARTIFACT): $(ARTIFACT_DIR) $(ARTIFACT_DIR)/DEBIAN/control
	dpkg-deb --build $<

$(ARTIFACT_DIR): JOBS := $(shell grep -c '^processor\>' /proc/cpuinfo)
$(ARTIFACT_DIR): $(SOURCE_DIR)
	cd $< \
		&& ./configure --prefix=$(ARTIFACT_DIR)/usr \
		&& make -j $(JOBS) \
		&& make install

$(ARTIFACT_DIR)/DEBIAN/%: DEBIAN/%
	mkdir -p $(dir $@)
	cat $< \
		| sed -e 's/{{PKG_VER}}/$(PKGVERSION)-$(PKGRELEASE)/g' \
		| sed -e 's/{{ARCH}}/$(ARCH)/g' \
		> $@

clean:
	rm -rf $(ARTIFACT_DIR) $(ARTIFACT)

realclean: clean
	rm -rf $(SOURCE_DIR)

.PHONY: all build clean realclean
