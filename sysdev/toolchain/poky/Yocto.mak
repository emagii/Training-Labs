YOCTO_ENV=./oe-init-build-env
MACHINE=beaglebone

ifneq ("$(wildcard $(YOCTO_ENV))","")
YOCTO_ENV_EXISTS = 1
SCRIPTS_BASE_VERSION	:= $(shell source $(YOCTO_ENV) ; echo $$SCRIPTS_BASE_VERSION)
BBFETCH2		:= $(shell source $(YOCTO_ENV) ; echo $$BBFETCH2)
DISTRO			:= $(shell source $(YOCTO_ENV) ; echo $$DISTRO)
DISTRO_DIRNAME		:= $(shell source $(YOCTO_ENV) ; echo $$DISTRO_DIRNAME)
OE_BUILD_DIR		:= $(shell source $(YOCTO_ENV) ; echo $$OE_BUILD_DIR)
BUILDDIR		:= $(shell source $(YOCTO_ENV) ; echo $$BUILDDIR)
OE_BUILD_TMPDIR		:= $(shell source $(YOCTO_ENV) ; echo $$OE_BUILD_TMPDIR)
OE_SOURCE_DIR		:= $(shell source $(YOCTO_ENV) ; echo $$OE_SOURCE_DIR)
OE_LAYERS_TXT		:= $(shell source $(YOCTO_ENV) ; echo $$OE_LAYERS_TXT)
OE_BASE			:= $(shell source $(YOCTO_ENV) ; echo $$OE_BASE)
PATH			:= $(shell source $(YOCTO_ENV) ; echo $$PATH)
BB_ENV_EXTRAWHITE	:= $(shell source $(YOCTO_ENV) ; echo $$BB_ENV_EXTRAWHITE)
BBPATH			:= $(shell source $(YOCTO_ENV) ; echo $$BBPATH)
sdk:	build/tmp/deploy/sdk
	@echo	"Done"
else
YOCTO_ENV_EXISTS = 0
sdk:	build
	@echo "Environment was not set,rerun"
endif

build:	
	.	$(YOCTO_ENV)

build/tmp/deploy/sdk:	$(YOCTO_ENV)
	bitbake meta-toolchain-sdk

.PHONY:	config sdk

debug:
	echo BUILDDIR=$(BUILDDIR)
