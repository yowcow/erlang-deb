erlang-deb
==========

Erlang deb package

HOW TO USE
----------


HOW TO BUILD
------------

To create a deb package:

    make all build

To create a package in a docker container:

    make -f docker.mk all build

To install a package:

    sudo dpkg -i erlang_23.3.1-1_amd64.deb

To uninstall:

    sudo dpkg -r erlang
