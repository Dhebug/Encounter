/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

/* Object command script and strings */

stringpack CINCH{
#ifdef ENGLISH	
	/***************************************/
	"A very resistant elastic band.";
#endif
#ifdef FRENCH	
	/***************************************/
	"Une bande élastique tres résistante.";
#endif
#ifdef SPANISH
	"Una banda elástica muy resistente.";
#endif
	
}

objectcode CINCH
{
	LookAt:
		scActorTalk(BLAKE,CINCH,0);
		scWaitForActor(BLAKE);
		scStopScript();
	Use:
		if(sfGetActionObject1()==YPIPE){
			scRunObjectCode(VERB_USE,CINCH,YPIPE);
		}
}



