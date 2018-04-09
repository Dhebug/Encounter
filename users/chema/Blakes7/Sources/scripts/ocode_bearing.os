/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

/* Object command script and strings */

stringpack BEARING{
#ifdef ENGLISH	
	/***************************************/
	"A small steel ball.";
	"Probably loose from a bearing.";
	"I can't use the ball in that way.";
#endif
#ifdef FRENCH	
	/***************************************/
	"Une petite bille d'acier.";
	"Probablement d'un roulement a billes.";
	"Je ne peux l'utiliser de cette facon.";
#endif
#ifdef SPANISH
	/***************************************/
	"Una pequeña bola de acero.";
	"Probablemente de un rodamiento.";
	"No puedo usarla de ese modo.";
#endif
	
}

objectcode BEARING
{
	LookAt:
		scCursorOn(false);
		scActorTalk(BLAKE,BEARING,0);
		scWaitForActor(BLAKE);
		scActorTalk(BLAKE,BEARING,1);
		scWaitForActor(BLAKE);
		scCursorOn(true);
		scStopScript();
	Use:
		if(sfGetActionObject1()==CATPULT)
			scRunObjectCode(VERB_USE,BEARING,CATPULT);
		else{
			scActorTalk(BLAKE,BEARING,2);
			scWaitForActor(BLAKE);			
		}
}



