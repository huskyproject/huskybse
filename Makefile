# huskybse/Makefile
#
# It is the main makefile for the Husky build environment
#
# This file is part of the Husky fidonet software project
# Use with GNU make v.3.82 or later
# Requires: husky environment
#

SHELL = /bin/sh
.DEFAULT_GOAL := all

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
SUBPROJECTS := huskybse huskylib smapi fidoconf areafix hptzip \
		hpt htick hptkill hptsqfix sqpack msged fidoroute util

# Per-subproject special variables
# gen_subproject generates defaults (in form <subproject>_<NAME>, skipping DIRSEP):
# LIBNAME = <subproject>
# ROOTDIR = <subproject>
## H_DIR is not generated, blank (used as current dir) by default
# BUILDDIR = $(<subproject>_ROOTDIR)$(BUILDDIR)
# $(OBJDIR) is taken from huskymak.cfg
# OBJDIR = $(<subproject>_ROOTDIR)$(OBJDIR)
# $(DEPDIR) is taken from huskymak.cfg
# DEPDIR = $(<subproject>_ROOTDIR)$(DEPDIR)
# SRCDIR = $(<subproject>_ROOTDIR)$(_SRCDIR) # overwritable
# MANDIR = $(<subproject>_ROOTDIR)man        # overwritable
# DOCDIR = $(<subproject>_ROOTDIR)doc

### huskylib ###
# The directory with header files
huskylib_H_DIR   = huskylib$(DIRSEP)


### smapi ###
# The directory with header files
smapi_H_DIR   = smapi$(DIRSEP)

### fidoconf ###
# The directory with header files
fidoconf_H_DIR := fidoconf$(DIRSEP)
fidoconf_DATEDEPS  = smapi huskylib
fidoconf_UNDOCDIR_PREREQ := fidoconf_docs_uninstall

### areafix ###
# The directory with header files
areafix_H_DIR   = areafix$(DIRSEP)

### hptzip ###
# The directory with header files
hptzip_H_DIR   = hptzip$(DIRSEP)

### hpt ###
# The directory with header files
hpt_H_DIR   = h$(DIRSEP)
# must be lazy due to HPTZIP
hpt_DATEDEPS  = $(HPTZIP) areafix fidoconf smapi huskylib
hpt_UNDOCDIR_PREREQ := hpt_doc_uninstall

### htick ###
# The directory with header files
htick_H_DIR   = h$(DIRSEP)
# Directories
htick_DOCDIR   = $(htick_ROOTDIR)doc$(DIRSEP)
htick_DATEDEPS  = $(HPTZIP) areafix fidoconf smapi huskylib
htick_UNDOCDIR_PREREQ := htick_doc_uninstall

### hptkill ###
# The directory with header files
hptkill_H_DIR   = h$(DIRSEP)
# Directories
hptkill_MANDIR   = $(hptkill_ROOTDIR)
hptkill_DATEDEPS  = fidoconf smapi huskylib

### hptsqfix ###
# The directory with header files
hptsqfix_H_DIR   = h$(DIRSEP)
# Directories
hptsqfix_CVSDATEDIR := hptsqfix$(DIRSEP)$(hptsqfix_H_DIR)
hptsqfix_DATEDEPS  = smapi huskylib

### sqpack ###
# Directories
sqpack_SRCDIR   = $(sqpack_ROOTDIR)
sqpack_MANDIR   = $(sqpack_ROOTDIR)
sqpack_DATEDEPS  = fidoconf smapi huskylib

### msged ###
# Directories
msged_SRCDIR   = $(msged_ROOTDIR)
msged_MAPDIR   = $(msged_ROOTDIR)maps$(DIRSEP)
msged_DATEDEPS  = fidoconf smapi huskylib
msged_UNDOCDIR_PREREQ := uninstall_msged_DOCDIR_DST

### fidoroute ###
# Directories
fidoroute_SRCDIR   = $(fidoroute_ROOTDIR)
fidoroute_MANDIR   = $(fidoroute_ROOTDIR)
fidoroute_DATEFILES := *.cpp

### util ###
# Directories
util_token   := util$(DIRSEP)Fidoconfig-Token$(DIRSEP)
util_rmfiles := util$(DIRSEP)Husky-Rmfiles$(DIRSEP)
util_DATEFILES := *.pl *.pm *.t

### huskybse ###


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
# HPTZIP variable for date dependencies in hpt and htick
ifeq ($(need_hptzip),1)
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

# $1 subproject
define gen_cvsdate
	cd "$(or $($1_CVSDATEDIR),$($1_ROOTDIR))"; curval=""; \
	[ -f $(cvsdate) ] && \
	curval=$$($(GREP) -Po 'char\s+cvs_date\[\]\s*=\s*"\K\d+-\d+-\d+' $(cvsdate)); \
	[ "$${$1_mdate}" != "$${curval}" ] && \
	echo "char cvs_date[]=\"$${$1_mdate}\";" > $(cvsdate) ||:
endef # gen_cvsdate

# generate shell code to choose the latest date from dependent subprojects
# assumes that that previous code set <project>_date/_mdate already
# $1 subproject
# $2 dependencies
define gen_date_selection
	$1_date=$($1_date); $1_mdate=$($1_mdate); \
	$(foreach sub,$2,\
		if [ "$${$1_date}" -lt $($(sub)_date) ]; \
		then $1_date=$($(sub)_date); $1_mdate=$($(sub)_mdate); fi;)
endef

# to use inside function which takes $1 as subproject name
DEFAULT_DATEFILES = $($1_H_DIR)*.h $(_SRC_DIR)$(DIRSEP)*.c

# get the project's last modification date
# uses DEFAULT_DATEFILES for files to check if <project>_DATEFILES is not set
# $1 subproject
define get_mdate
	$(shell cd $($1_ROOTDIR); \
		$(GIT) log -1 --date=short --format=format:"%cd" \
			$(or $($1_DATEFILES),$(DEFAULT_DATEFILES)))
endef

# generate data and rules for subproject
# $1 subproject
define gen_subproject

# subproject default variables
# LIBNAME is required for libraries, but makes no harm for others
$1_LIBNAME := $1
# need eval since ROOTDIR is used for include below and for overwrites
$1_ROOTDIR := $1$(DIRSEP)
$1_BUILDDIR := $$($1_ROOTDIR)$(BUILDDIR)$(DIRSEP)
# $(OBJDIR) is taken from huskymak.cfg
$1_OBJDIR   := $$($1_ROOTDIR)$(OBJDIR)$(DIRSEP)
# $(DEPDIR) is taken from huskymak.cfg
$1_DEPDIR   := $$($1_ROOTDIR)$(DEPDIR)$(DIRSEP)
$1_SRCDIR   := $$(or $$($1_SRCDIR),$$($1_ROOTDIR)$(_SRC_DIR)$(DIRSEP))
$1_MANDIR   := $$(or $$($1_MANDIR),$$($1_ROOTDIR)man$(DIRSEP))
$1_DOCDIR   := $$($1_ROOTDIR)doc$(DIRSEP)

# Add subproject rules to the dependencies

UPDATE_PREREQ    += $1_update
ifneq ($1,huskybse) # special, only one target addes
ALL_PREREQ       += $1_all
DEPEND_PREREQ    += $1_depend
INSTALL_PREREQ   += $1_install
CLEAN_PREREQ     += $1_clean
DISTCLEAN_PREREQ += $1_distclean
UNDOCDIR_PREREQ  += $($1_UNDOCDIR_PREREQ)
UNINSTALL_PREREQ += $1_uninstall
endif

.PHONY: $($1_UNDOCDIR_PREREQ)
.PHONY: $(addprefix $1_,all update depend install clean distclean uninstall)


ifneq ($(MAKECMDGOALS),update)
ifneq ($1,huskybse) # skip ourself :)
include $$($1_ROOTDIR)Makefile
endif
endif

# main update rule for subproject
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

.PHONY: all install uninstall clean distclean depend update
.PHONY: do_not_run_make_as_root

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

# <subproject>_glue
$(addsuffix _glue,$(ENABLED)): %_glue: %_git_update
	$(eval $*_mdate:=$(call get_mdate,$*))
	$(eval $*_date:=$(subst -,,$($*_mdate)))

# <subproject>_git_update pattern rule for git pull
$(addsuffix _git_update,$(ENABLED)): %_git_update: do_not_run_update_as_root
	@[ -d $($*_ROOTDIR).git ] && cd $($*_ROOTDIR) && \
	{ $(GIT) $(PULL) || echo "####### ERROR #######"; } || \
	$(GIT) $(CLONE) https://github.com/huskyproject/$*.git
