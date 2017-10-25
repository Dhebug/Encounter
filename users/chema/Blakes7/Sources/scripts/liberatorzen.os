/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"

#define ZEN 	202
#define ZEN2	203
#define STZEN 	200

#define DIALOG_SCRIPT 	220
#define DIALOG_OPTIONS 	220
#define DIALOG	200

/* Entry script */
script 200{
	if(tmpParam1==1)
		scExecuteAction(sfGetActorExecutingAction(),VERB_WALKTO,201,255);
	// else scExecuteAction(BLAKE,VERB_WALKTO,202,255);
	// Activate zen
	scSpawnScript(201);
}

// Object code Exit to deck
objectcode 200{
	WalkTo:
		scSetPosition(sfGetActorExecutingAction(),ROOM_LIBDECK,11,43);
		scLookDirection(sfGetActorExecutingAction(),FACING_RIGHT);
		scChangeRoomAndStop(ROOM_LIBDECK);
}


// Object code Back door
objectcode 201{
	WalkTo:
		scSetPosition(sfGetActorExecutingAction(),ROOM_LIBTELEPORT,10,23);
		scLookDirection(sfGetActorExecutingAction(),FACING_DOWN);
		scChangeRoomAndStop(ROOM_LIBTELEPORT);
}

/* Control panels */
objectcode 204{
	byte a;
	LookAt:
		a=sfGetEgo();
		scCursorOn(false);
		scActorTalk(a,STZEN,14);
		scWaitForActor(a);
		scActorTalk(a,STZEN,15);
		scWaitForActor(a);		
		scCursorOn(true);
		scStopScript();
	Use:
		a=sfGetEgo();
		if(a==BLAKE){
			scActorTalk(a,STZEN,16);
			scWaitForActor(a);
			scStopScript();
		}
		if(sfGetActionObject1()==TRANSMITTER){
			scCursorOn(false);
			scActorTalk(a,STZEN,17);
			scWaitForActor(a);
			scActorTalk(a,STZEN,18);
			scWaitForActor(a);
			scActorTalk(a,STZEN,19);
			scWaitForActor(a);
			scCursorOn(true);
			bTransmitterInstalled=true;
			scRemoveFromInventory(TRANSMITTER);
			scSave();
		}
		else{
			scActorTalk(a,STZEN,20);
			scWaitForActor(a);			
		}

}

objectcode ZEN{
	byte a;
	TalkTo:
		scCursorOn(false);
		scLoadDialog(DIALOG);
		if(sfGetEgo()==AVON){
			scActivateDlgOption(2,true);
		}
		scStartDialog();
		scStopScript();
	LookAt:
		a=sfGetEgo();
		scActorTalk(a,STZEN,21);
		scWaitForActor(a);
		
}

// Animate ZEN
script 201{
	byte a;
	scDelay(sfGetRandInt(20,70));
	scPlaySFX(15);
	if(sfGetAnimstate(ZEN)==0)
		a=1;
	else a=0;
	scSetAnimstate(ZEN,a);
	scSetAnimstate(ZEN2,a);
	scRestartScript();
}


// Make Zen speak. String code is passed in tmpParam1
script 202{
	byte i;
	byte a;	
	byte s;
	
	s=tmpParam1;
	//scCursorOn(false);
	scFreezeScript(201,true);
	a=sfGetAnimstate(ZEN);

	scPrint(STZEN,s);
	for (i=0;i<10;i=i+1){
		scSetAnimstate(ZEN,a+2);
		scSetAnimstate(ZEN2,a+2);
		scDelay(sfGetRandInt(5,15));
		scSetAnimstate(ZEN,a);
		scSetAnimstate(ZEN2,a);
		scDelay(5);
	}
	scPrint(STZEN,0);
	//scCursorOn(true);
	scFreezeScript(201,false);
}

stringpack STZEN{
#ifdef ENGLISH	
	/***************************************/
	" ";
	" All systems functioning normally.";
	" No ships detected within range.";
	
	//3
	" The teleport unit is independent";
	" from my functions.";
	" I can control the air conditioning.";
	
	//6
	" Sensors detect two ships appearing";
	" above the horizon.";
	" Available data classifies them as";
	" Federation pursuit ships.";
	" Confirmed.";
	" The estimated odds would be of 2.5";
	" to 3 on survival the first year.";
	" Please state course and speed.";
	
	//14
	"These controls are part of Zen's";
	"systems.";
	"How would I use them?";
	"Good idea. I can attach the transmitter";
	"to the indicator of the air";
	"conditioning system.";
	"I can't do that.";
	
	//21
	"This is Zen: The Libarator's AI.";
	
#endif
#ifdef SPANISH
	/***************************************/
	" ";
	" Los sistemas funcionan normalmente.";
	" No se detectan naves en rango.";

	//3
	" La unidad de teletransporte es";
	" independiente de mis funciones.";
	" Puedo controlar la climatización.";
	
	//6
	" Los sensores detectan dos naves";
	" apareciendo sobre el horizonte.";
	" Los datos disponibles los clasifican";
	" como naves de persecución.";
	" Confirmado.";
	" La estimación sería de 2.5 contra 3";
	" de sobrevivir durante el primer año.";
	" Indique rumbo y velocidad, por favor.";	
	
	//14
	/**************************************/
	"Estos controles son parte de los";
	"sistemas de Zen.";
	"¿Cómo voy a usarlos?";
	"Buena idea. Conectaré el transmisor";
	"al indicador del sistema de aire.";
	"acondicionado.";
	"No puedo hacer eso.";
	
	//21
	"Este es Zen: La IA del Libertador.";	
#endif
/*	
	//3-6
	" Available data indicate Cygnus Alpha";
	" does not contain advanced native";
	" life forms. Surface conditions are";
	" harsh, but compatible with human life.";
	
	//7-10
	" Available data indicate Centero";
	" contains a rich diversity of life";
	" forms. Surface conditions are";
	" perfect for human life.";
*/	
}



/* Dialog with Zen */
dialog DIALOG: script DIALOG_SCRIPT stringpack DIALOG_OPTIONS{
#ifdef ENGLISH
	option "Zen, full report on all systems." active -> systems;
	option "Zen, full sensor scan." active -> sensors;
	option "Zen, can you operate the teleport?" inactive -> teleport;
	option "That's all, Zen." active -> bye;	
#endif
#ifdef SPANISH
	option "Zen, informe de todos los sistemas." active -> systems;
	option "Zen, escaneo completo." active -> sensors;
	option "Zen, ¿puedes operar el teletransporte?" inactive -> teleport;	
	option "Eso es todo, Zen." active -> bye;
#endif
}

/* Script that controls the dialog above */
script DIALOG_SCRIPT{
export systems: 
	scActivateDlgOption(0,false);
	tmpParam1=1;
	goto common; 
export sensors: 
	scActivateDlgOption(1,false);
	tmpParam1=2;
	goto common; 
export teleport:
	scActivateDlgOption(2,false);
	scWaitForActor(sfGetActorExecutingAction());
	tmpParam1=3;
	scChainScript(202);
	tmpParam1=4;
	scChainScript(202);
	scDelay(50);
	tmpParam1=5;
	scChainScript(202);	
	scStartDialog();
	scStopScript();
common:
	scWaitForActor(sfGetActorExecutingAction());
	scChainScript(202);
	//goto end;
	scStartDialog();
	scStopScript();
export bye:
	scWaitForActor(sfGetActorExecutingAction());
end:
	/* End dialog, back to commands */
	scEndDialog();
}

