@echo off
if EXIST ..\..\huskymak.cfg.mvc echo Don't write huskymak.cfg.mvc: file exist!
if NOT EXIST ..\..\huskymak.cfg.mvc copy /-Y ..\huskymak.cfg.mvc ..\..\
if NOT EXIST ..\..\makefile     echo Don't write makefile: file exist!
if NOT EXIST ..\..\makefile         copy /-Y makeall.mvc ..\..\makefile
@copy /-Y rebase.cmd ..\..\
@copy /-Y bind.cmd  ..\..\
@copy /-Y leave.txt ..\..\
@copy /-Y group.txt ..\..\
@echo *****************************************************
@echo now start Visual Studio Command Prompt
@echo go to top directory where all your husky sources are
@echo and run 'nmake' or 'nmake .help'
@pause