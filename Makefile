all: make-tools make-huskyui
clean: clean-tools clean-huskyui
distclean: distclean-tools distclean-huskyui
install: install-tools install-huskyui

make-tools:
	$(MAKE) -C tools -f makefile.husky

clean-tools:
	$(MAKE) -C tools -f makefile.husky clean

distclean-tools:
	$(MAKE) -C tools -f makefile.husky distclean

install-tools:
	$(MAKE) -C tools -f makefile.husky install

make-huskyui:
	$(MAKE) -C huskyui -f makefile.husky

clean-huskyui:
	$(MAKE) -C huskyui -f makefile.husky clean

distclean-huskyui:
	$(MAKE) -C huskyui -f makefile.husky distclean

install-huskyui:
	$(MAKE) -C huskyui -f makefile.husky install

