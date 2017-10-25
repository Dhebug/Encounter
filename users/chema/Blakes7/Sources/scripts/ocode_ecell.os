/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"

/* Object command script and strings */

stringpack ECELL{
#ifdef ENGLISH	
	"Energy to power up a whole ship.";
	"I can't use the cell there.";
#endif
#ifdef SPANISH
	"Energía para una nave entera.";
	"No puedo usar la célula así.";
#endif	
}

objectcode ECELL
{
	LookAt: 
		scActorTalk(BLAKE,ECELL,0);
		scWaitForActor(BLAKE);
		scStopScript();
	PickUp:
		scPutInInventory(ECELL);
		scStopScript();
	Use:
		scActorTalk(BLAKE,ECELL,1);		
}
