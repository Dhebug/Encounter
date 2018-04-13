/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

#define DOOR		200
#define EXIT		201
#define CONTROLS	202

// String pack for descriptions in this room
#define STDESC  	200

// Open door
script 210{
	byte i;
	
	scPlaySFX(SFX_DOOR);
	for(i=1;i<=3;i=i+1){
		scSetAnimstate(DOOR,i);
		scDelay(10);
	}
}

// Close door
script 211{
	byte i;
	
	scPlaySFX(SFX_DOOR);
	for(i=2;i<255;i=i-1){
		scSetAnimstate(DOOR,i);
		scDelay(10);
	}
}


objectcode DOOR{
	byte a;
	LookAt:
		scCursorOn(false);
		a=sfGetEgo();
		scActorTalk(a,STDESC,0);
		scWaitForActor(a);
		scActorTalk(a,STDESC,1);
		scWaitForActor(a);
		scCursorOn(true);
		scStopScript();
	Open:
		scCursorOn(false);
		scChainScript(210);
		scCursorOn(true);
		scStopScript();
	Close:
		scCursorOn(false);
		scChainScript(211);
		scCursorOn(true);
		scStopScript();
	Use:
	WalkTo:	
		if(sfGetAnimstate(DOOR)==0){
			scChainScript(210);
		}
		if(!bIntroBaseDone){
			scSpawnScript(18);
			scStopScript();
		}
		else{
			scSetPosition(sfGetEgo(),ROOM_CORRIDOR,15,96);
			scLookDirection(sfGetEgo(),FACING_LEFT);
			scChangeRoomAndStop(ROOM_CORRIDOR);
		}
}


objectcode EXIT{
	WalkTo:
	Use:
		scSetPosition(sfGetEgo(),ROOM_HIDEOUT,12,58);
		scLookDirection(sfGetEgo(),FACING_DOWN);
		scChangeRoomAndStop(ROOM_HIDEOUT);
}


stringpack STDESC{
#ifdef ENGLISH
/***************************************/
"Acording to Jenna, this door leads to";
"the interior of the base.";
#endif

#ifdef FRENCH
/***************************************/
"Selon Jenna, cette porte mène à";
"l'intérieur de la base.";
#endif

#ifdef SPANISH
/***************************************/
"Según Jenna, esta puerta lleva al";
"interior de la base.";
#endif
	
}
