/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"


/* Object command script and strings */

stringpack CALLY
{
#ifdef ENGLISH
	/***************************************/
	"A fierce woman-warrior.";

#endif
#ifdef FRENCH
	/***************************************/
	"Une femme-guerriere féroce.";

#endif
#ifdef SPANISH
	"Una feroz mujer guerrera.";
#endif
}

objectcode CALLY
{
	byte a;
	LookAt:
		a=sfGetEgo();
		scActorTalk(a,CALLY,0);
		scWaitForActor(a);
		scStopScript();
}

