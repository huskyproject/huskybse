/* cfg.c - read config */
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <ctype.h>
#include "cfg.h"

tCfg cfg;

void cfgInit()
{
  FILE *f;
  char *fname;
  char line[512];
  char *pos;
  char *field, *content;
  int i;

  memset(&cfg, 0, sizeof(tCfg));
  cfg.fconf = readConfig(NULL);

  fname = getConfigFileNameForProgram("HUSKYUI", "huskyui.cfg");
  if (fname == NULL) fname = strdup("huskyui.cfg");

  f = fopen(fname, "r");

  if (f == NULL)
  {
      printf("Could not read config file '%s'!", fname);
      sleep(1);
      free(fname);

      return;
  }
  free(fname);

  while (feof(f) == 0)
  {
    line[0] = 0;
    fgets(line, 256, f);

    if (line[0] != 0)
    {
      // strip LF
      while ((line[0] != 0) && (line[strlen(line) - 1] == '\n'))
	line[strlen(line) - 1] = 0;

      if ((line[0] == 0) || (line[0] == '#') || (line[0] == ';')) continue;

      // split into field and content
      if (strchr(line, ' ') == NULL)
      {
        field = strdup(line);
	content = strdup("");
      }
      else
      {
        pos = strchr(line, ' ');
	field = malloc((pos - line) + 1);
	strncpy(field, line, (pos - line));
	field[(pos - line)] = 0;

	while (*pos == ' ') pos++;
	content = strdup(pos);
      }

      // convert field to lower case
      for (i = 0; i < strlen(field); i++)
      {
        field[i] = tolower(field[i]);
      }

      if (strcmp(field, "bossaddr") == 0)
      {
	string2addr(content, &cfg.bossAddr);
      }
      else if (strcmp(field, "maileditor") == 0)
      {
        cfg.mailEditor = strdup(content);
      }
      else if (strcmp(field, "pollcmd") == 0)
      {
        cfg.pollCmd = strdup(content);
      }
      else if (strcmp(field, "logfile") == 0)
      {
        cfg.logName = strdup(content);
      }
      else if (strcmp(field, "numloglines") == 0)
      {
	sscanf(content, "%d", &cfg.numLogLines);
      }
      else
      {
        printf("unknown field '%s'\n", field);
	sleep(1);
      }

      free(field);
      free(content);
    }
  }

  fclose(f);
}

void cfgDone()
{
  disposeConfig(cfg.fconf);
}

