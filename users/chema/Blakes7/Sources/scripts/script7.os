/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"

/* Script to teleport a character (appear) */
/* Need to make the SFX sound outside (to prevent it sounding several times) */
/* Usage if called for several objects is using event 2 
   to make sure the params are collected 
        tmpParam1=....
	scClearEvents(2);
	scSpawnScript(7);
	scWaitEvent(2);	
*/
script 7 {
	byte actor;
	byte row;
	byte col;
	byte cosid;
	byte cosno;
	
	actor=tmpParam1;
	row=tmpParam2;
	col=tmpParam3;
	scSetEvents(2);
	scBreakHere();

	//scPlaySFX(SFX_TELEPORT);
	scDelay(10);
	//scClearEvents(1);
	scWaitEvent(1);
	cosid=sfGetCostumeID(actor);
	cosno=sfGetCostumeNo(actor);
	scSetCostume(actor,14,0);
	scSetPosition(actor,sfGetCurrentRoom(),row, col);
	scLookDirection(actor,FACING_RIGHT);
	scSetAnimstate(actor,11);
	scDelay(5);
	scSetAnimstate(actor,10);
	scDelay(5);
	scSetAnimstate(actor,9);
	scDelay(5);
	scSetAnimstate(actor,8);
	scWaitForTune();
	scSetCostume(actor,cosid,cosno);	
	scSetAnimstate(actor,0);
}
