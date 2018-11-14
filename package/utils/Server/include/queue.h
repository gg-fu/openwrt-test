#ifndef _QUEUE_H
#define _QUEUE_H

#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/msg.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

struct msg{
    long mtype;
    char mtext[1024];
};

int recvMsg(struct msg *mybuf);
int sendMsg(char *data);
int init_queue(void);


#endif
