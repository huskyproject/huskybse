/* general.c - functions common to poll/send/request */

#include <stdlib.h>
#include <string.h>
#include "fidoconfig.h"
#include "general.h"

/* FLOName - generate name of FLO for a given address
   params: outbound     path of outbound
           Addr         address to generate FLO name for
   result: filename of FLO (memory is allocated automatically) */
char *FLOName(s_fidoconfig *config, s_addr Addr)
{
  char *FName;
  char *FName2;
  char *OutDir;

  // remove trailing directory seperator from outbound
  OutDir = strdup(config->outbound);
  OutDir[strlen(OutDir)-1] = 0;

  FName = calloc(1, 256);
  if ((Addr.domain != NULL) && (config->addr[0].domain != NULL) &&
   (stricmp(Addr.domain, config->addr[0].domain) != 0))
  {
    char *Tmp;

    Tmp = calloc(1, strlen(OutDir)+strlen(Addr.domain)+1);
    strncpy(Tmp, OutDir, strrchr(OutDir, DirSepC)-OutDir+1);
    Tmp[strrchr(OutDir, DirSepC)-OutDir+1] = '\0';

    if (Addr.point != 0)
    {
      if (Addr.zone != config->addr[1].zone)
      {
	sprintf(FName, "%s%s.%03x" DirSepS "%04x%04x.pnt" DirSepS
		"0000%04x.flo", Tmp, Addr.domain, Addr.zone, Addr.net,
		Addr.node, Addr.point);
      }
      else
      {
	sprintf(FName, "%s%s" DirSepS "%04x%04x.pnt" DirSepS "0000%04x.flo",
		Tmp, Addr.domain, Addr.net, Addr.node, Addr.point);
      }
    }
    else
    {
      if (Addr.zone != config->addr[0].zone)
      {
        sprintf(FName, "%s%s.%03x" DirSepS "%04x%04x.flo", Tmp,
         Addr.domain, Addr.zone, Addr.net, Addr.node);
      }
      else
      {
        sprintf(FName, "%s%s" DirSepS "%04x%04x.flo", Tmp,
         Addr.domain, Addr.net, Addr.node);
      }
    }

    free(Tmp);
  }
  else
  {
    if (Addr.point != 0)
    {
      if (Addr.zone != config->addr[0].zone)
      {
	sprintf(FName, "%s.%03x" DirSepS "%04x%04x.pnt" DirSepS "0000%04x.flo",
		OutDir, Addr.zone, Addr.net, Addr.node, Addr.point);
      }
      else
      {
	sprintf(FName, "%s" DirSepS "%04x%04x.pnt" DirSepS "0000%04x.flo",
		OutDir, Addr.net, Addr.node, Addr.point);
      }
    }
    else
    {
      if (Addr.zone != config->addr[0].zone)
      {
	sprintf(FName, "%s.%03x" DirSepS "%04x%04x.flo", OutDir, Addr.zone,
		Addr.net, Addr.node);
      }
      else
      {
	sprintf(FName, "%s" DirSepS "%04x%04x.flo", OutDir, Addr.net,
		Addr.node);
      }
    }
  }

  free(OutDir);
  FName2 = strdup(FName);
  free(FName);
  return FName2;
}

/* strlower - convert string to lower case
   params: s            string to convert to lower case
   result: s */
char *strlower(char *s)
{
  char *tmp;

  for (tmp = s; tmp[0] != '\0'; tmp++) tmp[0] = tolower(tmp[0]);
  return s;
}

/* Str2Addr - parse address-string into binary address
   params: s            string to parse
   result: binary address */
s_addr Str2Addr(char *s)
{
  s_addr a;
  char *Tmp;

  Tmp = calloc(1, 40);
  if (strchr(s, '.') != NULL)
  {
#ifdef LINUX
    unsigned int z, net, node, p;

    sscanf(s, "%u:%u/%u.%u@%s", &z, &net, &node, &p, Tmp);
    a.zone = z; a.net = net; a.node = node; a.point = p;
#else
    sscanf(s, "%u:%u/%u.%u@%s", &a.zone, &a.net, &a.node, &a.point, Tmp);
#endif
  }
  else
  {
#ifdef LINUX
    unsigned int z, net, node;

    sscanf(s, "%u:%u/%u@%s", &z, &net, &node, Tmp);
    a.zone = z; a.net = net; a.node = node;
#else
    sscanf(s, "%u:%u/%u@%s", &a.zone, &a.net, &a.node, Tmp);
#endif
    a.point = 0;
  }
  Tmp[39] = '\0';
  if (Tmp[0] != '\0') a.domain = strlower(strdup(Tmp));
  else a.domain = NULL;
  free(Tmp);

  return a;
}

/* Addr2Str - convert binary address to address-string
   params: a            binary address
   result: address-string (static!) */
char *Addr2Str(s_addr a)
{
  static char s[40];

  if (a.point != 0)
  {
    if (a.domain != NULL)
    {
      sprintf(s, "%d:%d/%d.%d@%s", a.zone, a.net, a.node, a.point, a.domain);
    }
    else
    {
      sprintf(s, "%d:%d/%d.%d", a.zone, a.net, a.node, a.point);
    }
  }
  else
  {
    if (a.domain != NULL)
    {
      sprintf(s, "%d:%d/%d@%s", a.zone, a.net, a.node, a.domain);
    }
    else
    {
      sprintf(s, "%d:%d/%d", a.zone, a.net, a.node);
    }
  }

  return s;
}

/* CompAddr - compare (binary) addresses
   params: a1           first address
           a2           second address
   result: 0 if equal */
int CompAddr(s_addr a1, s_addr a2)
{
  if ((a1.zone != a2.zone) && (a1.zone != 0) && (a2.zone != 0)) return 1;
  if ((a1.net != a2.net) && (a1.net != 0) && (a2.net != 0)) return 1;
  if (a1.node != a2.node) return 1;
  if (a1.point != a2.point) return 1;
  if ((a1.domain != NULL) && (a2.domain != 0) && (stricmp(a1.domain, a2.domain) != 0)) return 1;
  return 0;
}

