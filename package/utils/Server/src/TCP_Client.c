#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>
#include "queue.h"
#include "ubus_client.h"
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <event.h>
#define DBG_TCP_SERVER 2
static int socket_fd=-1;
static struct event_base *main_base;
static struct event net_event;

void readHandler(const int fd, const short which, void *arg)
{
	char buf[1024]={0};
	int ret = read(fd,buf,sizeof(buf));
	if (ret == -1)
	{
		DBG_vPrintf(DBG_TCP_SERVER,"read fialed and try to reconnect!\n");
		event_del(&net_event);
		close(socket_fd);
		sleep(1);
		connect_server("127.0.0.1",8888);
		return;
	}
	printf("read msg:%s\n",buf);
	Send_user_message();
}

int connect_server(char *ip,int port)
{
	socket_fd = socket(AF_INET,SOCK_STREAM,0);
	if (socket_fd < 0)
	{
		perror("socket failed\n");
		return -1;
	}
	struct sockaddr_in remote_addr; //服务器端网络地址结构体
 	memset(&remote_addr,0,sizeof(remote_addr)); //数据初始化--清零
        remote_addr.sin_family=AF_INET; //设置为IP通信
        remote_addr.sin_addr.s_addr=inet_addr(ip);//服务器IP地址
        remote_addr.sin_port=htons(port); //服务器端口号
        int con_result = connect(socket_fd, (struct sockaddr*) &remote_addr, sizeof(struct sockaddr));
        if(con_result < 0)
	{
		perror("connect failed!\n");
        	close(socket_fd);
            	return -1;
        }

	event_set(&net_event,socket_fd,EV_READ|EV_PERSIST,readHandler,main_base);
        event_base_set(main_base, &net_event);
        event_add(&net_event,NULL);

        return 0;
}

int main(int argc,char *argv[])
{
	init_ubus();
	init_queue();
	//char buf[100]="who am i,and where i want to go?";
	//struct msg *mybuf = (struct msg *)calloc(1,sizeof(struct msg));

	main_base = event_init();
	connect_server("127.0.0.1",8888);
	/*while(1)
	{
		Send_user_message();
		sendMsg(buf);
		sleep(2);
		recvMsg(mybuf);
		printf("recv buf:%s\n",mybuf->mtext);
		memset(mybuf,0,sizeof(struct ms));
	}
	free(mybuf);*/
	event_base_loop(main_base,0);
	return 0;
}
