

void pt3init();
void pl();

void main()
{
	printf("Initializing\r\n");
	pt3init();
	printf("Playing\r\n");
	while (1)
	{
		pl();
		printf(".");
	}
}


