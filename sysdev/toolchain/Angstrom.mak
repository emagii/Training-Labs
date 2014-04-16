ANGSTROM_ENV=environment-angstrom-v2013.06
MACHINE=beaglebone

sdk:	deploy/sdk

config:	$(ANGSTROM_ENV)

$(ANGSTROM_ENV):	
	./oebb.sh config beaglebone


deploy/sdk:	$(ANGSTROM_ENV)
	source $(ANGSTROM_ENV) ; MACHINE=$(MACHINE) ; echo BUILDDIR=$(BUILDDIR)

.PHONY:	config sdk


