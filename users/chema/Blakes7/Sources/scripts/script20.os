/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"

#define STLOCAL 	2	// We'll re-use id

#define ZENSTART	6

/* Change ego to Avon	*/
script 20{
	byte i;
	
	scLockResource(RESOURCE_STRING,STLOCAL);
	scShowVerbs(false);
	scClearInventory();

	// Remove Vila, Jenna and Gan from the Service room
	scRemoveObjectFromGame(VILA);
	scRemoveObjectFromGame(JENNA);
	scRemoveObjectFromGame(GAN);
	
	// Turn to Avon in the Liberator
	scLoadObjectToGame(AVON);
	scSetEgo(AVON);	
	scSetPosition(AVON, ROOM_LIBZEN, 16,19);
	scFollowActor(AVON);
	scLookDirection(AVON,FACING_LEFT);
	tmpParam1=0; // To avoid any automatic action when entering room
	scLoadRoom(ROOM_LIBZEN);
	scDelay(100);
	
	// Zen detects pursuit ships...
	tmpParam1=ZENSTART;
	scChainScript(202);
	scLookDirection(AVON,FACING_RIGHT);
	tmpParam1=ZENSTART+1;
	scChainScript(202);
	scDelay(30);
	tmpParam1=ZENSTART+2;
	scChainScript(202);
	tmpParam1=ZENSTART+3;
	scChainScript(202);

	for (i=0;i<=3;i=i+1){
		scActorTalk(AVON,STLOCAL,i);
		scWaitForActor(AVON);
		if(i==0) scDelay(20);
	}
	tmpParam1=ZENSTART+4;
	scChainScript(202);
	scDelay(50);

	scLookDirection(AVON, FACING_DOWN);
	for (i=4;i<=10;i=i+1){
		scActorTalk(AVON,STLOCAL,i);
		scWaitForActor(AVON);
		if(i==7){ 
			scDelay(20);
			scLookDirection(AVON,FACING_RIGHT);
		}
	}
	
	tmpParam1=ZENSTART+5;
	scChainScript(202);	
	tmpParam1=ZENSTART+6;
	scChainScript(202);

	scDelay(50);
	scLookDirection(AVON,FACING_DOWN);
	scDelay(100);

	scActorTalk(AVON,STLOCAL,11);
	scWaitForActor(AVON);
	
	scUnlockResource(RESOURCE_STRING,STLOCAL);
	scShowVerbs(true);
	scCursorOn(true);  // Is this necessary?
	scSave();
}

stringpack STLOCAL{
#ifdef ENGLISH
	"I knew it was a trap...";
	"Zen, put the Liberator outside";
	"their sensor range, keeping them";
	"below the horizon.";
	
	/**************************************/
	"And what do I do now?...";
	"I could run free forever in this ship.";
	"I don't need Blake.";
	"I don't need anybody at all!";
	
	"Zen, what are the odds for a single";
	"man to hide away from the Federation";
	"with the Liberator?";
	
	"Okay. I'll rescue them.";
#endif
#ifdef SPANISH
	"Sabía que era una trampa...";
	"Zen, maniobra fuera del rango de sus";
	"sensores, manteniéndolos por debajo";
	"del horizonte.";
	
	/**************************************/
	"¿Qué hago ahora?...";
	"Podría huir por siempre en esta nave.";
	"No necesito a Blake.";
	"¡No necesito a nadie!";
	
	"Zen, ¿cuales son las probabilidades de";
	"que un sólo hombre se esconda de la";
	"Federación con el Libertador?";
	
	"Está bien. Les rescataré entonces.";

#endif
	
}
