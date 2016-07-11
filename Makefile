# define setup variables
DDNSTOKEN  ?= $(shell read -p "DuckDNS token:  "; echo $$REPLY)
DDNSDOMAIN ?= $(shell read -p "DuckDNS domain: "; echo $$REPLY)

# install all
all: openvpn dyndns wemo


# run openvpn setup
openvpn:
	cd OpenVPN-Setup && \
		setup.sh

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
