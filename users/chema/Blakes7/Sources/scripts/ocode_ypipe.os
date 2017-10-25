/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"

/* Object command script and strings */

stringpack YPIPE{
#ifdef ENGLISH	
	/***************************************/
	"A Y-pipe. I am not sure I should have";
	"removed it from its place.";
	"I think I got your idea... Nice!";
	"I don't know what you want to do.";
#endif
#ifdef SPANISH
	/***************************************/
	"Un tubo en Y. No sé si debería haberlo";
	"quitado de su sitio.";
	"Creo que he cogido la idea. ¡Mola!";
	"No sé qué quieres hacer.";
#endif
	
}

objectcode YPIPE
{
	LookAt:
		scCursorOn(false);
		scActorTalk(BLAKE,YPIPE,0);
		scWaitForActor(BLAKE);
		scActorTalk(BLAKE,YPIPE,1);
		scWaitForActor(BLAKE);
		scCursorOn(true);
		scStopScript();
	Use:
		scCursorOn(false);
		scLookDirection(BLAKE,FACING_DOWN);
		if(sfGetActionObject1()==CINCH){
			scActorTalk(BLAKE,YPIPE,2);
			scWaitForActor(BLAKE);
			// We create a catpult!
			scRemoveFromInventory(CINCH);
			scRemoveFromInventory(YPIPE);
			scPutInInventory(CATPULT);
			scSave();
		}
		else{
			scActorTalk(BLAKE,YPIPE,3);
			scWaitForActor(BLAKE);
		}
		scCursorOn(true);
}



