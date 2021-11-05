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

UPDATE_PREREQ := huskybse_update
ifeq ($(need_huskylib), 1)
    ALL_PREREQ       += huskylib_all
    UPDATE_PREREQ    += huskylib_glue
    DEPEND_PREREQ    += huskylib_depend
    INSTALL_PREREQ   += huskylib_install
    CLEAN_PREREQ     += huskylib_clean
    DISTCLEAN_PREREQ += huskylib_distclean
    UNINSTALL_PREREQ += huskylib_uninstall
endif
ifeq ($(need_smapi), 1)
    ALL_PREREQ       += smapi_all
    UPDATE_PREREQ    += smapi_glue
    DEPEND_PREREQ    += smapi_depend
    INSTALL_PREREQ   += smapi_install
    CLEAN_PREREQ     += smapi_clean
    DISTCLEAN_PREREQ += smapi_distclean
    UNINSTALL_PREREQ += smapi_uninstall
endif
ifeq ($(need_fidoconf), 1)
    ALL_PREREQ       += fidoconf_all
    UPDATE_PREREQ    += fidoconf_cmp
    DEPEND_PREREQ    += fidoconf_depend
    INSTALL_PREREQ   += fidoconf_install
    CLEAN_PREREQ     += fidoconf_clean
    DISTCLEAN_PREREQ += fidoconf_distclean
    UNDOCDIR_PREREQ  := fidoconf_docs_uninstall
    UNINSTALL_PREREQ += fidoconf_uninstall
endif
ifeq ($(need_areafix), 1)
    ALL_PREREQ       += areafix_all
    UPDATE_PREREQ    += areafix_glue
    DEPEND_PREREQ    += areafix_depend
    INSTALL_PREREQ   += areafix_install
    CLEAN_PREREQ     += areafix_clean
    DISTCLEAN_PREREQ += areafix_distclean
    UNINSTALL_PREREQ += areafix_uninstall
endif
ifeq ($(need_hptzip), 1)
    ALL_PREREQ       += hptzip_all
    UPDATE_PREREQ    += hptzip_glue
    DEPEND_PREREQ    += hptzip_depend
    INSTALL_PREREQ   += hptzip_install
    CLEAN_PREREQ     += hptzip_clean
    DISTCLEAN_PREREQ += hptzip_distclean
    UNINSTALL_PREREQ += hptzip_uninstall
endif
ifeq ($(filter hpt,$(PROGRAMS)),hpt)
    ALL_PREREQ       += hpt_all
    UPDATE_PREREQ    += hpt_cmp
    DEPEND_PREREQ    += hpt_depend
    INSTALL_PREREQ   += hpt_install
    CLEAN_PREREQ     += hpt_clean
    DISTCLEAN_PREREQ += hpt_distclean
    UNDOCDIR_PREREQ  += hpt_doc_uninstall
    UNINSTALL_PREREQ += hpt_uninstall
endif
ifeq ($(filter htick,$(PROGRAMS)), htick)
    ALL_PREREQ       += htick_all
    UPDATE_PREREQ    += htick_cmp
    DEPEND_PREREQ    += htick_depend
    INSTALL_PREREQ   += htick_install
    CLEAN_PREREQ     += htick_clean
    DISTCLEAN_PREREQ += htick_distclean
    UNDOCDIR_PREREQ  += htick_doc_uninstall
    UNINSTALL_PREREQ += htick_uninstall
endif
ifeq ($(filter hptkill,$(PROGRAMS)), hptkill)
    ALL_PREREQ       += hptkill_all
    UPDATE_PREREQ    += hptkill_cmp
    DEPEND_PREREQ    += hptkill_depend
    INSTALL_PREREQ   += hptkill_install
    CLEAN_PREREQ     += hptkill_clean
    DISTCLEAN_PREREQ += hptkill_distclean
    UNINSTALL_PREREQ += hptkill_uninstall
endif
ifeq ($(filter hptsqfix,$(PROGRAMS)), hptsqfix)
    ALL_PREREQ       += hptsqfix_all
    UPDATE_PREREQ    += hptsqfix_cmp
    DEPEND_PREREQ    += hptsqfix_depend
    INSTALL_PREREQ   += hptsqfix_install
    CLEAN_PREREQ     += hptsqfix_clean
    DISTCLEAN_PREREQ += hptsqfix_distclean
    UNINSTALL_PREREQ += hptsqfix_uninstall
endif
ifeq ($(filter sqpack,$(PROGRAMS)), sqpack)
    ALL_PREREQ       += sqpack_all
    UPDATE_PREREQ    += sqpack_cmp
    DEPEND_PREREQ    += sqpack_depend
    INSTALL_PREREQ   += sqpack_install
    CLEAN_PREREQ     += sqpack_clean
    DISTCLEAN_PREREQ += sqpack_distclean
    UNINSTALL_PREREQ += sqpack_uninstall
endif
ifeq ($(filter msged,$(PROGRAMS)), msged)
    ALL_PREREQ       += msged_all
    UPDATE_PREREQ    += msged_cmp
    DEPEND_PREREQ    += msged_depend
    INSTALL_PREREQ   += msged_install
    CLEAN_PREREQ     += msged_clean
    DISTCLEAN_PREREQ += msged_distclean
    UNDOCDIR_PREREQ  += uninstall_msged_DOCDIR_DST
    UNINSTALL_PREREQ += msged_uninstall
endif
ifeq ($(filter fidoroute,$(PROGRAMS)), fidoroute)
    ALL_PREREQ       += fidoroute_all
    UPDATE_PREREQ    += fidoroute_wdate
    DEPEND_PREREQ    += fidoroute_depend
    INSTALL_PREREQ   += fidoroute_install
    CLEAN_PREREQ     += fidoroute_clean
    DISTCLEAN_PREREQ += fidoroute_distclean
    UNINSTALL_PREREQ += fidoroute_uninstall
endif
ifeq ($(filter util,$(PROGRAMS)), util)
    ALL_PREREQ       += util_all
    UPDATE_PREREQ    += util_wdate
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

ifneq ($(MAKECMDGOALS),update)
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

    ifeq ($(need_huskylib), 1)
        include $(huskylib_ROOTDIR)Makefile
    endif
    ifeq ($(need_smapi), 1)
        include $(smapi_ROOTDIR)Makefile
    endif
    ifeq ($(need_fidoconf), 1)
        include $(fidoconf_ROOTDIR)Makefile
    endif
    ifeq ($(need_areafix), 1)
        include $(areafix_ROOTDIR)Makefile
    endif
    ifeq ($(need_hptzip), 1)
        include $(hptzip_ROOTDIR)Makefile
    endif
    ifeq ($(filter hpt,$(PROGRAMS)),hpt)
        include $(hpt_ROOTDIR)Makefile
    endif
    ifeq ($(filter htick,$(PROGRAMS)), htick)
        include $(htick_ROOTDIR)Makefile
    endif
    ifeq ($(filter hptkill,$(PROGRAMS)), hptkill)
        include $(hptkill_ROOTDIR)Makefile
    endif
    ifeq ($(filter hptsqfix,$(PROGRAMS)), hptsqfix)
        include $(hptsqfix_ROOTDIR)Makefile
    endif
    ifeq ($(filter sqpack,$(PROGRAMS)), sqpack)
        include $(sqpack_ROOTDIR)Makefile
    endif
    ifeq ($(filter msged,$(PROGRAMS)), msged)
        include $(msged_ROOTDIR)Makefile
    endif
    ifeq ($(filter fidoroute,$(PROGRAMS)), fidoroute)
        include $(fidoroute_ROOTDIR)Makefile
    endif
    ifeq ($(filter util,$(PROGRAMS)), util)
        include $(util_ROOTDIR)Makefile
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
else
    update: $(UPDATE_PREREQ)

.PHONY: do_not_run_update_as_root \
        huskylib_glue huskylib_get_date smapi_glue smapi_get_date \
        fidoconf_cmp fidoconf_glue fidoconf_get_date \
        areafix_glue areafix_get_date hptzip_glue hptzip_get_date \
        hpt_cmp hpt_glue hpt_get_date htick_cmp htick_glue htick_get_date \
        hptkill_cmp hptkill_glue hptkill_get_date \
        hptsqfix_cmp hptsqfix_glue hptsqfix_get_date \
        sqpack_cmp sqpack_glue sqpack_get_date \
        msged_cmp msged_glue msged_get_date \
        fidoroute_wdate fidoroute_get_date util_wdate util_get_date

    ifeq ($(OSTYPE), UNIX)
        do_not_run_update_as_root:
			@[ $$($(ID) $(IDOPT)) -eq 0 ] && echo "DO NOT run \`make update\` as root" && exit 1 || true
    else
        do_not_run_update_as_root: ;
    endif

    ifeq ($(need_huskylib), 1)
        huskylib_glue: huskylib_get_date
			$(eval huskylib_date:=$(subst -,,$(huskylib_mdate)))
			@cd $(huskylib_ROOTDIR); curval=""; \
			[ -f $(cvsdate) ] && \
			curval=$$($(GREP) -Po 'char\s+cvs_date\[\]\s*=\s*"\K\d+-\d+-\d+' $(cvsdate)); \
			[ "$(huskylib_mdate)" != "$${curval}" ] && \
			echo "char cvs_date[]=\"$(huskylib_mdate)\";" > $(cvsdate) ||:

        huskylib_get_date: huskylib_update
			$(eval huskylib_mdate:=$(shell cd $(huskylib_ROOTDIR); $(GIT) log -1 \
			--date=short --format=format:"%cd" $(huskylib_H_DIR)*.h \
			$(_SRC_DIR)$(DIRSEP)*.c))

        huskylib_update: | do_not_run_update_as_root
			@[ -d $(huskylib_ROOTDIR).git ] && cd $(huskylib_ROOTDIR) && \
			{ $(GIT) $(PULL) || echo "####### ERROR #######"; } || \
			$(GIT) $(CLONE) https://github.com/huskyproject/huskylib.git
    endif


    ifeq ($(need_smapi), 1)
        smapi_glue: smapi_get_date
			$(eval smapi_date:=$(subst -,,$(smapi_mdate)))
			@cd $(smapi_ROOTDIR); curval=""; \
			[ -f $(cvsdate) ] && \
			curval=$$($(GREP) -Po 'char\s+cvs_date\[\]\s*=\s*"\K\d+-\d+-\d+' $(cvsdate)); \
			[ "$(smapi_mdate)" != "$${curval}" ] && \
			echo "char cvs_date[]=\"$(smapi_mdate)\";" > $(cvsdate) ||:

        smapi_get_date: smapi_update
			$(eval smapi_mdate:=$(shell cd $(smapi_ROOTDIR); $(GIT) log -1 \
			--date=short --format=format:"%cd" $(smapi_H_DIR)*.h $(_SRC_DIR)$(DIRSEP)*.c))

        smapi_update: | do_not_run_update_as_root
			@[ -d $(smapi_ROOTDIR).git ] && cd $(smapi_ROOTDIR) && \
			{ $(GIT) $(PULL) || echo "####### ERROR #######"; } || \
			$(GIT) $(CLONE) https://github.com/huskyproject/smapi.git
    endif


    ifeq ($(need_fidoconf), 1)
        fidoconf_cmp: fidoconf_glue smapi_glue huskylib_glue
			@fidoconf_date=$(fidoconf_date); fidoconf_mdate=$(fidoconf_mdate); \
			if [ $${fidoconf_date} -lt $(huskylib_date) ]; then fidoconf_date=$(huskylib_date); \
			fidoconf_mdate=$(huskylib_mdate); fi;  \
			if [ $${fidoconf_date} -lt $(smapi_date) ]; then fidoconf_date=$(smapi_date); \
			fidoconf_mdate=$(smapi_mdate); fi;  \
			cd $(fidoconf_ROOTDIR); curval=""; \
			[ -f $(cvsdate) ] && \
			curval=$$($(GREP) -Po 'char\s+cvs_date\[\]\s*=\s*"\K\d+-\d+-\d+' $(cvsdate)); \
			[ "$${fidoconf_mdate}" != "$${curval}" ] && \
			echo "char cvs_date[]=\"$${fidoconf_mdate}\";" > $(cvsdate) ||:

        fidoconf_glue: fidoconf_get_date
			$(eval fidoconf_date:=$(subst -,,$(fidoconf_mdate)))

        fidoconf_get_date: fidoconf_update
			$(eval fidoconf_mdate:=$(shell cd $(fidoconf_ROOTDIR); $(GIT) log -1 \
			--date=short --format=format:"%cd" $(fidoconf_H_DIR)*.h \
			$(_SRC_DIR)$(DIRSEP)*.c))

        fidoconf_update: | do_not_run_update_as_root
			@[ -d $(fidoconf_ROOTDIR).git ] && cd $(fidoconf_ROOTDIR) && \
			{ $(GIT) $(PULL) || echo "####### ERROR #######"; } || \
			$(GIT) $(CLONE) https://github.com/huskyproject/fidoconf.git
    endif


    ifeq ($(need_areafix), 1)
        areafix_glue: areafix_get_date
			$(eval areafix_date:=$(subst -,,$(areafix_mdate)))
			@cd $(areafix_ROOTDIR); curval=""; \
			[ -f $(cvsdate) ] && \
			curval=$$($(GREP) -Po 'char\s+cvs_date\[\]\s*=\s*"\K\d+-\d+-\d+' $(cvsdate)); \
			[ "$(areafix_mdate)" != "$${curval}" ] && \
			echo "char cvs_date[]=\"$(areafix_mdate)\";" > $(cvsdate) ||:

        areafix_get_date: areafix_update
			$(eval areafix_mdate:=$(shell cd $(areafix_ROOTDIR); $(GIT) log -1 \
			--date=short --format=format:"%cd" $(areafix_H_DIR)*.h $(_SRC_DIR)$(DIRSEP)*.c))

        areafix_update: | do_not_run_update_as_root
			@[ -d $(areafix_ROOTDIR).git ] && cd $(areafix_ROOTDIR) && \
			{ $(GIT) $(PULL) || echo "####### ERROR #######"; } || \
			$(GIT) $(CLONE) https://github.com/huskyproject/areafix.git
    endif


    ifeq ($(need_hptzip), 1)
        hptzip_glue: hptzip_get_date
			$(eval hptzip_date:=$(subst -,,$(hptzip_mdate)))
			@cd $(hptzip_ROOTDIR); curval=""; \
			[ -f $(cvsdate) ] && \
			curval=$$($(GREP) -Po 'char\s+cvs_date\[\]\s*=\s*"\K\d+-\d+-\d+' $(cvsdate)); \
			[ "$(hptzip_mdate)" != "$${curval}" ] && \
			echo "char cvs_date[]=\"$(hptzip_mdate)\";" > $(cvsdate) ||:

        hptzip_get_date: hptzip_update
			$(eval hptzip_mdate:=$(shell cd $(hptzip_ROOTDIR); $(GIT) log -1 \
			--date=short --format=format:"%cd" $(hptzip_H_DIR)*.h $(_SRC_DIR)$(DIRSEP)*.c))

        hptzip_update: | do_not_run_update_as_root
			@[ -d $(hptzip_ROOTDIR).git ] && cd $(hptzip_ROOTDIR) && \
			{ $(GIT) $(PULL) || echo "####### ERROR #######"; } || \
			$(GIT) $(CLONE) https://github.com/huskyproject/hptzip.git
    endif


    ifeq ($(filter hpt,$(PROGRAMS)),hpt)
        ifeq ($(USE_HPTZIP), 1)
            hpt_cmp: hpt_glue hptzip_glue areafix_glue fidoconf_glue smapi_glue huskylib_glue
				@hpt_date=$(hpt_date); hpt_mdate=$(hpt_mdate); \
				if [ $${hpt_date} -lt $(hptzip_date) ]; \
				then hpt_date=$(hptzip_date); hpt_mdate=$(hptzip_mdate); fi; \
				if [ $${hpt_date} -lt $(areafix_date) ]; \
				then hpt_date=$(areafix_date); hpt_mdate=$(areafix_mdate); fi; \
				if [ $${hpt_date} -lt $(fidoconf_date) ]; \
				then hpt_date=$(fidoconf_date); hpt_mdate=$(fidoconf_mdate); fi; \
				if [ $${hpt_date} -lt $(smapi_date) ]; \
				then hpt_date=$(smapi_date); hpt_mdate=$(smapi_mdate); fi; \
				if [ $${hpt_date} -lt $(huskylib_date) ]; \
				then hpt_mdate=$(huskylib_mdate); fi; \
				cd $(hpt_ROOTDIR); curval=""; \
				[ -f $(cvsdate) ] && \
				curval=$$($(GREP) -Po 'char\s+cvs_date\[\]\s*=\s*"\K\d+-\d+-\d+' $(cvsdate)); \
				[ "$${hpt_mdate}" != "$${curval}" ] && \
				echo "char cvs_date[]=\"$${hpt_mdate}\";" > $(cvsdate) ||:
        else
            hpt_cmp: hpt_glue areafix_glue fidoconf_glue smapi_glue huskylib_glue
				@hpt_date=$(hpt_date); hpt_mdate=$(hpt_mdate); \
				if [ $${hpt_date} -lt $(areafix_date) ]; \
				then hpt_date=$(areafix_date); hpt_mdate=$(areafix_mdate); fi; \
				if [ $${hpt_date} -lt $(fidoconf_date) ]; \
				then hpt_date=$(fidoconf_date); hpt_mdate=$(fidoconf_mdate); fi; \
				if [ $${hpt_date} -lt $(smapi_date) ]; \
				then hpt_date=$(smapi_date); hpt_mdate=$(smapi_mdate); fi; \
				if [ $${hpt_date} -lt $(huskylib_date) ]; \
				then hpt_mdate=$(huskylib_mdate); fi; \
				cd $(hpt_ROOTDIR); curval=""; \
				[ -f $(cvsdate) ] && \
				curval=$$($(GREP) -Po 'char\s+cvs_date\[\]\s*=\s*"\K\d+-\d+-\d+' $(cvsdate)); \
				[ "$${hpt_mdate}" != "$${curval}" ] && \
				echo "char cvs_date[]=\"$${hpt_mdate}\";" > $(cvsdate) ||:
        endif

        hpt_glue: hpt_get_date
			$(eval hpt_date:=$(subst -,,$(hpt_mdate)))

        hpt_get_date: hpt_update
			$(eval hpt_mdate:=$(shell cd $(hpt_ROOTDIR); $(GIT) log -1 \
			--date=short --format=format:"%cd" $(hpt_H_DIR)*.h $(_SRC_DIR)$(DIRSEP)*.c))

        hpt_update: | do_not_run_update_as_root
			@[ -d $(hpt_ROOTDIR).git ] && cd $(hpt_ROOTDIR) && \
			{ $(GIT) $(PULL) || echo "####### ERROR #######"; } || \
			$(GIT) $(CLONE) https://github.com/huskyproject/hpt.git
    endif


    ifeq ($(filter htick,$(PROGRAMS)), htick)
        ifeq ($(USE_HPTZIP), 1)
            htick_cmp: htick_glue hptzip_glue areafix_glue fidoconf_glue smapi_glue huskylib_glue
				@htick_date=$(htick_date); htick_mdate=$(htick_mdate); \
				if [ $${htick_date} -lt $(hptzip_date) ]; \
				then htick_date=$(hptzip_date); htick_mdate=$(hptzip_mdate); fi; \
				if [ $${htick_date} -lt $(areafix_date) ]; \
				then htick_date=$(areafix_date); htick_mdate=$(areafix_mdate); fi; \
				if [ $${htick_date} -lt $(fidoconf_date) ]; \
				then htick_date=$(fidoconf_date); htick_mdate=$(fidoconf_mdate); fi; \
				if [ $${htick_date} -lt $(smapi_date) ]; \
				then htick_date=$(smapi_date); htick_mdate=$(smapi_mdate); fi; \
				if [ $${htick_date} -lt $(huskylib_date) ]; \
				then htick_mdate=$(huskylib_mdate); fi; \
				cd $(htick_ROOTDIR); curval=""; \
				[ -f $(cvsdate) ] && \
				curval=$$($(GREP) -Po 'char\s+cvs_date\[\]\s*=\s*"\K\d+-\d+-\d+' $(cvsdate)); \
				[ "$${htick_mdate}" != "$${curval}" ] && \
				echo "char cvs_date[]=\"$${htick_mdate}\";" > $(cvsdate) ||:
        else
            htick_cmp: htick_glue areafix_glue fidoconf_glue smapi_glue huskylib_glue
				@htick_date=$(htick_date); htick_mdate=$(htick_mdate); \
				if [ $${htick_date} -lt $(areafix_date) ]; \
				then htick_date=$(areafix_date); htick_mdate=$(areafix_mdate); fi; \
				if [ $${htick_date} -lt $(fidoconf_date) ]; \
				then htick_date=$(fidoconf_date); htick_mdate=$(fidoconf_mdate); fi; \
				if [ $${htick_date} -lt $(smapi_date) ]; \
				then htick_date=$(smapi_date); htick_mdate=$(smapi_mdate); fi; \
				if [ $${htick_date} -lt $(huskylib_date) ]; \
				then htick_mdate=$(huskylib_mdate); fi; \
				cd $(htick_ROOTDIR); curval=""; \
				[ -f $(cvsdate) ] && \
				curval=$$($(GREP) -Po 'char\s+cvs_date\[\]\s*=\s*"\K\d+-\d+-\d+' $(cvsdate)); \
				[ "$${htick_mdate}" != "$${curval}" ] && \
				echo "char cvs_date[]=\"$${htick_mdate}\";" > $(cvsdate) ||:
        endif

        htick_glue: htick_get_date
			$(eval htick_date:=$(subst -,,$(htick_mdate)))

        htick_get_date: htick_update
			$(eval htick_mdate:=$(shell cd $(htick_ROOTDIR); $(GIT) log -1 \
			--date=short --format=format:"%cd" $(htick_H_DIR)*.h $(_SRC_DIR)$(DIRSEP)*.c))

        htick_update: | do_not_run_update_as_root
			@[ -d $(htick_ROOTDIR).git ] && cd $(htick_ROOTDIR) && \
			{ $(GIT) $(PULL) || echo "####### ERROR #######"; } || \
			$(GIT) $(CLONE) https://github.com/huskyproject/htick.git
    endif


    ifeq ($(filter hptkill,$(PROGRAMS)), hptkill)
        hptkill_cmp: hptkill_glue fidoconf_glue smapi_glue huskylib_glue
			@hptkill_date=$(hptkill_date); hptkill_mdate=$(hptkill_mdate); \
			if [ $${hptkill_date} -lt $(fidoconf_date) ]; \
			then hptkill_date=$(fidoconf_date); hptkill_mdate=$(fidoconf_mdate); fi; \
			if [ $${hptkill_date} -lt $(smapi_date) ]; \
			then hptkill_date=$(smapi_date); hptkill_mdate=$(smapi_mdate); fi; \
			if [ $${hptkill_date} -lt $(huskylib_date) ]; \
			then hptkill_mdate=$(huskylib_mdate); fi; \
			cd $(hptkill_ROOTDIR); curval=""; \
			[ -f $(cvsdate) ] && \
			curval=$$($(GREP) -Po 'char\s+cvs_date\[\]\s*=\s*"\K\d+-\d+-\d+' $(cvsdate)); \
			[ "$${hptkill_mdate}" != "$${curval}" ] && \
			echo "char cvs_date[]=\"$${hptkill_mdate}\";" > $(cvsdate) ||:

        hptkill_glue: hptkill_get_date
			$(eval hptkill_date:=$(subst -,,$(hptkill_mdate)))

        hptkill_get_date: hptkill_update
			$(eval hptkill_mdate:=$(shell cd $(hptkill_ROOTDIR); $(GIT) log -1 \
			--date=short --format=format:"%cd" $(hptkill_H_DIR)*.h $(_SRC_DIR)$(DIRSEP)*.c))

        hptkill_update: | do_not_run_update_as_root
			@[ -d $(hptkill_ROOTDIR).git ] && cd $(hptkill_ROOTDIR) && \
			{ $(GIT) $(PULL) || echo "####### ERROR #######"; } || \
			$(GIT) $(CLONE) https://github.com/huskyproject/hptkill.git
    endif


    ifeq ($(filter hptsqfix,$(PROGRAMS)), hptsqfix)
        hptsqfix_cmp: hptsqfix_glue smapi_glue huskylib_glue
			@hptsqfix_date=$(hptsqfix_date); hptsqfix_mdate=$(hptsqfix_mdate); \
			if [ $${hptsqfix_date} -lt $(smapi_date) ]; \
			then hptsqfix_date=$(smapi_date); hptsqfix_mdate=$(smapi_mdate); fi; \
			if [ $${hptsqfix_date} -lt $(huskylib_date) ]; \
			then hptsqfix_mdate=$(huskylib_mdate); fi; \
			cd $(hptsqfix_ROOTDIR)$(hptsqfix_H_DIR); curval=""; \
			[ -f $(cvsdate) ] && \
			curval=$$($(GREP) -Po 'char\s+cvs_date\[\]\s*=\s*"\K\d+-\d+-\d+' $(cvsdate)); \
			[ "$${hptsqfix_mdate}" != "$${curval}" ] && \
			echo "char cvs_date[]=\"$${hptsqfix_mdate}\";" > $(cvsdate) ||:

        hptsqfix_glue: hptsqfix_get_date
			$(eval hptsqfix_date:=$(subst -,,$(hptsqfix_mdate)))

        hptsqfix_get_date: hptsqfix_update
			$(eval hptsqfix_mdate:=$(shell cd $(hptsqfix_ROOTDIR); $(GIT) log -1 \
			--date=short --format=format:"%cd" $(hptsqfix_H_DIR)*.h $(_SRC_DIR)$(DIRSEP)*.c))

        hptsqfix_update: | do_not_run_update_as_root
			@[ -d $(hptsqfix_ROOTDIR).git ] && cd $(hptsqfix_ROOTDIR) && \
			{ $(GIT) $(PULL) || echo "####### ERROR #######"; } || \
			$(GIT) $(CLONE) https://github.com/huskyproject/hptsqfix.git
    endif


    ifeq ($(filter sqpack,$(PROGRAMS)), sqpack)
        sqpack_cmp: sqpack_glue fidoconf_glue smapi_glue huskylib_glue
			@sqpack_date=$(sqpack_date); sqpack_mdate=$(sqpack_mdate); \
			if [ $${sqpack_date} -lt $(fidoconf_date) ]; \
			then sqpack_date=$(fidoconf_date); sqpack_mdate=$(fidoconf_mdate); fi; \
			if [ $${sqpack_date} -lt $(smapi_date) ]; \
			then sqpack_date=$(smapi_date); sqpack_mdate=$(smapi_mdate); fi; \
			if [ $${sqpack_date} -lt $(huskylib_date) ]; \
			then sqpack_mdate=$(huskylib_mdate); fi; \
			cd $(sqpack_ROOTDIR); curval=""; \
			[ -f $(cvsdate) ] && \
			curval=$$($(GREP) -Po 'char\s+cvs_date\[\]\s*=\s*"\K\d+-\d+-\d+' $(cvsdate)); \
			[ "$${sqpack_mdate}" != "$${curval}" ] && \
			echo "char cvs_date[]=\"$${sqpack_mdate}\";" > $(cvsdate) ||:

        sqpack_glue: sqpack_get_date
			$(eval sqpack_date:=$(subst -,,$(sqpack_mdate)))

        sqpack_get_date: sqpack_update
			$(eval sqpack_mdate:=$(shell cd $(sqpack_ROOTDIR); $(GIT) log -1 \
			--date=short --format=format:"%cd" $(sqpack_H_DIR)*.h *.c))

        sqpack_update: | do_not_run_update_as_root
			@[ -d $(sqpack_ROOTDIR).git ] && cd $(sqpack_ROOTDIR) && \
			{ $(GIT) $(PULL) || echo "####### ERROR #######"; } || \
			$(GIT) $(CLONE) https://github.com/huskyproject/sqpack.git
    endif


    ifeq ($(filter msged,$(PROGRAMS)), msged)
        msged_cmp: msged_glue fidoconf_glue smapi_glue huskylib_glue
			@msged_date=$(msged_date); msged_mdate=$(msged_mdate); \
			if [ $${msged_date} -lt $(fidoconf_date) ]; \
			then msged_date=$(fidoconf_date); msged_mdate=$(fidoconf_mdate); fi; \
			if [ $${msged_date} -lt $(smapi_date) ]; \
			then msged_date=$(smapi_date); msged_mdate=$(smapi_mdate); fi; \
			if [ $${msged_date} -lt $(huskylib_date) ]; \
			then msged_mdate=$(huskylib_mdate); fi; \
			cd $(msged_ROOTDIR); curval=""; \
			[ -f $(cvsdate) ] && \
			curval=$$($(GREP) -Po 'char\s+cvs_date\[\]\s*=\s*"\K\d+-\d+-\d+' $(cvsdate)); \
			[ "$${msged_mdate}" != "$${curval}" ] && \
			echo "char cvs_date[]=\"$${msged_mdate}\";" > $(cvsdate) ||:

        msged_glue: msged_get_date
			$(eval msged_date:=$(subst -,,$(msged_mdate)))

        msged_get_date: msged_update
			$(eval msged_mdate:=$(shell cd $(msged_ROOTDIR); $(GIT) log -1 \
			--date=short --format=format:"%cd" *.h *.c))

        msged_update: | do_not_run_update_as_root
			@[ -d $(msged_ROOTDIR).git ] && cd $(msged_ROOTDIR) && \
			{ $(GIT) $(PULL) || echo "####### ERROR #######"; } || \
			$(GIT) $(CLONE) https://github.com/huskyproject/msged.git
    endif


    ifeq ($(filter fidoroute,$(PROGRAMS)), fidoroute)
        fidoroute_wdate: fidoroute_get_date
			@cd $(fidoroute_ROOTDIR); curval=""; \
			[ -f $(cvsdate) ] && \
			curval=$$($(GREP) -Po 'char\s+cvs_date\[\]\s*=\s*"\K\d+-\d+-\d+' $(cvsdate)); \
			[ "$(fidoroute_mdate)" != "$${curval}" ] && \
			echo "char cvs_date[]=\"$(fidoroute_mdate)\";" > $(cvsdate) ||:

        fidoroute_get_date: fidoroute_update
			$(eval fidoroute_mdate:=$(shell cd $(fidoroute_ROOTDIR); $(GIT) log -1 \
			--date=short --format=format:"%cd" *.cpp))

        fidoroute_update: | do_not_run_update_as_root
			@[ -d $(fidoroute_ROOTDIR).git ] && cd $(fidoroute_ROOTDIR) && \
			{ $(GIT) $(PULL) || echo "####### ERROR #######"; } || \
			$(GIT) $(CLONE) https://github.com/huskyproject/fidoroute.git
    endif


    ifeq ($(filter util,$(PROGRAMS)), util)
        util_wdate: util_update
			@cd util; curval=""; \
			util_mdate=$$($(GIT) log -1 \
			--date=short --format=format:"%cd" -- $(util_DATEFILES)); \
			[ -f $(cvsdate) ] && \
			curval=$$($(GREP) -Po 'char\s+cvs_date\[\]\s*=\s*"\K\d+-\d+-\d+' $(cvsdate)); \
			[ "$${util_mdate}" != "$${curval}" ] && \
			echo "char cvs_date[]=\"$${util_mdate}\";" > $(cvsdate) ||:

        util_update: | do_not_run_update_as_root
			@[ -d util/.git ] && cd util && \
			{ $(GIT) $(PULL) || echo "####### ERROR #######"; } || \
			$(GIT) $(CLONE) https://github.com/huskyproject/util.git
    endif

    huskybse_update: | do_not_run_update_as_root
		@[ -d $(huskybse_ROOTDIR).git ] && cd $(huskybse_ROOTDIR) && \
		{ $(GIT) $(PULL) || echo "####### ERROR #######"; } || \
		$(GIT) $(CLONE) https://github.com/huskyproject/huskybse.git
endif
