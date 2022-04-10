# SPDX-License-Identifier: GPL-2.0
VERSION = 1
PATCHLEVEL = 0
SUBLEVEL = 0
EXTRAVERSION = -rc1
NAME = unstable

PHONY := _all
_all:

MAKEFLAGS += -rR --no-print-directory

ifeq ("$(origin V)", "command line")
  MBUILD_VERBOSE = $(V)
endif
ifndef MBUILD_VERBOSE
  MBUILD_VERBOSE = 0
endif

ifeq ($(MBUILD_VERBOSE),1)
  quiet =
  Q =
else
  quiet=quiet_
  Q = @
endif

ifeq ("$(origin O)", "command line")
	O_LEVEL = $(O)
endif
ifndef O_LEVEL
	O_LEVEL = 2
endif

export quiet Q MBUILD_VERBOSE

srctree 	:= .
objtree		:= .
src		:= $(srctree)
obj		:= $(objtree)

export srctree objtree 

version_h := include/config/version.h

clean-targets := %clean

include scripts/Minos.config.mk

KERNELVERSION = $(VERSION)$(if $(PATCHLEVEL),.$(PATCHLEVEL)$(if $(SUBLEVEL),.$(SUBLEVEL)))$(EXTRAVERSION)
export VERSION PATCHLEVEL SUBLEVEL KERNELVERSION

ARCH		= aarch64
CROSS_COMPILE 	= aarch64-linux-gnu-

SRCARCH 	:= $(ARCH)

MCONFIG_CONFIG	?= .config
export MCONFIG_CONFIG

# Make variables (CC, etc...)
AS		= $(CROSS_COMPILE)as
LD		= $(CROSS_COMPILE)ld
CC		= $(CROSS_COMPILE)gcc
CPP		= $(CC) -E
AR		= $(CROSS_COMPILE)ar
NM		= $(CROSS_COMPILE)nm
STRIP		= $(CROSS_COMPILE)strip
OBJCOPY		= $(CROSS_COMPILE)objcopy
OBJDUMP		= $(CROSS_COMPILE)objdump
LEX		= flex
YACC		= bison
AWK		= awk
PERL		= perl
PYTHON		= python
PYTHON2		= python2
PYTHON3		= python3
CHECK		= sparse
DTC		= dtc

# Use LINUXINCLUDE when you must reference the include/ directory.
# Needed to be compatible with the O= option
MINOSINCLUDE    := \
		-I$(srctree)/arch/$(SRCARCH)/include \
		-I$(objtree)/include

CSTD_FLAG := -std=gnu11
MBUILD_DEFINE := -D__KERNEL__
NOSTDINC_FLAGS += -nostdinc 

MBUILD_CFLAGS   := 	-Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
		   			-fno-strict-aliasing -fno-common -fshort-wchar \
		   			-Werror-implicit-function-declaration \
		   			-Wno-format-security -O$(O_LEVEL) \
		   			$(CSTD_FLAG) --static -nostdlib -fno-builtin	\
					-g $(MINOSINCLUDE) $(MBUILD_DEFINE) $(NOSTDINC_FLAGS)

MBUILD_AFLAGS   := -D__ASSEMBLY__ $(MBUILD_CFLAGS)
MBUILD_LDFLAGS := --no-undefined

export ARCH SRCARCH CROSS_COMPILE AS LD CC DTC
export CPP AR NM STRIP OBJCOPY OBJDUMP 
export MAKE LEX YACC AWK GENKSYMS PERL PYTHON PYTHON2 PYTHON3 

export NOSTDINC_FLAGS MINOSINCLUDE OBJCOPYFLAGS MBUILD_LDFLAGS
export MBUILD_CFLAGS 
export MBUILD_AFLAGS 

export RCS_FIND_IGNORE := \( -name SCCS -o -name BitKeeper -o -name .svn -o    \
			  -name CVS -o -name .pc -o -name .hg -o -name .git \) \
			  -prune -o
export RCS_TAR_IGNORE := --exclude SCCS --exclude BitKeeper --exclude .svn \
			 --exclude CVS --exclude .pc --exclude .hg --exclude .git

PHONY += all
_all: all

core-y		:=
drivers-y	:= driver/
external-y	:=
libs-y		:=

-include .config

# The arch Makefile can set ARCH_{CPP,A,C}FLAGS to override the default
# values of the respective MBUILD_* variables
ARCH_AFLAGS :=
ARCH_CFLAGS :=
export ARCH_CFLAGS ARCH_AFLAGS

-include arch/$(SRCARCH)/Makefile

MBUILD_IMAGE 	:= ee.bin
MBUILD_IMAGE_ELF := ee.elf
MBUILD_IMAGE_SYMBOLS := allsymbols.o

all: include/config/config.h $(version_h) minos

minos-dirs	:= $(patsubst %/,%,$(filter %/, $(core-y) $(external-y) $(drivers-y) $(libs-y)))

minos-alldirs	:= $(sort $(minos-dirs) $(patsubst %/,%,$(filter %/, \
			$(core-) $(external-) $(drivers-) $(libs-))))

minos-clean-dirs = $(minos-dirs)
minos-cleandirs = $(minos-alldirs)

core-y		:= $(patsubst %/, %/built-in.o, $(core-y))
external-y	:= $(patsubst %/, %/built-in.o, $(external-y))
drivers-y	:= $(patsubst %/, %/built-in.o, $(drivers-y))
libs-y1		:= $(patsubst %/, %/lib.a, $(libs-y))
libs-y2		:= $(patsubst %/, %/built-in.o, $(filter-out %.o, $(libs-y)))

# Externally visible symbols (used by link-minos.sh)
export MBUILD_MINOS_INIT := $(head-y)
export MBUILD_MINOS_MAIN := $(core-y) $(libs-y2) $(drivers-y) $(external-y)
export MBUILD_MINOS_LIBS := $(libs-y1)
export MBUILD_LDS          := $(objtree)/arch/$(SRCARCH)/lds/minos.lds
export LDFLAGS_minos

minos-deps := $(MBUILD_LDS) $(MBUILD_MINOS_INIT) $(MBUILD_MINOS_MAIN) $(MBUILD_MINOS_LIBS)

CLEAN_DIRS	:=
clean: rm-dirs 	:= $(CLEAN_DIRS)
clean-dirs      := $(addprefix _clean_, . $(minos-cleandirs))

minos_LDFLAGS := $(MBUILD_LDFLAGS)
minos_LDFLAGS += -T$(MBUILD_LDS) -Map=$(srctree)/linkmap.txt

PHONY += $(clean-dirs) clean distclean
$(clean-dirs):
	$(Q) $(MAKE) $(clean)=$(patsubst _clean_%,%,$@)

minos: $(minos-deps) scripts/generate_allsymbols.py
	$(Q) echo "  LD      .tmp.minos.elf"
	$(Q) $(LD) $(minos_LDFLAGS) -o .tmp.minos.elf $(MBUILD_MINOS_INIT) $(MBUILD_MINOS_MAIN) $(MBUILD_MINOS_LIBS)
	$(Q) echo "  NM      .tmp.minos.symbols"
	$(Q) $(NM) -n .tmp.minos.elf > .tmp.minos.symbols
	$(Q) echo "  PYTHON  allsymbols.S"
	$(Q) python3 scripts/generate_allsymbols.py .tmp.minos.symbols allsymbols.S
	$(Q) echo "  CC      $(MBUILD_IMAGE_SYMBOLS)"
	$(Q) $(CC) $(CCFLAG) $(MBUILD_CFLAGS) -c allsymbols.S -o $(MBUILD_IMAGE_SYMBOLS)
	$(Q) echo "  LD      $(MBUILD_IMAGE_ELF)"
	$(Q) $(LD) $(minos_LDFLAGS) -o $(MBUILD_IMAGE_ELF) $(MBUILD_MINOS_INIT) $(MBUILD_MINOS_MAIN) $(MBUILD_MINOS_LIBS) $(MBUILD_IMAGE_SYMBOLS)
	$(Q) echo "  OBJCOPY $(MBUILD_IMAGE)"
	$(Q) $(OBJCOPY) -O binary $(MBUILD_IMAGE_ELF) $(MBUILD_IMAGE)
	$(Q) echo "  OBJDUMP minos.s"
	$(Q) $(OBJDUMP) $(MBUILD_IMAGE_ELF) -D > minos.s

# The actual objects are generated when descending,
# make sure no implicit rule kicks in
$(sort $(minos-deps)): $(minos-dirs) 

# here goto each directory to generate built-in.o
PHONY += $(minos-dirs)
$(minos-dirs):
	$(Q)$(MAKE) $(build)=$@

define sed-y
    "/^->/{s:->#\(.*\):/* \1 */:; \
    s:^->\([^ ]*\) [\$$#]*\([^ ]*\) \(.*\):#define \1 \2 /* \3 */:; \
    s:->::; p;}"
endef

define filechk_version.h
	(echo \#define MINOS_VERSION_CODE $(shell                         \
	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 0$(SUBLEVEL)) > $@; \
	echo '#define MINOS_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))' >> $@; \
	echo '#define MINOS_VERSION_STR "v$(VERSION).$(PATCHLEVEL).$(SUBLEVEL)$(EXTRAVERSION) $(NAME)"' >> $@;)
endef

PHONY += scriptconfig iscriptconfig menuconfig guiconfig dumpvarsconfig

PYTHONCMD ?= python3
kpython := PYTHONPATH=$(srctree)/scripts/Kconfiglib:$$PYTHONPATH $(PYTHONCMD)
KCONFIG ?= $(srctree)/Kconfig

ifneq ($(filter scriptconfig,$(MAKECMDGOALS)),)
ifndef SCRIPT
$(error Use "make scriptconfig SCRIPT=<path to script> [SCRIPT_ARG=<argument>]")
endif
endif

$(version_h) : Makefile
	$(Q) mkdir -p include/config
	$(Q) $(call filechk_version.h)

PHONY += include/config/config.h
include/config/config.h: .config
	$(Q) mkdir -p include/config
	$(Q) $(kpython) $(srctree)/scripts/Kconfiglib/genconfig.py --header-path=include/config/config.h

clean: $(clean-dirs)
	$(Q) echo "  CLEAN   all .o .*.d *.dtb built-in.o"
	$(Q) echo "  CLEAN   allsymbols.o allsymbols.S linkmap.txt minos.s .tmp.minos.elf .tmp.minos.symbols minos.bin minos.elf"
	$(Q) rm -f allsymbols.o allsymbols.S linkmap.txt minos.s .tmp.minos.elf .tmp.minos.symbols minos.bin minos.elf

distclean: clean
	$(Q) echo "  CLEAN   .config include/config"
	$(Q) rm -rf include/config .config .config.old
	$(Q) echo "  CLEAN   tags cscope.in.out cscope.out cscope.po.out"
	$(Q) rm -f tags cscope.in.out cscope.out cscope.po.out

scriptconfig:
	$(Q)$(kpython) $(SCRIPT) $(Kconfig) $(if $(SCRIPT_ARG),"$(SCRIPT_ARG)")

iscriptconfig:
	$(Q)$(kpython) -i -c \
	  "import kconfiglib; \
	   kconf = kconfiglib.Kconfig('$(Kconfig)'); \
	   print('A Kconfig instance \'kconf\' for the architecture $(ARCH) has been created.')"

menuconfig:
	$(Q)$(kpython) $(srctree)/scripts/Kconfiglib/menuconfig.py $(Kconfig)

guiconfig:
	$(Q)$(kpython) $(srctree)/scripts/Kconfiglib/guiconfig.py $(Kconfig)

dumpvarsconfig:
	$(Q)$(kpython) $(srctree)/scripts/Kconfiglib/examples/dumpvars.py $(Kconfig)

genconfig:
	$(Q)$(kpython) $(srctree)/scripts/Kconfiglib/genconfig.py $(Kconfig)

%defconfig:
	$(Q)test -e configs/$@ || (		\
	echo >&2;			\
	echo >&2 "  ERROR: $@ doest exist.";		\
	echo >&2 ;							\
	/bin/false)
	$(Q) echo "  GEN      .config From configs/$@"
	$(Q) mkdir -p include/config
	$(Q) python $(srctree)/scripts/Kconfiglib/defconfig.py $(Kconfig) configs/$@

PHONY += FORCE
FORCE:

# Declare the contents of the PHONY variable as phony.  We keep that
# information in a variable so we can use it in if_changed and friends.
.PHONY: $(PHONY)
