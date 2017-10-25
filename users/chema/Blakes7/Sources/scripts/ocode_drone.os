/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"

/* Object command script and strings */

objectcode DRONE{
	byte actor;
	LookAt:
		scCursorOn(false);
		actor=sfGetEgo();
		scActorTalk(actor, DRONE,0);
		scWaitForActor(actor);
		scActorTalk(actor, DRONE,1);
		scWaitForActor(actor);	
		if(actor==AVON){
			scActorTalk(actor, DRONE,3);
			scWaitForActor(actor);
			scActorTalk(actor, DRONE,4);
			scWaitForActor(actor);
		}
		scCursorOn(true);
		scStopScript();
	PickUp:
		actor=sfGetEgo();
		if(actor==BLAKE){
			scActorTalk(BLAKE, DRONE,2);
			scWaitForActor(BLAKE);
		}
		else{
			scPutInInventory(DRONE);
			bDroneTaken=true;
			scSave();
		}

}


stringpack DRONE{
#ifdef ENGLISH
	/***************************************/
	"It looks like a small drone, but it";
	"seems to be broken beyond repair.";
	"I wouldn't know what to do with it.";
	"I wonder if I can make use of that";
	"transmitter and that receiver...";
#endif

#ifdef SPANISH
	/***************************************/
	"Parece un pequeño dron, pero está";
	"roto sin posibilidad de reparación.";
	"No sabría qué hacer con él.";
	"Me pregunto si podría hacer algo con";
	"ese transmisor y ese receptor...";
#endif
}


