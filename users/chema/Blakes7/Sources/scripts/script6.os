/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"

/* Script to teleport a character (disappear) */
/* Need to make the SFX sound outside (to prevent it sounding several times) */
/* Usage if called for several objects is using event 2 
   to make sure the params are collected 
        tmpParam1=....
	scClearEvents(2);
	scSpawnScript(6);
	scWaitEvent(2);	
*/
script 6 {
	byte actor;
	byte cosid;
	byte cosno;
	
	actor=tmpParam1;
	scBreakHere();
	scSetEvents(2);
	
	cosid=sfGetCostumeID(actor);
	cosno=sfGetCostumeNo(actor);
	
	scLookDirection(actor,FACING_RIGHT);
	//scPlaySFX(SFX_TELEPORT);
	scDelay(10);
	//scClearEvents(1);
	scWaitEvent(1);
	scSetCostume(actor,14,0);
	scSetAnimstate(actor,8);
	scDelay(40);
	scSetAnimstate(actor,9);
	scDelay(5);
	scSetAnimstate(actor,10);
	scDelay(5);
	scSetAnimstate(actor,11);
	scDelay(5);
	scSetPosition(actor,0,10,10);
	scSetCostume(actor,cosid,cosno);
	scWaitForTune();
}

