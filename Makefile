all: make-tools make-huskyui
clean: clean-tools clean-huskyui
distclean: distclean-tools distclean-huskyui
install: install-tools install-huskyui

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

