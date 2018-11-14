#include "queue.h"
#define key 123
static int msg_id;

int init_queue(void)
{
	msg_id = msgget(key, IPC_CREAT | 0666);
    	if (msg_id == -1) 
	{
		fprintf(stderr,"msgget failed\n");
		return -1;
	}
	return msg_id;
	
}

int sendMsg(char *data)
{
	// 2. 初始化要发生的消息
        struct msg mybuf;
        mybuf.mtype = 1;
        strncpy(mybuf.mtext, data,strlen(data));
        // 3. 发送消息
	if (msg_id == -1)
	{
		return -1;
	}
        if (msgsnd(msg_id, &mybuf, sizeof(mybuf.mtext), 0)==-1) 
	{
		fprintf(stderr,"msgsnd failed\n");
		return -1;
	}
	return 0;
}

int recvMsg(struct msg *mybuf)
{
        // 2. 接收第一条消息，存到 mybuf 中
	if (msg_id == -1)
	{
		return -1;
	}
        if (msgrcv(msg_id, mybuf, sizeof(mybuf->mtext), 0, IPC_NOWAIT) == -1) 
	{ 
            	return -1;
        } 
	return 0;
}
