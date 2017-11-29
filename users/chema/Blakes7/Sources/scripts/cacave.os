/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR done 		*/
/****************************/

#include "globals.h"

// Scripts for the cave interior in Cygnus Alpha
#define CEXIT 		200
#define PASS 		201
#define STDESC		200

/* META: I think this is not used! */
/*
stringpack STDESC{
#ifdef ENGLISH
	"The entry of a cave...";
#endif

#ifdef FRENCH
	"L'entree de la cave...";
#endif

#ifdef SPANISH
	"La entrada a una cueva...";
#endif
}
*/

objectcode CEXIT{
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}
	WalkTo:
		scSetPosition(BLAKE,ROOM_CACAVEENTRY,8,15);
		scLookDirection(BLAKE,FACING_DOWN);
		scChangeRoomAndStop(ROOM_CACAVEENTRY);
}

objectcode PASS{
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}
	WalkTo:
		scSetPosition(BLAKE,ROOM_CABACKENTRY,12,32);
		scLookDirection(BLAKE,FACING_LEFT);
		scChangeRoomAndStop(ROOM_CABACKENTRY);	
}
