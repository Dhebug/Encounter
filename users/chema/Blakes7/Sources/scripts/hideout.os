/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

#define EXIT		200
#define CONTROLS	201
#define DOORC		202
#define CONSOLE		203
#define DOORO		204

#define LEVER1		210
#define LEVER2		211
#define LEVER3		212
#define LEVER4		213

#define EXITCON		214

#define LED1		220
#define LED2		221
#define LED3		222
#define LED4		223

#define ECELL2		224

// String pack for descriptions in this room
#define STDESC  	200

// Entry script
script 200 {
	scFollowActor(255); //Make the cam stop following the actor
	if(sfGetRoom(JENNA)==ROOM_SWAMP){
		/* Bring Jenna here too */
		scSetPosition(JENNA,ROOM_HIDEOUT,16,17);
		scLookDirection(JENNA,FACING_LEFT);
		scCursorOn(false);
		scBreakHere();
		/* And she says her lines... */
		scActorTalk(JENNA,STDESC,5);
		scWaitForActor(JENNA);
		scActorTalk(JENNA,STDESC,6);
		scWaitForActor(JENNA);	
		scActorTalk(JENNA,STDESC,12);
		scWaitForActor(JENNA);			
		scCursorOn(true);
	}
	if(bDoorPuzzleDone){
		scSetCameraAt(120);
	}
}

// Exit script
script 201{
	scFollowActor(sfGetEgo()); //Make the cam follow the Ego back
}


objectcode EXIT{
	WalkTo:
		scSetPosition(sfGetActorExecutingAction(),ROOM_SWAMP,13,37);
		scLookDirection(sfGetActorExecutingAction(),FACING_LEFT);
		scChangeRoomAndStop(ROOM_SWAMP);	
}

objectcode CONTROLS{
	LookAt:
		scActorTalk(sfGetActorExecutingAction(),STDESC,0);
	Use:
		if(sfGetActionObject1()==ECELL){
			bCellPlaced=true;
			scRemoveFromInventory(ECELL);
			scActorTalk(BLAKE,STDESC,13);
			scWaitForActor(BLAKE);
			scSave();
			scStopScript();
		} 
		if(bDoorPuzzleDone){
			scActorTalk(sfGetActorExecutingAction(),STDESC,11);
			scWaitForActor(sfGetActorExecutingAction());
		}
		else
			scLoadRoom(200);						
}


objectcode DOORC{
	LookAt:
		scActorTalk(sfGetActorExecutingAction(),STDESC,1);	
}


objectcode DOORO{
	Use:
	WalkTo:
		scSetPosition(sfGetEgo(),ROOM_TUNNEL,15,17);
		scLookDirection(sfGetEgo(),FACING_UP);
		scLoadRoom(ROOM_TUNNEL);
}


objectcode CONSOLE{
	LookAt:
		scActorTalk(sfGetActorExecutingAction(),STDESC,2);
		scStopScript();
}

// Control levers entry and exit scripts
script 210{
	
	// All 'pushed'
	scSetAnimstate(LEVER1,1);
	scSetAnimstate(LEVER2,3);
	scSetAnimstate(LEVER3,5);
	scSetAnimstate(LEVER4,7);
	
	// All leds are off
	bLed1On=false; bLed2On=false; bLed3On=false; bLed4On=false;
	
	
	if(bCellPlaced)
		scLoadObjectToGame(ECELL2);
	else{
		scCursorOn(false);
		scSpawnScript(231);
		scStopScript();
	}
		
	
	scDisableVerb(VERB_GIVE,true);
	scDisableVerb(VERB_PICKUP,true);
	scDisableVerb(VERB_USE,true);
	scDisableVerb(VERB_OPEN,true);
	scDisableVerb(VERB_LOOKAT,true);
	scDisableVerb(VERB_CLOSE,true);
	scDisableVerb(VERB_TALKTO,true);
	

	// Spawn script that detects correct combination
	scSpawnScript(230);
}


script 211{
	scDisableVerb(VERB_GIVE,false);
	scDisableVerb(VERB_PICKUP,false);
	scDisableVerb(VERB_USE,false);
	scDisableVerb(VERB_OPEN,false);
	scDisableVerb(VERB_LOOKAT,false);
	scDisableVerb(VERB_CLOSE,false);
	scDisableVerb(VERB_TALKTO,false);	
}

objectcode LEVER1{
	Push: 
		if(sfGetAnimstate(LEVER1)==0){
			scActorTalk(sfGetActorExecutingAction(),STDESC,3);
			scStopScript();
		}
		scSetAnimstate(LEVER1,0);
		scPlaySFX(SFX_BEEPLE);
		bLed1On=true;
		scLoadObjectToGame(LED1);
		scSetAnimstate(LED1,0);	
		if(bLed2On){
			scRemoveObjectFromGame(LED2);
			bLed2On=false;
		}
		scStopScript();
	Pull:	
		if(sfGetAnimstate(LEVER1)==1){
			scActorTalk(sfGetActorExecutingAction(),STDESC,4);
			scStopScript();
		}	
		scSetAnimstate(LEVER1,1);
		if(bLed1On){
			scRemoveObjectFromGame(LED1);
			bLed1On=false;
		}
}

objectcode LEVER2{
	Push: 
		if(sfGetAnimstate(LEVER2)==2){
			scActorTalk(sfGetActorExecutingAction(),STDESC,3);
			scStopScript();
		}	
		scSetAnimstate(LEVER2,2);
		scPlaySFX(SFX_BEEPLE);
		bLed2On=true;
		scLoadObjectToGame(LED2);
		scSetAnimstate(LED2,0);
		if(bLed1On){
			scRemoveObjectFromGame(LED1);
			bLed1On=false;
		}		
		scStopScript();
	Pull:	
		if(sfGetAnimstate(LEVER2)==3){
			scActorTalk(sfGetActorExecutingAction(),STDESC,4);
			scStopScript();
		}	
		scSetAnimstate(LEVER2,3);
		if(bLed2On){
			scRemoveObjectFromGame(LED2);
			bLed2On=false;
		}		
}
objectcode LEVER3{
	Push:
		if(sfGetAnimstate(LEVER3)==4){
			scActorTalk(sfGetActorExecutingAction(),STDESC,3);
			scStopScript();
		}	
		scSetAnimstate(LEVER3,4);
		scPlaySFX(SFX_BEEPLE);
		bLed3On=true;
		scLoadObjectToGame(LED3);
		scSetAnimstate(LED3,0);
		if(bLed2On){
			scRemoveObjectFromGame(LED2);
			bLed2On=false;
		}		
		scStopScript();
	Pull:	
		if(sfGetAnimstate(LEVER3)==5){
			scActorTalk(sfGetActorExecutingAction(),STDESC,4);
			scStopScript();
		}	
		scSetAnimstate(LEVER3,5);
		if(bLed3On){
			scRemoveObjectFromGame(LED3);
			bLed3On=false;
		}		
}
objectcode LEVER4{
	Push:
		if(sfGetAnimstate(LEVER4)==6){
			scActorTalk(sfGetActorExecutingAction(),STDESC,3);
			scStopScript();
		}	
		scSetAnimstate(LEVER4,6);
		scPlaySFX(SFX_BEEPLE);
		bLed4On=true;
		scLoadObjectToGame(LED4);
		scSetAnimstate(LED4,0);
		if(bLed1On){
			scRemoveObjectFromGame(LED1);
			bLed1On=false;
		}
		else{
			scLoadObjectToGame(LED1);
			scSetAnimstate(LED1,0);
			bLed1On=true;			
		}
		
		scStopScript();
	Pull:	
		if(sfGetAnimstate(LEVER4)==7){
			scActorTalk(sfGetActorExecutingAction(),STDESC,4);
			scStopScript();
		}	
		scSetAnimstate(LEVER4,7);
		if(bLed4On){
			scRemoveObjectFromGame(LED4);
			bLed4On=false;
		}
		
}

objectcode EXITCON{
	WalkTo:
		scLoadRoom(ROOM_HIDEOUT);
}


objectcode LED1{	
}

objectcode LED2{	
}
objectcode LED3{
	
}
objectcode LED4{
	
}
objectcode ECELL2{
	
}

/* Check if all leds on */
script 230{
	if( (bLed1On && bLed2On && bLed3On && bLed4On) ){
		/* Success, open the door */
		bDoorPuzzleDone=true;
		scCursorOn(false);
		scPlaySFX(SFX_SUCCESS);
		scWaitForTune();
		scSpawnScript(17);		
	}
	else{
		scDelay(20);
		scRestartScript();
	}
}

/* Script launched when there is no energy cell */
script 231{
	scBreakHere();
	scActorTalk(BLAKE,STDESC,12);
	scWaitForActor(BLAKE);
	scDelay(50);
	scCursorOn(true);
	scLoadRoom(ROOM_HIDEOUT);
}

stringpack STDESC{
#ifdef ENGLISH
/***************************************/
"A control desk with levers.";
"This door is closed.";
"These controls are not working anymore.";
"I have to pull it first.";
"I have to push it first.";

//5
"This is the entrance.";
"But the door is closed.";

//7
"Great! Good job!";
"Through these tunnels we can reach";
"a service corridor of the base.";
"Let's see if I can remember the way.";

//11
"There's no need. The door is open.";

//12
"All the systems are unpowered.";
"It worked! Systems are up.";
#endif

#ifdef FRENCH
/***************************************/
"Une table de controle avec des leviers.";
"Cette porte est fermée.";
"Ces commandes ne fonctionnent plus.";
"Je dois d'abord le tirer.";
"Je dois d'abord le pousser.";

//5
"C'est l'entrée.";
"Mais la porte est fermée.";

//7
"Super! Bien joué!";
"Par ces tunnels nous pourrons atteindre";
"le couloir de service de la base.";
"Voyons si je peux retrouver le chemin.";

//11
"Pas la peine, la porte est ouverte.";

//12
"Les systemes ne sont pas alimentés.";
"Ca marche! Les systemes sont activés.";
#endif

#ifdef SPANISH
/***************************************/
"Una mesa de control con palancas.";
"Esta puerta está cerrada.";
"Estos aparatos ya no funcionan.";
"Tengo que tirar de ella primero.";
"Tengo que empujarla primero.";

//5
"Esta es la entrada.";
"Pero la puerta está cerrada.";

//7
"¡Bien! ¡Buen trabajo!";
"A través de estos túneles se llega";
"al pasillo de servicio de la base.";
"A ver si recuerdo el camino...";

//11
"No hace falta. La puerta está abierta.";

//12
"Los sistemas no tienen energía.";
"¡Funciona! Los sistemas arrancan.";

#endif
	
}





