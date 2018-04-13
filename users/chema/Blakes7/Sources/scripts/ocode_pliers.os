/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

/* Object command script and strings */

stringpack PLIERS{
#ifdef ENGLISH	
	"Magnetic long-nose pliers.";
	"Cannot use the pliers here.";
#endif
#ifdef FRENCH	
	"Des pinces magnétiques à long bec.";
	"Je ne peux pas utiliser les pinces ici.";
#endif
#ifdef SPANISH
	"De punta larga y magnética.";
	"No puedo usar las tenazas aquí";
#endif
}

objectcode PLIERS
{
	LookAt: 
		scActorTalk(BLAKE,PLIERS,0);
		scWaitForActor(BLAKE);
		scStopScript();
	PickUp:
		scPutInInventory(PLIERS);
		scStopScript();
	Use:
		scActorTalk(BLAKE,PLIERS,1);

}
