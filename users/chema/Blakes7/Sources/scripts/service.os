/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

#define EXIT		200


// String pack for descriptions in this room
#define STDESC  	200


// Entry script
script 200{
/*	
	if(bClockTampered)
		scLoadObjectToGame(TRASPONDER);
	
	if(sfGetEgo()==AVON){
		bClockTampered=false;
		scPutInInventory()
	}
*/
}

objectcode EXIT{
	WalkTo:
		if((sfGetEgo()==AVON) && (!sfIsObjectInInventory(TRASPONDER)) ){
			scActorTalk(AVON,STDESC,0);
		}
		else{
			scSetPosition(sfGetActorExecutingAction(),ROOM_CORRIDOR,14,85);
			scLookDirection(sfGetActorExecutingAction(),FACING_DOWN);
			scChangeRoomAndStop(ROOM_CORRIDOR);
		}
}

stringpack STDESC{
#ifdef ENGLISH
	/**************************************/
	"I'd better get the transponder first.";
#endif
#ifdef FRENCH
	/**************************************/
	"Prenons d'abord le transpondeur.";
#endif
#ifdef SPANISH
	"Mejor cojo el transpondedor primero.";
#endif	
	
}


