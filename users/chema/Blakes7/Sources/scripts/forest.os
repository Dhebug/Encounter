/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

#define EXIT		200
#define FOREST 		201
#define LOG		202



// String pack for descriptions in this room
#define STDESC  	200

// Entry script
script 200 
{
	if(!bLogTaken){
		scLoadObjectToGame(LOG); // Load log if not taken
		scSetAnimstate(202,0);
	}
	
}


objectcode LOG{
	LookAt:
		scActorTalk(sfGetActorExecutingAction(),STDESC,0);
		scStopScript();
	PickUp:
		scCursorOn(false);
		bLogTaken=true;
		//scLoadObjectToGame(WOODENLOG);
		scPutInInventory(WOODENLOG);
		//scSetPosition(LOG,ROOM_FOREST,15,255);
		scRemoveObjectFromGame(LOG);
		scBreakHere();
		scCursorOn(true);
}

objectcode FOREST{
	LookAt:
		scActorTalk(sfGetActorExecutingAction(),STDESC,1);
		scStopScript();
	WalkTo:
		scLookDirection(sfGetActorExecutingAction(),FACING_DOWN);
		scActorTalk(sfGetActorExecutingAction(),STDESC,2);
		//scStopScript();
}

objectcode EXIT{
	WalkTo:
		scSetPosition(sfGetActorExecutingAction(),ROOM_SWAMP,12,0);
		scChangeRoomAndStop(ROOM_SWAMP);
		//scStopScript();
}



stringpack STDESC	
{
#ifdef ENGLISH
/***************************************/
"Wooden logs, from fallen trees.";  // [laurentd75]: corrected: logs don't FALL from trees, they are FROM fallen trees.
"Dark and most probably dangerous.";
"I won't enter there. I'm not mad.";

#endif

#ifdef FRENCH
/***************************************/
"Des troncs, d'arbres abattus."; // [laurentd75]: utilisé "troncs" plutot que "rondins" et "abattus" plutot que "tombés"
"Obscur, et probablement dangereux.";
"Je n'entre pas là, je ne suis pas fou!";

#endif

#ifdef SPANISH
/***************************************/
"Unos maderos de árboles caídos."; // [laurentd75]: corrected (checked with Chema)
"Oscuro y probablemente peligroso";
"No entro ahí ni loco.";
#endif
}



