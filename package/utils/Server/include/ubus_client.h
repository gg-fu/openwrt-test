#ifndef _UBUS_CLIENT_H
#define _UBUS_CLIENT_H

#include <stdio.h>
#include <libubus.h>
#include <signal.h>
#include <pthread.h>
#include <libdaemon/daemon.h>
#include <libubox/blobmsg_json.h>

#define DBG_vPrintf(a,b,ARGS...) do {  if (a) daemon_log(LOG_INFO,"%s: " b, __FUNCTION__, ## ARGS);} while(0)

void init_ubus(void);
int Send_user_message();
void *client_main(void *arg);
void Bru_create_pthread(void *(*func)(void *),void *arg);

#endif

