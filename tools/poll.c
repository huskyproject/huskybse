/* poll.c - create a flowfile for a node/point to call him */

#include <errno.h>
#include <fidoconfig/fidoconfig.h>
#include <string.h>
#include <stdlib.h>
#include "general.h"

int main(int argc, char *argv[])
{
  s_fidoconfig *config;

  if (argc < 2)
  {
    printf("poll - poll (create a flowfile for) a node/point\n");
    printf("Syntax: poll <address> [<flavour>]\n");

    return 1;
  }

  config = readConfig();

  if (config != NULL)
  {
    char *flo = FLOName(config, Str2Addr(argv[1]));
    FILE *f;

    if (argc > 2)
    {
      if (stricmp(argv[2], "immediate") == 0) flo[strlen(flo)-3] = 'i';
      else if (stricmp(argv[2], "crash") == 0) flo[strlen(flo)-3] = 'c';
      else if (stricmp(argv[2], "normal") == 0) flo[strlen(flo)-3] = 'f';
      else if (stricmp(argv[2], "direct") == 0) flo[strlen(flo)-3] = 'd';
      else if (stricmp(argv[2], "hold") == 0) flo[strlen(flo)-3] = 'h';
      else
      {
	printf("Invalid flavour '%s'! Using crash.\n", argv[2]);
	flo[strlen(flo)-3] = 'c';
      }
    }
    else flo[strlen(flo)-3] = 'c';

    f = fopen(flo, "a");
    if (f == NULL)
    {
      printf("Could not open '%s' (error #%d: %s)!\n", flo, errno,
	     strerror(errno));
    }
    else fclose(f);

    free(flo);
  }
  else
  {
    printf("Cannot read fidoconfig!\n");

    return 5;
  }

  return 0;
}

