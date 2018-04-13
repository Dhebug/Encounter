/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

/* Object command script and strings */

stringpack LAMP{
#ifdef ENGLISH	
	"It is a quite primitive oil lamp.";
	"I don't know what you want to do.";
#endif
#ifdef FRENCH	
	"C'est une lampe à huile primitive.";
	"Je ne saisis pas ce que vous voulez.";
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

