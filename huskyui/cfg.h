/* cfg.h - read config */
#include <fidoconfig/fidoconfig.h>
#include <fidoconfig/common.h>

typedef struct _tCfg
{
  s_addr bossAddr;
  char *mailEditor;
  char *pollCmd;
  char *logName;
  int numLogLines;
  s_fidoconfig *fconf;
} tCfg;

extern tCfg cfg;

// read config
void cfgInit();

// dispose config
void cfgDone();

