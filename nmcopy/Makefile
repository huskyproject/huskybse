include ../../huskymak.cfg

all: nmcopy$(EXE)

ifeq ($(DEBUG), 1)
  CFLAGS=-I$(INCDIR) $(DEBCFLAGS) $(WARNFLAGS)
  LFLAGS=$(DEBLFLAGS)
else
  CFLAGS=-I$(INCDIR) $(OPTCFLAGS) $(WARNFLAGS)
  LFLAGS=$(OPTLFLAGS)
endif

ifeq ($(SHORTNAME), 1)
  LIBS=-L$(LIBDIR) -lfidoconf -lsmapi
else
  LIBS=-L$(LIBDIR) -lfidoconfig -lsmapi
endif

CDEFS=-D$(OSTYPE) $(ADDCDEFS)


.c$(OBJ):
	$(CC) $(CFLAGS) $(CDEFS) -c $<

nmcopy$(EXE): nmcopy$(OBJ)
	$(CC) $(LFLAGS) -o nmcopy$(EXE) nmcopy$(OBJ) $(LIBS)

clean:
	-$(RM) *~
	-$(RM) *$(OBJ)

distclean: clean
	-$(RM) nmcopy$(EXE)

install:
	$(INSTALL) $(IBOPT) nmcopy$(EXE) $(BINDIR)

