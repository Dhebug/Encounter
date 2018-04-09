/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

/* Object command script and strings */

objectcode MUG
{
	byte actor;
	LookAt: 
		actor=sfGetActorExecutingAction();
		scCursorOn(false);
		scActorTalk(actor,MUG,0);
		scWaitForActor(actor);
		scActorTalk(actor,MUG,1);
		scWaitForActor(actor);
		scCursorOn(true);
		scStopScript();
	PickUp:
		scPutInInventory(MUG);
}

stringpack MUG
{
#ifdef ENGLISH
	"The mug I bought last month.";
	"It is empty."
#endif
#ifdef FRENCH
	"Le mug que j'ai acheté le mois dernier.";
	"Il est vide."
#endif
#ifdef SPANISH
	"La taza que compré el mes pasado.";
	"Está vacía."
#endif
}
