
/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"

/* Intro script */
/* Local rooms 200-203 are the intro scenes 	*/
/* Local string pack 201 contains the strings 	*/
/* Local string pack 200 is in blake's room and */
/* contains the first sentence he speaks        */
/* I made this script global because else it'd  */
/* get nuked when changing rooms, so this was   */
/* easier...					*/
script 2
{
	byte line;
	byte sentence;

	scLockResource(1,3);
	scLockResource(1,4);
	scLockResource(1,5);
	scLockResource(1,6);

	
	// Disable fading effects
	scSetFadeEffect(0);
	
	// Load pic with dome city
	scLoadRoom(0);
	
	// Set the destination for ESC press
	scSetOverrideJump(here);
	
	// Prepare everything for camera pan and music
	scSetCameraAt(120);
	scBreakHere();

	scDelay(50);
	scPrint(201,1);
	scDelay(70);
	scPanCamera(0);
	scPlayTune(MAIN_TUNE);
	scPrint(201,2);
	scWaitForCamera();
	scPrint(201,3);
	scDelay(150);
	scPrint(201,0);
	
	// Load pic with camera
	scLoadRoom(201);
	scBreakHere();
	scPrintAt(201,4,42,119);
	scDelay(50);
	scDelay(50);


	// And pic with guard
	scLoadRoom(202);
	scDelay(50);
	scPrintAt(201,5,24,123-4);
	scPrintAt(201,6,42,131-4);

	
	// Wait for tune event
	scClearEvents(1);
	scWaitEvent(1);
	
	// Load Blake'7 logo 
	scLoadRoom(203);
	
	scClearEvents(1);
	scWaitEvent(1);
	scPrintAt(201,11,54,120);	//D&P
	scPrintAt(201,7,72,128);	//Ch

	scClearEvents(1);
	scWaitEvent(1);
	scPrintAt(201,12,54,120);	//Char Art
	scPrintAt(201,9,72,128);	//jojo

	scClearEvents(1);
	scWaitEvent(1);
	scPrintAt(201,13,54,120);	//Back
	scPrintAt(201,7,72,128);	//Chema
	
	scClearEvents(1);
	scWaitEvent(1);
	scPrintAt(201,14,54,120);	//AddCode
	scPrintAt(201,8,72,128);	//Dbug
	
	scClearEvents(1);
	scWaitEvent(1);
	scPrintAt(201,15,54,120);	//Music
	scPrintAt(201,10,72,128);	//D.S.
	
	scClearEvents(1);
	scWaitEvent(1);
	scPrintAt(201,16,24,112);	
	scPrintAt(201,17,24,120);	
	scPrintAt(201,18,24,128);	
	
	//and wait for tune to finish
	scWaitForTune();
	
here:
	// Make sure the music finised and prepare episode intro
	scStopTune();
	// Clear the area and show menu
	scClearRoomArea();
	scMenu();
		
	scSetOverrideJump(here2);
	scLoadRoom(ROOM_EPISODE1);
	scDelay(100);
	scClearRoomArea();
	
	// Words...
	scPrintAt(200,0,42,20);
	scDelay(50);
	scPrintAt(200,1,60,30);
	scDelay(50);
	scPrintAt(200,2,120,40);
	scDelay(50);
	scPrintAt(200,3,78,50);
	scDelay(50);
	scPrintAt(200,4,48,60);
	scDelay(50);
	scPrintAt(200,5,90,80);
	scDelay(50);

	// Faces
	scLoadRoom(200);
	scDelay(50);
	scLoadRoom(201);
	scDelay(50);
	scClearRoomArea();
	scDelay(60);
	
	// Text
	line=24;

	for(sentence=6;sentence<=16;sentence=sentence+1)
	{
		scPrintAt(200,sentence,1,line);
		line=line+8;
		scDelay(20);
	}

	scDelay(250);
	scDelay(250);
	scDelay(100);
	
	scClearEvents(1);
	scSpawnScript(3);
	scDelay(10);
	scSpawnScript(4);
	scDelay(10);
	scSpawnScript(5);
	scDelay(10);
	scSpawnScript(6);

	scWaitEvent(1);

here2:	
	scUnlockResource(RESOURCE_SCRIPT,3);
	scUnlockResource(RESOURCE_SCRIPT,4);
	scUnlockResource(RESOURCE_SCRIPT,5);
	scUnlockResource(RESOURCE_SCRIPT,6);
	scClearRoomArea();

}

script 3{
	byte i;
	for(i=16;i<128;i=i+8)
	{
		scPrintAt(201,0,0,i);
		scDelay(15);
	}
}

script 4{
	byte i;
	for(i=16;i<128;i=i+8)
	{
		scPrintAt(201,1,0,i);
		scDelay(15);
	}
	
}

script 5{
	byte i;
	for(i=16;i<128;i=i+8)
	{
		scPrintAt(201,2,0,i);
		scDelay(15);
	}
}

script 6{
	byte i;
	for(i=16;i<128;i=i+8)
	{
		scPrintAt(201,3,0,i);
		scDelay(15);
	}
	scSetEvents(1);
}

