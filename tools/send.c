/* poll.c - create a flowfile for a node/point to call him */

#include <errno.h>
#include "fidoconfig.h"
#include "general.h"

int main(int argc, char *argv[])
{
  s_fidoconfig *config;

  if (argc < 4)
  {
    printf("send - send files to node/point\n");
    printf("Syntax: send <address> <flavour> {<file>}\n");

    return 1;
  }

  config = readConfig();

  if (config != NULL)
  {
    char *flo = FLOName(config, Str2Addr(argv[1]));
    FILE *f;

    if (stricmp(argv[2], "immediate") == 0) flo[strlen(flo)-3] = 'i';
    else if (stricmp(argv[2], "crash") == 0) flo[strlen(flo)-3] = 'c';
    else if (stricmp(argv[2], "normal") == 0) flo[strlen(flo)-3] = 'f';
    else if (stricmp(argv[2], "direct") == 0) flo[strlen(flo)-3] = 'd';
    else if (stricmp(argv[2], "hold") == 0) flo[strlen(flo)-3] = 'h';
    else
    {
      printf("Invalid flavour '%s'! Using normal.\n", argv[2]);
      flo[strlen(flo)-3] = 'f';
    }

    f = fopen(flo, "a");
    if (f == NULL)
    {
      printf("Could not open '%s' (error #%d: %s)!\n", flo, errno,
	     strerror(errno));
    }
    else
    {
      int i;

      for (i = 0; i < (argc - 3); i++) fprintf(f, "%s\n", argv[i+3]);
      fclose(f);
    }

    free(flo);
  }
  else
  {
    printf("Cannot read fidoconfig!\n");

    return 5;
  }

}

