/* nmcopy.c - copies netmails to homedirs */

// obvious
#define VERSION "1.0"
// group with all fido-users
#define GROUPNAME "fido"
// file/path of area, relative to homedir
#define NETMAILAREA ".fido/netmail"

#include <errno.h>
#include <smapi/msgapi.h>
#include <fidoconf/fidoconf.h>
#include <fidoconf/common.h>
#include <string.h>
#include <stdlib.h>
#include <pwd.h>
#include <grp.h>
#include <sys/types.h>

#ifndef nfree
#define nfree(a) { if (a) { free(a); a = NULL; } }
#endif

char **users = NULL;
char **userNames = NULL;
char **homeDirs = NULL;
unsigned int numUsers = 0;
s_fidoconfig *config = NULL;

void cvtAddr(const NETADDR aka1, s_addr *aka2)
{
  aka2->zone = aka1.zone;
  aka2->net  = aka1.net;
  aka2->node = aka1.node;
  aka2->point = aka1.point;
}

void done()
{
  unsigned int i;

  for (i = 0; i < numUsers; i++)
  {
    nfree(users[i]);
    nfree(userNames[i]);
    nfree(homeDirs[i]);
  }
  nfree(users);
  nfree(userNames);
  nfree(homeDirs);

  if (config) disposeConfig(config);
}

char *getHomeDir(char *user)
{
  struct passwd *pw;

  pw = getpwnam(user);
  return strdup(pw->pw_dir);
}

char *getRealname(char *user)
{
  struct passwd *pw;
  char *pos;
  char *res;

  pw = getpwnam(user);
  if (!pw) return strdup(user);

  if ((pw->pw_gecos != NULL) && (*pw->pw_gecos != 0))
  {
    pos = strchr(pw->pw_gecos, ',');
    if (pos)
    {
      res = malloc(pos - pw->pw_gecos + 1);
      strncpy(res, pw->pw_gecos, pos - pw->pw_gecos);
      res[pos - pw->pw_gecos] = 0;

      return res;
    }
    else return strdup(pw->pw_gecos);
  }
  else return strdup(user);
}

void getUsers()
{
  struct group *gr;
  unsigned int i;

  gr = getgrnam(GROUPNAME);
  if (!gr)
  {
    printf("Could not get members of group '%s'!\n", GROUPNAME);
    done();
    exit(10);
  }

  for (i = 0; (gr->gr_mem[i]); i++)
  {
    numUsers++;
    users = realloc(users, numUsers * sizeof(char *));
    users[i] = strdup(gr->gr_mem[i]);
  }
  userNames = malloc(numUsers * sizeof(char *));
  homeDirs = malloc(numUsers * sizeof(char *));
  for (i = 0; i < numUsers; i++)
  {
    userNames[i] = strLower(getRealname(users[i]));
    homeDirs[i] = getHomeDir(users[i]);
  }
}

int scanMsg(HAREA area, unsigned int msgNum)
{
  HMSG msg, newMsg;
  XMSG xmsg;
  long int addrMatch, nameMatch;
  unsigned int i;
  char *toLow;
  s_addr dest;
  char *text, *ctrlText;
  unsigned long int textLen, ctrlLen;
  HAREA userArea;
  char *userAreaName;

  msg = MsgOpenMsg(area, MOPEN_READ, msgNum);
  if (msg == NULL) return 0;

  MsgReadMsg(msg, &xmsg, 0, 0, NULL, 0, NULL);

  // check address
  addrMatch = -1;
  cvtAddr(xmsg.dest, &dest);
  for (i = 0; i < config->addrCount; i++)
    if (addrComp(dest, config->addr[i]) == 0)
    {
      addrMatch = i;
      i = config->addrCount;
    }

  if (addrMatch == -1) return 0;

  // check name
  nameMatch = -1;
  toLow = strLower(strdup(xmsg.to));
  for (i = 0; i < numUsers; i++)
    if (strstr(toLow, userNames[i]))
    {
      printf("Message #%d to '%s' matching user '%s'\n", msgNum, toLow,
	     users[i]);
      nameMatch = i;
      i = numUsers;
    }
  nfree(toLow);

  if (nameMatch == -1) return 0;

  // copy msg
  userAreaName = malloc(strlen(homeDirs[nameMatch])+strlen(NETMAILAREA)+2);
  sprintf(userAreaName, "%s/%s", homeDirs[nameMatch], NETMAILAREA);

  userArea = MsgOpenArea(userAreaName, MSGAREA_NORMAL, MSGTYPE_SQUISH);
  if (!userArea)
  {
    printf("Could not open area '%s' for user '%s'!\n", userAreaName,
	   users[nameMatch]);
    nfree(userAreaName);

    return 0;
  }
  nfree(userAreaName);

  textLen = MsgGetTextLen(msg);
  ctrlLen = MsgGetCtrlLen(msg);

  text = (char *) malloc(textLen+1);
  text[textLen] = '\0';

  ctrlText = (char *) malloc(ctrlLen+1);
  ctrlText[ctrlLen] = '\0';

  MsgReadMsg(msg, NULL, 0, textLen, (byte*)text, ctrlLen, (byte*)ctrlText);
  newMsg = MsgOpenMsg(userArea, MOPEN_CREATE, 0);

  MsgWriteMsg(newMsg, 0, &xmsg, (byte*)text, textLen, textLen, ctrlLen, (byte*)ctrlText);
  MsgCloseMsg(newMsg);

  free(text);
  free(ctrlText);

  MsgCloseArea(userArea);

  return 1;
}

void scanArea(HAREA area)
{
  unsigned int highMsg;
  unsigned int i;

  highMsg = MsgGetHighMsg(area);
  for (i = 1; i <= highMsg; i++)
  {
    if (scanMsg(area, i))
    {
//      printf("deleting msg #%d\n", i);
      MsgKillMsg(area, i);
    }
  }
}

int main(int argc, char **argv)
{
  struct _minf m;
  HAREA area;

  printf("nmcopy %s\n", VERSION);

  if (argc > 1)
  {
    printf("nmcopy - copy netmails to homedirs\n");
    printf("Syntax: nmcopy\n");

    return 1;
  }

  // get usernames
  getUsers();

  // read fidoconfig
  config = readConfig(NULL);

  if (config != NULL)
  {
    m.req_version = 0;
    m.def_zone = config->addr[0].zone;

    if (MsgOpenApi(&m) != 0)
    {
      printf("Cannot open smapi!\n");
      done();
      return 6;
    }

    area = MsgOpenArea(config->netMailAreas[0].fileName, MSGAREA_NORMAL,
		       config->netMailAreas[0].msgbType);
    if (!area)
    {
      printf("Cannot open primary netmail area!\n");
      done();
      return 7;
    }
    else
    {
      scanArea(area);
      MsgCloseArea(area);
    }

    done();
  }
  else
  {
    printf("Cannot read fidoconfig!\n");
    done();

    return 5;
  }

  return 0;
}

