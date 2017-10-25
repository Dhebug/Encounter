/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"

/* Object command script and strings */

objectcode DECAF
{
	LookAt:
		scCursorOn(false);
		scActorTalk(BLAKE,DECAF,0);
		scWaitForActor(BLAKE);		
		scActorTalk(BLAKE,DECAF,1);
		scWaitForActor(BLAKE);	
		//scActorTalk(BLAKE,DECAF,2);
		//scWaitForActor(BLAKE);				
		scCursorOn(true);
		scStopScript();
	Use:
		scActorTalk(BLAKE,DECAF,2);

}

stringpack DECAF
{
#ifdef ENGLISH
	"A cup of decaf coffee.";
	"Neat. These paper cups keep it hot.";
	"I don't know how to use it this way."
#endif
#ifdef SPANISH
	"Un descafeinado.";
	"Fíjate. La taza lo mantiene caliente.";
	"No sé cómo usarlo de este modo.";
#endif
}