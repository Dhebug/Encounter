//
//
// Convertisseur d'images PCX vers format ORIC
//
// Mick: Fri  13/09/96
//	      16:16:14
//
//

#include "F:\projet\lib386\lib_sys4\adeline.h"
#include "F:\projet\lib386\lib_sys4\lib_sys.h"
#include "F:\projet\lib386\lib_svg5\lib_svga.h"


//#include	  <stdio.h>
//#include	  <conio.h>
//#include	  <stdlib.h>
//#include	  <sys\types.h>
//#include	  <direct.h>
//#include	  <string.h>
//#include	  <dos.h>

//#include	  <mem.h>

#include	<stdarg.h>
#include	<ctype.h>


#include	"F:\PROJET\TIME\TOOLS\FILES\FILES.H"

//
// Types de valeurs sous deluxe paint:
//
//   0 Sol
//   1 Mur
//   2 Faux mur
//   3 Porte ferm‚e
//   4 Porte ouverte
//   5 Porte cass‚e
//   6 Grille ferm‚e
//   7 Grille ouverte
//   8 Trape ferm‚e
//   9 Trappe ouverte
//  10 Dalle au sol
//  11 Boutton rond
//  12 Boutton rond enfonc‚
//  13 Boutton carr‚
//  14 Boutton carr‚ enfonc‚
//  15 Levier lev‚
//  16 Levier baiss‚
//  17 Escalier vers le haut
//  18 Escalier vers le bas
//  19 Niche carr‚e
//  20 Niche arrondie
//  21 Menotes sur un mur
//  22 Bouche d'‚gouts sur un mur
//  23 Fontaine
//  24 T‚l‚porteur
//  25 Bouche lance flamme
//  26 Serrure
//  27 Gargouille





#define GROUND_OPAQUE	 1
#define GROUND_CHUTE	 2
#define GROUND_SOLIDE	 4
#define GROUND_CLOSABLE  8
#define GROUND_TELEPORT  16
#define GROUND_BUTTON	 32
#define GROUND_INSERT	 64

#define LEVEL_POS(x,y,level)	(((x)&31)+(((y)&31)<<5)+(((level)&63)<<10))


/*
    Type:

    0 Sol
    1 Mur
    2 Porte
*/



typedef struct
{
    unsigned int    position;	    // de type LEVEL_POS(x,y,level)
    unsigned char   type;
    unsigned char   value;
} DUNGEON_OBJECT;



DUNGEON_OBJECT	DungeonObject[500];
S32		NbDungeonObject=0;




S32	Level=0;

FILE	*File;
UBYTE	*Image;
UBYTE	*PaletteImage;

UBYTE	NomImage[_MAX_PATH];
UBYTE	NomFichierTexture[_MAX_PATH];
UBYTE	NomFichierDest[_MAX_PATH];



UBYTE	SDrive[_MAX_DRIVE] ;
UBYTE	SDir[_MAX_DIR] ;
UBYTE	SName[_MAX_FNAME] ;
UBYTE	SExt[_MAX_EXT] ;


LONG	FlagInfos;
LONG	FlagPause;
LONG	FlagPalette;







void	Error(UBYTE *message,...)
{
    WORD    l;
    BYTE    c;
    BYTE    str[256];
    BYTE    tempo[34];
    BYTE    *str_out = str;
    BYTE    *ptr;
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
	    case 'C':       /* BYTE */
		tempo[0] = va_arg(ap,BYTE);
		tempo[1] = 0;
		strcat(str_out,tempo);
		l++;
		break;

	    case 'S':       /* string */
		ptr = va_arg(ap,BYTE*);
		strcat(str_out,ptr);
		l += strlen(ptr);
		break;

	    case 'B':       /* byte */
		strcat(str_out,ltoa(va_arg(ap,UBYTE),tempo,10));
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
	    str[l] = c;
	    l++;
	    str[l] = 0;
	}
    }
    va_end(ap);

    printf("\nÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍµERRORÆÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ");
    printf("\n%s",str);
    //fprintf(stderr,"\n%s",str);
    printf("\nÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ");
    printf("\n");
    exit(1);
}


#include	"F:\PROJET\TIME\TOOLS\FILES\FILES.C"






void OpenSource(char *name)
{
    if (!(File=fopen(name,"wb")))                     Error("Create error: ®%s¯",name);
}


void CloseSource()
{
    fclose(File);
}





void LoadImage(char *image)
{
    if (!FileSize(image))			    Error("Not found: ®%s¯",image);
    Load_Pcx(image,Image,PaletteImage);
}



void CutMap(U32 x1,U32 y1,U32 l,U32 h)
{
    S32 	xpos,ypos;
    S32 	x,y;

    S32 	a;

    U8		*ptr1;


    printf("Cutting...\n");


    ypos=0;
    for (y=y1;y<y1+h;y++)
    {
	fprintf(File,"    ");
	ptr1=Image+y*320+x1;

	a=0;
	xpos=0;
	for (x=0;x<l;x++)
	{
	    a=*ptr1++;
	    fprintf(File,"%d,",a);
	    if (a>1)
	    {
		DungeonObject[NbDungeonObject].position =LEVEL_POS(xpos,ypos,Level);
		DungeonObject[NbDungeonObject].type	=a;
		DungeonObject[NbDungeonObject].value	=0;
		NbDungeonObject++;
	    }
	    xpos++;
	}
	fprintf(File,"\n");
	ypos++;
    }
    fprintf(File,"\n\n");

}






void	MainLoop()
{
    S32     n;

    PaletteImage=Malloc(768+640*480+500);
    if (!PaletteImage)	Error("Allocation m‚moire pour PCX impossible");
    Image=PaletteImage+768;

    OpenSource("D:\\ORIC\\DEV\\SOURCES\\DUNGEON\\LEVELS.C");
    LoadImage("D:\\ORIC\\DEV\\SOURCES\\DUNGEON\\PIC\\LEVELS.PCX");

    fprintf(File,"\n\nunsigned int Map[2][32][32]=\n{\n");

    Level=0;
    CutMap(  1,  1, 32, 32);	// Level 0

    Level=1;
    CutMap( 34,  1, 32, 32);	// Level 1

    fprintf(File,"};\n\n");
    CloseSource();


    //
    // Sauve les emplacements des portes et autres trappes, boutons,...
    //
    OpenSource("D:\\ORIC\\DEV\\SOURCES\\DUNGEON\\OBJECTS.C");
    fprintf(File,"\n\nDUNGEON_OBJECT DungeonObject[%d]=\n{\n",NbDungeonObject);
    for (n=0;n<NbDungeonObject;n++)
    {
	fprintf(File,"    {%d,%d,%d},\n",DungeonObject[n].position,DungeonObject[n].type,DungeonObject[n].value);
    }
    fprintf(File,"};\n\n");
    CloseSource();

}











#define NB_ARG	2


void main(WORD argc,UBYTE *argv[])
{
    /*
    #define lname   "LBA.CFG"
    #define inits   INIT_TIMER|INIT_SVGA|INIT_KEYB
    #include "f:\projet\lib386\lib_sys3\initadel.c"
    */

    MainLoop();
    exit(0);
}





