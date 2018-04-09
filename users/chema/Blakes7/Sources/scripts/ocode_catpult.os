/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

/* Object command script and strings */

stringpack CATPULT{
#ifdef ENGLISH	
	/***************************************/
	"A deadly weapon.";
	"With the proper projectile, that is.";
	"I don't have a projectile.";
	"Just tell me the target.";
#endif
#ifdef FRENCH	
	/***************************************/
	"Une arme mortelle...";
	"...si l'on a le projectile adéquat.";
	"Je n'ai aucun projectile.";
	"Indiquez-moi simplement la cible.";
#endif
#ifdef SPANISH
	/***************************************/
	"Un arma mortífera.";
	"Con un proyectil apropiado, claro.";
	"No tengo un proyectil.";
	"Indícame el objetivo.";
#endif	
}

objectcode CATPULT
{
	LookAt:
		scCursorOn(false);
		scActorTalk(BLAKE,CATPULT,0);
		scWaitForActor(BLAKE);
		scActorTalk(BLAKE,CATPULT,1);
		scWaitForActor(BLAKE);
		scCursorOn(true);
		scStopScript();
	Use:
		if(!sfIsObjectInInventory(BEARING)){
			scActorTalk(BLAKE,CATPULT,2);
		}
		else{
			scActorTalk(BLAKE,CATPULT,3);
		}
		scWaitForActor(BLAKE);			
}



