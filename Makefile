# define setup variables
DDNSTOKEN  ?= $(shell read -p "DuckDNS token:  "; echo $$REPLY)
DDNSDOMAIN ?= $(shell read -p "DuckDNS domain: "; echo $$REPLY)

VENV=venv
PIP=$(VENV)/bin/pip

# install all
all: openvpn dyndns wemo

requirements:
	apt-get update
	apt-get upgrade
	apt-get install -y build-essential autoconf libtool pkg-config python-opengl \
		python-imaging python-pyrex python-pyside.qtopengl idle-python2.7 python-dev \
		qt4-dev-tools qt4-designer libqtgui4 libqtcore4	libqt4-xml libqt4-test \
		libqt4-script libqt4-network libqt4-dbus python-qt4 python-qt4-gl libgle3
	apt-get install -y git ffmpeg libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev \
		libsdl2-ttf-dev libportmidi-dev libswscale-dev libavformat-dev \
		libavcodec-dev zlib1g-dev
	apt-get install -y opengl freeglut3 freeglut3-dev libglew1.5 libglew1.5-dev \
		libglu1-mesa libglu1-mesa-dev libgl1-mesa-glx libgl1-mesa-dev
	apt-get install qtdeclarative5-dev
	apt-get install --reinstall libgl1-mesa-glx
	apt-get install mosh

venv:
	pip install virtualenv
	virtualenv $(VENV)
	$(PIP) install cython

# run openvpn setup
openvpn:
	curl -L https://install.pivpn.io | bash

# install dyndns
dyndns:
	# set persistent env variables
	@echo $(DDNSTOKEN)
	# write config file

	# run ddclient setup

##########
## WEMO ##
##########
wemo: wemo-cron

wemo-install:
	# install ouimeaux
	pip install ouimeaux[server]
	# discover device, set and persist WEMO variable

# wemo install auto-off and power monitor
wemo-cron: wemo-install
	# setup cron to auto off on no load

	# setup powerlog

# KIVY stuff

KIVYDESIGNER=kivy-designer
kivy:
	$(PIP) install -r $(KIVYDESIGNER)/requirements.txt
