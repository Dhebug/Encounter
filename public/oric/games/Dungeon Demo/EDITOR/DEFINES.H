#ifndef defines_h
#define defines_h


//#define DEBUG_MALLOC	    // LoadMallocGIF n'accepte pas le mode Safe_Malloc !!! Burk


#define OBJECT_PTR		1		// Ca veut dire que l'on passe des pointeurs !!!
#define SIZE_BUFFER_ANIM	2000

#include "f:\projet\lib386\lib_sys4\adeline.h"
#include "f:\projet\lib386\lib_sys4\lib_sys.h"
#include "f:\projet\lib386\lib_svg5\lib_svga.h"
#include "f:\projet\lib386\lib_men3\lib_menu.h"
#include "f:\projet\lib386\lib_3d6\lib_3d.h"


#include <stdlib.h>
#include <stdarg.h>
#include <stdio.h>
#include <math.h>
#include <mem.h>
#include <dos.h>
#include <string.h>
#include <limits.h>
#include <conio.h>
#include <ctype.h>
#include <direct.h>
#include <time.h>
#include <env.h>



enum
{
    ID_MENU_LOAD,
    ID_MENU_SAVE,
    ID_MENU_LEVEL,
    ID_MENU_QUITTE,
    ID_MENU_TYPE_DRAW,
    ID_MENU_TYPE_ERASE,
};





// couleur
//#define BLACK   0
#define GRIS	8
//#define MAGENTA 13


#define RELIEF_RED_0	(B_RED+2)
#define RELIEF_RED_1	(B_RED+1)
#define RELIEF_RED_2	(B_RED+0)

#define RELIEF_BLUE_0  (B_GREY+2)
#define RELIEF_BLUE_1  (B_GREY+1)
#define RELIEF_BLUE_2  (B_GREY+0)


#define BANQUE_RED	4
#define BANQUE_YELLOW	6
#define BANQUE_GREEN	8
#define BANQUE_GRIS	11
#define BANQUE_BLUE	12



#endif
