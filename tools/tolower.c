/*
 * tolower.c - rename to lowercase name
 */

#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <fidoconfig/fidoconfig.h>
#include <ctype.h>

char *buffer;
char *tmp;

int main(int argc, char *argv[])
{
  if (argv[1] == NULL)
  {
    printf("Syntax: tolower <file>\n");
    return 1;
  }

  buffer = strdup(argv[1]);

  if (strchr(buffer, PATH_DELIM) != NULL)
    for (tmp = strchr(buffer, PATH_DELIM); *tmp != 0; tmp++)
	 *tmp = tolower(*tmp);
  else
    for (tmp = buffer; *tmp != 0; tmp++) *tmp = tolower(*tmp);

  if (rename(argv[1], buffer) == 0)
  {
    printf("renamed '%s' to '%s'\n", argv[1], buffer);
  }
  else
  {
    printf("could not rename '%s' to '%s'!\n", argv[1], buffer);
    free(buffer);

    return 2;
  }

  free(buffer);

  return 0;
}
