include ../../huskymak.cfg

all: huskyui$(EXE)

ifeq ($(DEBUG), 1)
  CFLAGS=-I$(INCDIR) $(DEBCFLAGS) $(WARNFLAGS)
  LFLAGS=$(DEBLFLAGS)
else
  CFLAGS=-I$(INCDIR) $(OPTCFLAGS) $(WARNFLAGS)
  LFLAGS=$(OPTLFLAGS)
endif

ifeq ($(SHORTNAME), 1)
  LIBS=-L$(LIBDIR) -lncurses -lsmapi -lfidoconf
else
  LIBS=-L$(LIBDIR) -lncurses -lsmapi -lfidoconfig
endif

CDEFS=-D$(OSTYPE) $(ADDCDEFS)

.c$(OBJ):
	$(CC) $(CFLAGS) $(CDEFS) -c $<

huskyui$(EXE): huskyui$(OBJ) sock$(OBJ) showlog$(OBJ) showoutb$(OBJ)\
  menu$(OBJ) cfg$(OBJ) screen$(OBJ)
	$(CC) $(LFLAGS) -o huskyui$(EXE) huskyui$(OBJ) sock$(OBJ) \
	  showlog$(OBJ) showoutb$(OBJ) menu$(OBJ) cfg$(OBJ) \
	  screen$(OBJ) $(LIBS)

clean:
	-$(RM) *~
	-$(RM) *$(OBJ)

distclean: clean
	-$(RM) huskyui$(EXE)

install:
	$(INSTALL) $(IBOPT) huskyui$(EXE) $(BINDIR)

