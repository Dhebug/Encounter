
/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

/* Object command script and strings */

stringpack GUN{
#ifdef ENGLISH	
	/***************************************/
	"Tt looks like a hair curl iron or a";
	"pulley stopper.";
#endif
#ifdef FRENCH	
	/***************************************/
	"On dirait un fer à friser, ou bien un";
	"bloqueur de poulie.";
#endif
#ifdef SPANISH
	/***************************************/
	"Parece un rizador de pelo o el tope de";
	"una polea grande.";
#endif
}

objectcode GUN
{
	LookAt:
		scCursorOn(false);
		scActorTalk(BLAKE,GUN,0);
		scWaitForActor(BLAKE);
		scActorTalk(BLAKE,GUN,1);
		scWaitForActor(BLAKE);
		scCursorOn(true);
		scStopScript();
	/*Use:
		scActorTalk(BLAKE,GUN,2);
		scWaitForActor(BLAKE);	
		scStopScript();
	*/
}
