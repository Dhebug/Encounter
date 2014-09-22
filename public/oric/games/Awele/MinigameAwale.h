#ifndef __AWELE_H_
#define __AWELE_H_

#define WIDTH	(6)
#define LENGTH	(2)


#define RAND_MAX (0x7fff)
//int rand();

/**
	@brief	definition d'un coup
*/
/*
typedef struct _shot_awale
{
	int	m_column;	// which column ?
}ShotAwale;
*/
typedef int ShotAwale;

/**
	@brief	definition d'un joueur
*/
/*
typedef struct _player_awale
{
	unsigned long	m_id;
}PlayerAwale;
*/
typedef int PlayerAwale;

/**
*/
typedef struct _state_awale
{
	// Datas
	int				m_player;	// current line to play (0 or 1)
	int				m_garbage[LENGTH];
	//unsigned short	m_map[LENGTH][WIDTH];
	int				m_map[LENGTH][WIDTH];
} StateAwale;

void	StateAwale_Reset(StateAwale* state);
int		StateAwale_PlacesToPlay(const StateAwale* state, ShotAwale*	shotArray);
int		StateAwale_HasPlaceToPlay(const StateAwale* state);
int		StateAwale_CanPlay(const StateAwale* state, ShotAwale play);
void	StateAwale_PlayShot(StateAwale* state, ShotAwale play);

//int		StateAwale_GetPlayer(const StateAwale* state)	{ return state->m_player; }
//void	StateAwale_SetPlayer(StateAwale* state, int p)	{ state->m_player = p; }
#define StateAwale_GetPlayer(state)		((state)->m_player)
#define StateAwale_SetPlayer(state, p)	((state)->m_player = p)


// display
//int		StateAwale_Eval(const StateAwale* state, int player) { return state->m_garbage[player] - state->m_garbage[1-player]; }
#define StateAwale_Eval(state, player)	( (state)->m_garbage[player] - (state)->m_garbage[1-player] )

// IA

/**
	@return index of the best shot in the array
*/
int		StateAwale_BestShot_AlphaBeta(const StateAwale* state, const ShotAwale* shotArray, int shotArraySize, int depth);

/**
	@return	an evaluation of the branch
*/
int		StateAwale_AlphaBeta(const StateAwale* state, int player, int alpha, int beta, int depth);




/**
*/
struct _game_awale;
typedef	ShotAwale	(*SHOT_FUNC)(struct _game_awale*);

typedef struct _game_awale
{
	SHOT_FUNC	m_shotFunc[LENGTH];
	PlayerAwale	m_player[LENGTH];
	StateAwale	m_currentState;
} GameAwale;


void	GameAwale_GameInit(GameAwale* game);
void	GameAwale_GameLoop(GameAwale* game);
int		GameAwale_GameTerm(GameAwale* game);

ShotAwale GameAwale_GetShot_Human(GameAwale* game );
ShotAwale GameAwale_GetShot_Cpu0(GameAwale* game );	// random
ShotAwale GameAwale_GetShot_Cpu1(GameAwale* game ); // alpha-beta
ShotAwale GameAwale_GetShot_Cpu2(GameAwale* game ); // alpha-beta bis
#endif // __AWELE_H_


