/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

#define DOOR1		200
#define DOOR2		201
#define DOOR3		202
#define DOOR4		203
#define EXITCELLS	204
#define EXITDOOR	205

#define SCREEN1		206
#define SCREEN2		207
#define SCREEN3		208
#define SCREEN4		209

// String pack for descriptions in this room
#define STDESC  	200

// Entry script

script 200{

	tmpParam1=SCREEN1;
	scClearEvents(1);
	scSpawnScript(201);
	scWaitEvent(1);

	tmpParam1=SCREEN2;
	scClearEvents(1);
	scSpawnScript(201);
	scWaitEvent(1);

	tmpParam1=SCREEN3;
	scClearEvents(1);
	scSpawnScript(201);
	scWaitEvent(1);

	tmpParam1=SCREEN4;
	scClearEvents(1);
	scSpawnScript(201);
}


script 201{
	byte scid;
	byte i;

	// Grab the parameter
	scid=tmpParam1;
	scSetEvents(1);

loop:	
	scDelay(sfGetRand());
	scDelay(sfGetRandInt(100,200));
	scDelay(sfGetRandInt(100,200));
	scDelay(sfGetRand());
	i=sfGetRandInt(0,4);
	
	if(i<2){
		for(i=12;i<=15;i=i+1){
			scSetAnimstate(scid,i);
			scDelay(30);
		}
	}
	else{
		if(i==2){
			for(i=1;i<=3;i=i+1){
				scSetAnimstate(scid,i);
				scDelay(60);
			}
			
		}
		else{
			scSetAnimstate(scid,10);
			scDelay(30);
			for(i=4;i<=10;i=i+1){
				scSetAnimstate(scid,i);
				scDelay(10);
			}
			scDelay(20);
			scSetAnimstate(scid,11);
		}
	}
	
	scDelay(50);
	scSetAnimstate(scid,0);
	goto loop;
}

objectcode SCREEN1{
	LookAt:
		scActorTalk(sfGetEgo(),STDESC,2);
}

objectcode SCREEN2{
	LookAt:
		scActorTalk(sfGetEgo(),STDESC,2);
}
objectcode SCREEN3{
	LookAt:
		scActorTalk(sfGetEgo(),STDESC,2);
}
objectcode SCREEN4{
	LookAt:
		scActorTalk(sfGetEgo(),STDESC,2);	
}



// Open a door
script 250
{
	byte door;
	byte i;
	door=tmpParam1;
	
	// Check the door is not already being
	// opened or closed.
	if(sfGetAnimstate(door)!=0) scStopScript();

	// Launch the time-out closing, just in case.
	scSpawnScript(252);
	scBreakHere();

	scPlaySFX(SFX_DOOR);
	
	for(i=1;i<=5;i=i+1){
		scSetAnimstate(door,i);
		scDelay(5);		
	}
}

// Close a door
script 251
{
	byte door;	
	byte i;
	door=tmpParam1;
	
	// Check the door is not already being
	// opened or closed.
	if(sfGetAnimstate(door)!=5) scStopScript();
	
	scPlaySFX(SFX_DOOR);
	
	for(i=4;i<255;i=i-1){
		scSetAnimstate(door,i);
		scDelay(5);		
	}
}

// Time-out close an open door
script 252
{
	byte door;
	door=tmpParam1;
	
	scDelay(200);
	if(sfGetAnimstate(door)!=0)
	{
		tmpParam1=door;
		scChainScript(251);
	}
}

objectcode DOOR1
{
	byte actor;
		
	LookAt: scActorTalk(sfGetActorExecutingAction(), STDESC, 0); scStopScript();
	Open:
		tmpParam1=DOOR1;
		scChainScript(250);
		scStopScript();
	Close:
		tmpParam1=DOOR1;
		scChainScript(251);
		scStopScript();	
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}
	WalkTo:
		actor=sfGetActorExecutingAction();
		if(actor==sfGetEgo())
			scCursorOn(false);
		if(sfGetAnimstate(DOOR1)==0)
			scRunObjectCode(VERB_OPEN, DOOR1, 255);
		scSetPosition(actor, ROOM_SERVICE, 16, 16);
		scLookDirection(actor, FACING_UP);
		if(actor==sfGetEgo())
		{
			scCursorOn(true);
			scChangeRoomAndStop(ROOM_SERVICE);
		}
}


objectcode DOOR2
{
	byte actor;
		
	LookAt: scActorTalk(sfGetActorExecutingAction(), STDESC, 0); scStopScript();
	Open:
		tmpParam1=DOOR2;
		scChainScript(250);
		scStopScript();
	Close:
		tmpParam1=DOOR2;
		scChainScript(251);
		scStopScript();	
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}
	WalkTo:
		actor=sfGetActorExecutingAction();
		if(actor==sfGetEgo())
			scCursorOn(false);
		if(sfGetAnimstate(DOOR2)==0)
			scRunObjectCode(VERB_OPEN, DOOR2, 255);
		scSetPosition(actor, ROOM_TOILET, 16, 16);
		scLookDirection(actor, FACING_UP);
		if(actor==sfGetEgo())
		{
			scCursorOn(true);
			scChangeRoomAndStop(ROOM_TOILET);
		}
}


objectcode DOOR3
{
	byte actor;
		
	LookAt: scActorTalk(sfGetActorExecutingAction(), STDESC, 0); scStopScript();
	Open:
		tmpParam1=DOOR3;
		scChainScript(250);
		scStopScript();
	Close:
		tmpParam1=DOOR3;
		scChainScript(251);
		scStopScript();	
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}
	WalkTo:
		actor=sfGetActorExecutingAction();
		if(actor==sfGetEgo())
			scCursorOn(false);
		if(sfGetAnimstate(DOOR3)==0)
			scRunObjectCode(VERB_OPEN, DOOR3, 255);
		scSetPosition(actor, ROOM_COMMON, 16, 16);
		scLookDirection(actor, FACING_UP);
		if(actor==sfGetEgo())
		{
			scCursorOn(true);
			scChangeRoomAndStop(ROOM_COMMON);
		}
}

objectcode DOOR4
{
	byte actor;
		
	LookAt: scActorTalk(sfGetActorExecutingAction(), STDESC, 0); scStopScript();
	Open:
		tmpParam1=DOOR4;
		scChainScript(250);
		scStopScript();
	Close:
		tmpParam1=DOOR4;
		scChainScript(251);
		scStopScript();	
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}
	WalkTo:
		actor=sfGetActorExecutingAction();
		if(actor==sfGetEgo())
			scCursorOn(false);
		if(sfGetAnimstate(DOOR4)==0)
			scRunObjectCode(VERB_OPEN, DOOR4, 255);
		//scActorWalkTo(actor,21,14);
		//scWaitForActor(actor);
		scSetPosition(actor, ROOM_LAUNDRY, 16, 16);
		scLookDirection(actor, FACING_UP);
		if(actor==sfGetEgo())
		{
			scCursorOn(true);
			scChangeRoomAndStop(ROOM_LAUNDRY);
		}
}


objectcode EXITDOOR{
	byte actor;
	WalkTo:
	Open:
		scActorTalk(sfGetEgo(), STDESC,1);
}


objectcode EXITCELLS{
	byte actor;
	WalkTo:
		actor=sfGetEgo();
		scSetPosition(actor, ROOM_CELLCORRIDOR, 14, 0);
		scLookDirection(actor, FACING_RIGHT);
		scChangeRoomAndStop(ROOM_CELLCORRIDOR);		

}




stringpack STDESC{
#ifdef ENGLISH
/***************************************/
"It is just an automatic door.";
"No time to go back. Just forward.";
"They appear to be running ads."
#endif

#ifdef FRENCH
/***************************************/
"C'est juste une porte automatique.";
"Ce n'est pas le moment de reculer.";
"On dirait qu'ils passent des pubs."
#endif

#ifdef SPANISH
/***************************************/
"Solo es una puerta automática.";
"No es momento de volver.";
"Parece que están echando anuncios.";
#endif
	
}


