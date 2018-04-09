/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"


/* Object command script and strings */

stringpack UNIFORM
{
#ifdef ENGLISH
	/***************************************/
	"A Federation soldier uniform.";
	"Not now. I don't want to move around";
	"in a uniform that is too small for me.";  // [laurentd75]: correction: added "too"

#endif

#ifdef FRENCH
	/***************************************/
	"Un uniforme de soldat de la Fédération.";
	"Plus tard. Je ne tiens pas a déambuler"; // [laurentd75]: trainer, roder, sortir, me balader, crapahuter, déambuler, flaner
	"dans un uniforme trop petit pour moi."; // ou "dans un uniforme qui m'est trop petit"

#endif
#ifdef SPANISH
	"Un uniforme de soldado.";
	"Ahora no. No quiero ir por ahí con";
	"un uniforme que me está pequeño.";
#endif
}

objectcode UNIFORM
{
	byte string;
	LookAt: 
		scActorTalk(BLAKE,UNIFORM,0);
		scWaitForActor(BLAKE);
		scStopScript();
	Use:
		if(sfGetCurrentRoom()!=ROOM_CELLCORRIDOR){
			scActorTalk(BLAKE,UNIFORM,1);
			scWaitForActor(BLAKE);
			scActorTalk(BLAKE,UNIFORM,2);
			scWaitForActor(BLAKE);
		}
		else{
			scTerminateScript(210);
			scSpawnScript(211);
			scSetCostume(BLAKE,3,0);
			scRemoveFromInventory(UNIFORM);
			scPlaySFX(SFX_BEEPLE);
			scSave();
		}	
}
