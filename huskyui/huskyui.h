/* huskyui.h - common stuff */

#define nfree(a) { if (a != NULL) { free(a); a = NULL; } }

#define min(a,b)     ((a)<=(b)?(a):(b))
#define max(a,b)     ((a)>(b)?(a):(b))

