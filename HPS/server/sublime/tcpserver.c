#include "Common.h"
#include <strings.h>

int main(int argc, char **argv)
{
	int listenfd, connfd, n;
	struct sockaddr_in servaddr;
	uint8_t buff[MAXLINE+1];
	uint8_t recvline[MAXLINE+1];

	if((listenfd = socket(AF_INET, SOCK_STREAM, 0)) < 0)
		err_n_die("socket error");

	bzero(&servaddr, sizeof(servaddr));
	servaddr.sin_family = AF_INET;
	servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
	servaddr.sin_port = htons(SERVER_PORT);

	if((bind(listenfd, (SA *) &servaddr, sizeof(servaddr)))<0)
		err_n_die("bind error");

	if((listen(listenfd, 10))<0)
		err_n_die("listen error");

	for( ; ; )
	{
		struct  sockaddr_in addr;
		socklen_t addr_len;

		printf("waiting for a connection port %d\n", SERVER_PORT);
		fflush(stdout);
		connfd = accept(listenfd, (SA *) NULL, NULL);

		memset(recvline, 0, MAXLINE);
        printf("recvline = %s\n", recvline);
        n = read(connfd, recvline, MAXLINE-1);
        printf("n = %d\n",n);
        printf("%s\n", bin2hex(recvline, n));
        //printf("\n%s\n\n%s\n", n, bin2hex(recvline, n));

		while ((n = read(connfd, recvline, MAXLINE-1))>0)
		{
            //fprintf(stdout, "%s", recvline);
			fprintf(stdout, "%s\n%s\n", bin2hex(recvline, n), recvline);
		    //printf("recvline = %u\n", recvline);
		}
        printf(stdout,"\n");
		if (recvline[n-1] == '\n')
			break;
        printf("loop\n");

        memset(recvline, 0, MAXLINE);
	}

	printf("out of loop\n");
	if(n<0)
		err_n_die("read error");

	snprintf((char*)buff, sizeof(buff), "HTTP/1.0 200 OK\r\n\r\nHEllo");
    printf("buff = %s\n",buff);
	write(connfd, (char*)buff, strlen((char*)buff));
	close(connfd);
	return 0;

	//отложенный запуск печати
	//удаленный запуск печати
	//на разбери реализованные сервера


	//мб камера
}