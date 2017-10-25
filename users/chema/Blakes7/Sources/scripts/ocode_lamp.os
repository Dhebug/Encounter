/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"

/* Object command script and strings */

stringpack LAMP{
#ifdef ENGLISH	
	"It is a quite primitive oil lamp.";
	"I don't know what you want to do.";
#endif
#ifdef SPANISH
	"Una primitiva lámpara de aceite.";
	"No entiendo qué quieres hacer.";
#endif	
}

objectcode LAMP{
	LookAt:
		scActorTalk(BLAKE,LAMP,0);
		scStopScript();
	Use:
	PickUp:
		if(sfIsObjectInInventory(LAMP))
			scActorTalk(BLAKE,LAMP,1);
		else
			scPutInInventory(LAMP);
		
}

