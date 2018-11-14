#ifndef _UBUS_SERVER_H
#define _UBUS_SERVER_H

#include <stdio.h>
#include <libubus.h>
#include <signal.h>
#include <pthread.h>
#include <libdaemon/daemon.h>
#include <libubox/blobmsg_json.h>

#define DBG_vPrintf(a,b,ARGS...) do {  if (a) daemon_log(LOG_INFO,"%s: " b, __FUNCTION__, ## ARGS);} while(0)

void ubus_server_main(char *ubus_socket);
int Send_user_message();

#endif


