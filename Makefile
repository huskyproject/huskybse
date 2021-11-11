# huskybse/Makefile
#
# It is the main makefile for the Husky build environment
#
# This file is part of the Husky fidonet software project
# Use with GNU make v.3.82 or later
# Requires: husky environment
#

SHELL = /bin/sh

ifeq ($(MAKECMDGOALS),)
    MAKECMDGOALS := all
endif

Make = make
ifeq ($(shell uname -s),FreeBSD)
    Make := gmake
endif

ifneq ($(words $(MAKECMDGOALS)),1)
    $(error Please use $(Make) with one goal at a time)
endif

ifdef RPM_BUILD
    HUSKYMAK=./huskymak.rpm.cfg
else ifdef RPM_BUILD_ROOT
    HUSKYMAK=./huskymak.rpm.cfg
else
    HUSKYMAK=./huskymak.cfg
endif

# include Husky-Makefile-Config
include $(HUSKYMAK)

ifneq ($(findstring ~,$(PREFIX)),)
    $(eval PREFIX := $(subst ~,$${HOME},$(PREFIX)))
endif

ifeq ($(MAKECMDGOALS),update)
    ifneq ($(findstring git version,$(shell git --version)),git version)
        $(error ERROR: To update Husky, you must install git)
    endif
endif

ifeq ($(MAKECMDGOALS),all)
    ifeq ($(findstring util,$(PROGRAMS)), util)
        ifneq ($(findstring This is perl,$(shell perl -v)),This is perl)
            $(error ERROR: To build util, you must install Perl)
        endif
        ifneq ($(findstring Module::Build - Build and install,$(shell perldoc Module::Build)),Module::Build - Build and install)
            $(error ERROR: To build util, you must install Perl module Module::Build)
        endif
    endif
endif

ifdef INFODIR
    ifeq ($(filter distclean,$(MAKECMDGOALS))$(filter uninstall,$(MAKECMDGOALS)),)
        ifeq ($(shell whereis -b makeinfo | cut -d: -f2),)
            $(error Please install makeinfo program)
        endif
    endif
endif

ifeq ($(OSTYPE), UNIX)
  LIBPREFIX=lib
  DLLPREFIX=lib
endif

ifeq ($(DEBUG), 1)
  CFLAGS+=$(WARNFLAGS) $(DEBCFLAGS)
  LFLAGS=$(DEBLFLAGS)
  IBOPT=$(DEBIBOPT)
else
  CFLAGS+=$(WARNFLAGS) $(OPTCFLAGS)
  LFLAGS=$(OPTLFLAGS)
  IBOPT=$(OPTIBOPT)
endif
CDEFS=-D$(OSTYPE) $(ADDCDEFS)

ifdef BINDIR
    BINDIR_DST=$(DESTDIR)$(BINDIR)$(DIRSEP)
else
    $(error BINDIR not defined!)
endif
ifdef LIBDIR
    LIBDIR_DST=$(DESTDIR)$(LIBDIR)$(DIRSEP)
else
    $(error LIBDIR not defined!)
endif
ifdef DOCDIR
    DOCDIR_DST=$(DESTDIR)$(DOCDIR)$(DIRSEP)
    PARENT_DOCDIR_DST=$(dir $(DESTDIR)$(DOCDIR))
endif
ifdef INFODIR
    INFODIR_DST=$(DESTDIR)$(INFODIR)$(DIRSEP)
endif
ifdef MAN1DIR
    MANDIR=$(dir $(MAN1DIR))
endif

cvsdate=cvsdate.h

# In dependency order
SUBPROJECTS := huskybse huskylib smapi fidoconf areafix hptzip hpt \
               htick hptkill hptsqfix sqpack msged fidoroute util

### huskylib ###
# Library name
huskylib_LIBNAME = husky
# The root directory of the subproject
huskylib_ROOTDIR  := huskylib/
# The directory with header files
huskylib_H_DIR   = huskylib/
# Directories
huskylib_BUILDDIR := $(huskylib_ROOTDIR)$(BUILDDIR)$(DIRSEP)
# $(OBJDIR) is taken from huskymak.cfg
huskylib_OBJDIR   := $(huskylib_ROOTDIR)$(OBJDIR)$(DIRSEP)
# $(DEPDIR) is taken from huskymak.cfg
huskylib_DEPDIR   := $(huskylib_ROOTDIR)$(DEPDIR)$(DIRSEP)
huskylib_SRCDIR   := $(huskylib_ROOTDIR)$(_SRC_DIR)$(DIRSEP)

### smapi ###
# Library name
smapi_LIBNAME = smapi
# The root directory of the subproject
smapi_ROOTDIR  := smapi$(DIRSEP)
# The directory with header files
smapi_H_DIR   = smapi$(DIRSEP)
# Directories
smapi_BUILDDIR := $(smapi_ROOTDIR)$(BUILDDIR)$(DIRSEP)
smapi_OBJDIR   := $(smapi_ROOTDIR)$(OBJDIR)$(DIRSEP)
smapi_DEPDIR   := $(smapi_ROOTDIR)$(DEPDIR)$(DIRSEP)
smapi_SRCDIR   := $(smapi_ROOTDIR)$(_SRC_DIR)$(DIRSEP)

### fidoconf ###
# Library name
fidoconf_LIBNAME := fidoconfig
# The root directory of the subproject
fidoconf_ROOTDIR := fidoconf$(DIRSEP)
# The directory with header files
fidoconf_H_DIR := fidoconf$(DIRSEP)
# Directories
fidoconf_BUILDDIR := $(fidoconf_ROOTDIR)$(BUILDDIR)$(DIRSEP)
fidoconf_OBJDIR   := $(fidoconf_ROOTDIR)$(OBJDIR)$(DIRSEP)
fidoconf_DEPDIR   := $(fidoconf_ROOTDIR)$(DEPDIR)$(DIRSEP)
fidoconf_SRCDIR   := $(fidoconf_ROOTDIR)$(_SRC_DIR)$(DIRSEP)
fidoconf_MANDIR   := $(fidoconf_ROOTDIR)man$(DIRSEP)
fidoconf_DATEDEPS  = smapi huskylib

### areafix ###
# Library name
areafix_LIBNAME = areafix
# The root directory of the subproject
areafix_ROOTDIR  := areafix$(DIRSEP)
# The directory with header files
areafix_H_DIR   = areafix$(DIRSEP)
# Directories
areafix_BUILDDIR := $(areafix_ROOTDIR)$(BUILDDIR)$(DIRSEP)
areafix_OBJDIR   := $(areafix_ROOTDIR)$(OBJDIR)$(DIRSEP)
areafix_DEPDIR   := $(areafix_ROOTDIR)$(DEPDIR)$(DIRSEP)
areafix_SRCDIR   := $(areafix_ROOTDIR)$(_SRC_DIR)$(DIRSEP)


### hptzip ###
# Library name
hptzip_LIBNAME = hptzip
# The root directory of the subproject
hptzip_ROOTDIR  := hptzip$(DIRSEP)
# The directory with header files
hptzip_H_DIR   = hptzip$(DIRSEP)
# Directories
hptzip_BUILDDIR := $(hptzip_ROOTDIR)$(BUILDDIR)$(DIRSEP)
hptzip_OBJDIR   := $(hptzip_ROOTDIR)$(OBJDIR)$(DIRSEP)
hptzip_DEPDIR   := $(hptzip_ROOTDIR)$(DEPDIR)$(DIRSEP)
hptzip_SRCDIR   := $(hptzip_ROOTDIR)$(_SRC_DIR)$(DIRSEP)

### hpt ###
# The root directory of the subproject
hpt_ROOTDIR  := hpt$(DIRSEP)
# The directory with header files
hpt_H_DIR   = h$(DIRSEP)
# Directories
hpt_BUILDDIR := $(hpt_ROOTDIR)$(BUILDDIR)$(DIRSEP)
hpt_OBJDIR   := $(hpt_ROOTDIR)$(OBJDIR)$(DIRSEP)
hpt_DEPDIR   := $(hpt_ROOTDIR)$(DEPDIR)$(DIRSEP)
hpt_SRCDIR   := $(hpt_ROOTDIR)$(_SRC_DIR)$(DIRSEP)
hpt_MANDIR   := $(hpt_ROOTDIR)man$(DIRSEP)
hpt_DOCDIR   := $(hpt_ROOTDIR)doc$(DIRSEP)
# must be lazy due to HPTZIP
hpt_DATEDEPS  = $(HPTZIP) areafix fidoconf smapi huskylib

### htick ###
# The root directory of the subproject
htick_ROOTDIR  := htick$(DIRSEP)
# The directory with header files
htick_H_DIR   = h$(DIRSEP)
# Directories
htick_BUILDDIR := $(htick_ROOTDIR)$(BUILDDIR)$(DIRSEP)
htick_OBJDIR   := $(htick_ROOTDIR)$(OBJDIR)$(DIRSEP)
htick_DEPDIR   := $(htick_ROOTDIR)$(DEPDIR)$(DIRSEP)
htick_SRCDIR   := $(htick_ROOTDIR)$(_SRC_DIR)$(DIRSEP)
htick_MANDIR   := $(htick_ROOTDIR)man$(DIRSEP)
htick_DOCDIR   := $(htick_ROOTDIR)doc$(DIRSEP)
htick_DATEDEPS  = $(HPTZIP) areafix fidoconf smapi huskylib

### hptkill ###
# The root directory of the subproject
hptkill_ROOTDIR  := hptkill$(DIRSEP)
# The directory with header files
hptkill_H_DIR   = h$(DIRSEP)
# Directories
hptkill_BUILDDIR := $(hptkill_ROOTDIR)$(BUILDDIR)$(DIRSEP)
hptkill_OBJDIR   := $(hptkill_ROOTDIR)$(OBJDIR)$(DIRSEP)
hptkill_DEPDIR   := $(hptkill_ROOTDIR)$(DEPDIR)$(DIRSEP)
hptkill_SRCDIR   := $(hptkill_ROOTDIR)$(_SRC_DIR)$(DIRSEP)
hptkill_MANDIR   := $(hptkill_ROOTDIR)
hptkill_DATEDEPS  = fidoconf smapi huskylib

### hptsqfix ###
# The root directory of the subproject
hptsqfix_ROOTDIR  := hptsqfix$(DIRSEP)
# The directory with header files
hptsqfix_H_DIR   = h$(DIRSEP)
# Directories
hptsqfix_BUILDDIR := $(hptsqfix_ROOTDIR)$(BUILDDIR)$(DIRSEP)
hptsqfix_OBJDIR   := $(hptsqfix_ROOTDIR)$(OBJDIR)$(DIRSEP)
hptsqfix_DEPDIR   := $(hptsqfix_ROOTDIR)$(DEPDIR)$(DIRSEP)
hptsqfix_SRCDIR   := $(hptsqfix_ROOTDIR)$(_SRC_DIR)$(DIRSEP)
hptsqfix_MANDIR   := $(hptsqfix_ROOTDIR)man$(DIRSEP)
hptsqfix_CVSDATEDIR := hptsqfix$(DIRSEP)$(hptsqfix_H_DIR)
hptsqfix_DATEDEPS  = smapi huskylib

### sqpack ###
# The root directory of the subproject
sqpack_ROOTDIR  := sqpack$(DIRSEP)
# The directory with header files
sqpack_H_DIR    :=
# Directories
sqpack_BUILDDIR := $(sqpack_ROOTDIR)$(BUILDDIR)$(DIRSEP)
sqpack_OBJDIR   := $(sqpack_ROOTDIR)$(OBJDIR)$(DIRSEP)
sqpack_DEPDIR   := $(sqpack_ROOTDIR)$(DEPDIR)$(DIRSEP)
sqpack_SRCDIR   := $(sqpack_ROOTDIR)
sqpack_MANDIR   := $(sqpack_ROOTDIR)
sqpack_DATEDEPS  = fidoconf smapi huskylib
sqpack_DATEFILES:= *.c *.h

### msged ###
# The root directory of the subproject
msged_ROOTDIR  := msged$(DIRSEP)
# The directory with header files
msged_H_DIR    :=
# Directories
msged_BUILDDIR := $(msged_ROOTDIR)$(BUILDDIR)$(DIRSEP)
msged_OBJDIR   := $(msged_ROOTDIR)$(OBJDIR)$(DIRSEP)
msged_DEPDIR   := $(msged_ROOTDIR)$(DEPDIR)$(DIRSEP)
msged_SRCDIR   := $(msged_ROOTDIR)
msged_DOCDIR   := $(msged_ROOTDIR)doc$(DIRSEP)
msged_MAPDIR   := $(msged_ROOTDIR)maps$(DIRSEP)
msged_DATEDEPS  = fidoconf smapi huskylib
msged_DATEFILES:= *.c *.h

### fidoroute ###
# The root directory of the subproject
fidoroute_ROOTDIR  := fidoroute$(DIRSEP)
# The directory with header files
fidoroute_H_DIR    :=
# Directories
fidoroute_BUILDDIR := $(fidoroute_ROOTDIR)$(BUILDDIR)$(DIRSEP)
fidoroute_OBJDIR   := $(fidoroute_ROOTDIR)$(OBJDIR)$(DIRSEP)
fidoroute_DEPDIR   := $(fidoroute_ROOTDIR)$(DEPDIR)$(DIRSEP)
fidoroute_SRCDIR   := $(fidoroute_ROOTDIR)
fidoroute_MANDIR   := $(fidoroute_ROOTDIR)
fidoroute_DOCDIR   := $(fidoroute_ROOTDIR)doc$(DIRSEP)
fidoroute_DATEFILES := *.cpp

### util ###
# The root directory of the subproject
util_ROOTDIR := util$(DIRSEP)
# Directories
util_token   := util$(DIRSEP)Fidoconfig-Token$(DIRSEP)
util_rmfiles := util$(DIRSEP)Husky-Rmfiles$(DIRSEP)
# Files
util_DATEFILES := bin/*.pl t/*.t \
    Fidoconfig-Token/lib/Fidoconfig/Token.pm Fidoconfig-Token/t/*.t \
    Husky-Rmfiles/lib/Husky/Rmfiles.pm Husky-Rmfiles/t/*.t

### huskybse ###
# The root directory of the subproject
huskybse_ROOTDIR  := huskybse$(DIRSEP)


# Define need_huskylib
need_huskylib := $(if $(or $(filter hpt,$(PROGRAMS)), \
                           $(filter htick,$(PROGRAMS)), \
                           $(filter hptkill,$(PROGRAMS)), \
                           $(filter hptsqfix,$(PROGRAMS)), \
                           $(filter sqpack,$(PROGRAMS)), \
                           $(filter msged,$(PROGRAMS))),1,0)

# Define need_smapi
need_smapi := $(need_huskylib)

# Define need_fidoconf
need_fidoconf := $(if $(or $(filter hpt,$(PROGRAMS)), \
                           $(filter htick,$(PROGRAMS)), \
                           $(filter hptkill,$(PROGRAMS)), \
                           $(filter sqpack,$(PROGRAMS)), \
                           $(filter msged,$(PROGRAMS))),1,0)

# Define need_areafix
need_areafix := $(if $(or $(filter hpt,$(PROGRAMS)), \
                          $(filter htick,$(PROGRAMS))),1,0)

# Define need_hptzip
need_hptzip := $(need_areafix)
ifneq ($(USE_HPTZIP), 1)
    need_hptzip:=0
endif
ifeq ($(need_hptzip),1)
    # HPTZIP variable for date dependencies in hpt and htick
    HPTZIP := hptzip
endif

# make dependency sorted list of enabled subprojects
# keep need_* for now 0/1
DEPS :=
ifeq ($(need_huskylib),1)
DEPS += huskylib
endif
ifeq ($(need_smapi),1)
DEPS += smapi
endif
ifeq ($(need_fidoconf),1)
DEPS += fidoconf
endif
ifeq ($(need_areafix),1)
DEPS += areafix
endif
ifeq ($(need_hptzip),1)
DEPS += hptzip
endif

ENABLED := huskybse
$(foreach sub,$(SUBPROJECTS),\
    $(if $(filter $(sub),$(PROGRAMS) $(DEPS)),\
        $(eval ENABLED += $(sub)),))

UPDATE_PREREQ := huskybse_update
ifeq ($(need_huskylib), 1)
    ALL_PREREQ       += huskylib_all
    UPDATE_PREREQ    += huskylib_update
    DEPEND_PREREQ    += huskylib_depend
    INSTALL_PREREQ   += huskylib_install
    CLEAN_PREREQ     += huskylib_clean
    DISTCLEAN_PREREQ += huskylib_distclean
    UNINSTALL_PREREQ += huskylib_uninstall
endif
ifeq ($(need_smapi), 1)
    ALL_PREREQ       += smapi_all
    UPDATE_PREREQ    += smapi_update
    DEPEND_PREREQ    += smapi_depend
    INSTALL_PREREQ   += smapi_install
    CLEAN_PREREQ     += smapi_clean
    DISTCLEAN_PREREQ += smapi_distclean
    UNINSTALL_PREREQ += smapi_uninstall
endif
ifeq ($(need_fidoconf), 1)
    ALL_PREREQ       += fidoconf_all
    UPDATE_PREREQ    += fidoconf_update
    DEPEND_PREREQ    += fidoconf_depend
    INSTALL_PREREQ   += fidoconf_install
    CLEAN_PREREQ     += fidoconf_clean
    DISTCLEAN_PREREQ += fidoconf_distclean
    UNDOCDIR_PREREQ  := fidoconf_docs_uninstall
    UNINSTALL_PREREQ += fidoconf_uninstall
endif
ifeq ($(need_areafix), 1)
    ALL_PREREQ       += areafix_all
    UPDATE_PREREQ    += areafix_update
    DEPEND_PREREQ    += areafix_depend
    INSTALL_PREREQ   += areafix_install
    CLEAN_PREREQ     += areafix_clean
    DISTCLEAN_PREREQ += areafix_distclean
    UNINSTALL_PREREQ += areafix_uninstall
endif
ifeq ($(need_hptzip), 1)
    ALL_PREREQ       += hptzip_all
    UPDATE_PREREQ    += hptzip_update
    DEPEND_PREREQ    += hptzip_depend
    INSTALL_PREREQ   += hptzip_install
    CLEAN_PREREQ     += hptzip_clean
    DISTCLEAN_PREREQ += hptzip_distclean
    UNINSTALL_PREREQ += hptzip_uninstall
endif
ifeq ($(filter hpt,$(PROGRAMS)),hpt)
    ALL_PREREQ       += hpt_all
    UPDATE_PREREQ    += hpt_update
    DEPEND_PREREQ    += hpt_depend
    INSTALL_PREREQ   += hpt_install
    CLEAN_PREREQ     += hpt_clean
    DISTCLEAN_PREREQ += hpt_distclean
    UNDOCDIR_PREREQ  += hpt_doc_uninstall
    UNINSTALL_PREREQ += hpt_uninstall
endif
ifeq ($(filter htick,$(PROGRAMS)), htick)
    ALL_PREREQ       += htick_all
    UPDATE_PREREQ    += htick_update
    DEPEND_PREREQ    += htick_depend
    INSTALL_PREREQ   += htick_install
    CLEAN_PREREQ     += htick_clean
    DISTCLEAN_PREREQ += htick_distclean
    UNDOCDIR_PREREQ  += htick_doc_uninstall
    UNINSTALL_PREREQ += htick_uninstall
endif
ifeq ($(filter hptkill,$(PROGRAMS)), hptkill)
    ALL_PREREQ       += hptkill_all
    UPDATE_PREREQ    += hptkill_update
    DEPEND_PREREQ    += hptkill_depend
    INSTALL_PREREQ   += hptkill_install
    CLEAN_PREREQ     += hptkill_clean
    DISTCLEAN_PREREQ += hptkill_distclean
    UNINSTALL_PREREQ += hptkill_uninstall
endif
ifeq ($(filter hptsqfix,$(PROGRAMS)), hptsqfix)
    ALL_PREREQ       += hptsqfix_all
    UPDATE_PREREQ    += hptsqfix_update
    DEPEND_PREREQ    += hptsqfix_depend
    INSTALL_PREREQ   += hptsqfix_install
    CLEAN_PREREQ     += hptsqfix_clean
    DISTCLEAN_PREREQ += hptsqfix_distclean
    UNINSTALL_PREREQ += hptsqfix_uninstall
endif
ifeq ($(filter sqpack,$(PROGRAMS)), sqpack)
    ALL_PREREQ       += sqpack_all
    UPDATE_PREREQ    += sqpack_update
    DEPEND_PREREQ    += sqpack_depend
    INSTALL_PREREQ   += sqpack_install
    CLEAN_PREREQ     += sqpack_clean
    DISTCLEAN_PREREQ += sqpack_distclean
    UNINSTALL_PREREQ += sqpack_uninstall
endif
ifeq ($(filter msged,$(PROGRAMS)), msged)
    ALL_PREREQ       += msged_all
    UPDATE_PREREQ    += msged_update
    DEPEND_PREREQ    += msged_depend
    INSTALL_PREREQ   += msged_install
    CLEAN_PREREQ     += msged_clean
    DISTCLEAN_PREREQ += msged_distclean
    UNDOCDIR_PREREQ  += uninstall_msged_DOCDIR_DST
    UNINSTALL_PREREQ += msged_uninstall
endif
ifeq ($(filter fidoroute,$(PROGRAMS)), fidoroute)
    ALL_PREREQ       += fidoroute_all
    UPDATE_PREREQ    += fidoroute_update
    DEPEND_PREREQ    += fidoroute_depend
    INSTALL_PREREQ   += fidoroute_install
    CLEAN_PREREQ     += fidoroute_clean
    DISTCLEAN_PREREQ += fidoroute_distclean
    UNINSTALL_PREREQ += fidoroute_uninstall
endif
ifeq ($(filter util,$(PROGRAMS)), util)
    ALL_PREREQ       += util_all
    UPDATE_PREREQ    += util_update
    INSTALL_PREREQ   += util_install
    CLEAN_PREREQ     += util_clean
    DISTCLEAN_PREREQ += util_distclean
    UNINSTALL_PREREQ += util_uninstall
endif

.PHONY: all install uninstall clean distclean depend update huskylib_update \
        smapi_update fidoconf_update areafix_update hptzip_update hpt_update \
        htick_update hptkill_update hptsqfix_update sqpack_update msged_update \
        fidoroute_update util_update huskybse_update uninstall_DOCDIR_DST \
        do_not_run_make_as_root do_not_run_depend_as_root

all: $(ALL_PREREQ) ;

ifeq ($(MAKECMDGOALS),all)
    ifeq ($(OSTYPE), UNIX)
        do_not_run_make_as_root:
		@[ $$($(ID) $(IDOPT)) -eq 0 ] && echo "DO NOT run \`make\` as root" && exit 1 || true
    else
        do_not_run_make_as_root: ;
    endif
endif

depend: $(DEPEND_PREREQ) ;

ifeq ($(MAKECMDGOALS),depend)
    ifeq ($(OSTYPE), UNIX)
        do_not_run_depend_as_root:
		@[ $$($(ID) $(IDOPT)) -eq 0 ] && echo "DO NOT run \`make depend\` as root" && exit 1 || true
    else
        do_not_run_depend_as_root: ;
    endif
endif

test: util_test ;

install: $(INSTALL_PREREQ) ;

uninstall: $(UNINSTALL_PREREQ) uninstall_DOCDIR_DST ;

clean: $(CLEAN_PREREQ) ;

distclean: $(DISTCLEAN_PREREQ) ;

ifneq ($(MAKECMDGOALS),update)
    include $(patsubst %,%/Makefile,$(filter-out huskybse,$(ENABLED)))
endif

$(DOCDIR_DST):
	[ -d "$(PARENT_DOCDIR_DST)" ] || $(MKDIR) $(MKDIROPT) "$(PARENT_DOCDIR_DST)"
	[ -d "$@" ] || $(MKDIR) $(MKDIROPT) "$@"

$(DESTDIR)$(MANDIR):
	[ -d "$@" ] || $(MKDIR) $(MKDIROPT) "$@"

ifndef INFODIR
    all_info_install: ;
    all_info_uninstall: ;
else
    #
    # Install
    #
    info_PREREQ := $(INFODIR_DST)fidoconfig.info.gz
    ifeq ($(filter hpt,$(PROGRAMS)),hpt)
        info_PREREQ += $(INFODIR_DST)hpt.info.gz
    endif
    ifeq ($(filter htick,$(PROGRAMS)), htick)
        info_PREREQ += $(INFODIR_DST)htick.info.gz
    endif
    ifeq ($(filter msged,$(PROGRAMS)), msged)
        info_PREREQ += $(INFODIR_DST)msged.info.gz
    endif

    info_RECIPE := install-info --info-dir="$(INFODIR_DST)" "$(INFODIR_DST)fidoconfig.info.gz";
    ifeq ($(filter hpt,$(PROGRAMS)),hpt)
        info_RECIPE += install-info --info-dir="$(INFODIR_DST)" \
        "$(INFODIR_DST)hpt.info.gz";
    endif
    ifeq ($(filter htick,$(PROGRAMS)), htick)
        info_RECIPE += install-info --info-dir="$(INFODIR_DST)" "$(INFODIR_DST)htick.info.gz";
    endif
    ifeq ($(filter msged,$(PROGRAMS)), msged)
        info_RECIPE += install-info --info-dir="$(INFODIR_DST)" "$(INFODIR_DST)msged.info.gz";
    endif
    info_RECIPE += touch $(INFODIR_DST)dir;

    ifdef RPM_BUILD_ROOT
        all_info_install: $(info_PREREQ) ;
    else
        all_info_install: $(INFODIR_DST)dir ;

        $(INFODIR_DST)dir: $(info_PREREQ)
			$(info_RECIPE)
    endif

    $(INFODIR_DST)fidoconfig.info.gz: \
    $(fidoconf_BUILDDIR)fidoconfig.info.gz | $(DESTDIR)$(INFODIR)
		$(INSTALL) $(IMOPT) "$<" "$|"; \
		$(TOUCH) "$@"

    $(INFODIR_DST)hpt.info.gz: \
    $(hpt_BUILDDIR)hpt.info.gz | $(DESTDIR)$(INFODIR)
		$(INSTALL) $(IMOPT) "$<" "$|"; \
		$(TOUCH) "$@"

    $(INFODIR_DST)htick.info.gz: \
    $(htick_BUILDDIR)htick.info.gz | $(DESTDIR)$(INFODIR)
		$(INSTALL) $(IMOPT) "$<" "$|"; \
		$(TOUCH) "$@"

    $(INFODIR_DST)msged.info.gz: \
    $(msged_BUILDDIR)msged.info.gz | $(DESTDIR)$(INFODIR)
		$(INSTALL) $(IMOPT) "$<" "$|"; \
		$(TOUCH) "$@"

    $(DESTDIR)$(INFODIR):
		[ -d "$@" ] || $(MKDIR) $(MKDIROPT) "$@"

    #
    # Uninstall
    #
    uninfo_RECIPE := [ -f $(INFODIR_DST)fidoconfig.info.gz ] && \
        install-info --remove --info-dir=$(DESTDIR)$(INFODIR) \
        $(INFODIR_DST)fidoconfig.info.gz;
    ifeq ($(filter hpt,$(PROGRAMS)),hpt)
        uninfo_RECIPE += [ -f $(INFODIR_DST)hpt.info.gz ] && \
            install-info --remove --info-dir=$(DESTDIR)$(INFODIR) \
            $(INFODIR_DST)hpt.info.gz;
    endif
    ifeq ($(filter htick,$(PROGRAMS)), htick)
        uninfo_RECIPE += [ -f $(INFODIR_DST)htick.info.gz ] && \
            install-info --remove --info-dir=$(DESTDIR)$(INFODIR) \
            $(INFODIR_DST)htick.info.gz;
    endif
    ifeq ($(filter msged,$(PROGRAMS)), msged)
        uninfo_RECIPE += [ -f $(INFODIR_DST)msged.info.gz ] && \
            install-info --remove --info-dir=$(DESTDIR)$(INFODIR) \
            $(INFODIR_DST)msged.info.gz
    endif

    all_info_uninstall:
		-$(uninfo_RECIPE) || true
endif

uninstall_DOCDIR_DST: $(UNDOCDIR_PREREQ)
	-[ -d "$(DOCDIR_DST)" ] && $(RMDIR) $(DOCDIR_DST) || true

update: $(UPDATE_PREREQ)

.PHONY: do_not_run_update_as_root

ifeq ($(OSTYPE), UNIX)
    do_not_run_update_as_root:
		@[ $$($(ID) $(IDOPT)) -eq 0 ] && echo "DO NOT run \`make update\` as root" && exit 1 || true
else
    do_not_run_update_as_root: ;
endif

# Generate cvsdate.h
# Here $1 means a subproject name
define gen_cvsdate
	cd "$(or $($1_CVSDATEDIR),$($1_ROOTDIR))"; curval=""; \
	[ -f $(cvsdate) ] && \
	curval=$$($(GREP) -Po 'char\s+cvs_date\[\]\s*=\s*"\K\d+-\d+-\d+' $(cvsdate)); \
	[ "$${$1_mdate}" != "$${curval}" ] && \
	echo "Generating $(or $($1_CVSDATEDIR),$($1_ROOTDIR))cvsdate.h" && \
	echo "char cvs_date[]=\"$${$1_mdate}\";" > $(cvsdate) ||:
endef

# Generate shell code to choose the latest date from dependent subprojects.
# Assumes that that the previous code has already set <project>_date/_mdate
# Here $1 means a subproject name
# and  $2 is a list of the subprojects it depends on
define gen_date_selection
	$1_date=$($1_date); $1_mdate=$($1_mdate); \
	$(foreach sub,$2,\
		if [ "$${$1_date}" -lt $($(sub)_date) ]; \
		then $1_date=$($(sub)_date); $1_mdate=$($(sub)_mdate); fi;)
endef

# to use inside get_mdate function which takes $1 as subproject name
DEFAULT_DATEFILES = $($1_H_DIR)*.h $(_SRC_DIR)$(DIRSEP)*.c

# get the project's last modification date
# uses DEFAULT_DATEFILES for files to check if <project>_DATEFILES is not set
# $1 is a subproject name
define get_mdate
	$(shell cd $($1_ROOTDIR); \
		$(GIT) log -1 --date=short --format=format:"%cd" \
			$(or $($1_DATEFILES),$(DEFAULT_DATEFILES)))
endef

# generate data and rules for a subproject
# $1 is a subproject
define gen_subproject

# main update rule for a subproject
# <subproject>_update: <subproject>_glue <dep>_glue
#                      <subproject>_date=$(<subproject>_date); \
#                      <subproject>_mdate=$(<subproject>_mdate); \
#                      if [ "${<subproject>_date}" -lt $(<dep>_date) ]; \
#                      then <subproject_date=$(<dep>_date); \
#                           <subproject_mdate=$(<dep>_mdate); \
#                      fi; \
#                      cd "$(<subproject>_CVSDATEDIR)"; \ # or _ROOTDIR if not set
#                      curval=""; \
#                      [ -f $(cvsdate) ] && \
#                      curval=$($(GREP) -Po 'char\s+cvs_date\[\]\s*=\s*"\K\d+-\d+-\d+' $(cvsdate)); \
#                      [ "${<subproject>_mdate}" != "${curval}" ] && \
#                      echo "char cvs_date[]=\"${<subproject>_mdate}\";" > $(cvsdate) ||:
$1_update: $$(addsuffix _glue,$1 $$($1_DATEDEPS))
	@$$(call gen_date_selection,$1,$$($1_DATEDEPS)) \
	$$(call gen_cvsdate,$1)

.PHONY: $1_update $1_glue $1_git_update

endef # gen_subproject

# Generate main update rule for subprojects
$(foreach sub,$(ENABLED),$(eval $(call gen_subproject,$(sub))))

# <subproject>_glue
$(addsuffix _glue,$(ENABLED)): %_glue: %_git_update
	$(eval $*_mdate:=$(call get_mdate,$*))
	$(eval $*_date:=$(subst -,,$($*_mdate)))

# <subproject>_git_update pattern rule
$(addsuffix _git_update,$(ENABLED)): %_git_update: do_not_run_update_as_root
	@[ -d $($*_ROOTDIR).git ] && cd $($*_ROOTDIR) && \
	{ $(GIT) $(PULL) || echo "####### ERROR #######"; } || \
	$(GIT) $(CLONE) https://github.com/huskyproject/$*.git
