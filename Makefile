# huskybse/Makefile
#
# It is the main makefile for the Husky build environment
#
# This file is part of the Husky fidonet software project
# Use with GNU make v.3.82 or later
# Requires: husky environment
#

SHELL = /bin/sh
.DEFAULT_GOAL := build

ifeq ($(MAKECMDGOALS),)
    MAKECMDGOALS := build
endif

ostyp := $(shell uname -s)

Make = make
ifeq ($(ostyp),FreeBSD)
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
else ifeq ($(DYNLIBS),1)
    $(error LIBDIR not defined!)
endif
ifdef DOCDIR
    DOCDIR_DST=$(DESTDIR)$(DOCDIR)$(DIRSEP)
    PARENT_DOCDIR_DST=$(dir $(DESTDIR)$(DOCDIR))
endif
ifdef INFODIR
    INFODIR_DST=$(DESTDIR)$(INFODIR)$(DIRSEP)
    info_RECIPE := cd $(INFODIR_DST);
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

# The default soutce file extension
DEFAULT_SRC_EXT := $(_C)

### huskylib ###
# The directory with header files
huskylib_H_DIR = huskylib$(DIRSEP)

### smapi ###
# The directory with header files
smapi_H_DIR = smapi$(DIRSEP)

### fidoconf ###
# The directory with header files
fidoconf_H_DIR := fidoconf$(DIRSEP)
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
htick_DOCDIR   = $(htick_ROOTDIR)doc$(DIRSEP)
htick_DATEDEPS = $(HPTZIP) areafix fidoconf smapi huskylib
htick_UNDOCDIR_PREREQ := htick_doc_uninstall
htick_INFO = htick.info.gz

### hptkill ###
# The directory with header files
hptkill_H_DIR = h$(DIRSEP)
hptkill_DATEDEPS = fidoconf smapi huskylib
# Directories
hptkill_MANDIR   = $(hptkill_ROOTDIR)

### hptsqfix ###
# The directory with header files
hptsqfix_H_DIR   = h$(DIRSEP)
hptsqfix_CVSDATEDIR := hptsqfix$(DIRSEP)$(hptsqfix_H_DIR)
hptsqfix_DATEDEPS  = smapi huskylib

### sqpack ###
# The source files
sqpack_DATEFILES := *$(_C) *.h
# Directories
sqpack_SRCDIR     = $(sqpack_ROOTDIR)
sqpack_MANDIR     = $(sqpack_ROOTDIR)
sqpack_DATEDEPS   = fidoconf smapi huskylib

### msged ###
# The source files
msged_DATEFILES := *$(_C) *.h
# Directories
msged_SRCDIR     = $(msged_ROOTDIR)
msged_MAPDIR     = $(msged_ROOTDIR)maps$(DIRSEP)
msged_DATEDEPS   = fidoconf smapi huskylib
msged_UNDOCDIR_PREREQ := uninstall_msged_DOCDIR_DST
msged_INFO = msged.info.gz

### fidoroute ###
# The source files
fidoroute_SRC_EXT   := .cpp
fidoroute_DATEFILES := *.cpp *.h
# Directories
fidoroute_SRCDIR     = $(fidoroute_ROOTDIR)
fidoroute_MANDIR     = $(fidoroute_ROOTDIR)

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

MSGED := $(filter msged,$(PROGRAMS))

UTIL := $(filter util,$(PROGRAMS))

USED_LIBRARIES := $(HUSKYLIB) $(SMAPI) $(FIDOCONF) $(AREAFIX) $(HPTZIP)

ENABLED := huskybse
$(foreach sub,$(SUBPROJECTS),\
    $(if $(filter $(sub),\
        $(PROGRAMS) $(USED_LIBRARIES)),\
        $(eval ENABLED += $(sub)),))

ifneq ($(filter build install,$(MAKECMDGOALS)),)

# Get the version components from the "version.h" file
# $1 is the file path
# $2 is <subproject>_VER_MAJOR
# $3 is <subproject>_VER_MINOR
# $4 is <subproject>_VER_PATCH
# $5 is <subproject>_VER_BRANCH
define getVerParts
    perl -e 'use List::Util "first"; \
    open(fh, "<", "$(1)"); my @a=<fh>; close(fh); chomp @a;  \
    my $$b1 = first { s/$(2)/$$1/; } @a; \
    my $$b2 = first { s/$(3)/$$1/; } @a; print "$$b1.$$b2 "; \
    my $$b3 = first { s/$(4)/$$1/; } @a; print "$$b3 "; \
    my $$b4 = first { s/$(5)/$$1/; } @a; print "$$b4";'
endef

# Get the date from the "cvsdate.h" file
# $1 is the file path
define getCvsdate
    perl -e 'open(fh, "<", "$(1)"); my @a=<fh>; close(fh); chomp @a; \
    $$a[0] =~ m/^char\s+cvs_date\[\]\s*=\s*"\K\d+-\d+-\d+/; print "$$&";'
endef

# Generate the full subproject version, fetching information
# from "version.h" and "cvsdate.h" files.
# $1 is the subproject name
define getVer
    $1_file1 := $1/$$($1_H_DIR)version.h
    $1_s1    := ^\#define\s+$1_VER_MAJOR\s+(\d+)
    $1_s2    := ^\#define\s+$1_VER_MINOR\s+(\d+)
    $1_s3    := ^\#define\s+$1_VER_PATCH\s+(\d+)
    $1_s4    := ^\#define\s+$1_VER_BRANCH\s+(\w+)

    $1_V:=$$(shell $$(call getVerParts,$$($1_file1),$$($1_s1),$$($1_s2),$$($1_s3),$$($1_s4)))

    $1_VERH := $$(firstword $$($1_V))
    $1_VERBRANCH := $$(lastword $$($1_V))

    $1_file2    = $$(or $$($1_CVSDATEDIR),$1/)cvsdate.h
    $1_cvsdate := $$(shell $$(call getCvsdate,$$($1_file2)))

    ifneq ($$($1_VERBRANCH),BRANCH_CURRENT)
        $1_VERPATCH := $$(word 2,$$($$1_V))
        $1_VER      := $$($$1_VERH).$$($$1_VERPATCH)
    else
        $1_reldate := $$(subst -,,$$($1_cvsdate))
        $1_VER     := $$($1_VERH).$$($1_reldate)
    endif
endef

# Generate version numbers for subprojects
$(foreach sub,$(USED_LIBRARIES) $(MSGED) $(UTIL),$(eval $(call getVer,$(sub))))

endif # ifneq ($(filter build install,...


# Generate cvsdate.h
# Here $1 means a subproject name
define gen_cvsdate
	cd "$(or $($1_CVSDATEDIR),$($1_ROOTDIR))"; curval=""; \
	[ -f $(cvsdate) ] && \
	curval=$$(perl -e 'open(fh, "<", "$(cvsdate)"); my @a=<fh>; close(fh); chomp @a; $$a[0]=~ m/^char\s+cvs_date\[\]\s*=\s*"\K\d+-\d+-\d+/; print $$&;'); \
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
DEFAULT_DATEFILES = $($1_H_DIR)*.h $(_SRC_DIR)$(DIRSEP)*$(_C)

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
$1_CFLAGS   := $$(CFLAGS)
$1_ALL_SRC  := $$(wildcard $$($1_SRCDIR)*$$(or $$($1_SRC_EXT),$$(DEFAULT_SRC_EXT)))
ifeq ($1,hpt)
    ifeq ($(PERL),1)
        $1_CFLAGS   := -DDO_PERL $$(shell perl -MExtUtils::Embed -e ccopts) $$(CFLAGS)
    else
        $1_ALL_SRC  := $$(filter-out $$($1_SRCDIR)perl.c,$$($1_ALL_SRC))
    endif
endif
ifeq ($1,hptzip)
    $1_ALL_SRC := $$(filter-out $$($1_SRCDIR)test.c $$($1_SRCDIR)version.c,$$($1_ALL_SRC))
    ifeq ($(findstring MINGW,$(ostyp)),)
         $1_ALL_SRC := $$(filter-out $$($1_SRCDIR)iowin32.c,$$($1_ALL_SRC))
    endif
endif
ifeq ($1,msged)
    ifeq ($(OSTYPE), UNIX)
        ifneq ("$(TERMCAP)", "")
            msged_OSLIBS=-l$(TERMCAP)
        endif
        # remove what belongs to OS2
        $1_ALL_SRC := $$(filter-out $$($1_SRCDIR)os2scr.c,$$($1_ALL_SRC))
        $1_ALL_SRC := $$(filter-out $$($1_SRCDIR)malloc16.c,$$($1_ALL_SRC))
        # remove what belongs to WINNT
        $1_ALL_SRC := $$(filter-out $$($1_SRCDIR)winntscr.c,$$($1_ALL_SRC))
    endif
    ifeq ($(OSTYPE), OS2)
        # remove what belongs to UNIX
        $1_ALL_SRC := $$(filter-out $$($1_SRCDIR)ansi.c,$$($1_ALL_SRC))
        $1_ALL_SRC := $$(filter-out $$($1_SRCDIR)readtc.c,$$($1_ALL_SRC))
        # remove what belongs to  WINNT
        $1_ALL_SRC := $$(filter-out $$($1_SRCDIR)winntscr.c,$$($1_ALL_SRC))
    endif
    ifneq ($$(findstring MINGW,$(ostyp)),)
        # remove what belongs to UNIX
        $1_ALL_SRC := $$(filter-out $$($1_SRCDIR)ansi.c,$$($1_ALL_SRC))
        $1_ALL_SRC := $$(filter-out $$($1_SRCDIR)readtc.c,$$($1_ALL_SRC))
        # remove what belongs to OS2
        $1_ALL_SRC := $$(filter-out $$($1_SRCDIR)os2scr.c,$$($1_ALL_SRC))
        $1_ALL_SRC := $$(filter-out $$($1_SRCDIR)malloc16.c,$$($1_ALL_SRC))
    endif
    ifeq ($(OSTYPE), Cygwin)
        ifneq ("$(TERMCAP)", )
            msged_OSLIBS=-l$(TERMCAP)
        endif
        # remove what belongs to OS2
        $1_ALL_SRC := $$(filter-out $$($1_SRCDIR)os2scr.c,$$($1_ALL_SRC))
        $1_ALL_SRC := $$(filter-out $$($1_SRCDIR)malloc16.c,$$($1_ALL_SRC))
        # remove what belongs to WINNT
        $1_ALL_SRC := $$(filter-out $$($1_SRCDIR)winntscr.c,$$($1_ALL_SRC))
    endif
    ifneq ($(OSTYPE), MSDOS)
        $1_ALL_SRC := $$(filter-out $$($1_SRCDIR)dosasm.c,$$($1_ALL_SRC))
        $1_ALL_SRC := $$(filter-out $$($1_SRCDIR)dosmisc.c,$$($1_ALL_SRC))
    endif
    # The source files to exclude
    msged_excl := ibmscrn.c mouse4.c pacific.c rfind1st.c sasc.c vio.c
    msged_excl := $$(addprefix $$(msged_SRCDIR),$$(msged_excl))
    $1_ALL_SRC := $$(filter-out $$(msged_excl),$$($1_ALL_SRC))
endif
$1_ALL_OBJS := $$(addprefix $$($1_OBJDIR),$$(notdir $$($1_ALL_SRC:$$(or $$($1_SRC_EXT),$$(DEFAULT_SRC_EXT))=$$(_OBJ))))
$1_DEPS     := $$(addprefix $$($1_DEPDIR),$$(notdir $$($1_ALL_SRC:$$(or $$($1_SRC_EXT),$$(DEFAULT_SRC_EXT))=$$(_DEP))))

# Add subproject rules to the dependencies

UPDATE_PREREQ        += $1_update
ifneq ($1,huskybse)
    BUILD_PREREQ     += $1_build
    DEPEND_PREREQ    += $1_depend
    INSTALL_PREREQ   += $1_install
    CLEAN_PREREQ     += $1_clean
    DISTCLEAN_PREREQ += $1_distclean
    UNDOCDIR_PREREQ  += $($1_UNDOCDIR_PREREQ)
    UNINSTALL_PREREQ += $1_uninstall
endif

.PHONY: $($1_UNDOCDIR_PREREQ)
.PHONY: $(addprefix $1_,build update depend install clean distclean uninstall)

ifneq ($$($1_INFO),)
    info_PREREQ += $(INFODIR_DST)$$($1_INFO)
    info_RECIPE +=  install-info "$$($1_INFO)" "$(INFODIR_DST)dir";

    $(INFODIR_DST)$$($1_INFO): $$($1_BUILDDIR)$$($1_INFO) | $(DESTDIR)$(INFODIR)
		$(INSTALL) $(IMOPT) "$$<" "$$|"
		$(TOUCH) "$$@"

    uninfo_RECIPE += $(if $(uninfo_RECIPE),;) [ -f $(INFODIR_DST)$$($1_INFO) ] && \
		install-info --remove --info-dir=$(DESTDIR)$(INFODIR) \
		$(INFODIR_DST)$$($1_INFO)
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
	$$(if $$(filter $1,huskybse),,$$(call gen_cvsdate,$1))

ifeq ($(MAKECMDGOALS),depend)
ifeq ($$(filter $1,huskybse fidoroute util),)
    # main depend rule for a subproject
    $1_depend: $$($1_DEPS)

    # Build a dependency makefile for every source file
#    $(areafix_DEPS): $(areafix_DEPDIR)%$(_DEP): $(areafix_SRCDIR)%.c | $(areafix_DEPDIR)
#    	@set -e; rm -f $@; \
#    	$(CC) -MM $(CFLAGS) $(areafix_CDEFS) $< > $@.$$$$; \
#    	sed 's,\($*\)\$(_OBJ)[ :]*,$(areafix_OBJDIR)\1$(_OBJ) $@ : ,g' < $@.$$$$ > $@; \
#    	rm -f $@.$$$$
    $$($1_DEPS): $$($1_DEPDIR)%$$(_DEP): \
        $$($1_SRCDIR)%$$(or $$($1_SRC_EXT),$$(DEFAULT_SRC_EXT)) | $$($1_DEPDIR)
		@set -e; rm -f $$@; \
		$$(CC) -MM $$($1_CFLAGS) $$($1_CDEFS) $$< > $$@.$$$$$$$$; \
		sed 's,\($$*\)\$$(_OBJ)[ :]*,$$($1_OBJDIR)\1$$(_OBJ) $$@ : ,g' \
		< $$@.$$$$$$$$ > $$@; \
		rm -f $$@.$$$$$$$$

    $$($1_DEPDIR): | $$($1_BUILDDIR) do_not_run_depend_as_root
		[ -d $$@ ] || $(MKDIR) $(MKDIROPT) $$@
endif # filter
endif # depend

ifeq ($$(filter $1,huskybse util),)
$$($1_BUILDDIR):
	[ -d $$@ ] || $(MKDIR) $(MKDIROPT) $$@
endif

.PHONY: $1_update $1_glue $1_git_update $1_depend

endef # gen_subproject

# Generate main update and depend rules for subprojects
$(foreach sub,$(ENABLED),$(eval $(call gen_subproject,$(sub))))


.PHONY: build install uninstall clean distclean depend update
.PHONY: do_not_run_make_as_root do_not_run_depend_as_root

build: $(BUILD_PREREQ) ;

ifeq ($(MAKECMDGOALS),build)
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
	echo "Trying to update $*" && \
	{ $(GIT) $(PULL) || echo "####### ERROR #######"; } || \
	$(GIT) $(CLONE) https://github.com/huskyproject/$*.git
