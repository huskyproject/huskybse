#ifndef __SOCK_H__
#define __SOCK_H__

#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <errno.h>
#include <unistd.h>
#include <netinet/in.h>
#include <limits.h>
#include <netdb.h>
#include <arpa/inet.h>

/* On some crazy systems, these aren't defined. */
#ifndef EXIT_FAILURE
#define EXIT_FAILURE 1
#endif
#ifndef EXIT_SUCCESS
#define EXIT_SUCCESS 0
#endif

int atoport(/* char *service, char *proto */);
struct in_addr *atoaddr(/* char *address */);
int sock_read(/* int sockfd, char *buf, size_t count */);
int sock_write(/* int sockfd, const char *buf, size_t count */);
int sock_gets(/* int sockfd, char *str, size_t count */);
int sock_puts(/* int sockfd, const char *str */);
void ignore_pipe(/*void*/);

int get_connection(/* int socket_type, u_short port, int *listener */);
int make_connection(/* char *service, int type, char *netaddress */);

#endif
