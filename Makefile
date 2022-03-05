PKGNAME := yowcow-erlang
PKGVERSION := 24.2.2
PKGRELEASE := 1
ARCH := amd64

URL := https://github.com/erlang/otp
PKGSOURCE := https://github.com/erlang/otp.git
TAG := OTP-$(PKGVERSION)
SOURCEDIR := $(PKGNAME)_$(PKGVERSION)

ARTIFACT := $(PKGNAME)_$(PKGVERSION)-$(PKGRELEASE)_$(ARCH).deb

all: JOBS := $(shell grep -c '^processor\>' /proc/cpuinfo)
all: $(SOURCEDIR)
	cd $< && \
		./otp_build autoconf && \
		./configure --prefix=/usr && \
		make -j $(JOBS)

$(SOURCEDIR):
	git clone -b $(TAG) --depth 1 -- $(PKGSOURCE) $@

build: $(ARTIFACT)

$(ARTIFACT): $(SOURCEDIR)/$(ARTIFACT)
	mv $< $@

$(SOURCEDIR)/$(ARTIFACT):
	cd $(dir $@) && \
		checkinstall \
			-D \
			--maintainer yowcow@gmail.com \
			--summary "Erlang OTP" \
			--pkgname $(PKGNAME) \
			--pkgversion $(PKGVERSION) \
			--pkgrelease $(PKGRELEASE) \
			--arch $(ARCH) \
			--pkgsource $(URL) \
			--conflicts erlang \
			-y \
			make install

clean:
	rm -rf $(SOURCEDIR)

realclean: clean
	rm -rf *.deb

.PHONY: all build clean realclean
