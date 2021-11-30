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

ifneq ($(findstring ~,$(PREFIX)),)
    $(eval PREFIX := $(subst ~,$${HOME},$(PREFIX)))
endif

ifeq ($(MAKECMDGOALS),update)
    ifeq ($(findstring git version,$(shell git --version)),)
        $(error ERROR: To update Husky, you must install git)
    endif
endif

ifeq ($(MAKECMDGOALS),all)
    ifneq ($(filter util,$(PROGRAMS)),)
        ifeq ($(findstring This is perl,$(shell perl -v)),)
            $(error ERROR: To build util, you must install Perl)
        endif
        ifeq ($(findstring Module::Build - Build and install,$(shell perldoc Module::Build)),)
            $(error ERROR: To build util, you must install Perl module Module::Build)
        endif
    endif
endif

ifdef INFODIR
    ifdef MAKEINFO
        ifeq ($(filter distclean uninstall,$(MAKECMDGOALS)),)
            OStype := $(shell uname -s)
            if_makeinfo = $(shell whereis -b makeinfo | cut -d: -f2)

            ifneq ($(filter Linux FreeBSD,$(OStype)),)
                ifeq ($(if_makeinfo),)
                    $(error Please install makeinfo program)
                endif
            endif

            if_makeinfo = $(shell which /usr/local/opt/texinfo/bin/makeinfo)
            ifeq ($(OStype),Darwin)
                ifneq ($(if_makeinfo),/usr/local/opt/texinfo/bin/makeinfo)
                    $(error Please run 'brew install texinfo')
                endif
            endif
        endif
    else
        $(error You have to define MAKEINFO in huskymak.cfg to get .info docs)
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
huskylib_H_DIR = huskylib$(DIRSEP)

### smapi ###
# The directory with header files
smapi_H_DIR = smapi$(DIRSEP)
# Directories

### fidoconf ###
# The directory with header files
fidoconf_H_DIR := fidoconf$(DIRSEP)
# Directories
fidoconf_DATEDEPS = smapi huskylib
fidoconf_UNDOCDIR_PREREQ := fidoconf_docs_uninstall
fidoconf_INFO = fidoconfig.info.gz

### areafix ###
# The directory with header files
areafix_H_DIR = areafix$(DIRSEP)

### hptzip ###
# The directory with header files
hptzip_H_DIR = hptzip$(DIRSEP)

### hpt ###
# The directory with header files
hpt_H_DIR = h$(DIRSEP)
# must be lazy due to HPTZIP
hpt_DATEDEPS = $(HPTZIP) areafix fidoconf smapi huskylib
hpt_UNDOCDIR_PREREQ := hpt_doc_uninstall
hpt_INFO = hpt.info.gz

### htick ###
# The directory with header files
htick_H_DIR = h$(DIRSEP)
# Directories
htick_DOCDIR   = $(htick_ROOTDIR)doc$(DIRSEP)
htick_DATEDEPS = $(HPTZIP) areafix fidoconf smapi huskylib
htick_UNDOCDIR_PREREQ := htick_doc_uninstall
htick_INFO = htick.info.gz

### hptkill ###
# The directory with header files
hptkill_H_DIR = h$(DIRSEP)
# Directories
hptkill_MANDIR   = $(hptkill_ROOTDIR)
hptkill_DATEDEPS = fidoconf smapi huskylib

### hptsqfix ###
# The directory with header files
hptsqfix_H_DIR   = h$(DIRSEP)
# Directories
hptsqfix_CVSDATEDIR := hptsqfix$(DIRSEP)$(hptsqfix_H_DIR)
hptsqfix_DATEDEPS  = smapi huskylib

### sqpack ###
# Directories
sqpack_SRCDIR     = $(sqpack_ROOTDIR)
sqpack_MANDIR     = $(sqpack_ROOTDIR)
sqpack_DATEDEPS   = fidoconf smapi huskylib
sqpack_DATEFILES := *.c *.h

### msged ###
# Directories
msged_SRCDIR     = $(msged_ROOTDIR)
msged_MAPDIR     = $(msged_ROOTDIR)maps$(DIRSEP)
msged_DATEDEPS   = fidoconf smapi huskylib
msged_DATEFILES := *.c *.h
msged_UNDOCDIR_PREREQ := uninstall_msged_DOCDIR_DST
msged_INFO = msged.info.gz

### fidoroute ###
# Directories
fidoroute_SRCDIR     = $(fidoroute_ROOTDIR)
fidoroute_MANDIR     = $(fidoroute_ROOTDIR)
fidoroute_DATEFILES := *.cpp *.h

### util ###
# Directories
util_token   := util$(DIRSEP)Fidoconfig-Token$(DIRSEP)
util_rmfiles := util$(DIRSEP)Husky-Rmfiles$(DIRSEP)
# Files
util_DATEFILES := bin/*.pl t/*.t \
    Fidoconfig-Token/lib/Fidoconfig/Token.pm Fidoconfig-Token/t/*.t \
    Husky-Rmfiles/lib/Husky/Rmfiles.pm Husky-Rmfiles/t/*.t

# define "space"
nil   :=
space := $(nil) $(nil)

### huskybse ###
huskybse_DATEFILES:= $(space)


HUSKYLIB := $(and $(filter hpt htick hptkill hptsqfix sqpack msged, \
                    $(PROGRAMS)), huskylib)

SMAPI := $(and $(HUSKYLIB),smapi)

FIDOCONF := $(and $(filter hpt htick hptkill sqpack msged,$(PROGRAMS)), \
                  fidoconf)

AREAFIX := $(and $(filter hpt htick,$(PROGRAMS)), areafix)

HPTZIP := $(and $(AREAFIX),hptzip)

ifneq ($(USE_HPTZIP), 1)
    HPTZIP :=
endif

ENABLED := huskybse
$(foreach sub,$(SUBPROJECTS),\
    $(if $(filter $(sub),\
        $(PROGRAMS) $(HUSKYLIB) $(SMAPI) $(FIDOCONF) $(AREAFIX) $(HPTZIP)),\
        $(eval ENABLED += $(sub)),))

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

# subproject default variables
# LIBNAME is required for libraries, but makes no harm for others
$1_LIBNAME := $(if $(filter huskylib,$1),husky,$1)
# needs eval since ROOTDIR is used for overwrites
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

UPDATE_PREREQ        += $1_update
ifneq ($1,huskybse)
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

ifneq ($($1_INFO),)
    info_PREREQ += $(INFODIR_DST)$($1_INFO)
    info_RECIPE +=  install-info --info-dir="$(INFODIR_DST)" "$(INFODIR_DST)$($1_INFO)";

    $(INFODIR_DST)$($1_INFO): $$($1_BUILDDIR)$($1_INFO) | $(DESTDIR)$(INFODIR)
		$(INSTALL) $(IMOPT) "$$<" "$$|"
		$(TOUCH) "$$@"

    uninfo_RECIPE += [ -f $(INFODIR_DST)$($1_INFO) ] && \
		install-info --remove --info-dir=$(DESTDIR)$(INFODIR) \
		$(INFODIR_DST)$($1_INFO);
endif

ifneq ($(MAKECMDGOALS),update)
    ifneq ($1,huskybse)     # skip ourself :)
        include $$($1_ROOTDIR)Makefile
    endif
endif

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

    # info_PREREQ, info_RECIPE generated by gen_subproject
    info_RECIPE += touch $(INFODIR_DST)dir;

    ifdef RPM_BUILD_ROOT
        all_info_install: $(info_PREREQ) ;
    else
        all_info_install: $(INFODIR_DST)dir ;

        $(INFODIR_DST)dir: $(info_PREREQ)
			$(info_RECIPE)
    endif

    $(DESTDIR)$(INFODIR):
		[ -d "$@" ] || $(MKDIR) $(MKDIROPT) "$@"

    #
    # Uninstall
    #

    # uninfo_RECIPE generated by gen_subproject
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

# <subproject>_git_update pattern rule
$(addsuffix _git_update,$(ENABLED)): %_git_update: do_not_run_update_as_root
	@[ -d $($*_ROOTDIR).git ] && cd $($*_ROOTDIR) && \
	{ $(GIT) $(PULL) || echo "####### ERROR #######"; } || \
	$(GIT) $(CLONE) https://github.com/huskyproject/$*.git
