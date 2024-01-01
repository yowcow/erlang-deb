PKGVERSION = 26.2.1
PKGRELEASE = 1
UBUNTU_RELEASE = $(shell lsb_release -sr)
PROCESSOR = $(shell uname -p)

ifeq ($(PROCESSOR),x86_64)
ARCH = amd64
else
ARCH = $(PROCESSOR)
endif

SRCDIR = erlang-$(PKGVERSION)
ARTIFACT = yowcow-erlang.$(PKGVERSION)-$(PKGRELEASE).ubuntu-$(UBUNTU_RELEASE).$(ARCH).deb
DESTDIR = /tmp/erlang-otp

all: JOBS = $(shell grep -c '^processor\>' /proc/cpuinfo)
all: $(SRCDIR)
	cd $< \
		&& ./configure --prefix=/usr \
		&& make -j $(JOBS)

$(SRCDIR): REPOSITORY = https://github.com/erlang/otp.git
$(SRCDIR): TAG = OTP-$(PKGVERSION)
$(SRCDIR):
	git clone -b $(TAG) --depth 1 -- $(REPOSITORY) $@

build: $(ARTIFACT)

%.deb: $(DESTDIR)
	$(MAKE) $(DESTDIR)/DEBIAN/control
	dpkg-deb --build $< $@

$(DESTDIR): $(SRCDIR)
	cd $< \
		&& $(MAKE) DESTDIR=$@ install

$(DESTDIR)/DEBIAN/control: DEBIAN/control $(DESTDIR)
	mkdir -p $(dir $@)
	cat $< \
		| sed -e 's/{{PKGVERSION}}/$(PKGVERSION)/g' \
		| sed -e 's/{{PKGRELEASE}}/$(PKGRELEASE)/g' \
		| sed -e 's/{{ARCH}}/$(ARCH)/g' \
		> $@

clean:
	rm -rf *.deb /tmp/erlang-otp

.PHONY: all build clean
