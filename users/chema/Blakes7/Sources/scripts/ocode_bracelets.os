
/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"

/* Object command script and strings */

stringpack BRACELETS{
#ifdef ENGLISH	
	/***************************************/
	"Some extra bracelets, enough to bring";
	"the rest of my crew up.";
	"These are for the rest of the crew.";
#endif
#ifdef SPANISH
	/***************************************/
	"Algunas pulseras de más, para poder";
	"traer al resto de mi tripulación.";
	"Estas pulseras son para los demás.";
#endif
}

objectcode BRACELETS
{
	LookAt:
		scCursorOn(false);
		scActorTalk(BLAKE,BRACELETS,0);
		scWaitForActor(BLAKE);
		scActorTalk(BLAKE,BRACELETS,1);
		scWaitForActor(BLAKE);
		scCursorOn(true);
		scStopScript();
	Use:
		scActorTalk(BLAKE,BRACELETS,2);
		scWaitForActor(BLAKE);	
		scStopScript();
}
