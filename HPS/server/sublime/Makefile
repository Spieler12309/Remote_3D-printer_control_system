cc = clang
CFLAGS = -g
COMMON_OBJS = common.o

all: $(COMMON_OBJS)  tcps #tcpc

common.o: Common.h Common.c
	$(CC) $(CFLAGS) -c Common.c

#tcpc: tcpclient.c $(COMMON_OBJS)
#	$(CC) $(CFLAGS) -o tcpc tcpclient.c $(COMMON_OBJS)

tcps: tcpserver.c $(COMMON_OBJS)
	$(CC) $(CFLAGS) -o tcps tcpserver.c $(COMMON_OBJS)

#clean:
#	rm -rf *.o *.dSYM tcps