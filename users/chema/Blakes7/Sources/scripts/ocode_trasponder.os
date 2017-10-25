

/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"


/* Object command script and strings */

objectcode TRASPONDER{
	byte actor;
	LookAt:
		actor=sfGetEgo();
		scCursorOn(false);
		scActorTalk(actor,TRASPONDER,0);
		scWaitForActor(actor);
		scActorTalk(actor,TRASPONDER,1);
		scWaitForActor(actor);
		if(actor==AVON){
			scActorTalk(actor,TRASPONDER,2);
			scWaitForActor(actor);
			scActorTalk(actor,TRASPONDER,3);
			scWaitForActor(actor);			
			scActorTalk(actor,TRASPONDER,4);
			scWaitForActor(actor);			
		}
		scCursorOn(true);
		scStopScript();
	PickUp:
		actor=sfGetEgo();
		if(actor==BLAKE)
			scActorTalk(actor,TRASPONDER,5);
		else{
			scPutInInventory(TRASPONDER);
			bClockTampered=false;
		}
	
}

stringpack TRASPONDER{
#ifdef ENGLISH
/**************************************/
"The transponder needed for teleporting";
"inside this shielded complex.";

"It provides a signal for fixing the";
"teleport system and encodes the signal";
"of the nearby bracelets.";

"I need it connected there.";
#endif
#ifdef SPANISH
"El traspondedor para teleportarnos";
"desde este complejo apantallado.";

"Proporciona una señal para fijar el";
"sistema de telepore y codifica la";
"señal de los brazaletes cercanos.";

"Lo necesito conectado ahí.";
#endif
}