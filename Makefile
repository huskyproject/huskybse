all: make-tools make-huskyui make-nmcopy
clean: clean-tools clean-huskyui clean-nmcopy
distclean: distclean-tools distclean-huskyui distclean-nmcopy
install: install-tools install-huskyui install-nmcopy

make-tools:
	$(MAKE) -C tools

clean-tools:
	$(MAKE) -C tools clean

distclean-tools:
	$(MAKE) -C tools distclean

install-tools:
	$(MAKE) -C tools install

make-huskyui:
	$(MAKE) -C huskyui

clean-huskyui:
	$(MAKE) -C huskyui clean

distclean-huskyui:
	$(MAKE) -C huskyui distclean

install-huskyui:
	$(MAKE) -C huskyui install

make-nmcopy:
	$(MAKE) -C nmcopy

clean-nmcopy:
	$(MAKE) -C nmcopy clean

distclean-nmcopy:
	$(MAKE) -C nmcopy distclean

install-nmcopy:
	$(MAKE) -C nmcopy install

