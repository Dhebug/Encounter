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



UBYTE	NomImage[_MAX_PATH];
UBYTE	NomFichierTexture[_MAX_PATH];
UBYTE	NomFichierDest[_MAX_PATH];



UBYTE	SDrive[_MAX_DRIVE] ;
UBYTE	SDir[_MAX_DIR] ;
UBYTE	SName[_MAX_FNAME] ;
UBYTE	SExt[_MAX_EXT] ;


LONG	FlagLori;
LONG	FlagInfos;
LONG	FlagPause;
LONG	FlagPalette;



U8	    Header[]={0x16,0x16,0x16,0x24,0x00,0x00,0x80,0x00,0xbf,0x40,0xa0,0x00,0x00};


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









void InitLog()
{
    LONG    y;
    ULONG   *ptr = &TabOffLine;

    if (!(Log=Malloc(640*480)))     Error("Pas assez de m‚moire pour le buffer Log");
    MemoLog=Log;
    SetClip(0,0,639,479);
    Screen_X=640;
    Screen_Y=480;
    for (y=0;y<480;y++) *ptr++ = y*640;
}









void	MainLoop()
{
    FILE_COUNT	fichier;
    LONG	x,y,xx;
    S32 	a,b;

    UBYTE	*image;
    U8		*dest;
    UBYTE	*palette_image;
    U8		*ptr1;
    U8		*ptr2;

    U8		*ptr_attrib;

    InitLog();

    _splitpath(NomImage,SDrive,SDir,SName,SExt);

    _makepath(NomFichierTexture,SDrive,SDir,SName,"PCX") ;
    _makepath(NomFichierDest,SDrive,SDir,SName,"HIR") ;         // xxxxxxxx.HIR(es)


    //
    //
    // R‚serve de la place pour charger les PCX
    //
    //
    palette_image=Malloc(768+640*480+500);
    if (!palette_image)  Error("Allocation m‚moire pour PCX impossible");
    image=palette_image+768;

    if (!(dest=Malloc(8000)))	    Error("Not enough ram");

    //
    //
    // Charge et convertie la page de texture
    //
    //
    if (FlagInfos)  printf("\nTransformation de l'image (%s)",NomFichierTexture);

    if (!FileSize(NomFichierTexture))			   Error("Image introuvable");
    Load_Pcx(NomFichierTexture,image,palette_image);

    memset(dest,64,8000);

    for (y=0;y<200;y++)
    {
	ptr1=image+y*320;
	ptr2=dest+y*40;
	ptr_attrib=ptr2;

	a=0;
	for (x=0;x<40;x++)
	{
	    a=0;
	    for (xx=0;xx<6;xx++)
	    {
		a<<=1;
		b=*ptr1++;
		if (b)
		{
		    a |=1;
		    if (b<8)	*ptr_attrib=b;
		}
	    }
	    a&=63;
	    *ptr2++= 64 + a;
	}
    }


    OpenWriteCount(&fichier,NomFichierDest);
    WriteMult(&fichier,"Sauve header",Header,13);
    WriteMult(&fichier,"Nom",SName,strlen(SName)+1);
    WriteMult(&fichier,"Sauve image",dest,8000);
    CloseCount(&fichier);
    Free(palette_image);
}











#define NB_ARG	2


void main(WORD argc,UBYTE *argv[])
{
    S32     param;
    S32     nb_arg;

    /*
    #define lname   "LBA.CFG"
    #define inits   INIT_TIMER|INIT_SVGA|INIT_KEYB
    #include "f:\projet\lib386\lib_sys3\initadel.c"
    */

    FlagLori=FALSE;
    FlagInfos=FALSE;
    FlagPause=FALSE;
    FlagPalette=TRUE;

    param=1;

    for (;;)
    {
	nb_arg=argc;
	if (!memicmp(argv[param],"-i",2))
	{
	    FlagInfos=atoi(argv[param]+2);
	    argc--;
	    param++;
	}
	else if (!stricmp(argv[param],"-p"))
	{
	    FlagPause=TRUE;
	    argc--;
	    param++;
	}
	else if (!stricmp(argv[param],"-NOPAL"))
	{
	    FlagPalette=FALSE;
	    argc--;
	    param++;
	}
	if (nb_arg==argc)   break;
    }


    if (argc==NB_ARG)
    {
	strcpy(NomImage,argv[param]);
	MainLoop();
    }
    else
    {
	printf("\n");
	printf("\nÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿");
	printf("\n³ D‚coupeur d'images PCX    ³");
	printf("\n³     vers format ORIC      ³");
	printf("\n³           V0.1            ³");
	printf("\n³ (c) 1996 POINTIER Micka‰l ³");
	printf("\n³   from Adeline Software   ³");
	printf("\nÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ");
	printf("\nDate de compilation: "__DATE__);
	printf("\nHeure de compilation: "__TIME__);
	printf("\n");
	printf("\n\n  USAGE:");
	printf("\n\n  CONVERT [option 1] [option 2] [option ...] <nom de la PCX>");
	printf("\n\n    [options]:");
	printf("\n      ®-i1¯ Pour avoir des informations simples.");
	printf("\n      ®-i2¯ Pour avoir toutes les informations.");
	printf("\n      ®-p¯  Pour avoir une pause aprŠs chaque traitement.");
	printf("\n");
	exit(1);
    }
    printf("\nÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿");
    printf("\n³Op‚ration termin‚e³");
    printf("\nÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ");
    printf("\n\n");
    exit(0);
}





