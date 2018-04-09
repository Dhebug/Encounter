/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

/* Object command script and strings */

stringpack ECELL{
#ifdef ENGLISH	
	"Energy to power up a whole ship.";
	"I can't use the cell there.";
#endif
#ifdef FRENCH	
	"De l'énergie pour un vaisseau entier.";
	"Je ne peux pas utiliser la pile ici."; // [laurentd75]: pile/batterie/ou cellule: 
	                                        // cf. room_hideout.os et liberatorcargo.os, et obj_ep2.s dans ../resdata
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
