//
//
//
//
//
//			    €ﬂﬂﬂﬂ €ﬂﬂﬂ€ €‹ ‹€ €ﬂﬂﬂﬂ
//			    €€ ﬂ€ €€ﬂﬂ€ €€ﬂ € €€ﬂﬂ
//			    ﬂﬂﬂﬂﬂ ﬂﬂ  ﬂ ﬂﬂ  ﬂ ﬂﬂﬂﬂﬂ
//
//		      €     €ﬂﬂﬂ€ €ﬂﬂﬂ€ €ﬂﬂﬂ‹ €ﬂﬂﬂﬂ €ﬂﬂﬂ€
//		      €€    €€	€ €€ﬂﬂ€ €€  € €€ﬂﬂ  €€ﬂ€ﬂ
//		      ﬂﬂﬂﬂﬂ ﬂﬂﬂﬂﬂ ﬂﬂ  ﬂ ﬂﬂﬂﬂ  ﬂﬂﬂﬂﬂ ﬂﬂ	ﬂ
//
//
//
//

//
//  Ce petit module est destinÇ Ö assurer la liaison entre les
// diffÇrents morceaux du jeu.
//
//  Le premier test sera de savoir si on peu lancer plusieurs
// exÇcutables, les uns Ö la suite des autres !!!
//



#include    "lib.h"

#include    "defines.h"


void cload(char *name)
{
    poke(0x24d,0);  // rapide
    poke(0x2ae,1);  // Asm
    poke(0x25e,0);  // No VÇrifi
    poke(0x25a,0);  // NoMerge
    strcpy((char*)0x293,name);
    strcpy((char*)0x27f,name);
    call(0xe874);
    /*
    call(0xe76a);   // Inhibe kbd
    call(0xe57d);   // Searching
    call(0xe4ac);
    call(0xe59b);
    call(0xe4e0);
    call(0xe93d);
    */
    //call(0x600);
}

void main()
{

    hires();
    while (TRUE)
    {
	cload("NEXT.HIR");
	cload("PAUSE.HIR");
	cload("HELP.HIR");
	//sedoric("!LOAD \"GAME.COM\"");
    }
}


