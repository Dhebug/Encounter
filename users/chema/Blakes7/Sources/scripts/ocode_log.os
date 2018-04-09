/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

/* Object command script and strings */

stringpack WOODENLOG{
#ifdef ENGLISH	
	/***************************************/
	"Seems resistant, despite its weight.";
	"I can't use the log with that.";
	"I'd better keep it there.";
#endif
#ifdef FRENCH	
	/***************************************/
	"Ca parait résistant, malgré son poids.";
	"Je ne peux utiliser le tronc comme ca."; // [laurentd75]: tronc, rondin ou branche - voir "forest.os"
	"Mieux vaut le laisser ici.";
#endif
#ifdef SPANISH
	/***************************************/
	"Parece resistente, pese a su peso.";
	"No puedo usar el tronco con eso.";
	"Mejor lo dejo aquí.";
#endif
}

objectcode WOODENLOG
{
	LookAt:
		scActorTalk(sfGetActorExecutingAction(),WOODENLOG,0);
		scStopScript();
	Use:
		if(sfIsObjectInInventory(WOODENLOG)){
			scActorTalk(BLAKE,WOODENLOG,1);	//We ca use Blake here, as he is the only one who could have it.		
			scStopScript();
		}
	PickUp:
		scActorTalk(sfGetActorExecutingAction(),WOODENLOG,2);			
		
}

