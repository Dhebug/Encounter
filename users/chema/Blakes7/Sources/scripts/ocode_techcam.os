/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"

/* Object command script and strings */

// Local dialog 
#define DIALOG_1	200

objectcode TECHCAM
{
	Use:
		// If something is being used with the
		// technician, it must be the 2nd object
		if(sfGetActionObject2()==TECHCAM)
			goto Give;
		else
		{
			scCursorOn(false);
			scActorTalk(BLAKE,TECHCAM,3);
			scWaitForActor(BLAKE);
			scCursorOn(true);
		}
		scStopScript();

	Give:
		// Is the player trying to give the sandwich?
		if (sfGetActionObject1()==SANDWICH)
			// Is the sandwich poisoned?
			if (sfGetState(SANDWICH)==1)
				goto TalkTo;
			else
			{
				scActorTalk(BLAKE,TECHCAM,5);
				scWaitForActor(BLAKE);
			}
		else
		{
			scCursorOn(false);
			scLookDirection(TECHCAM, FACING_LEFT);	
			scActorTalk(TECHCAM,TECHCAM,4);
			scWaitForActor(TECHCAM);
			scLookDirection(TECHCAM, FACING_RIGHT);	
			scCursorOn(true);
		}
		scStopScript();

	TalkTo:
		scCursorOn(false);
		scLookDirection(TECHCAM, FACING_LEFT);	
		scActorTalk(TECHCAM,TECHCAM,6);
		scWaitForActor(TECHCAM);
		scActorTalk(TECHCAM,TECHCAM,7);
		scWaitForActor(TECHCAM);		
		//scLookDirection(TECHCAM, FACING_RIGHT);	
		scCursorOn(true);	
		scLoadDialog(DIALOG_1);
		scStartDialog();
		scStopScript();
	LookAt: 
		scCursorOn(false);
		scActorTalk(BLAKE,TECHCAM,0);
		scWaitForActor(BLAKE);
		scActorTalk(BLAKE,TECHCAM,1);
		scWaitForActor(BLAKE);
		scActorTalk(BLAKE,TECHCAM,2);
		scWaitForActor(BLAKE);
		scCursorOn(true);		
		scStopScript();
}

stringpack TECHCAM
{
#ifdef ENGLISH 
	/*
	 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx */
	"Seems to be in charge of the control";
	"of the systems in this area.";
	"He could get me arrested.";
	
	"I don't see what you want to do.";
	
	"What? What would I do with that?";
	
	"How can that be of any help?";
	
	"Ah! are you from the kitchen service?";
	"I've been waiting for ages!";
#endif
#ifdef SPANISH
	/*
	 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx */
	"Parece estar al cargo de los sistemas";
	"de control de este área.";
	"Podría hacer que me arrestasen.";
	"No entiendo qué quieres hacer.";
	"¿Qué? ¿Qué iba a hacer con eso?";
	"¿Y eso para qué iba a servir?";
	"¡Ah! ¿Eres del servicio de cocina?";
	"¡Llevo esperando siglos!";
#endif

}