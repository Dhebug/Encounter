/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"


/* Scripts for the Liberator workshop */
#define STDESC 200

stringpack STDESC{
#ifdef ENGLISH
	/***************************************/
	"An apparently normal sink.";
	"I wonder if the water is drinkable.";
	"Ahhh... refreshing...";
	"The water drains very slowly.";
	"Something must be clogging the drain.";
	"Yes... there is something here...";
	"Why would I do that?";
	"I can't unclog it with this.";
	
	//8
	"I've no idea what this is for.";
	"A bit risky, but let's do it...";
	"Better leave it alone.";
	
	//11
	"It seems some kind of repair station.";
	"Full of electronic equipment.";
	"That is beyond my abilities.";
	"Let's see what I can do...";
	"I can't use the station with this.";
	
	//16
	"I can attach this transmitter to any";
	"circuit to activate the relay remotely.";
	"The relay can be attached anywhere.";
#endif

#ifdef SPANISH
	/***************************************/
	"Parece un labavo normal.";
	"Me pregunto si el agua será potable.";
	"Ahhh... refrescante...";
	"El agua drena muy lentamente.";
	"Algo debe estar atascando el sumidero.";
	"Sí... hay algo aquí dentro...";
	"¿Por qué razón iba a hacer eso?";
	"No puedo desatascarlo con eso.";
	
	//8
	"Ni idea de para qué sirve esto.";
	"Arriesgado, pero vamos a hacerlo...";
	"Mejor deja eso como está.";
	
	//11
	"Parece una estación de reparaciones.";
	"Todo equipamiento electrónico.";
	"Eso está más allá de mis habilidades.";
	"A ver qué podemos hacer...";
	"No puedo usar la estación con eso.";
	
	//16
	/***************************************/
	"Puedo conectar el transmisior a un";
	"circuito para activar el relé remoto.";
	"Y éste puede operar cualquier sistema.";

#endif
}

/* Entry script */
script 200{
	if(sfIsObjectInInventory(YPIPE) || sfIsObjectInInventory(CATPULT) ){
		scLoadObjectToGame(250);
	}
}

/* Pipe */
objectcode 202{
	LookAt:
		scActorTalk(sfGetActorExecutingAction(),STDESC,8);
		scWaitForActor(sfGetActorExecutingAction());
		scStopScript();
	Use:
	
		if( (!sfIsObjectInInventory(YPIPE)) && (!bBallDefeated) && (sfGetActionObject1()==WRENCH) ){
			scActorTalk(BLAKE,STDESC,9);
			scWaitForActor(BLAKE);
			scPutInInventory(YPIPE);
			scLoadObjectToGame(250);
			scSave();
		}
		else{
			scActorTalk(sfGetActorExecutingAction(),STDESC,10);
			scWaitForActor(sfGetActorExecutingAction());			
		}
		
}

/*Sink */
objectcode 200 {
	byte a;	
	Open:
	Use:
		a=sfGetActorExecutingAction();
		if ((sfGetActionObject1()==PLIERS) && bCloggingSeen && !bDrainUnclogged){
			scActorTalk(a,STDESC,5);
			scWaitForActor(a);
			scPutInInventory(BEARING);
			bDrainUnclogged=true;
			scSave();
			scStopScript();
		}
		if (sfGetActionObject1()!=200){
			// Trying to use another object with the sink
			if (bCloggingSeen && !bDrainUnclogged)
				scActorTalk(a,STDESC,7);
			else
				scActorTalk(a,STDESC,6);
			scWaitForActor(a);
			scStopScript();
		}
		scActorTalk(a,STDESC,2);
		scWaitForActor(a);
		bSinkUsed=true;
		scSave();
		scStopScript();
	LookAt:
		a=sfGetActorExecutingAction();
		scCursorOn(false);
		if(bSinkUsed && !bDrainUnclogged){
			scActorTalk(a,STDESC,3);
			scWaitForActor(a);
			scActorTalk(a,STDESC,4);
			bCloggingSeen=true;
		}
		else{
			scActorTalk(a,STDESC,0);
			scWaitForActor(a);
			scActorTalk(a,STDESC,1);
		}
		scWaitForActor(a);			
		scCursorOn(true);
		scStopScript();
}


/* Door */
objectcode 201{
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}	
	WalkTo:
		scSetPosition(sfGetActorExecutingAction(),ROOM_LIBPASS,15,0);
		scLookDirection(sfGetActorExecutingAction(),FACING_RIGHT);
		scChangeRoomAndStop(ROOM_LIBPASS);
}

/* Repair station */
objectcode 203{
	byte a;
	LookAt:
		a=sfGetActorExecutingAction();
		scCursorOn(false);
		scActorTalk(a,STDESC,11);
		scWaitForActor(a);	
		scActorTalk(a,STDESC,12);
		scWaitForActor(a);			
		scCursorOn(true);
		scStopScript();
		
	Use:
		a=sfGetActorExecutingAction();
		if(a==BLAKE){
			scActorTalk(BLAKE,STDESC,13);
			scWaitForActor(BLAKE);
			scStopScript();
		}
		if (sfGetActionObject1()==DRONE){
			scCursorOn(false);
			scActorTalk(AVON,STDESC,14);
			scWaitForActor(AVON);
			scDelay(40);
			scRemoveFromInventory(DRONE);
			scPutInInventory(TRANSMITTER);
			scPutInInventory(WSWITCH);
			scWaitForTune();
			scPlaySFX(SFX_SUCCESS);
			scWaitForTune();
			scLookDirection(AVON,FACING_DOWN);
			scActorTalk(AVON,STDESC,16);
			scWaitForActor(AVON);	
			scActorTalk(AVON,STDESC,17);
			scWaitForActor(AVON);
			scActorTalk(AVON,STDESC,18);
			scWaitForActor(AVON);			
			scCursorOn(true);
			scSave();
			scStopScript();
		}
		scActorTalk(AVON,STDESC,15);
		scWaitForActor(AVON);
}