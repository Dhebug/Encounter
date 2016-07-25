

#define     BYTE	    char;
#define     UBYTE	    unsigned char;

#define     AND 	    &&
#define     OR		    ||

#define     TRUE	    1
#define     FALSE	    0


#define     CURSOR_LEFT     8
#define     CURSOR_RIGHT    9
#define     CURSOR_DOWN     10
#define     CURSOR_UP	    11


// OPAQUE:	On ne voit rien au travers (mur/illusion)
// CHUTE:	Si on passe dessus, on tombe
// SOLIDE:	On ne peut pas passer au travers (mur)
// CLOSABLE:	On peut la fermer ou l'ouvrir (porte/herse)
// TELEPORT:	Le passage fait changer d'emplacement                                   [ziooouuup !]
// BUTTON:	Permet d'activer un m‚canisme quelconque                                [click]
// INSERT:	Mettre un objet pour actionner quelque chose (clef/piece/objet sp‚cial)


#define GROUND_NONE	 0

#define GROUND_OPAQUE	 1
#define GROUND_CHUTE	 2
#define GROUND_SOLIDE	 4
#define GROUND_CLOSABLE  8
#define GROUND_TELEPORT  16
#define GROUND_BUTTON	 32
#define GROUND_INSERT	 64
#define GROUND_OPEN	 128




#define BUFFER_ADR(x,y) 	((char*)(DisplayBuffer+((x)-10)+(30*((y)-70))))
#define SCREEN_ADR(x,y) 	((char*)(0xa000+(x)+(40*(y))))

#define LEVEL_POS(x,y,level)	(((x)&31)+(((y)&31)<<5)+(((level)&63)<<10))



#define NO_OBJECT	255

enum
{
    SPRITE_EPEE,
    SPRITE_BOUCLIER,
    SPRITE_LANCE,
    SPRITE_ECU,
    SPRITE_ARC,
    SPRITE_TORCHE,
    SPRITE_CARQUOI,
    SPRITE_HACHE,

    SPRITE_BOUSSOLE,
    SPRITE_VISAGE_MORT,
    SPRITE_VISAGE_1,
    SPRITE_VISAGE_2,
    SPRITE_VISAGE_3,
    SPRITE_VISAGE_4,
    SPRITE_VISAGE_5,
    SPRITE_FIOLE,

    SPRITE_PARCHEMIN,
    SPRITE_BOURSE,
    SPRITE_POMME,
    SPRITE_CLEF,
    SPRITE_MAIN_GAUCHE,
    SPRITE_MAIN_DROITE,
};

#define     EMPTY   255



enum
{
    CLASS_FIGHTER,
    CLASS_RANGER,
    CLASS_MAGICIAN,
    CLASS_CLERIC,
    CLASS_THIEF,
};

enum
{
    RACE_HUMAN,
    RACE_ELF,
    RACE_DWARF,
    RACE_HALFLING,
    RACE_HALF_ELF,
};



enum
{
    FORMATED_LEFT,
    FORMATED_RIGHT,
    FORMATED_CENTER,
};




enum
{
    DIRECTION_NORTH,
    DIRECTION_EAST,
    DIRECTION_SOUTH,
    DIRECTION_WEST,
};



enum
{
    BLACK,
    RED,
    GREEN,
    YELLOW,
    BLUE,
    MAGENTA,
    CYAN,
    WHITE,
};


