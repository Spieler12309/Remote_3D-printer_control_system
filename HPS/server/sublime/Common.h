#ifndef _COMMON_H_
#define _COMMON_H_

#include "stdlib.h"
#include "stdio.h"
#include "sys/socket.h"
#include "sys/types.h"
#include "signal.h"
#include "stdio.h"
#include "string.h"
#include "unistd.h"
#include "arpa/inet.h"
#include "stdarg.h"
#include "errno.h"
#include "fcntl.h"
#include "sys/time.h"
#include "sys/ioctl.h"
#include "netinet/in.h"//"netbd.h"

#define SERVER_PORT 18000

#define MAXLINE 20//4096
#define SA struct sockaddr

void err_n_die(const char *fmt, ...);
char *bin2hex(const unsigned char *input, size_t len);

#endif