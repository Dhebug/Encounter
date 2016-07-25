
#include    "lib.h"

#include    "defines.h"
#include    "levels.c"

#include    "sprites.c"
#include    "walls.c"



extern	unsigned char	DisplayBuffer[];

extern	unsigned int	ScreenOff[];


//
// GRAF.S
//
extern	void AddMessage(char *message,char color);

extern	void ClearDisplayBuffer();

extern	void SetScreenSize(unsigned int largeur);
extern	void SetSpriteSize(unsigned int largeur,unsigned int hauteur);
extern	void DrawSprite(char *dest,char *source);

extern	void FillColumn(char *ptr_screen,unsigned char height,unsigned char value);
extern	void FillBox(char *ptr_screen,unsigned int size,unsigned char value);

extern	void AffText(char *ptr_screen,char *string);


//
// TIMER.S
//
extern	void	     VSync();
extern	void	     TimeIrqHandler();
extern	void	     Wait(unsigned int delay);
extern	unsigned int TimeValueIrq;		    // Contient la valeur courante de time



void cling();




unsigned char	GroundType[]=
{
    GROUND_NONE,				    // 0    Le sol
    GROUND_OPAQUE|GROUND_SOLIDE,		    // 1    Les vrais murs
    GROUND_CHUTE,				    // 2    Les trappes
    //GROUND_OPAQUE|GROUND_SOLIDE|GROUND_CLOSABLE,    // 3    Porte
    GROUND_CLOSABLE,	// 3	Porte
    GROUND_TELEPORT,				    // 4    Teleporteur
    GROUND_OPAQUE|GROUND_SOLIDE|GROUND_BUTTON,	    // 5    Bouton sur un mur
    GROUND_BUTTON,				    // 6    Bouton sur le sol
    GROUND_INSERT,				    // 7    Serrure, fente pour piece, ou emplacement pour objet
};





typedef struct
{
    char	    name[8];

    short int	    visage;
    short int	    race;
    short int	    class;

    short int	    life_point;
    short int	    strenght_point;
    short int	    magic_point;

    short int	    max_life_point;
    short int	    max_strenght_point;
    short int	    max_magic_point;

    unsigned char   inventory[8];
} PLAYER;


/*
char	*InlineHelp[];
{
    //1234567890123456789012345678901234567890
    {"Dungeon Preview release 3"},
    {"========================="},
    {"You can move with the arrows. Up and"},
    {"Down for moving forward and backward"},
    {""},
    {""},
    {""},
}
*/




char	*NameClasses[]=
{
    {"FIGHTER"},
    {"RANGER"},
    {"MAGICIAN"},
    {"CLERIC"},
    {"THIEF"},
};


char	*NameRaces[]=
{
    {"HUMAN"},
    {"ELF"},
    {"DWARF"},
    {"HALFLING"},
    {"HALF-ELF"},
};




PLAYER	Player[4]=
{
    {
	"CONAN  ",
	SPRITE_VISAGE_1,
	RACE_HUMAN   ,
	CLASS_FIGHTER ,
	30,22, 0,40,40,40,
	{
	    EMPTY,
	    SPRITE_TORCHE,
	    EMPTY,
	    EMPTY,
	    EMPTY,
	    EMPTY,
	    EMPTY,
	    EMPTY
	}
    },

    {
	"ARNOLD ",
	SPRITE_VISAGE_3,
	RACE_DWARF   ,
	CLASS_FIGHTER ,
	15,40, 5,40,40,40,
	{
	    EMPTY,
	    SPRITE_POMME,
	    EMPTY,
	    EMPTY,
	    EMPTY,
	    EMPTY,
	    EMPTY,
	    EMPTY
	}
    },

    {
	"GANDALF",
	SPRITE_VISAGE_2,
	RACE_ELF     ,
	CLASS_MAGICIAN,
	20,10,40,40,40,40,
	{
	    SPRITE_PARCHEMIN,
	    SPRITE_CLEF  ,
	    EMPTY,
	    EMPTY,
	    EMPTY,
	    EMPTY,
	    EMPTY,
	    EMPTY
	}
    },

    {
	"DAROU  ",
	SPRITE_VISAGE_5,
	RACE_HALF_ELF,
	CLASS_CLERIC  ,
	10, 5,30,40,40,40,
	{
	    EMPTY,
	    EMPTY,
	    EMPTY,
	    EMPTY,
	    EMPTY,
	    EMPTY,
	    EMPTY,
	    EMPTY
	}
    },
};





unsigned char	PlayerPlace[4]={0,1,2,3};

unsigned char	LocalMap[3][5];

unsigned char	FlagMove=TRUE;
unsigned char	FlagDoorOpen=TRUE;

unsigned char	Leader=0;
unsigned char	Level=0;
char		XPos=6; 	// (3,1) -> Normal starting pos
char		YPos=2;
signed char	XWalk=0;
signed char	YWalk=-1;
signed char	Direction=DIRECTION_NORTH;
unsigned int	LastTimeAction;
unsigned int	LastTimeMessage;
unsigned int	CurrentTime;






char *SpritePos[]=
{
    (char*)0xa000-1+40*12+10*0,     // ???
    (char*)0xa000-1+40*12+10*1,
    (char*)0xa000-1+40*12+10*2,
    (char*)0xa000-1+40*12+10*3,
    (char*)0xa000-1+40*38+5*0,
    (char*)0xa000-1+40*38+5*1,
    (char*)0xa000-1+40*38+5*2,
    (char*)0xa000-1+40*38+5*3,
    (char*)0xa000-1+40*38+5*4,
    (char*)0xa000-1+40*38+5*5,
    (char*)0xa000-1+40*38+5*6,
    (char*)0xa000-1+40*38+5*7,
};






void draw_objects()
{
    int 	    i,p,o;

    SetSpriteSize(5,22);

    /* Visages */
    for (i=0;i<4;i++)
    {
	p=PlayerPlace[i];
	DrawSprite(SpritePos[i]      ,(char*)sprites+Player[p].visage*110-1);  // Visage

	o=Player[p].inventory[0];
	if (o==255)		    o=SPRITE_MAIN_GAUCHE;	    // Main gauche vide
	DrawSprite(SpritePos[4+i*2]  ,(char*)sprites+o*110-1);	    // Main gauche pleine

	o=Player[p].inventory[1];
	if (o==255)		    o=SPRITE_MAIN_DROITE;	    // Main droite vide
	DrawSprite(SpritePos[4+i*2+1],(char*)sprites+o*110-1);	    // Main droite pleine
    }
}






void display_3d()
{
    unsigned int    x,y;
    unsigned char   *ptr;

    SetScreenSize(30);

    //
    //
    // Optimisation de la carte:
    // - On supprime toutes les cases qui sont masqu‚es par d'autres
    //
    //
    if (LocalMap[1][1] & GROUND_OPAQUE)
    {
	LocalMap[1][0]&=~GROUND_OPAQUE;

	if (LocalMap[0][1] & GROUND_OPAQUE)
	{
	    LocalMap[0][0]&=~GROUND_OPAQUE;
	}

	if (LocalMap[2][1] & GROUND_OPAQUE)
	{
	    LocalMap[2][0]&=~GROUND_OPAQUE;
	}
    }


    if (LocalMap[1][2] & GROUND_OPAQUE)
    {
	LocalMap[1][1]&=~GROUND_OPAQUE;
	LocalMap[1][0]&=~GROUND_OPAQUE;
	if (LocalMap[0][2] & GROUND_OPAQUE)
	{
	    LocalMap[0][1]&=~GROUND_OPAQUE;
	    LocalMap[0][0]&=~GROUND_OPAQUE;
	}

	if (LocalMap[2][2] & GROUND_OPAQUE)
	{
	    LocalMap[2][1]&=~GROUND_OPAQUE;
	    LocalMap[2][0]&=~GROUND_OPAQUE;
	}
    }

    //
    //
    // Efface la vue 3d pendant que l'on fait les redraw
    //
    //
    ClearDisplayBuffer();




    //
    //
    // Les murs et objets du cot‚ gauche
    // de la vue 3d
    //
    //

    if (LocalMap[0][0] & GROUND_OPAQUE)
    {
	if (!(LocalMap[1][0] & GROUND_OPAQUE))
	{
	    SetSpriteSize(1,48);
	    DrawSprite(BUFFER_ADR(20,87)-1,(char*)wall_g-1);
	}
    }

    if (LocalMap[0][1] & GROUND_OPAQUE)
    {
	if (!(LocalMap[1][1] & GROUND_OPAQUE))
	{
	    SetSpriteSize(2,63);
	    DrawSprite(BUFFER_ADR(18,84)-1,(char*)wall_g0-1);
	}
    }
    else
    {
	if (LocalMap[0][0] & GROUND_OPAQUE)
	{
	    SetSpriteSize(10,50);
	    DrawSprite(BUFFER_ADR(10,85)-1,(char*)wall_c0-1);
	}
    }


    if (LocalMap[0][2] & GROUND_OPAQUE)
    {
	if (!(LocalMap[1][2] & GROUND_OPAQUE))
	{
	    SetSpriteSize(5,100);
	    DrawSprite(BUFFER_ADR(13,75)-1,(char*)wall_g1-1);
	}
    }
    else
    {
	if (LocalMap[0][1] & GROUND_OPAQUE)
	{
	    SetSpriteSize(8+((14-8)<<8),63);
	    DrawSprite(BUFFER_ADR(10,84)-1,(char*)wall_c1-1+14-8);
	}
	else
	if (LocalMap[0][1] & GROUND_CHUTE)
	{
	    //SetSpriteSize(10,11);
	    SetSpriteSize(9+((10-9)<<8),11);
	    DrawSprite(BUFFER_ADR(10,136)-1,(char*)pit_0-1+1);
	}
	else
	if (LocalMap[0][1] & GROUND_CLOSABLE)
	{
	    SetSpriteSize(2+(1<<8),63);
	    DrawSprite(BUFFER_ADR(16,84)-1,(char*)door_d1-1);	    // Cot‚ droit de la porte

	    if (FlagDoorOpen)
	    {
		SetSpriteSize(2,52);
		DrawSprite(BUFFER_ADR(14,86)-1,(char*)door_c1-1);	// 1Šre planche
		DrawSprite(BUFFER_ADR(12,86)-1,(char*)door_c1-1);	// 1Šre planche
		DrawSprite(BUFFER_ADR(10,86)-1,(char*)door_c1-1);	// 1Šre planche
	    }
	}
    }



    if (LocalMap[0][3] & GROUND_OPAQUE)
    {
	SetSpriteSize(3,122);
	DrawSprite(BUFFER_ADR(10,70)-1,(char*)wall_g2-1);
    }
    else
    {
	if (LocalMap[0][2] & GROUND_OPAQUE)
	{
	    SetSpriteSize(3+((24-3)<<8),99);
	    DrawSprite(BUFFER_ADR(10,76)-1,(char*)wall_c2-1+24-3);
	}
	else
	if (LocalMap[0][2] & GROUND_CHUTE)
	{
	    SetSpriteSize(5+((13-5)<<8),25);
	    DrawSprite(BUFFER_ADR(10,148)-1,(char*)pit_1-1+13-5);
	}
	else
	if (LocalMap[0][2] & GROUND_CLOSABLE)
	{
	    SetSpriteSize(1+(4<<8),99);
	    DrawSprite(BUFFER_ADR(12,75)-1,(char*)door_d2-1);		// Cot‚ droit de la porte

	    if (FlagDoorOpen)
	    {
		SetSpriteSize(2+(2<<8),79);
		DrawSprite(BUFFER_ADR(10,80)-1,(char*)door_c2-1);	// 1Šre planche
	    }
	}
    }








    /* Les murs de droite !!! */

    if (LocalMap[2][0] & GROUND_OPAQUE)
    {
	if (!(LocalMap[1][0] & GROUND_OPAQUE))
	{
	    SetSpriteSize(1,48);
	    DrawSprite(BUFFER_ADR(29,87)-1,(char*)wall_d-1);
	}
    }

    if (LocalMap[2][1] & GROUND_OPAQUE)
    {
	if (!(LocalMap[1][1] & GROUND_OPAQUE))
	{
	    SetSpriteSize(2,63);
	    DrawSprite(BUFFER_ADR(30,84)-1,(char*)wall_d0-1);
	}
    }
    else
    {
	if (LocalMap[2][0] & GROUND_OPAQUE)
	{
	    SetSpriteSize(10,50);
	    DrawSprite(BUFFER_ADR(30,85)-1,(char*)wall_c0-1);
	}
    }


    if (LocalMap[2][2] & GROUND_OPAQUE)
    {
	if (!(LocalMap[1][2] & GROUND_OPAQUE))
	{
	    SetSpriteSize(5,100);
	    DrawSprite(BUFFER_ADR(32,75)-1,(char*)wall_d1-1);
	}
    }
    else
    {
	if (LocalMap[2][1] & GROUND_OPAQUE)
	{
	    SetSpriteSize(8+((14-8)<<8),63);
	    DrawSprite(BUFFER_ADR(32,84)-1,(char*)wall_c1-1);
	}
	if (LocalMap[2][1] & GROUND_CHUTE)
	{
	    //SetSpriteSize(10,11);
	    SetSpriteSize(9+((10-9)<<8),11);
	    DrawSprite(BUFFER_ADR(31,136)-1,(char*)pit_0-1);
	}
	else
	if (LocalMap[2][1] & GROUND_CLOSABLE)
	{
	    SetSpriteSize(2+(1<<8),63);
	    DrawSprite(BUFFER_ADR(32,84)-1,(char*)door_g1-1+1);       // Cot‚ droit de la porte

	    if (FlagDoorOpen)
	    {
		SetSpriteSize(2,52);
		DrawSprite(BUFFER_ADR(34,86)-1,(char*)door_c1-1);	// 1Šre planche
		DrawSprite(BUFFER_ADR(36,86)-1,(char*)door_c1-1);	// 1Šre planche
		DrawSprite(BUFFER_ADR(38,86)-1,(char*)door_c1-1);	// 1Šre planche
	    }
	}
    }


    if (LocalMap[2][3] & GROUND_OPAQUE)
    {
	SetSpriteSize(3,122);
	DrawSprite(BUFFER_ADR(37,70)-1,(char*)wall_d2-1);
    }
    else
    {
	if (LocalMap[2][2] & GROUND_OPAQUE)
	{
	    SetSpriteSize(3+((24-3)<<8),99);
	    DrawSprite(BUFFER_ADR(37,76)-1,(char*)wall_c2-1);
	}
	else
	if (LocalMap[2][2] & GROUND_CHUTE)
	{
	    //SetSpriteSize(13,25);
	    SetSpriteSize(5+((13-5)<<8),25);
	    DrawSprite(BUFFER_ADR(35,148)-1,(char*)pit_1-1);
	}
	else
	if (LocalMap[2][2] & GROUND_CLOSABLE)
	{
	    SetSpriteSize(1+(4<<8),99);
	    DrawSprite(BUFFER_ADR(37,75)-1,(char*)door_g2-1+4);       // Cot‚ gauche de la porte

	    if (FlagDoorOpen)
	    {
		SetSpriteSize(2+(2<<8),79);
		DrawSprite(BUFFER_ADR(38,80)-1,(char*)door_c2-1);	// 1Šre planche
	    }
	}
    }


    /* Les murs du centre !!! */

    if (LocalMap[1][0] & GROUND_OPAQUE)
    {
	SetSpriteSize(10,50);
	DrawSprite(BUFFER_ADR(20,85)-1,(char*)wall_c0-1);
    }

    if (LocalMap[1][1] & GROUND_OPAQUE)
    {
	SetSpriteSize(14,63);
	DrawSprite(BUFFER_ADR(18,84)-1,(char*)wall_c1-1);
    }
    else
    {
	if (LocalMap[1][1] & GROUND_CHUTE)
	{
	    SetSpriteSize(10,11);
	    DrawSprite(BUFFER_ADR(20,136)-1,(char*)pit_0-1);
	}
	else
	if (LocalMap[1][1] & GROUND_CLOSABLE)
	{
	    SetSpriteSize(3,63);
	    DrawSprite(BUFFER_ADR(18,84)-1,(char*)door_g1-1);	    // Cot‚ gauche de la porte
	    DrawSprite(BUFFER_ADR(29,84)-1,(char*)door_d1-1);	    // Cot‚ droit de la porte

	    if (FlagDoorOpen)
	    {
		SetSpriteSize(2,52);
		DrawSprite(BUFFER_ADR(21,86)-1,(char*)door_c1-1);	// 1Šre planche
		DrawSprite(BUFFER_ADR(23,86)-1,(char*)door_c1-1);	// 2Šme planche
		DrawSprite(BUFFER_ADR(25,86)-1,(char*)door_c1-1);	// 3Šme planche
		DrawSprite(BUFFER_ADR(27,86)-1,(char*)door_c1-1);	// 4Šme planche
	    }
	}
    }

    if (LocalMap[1][2] & GROUND_OPAQUE)
    {
	SetSpriteSize(24,99);
	DrawSprite(BUFFER_ADR(13,76)-1,(char*)wall_c2-1);
	if (LocalMap[1][3] & GROUND_CLOSABLE)
	{
	    SetSpriteSize(4,107);
	    DrawSprite(BUFFER_ADR(24,72)-1,(char*)door_center-1);	// Fixation de la porte
	}
    }
    else
    {
	if (LocalMap[1][2] & GROUND_CHUTE)
	{
	    SetSpriteSize(13,25);
	    DrawSprite(BUFFER_ADR(18,148)-1,(char*)pit_1-1);
	}
	else
	if (LocalMap[1][2] & GROUND_CLOSABLE)
	{
	    SetSpriteSize(5,99);
	    DrawSprite(BUFFER_ADR(13,75)-1,(char*)door_g2-1);	    // Cot‚ gauche de la porte
	    DrawSprite(BUFFER_ADR(32,75)-1,(char*)door_d2-1);	    // Cot‚ droit de la porte

	    if (FlagDoorOpen)
	    {
		SetSpriteSize(4,79);
		DrawSprite(BUFFER_ADR(18,80)-1,(char*)door_c2-1);	// 1Šre planche
		DrawSprite(BUFFER_ADR(22,80)-1,(char*)door_c2-1);	// 2Šme planche
		DrawSprite(BUFFER_ADR(26,80)-1,(char*)door_c2-1);	// 3Šme planche

		SetSpriteSize(2+((4-2)<<8),79);
		//SetSpriteSize(4,79);
		DrawSprite(BUFFER_ADR(30,80)-1,(char*)door_c2-1);	// 4Šme planche
	    }
	}

    }

    /*box(60,69,239,199,1);*/			    /* Grand cadre ext‚rieur de la fenˆtre */

    //FillColumn(BUFFER_ADR(9,69),131,GREEN);	    /* Le graph … droite en vert */

    SetScreenSize(40);

    //
    // Affichage du buffer !
    //
    SetSpriteSize(30,130);
    DrawSprite(SCREEN_ADR(10,70)-1,(char*)DisplayBuffer-1);
}







int GetType(int x,int y)
{
    if ((x<0) OR (y<0) OR (x>31) OR (y>31))	    return GROUND_SOLIDE|GROUND_OPAQUE;
    else					    return GroundType[Map[Level][y][x]];
}





void display_map()
{
    unsigned int    x,y;
    int 	    xx,yy;

    /*
    curset(6*7,70,0);
    fill(6*7,1,16);
    for (y=0;y<7;y++)
    {
	for (x=0;x<7;x++)
	{
	    xx=XPos-3+x;
	    yy=YPos-3+y;
	    curset(x*6,70+y*6,0);
	    if ((xx<0) OR (yy<0) OR (xx>31) OR (yy>31))
	    {
		fill(6,1,16+WHITE);
	    }
	    else
	    {
		if ((x==3) AND (y==3))	fill(6,1,16+BLUE);
		else			fill(6,1,16+Map[Level][yy][xx]);
	    }
	}
    }
    */


    switch (Direction)
    {
    case DIRECTION_NORTH:
	XWalk=0;
	YWalk=-1;
	for (y=0;y<5;y++)
	{
	    for (x=0;x<3;x++)
	    {
		LocalMap[x][y]=GetType(XPos-1+x,YPos-3+y);
	    }
	}
	break;
    case DIRECTION_SOUTH:
	XWalk=0;
	YWalk=1;
	for (y=0;y<5;y++)
	{
	    for (x=0;x<3;x++)
	    {
		LocalMap[x][y]=GetType(XPos+1-x,YPos+3-y);
	    }
	}
	break;
    case DIRECTION_EAST:
	XWalk=1;
	YWalk=0;
	for (y=0;y<5;y++)
	{
	    for (x=0;x<3;x++)
	    {
		LocalMap[x][y]=GetType(XPos+3-y,YPos-1+x);
	    }
	}
	break;
    case DIRECTION_WEST:
	XWalk=-1;
	YWalk=0;
	for (y=0;y<5;y++)
	{
	    for (x=0;x<3;x++)
	    {
		LocalMap[x][y]=GetType(XPos-3+y,YPos+1-x);
	    }
	}
	break;
    }


    /*
    curset(6*7,130,0);
    fill(6*7,1,16);
    for (y=0;y<5;y++)
    {
	for (x=0;x<3;x++)
	{
	    curset(x*6,130+y*6,0);
	    if ((x==3) AND (y==3))  fill(6,1,64+1);
	    else		    fill(6,1,64+LocalMap[x][y]);
	}
    }
    */
}






void draw_names()
{
    unsigned int    n,x,y,i;

    for (n=0;n<4;n++)
    {
	x=n*10;

	if (n==Leader)	    FillColumn(SCREEN_ADR(x,2),8,YELLOW);
	else		    FillColumn(SCREEN_ADR(x,2),8,CYAN);

	AffText(SCREEN_ADR(x+1,2),Player[PlayerPlace[n]].name);
    }
}




void draw_stats()
{
    unsigned int    n,p,x,y,i;

    for (n=0;n<4;n++)
    {
	x=10*n+5;
	p=PlayerPlace[n];

	FillColumn(SCREEN_ADR(x,10),25,RED+p);

	y=25*Player[p].life_point/Player[p].max_life_point;
	if (y!=25)  FillColumn(SCREEN_ADR(x+1,10),25-y,64);
	if (y)	    FillColumn(SCREEN_ADR(x+1,10+25-y),y,64+15);

	y=25*Player[p].strenght_point/Player[p].max_strenght_point;
	if (y!=25)  FillColumn(SCREEN_ADR(x+2,10),25-y,64);
	if (y)	    FillColumn(SCREEN_ADR(x+2,10+25-y),y,64+15);

	y=25*Player[p].magic_point/Player[p].max_magic_point;
	if (y!=25)  FillColumn(SCREEN_ADR(x+3,10),25-y,64);
	if (y)	    FillColumn(SCREEN_ADR(x+3,10+25-y),y,64+15);
    }
}






void RedrawPlayers()
{
    draw_objects();
    draw_names();
    draw_stats();
}






void display_menus()
{

    FillColumn(SCREEN_ADR(9,69),131,GREEN);	// Le graph … droite en vert

    /* Cases pour les persos */

    poke((int)SCREEN_ADR(0, 0),16+GREEN);	     // Ligne verte du haut
    poke((int)SCREEN_ADR(0,37),16+GREEN);	     // Ligne verte du milieu
    poke((int)SCREEN_ADR(0,61),16+GREEN);	     // Ligne verte du bas

    /*
    curset(0,0,0);
    fill(1,1,16+GREEN);
    curset(0,37,0);
    fill(1,1,16+GREEN);
    curset(0,61,0);
    fill(1,1,16+GREEN);
    */

    /* Affiche le nom des persos */

    RedrawPlayers();
    display_map();
    display_3d();
}




typedef struct
{
    unsigned char   centieme;
    unsigned char   seconde;
    unsigned char   minute;
    unsigned char   heure;
    unsigned char   jour;
    unsigned char   mois;
    unsigned char   annee;
} TIME;


TIME	Date;




void DoAction()
{
    short int type;

    type=GetType(XPos+XWalk,YPos+YWalk);

    if (type & GROUND_CLOSABLE)
    {
	kbdclick1();
	FlagDoorOpen=TRUE-FlagDoorOpen;
	FlagMove=TRUE;
    }
}



void move_party(int a,int b)
{
    short int type;
    int 	y,x;

    type=GetType(XPos+a,YPos+b);

    if ((type & GROUND_SOLIDE) OR ((type & GROUND_CLOSABLE) AND FlagDoorOpen) OR (type & GROUND_CHUTE))
    {
	shoot();
	AddMessage("Ouch...",RED);
	FlagMove=FALSE;
    }
    else
    {
	XPos+=a;
	YPos+=b;
	FlagMove=TRUE;
    }
}






void main()
{
    unsigned int    car,deadkey;
    unsigned int    a,b;

    paper(BLACK);
    ink(BLUE);

    hires();

    for (a=0;a<128;a++)
    {
	doke(0x9c00+a*2,0x9800+a*8);
    }

    display_menus();
    setflags(NOKEYCLICK|PROTECT|SCREEN);


    chain_irq_handler(TimeIrqHandler);

    AddMessage("The party enters level one",GREEN);

    while (TRUE)
    {
	CurrentTime=TimeValueIrq;

	car=key();
	if (car)
	{
	    deadkey=getdeadkeys();

	    LastTimeAction=CurrentTime;

	    if (car==27)    break;

	    switch (car)
	    {
	    case '1':
	    case '2':
	    case '3':
	    case '4':
		a=car-'1';
		if (a!=Leader)
		{
		    if (deadkey==CTRL)
		    {
			/*
			::
			:: Swappe le leader avec le nouveau personnage
			::
			*/
			b=PlayerPlace[Leader];
			PlayerPlace[Leader]=PlayerPlace[a];
			PlayerPlace[a]=b;
			RedrawPlayers();
		    }
		    else
		    {
			/*
			::
			:: Changement de leader
			::
			*/
			Leader=a;
			draw_names();
			AddMessage("The leader is now:",RED);
			AddMessage(Player[Leader].name,YELLOW);
		    }
		}
		break;

	    case CURSOR_LEFT:
		if (deadkey==CTRL)
		{
		    switch (Direction)
		    {
		    case DIRECTION_NORTH:
		    case DIRECTION_SOUTH:
			move_party(YWalk,XWalk);
			break;
		    case DIRECTION_EAST:
		    case DIRECTION_WEST:
			move_party(-YWalk,-XWalk);
			break;
		    }
		}
		else
		{
		    Direction--;
		    if (Direction<0)	    Direction=3;
		    FlagMove=TRUE;
		}
		break;

	    case CURSOR_RIGHT:
		if (deadkey==CTRL)
		{
		    switch (Direction)
		    {
		    case DIRECTION_NORTH:
		    case DIRECTION_SOUTH:
			move_party(-YWalk,-XWalk);
			break;
		    case DIRECTION_EAST:
		    case DIRECTION_WEST:
			move_party(YWalk,XWalk);
			break;
		    }
		}
		else
		{
		    Direction++;
		    if (Direction>3)	    Direction=0;
		    FlagMove=TRUE;
		}
		break;

	    case CURSOR_UP:
		move_party(XWalk,YWalk);
		break;

	    case CURSOR_DOWN:
		if (deadkey==CTRL)
		{
		    Direction=(Direction+2)&3;
		    FlagMove=TRUE;
		}
		else
		{
		    move_party(-XWalk,-YWalk);
		}
		break;

	    case ' ':
		DoAction();
		break;
	    }
	}
	else
	{
	    /* No one press a key this time */

	    /*
	    if ((CurrentTime-LastTimeMessage)>(30*100))
	    {
		AddMessage("",YELLOW);
	    }
	    */

	}

	if (FlagMove)
	{
	    display_map();
	    display_3d();
	    FlagMove=FALSE;
	    //printf("\nX:%d,Y:%d",XPos,YPos);
	}

	VSync();
    }

    AddMessage("",BLACK);
    AddMessage("",BLACK);
    AddMessage("Thank you for playing Dungeon Master",YELLOW);

    call(deek(0xfffc));     /* reset froid */
}

