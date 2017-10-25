/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"

#define EXIT		200
#define CLOCK		201
#define BLOCKA		202
#define BLOCKB		203
#define TERM		204

// String pack for descriptions in this room
#define STDESC  	200
#define STCOUPLETS 	201

#define DIALOG_SCRIPT 	220
#define DIALOG_STRINGS	221
#define DIALOG_OPTIONS 	220
#define DIALOG_1	200


/* Dialog with the Guard*/
dialog DIALOG_1: script DIALOG_SCRIPT stringpack DIALOG_OPTIONS{
#ifdef ENGLISH
	option "I need to visit a prisoner." active -> visit;
	option "I need to use the terminal." active -> terminal;
	option "Your shift's over. I'll replace you." active -> shift;
	option "Good watch, comrade." active -> bye;
	option "But this is an exception..." inactive -> exception;
	option "Bah, who's going to tell him?" inactive -> whotell;
	
	option "Except for maybe go to hell'." inactive -> o1;
	option "If only you could hide your face.'" inactive -> o2;
	option "This describes everything you are not.'" inactive -> o3;
	option "Damn, I'm good at telling lies!'"  inactive -> o4;
	option "That's why I always wake up screaming.'"  inactive -> o5;
	option "I have no idea... 'hocus pocus'?" inactive -> o6;
#endif

#ifdef SPANISH
		/***********************************/
	option "Necesito ver a un prisionero." active -> visit;
	option "Necesito usar el terminal." active -> terminal;
	option "Se acabó tu turno. Yo te reemplazo." active -> shift;
	option "Buena guardia, camarada." active -> bye;
	option "Pero esto es una excepción..." inactive -> exception;
	option "Bah, ¿quién se lo va a decir?" inactive -> whotell;	
	
	option "No hay quien encienda un pitillo.'" inactive -> o1;
	option "Ha subido otra peseta.'" inactive -> o2;
	option "Tienen cara de hotentote.'" inactive -> o3;
	option "Tienen cara de canguro.'" inactive -> o4;
	option "Se moja hasta mi tía.'" inactive -> o5; 
	option "Ni idea... ¿'abracadabra'?" inactive -> o6;
	
	
#endif
}


/* Script that controls the dialog above */
script DIALOG_SCRIPT{

postdlg1:	
	scWaitForActor(GUARD2);
	scActorTalk(GUARD2, DIALOG_STRINGS,2);
	scWaitForActor(GUARD2);	
	scActivateDlgOption(0,false);
	scActivateDlgOption(1,false);
	scActivateDlgOption(2,false);
	scActivateDlgOption(3,false);
	scActivateDlgOption(4,true);
	scActivateDlgOption(5,true);
	scStartDialog();
	scStopScript();	
export bye:	
	scWaitForActor(BLAKE);
	scActorTalk(GUARD2, DIALOG_STRINGS,0);
	scWaitForActor(GUARD2);
	scEndDialog();
	scStopScript();
export visit:
	scActivateDlgOption(0,false);
	scWaitForActor(BLAKE);
	scActorTalk(GUARD2, DIALOG_STRINGS,1);
	goto postdlg1;
export terminal:
	scActivateDlgOption(1,false);
	scWaitForActor(BLAKE);
	scActorTalk(GUARD2, DIALOG_STRINGS,3);
	goto postdlg1;
export shift:
	scActivateDlgOption(2,false);
	scWaitForActor(BLAKE);
	if(!bClockTampered){
		scActorTalk(GUARD2, DIALOG_STRINGS,4);	
		scWaitForActor(GUARD2);
		scActorTalk(GUARD2, DIALOG_STRINGS,5);
		scWaitForActor(GUARD2);	
		bShiftTimeFound=true;
		scStartDialog();	
		scStopScript();			
	} 
	else{
		scActorTalk(GUARD2, DIALOG_STRINGS,6);	
		scWaitForActor(GUARD2);
		scActorTalk(GUARD2, DIALOG_STRINGS,7);
		scWaitForActor(GUARD2);	
		scActivateDlgOption(0,false);
		scActivateDlgOption(1,false);
		scActivateDlgOption(2,false);
		scActivateDlgOption(3,false);
		
		
		if(bCouplet1Known) scActivateDlgOption(6,true);
		if(bCouplet2Known) scActivateDlgOption(7,true);
		if(bCouplet3Known) scActivateDlgOption(8,true);
		if(bCouplet4Known) scActivateDlgOption(9,true);		
		if(bCouplet5Known) scActivateDlgOption(10,true);				
		scActivateDlgOption(11,true);

		tmpParam1=0;		
		scChainScript(250);
		scStartDialog();
		scStopScript();

	}

wrongword:
	scWaitForActor(BLAKE);
	scActorTalk(GUARD2, DIALOG_STRINGS,10);	
	scWaitForActor(GUARD2);
	scEndDialog();
	scStopScript();	
rightword:
	scWaitForActor(BLAKE);
	if (tmpParam1<2){
		scActorTalk(GUARD2, DIALOG_STRINGS,11);	
		scWaitForActor(GUARD2);
		tmpParam1=tmpParam1+1;
		scChainScript(250);
		scStartDialog();
		scStopScript();
	}
	scActorTalk(GUARD2, DIALOG_STRINGS,12);	
	scWaitForActor(GUARD2);
	scActorWalkTo(GUARD2,0,13);
	scWaitForActor(GUARD2);
	scRemoveObjectFromGame(GUARD2);
	scPlaySFX(SFX_SUCCESS);
	bGuardLeftCells=true;
	scSetCostume(BLAKE,0,0);
	scTerminateScript(211);
	scEndDialog();
	scSave();
	scStopScript();
export o1:
	if(nWatchWord!=0) goto wrongword;
	goto rightword;
export o2:
	if(nWatchWord!=1) goto wrongword;
	goto rightword;
export o3:
	if(nWatchWord!=2) goto wrongword;
	goto rightword;	
export o4:
	if(nWatchWord!=3) goto wrongword;
	goto rightword;
export o5:
	if(nWatchWord!=4) goto wrongword;
	goto rightword;
export o6:
	goto wrongword;
	
export exception:
export whotell:	
	scWaitForActor(BLAKE);
	scActorTalk(GUARD2, DIALOG_STRINGS,8);	
	scWaitForActor(GUARD2);
	scActorTalk(GUARD2, DIALOG_STRINGS,9);
	scWaitForActor(GUARD2);	
	scActivateDlgOption(0,true);
	scActivateDlgOption(1,true);
	scActivateDlgOption(2,true);
	scActivateDlgOption(3,true);
	scActivateDlgOption(4,false);
	scActivateDlgOption(5,false);	
	scStartDialog();	
	scStopScript();
}

stringpack DIALOG_STRINGS
{
#ifdef ENGLISH
"Good day, comrade.";
"Impossible. No visits allowed.";
"Orders from the General.";
"Impossible. No one can use it.";
"You're mistaken. Look at the clock.";
"There's still an hour left.";
"Ah... great! I was quite tired.";
"But first the watchword!";
"They were very serious this time.";
"Sorry, but I can't let you.";
"No watchword, no shift change.";
"Good. Next one.";
"Perfect! Have a good shift, comrade.";
#endif

#ifdef SPANISH
"Buen día, camarada.";
"Imposible. No se permiten visitas.";
"Son órdenes del General.";
"Imposible. Nadie puede usarlo.";
"Estás equivocado. Mira el reloj.";
"Aún falta una hora.";
"Ah, bien. Ya estaba algo cansado.";
"¡Pero primero el Santo y Seña!";
"Fueron muy serios esta vez.";
"Lo siento, pero no puedo.";
"Sin Santo y Seña, no hay cambio.";
"Bien. Siguiente.";
"¡Perfecto! Buen turno camarada.";
#endif

}



stringpack STCOUPLETS{
#ifdef ENGLISH
	/***************************************/
	"'My feelings for you no words can tell";
	"'Oh loving beauty you float with grace";
	"'Kind, intelligent, loving and hot";
	"'I love your smile, face, and eyes";
	"'I see your face when I am dreaming";
#endif
#ifdef SPANISH
	/***************************************/
	"'Debajo del río amarillo";
	"'El kilo de sardineta";
	"'Esos tipos con bigote";
	"'Los tipos que fuman puro";
	"'Cuando llueve en Almería";
#endif
}

// Do the work selecting a couplet.
// if tmpParam1 is 0 it is the first time
// if it is 2 it is the last and if one is not known, it should be selected.
script 250{
	if(tmpParam1==0){
		nWatchWord=sfGetRandInt(0,4);	
		goto doit;
	} 	
	if (tmpParam1==2) {
		// Check the first one we don't know
		if (!bCouplet1Known){
			nWatchWord=0;
			goto doit;
		}
		if (!bCouplet2Known){	
			nWatchWord=1;
			goto doit;
		}
		if (!bCouplet3Known){	
			nWatchWord=2;
			goto doit;
		}
		if (!bCouplet4Known){
			nWatchWord=3;
			goto doit;
		}
		if (!bCouplet4Known){
			nWatchWord=4;
			goto doit;
		}
		// If here, we know them all, so select the next one.
	}
	
	if(nWatchWord==4) 
		nWatchWord=0;
	else 	
		nWatchWord=nWatchWord+1;

doit:	
	scActorTalk(GUARD2, STCOUPLETS,nWatchWord);
	scWaitForActor(GUARD2);			
}


// Entry script
script 200{
	if(!bClockTampered)
		scSetAnimstate(CLOCK,0);
	else
		scSetAnimstate(CLOCK,2);
	scSpawnScript(212);
	
	if(!bGuardLeftCells){
		scLoadObjectToGame(GUARD2);
		scSetPosition(GUARD2,ROOM_CELLCORRIDOR,13,22);
		scLookDirection(GUARD2,FACING_DOWN);
		if(sfGetCostumeID(BLAKE)!=3)
			scSpawnScript(210); // Script that controls the guard expelling Blake
		else
			scSpawnScript(211); // Script that controls the guard not letting us reach the terminal
	}
	scBreakHere();
	if(sfGetEgo()==AVON){
		scActorTalk(AVON,STDESC,18);
		scWaitForActor(AVON);
	}
}

// Exit script
script 201{
	// Remove guard uniform, if worn
	if(sfGetCostumeID(BLAKE)==3){
		scSetCostume(BLAKE,0,0);
		scPutInInventory(UNIFORM);
	}
	// When expelling Blake cursor was disabled. It does not harm to enable
	// it, even if it hasn't been disabled.
	scCursorOn(true);
}

stringpack STDESC{
#ifdef ENGLISH
	"Hey! Civilians cannot enter here.";
	"Leave immediately!";
	"Sorry, sir.";
	"Comrade. Nobody can enter here.";
	"Orders from the General.";
	"Okay. Sorry, comrade.";
	"Just a clock.";
	"I need to know the cell number first.";
	"Let's see if I find Ravella...";
	"Nothing. They surely use a code.";
	// 10
	/***************************************/
	" (You. You're not a guard.)";
	"What is that voice in my head?";
	" (Please, free me.)";
	"Who are you? Why are you in my mind?";
	" (Free me, and I'll help you.)";
	" (I'm in cell B-3.)";
	"Okay. Let's find out what's going on.";
	//17
	"This is not the correct block.";
	"I hear voices in block B.";
#endif
#ifdef SPANISH
	"¡Hey! Los civiles no pueden pasar.";
	"Márchese inmediatamente.";
	"Lo siento, señor.";
	"Camarada. Nadie puede entrar.";
	"Son órdenes del General.";
	"De acuerdo. Lo siento camarada.";
	"Sólo es un reloj.";
	"Necesito saber la celda primero.";
	"A ver si encuentro a Ravella...";
	"Nada. Fijo que usan algún código.";
	// 10
	/***************************************/
	" (Tú. No eres un soldado.)";
	"¿Qué es esa voz de mi cabeza?";
	" (Por favor, ven por mí.)";
	"¿Quién eres? ¿Cómo estás en mi mente?";
	" (Libérame y te ayudaré.)";
	" (Estoy en la celda B-3.)";
	"Vale. Veamos de qué va esto.";

	//17
	"Este no es el bloque correcto.";
	"Oigo voces en el bloque B.";
	
#endif
}

script 210{
	if(sfGetCol(BLAKE)<=3){
		scDelay(5);
		scRestartScript();
	}
	scCursorOn(false);
	scLookDirection(GUARD2,FACING_LEFT);
	scActorTalk(GUARD2,STDESC,0);
	scStopCharacterAction(BLAKE);
	scWaitForActor(GUARD2);
	scActorTalk(GUARD2,STDESC,1);
	scWaitForActor(GUARD2);
	scActorTalk(BLAKE,STDESC,2);
	scWaitForActor(BLAKE);
	scExecuteAction(BLAKE,VERB_WALKTO,EXIT,255);
	scWaitForActor(BLAKE);
	// Code here works... Dunno why, probably some schedule is being done or there
	// is time for running it before the objectcode thread is ran.
	scLookDirection(GUARD2,FACING_DOWN);	
}

script 211{
	if(sfGetCol(BLAKE)>27){ 
		scCursorOn(false);
		scLookDirection(GUARD2,FACING_RIGHT);
		scActorTalk(GUARD2,STDESC,3);
		scStopCharacterAction(BLAKE);
		scLookDirection(BLAKE,FACING_LEFT);
		scWaitForActor(GUARD2);
		scActorTalk(GUARD2,STDESC,4);
		scWaitForActor(GUARD2);
		scActorTalk(BLAKE,STDESC,5);
		scWaitForActor(BLAKE);
		scActorWalkTo(BLAKE,2,15);
		scWaitForActor(BLAKE);
		scLookDirection(BLAKE, FACING_RIGHT);
		// Code here works... Dunno why, probably some schedule is being done or there
		// is time for running it before the objectcode thread is ran.
		scLookDirection(GUARD2,FACING_DOWN);	
		scCursorOn(true);
	}
	scBreakHere();
	scRestartScript();
}


// Sciript that animates the clock
script 212{
	byte a;
	scDelay(50);
	a=sfGetAnimstate(CLOCK);
	if((a==0) || (a==2))
		scSetAnimstate(CLOCK,a+1);
	else
		scSetAnimstate(CLOCK,a-1);
	scRestartScript();
}

objectcode EXIT{
	byte actor;
	WalkTo:
		actor=sfGetEgo();
		scSetPosition(actor, ROOM_CORRIDOR, 14, 0);
		scLookDirection(actor, FACING_RIGHT);
		scChangeRoomAndStop(ROOM_CORRIDOR);		

}

objectcode CLOCK{
	LookAt:
		scActorTalk(sfGetEgo(),STDESC,6);
}

objectcode BLOCKA{
	byte a;
	WalkTo:
	a=sfGetEgo();
	if(!bCellFound)
		scActorTalk(a,STDESC,7);
	else
		scActorTalk(a,STDESC,17);
}

objectcode BLOCKB{
	byte actor;
	WalkTo:
		if(!bCellFound)
			scActorTalk(sfGetEgo(),STDESC,7);
		else{
			actor=sfGetEgo();
			if(actor==AVON){
				scSetPosition(actor, ROOM_CELLENTRY2, 8, 33);
				scLookDirection(actor, FACING_LEFT);
				scChangeRoomAndStop(ROOM_CELLENTRY2);			
			}
			else {
				scSetPosition(actor, ROOM_CELLENTRY, 8, 33);
				scLookDirection(actor, FACING_LEFT);
				scChangeRoomAndStop(ROOM_CELLENTRY);				
			}
				
		}
}

objectcode TERM{
	byte a;
	
	Use:
	LookAt:
		a=sfGetEgo();
		scCursorOn(false);
		scActorTalk(a,STDESC,8);
		scWaitForActor(a);
		scDelay(50);
		scLookDirection(a,FACING_DOWN);
		scActorTalk(a,STDESC,9);
		scWaitForActor(a);
		if(!bCellFound){
			scPrint(STDESC,10);
			scDelay(100);
			scActorTalk(BLAKE,STDESC,11);
			scWaitForActor(BLAKE);
			scPrint(STDESC,12);
			scDelay(100);
			scActorTalk(BLAKE,STDESC,13);
			scWaitForActor(BLAKE);
			scPrint(STDESC,14);
			scDelay(100);
			scPrint(STDESC,15);
			scDelay(100);
			bCellFound=true;
			scActorTalk(BLAKE,STDESC,16);
			scWaitForActor(BLAKE);			
		}
		scCursorOn(true);
}
