#include <stdio.h>
#include <stdlib.h>
#include "ubus_client.h"

int main(int arc,char *argv[])
{
	int sum = Add(4,6);
	printf("the sum is :%d\n",sum);	
	return 0;
}
