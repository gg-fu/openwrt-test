#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ubus_server.h"


int main(int argc,char *argv[])
{
	ubus_server_main("/var/run/ubus.sock");
	return 0;
}
