
#include    "lib.h"

#include    "defines.h"



extern	unsigned char	DisplayBuffer[];

//extern  unsigned int	  ScreenOff[];


char Command[40];


char CommandLoad[]="!LOAD \"";



void Load(char *filename)
{
    strcpy(Command,CommandLoad);
    strcat(Command,filename);
    strcat(Command,"\"");

    sedoric(Command);
}

void LoadAdr(char *filename,char *adresse)
{
    strcpy(Command,CommandLoad);
    strcat(Command,filename);
    strcat(Command,"\",A");
    strcat(Command,adresse);

    sedoric(Command);
}





//
// GRAF.S
//
extern	void		AddMessage(char *message,char color);

extern	void		ClearDisplayBuffer();

extern	void		SetScreenSize(unsigned int largeur);
extern	void		SetSpriteSize(unsigned int largeur,unsigned int hauteur);
extern	void		DrawSprite(char *dest,char *source);

extern	void		FillColumn(char *ptr_screen,unsigned char height,unsigned char value);
extern	void		FillBox(char *ptr_screen,unsigned int size,unsigned char value);

extern	void		AffText(char *ptr_screen,char *string);

extern	void		CreateSymTable();



//
// TIMER.S
//
extern	void		VSync();
extern	void		TimeIrqHandler();
extern	void		Wait(unsigned int delay);
extern	unsigned int	TimeValueIrq;		       // Contient la valeur courante de time




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





unsigned int	LastTimeAction;
unsigned int	LastTimeMessage;
unsigned int	CurrentTime;





void main()
{
    unsigned int    car,deadkey;
    unsigned int    a,b;


    paper(BLACK);
    ink(BLUE);

    hires();
    chain_irq_handler(TimeIrqHandler);
    setflags(NOKEYCLICK|PROTECT|SCREEN);


    CreateSymTable();			// Table d'inversion des bits pour l'affichage

    for (a=0;a<128;a++)
    {
	doke(0x9c00+a*2,0x9800+a*8);
    }


    while (TRUE)
    {
	CurrentTime=TimeValueIrq;

	car=key();
	if (car)
	{
	    deadkey=getdeadkeys();

	    LastTimeAction=CurrentTime;

	    if ((car=='q') OR (car=='Q'))   break;
	}
    }

    AddMessage("",BLACK);
    AddMessage("",BLACK);
    AddMessage("Thank you for playing Dungeon Master",YELLOW);

    uninstall_irq_handler();	// Plus propre !!!
    exit(0);
}

