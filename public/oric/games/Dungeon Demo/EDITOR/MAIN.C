#include    "defines.h"

void BRKPT();

#pragma aux BRKPT="INT 3"




typedef struct
{
    U8	    type;
    U8	    pad[15];
} DUNGEON_CASE;



#define     BASE_GREY	    16
#define     BASE_RED	    32
#define     BASE_GREEN	    48
#define     BASE_BLUE	    64
#define     BASE_YELLOW     80
#define     BASE_MAGENTA    96
#define     BASE_CYAN	    112
#define     BASE_BRUN	    128




char *CaseType[]=
{
   {"Sol                       "},  // 0
   {"Mur                       "},  // 1
   {"Faux mur                  "},  // 2
   {"Porte ferm‚e              "},  // 3
   {"Porte ouverte             "},  // 4
   {"Porte cass‚e              "},  // 5
   {"Grille ferm‚e             "},  // 6
   {"Grille ouverte            "},  // 7
   {"Trape ferm‚e              "},  // 8
   {"Trappe ouverte            "},  // 9
   {"Dalle au sol              "},  // 10
   {"Boutton rond              "},  // 11
   {"Boutton rond enfonc‚      "},  // 12
   {"Boutton carr‚             "},  // 13
   {"Boutton carr‚ enfonc‚     "},  // 14
   {"Levier lev‚               "},  // 15
   {"Levier baiss‚             "},  // 16
   {"Escalier vers le haut     "},  // 17
   {"Escalier vers le bas      "},  // 18
   {"Niche carr‚e              "},  // 19
   {"Niche arrondie            "},  // 20
   {"Menotes sur un mur        "},  // 21
   {"Bouche d'‚gouts sur un mur"},  // 22
   {"Fontaine                  "},  // 23
   {"T‚l‚porteur               "},  // 24
   {"Bouche lance flamme       "},  // 25
   {"Serrure                   "},  // 26
   {"Gargouille                "},  // 27
};




DUNGEON_CASE	DungeonMap[14][32][32];
S32		Level;
S32		FlagMap=FALSE;
S32		Xpos=0;
S32		Ypos=0;


S32		TypeDraw=1;
S32		TypeErase=0;


S32		FlagQuitte;

S32		ErrorCode;
U8		ErrorChaine[255];

T_MENU		Menu;

S32		SameKey   = 0;
S32		MyKey	  = 0;
S32		LastMyKey = -1;
S32		MyJoy	  = 0;
S32		LastMyJoy = -1;
S32		MyClick   = 0;
S32		LastMyClick= -1;
S32		MyMouseX=0;
S32		LastMyMouseX=-1;
S32		MyMouseY=0;
S32		LastMyMouseY=-1;
S32		MyFire	  = 0;
S32		LastMyFire= -1;

S32		Wx1,Wx2,Wy1,Wy2,Wcx,Wcy,Wl,Wh;


void DrawMap()
{
    S32 x,y;
    S32 xp,yp;
    S32 t;
    S32 color;

    Box(Wx1,Wy1,Wx2,Wy2,0);

    for (y=0;y<32;y++)
    {
	yp=Wy1+y*15;
	for (x=0;x<32;x++)
	{
	    xp=Wx1+x*15;
	    t=DungeonMap[Level][y][x].type;
	    switch (t)
	    {
	    case 0:			    // Sol
		Box(xp	,yp  ,xp+14  ,yp+14  ,BASE_GREY+8);
		break;

	    case 1:			    // Mur
		Box(xp	,yp  ,xp+14  ,yp+14  ,BASE_GREY+4);
		break;

	    case 3:
	    case 4:
	    case 5:
	    case 6:
	    case 7:
		if ((t==7) OR (t==4) OR (t==5))     color=BASE_GREY+8;	    // Ouverte
		if (t==3)     color=BASE_BRUN+8;      // Marron
		if (t==6)     color=BASE_GREY+12;     // Grise

		Box(xp	,yp  ,xp+14  ,yp+14  ,BASE_GREY+8);
		if (DungeonMap[Level][y][x-1].type==1)	    // Porte -
		{
		    Box(xp     ,yp+5	 ,xp+14 ,yp+9	,color);

		    Box(xp     ,yp+5	 ,xp+3	,yp+9	,BASE_GREY+4);
		    Box(xp+14-3,yp+5	 ,xp+14 ,yp+9	,BASE_GREY+4);
		}
		else					    // Porte |
		{
		    Box(xp+5  ,yp	,xp+9  ,yp+14  ,color);

		    Box(xp+5  ,yp	,xp+9  ,yp+3   ,BASE_GREY+4);
		    Box(xp+5  ,yp+14-3	,xp+9  ,yp+14  ,BASE_GREY+4);
		}
		break;

	    case 8:			    // Trappe ferm‚e
		Box(xp	,yp  ,xp+14  ,yp+14  ,BASE_GREY+8);
		Box(xp+2,yp+2,xp+14-2,yp+14-2,BASE_GREY+4);
		Box(xp+3,yp+3,xp+14-3,yp+14-3,BASE_GREY+8);
		break;
	    case 9:			    // Trappe ouverte
		Box(xp	,yp  ,xp+14  ,yp+14  ,BASE_GREY+8);
		Box(xp+2,yp+2,xp+14-2,yp+14-2,BASE_GREY+4);
		Box(xp+3,yp+3,xp+14-3,yp+14-3,BASE_GREY+6);
		break;

	    case 10:			     // Dalle au sol
		Box(xp	,yp  ,xp+14  ,yp+14  ,BASE_GREY+8);
		Box(xp+4,yp+4,xp+14-4,yp+14-4,BASE_GREY+4);
		Box(xp+5,yp+5,xp+14-5,yp+14-5,BASE_GREY+6);
		break;

	    default:
		Box(xp,yp,xp+14,yp+14,t);
		break;
	    }
	}
    }

    for (x=0;x<32;x++)	    Line(Wx1+x*15,Wy1	  ,Wx1+x*15,Wy2     ,1);
    for (y=0;y<32;y++)	    Line(Wx1	 ,Wy1+y*15,Wx2	   ,Wy1+y*15,1);

    CopyBlockPhys(Wx1,Wy1,Wx2,Wy2);
}




void DisplayMousePos()
{
    Box(0,400,159,479,0);

    Text(0,480- 40,"%s",CaseType[TypeDraw]);
    Text(0,480- 32,"%s",CaseType[TypeErase]);

    FlagMap=FALSE;
    if (MyMouseX>Wx1)
    {
	Xpos=(MyMouseX-160)/15;
	Ypos=MyMouseY/15;
	FlagMap=TRUE;
	Text(0,480-16,"(%d,%d)",Xpos,Ypos);
	Text(0,480-8 ,"%s",CaseType[DungeonMap[Level][Ypos][Xpos].type]);
    }

    CopyBlockPhys(0,400,159,479);
}





void LoadLevel()
{
    Load("LEVELS.BIN",DungeonMap);
}



void SaveLevel()
{
    Save("LEVELS.BIN",DungeonMap,sizeof(DUNGEON_CASE)*14*32*32);
}





void CreateMenu()
{
    OpenMenu	  (&Menu,10,15);

    AddButton	  (&Menu,ID_MENU_QUITTE     , 0, 0, 6,1,FLAG_CENTRE|FLAG_RED,"QUIT");
    AddButton	  (&Menu,ID_MENU_LOAD	    , 0, 1, 6,1,FLAG_CENTRE,"LOAD");
    AddButton	  (&Menu,ID_MENU_SAVE	    , 0, 2, 6,1,FLAG_CENTRE,"SAVE");
    AddChangeValue(&Menu,ID_MENU_LEVEL	    , 0, 3,10,1,FLAG_CENTRE,"Level:",&Level,1,0,13);

    AddChangeValue(&Menu,ID_MENU_TYPE_DRAW  , 0, 5,10,1,FLAG_CENTRE,"Left:",&TypeDraw,1,0,255);
    AddChangeValue(&Menu,ID_MENU_TYPE_ERASE , 0, 7,10,1,FLAG_CENTRE,"Right:",&TypeErase,1,0,255);
}



void Fin()
{
    if (ErrorCode)
    {
	printf("\nDungeonMapEDitor\n");
	printf("\nDate de compilation: "__DATE__);
	printf("\nHeure de compilation: "__TIME__);
	printf("\nÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍµERRORÆÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ");
	printf("\n%s",ErrorChaine);
	printf("\nÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ");
	printf("\n");
	getch();
    }
}







void Error(U8 *message,...)
{
    S16    l;
    S8	  c;
    S8	  tempo[34];
    S8	  *str_out = ErrorChaine;
    S8	  *ptr;
    va_list ap;

    l = 0;

    va_start(ap,message);

    *str_out = 0;
    while ((c=*message++) != 0)
    {
	if (c == '%')
	{
	    switch(toupper(*message++))
	    {
	    case 'C':       /* S8 */
		tempo[0] = va_arg(ap,S8);
		tempo[1] = 0;
		strcat(str_out,tempo);
		l++;
		break;

	    case 'S':       /* string */
		ptr = va_arg(ap,S8*);
		strcat(str_out,ptr);
		l += strlen(ptr);
		break;

	    case 'B':       /* byte */
		strcat(str_out,ltoa(va_arg(ap,U8),tempo,10));
		l += strlen(tempo);
		break;

	    case 'D':       /* decimal */
	    case 'L':       /* long decimal */
		strcat(str_out,ltoa(va_arg(ap,int),tempo,10));
		l += strlen(tempo);
		break;

	    case 'U':       /* unsigned decimal */
		strcat(str_out,ultoa(va_arg(ap,unsigned),tempo,10));
		l += strlen(tempo);
		break;

	    case 'P':       /* pointeur hexa */
		strcat(str_out,ultoa(va_arg(ap,unsigned),tempo,16));
		l += strlen(tempo);
		break;

	    default:
		return;
	    }
	}
	else
	{
	    ErrorChaine[l] = c;
	    l++;
	    ErrorChaine[l] = 0;
	}
    }
    va_end(ap);

    ErrorCode=TRUE;
    exit(1);
}




void BouclePrincipale()
{
    S32     flag_fin=FALSE;
    S32     ret;

    //BRKPT();

    TypeDraw=1;
    TypeErase=0;

    Cls();
    DrawMenu(&Menu,0,0);

    Wx1=160;
    Wy1=0;
    Wx2=639;
    Wy2=479;
    Wl=480;
    Wh=480;
    Box(Wx1,Wy1,Wx2,Wy2,1);

    DrawMap();

    FullFlip();

    while (!flag_fin)
    {
	MyKey = Key;
	MyJoy = Joy;
	MyFire = Fire;
	MyClick = Click;
	MyMouseX= Mouse_X;
	MyMouseY= Mouse_Y;

	SameKey=(MyKey==LastMyKey);

	AffMouse();
	ret=GereMenu(&Menu);

	DisplayMousePos();

	switch (ret)
	{
	case ID_MENU_QUITTE:
	    flag_fin=TRUE;
	    break;

	case ID_MENU_LEVEL:
	    DrawMap();
	    break;

	case ID_MENU_LOAD:
	    LoadLevel();
	    DrawMap();
	    break;

	case ID_MENU_SAVE:
	    SaveLevel();
	    break;
	}

	if (MyClick)
	{
	    if (FlagMap)
	    {
		if (MyClick&1)
		{
		    if (DungeonMap[Level][Ypos][Xpos].type!=TypeDraw)
		    {
			DungeonMap[Level][Ypos][Xpos].type=TypeDraw;
			DrawMap();
		    }
		}
		else
		{
		    if (DungeonMap[Level][Ypos][Xpos].type!=TypeErase)
		    {
			DungeonMap[Level][Ypos][Xpos].type=TypeErase;
			DrawMap();
		    }
		}
	    }
	}


	if (MyKey==K_ESC)    flag_fin=TRUE;

	LastMyKey	= MyKey;
	LastMyJoy	= MyJoy;
	LastMyFire	= MyFire;
	LastMyClick	= MyClick;
	LastMyMouseX	= MyMouseX;
	LastMyMouseY	= MyMouseY;
    }
}







int main(S16 argc,U8 *argv[])
{
    char palette[768];


    atexit(Fin);

    #define lname   "adeline.def"
    #define inits   INIT_TIMER|INIT_SVGA|INIT_KEYB|INIT_MOUSE|INIT_3D
    #include "f:\projet\lib386\lib_sys4\initadel.c"

    Cls();
    FullFlip();
    Load("PALETTE.PCP",palette);
    Palette(palette);
    LoadLevel();
    InitPalMenu();

    CreateMenu();

    BouclePrincipale();

    Cls();
    FullFlip();

    return 0;
}


