# $Id$

# This is "makefile common part (include file)" template to build husky library
# using any compiler and make utility.
# Copy this file into your work directory as make/makefile.inc;
# set LIBNAME, OBJ*, HEADERS*, PROGRAMS, VER*, (possible) H_DIR,
# (possible) LIBS and above.
# (1st: replace XXXXX with library name (not more 5 chars long if possible)

#
# Common makefiles part (include-file) for XXXXXlib

# Use defines before including this file:
# _OBJ	object files suffix begins with point (".o", ".obj", ... )
# _LIB	library files suffix begins with point (".a", ".lib", ... )
# _DLL	dinamic linking library files suffix begins with point (".dll", ".so", ...)
# LIBPREFIX  library filename prefix ("lib", "", ...)
# LIBSUFFIX  library filename suffix (compiler ID, three characters, somewhere empty)
# DLLPREFIX  dinamic linking library prefix (usually empty)
# DLLSUFFIX  dinamic linking library suffix (compiler ID or empty)

# Library name
LIBNAME	= XXXXX

# Version
VERMAJOR= 0
VERMINOR= 1
VER	= $(VERMAJOR).$(VERMINOR)

# Object files (example from huskylib)
OBJS1	= calendar$(_OBJ) cvtdate$(_OBJ) fexist$(_OBJ) ffind$(_OBJ) genmsgid$(_OBJ)
OBJS2	= memory$(_OBJ) parsenn$(_OBJ) patmat$(_OBJ) setfsize$(_OBJ) strext$(_OBJ)
OBJS3	= strftime$(_OBJ) tdelay$(_OBJ)
OBJS	= $(OBJS1) $(OBJS2) $(OBJS3)

# Header files (example from huskylib)
HEADERS1= calendar.h compiler.h cvtdate.h ffind.h huskylib.h patmat.h
HEADERS2= parsenn.h strext.h unused.h vixie.h
HEADERS3= BCD.h BCO.h BCW.h BEOS5.h BORLANDC.h DJGPP.h EMX.h HIGHC.h IBMC_OS2.h
HEADERS4= MINGW32.h MSC.h MSVC.h SASC.h UNIX.h WATCOMC.h WCD.h WCO.h WCW.h WCX.h
HEADERS	= $(HEADERS1) $(HEADERS2) $(HEADERS3) $(HEADERS4)

# Binary file(s) to build from sources (example from huskylib)
PROGRAMS= gnmsgid$(_EXE)

SRC_DIR	=../src/
H_DIR	=../h/

# Usually compose from LIBPREFIX, LIBSUFFIX and LIB.
TARGETLIB = $(LIBPREFIX)$(LIBNAME)$(LIBSUFFIX)$(_LIB)
TARGETDLL = $(DLLPREFIX)$(LIBNAME)$(DLLSUFFIX)$(_DLL)

# List of HUSKY libraries required to build binary file(s)
# Examples! Change to real please.
LIBS	= -lhusky$(LIBSUFFIX) -lsmapi$(LIBSUFFIX)
DLLS	= ../../$(DLLPREFIX)husky$(DLLSUFFIX)$(_DLL) ../../$(DLLPREFIX)smapi$(DLLSUFFIX)$(_DLL)
