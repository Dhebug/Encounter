/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"


/* Object command script and strings */

stringpack UNIFORM
{
#ifdef ENGLISH
	/***************************************/
	"A Federation soldier uniform.";
	"Not now. I don't want to move around";
	"in a uniform that is small for me.";

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
