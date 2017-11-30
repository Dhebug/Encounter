/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR en cours	*/
/****************************/

#include "globals.h"

// Scripts for the cave entry Cygnus Alpha
#define CENTRY 		200
#define ROPE 		201
#define STDESC		200

stringpack STDESC{
	/*************************************/
#ifdef ENGLISH
	"The rope to climb back up.";
	"The entry of a cave...";
	"It is too dark to see inside.";
#endif

#ifdef FRENCH
	"The rope to climb back up.";
	"L'entree de la cave...";
	"Il fait trop sombre pour voir";
#endif

#ifdef SPANISH
	"La cuerda para volver arriba.";
	"La entrada a una cueva.";
	"Está demasiado oscuro para ver.";
#endif
}

objectcode CENTRY{
	LookAt:
		scActorTalk(BLAKE,STDESC,1);
		scStopScript();
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}
	WalkTo:
		if(!sfIsObjectInInventory(LAMP)){
			scLookDirection(BLAKE,FACING_DOWN);
			scActorTalk(BLAKE,STDESC,2);			
		}
		else{
			scSetPosition(BLAKE,ROOM_CACAVE,12,50);
			scLookDirection(BLAKE,FACING_LEFT);
			if(bCrusaderCutscene)
				scChangeRoomAndStop(ROOM_CACAVE);
			else{	
				bCrusaderCutscene=true;
				scSpawnScript(9); // He is a crusader cutscene
			}
		}
}


objectcode ROPE{
	LookAt:
		scActorTalk(BLAKE,STDESC,0);
		scStopScript();	
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}	
	WalkTo:
		scSetPosition(BLAKE,ROOM_CAPIT,16,14);
		scLookDirection(BLAKE,FACING_LEFT);
		scChangeRoomAndStop(ROOM_CAPIT);
}
