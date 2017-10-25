/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"

/* Object command script and strings */

objectcode LAXATIVE
{
	LookAt:
		scCursorOn(false);
		scActorTalk(BLAKE,LAXATIVE,0);
		scWaitForActor(BLAKE);		
		scCursorOn(true);
		scStopScript();
	Use:
		scActorTalk(BLAKE,LAXATIVE,1);
	
}

stringpack LAXATIVE
{
#ifdef ENGLISH
	"Super-Strong Laxative.";
	"Can't use the laxative that way.";
#endif
#ifdef SPANISH
	"Laxante Ultra-Potente.";
	"No puedo usar el laxante así.";
#endif
}