
/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"

#define STDESC  	200


/* Jenna guides Blake through the door 	*/
/* towards the entry to the base.	*/
script 17{
	byte i;
	scShowVerbs(false);
	scPlaySFX(SFX_DOOR);
	scDelay(5);
	scPlaySFX(SFX_DOOR);	
	scSetPosition(JENNA,ROOM_HIDEOUT,16,55);
	scSetPosition(BLAKE,ROOM_HIDEOUT,14,64);
	scLoadRoom(ROOM_HIDEOUT);
	scBreakHere();
	scLookDirection(JENNA,FACING_RIGHT);	
	
	for (i=7;i<=10;i=i+1){
		scActorTalk(JENNA,STDESC,i);
		scWaitForActor(JENNA);
		if(i==9){
			scActorWalkTo(JENNA,56,11);
			scWaitForActor(JENNA);
		}
	}
	scActorWalkTo(BLAKE,60,12);
	scWaitForActor(BLAKE);
	
	scSetPosition(JENNA,ROOM_TUNNEL,15,14);
	scSetPosition(BLAKE,ROOM_TUNNEL,16,21);
	scLookDirection(BLAKE,FACING_UP);
	scLookDirection(JENNA,FACING_RIGHT);
		
	scLoadRoom(ROOM_TUNNEL);

	// Show verbs back, save and finish.
	scShowVerbs(true);
	scSave();
}
