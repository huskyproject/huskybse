@copy /-Y ..\huskymak.cfg.mvc ..\..\huskymak.cfg
@copy /-Y makeall.mvc ..\..\makefile
@copy /-Y rebase.cmd ..\..\
@copy /-Y bind.cmd  ..\..\
@copy /-Y leave.txt ..\..\
@copy /-Y group.txt ..\..\
@echo *****************************************************
@echo now start Visual Studio Command Prompt
@echo go to top directory where all your husky sources are
@echo and run 'nmake' or 'nmake .help'
@pause