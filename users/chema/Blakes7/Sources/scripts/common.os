/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"

#define EXIT		200
#define AUX_CUP		201
#define COFFEEMACHINE	202
#define TERMINAL	203
#define BOOKS		204
#define BOOK		205


// String pack for descriptions in this room
#define STDESC  	200


// Entry script
script 200{
	if(!bCupTaken)
		scLoadObjectToGame(AUX_CUP);
	if(!bGuardLeftCommon){
		scLoadObjectToGame(GUARD);
		scSetPosition(GUARD,ROOM_COMMON,14,14);
		scLookDirection(GUARD,FACING_UP);
		scSpawnScript(201);
	}
}

objectcode EXIT{
	WalkTo:
		scSetPosition(sfGetActorExecutingAction(),ROOM_CORRIDOR,14,49);
		scLookDirection(sfGetActorExecutingAction(),FACING_DOWN);
		scChangeRoomAndStop(ROOM_CORRIDOR);
}


objectcode AUX_CUP{
	byte a;
	PickUp:
		scPutInInventory(CUP);	
		scRemoveObjectFromGame(AUX_CUP);
		bCupTaken=true;
		scSave();
		scStopScript();
	LookAt:		
		a=sfGetEgo();
		scActorTalk(a,STDESC,24);
		scWaitForActor(a);
	
}


objectcode TERMINAL{
	WalkTo:
	LookAt:
		scSpawnScript(203);		
		//scStopScript();	
}

objectcode COFFEEMACHINE{
	byte a;
	WalkTo:
	LookAt:
		a=sfGetEgo();
		scActorTalk(a,STDESC,0);
		scWaitForActor(a);
		scActorTalk(a,STDESC,1);
		scWaitForActor(a);
		scActorTalk(a,STDESC,2);
		scWaitForActor(a);
		scStopScript();
	Use:
		a=sfGetEgo();
		if(sfGetActionObject1()!=CUP){
			scActorTalk(a,STDESC,3);
			scWaitForActor(a);
			scStopScript();			
		}
		if(sfGetState(CUP)!=1){
			scActorTalk(a,STDESC,3);
			scWaitForActor(a);
			scStopScript();			
		}
		scActorTalk(a,STDESC,4);
		scWaitForActor(a);
		scActorWalkTo(a,20,14);
		scWaitForActor(a);
		scLookDirection(a,FACING_UP);
		scPlaySFX(SFX_PIC);
		scWaitForTune();
		scLookDirection(a,FACING_DOWN);
		scSetState(CUP,2);
		scSave();
}

objectcode BOOKS{
	byte a;
	LookAt:
		a=sfGetEgo();
		scCursorOn(false);
		scActorTalk(a,STDESC,16);
		scWaitForActor(a);
		scActorTalk(a,STDESC,17);
		scWaitForActor(a);
		scCursorOn(true);
		scStopScript();
	Use:
	PickUp:
	Open:
		scActorTalk(sfGetEgo(),STDESC,19);
}

objectcode BOOK{
	byte a;
	LookAt:
		scActorTalk(sfGetEgo(),STDESC,18);
		scStopScript();
	Open:
		a=sfGetEgo();
		scCursorOn(false);
		scActorTalk(a,STDESC,21);
		scWaitForActor(a);
		scActorTalk(a,STDESC,22);
		scWaitForActor(a);
		scDelay(100);
		scLookDirection(a,FACING_DOWN);
		scBreakHere();
		scActorTalk(a,STDESC,23);
		scWaitForActor(a);		
		scCursorOn(true);
		scStopScript();
	Use:
	PickUp:
		scActorTalk(sfGetEgo(),STDESC,20);
}


// Handle guard
script 201{
	
}

// Coffe on guard!
script 202{
	// Is it empty?	
	if(sfGetState(CUP)==0){
		scActorTalk(BLAKE,STDESC,7);
		scStopScript();
	}
	// Is it empty or filled with water???
	if(sfGetState(CUP)==1){
		scActorTalk(BLAKE,STDESC,8);
		scStopScript();
	}
	// It contains coffee!
	scCursorOn(false);
	scActorTalk(BLAKE,STDESC,9);
	scWaitForActor(BLAKE);

	scActorWalkTo(BLAKE,19,14);
	scLookDirection(BLAKE,FACING_LEFT);
	scActorTalk(BLAKE,STDESC,10);
	scWaitForActor(BLAKE);
	
	scLookDirection(GUARD,FACING_RIGHT);
	scBreakHere();
	scActorTalk(GUARD,STDESC,11);
	scWaitForActor(GUARD);
	scActorTalk(BLAKE,STDESC,12);
	scWaitForActor(BLAKE);
	scActorTalk(GUARD,STDESC,13);
	scWaitForActor(GUARD);	
	scActorTalk(GUARD,STDESC,14);
	scWaitForActor(GUARD);	
	scActorTalk(GUARD,STDESC,15);
	scWaitForActor(GUARD);
	
	// Make the guard leave ranting...
	scActorWalkTo(GUARD,14,16);
	scWaitForActor(GUARD);
	scRemoveObjectFromGame(GUARD);
	
	bGuardLeftCommon=true;
	scRemoveFromInventory(CUP);
	scCursorOn(true);
	scSave();
}

// Handle showing the computer screen picture
script 203{
	byte a;
	
	if(!bLaundryMesgSeen){
		a=sfGetEgo();
		scCursorOn(false);
		scActorTalk(a,STDESC,5);
		scWaitForActor(a);
		scPlaySFX(SFX_BEEPLE);
		scWaitForTune();
		scActorTalk(a,STDESC,6);
		scWaitForActor(a);
		bLaundryMesgSeen=true;	
	}
	scLoadRoom(200);
	scDelay(150);
	scCursorOn(true);
	scLoadRoom(ROOM_COMMON);
}

stringpack STDESC{
#ifdef ENGLISH
	/***************************************/
	"Compact full metal bean-to-cup machine";
	"with the Fed'Xpresso patented automatic";
	"cappuccino system.";
	"The water deposit is empty.";
	"Ok, I'll use the water to make coffee";
	"Mmmm... he left the session open...";
	"He's just had an incoming message...";
	"I don't know what you mean by that.";
	"And wet him? No, thank you.";
	"Okay, I'll pretend...";
	"OOPS!";
	"What the...!?";
	"I'm terribly sorry...";
	"My uniform! What a mess!";
	"And my other one is not ready yet...";
	"Unless I can clean it, you'll see...";
	//16
	"They seem all to be history books.";
	"Federation approved, of course";
	"'The outer colonies'";
	// 19
	"I don't have time to read now.";
	"I don't need that.";
	// 21
	/***************************************/
	"Nice idea! Surely there is something";
	"useful used as page separator...";
	"Ah, no. It's just an empty paper.";
	"It is just a cup!";
#endif
#ifdef SPANISH
	/***************************************/
	"De metal, compacta y superautomática";
	"con el sistema Fed'Xpresso patentado";
	"de preparación de capuccinos.";
	"El depósito de agua está vacío.";
	"Vale, usaré el agua para hacer café.";
	"Mira, se ha dejado la sesión abierta.";
	"Acaba de llegarle un mensaje...";
	"No sé qué quieres que haga.";
	"¿Y empaparlo? No, gracias.";
	//9
	"Está bien, fingiré...";
	"¡Ups!";
	"¡Qué diablos!...";
	"Lo siento mucho...";
	"¡Me has puesto perdido!";
	"Y aún no está listo mi otro uniforme.";
	"Como no sea capaz de limpiarlo...";
	//16
	"Parecen todos libros de historia.";
	"Aprobados por la Federación, claro.";
	"'Las Colonias Exteriores'";
	// 19
	"No tengo tiempo para leer.";
	"No lo necesito.";
	// 21
	/***************************************/
	"¡Buena idea! Fijo que hay algo útil";
	"usado como separador...";
	"Ah, pues no. Sólo un papel en blanco.";
	"Sólo es una taza.";
#endif
	
}


