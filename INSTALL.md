Husky Installation Instructions
===============================

$Header$

This file covers all basic questions that you might have if you are new to
the Husky software. Please read those sections that are of interest to you
carefully.

Compiling Husky source is a little more complicated than compiling standard
Unix software. In particular, there is no configure script. So even if you
are an experienced user, please have a look at section II of this document.

(Editors note: This file is to be edited with Emacs with text-mode and
auto-fill-mode, and fill-column set to 77. Please indent all text that is to
be set in a fixed-width font with two spaces.)


Contents
========

I.   Overview

II.  Compiling the Source Code

III. How to Configure and Use the Software


I. Overview
===========

The Husky Fidonet software package is split into different "modules". A
module is a library or a program. In order to compile any Husky program, you
will at least have to download the following modules:

  huskybse      Husky Base, contains instructions, a template compilation
                configuration file, and sample configs.
  huskylib      Common declarations and functions for Husky programs
  smapi         The Squish Message API library.
  fidoconf      The Fidoconfig library.

In addition, you need the programs that you want to use, like "hpt" (the
tosser), "htick" (the ticker), "msged" (the mail editor), and others. For a
full list of available modules, refer to the husky homepage.

The distribution filenames of the modules are named

  MODULENAME-VERSION.tar.gz    e.g. smapi-1.6.4-stable.tar.gz

for the release versions or

  MODULENAME-yymmdd.tar.gz     e.g. smapi-000521.tar.gz (snapshot from 21st May 2000)
  MODULENAME-latest.tar.gz     e.g. smapi-latest.tar.gz (current snapshot)

for the daily snapshots. Unless you are a very experienced user, or have
explicitly been instructed, you should use the release versions. They are
available at the Husky homepage at http://husky.sourceforge.net.

Note that IF you really want to get daily snapshots from
http://husky.sourceforge.net/cvs2, you should fetch all modules that
you need at once, i.E. use snapshots from the same day for all libraries and
programs.


II. Compiling the Source Code
=============================

Download all the modules that you want to use, and untar them in a common
directory. E.g:

  mkdir ~/husky
  cd ~/husky
  tar xzf ~/download/huskybse-latest.tar.gz
  tar xzf ~/download/smapi-latest.tar.gz
  tar xzf ~/download/fidoconf-latest.tar.gz
  tar xzf ~/download/hpt-latest.tar.gz

Replace -latest with the actual file name extension. This could be "-latest"
if you download from our CVS site, but it could also be something like
"-1.2.0-stable", "-1.2.1-release", etc.

Then, there are two basic ways of building Husky source: You can use the
standard Makefile with huskymak.cfg, or you can use the platform dependent
Legacy Makefiles. Usually, the former will be your primary choice.


II.1 Compiling and installing with the standard Makefile and huskymak.cfg
-------------------------------------------------------------------------


II.1.1 Overview

This is the standard way of compiling Husky source code on Unix-style
operating systems. It will also work on OS/2 if you have the EMX compiler and
a more or less complete chain of GNU tools installed. You should use this
method if you are a Unix user.

If you compile Husky in this way, the default path of the configuration file
and other specialties will be compiled into your executables based onto your
individual needs, and shared libraries will be used if possible to decrease
hard disk space requirements and improve flexibility.

In order to use the standard Makefiles with huskymak.cfg, you must use GNU
make (gmake). GNU make is the standard make program on Linux, while on most
other Unix systems (including FreeBSD, NetBSD, Tru64, Solaris and others),
the standard "make" command will NOT work with the Husky standard
Makefiles. You should obtain a copy of GNU make and use that one to build
Husky. Or, if you can't get GNU make, refer to section II.2 and use the
legacy Makefiles.

The drawback of this way is that it only works on Unixish systems, and that
it requires some of the libraries to be installed before the rest of the
software can be compiled. If you don't want to install anything while
compiling, you should use the Legacy Makefiles (Section II.2)


II.1.2 Configuring

Every Module is supplied with a "Makefile". This is the standard Makefile,
and will only work with GNU make.

In order to use it, you need to create a file named "huskymak.cfg" in the top
level directory below which you extracted the individual module sources,
which you will use to configure the peculiarities of your system. In the
example from above, this file would be named "~/husky/huskymak.cfg".

You don't need to create this file by hand - the huskybse module contains
template huskymak configuration files. Select one, copy it to the top-level
directory, and then edit it to adapt it to your needs. The following example
files are currently provided:

  File              Platform
  -------------------------------------------------------------------
  huskymak.cfg      Generic UNIX (will work as is on Linux, contains
                    documentation on what to change for other Unices)
  huskymak.cfg.bsd  FreeBSD (possible OpenBSD and NetBSD)
  huskymak.cfg.sun  SunOS (Solaris), using GNU C & GNU make

So, for example, you would do

  cd ~/husky
  cp huskybse/huskymak.cfg ./huskymak.cfg
  emacs huskymak.cfg # or would you rather like vi? ;-)

Note that the "huskybse" subdirectory, like any other subdirectory mentioned
from now on, might also have a version number as prefix, like
"huskybse-0.10", depending from where you got the source files from.

Please read the comments in the template huskymak.cfg and change all values
according to your needs.


II.1.3 Compiling and Installing

Now, you can build smapi and fidoconfig (please do it in this order) using

  cd ~/husky/smapi
  make clean
  # or use "gmake" if "make" does not invoke GNU make on your system!
  make all install

  cd ~/husky/fidoconf
  make clean
  make all install

It is important that you a) INSTALL (gmake install) smapi before you try to
COMIPLE fidoconf, because otherwise the smapi library - which is required for
building fidoconfig - will not be found, and likewise, that you INSTALL
fidoconf before you try to COMPILE anything else. For the other modules, you
don't have to take care about any particular order. You can build and install
any module using the command sequence

  cd ~/husky/MODULENAME
  make clean
  make all install

After you did this with all modules, read on in section III of this document.


II.2 Compiling with the Legacy Makefiles
----------------------------------------


II.2.1 Overview
---------------

Besides the standard "Makefile", most Husky modules deliver additional
makefiles, named "makefile.XXX", where "XXX" is a platform dependent
suffix. Those makefiles are called legacy makefiles by us. They differ from
the standard Makefile in the following ways:

  + You don't need to edit huskymak.cfg, the makefiles work for themselves
  + You can compile everything without having to install anything
  + Many non-UNIX systems are supported
  + You don't need neither GNU make nor gcc if not specified other
  + Sometimes gives less trouble than the standard Makefile

  - You cannot install anything with these makefiles (usualy). It is within
    your responsibility to copy the programs that you compiled to the
    proper directories.
  - No support for shared libraries, everything is linked statically.


II.2.2 List of platforms supported by the legacy makefiles
----------------------------------------------------------

The following is a list of platforms that are supported by legacy
makefiles.

  Makefile         Sup.  Platform  Compiler
  ---------------------------------------------------------------------------

  makefile.unx     1     Unix      Any (standard "cc" is enough!)
  makefile.be      1     BeOS      BeOS R5 with gcc
  makefile.bsd     1     BSD       (tested: FreeBSD) GNU gcc
  makefile.lnx     1     Linux     GNU gcc (2.7..2.95, 3.x)
  makefile.djg     1     DOS/32    DJ Delorie GNU gcc (DJGPP)
  makefile.cyg     1     Win32     Mingw32 on Cygwin: http://www.cygwin.com
  makefile.mvc     1     Win32     Microsoft Visual C
  makefile.mvcdll  1     Win32     Microsoft Visual C - dll build

  makefile.emo     2     OS/2      EMX; OMF static (standalone) binaries
  makefile.emx     2     OS/2      EMX; a.out dynamic (EMXRT) binaries
  makefile.mgw     2     Win32     Mingw32 or Mingw32/CPD gcc: www.mingw32.org
  makefile.rxw     2     Win32     EMX/RSXNT gcc with -Zwin32
  makefile.sun     2     Solaris   GNU gcc
  makefile.wco     2     OS/2      Watcom C
  makefile.wcw     2     Win32     Watcom C
  makefile.wcx     2     DOS/32    Watcom C with DOS extender

  makefile.aix     3     AIX       IBM xlC
  makefile.bcd     3     DOS       Borland C / Turbo C (requires TASM)
  makefile.bco     3     OS/2      Borland C 2.0
  makefile.bcw     3     Win32     Borland C
  makefile.ibo     3     OS/2      IBM CSet or VACPP
  makefile.hco     3     OS/2      Metaware High C
  makefile.osf     3     TRU64     Compaq CC (or DEC Unix with DEC cc)
  makefile.wcd     2     DOS       Watcom C
  makefile.qcd     2     DOS       Quick C / Microsoft MSC 6.0 (req. MASM)

The "Sup." classification has the following meaning:

  1  Means this makefile is the primary one used by Husky developers
     for this particular platform, e.g. for building binary releases. It is
     very well supported and should work without problems. Every Husky
     module that has left beta phase should have this makefile.

  2  At least one Husky developer is sometimes using this file, so it will
     be more or less up to date and should mostly work. Most projects will
     have this makefile.

  3  Only some projects have this makefile, it is not known if anybody
     currently uses this or if it works at all. (Note this does not mean
     that Husky will not work on this PLATFORM, but only that this MAKEFILE
     probably is highly outdated).

As a rule of thumb, if you have any Unix OS with a "make" and a "cc" command,
you should first try to use "makefile.unx". "makefile.unx" is a very
troublefree way of building everything!


II.2.3 Compiling
----------------

First, if your subdirectories contain version number suffixes, you need
to rename the smapi and fidoconf subdirectories to the base name with
out version number suffix. E.g., if, after extracting the sources, you have
directories called like "smapi-1.6.4" and "fidoconf-0.10", you must rename
them to "smapi" and "fidoconf", respectively. This is so that the other
projects are able to find the include files etc. You do not need to rename
the directories for the other projects.

Now that you have chosen the proper makefile, build smapi and fidoconfig like
this (let's assume you have chosen makefile.unx):

  cd ~/husky/huskylib
  make -f makefile.unx clean
  make -f makefile.unx
  cd ~/husky/smapi
  make -f makefile.unx clean
  make -f makefile.unx
  cd ~/husky/fidoconf
  make -f makefile.unx clean
  make -f makefile.unx

You can then directly proceed to build any program like this:

  cd ~/husky/MODULENAME
  make -f makefile.unx

This also works with Non-UNIX systems, e.g.:

  C:
  CD \HUSKY\HUSKYLIB
  imake -f makefile.ibo clean
  imake -f makefile.ibo
  CD \HUSKY\SMAPI
  imake -f makefile.ibo clean
  imake -f makefile.ibo
  CD \HUSKY\FIDOCONF
  imake -f makefile.ibo clean
  imake -f makefile.ibo
  CD \HUSKY\MSGED
  imake -f makefile.ibo clean
  imake -f makefile.ibo


II.2.4 Installing
-----------------

As already noted, the legacy makefiles usually do not contain an "install"
target. Therefore, you have to "install" the programs manually if you use
legacy makefiles (you don't need to install the libraries, as the programs
are linked against those statically). For most Husky programs, installing is
just copying the executables to a directory of your choice. For some others,
it is more complicated, in particular Msged, where you must also install the
recoding tables, help files etc.. Please refer to the individual programs'
documentation for more information.


III How to Configure and Use the Software
=========================================

We assume you have now a set of executables of the Husky software. Either
compiled manually, or downloaded in binary form from somewhere. Now - where
do you go from here?

III.1 Creating the configuration file
-------------------------------------

The good news is that all Husky programs only need a single configuration
file. It's filename is "config", and you should put it into the directory
that you have configured as CFGDIR in huskymak.cfg.

If you don't know the value of CFGDIR, because you compiled the source with
legacy makefiles (no CFGDIR setting) or because you have downloaded binary
versions, you should set up an environent variable FIDOCONFIG which should
contain the path and filename of that config file. E.g., on Unix with
ksh/bash, you would put something like

   FIDOCONFIG=/etc/fido/config; export FIDOCONFIG

to /etc/profile, while you would use

   SET FIDOCONFIG=c:\fido\config

for config.sys on OS/2 or autoexec.bat for Win9x. On Windows NT, you would
use the System Control Panel.

Now what do you write into this configuration file?

III.2 Fidoconfig documentation
------------------------------

Each and every configuration value that you can put into the fidoconfig
configuration file is described in the fidoconfig documentation. If you have
a binary distribution of the Husky software, you should have received this
documentation in HTML or a similar format.

If you have compiled with huskymak.cfg / standard Makefiles, you should
theoretically be able to type "info fidoconfig" on the command line to view
the fidoconfig documentation. However, this will not work on all Linux
distributions.

You can manually build and view the fidoconfig documentation as follows:
Change to the documentation subdirectory:

  cd ~/husky/fidoconf/doc

Then type this to build the GNU info version:

  makeinfo fidoconfig
  info -f ./fidoconfig.info

This requires a working TEXINFO installation on your Unix system. TEXINFO is
also available for OS/2 and cygwin.

Or, you can try to build the HTML version:

  makeinfo --html fidoconfig
(or texi2html fidoconfig)
  lynx ./fidoconfig_toc.html


III.3 Examples
--------------

Not everybody likes to build a config file from scratch using only a keyword
reference. Therefore, the "huskybse" module contains various example
configuration files. Have a look at these!
The "fidoconfig" module contains a script "fidoInst" which asks you some parameter
of your system and will create a basic config file. This script is tested
on linux with bash.


III.4 Other Documentation
-------------------------

Some of the Husky tools have their own documentation. Go and search for it in
their source directory. In particularly, you should read the "installation
instructions" part of the Msged TE manual if you want to use Msged. The Msged
TE manual can be build similar to the fidoconfig manual, but you can also
simply download it in various formats from the Msged TE homepage
(http://www.physcip.uni-stuttgart.de/tobi/msged).

On the Husky homepage (http://husky.sourceforge.net), you will also
find some pointers to FAQ's and other helpful documents.

III.5 Operations Guide
----------------------

With the information mentioned so far, you should be able to get a Fido point
or node going if you are already somewhat familiar with running a Fido
system. Most tools will show some information if you invoke them without
parameter. Unfortunately, there currently is no full Husky operations
guide. Perhaps you want to write one?

Again, a look into the sample files in the "huskybse" module could be
helpful. There are also some scripts.

[EOF]
