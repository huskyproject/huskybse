/* general.h - functions common to poll/send/request */

#ifdef UNIX
#define DirSepC '/'
#define DirSepS "/"
#else
#define DirSepC '\\'
#define DirSepS "\\"
#endif

char *FLOName(s_fidoconfig *config, s_addr Addr);
char *strlower(char *s);
s_addr Str2Addr(char *s);
char *Addr2Str(s_addr a);
int CompAddr(s_addr a1, s_addr a2);

