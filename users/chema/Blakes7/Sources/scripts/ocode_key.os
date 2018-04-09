/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

/* Object command script and strings */

objectcode KEY
{
	LookAt:
		scCursorOn(false);
		scActorTalk(BLAKE,KEY,0);
		scWaitForActor(BLAKE);
		scCursorOn(true);
		scStopScript();
	Use:
		scActorTalk(BLAKE,KEY,1);		
		
}

stringpack KEY
{
#ifdef ENGLISH	
	"A small key.";
	"Can't use the key here.";
#endif
#ifdef FRENCH	
	"Une petite clé.";
	"Je ne peux pas utiliser la clé ici.";
#endif
#ifdef SPANISH
	"Una llave pequeña.";
	"No puedo usar la llave aquí.";
#endif
}
