# define setup variables
DDNSTOKEN  ?= $(shell read -p "DuckDNS token:  "; echo $$REPLY)
DDNSDOMAIN ?= $(shell read -p "DuckDNS domain: "; echo $$REPLY)

VENV=venv
PIP=$(VENV)/bin/pip

# install all
all: openvpn dyndns wemo

requirements:
	apt-get update
	apt-get upgrade -y
	apt-get dist-upgrade
	apt-get install -y raspberrypi-ui-mods
	apt-get install -y raspberrypi-net-mods
	apt-get install -y git
	apt-get install -y mosh

# NFSv4 server
nfs:
	apt-get install -y nfs-common nfs-kernel-server
	mkdir -p /srv/nfs4 && ln -s $(HOME) /srv/nfs4/share
	echo "/srv/nfs4/share apfelbuch(rw,sync,no_subtree_check)" >> /etc/exports
	# backup scripts
	cp /etc/init.d/nfs-kernel-server /etc/init.d/nfs-kernel-server.pristine
	cp /etc/default/nfs-kernel-server /etc/default/nfs-kernel-server.pristine
	cp /etc/default/nfs-common /etc/default/nfs-common.pristine
	# copy RPi NFS init scripts
	cp nfs/nfs-kernel-server.script /etc/init.d/nfs-kernel-server
	cp nfs/nfs-kernel-server.cfg /etc/default/nfs-kernel-server
	cp nfs/nfs-common /etc/default/nfs-common
	# start NFS server
	service nfs-kernel-server start


# dynamic DNS (duckdns)
ddns:
	mkdir $(HOME)/duckdns
	cp duckdns/duck.sh $(HOME)/duckdns/duck.sh

# secure RPi
secure:
	apt-get install -y rpi-update
	rpi-update
	# stengthen SSH policies (no external password authentication)
	cp secure/sshd_config /etc/ssh/sshd_config
	# install and configure fail2ban
	apt-get install -y fail2ban
	cp secure/jail.conf /etc/fail2ban/
	cp secure/jail.local /etc/fail2ban/
	cp secure/fail2ban.conf /etc/fail2ban/
	cp secure/iptables-allports.conf /etc/fail2ban/action.d/

fail2ban-check:
	iptables -L -n --line

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
kivy-install:
	echo "deb http://vontaene.de/raspbian-updates/ . main" >> /etc/apt/sources.list
	gpg --keyserver pgp.mit.edu --recv-keys 0C667A3E
	gpg -a --export 0C667A3E | sudo apt-key add -
	apt-get update
	apt-get -y install pkg-config libgl1-mesa-dev libgles2-mesa-dev \
		python-pygame python-setuptools \
		libgstreamer1.0-dev \
		gstreamer1.0-plugins-bad \
		gstreamer1.0-plugins-base \
		gstreamer1.0-plugins-good \
		gstreamer1.0-plugins-ugly \
		gstreamer1.0-omx \
		gstreamer1.0-alsa \
		python-dev
	pip install pip --upgrade
	pip install cython pygments docutils
	git clone https://github.com/kivy/kivy && \
		cd kivy && \
		python setup.py build && \
 		python setup.py install
	mkdir -p $(HOME)/.kivy && cp kivy/config.ini $(HOME)/.kivy/
