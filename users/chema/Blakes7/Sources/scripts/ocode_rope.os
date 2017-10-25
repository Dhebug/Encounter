/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"

/* Object command script and strings */

stringpack ROPE{
#ifdef ENGLISH	
	/***************************************/
	"Looks like a strong rope.";
	"I can't use the rope with that.";
#endif
#ifdef SPANISH
	/***************************************/
	"Parece una cuerda fuerte.";
	"No puedo usar la cuerda con eso.";
#endif
}

objectcode ROPE
{
	LookAt:
		scActorTalk(BLAKE,ROPE,0);
		scStopScript();
	Use:
		scActorTalk(BLAKE,ROPE,1);
}

