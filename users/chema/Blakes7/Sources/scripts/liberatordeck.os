/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"

// Scripts for the liberator deck

#define EXIT 200
#define ZENA 201
#define ZENB 202
#define CHAIR1 203
#define CHAIR2 204
#define DOOR 205
#define COUCHCTRL 206

#define STDESC 201

stringpack STDESC{
#ifdef ENGLISH
	/***************************************/
	"All kind of panels and controls.";
	"It takes a very skilled pilot, not me!";
#endif

#ifdef SPANISH
	/***************************************/
	"Todo tipo de paneles y controles.";
	"Hay que ser un piloto experimentado.";

#endif
}

// Main door
objectcode EXIT{
	WalkTo:
		scSetPosition(sfGetActorExecutingAction(),ROOM_LIBPASS,11,19);
		scLookDirection(sfGetActorExecutingAction(),FACING_DOWN);
		scChangeRoomAndStop(ROOM_LIBPASS);
}

// Command chairs
objectcode CHAIR1{
	LookAt:
		scActorTalk(sfGetActorExecutingAction(),STDESC,0);
		scWaitForActor(sfGetActorExecutingAction());
		scStopScript();
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}	
		scActorTalk(sfGetActorExecutingAction(),STDESC,1);
		scWaitForActor(sfGetActorExecutingAction());
		scStopScript();
}

objectcode CHAIR2{
	LookAt:
		scActorTalk(sfGetActorExecutingAction(),STDESC,0);
		scWaitForActor(sfGetActorExecutingAction());
		scStopScript();
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}
		scActorTalk(sfGetActorExecutingAction(),STDESC,1);
		scWaitForActor(sfGetActorExecutingAction());
		scStopScript();
}

objectcode DOOR{
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}	

	WalkTo:
		tmpParam1=1; // Signal we are going to Door
		scSetPosition(sfGetActorExecutingAction(),ROOM_LIBZEN,15,34);
		scLookDirection(sfGetActorExecutingAction(),FACING_LEFT);
		scChangeRoomAndStop(ROOM_LIBZEN);
}


objectcode ZENA{
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}	

	LookAt:
	TalkTo:
	WalkTo:
		tmpParam1=2; // Signal we are going to Zen
		scSetPosition(sfGetActorExecutingAction(),ROOM_LIBZEN,15,34);
		scLookDirection(sfGetActorExecutingAction(),FACING_LEFT);
		scChangeRoomAndStop(ROOM_LIBZEN);
		
}

objectcode ZENB{

	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}
	LookAt:
	TalkTo:
	WalkTo:
		tmpParam1=2; // Signal we are going to Zen
		scSetPosition(sfGetActorExecutingAction(),ROOM_LIBZEN,15,34);
		scLookDirection(sfGetActorExecutingAction(),FACING_LEFT);
		scChangeRoomAndStop(ROOM_LIBZEN);		
}

objectcode COUCHCTRL{
	LookAt:
		scActorTalk(sfGetActorExecutingAction(),STDESC,0);
		scWaitForActor(sfGetActorExecutingAction());
		scStopScript();
}

/* Entry script */
script 200 {
	/* If the defense ball-robot has not been defeated yet, load it
	   and run its script */
	scLookDirection(ZENB,FACING_RIGHT);
	scLookDirection(ZENA,FACING_RIGHT);
	scSetAnimstate(ZENA,2);
	scSetAnimstate(ZENB,3);
	  
	if(!bBallDefeated){
		scLoadObjectToGame(250); // Projectile, local in deck
		scSetAnimstate(250,10);				
		scSetPosition(250,sfGetCurrentRoom(),15,100);
		scLoadObjectToGame(BALLROBOT);
		scSetWalkboxAsWalkable(1,false);
		scSetWalkboxAsWalkable(11,false);
		scSetWalkboxAsWalkable(8,false);
		scSpawnScript(210);
	}
	scSpawnScript(202);		
}


/* Exit script */
script 201{
	if(!bBallDefeated)
		scRemoveObjectFromGame(BALLROBOT);
}

/* Zen flickering */
script 202{
	scSetAnimstate(ZENA,2);
	scSetAnimstate(ZENB,3);
	scDelay(sfGetRandInt(20,70));
	scSetAnimstate(ZENA,4);
	scSetAnimstate(ZENB,5);	
	scDelay(sfGetRandInt(20,70));
	scRestartScript();
}

/* Zen talk */
script 203{
	byte i;
	// Stop Zen flicker
	scFreezeScript(202,true);
	for(i=0;i<4;i=i+1){
		scSetAnimstate(ZENA,0);
		scSetAnimstate(ZENB,1);
		scDelay(sfGetRandInt(30,40));
		scSetAnimstate(ZENA,2);
		scSetAnimstate(ZENB,3);	
		scDelay(sfGetRandInt(5,10));
	}
	scPrint(200,10); // Clear line
	// Restart Zen flicker
	scFreezeScript(202,false);
}



/* Script that animates ball robot */

script 210 {
	scSetAnimstate(BALLROBOT,0);
	scDelay(10);
	scSetAnimstate(BALLROBOT,1);
	scDelay(10);
	scSetAnimstate(BALLROBOT,2);
	scDelay(10);
	scSetAnimstate(BALLROBOT,3);
	scDelay(10);
	scRestartScript();
}

/*Script that makes the ball explode */
script 211 {
	byte i;
	
	scTerminateScript(210);
	scDelay(20);
	for(i=4;i<=9;i=i+1){
		scSetAnimstate(BALLROBOT,i);		
		if( (i>=6) && (i<8) ){
			scPlaySFX(SFX_EXPLOSION);
			scDelay(2);
			scPlaySFX(SFX_EXPLOSION);
			scDelay(3);
			scPlaySFX(SFX_EXPLOSION);
			scDelay(5);
		} 
		else scDelay(10);
	}
	scRemoveObjectFromGame(BALLROBOT);
	scBreakHere();
	scSetWalkboxAsWalkable(1,true);
	scSetWalkboxAsWalkable(11,true);
	scSetWalkboxAsWalkable(8,true);
	bBallDefeated=true;
	scSetAnimstate(AVON,0);
	scSetAnimstate(JENNA,0);
	
	scSpawnScript(5);
	
	//scCursorOn(true);
	//scSave();
}



stringpack 200{
#ifdef ENGLISH
	/***************************************/
	" Jenna Stannis...";
	" Kerr Avon...";
	" Roj Blake...";
	//3
	" Your mind is transparent to me...";
	" Image implanted.";
	//5
	"Mum, mum, don't leave me!";
	"Come back! mum...";
	//7
	"Brother! Be careful!, don't go...";
	"No. Listen to me! You'll DIE!";
	//9
	" --Warning: Error reading mind...";
	" ";
	//11
	"Blake! Look! What is that?";
	"A defensive system, maybe.";
	"Jenna! Avon! Resist!";
#endif
#ifdef SPANISH
	/***************************************/
	" Jenna Stannis...";
	" Kerr Avon...";
	" Roj Blake...";
	//3
	" Tu mente es transparente...";
	" Imagen implantada.";
	//5
	"¡Mamá! ¡mamá no me dejes!";
	"¡Vuelve! mamá...";
	//7
	"¡Hermano! ¡cuidado! ¡no vayas!...";
	"No. ¡Escucha! ¡VAS A MORIR!";
	//9
	" --Alerta: Error leyendo mente...";
	" ";
	//11
	"Blake, ¡mira! ¿qué es eso?";
	"Puede ser un sistema defensivo.";
	"¡Jenna! ¡Avon! ¡resistid!";
#endif		
}
