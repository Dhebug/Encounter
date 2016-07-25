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

    printf("\nออออออออออออออออตERRORฦออออออออออออออออ");
    printf("\n%s",str);
    //fprintf(stderr,"\n%s",str);
    printf("\nอออออออออออออออออออออออออออออออออออออออ");
    printf("\n");
    exit(1);
}


#include	"F:\PROJET\TIME\TOOLS\FILES\FILES.C"






void OpenSource(char *name)
{
    if (!(File=fopen(name,"wb")))                     Error("Create error: ฎ%sฏ",name);
}


void CloseSource()
{
    fclose(File);
}





void LoadImage(char *image)
{
    if (!FileSize(image))			    Error("Not found: ฎ%sฏ",image);
    Load_Pcx(image,Image,PaletteImage);
}



void CutBloc(char *name,U32 x1,U32 y1,U32 l,U32 h,S32 value)
{
    S32 	x,y;

    S32 	xx;
    S32 	a,b;

    U8		*ptr1;


    printf("Cutting: %s\n",name);

    fprintf(File,"\n\nunsigned char %s[]={\n",name);

    for (y=y1;y<y1+h;y++)
    {
	fprintf(File,"    ");
	ptr1=Image+y*320+x1;

	a=0;
	for (x=0;x<l/6;x++)
	{
	    a=0;
	    for (xx=0;xx<6;xx++)
	    {
		a<<=1;
		b=*ptr1++;
		if (b)
		{
		    a |=1;
		}
	    }
	    a&=63;
	    fprintf(File,"0x%02x,",64+a+value);
	}
	fprintf(File,"\n");
    }

    fprintf(File,"};\n\n");
}






void	MainLoop()
{
    PaletteImage=Malloc(768+640*480+500);
    if (!PaletteImage)	Error("Allocation mmoire pour PCX impossible");
    Image=PaletteImage+768;

    //
    // Dcoupe et sauve les lements du dcors
    //
    OpenSource("D:\\ORIC\\DEV\\SOURCES\\DUNGEON\\WALLS.C");
    LoadImage("D:\\ORIC\\DEV\\SOURCES\\DUNGEON\\PIC\\WALLS.PCX");
    CutBloc("wall_c0"    ,  1,  1, 60, 50,  0);
    CutBloc("wall_c1"    , 62,  1, 84, 63,  0);
    CutBloc("wall_c2"    ,147,  1,144, 99,  0);

    CutBloc("wall_g"     , 51, 52,  6, 48,  0);
    CutBloc("wall_g0"    , 62, 65, 12, 63,  0);
    CutBloc("wall_g1"    , 20, 52, 30,100,  0);
    CutBloc("wall_g2"    ,  1, 52, 18,122,  0);

    CutBloc("wall_d"     ,138, 65,  6, 48,  0);
    CutBloc("wall_d0"    , 75, 65, 12, 63,  0);
    CutBloc("wall_d1"    , 88, 65, 30,100,  0);
    CutBloc("wall_d2"    ,119, 65, 18,122,  0);

    CutBloc("pit_1"      ,145,101, 78, 25,  0);
    CutBloc("pit_0"      ,138,127, 60, 11,  0);

    CutBloc("door_g2"    ,224,101, 30, 99,  0);
    CutBloc("door_d2"    ,255,101, 30, 99,  0);
    CutBloc("door_c2"    ,292,  1, 24, 79,128);

    CutBloc("door_g1"    ,205,127, 18, 63,  0);
    CutBloc("door_d1"    , 56,129, 18, 63,  0);
    CutBloc("door_c1"    , 75,129, 12, 52,128);

    CutBloc("door_center",292, 81, 24,107,  0);

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





