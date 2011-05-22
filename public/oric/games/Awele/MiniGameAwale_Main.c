#include "lib.h"
#include "MiniGameAwale.h"
//#include <stdio.h>

#define NB_TEST	(5000)



/*
void srand(unsigned int seed)
{
	holdrand = seed;
}
*/


	int res[] = { 0, 0, 0};


int main()
{
	GameAwale game;
	int i;

	// for cpu, we can need random
	//srand(time(0));
	//srand(0);

	printf("Awele\n");
	for(i=0; i<NB_TEST; ++i)
	{
		printf("Game init\n");
		GameAwale_GameInit(&game);
		printf("Game loop\n");
		GameAwale_GameLoop(&game);
		printf("Game term\n");
		res[GameAwale_GameTerm(&game)]++;
	}

	//cout << "Draw: " << res[0] << endl;
	//cout << "P1:   " << res[1] << endl;
	//cout << "P2:   " << res[2] << endl;
	printf("Draw: %d\n", res[0]);
	printf("P1:   %d\n", res[1]);
	printf("P2:   %d\n", res[2]);

	return 0;
}