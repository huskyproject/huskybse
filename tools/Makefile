include ../../huskymak.cfg

all: poll$(EXE) request$(EXE) send$(EXE) tolower$(EXE)

ifeq ($(DEBUG), 1)
  CFLAGS=-I$(INCDIR) $(DEBCFLAGS) $(WARNFLAGS)
  LFLAGS=$(DEBLFLAGS)
else
  CFLAGS=-I$(INCDIR) $(OPTCFLAGS) $(WARNFLAGS)
  LFLAGS=$(OPTLFLAGS)
endif

ifeq ($(SHORTNAME), 1)
  LIBS=-L$(LIBDIR) -lsmapi -lfidoconf
else
  LIBS=-L$(LIBDIR) -lsmapi -lfidoconfig
endif

CDEFS=-D$(OSTYPE) $(ADDCDEFS)


.c$(OBJ):
	$(CC) $(CFLAGS) $(CDEFS) -c $<

poll$(EXE): poll$(OBJ) general$(OBJ)
	$(CC) $(LFLAGS) -o poll$(EXE) poll$(OBJ) general$(OBJ) $(LIBS)

request$(EXE): request$(OBJ) general$(OBJ)
	$(CC) $(LFLAGS) -o request$(EXE) request$(OBJ) general$(OBJ) $(LIBS)

send$(EXE): send$(OBJ) general$(OBJ)
	$(CC) $(LFLAGS) -o send$(EXE) send$(OBJ) general$(OBJ) $(LIBS)

tolower$(EXE): tolower$(OBJ)
	$(CC) $(LFLAGS) -o tolower$(EXE) tolower$(OBJ) $(LIBS)

clean:
	-$(RM) *~
	-$(RM) *$(OBJ)

distclean: clean
	-$(RM) poll$(EXE)
	-$(RM) request$(EXE)
	-$(RM) send$(EXE)
	-$(RM) tolower$(EXE)

install:
	$(INSTALL) $(IBOPT) poll$(EXE) $(BINDIR)
	$(INSTALL) $(IBOPT) request$(EXE) $(BINDIR)
	$(INSTALL) $(IBOPT) send$(EXE) $(BINDIR)
	$(INSTALL) $(IBOPT) tolower$(EXE) $(BINDIR)

