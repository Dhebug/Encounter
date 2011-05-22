#include "MiniGameAwale.h"
#include <stdio.h>

//#include <assert.h>	// no assert on oric!
#define assert(test)

#define DEPTH_SEARCH1	(3)
#define DEPTH_SEARCH2	(4)

#define FALSE			(0)
#define TRUE			(!FALSE)

#define DISPLAY

#ifndef NULL
	#define NULL		(0)
#endif //NULL



static long holdrand = 1L;

int rand()
{
	return(((holdrand = holdrand * 214013L + 2531011L) >> 16) & 0x7fff);
}


void	StateAwale_Reset(StateAwale* state)
{
	// clear map
	int i, j;
	for(j=0; j<LENGTH; ++j)
	{
		for(i=0; i<WIDTH; ++i)
		{
			state->m_map[j][i] = 4;
		}
	}

	// reset garbages
	state->m_garbage[0] = state->m_garbage[1] = 0;

	// clear first player
	state->m_player = rand()&1;
}


int		StateAwale_PlacesToPlay(const StateAwale *state, ShotAwale*	shotArray)
{
	int i, nbShot = 0;
	ShotAwale shot;

	for(i=0; i<WIDTH; ++i)
	{
		if(state->m_map[state->m_player][i]!=0)
		{
			shot = i;
			if(StateAwale_CanPlay(state, shot))
			{
				if(NULL != shotArray)
				{
					shotArray[nbShot] = shot;
				}
				nbShot++;
			}
		}
	}
	return nbShot;
}


int	StateAwale_HasPlaceToPlay(const StateAwale* state)
{
	int hasPlaceToPlay = FALSE;
	int i;
	for(i=0; i<WIDTH; ++i)
	{
		if(state->m_map[state->m_player][i]!=0)
		{
			ShotAwale shot;
			shot = i;
			if(StateAwale_CanPlay(state, shot))
			{
				hasPlaceToPlay = TRUE;
				break;
			}
		}
	}

	return hasPlaceToPlay;
}


int	StateAwale_CanPlay(const StateAwale *state, ShotAwale play)
{
	int ret = FALSE;
	if(play>=0 && play<WIDTH)
	{
		switch(state->m_player)
		{
		case 0:
			{
				if(state->m_map[0][play] > play)
					ret = TRUE;
			}
			break;
		case 1:
			{
				if(state->m_map[1][play] >= (WIDTH - play))
					ret = TRUE;
			}
			break;
		}
	}
	return ret;
}


void	StateAwale_PlayShot(StateAwale* state, ShotAwale play)
{
	int seeds;
	int column;
	int line;
	int step;

	seeds = 0;
	column = play;
	line = state->m_player;
	step = 0;
	assert(StateAwale_CanPlay(state, play));

	// 1°) take the seeds
	seeds = state->m_map[state->m_player][column];
	state->m_map[state->m_player][column] = 0;

	// 2°) drop the seeds on the map
	step = (0==state->m_player) ? -1 : 1;
	while(seeds>0)
	{
		// faire le test avant, de toute façon il faut faire le test,
		// on évite ainsi de faire un incrément plus une correction
		// revoir l'ordre de stockage des troous afin d'avoir un tableau 
		// linéaire et de ne pas faire de test pour step
		column += step;
		if(column<0)
		{
			step = step > 0 ? -1 : 1;
			column = 0;
			line = 1 - line;
		}
		else if(column>=WIDTH)
		{
			step = step > 0 ? -1 : 1;
			column = WIDTH - 1;
			line = 1 - line;
		}

		state->m_map[line][column]++;
		seeds--; 
	};

	// 3°) does we get seeds ?
	if( line == (1-state->m_player))
	{
		step = step > 0 ? -1 : 1;
		while(state->m_map[line][column] == 2 ||
			state->m_map[line][column] == 3)
		{
			state->m_garbage[state->m_player] += state->m_map[line][column];
			state->m_map[line][column] = 0;
			if(column>0 && column<WIDTH-1)
			{
				column += step;
			}
		}
	}

	// 4°) change the player
	StateAwale_SetPlayer(state, 1-StateAwale_GetPlayer(state));
}


//=========================================================
// IA Part
//=========================================================
int StateAwale_AlphaBeta(const StateAwale* state, int player, int alpha, int beta, int depth)
{
	int m, i, t, nbSon;
	int end;
	ShotAwale shotAvailable[WIDTH];
	StateAwale son;

	// must we stop search ?
	if(0 == depth || !StateAwale_HasPlaceToPlay(state))
		return StateAwale_Eval(state, player);


	nbSon = StateAwale_PlacesToPlay(state, shotAvailable);
	if( StateAwale_GetPlayer(state) == player )	// on maximise
	{
		m = alpha;
		end = FALSE;
		for(i=0; !end && i<nbSon; i++)
		{
			son = *state;
			StateAwale_PlayShot(&son, shotAvailable[i]);
			t = StateAwale_AlphaBeta(&son, player, m, beta, depth-1);
			if(t>m)
				m = t;	// mise a jour du max
			if(t>beta)
				end = TRUE;	// elagage de l'arbre
		}
	}
	else // on minimise
	{
		m = beta;
		end = FALSE;
		for(i=0; !end && i<nbSon; i++)
		{
			son = *state;
			StateAwale_PlayShot(&son, shotAvailable[i]);
			t = StateAwale_AlphaBeta(&son, player, alpha, m, depth-1);
			if(t<m)
				m = t;	// mise à jour du min
			if(t<alpha)
				end = TRUE;
		}
	}
	
	return m;
}


int StateAwale_BestShot_AlphaBeta(const StateAwale* state, const ShotAwale* shotArray, int shotArraySize, int depth)
{
	int ret = -1;
	int score, bestScore, bestShot;
	int nbGoodShot = 0;
	int goodShots[WIDTH];
	int i;
	StateAwale son;

	bestScore = -1000;
	assert(depth>=0);
	for(i=0; i<shotArraySize; i++)
	{
		son = *state;
		StateAwale_PlayShot(&son, shotArray[i]);
		score = StateAwale_AlphaBeta(&son, StateAwale_GetPlayer(state), -1000, +1000, depth-1); // start with minimize, invert
		if(score>=bestScore)
		{
			// store every shots with the same score as the best one
			if(score>bestScore)
				nbGoodShot = 0;	// reset best shots array

			goodShots[nbGoodShot] = i; // store shot
			nbGoodShot++;

			// store the best shot
			bestScore = score;
			bestShot = i;
		}
	}

	// return one of the best shot
	bestShot = rand()%nbGoodShot;
	return goodShots[bestShot];
	// return the best shot
	//return bestShot;
}


void	StateAwale_Display(const StateAwale* state)
{
	int i, j;
	puts("+-+-----------------+\n");
	puts("| | 0| 1| 2| 3| 4| 5|\n");
	puts("+-+-----------------+\n");

	for(j=0; j<LENGTH; ++j)
	{
		char player = (StateAwale_GetPlayer(state)==j) ? '*' : ' ';
		printf("|%d|", player);
		for(i=0; i<WIDTH; ++i)
		{
			if(state->m_map[j][i]<10)
				putchar(' ');
			printf("%d|", state->m_map[j][i]);
		}
		putchar('\n');
		puts("+-+-----------------+\n");
	}

	printf("line 0: %d  line 1: %d\n", state->m_garbage[0], state->m_garbage[1]);
	get();
}


ShotAwale GameAwale_GetShot_Human(/*const*/ GameAwale *game )
{
	int place;
	int canPlayShot;
	ShotAwale shot;
	
	canPlayShot = FALSE;
	while(!canPlayShot)
	{
		puts("Select a shot\n");
		//cin >> place;
		//scanf("%d", &place);
		place = getchar();
		if (place>='0' && place<='9')
		{
			shot = place - '0';
			if(StateAwale_CanPlay(&game->m_currentState, shot))
			{
				canPlayShot = TRUE;
			}
		}
		
		if(canPlayShot != TRUE)
		{
			puts("invalid shot\n");
		}
	}

	return shot;
}


ShotAwale GameAwale_GetShot_Cpu0(/*const*/ GameAwale *game )
{
	ShotAwale shotAvailable[WIDTH];
	int nbShot, randShot;
	ShotAwale shot;

	nbShot = StateAwale_PlacesToPlay(&game->m_currentState, shotAvailable);
	randShot = rand()/(RAND_MAX%nbShot);
	shot = shotAvailable[randShot];
	assert(StateAwale_CanPlay(&game->m_currentState, shot));
#ifdef DISPLAY
	//cout << "Shot Selected : " << ret.m_column << endl;
	printf("Shot selected: %d\n", shot);
#endif	

	return shot;
}


ShotAwale GameAwale_GetShot_Cpu1(/*const*/ GameAwale* game )
{
	ShotAwale shotAvailable[WIDTH];
	int nbShot, abShot;
	ShotAwale shot;

	nbShot = StateAwale_PlacesToPlay(&game->m_currentState, shotAvailable);
	abShot = StateAwale_BestShot_AlphaBeta(&game->m_currentState, shotAvailable, nbShot, DEPTH_SEARCH1);
	shot = shotAvailable[abShot];
	assert(StateAwale_CanPlay(&game->m_currentState, shot));
#ifdef DISPLAY
	//cout << "Shot Selected : " << ret.m_column << endl;
	printf("Shot Selected : %d\n", shot );
#endif

	return shot;
}


ShotAwale GameAwale_GetShot_Cpu2(/*const*/ GameAwale* game )
{
	ShotAwale shotAvailable[WIDTH];
	int nbShot, abShot;
	ShotAwale shot;

	nbShot = StateAwale_PlacesToPlay(&game->m_currentState, shotAvailable);
	abShot = StateAwale_BestShot_AlphaBeta(&game->m_currentState, shotAvailable, nbShot, DEPTH_SEARCH2);
	shot = shotAvailable[abShot];
	assert(StateAwale_CanPlay(&game->m_currentState, shot));
#ifdef DISPLAY
	//cout << "Shot Selected : " << ret.m_column << endl;
	printf("Shot Selected : %d\n", shot );
#endif	
	return shot;
}


void	GameAwale_GameInit(GameAwale* game)
{
	// Clear Map
	StateAwale_Reset(&game->m_currentState);

	// Give Player Name
	game->m_player[0] = 'A';
	game->m_player[1] = 'B';

	// Init ShotFunc Ptr (Human or computer)
	//m_shotFunc[0] = GetShot_Human;
	//m_shotFunc[0] = GetShot_Cpu0;
	game->m_shotFunc[0] = GameAwale_GetShot_Cpu1;

	//m_shotFunc[1] = GetShot_Human;
	//m_shotFunc[1] = GetShot_Cpu0;
	//m_shotFunc[1] = GetShot_Cpu1;
	game->m_shotFunc[1] = GameAwale_GetShot_Cpu2;

}


void	GameAwale_GameLoop(GameAwale* game)
{
	ShotAwale shot;
	for(;;)
	{
		// 1°) display current state
#ifdef DISPLAY
		//cout << m_currentState << endl;
		StateAwale_Display(&game->m_currentState);
#endif
		// 2°) test if finished
		if( !StateAwale_HasPlaceToPlay(&game->m_currentState))
			break;
		// 3°) ask the player to play
		//ShotAwale shot = GetShot_Human();
#ifdef DISPLAY
		//cout << "Player: " << (char)(game->m_player[StateAwale_GetPlayer(game->m_currentState.)].m_id) << endl;
		printf("Player: %d\n", (char)(game->m_player[StateAwale_GetPlayer(&game->m_currentState)]));
#endif
		// get player shot
		shot = (game->m_shotFunc[StateAwale_GetPlayer(&game->m_currentState)])(game);
		// and play it
		StateAwale_PlayShot(&game->m_currentState, shot);
	}
}


int	GameAwale_GameTerm(GameAwale* game)
{
	// 5°) display the winner or draw game
	int eval;
	eval = StateAwale_Eval(&game->m_currentState, 0);
#ifdef DISPLAY
	if( 0==eval )
	{
		//cout << "Draw Game" << endl;
		puts("Draw game\n");
	}
	else
	{
		//cout << "The Winner is: " << (char)((eval>0) ? game->m_player[0].m_id : game->m_player[1].m_id) << endl;
		printf("The Winner is: %c\n", (char)((eval>0) ? game->m_player[0] : game->m_player[1]));
	}
#endif

	return (eval==0)?0:(eval>0)?1:2;
}








