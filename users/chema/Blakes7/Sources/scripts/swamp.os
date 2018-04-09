/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

#define EXIT		200
#define STONE		201
#define CAVE		202
#define SHORE		203


// String pack for descriptions in this room
#define STDESC  	200

// Entry script
script 200 
{
	if(!bLogTaken){
		scSetWalkboxAsWalkable(2,false);
		scStopScript();
	}
	if(sfIsObjectInInventory(WOODENLOG)){
		scSetWalkboxAsWalkable(2,false);
		scStopScript();
	}
	/*
	if(sfGetRoom(WOODENLOG)!=ROOM_SWAMP){
		scSetWalkboxAsWalkable(2,false);
	}
	*/
}


objectcode STONE{
	LookAt:
		scActorTalk(sfGetActorExecutingAction(),STDESC,0);
		scStopScript();
	Use:
		if(sfGetActionObject1()==WOODENLOG){
			scRemoveFromInventory(WOODENLOG);
			scLoadObjectToGame(WOODENLOG);
			scSetPosition(WOODENLOG,ROOM_SWAMP,12,9);
			scSetAnimstate(WOODENLOG,1);
			scSetWalkboxAsWalkable(2,true);
			scStopScript();
		}
		scActorTalk(sfGetActorExecutingAction(),STDESC,3);

}

objectcode CAVE{
	byte a;
	LookAt:	
		scActorTalk(sfGetActorExecutingAction(),STDESC,1);
		scStopScript();
	WalkTo:
		a=sfGetActorExecutingAction();	
		/*
		Why is this failing to get the correct offset for the IF jump?
		if(!sfIsWalkboxWalkable(2)){
			scActorTalk(a,STDESC,2);
			scStopScript();
		}*/
		/*scActorWalkTo(a,37,13);
		scWaitForActor(a);
		*/
		
		if(bDoorPuzzleDone){
			scSetPosition(a,ROOM_HIDEOUT,15,49);			
		}
		else{
			scSetPosition(a,ROOM_HIDEOUT,15,11);
		}
		scLookDirection(a,FACING_UP);		
		scChangeRoomAndStop(ROOM_HIDEOUT);		
}

objectcode EXIT{
	WalkTo:
		scSetPosition(sfGetActorExecutingAction(),ROOM_FOREST,10,36);
		scChangeRoomAndStop(ROOM_FOREST);
}

 objectcode SHORE{
 
 }

stringpack STDESC	
{
#ifdef ENGLISH
/***************************************/
"A stone protruding from the water.";
"That cave is the entrance to the base.";
"I can't reach the cave.";
"I can't do that.";

#endif

#ifdef FRENCH
/***************************************/
"Une pierre qui émerge de l'eau.";
"Cette grotte est l'entrée de la base.";
"Je ne peux pas atteindre la grotte.";
"Je ne peux pas faire cela.";
#endif

#ifdef SPANISH
/***************************************/
"Una piedra sobresaliendo del agua.";
"Esa cueva es la entrada a la base.";
"No puedo llegar a la cueva.";
"No puedo hacer eso.";
#endif
}



