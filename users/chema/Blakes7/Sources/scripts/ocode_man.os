/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"

/* Object command script and strings */

#define DIALOG_1	200
#define DIALOG_STRINGS 	201


// Temporary code for staff member
objectcode INFOMAN
{
	LookAt: 
		scActorTalk(BLAKE,DIALOG_STRINGS,0);
		scWaitForActor(BLAKE);
		scStopScript();
	TalkTo:
		if (bMapPrinted)
		{
			/* All has been done, just remember the player */
			scActorTalk(INFOMAN,DIALOG_STRINGS,22);
			scWaitForActor(INFOMAN);
			scStopScript();
		}

		if (sfGetCurrentRoom()!=ROOM_MAPROOM)
		{
			scFreezeScript(202,true);
			scLookDirection(INFOMAN,FACING_RIGHT);
		}

		scCursorOn(false);
		scActorTalk(INFOMAN,DIALOG_STRINGS,1);
		scWaitForActor(INFOMAN);
		scCursorOn(true);
		scLoadDialog(DIALOG_1);
		if(bMetRavella || bReadMapPoster)
			scActivateDlgOption(0,true);
		scStartDialog();
		scStopScript();
	Give:
		if (sfGetCurrentRoom()!=ROOM_MAPROOM)
		{
			scLookDirection(INFOMAN,FACING_RIGHT);
			scFreezeScript(202,true);
			scActorTalk(INFOMAN,DIALOG_STRINGS,18);
			scWaitForActor(INFOMAN);			
			scFreezeScript(202,false);

		}
		else
			/* run a local script taking care of this */
			scChainScript(250);
		scStopScript();	
}
