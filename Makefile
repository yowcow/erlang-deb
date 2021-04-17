REPOSITORY := https://github.com/erlang/otp.git
VERSION := 23.3.1
TAG := OTP-$(VERSION)

PKG_VER := $(VERSION)-1
ARCH := amd64
ARTIFACT := erlang_$(PKG_VER)_$(ARCH)

all: $(ARTIFACT)/usr $(ARTIFACT)/DEBIAN/control

$(ARTIFACT)/DEBIAN/control: DEBIAN/control $(ARTIFACT)/DEBIAN
	cat $< \
		| sed 's/{{PKG_VER}}/$(PKG_VER)/g' \
		| sed 's/{{ARCH}}/$(ARCH)/g' \
		> $@

$(ARTIFACT)/%:
	mkdir -p $@

build:
	$(MAKE) build-src
	$(MAKE) build-deb

build-src: $(TAG)
	cd $< \
		&& ./otp_build autoconf \
		&& ./configure --prefix=$(abspath $(ARTIFACT)/usr) \
		&& $(MAKE) all install

$(TAG):
	git clone -b $(TAG) --depth 1 -- $(REPOSITORY) $@

build-deb:
	dpkg-deb --build --root-owner-group $(ARTIFACT)

clean:
	$(MAKE) -C $(TAG) clean

realclean: clean
	rm -rf OTP-*
