/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"

/* Object command script and strings */

stringpack GAN
{
#ifdef ENGLISH	
	"He looks strong as a rock.";
	"I'm ready.";
	"Just tell me what you want me to do.";
#endif
#ifdef SPANISH
	"Parece fuerte como una roca.";
	"Estoy listo.";
	"Sólo dime qué quieres que haga.";
#endif
}


objectcode GAN
{
	LookAt: 
		if(!bGanIntroduced) {
			scSpawnScript(201);
			scStopScript();
		}
		scActorTalk(BLAKE,GAN,0);
		scWaitForActor(BLAKE);
		scStopScript();
	TalkTo:
		// In case he has not been introduced...
		if(!bGanIntroduced) {
			scSpawnScript(201);
			scStopScript();
		}	
		// Dialong in the London Cell
		if(sfGetCurrentRoom()==ROOM_LONDONCELL){
			scLoadDialog(208);
			scStartDialog();
			scStopScript();
		}
		// Default responses
		scActorTalk(GAN,GAN,sfGetRandInt(1,2));
}
