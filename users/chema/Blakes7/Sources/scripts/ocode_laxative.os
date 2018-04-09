/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
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
#ifdef FRENCH
	"Laxatif Surpuissant.";
	"Je ne peux utiliser le laxatif ainsi.";
#endif
#ifdef SPANISH
	"Laxante Ultra-Potente.";
	"No puedo usar el laxante así.";
#endif
}
