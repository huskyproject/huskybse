/* poll.c - create a flowfile for a node/point to call him */

#include <errno.h>
#include <fidoconfig/fidoconfig.h>
#include <string.h>
#include <stdlib.h>
#include "general.h"

int main(int argc, char *argv[])
{
  s_fidoconfig *config;

  if (argc < 3)
  {
    printf("request - request files from node/point\n");
    printf("Syntax: request <address> {<file>}\n");

    return 1;
  }

  config = readConfig();

  if (config != NULL)
  {
    char *flo = FLOName(config, Str2Addr(argv[1]));
    FILE *f;

    flo[strlen(flo)-3] = 'r';
    flo[strlen(flo)-2] = 'e';
    flo[strlen(flo)-1] = 'q';

    f = fopen(flo, "a");
    if (f == NULL)
    {
      printf("Could not open '%s' (error #%d: %s)!\n", flo, errno,
	     strerror(errno));
    }
    else
    {
      int i;

      for (i = 0; i < (argc - 2); i++) fprintf(f, "%s\n", argv[i+2]);
      fclose(f);
    }

    free(flo);
  }
  else
  {
    printf("Cannot read fidoconfig!\n");

    return 5;
  }

  return 0;
}

