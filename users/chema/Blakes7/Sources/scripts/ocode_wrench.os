/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"

/* Object command script and strings */

stringpack WRENCH{
#ifdef ENGLISH	
	"Chromium-vanadium alloy?";
	"The wrench cannnot be used that way.";
#endif
#ifdef SPANISH
	"¿Serán de cromo-vanadio?";
	"No se puede usar la llave así.";
#endif
}

objectcode WRENCH
{
	LookAt: 
		scActorTalk(BLAKE,WRENCH,0);
		scWaitForActor(BLAKE);
		scStopScript();
	PickUp:
		scPutInInventory(WRENCH);
		scStopScript();
	Use:
		scActorTalk(BLAKE,WRENCH,1);
	
}
