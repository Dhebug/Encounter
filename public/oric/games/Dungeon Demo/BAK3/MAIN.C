
#include    "lib.h"

#include    "defines.h"
#include    "levels.c"

#include    "sprites.c"
#include    "walls.c"



extern	unsigned int	ScreenOff[];

extern	void AddMessage(char *message,char color);

extern	void SetSpriteSize(unsigned int largeur,unsigned int hauteur);
extern	void DrawSprite(char *dest,char *source);

extern	void FillColumn(char *ptr_screen,unsigned char height,unsigned char value);
extern	void FillBox(char *ptr_screen,unsigned int size,unsigned char value);

extern	void AffText(char *ptr_screen,char *string);


/* lib16\sound.s */

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


char	*BoringMessage[]=
{
    {"What are thou waiting for ???"},
    {"Yes, thinking is a good thing !"},
    {"I'm afraid you're loosing time..."},
    {"Are you afraid of moving ?"},
    {"Ok, I let you sleeping now."},
};



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
unsigned char	FlagDoorOpen=FALSE;

unsigned char	Leader=0;
unsigned char	Level=0;
unsigned char	XPos=3;
unsigned char	YPos=4;
signed char	XWalk=0;
signed char	YWalk=-1;
signed char	Direction=DIRECTION_NORTH;
unsigned int	LastTimeAction;
unsigned int	LastTimeMessage;
unsigned int	CurrentTime;
unsigned int	LastBoringMessage;






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
    int 	    x,y,i,p;
    unsigned char   *ptr_src;
    unsigned char   *ptr_dst;

    SetSpriteSize(5,22);

    /* Visages */
    for (i=0;i<4;i++)
    {
	p=PlayerPlace[i];
	DrawSprite(SpritePos[i]      ,(char*)sprites+Player[p].visage*110-1);  /* Visage */
	if (Player[p].inventory[0]==255)
	{
	    DrawSprite(SpritePos[4+i*2]  ,(char*)sprites+SPRITE_MAIN_GAUCHE*110-1);	    /* Main gauche vide */
	}
	else
	{
	    DrawSprite(SpritePos[4+i*2]  ,(char*)sprites+Player[p].inventory[0]*110-1);     /* Main gauche pleine */
	}

	if (Player[p].inventory[1]==255)
	{
	    DrawSprite(SpritePos[4+i*2+1],(char*)sprites+SPRITE_MAIN_DROITE*110-1);	    /* Main droite vide */
	}
	else
	{
	    DrawSprite(SpritePos[4+i*2+1],(char*)sprites+Player[p].inventory[1]*110-1);     /* Main droite pleine */
	}
    }
}






void display_3d()
{
    unsigned int    x,y;
    unsigned char   *ptr;

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
    FillColumn(SCREEN_ADR(9,69),131,BLACK);	    /* Le graph … droite en noir (invisible) */
    FillBox(SCREEN_ADR(10,70)-1,(129<<8)+30,64);    /* Efface la vue 3D */




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
	    DrawSprite(SCREEN_ADR(20,87)-1,(char*)wall_g-1);
	}
    }

    if (LocalMap[0][1] & GROUND_OPAQUE)
    {
	if (!(LocalMap[1][1] & GROUND_OPAQUE))
	{
	    SetSpriteSize(2,63);
	    DrawSprite(SCREEN_ADR(18,84)-1,(char*)wall_g0-1);
	}
    }
    else
    {
	if (LocalMap[0][0] & GROUND_OPAQUE)
	{
	    SetSpriteSize(10,50);
	    DrawSprite(SCREEN_ADR(10,85)-1,(char*)wall_c0-1);
	}
    }

    if (LocalMap[0][2] & GROUND_OPAQUE)
    {
	if (!(LocalMap[1][2] & GROUND_OPAQUE))
	{
	    SetSpriteSize(5,100);
	    DrawSprite(SCREEN_ADR(13,75)-1,(char*)wall_g1-1);
	}
    }
    else
    {
	if (LocalMap[0][1] & GROUND_OPAQUE)
	{
	    SetSpriteSize(8+((14-8)<<8),63);
	    DrawSprite(SCREEN_ADR(10,84)-1,(char*)wall_c1-1+14-8);
	}
	else
	if (LocalMap[0][1] & GROUND_CHUTE)
	{
	    //SetSpriteSize(10,11);
	    SetSpriteSize(9+((10-9)<<8),11);
	    DrawSprite(SCREEN_ADR(10,136)-1,(char*)pit_0-1+1);
	}
    }

    if (LocalMap[0][3] & GROUND_OPAQUE)
    {
	SetSpriteSize(3,122);
	DrawSprite(SCREEN_ADR(10,70)-1,(char*)wall_g2-1);
    }
    else
    {
	if (LocalMap[0][2] & GROUND_OPAQUE)
	{
	    SetSpriteSize(3+((24-3)<<8),99);
	    DrawSprite(SCREEN_ADR(10,76)-1,(char*)wall_c2-1+24-3);
	}
	else
	if (LocalMap[0][2] & GROUND_CHUTE)
	{
	    //SetSpriteSize(13,25);
	    SetSpriteSize(6+((13-6)<<8),25);
	    DrawSprite(SCREEN_ADR(10,148)-1,(char*)pit_1-1+13-6);
	}
    }








    /* Les murs de droite !!! */

    if (LocalMap[2][0] & GROUND_OPAQUE)
    {
	if (!(LocalMap[1][0] & GROUND_OPAQUE))
	{
	    SetSpriteSize(1,48);
	    DrawSprite(SCREEN_ADR(29,87)-1,(char*)wall_d-1);
	}
    }

    if (LocalMap[2][1] & GROUND_OPAQUE)
    {
	if (!(LocalMap[1][1] & GROUND_OPAQUE))
	{
	    SetSpriteSize(2,63);
	    DrawSprite(SCREEN_ADR(30,84)-1,(char*)wall_d0-1);
	}
    }
    else
    {
	if (LocalMap[2][0] & GROUND_OPAQUE)
	{
	    SetSpriteSize(10,50);
	    DrawSprite(SCREEN_ADR(30,85)-1,(char*)wall_c0-1);
	}
    }


    if (LocalMap[2][2] & GROUND_OPAQUE)
    {
	if (!(LocalMap[1][2] & GROUND_OPAQUE))
	{
	    SetSpriteSize(5,100);
	    DrawSprite(SCREEN_ADR(32,75)-1,(char*)wall_d1-1);
	}
    }
    else
    {
	if (LocalMap[2][1] & GROUND_OPAQUE)
	{
	    SetSpriteSize(8+((14-8)<<8),63);
	    DrawSprite(SCREEN_ADR(32,84)-1,(char*)wall_c1-1);
	}
	if (LocalMap[2][1] & GROUND_CHUTE)
	{
	    //SetSpriteSize(10,11);
	    SetSpriteSize(9+((10-9)<<8),11);
	    DrawSprite(SCREEN_ADR(31,136)-1,(char*)pit_0-1);
	}
    }

    if (LocalMap[2][3] & GROUND_OPAQUE)
    {
	SetSpriteSize(3,122);
	DrawSprite(SCREEN_ADR(37,70)-1,(char*)wall_d2-1);
    }
    else
    {
	if (LocalMap[2][2] & GROUND_OPAQUE)
	{
	    SetSpriteSize(3+((24-3)<<8),99);
	    DrawSprite(SCREEN_ADR(37,76)-1,(char*)wall_c2-1);
	}
	else
	if (LocalMap[2][2] & GROUND_CHUTE)
	{
	    //SetSpriteSize(13,25);
	    SetSpriteSize(6+((13-6)<<8),25);
	    DrawSprite(SCREEN_ADR(34,148)-1,(char*)pit_1-1);
	}
    }


    /* Les murs du centre !!! */

    if (LocalMap[1][0] & GROUND_OPAQUE)
    {
	SetSpriteSize(10,50);
	DrawSprite(SCREEN_ADR(20,85)-1,(char*)wall_c0-1);
    }

    if (LocalMap[1][1] & GROUND_OPAQUE)
    {
	SetSpriteSize(14,63);
	DrawSprite(SCREEN_ADR(18,84)-1,(char*)wall_c1-1);
    }
    else
    {
	if (LocalMap[1][1] & GROUND_CHUTE)
	{
	    SetSpriteSize(10,11);
	    DrawSprite(SCREEN_ADR(20,136)-1,(char*)pit_0-1);
	}
	else
	if (LocalMap[1][1] & GROUND_CLOSABLE)
	{
	    SetSpriteSize(3,63);
	    DrawSprite(SCREEN_ADR(18,84)-1,(char*)door_g1-1);	    // Cot‚ gauche de la porte
	    DrawSprite(SCREEN_ADR(29,84)-1,(char*)door_d1-1);	    // Cot‚ droit de la porte

	    if (FlagDoorOpen)
	    {
		SetSpriteSize(2,52);
		DrawSprite(SCREEN_ADR(21,86)-1,(char*)door_c1-1);	// 1Šre planche
		DrawSprite(SCREEN_ADR(23,86)-1,(char*)door_c1-1);	// 2Šme planche
		DrawSprite(SCREEN_ADR(25,86)-1,(char*)door_c1-1);	// 3Šme planche
		DrawSprite(SCREEN_ADR(27,86)-1,(char*)door_c1-1);	// 4Šme planche
	    }
	}
    }

    if (LocalMap[1][2] & GROUND_OPAQUE)
    {
	SetSpriteSize(24,99);
	DrawSprite(SCREEN_ADR(13,76)-1,(char*)wall_c2-1);
    }
    else
    {
	if (LocalMap[1][2] & GROUND_CHUTE)
	{
	    SetSpriteSize(13,25);
	    DrawSprite(SCREEN_ADR(18,148)-1,(char*)pit_1-1);
	}
	else
	if (LocalMap[1][2] & GROUND_CLOSABLE)
	{
	    SetSpriteSize(5,99);
	    DrawSprite(SCREEN_ADR(13,75)-1,(char*)door_g2-1);	    // Cot‚ gauche de la porte
	    DrawSprite(SCREEN_ADR(32,75)-1,(char*)door_d2-1);	    // Cot‚ droit de la porte

	    if (FlagDoorOpen)
	    {
		SetSpriteSize(4,79);
		DrawSprite(SCREEN_ADR(18,80)-1,(char*)door_c2-1);	// 1Šre planche
		DrawSprite(SCREEN_ADR(22,80)-1,(char*)door_c2-1);	// 2Šme planche
		DrawSprite(SCREEN_ADR(26,80)-1,(char*)door_c2-1);	// 3Šme planche

		SetSpriteSize(2+((4-2)<<8),79);
		//SetSpriteSize(4,79);
		DrawSprite(SCREEN_ADR(30,80)-1,(char*)door_c2-1);	// 4Šme planche
	    }
	}

    }

    /*box(60,69,239,199,1);*/			    /* Grand cadre ext‚rieur de la fenˆtre */

    FillColumn(SCREEN_ADR(9,69),131,GREEN);	  /* Le graph … droite en vert */
}







void display_boussole()
{
    unsigned int    a;

    switch (Direction)
    {
    case DIRECTION_NORTH:
	a='N';
	break;
    case DIRECTION_SOUTH:
	a='S';
	break;
    case DIRECTION_EAST:
	a='E';
	break;
    case DIRECTION_WEST:
	a='W';
	break;
    default:
	a='?';
    }
    curset(10,180,0);
    hchar(127,0,0);
    hchar(a,0,1);
}






void display_map()
{
    unsigned int    x,y;
    signed int	    xx,yy;

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
		xx=XPos-1+x;
		yy=YPos-3+y;
		if ((xx<0) OR (yy<0) OR (xx>31) OR (yy>31))
		{
		    LocalMap[x][y]=GroundType[1];
		}
		else
		{
		    LocalMap[x][y]=GroundType[Map[Level][yy][xx]];
		}
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
		xx=XPos+1-x;
		yy=YPos+3-y;
		if ((xx<0) OR (yy<0) OR (xx>31) OR (yy>31))
		{
		    LocalMap[x][y]=GroundType[1];
		}
		else
		{
		    LocalMap[x][y]=GroundType[Map[Level][yy][xx]];
		}
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
		xx=XPos+3-y;
		yy=YPos-1+x;
		if ((xx<0) OR (yy<0) OR (xx>31) OR (yy>31))
		{
		    LocalMap[x][y]=GroundType[1];
		}
		else
		{
		    LocalMap[x][y]=GroundType[Map[Level][yy][xx]];
		}
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
		xx=XPos-3+y;
		yy=YPos+1-x;
		if ((xx<0) OR (yy<0) OR (xx>31) OR (yy>31))
		{
		    LocalMap[x][y]=GroundType[1];
		}
		else
		{
		    LocalMap[x][y]=GroundType[Map[Level][yy][xx]];
		}
	    }
	}
	break;
    }
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
    /* Cases pour les persos */

    curset(0,0,0);
    fill(1,1,16+GREEN);
    curset(0,37,0);
    fill(1,1,16+GREEN);
    curset(0,61,0);
    fill(1,1,16+GREEN);

    /* Affiche le nom des persos */

    RedrawPlayers();
    display_boussole();
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



unsigned int GetTime()
{
    return (Date.minute*60*100+Date.seconde*100+Date.centieme);
}

void wait(unsigned int n)
{
    unsigned int    last;

    last=GetTime();

    while ((GetTime()-last)<n);
}




void my_handler()
{
    Date.centieme++;
    if (Date.centieme>99)			    /* 100Šmes de secondes */
    {
	Date.centieme=0;
	Date.seconde++;

	if (Date.seconde>59)			    /* 1 minute est ‚coul‚e */
	{
	    Date.seconde=0;
	    Date.minute++;
	    if (Date.minute>59) 		    /* 1 heure est ‚coul‚e */
	    {
		Date.minute=0;
		Date.heure++;
		if (Date.heure>23)		    /* 1 journ‚e est ‚coul‚e */
		{
		    Date.heure=0;
		    Date.jour++;
		}
	    }
	}
    }
}





void move_party(int a,int b,char *message)
{
    short int type;

    type=GroundType[Map[Level][YPos+b][XPos+a]];

    if ((type & GROUND_SOLIDE) OR ((type & GROUND_CLOSABLE) AND FlagDoorOpen))
    {
	shoot();
	AddMessage("Ouch...",RED);
	FlagMove=FALSE;
    }
    else if (type & GROUND_CHUTE)
    {
	//zap();
	AddMessage("You fall in a pit",RED);
	//
	// En th‚orie, brancher sur la bonne routine et descendre d'un niveau !
	//
	XPos+=a;
	YPos+=b;
	FlagMove=TRUE;
    }
    else
    {
	XPos+=a;
	YPos+=b;
	AddMessage(message,WHITE);
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


    /*
    chain_irq_handler(my_handler);
    */

    AddMessage("Welcome to the greatest dungeon game",YELLOW);
    AddMessage("ever created for your Oric 1 or Atmos",RED);
    AddMessage("Press a key to seal your destiny",GREEN);

    while (TRUE)
    {
	CurrentTime=GetTime();

	car=key();
	if (car)
	{
	    deadkey=getdeadkeys();

	    LastTimeAction=CurrentTime;
	    LastBoringMessage=0;

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
			move_party(YWalk,XWalk,"The party dodge left");
			break;
		    case DIRECTION_EAST:
		    case DIRECTION_WEST:
			move_party(-YWalk,-XWalk,"The party dodge left");
			break;
		    }
		}
		else
		{
		    Direction--;
		    if (Direction<0)	    Direction=3;
		    AddMessage("The party rotate left",WHITE);
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
			move_party(-YWalk,-XWalk,"The party dodge right");
			break;
		    case DIRECTION_EAST:
		    case DIRECTION_WEST:
			move_party(YWalk,XWalk,"The party dodge right");
			break;
		    }
		}
		else
		{
		    Direction++;
		    if (Direction>3)	    Direction=0;
		    AddMessage("The party rotate right",WHITE);
		    FlagMove=TRUE;
		}
		break;

	    case CURSOR_UP:
		move_party(XWalk,YWalk,"The party moves forward");
		break;

	    case CURSOR_DOWN:
		if (deadkey==CTRL)
		{
		    Direction=(Direction+2)&3;
		    AddMessage("The party turns back",WHITE);
		    FlagMove=TRUE;
		}
		else
		{
		    move_party(-XWalk,-YWalk,"The party moves backward");
		}
		break;

	    case 'H':
	    case 'h':
		AddMessage("Sorry, no Help this time !",WHITE);
		break;

	    case ' ':
		FlagDoorOpen=TRUE-FlagDoorOpen;
		FlagMove=TRUE;
		break;
	    }
	}
	else
	{
	    /* No one press a key this time */

	    if ((CurrentTime-LastTimeMessage)>(30*100))
	    {
		AddMessage("",YELLOW);
	    }

	    if (((CurrentTime-LastTimeAction)> ((LastBoringMessage+1)*100*60)) AND (LastBoringMessage<5))
	    {
		AddMessage("",YELLOW);
		AddMessage("",YELLOW);
		AddMessage(BoringMessage[LastBoringMessage],YELLOW);
		LastBoringMessage++;
	    }

	}

	if (FlagMove)
	{
	    display_boussole();
	    display_map();
	    display_3d();
	    FlagMove=FALSE;
	}
    }

    AddMessage("",BLACK);
    AddMessage("",BLACK);
    AddMessage("Thank you for playing Dungeon Master",YELLOW);

    call(deek(0xfffc));     /* reset froid */
}

