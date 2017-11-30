
/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR en cours	*/
/****************************/

#include "globals.h"

#define DIALOG_SCRIPT 	220
#define DIALOG_STRINGS	221
#define DIALOG_OPTIONS 	220
#define DIALOG_1	200

#define DOOR		200
#define CONSOLE		201
#define SCREEN1		203
#define SCREEN2		204

#define STDESC		200
#define STGUARD		201
#define STEXTRA		202

/* Dialog with the Technician */
dialog DIALOG_1: script DIALOG_SCRIPT stringpack DIALOG_OPTIONS{
#ifdef ENGLISH
	option "Er... not, actually." active -> enddiag;
	option "Yes... what did you order?" active -> question;
	option "No, but we could be of mutual help." active -> favour;
	option "Yes... I have your order here." active -> haveit;
	option "A coffee, wasn't it?" inactive -> coffee;
	option "A cheese sandwich, wasn't it?" inactive -> sandwich;
	option "Uh, oh, I must have forgotten it." inactive -> enddiag;
#endif

#ifdef FRENCH
	option "Er... not, actually." active -> enddiag;
	option "Yes... what did you order?" active -> question;
	option "No, but we could be of mutual help." active -> favour;
	option "Yes... I have your order here." active -> haveit;
	option "A coffee, wasn't it?" inactive -> coffee;
	option "A cheese sandwich, wasn't it?" inactive -> sandwich;
	option "Uh, oh, I must have forgotten it." inactive -> enddiag;
#endif

#ifdef SPANISH
		/***********************************/
	option "Eh... en realidad, no." active -> enddiag;
	option "Sí. ¿Cuál era el pedido?" active -> question;
	option "No, pero podríamos colaborar." active -> favour;
	option "Sí... tengo aquí su pedido." active -> haveit;
	option "Un café, ¿no?" inactive -> coffee;
	option "Un sandwich de queso, ¿no?" inactive -> sandwich;
	option "¡Vaya! Creo que me lo he olvidado." inactive -> enddiag;

#endif
}


/* Script that controls the dialog above */
script DIALOG_SCRIPT{

expell:	
	scWaitForActor(TECHCAM);
	scLookDirection(TECHCAM, FACING_RIGHT);	
	scEndDialog();
	scCursorOn(false);
	scExecuteAction(BLAKE,VERB_WALKTO,DOOR,255);
	bAutoExit=true;	
	scStopScript();

export enddiag:	
	scWaitForActor(BLAKE);
	scActorTalk(TECHCAM, DIALOG_STRINGS,0);
	goto expell;
	
export question:
	scWaitForActor(BLAKE);
	scActorTalk(TECHCAM, DIALOG_STRINGS,1);
	scWaitForActor(TECHCAM);
	scActorTalk(TECHCAM, DIALOG_STRINGS,2);
	goto expell;
	
export favour:
	scWaitForActor(BLAKE);
	scActorTalk(TECHCAM, DIALOG_STRINGS,3);
	goto expell;

export haveit:
	scWaitForActor(BLAKE);
	scActorTalk(TECHCAM, DIALOG_STRINGS,4);
	scWaitForActor(TECHCAM);
	if (sfIsObjectInInventory(DECAF))
		scActivateDlgOption(4,true);	
	if (sfIsObjectInInventory(SANDWICH))
		scActivateDlgOption(5,true);	
	scActivateDlgOption(6,true);	
	scActivateDlgOption(0,false);
	scActivateDlgOption(1,false);
	scActivateDlgOption(2,false);
	scActivateDlgOption(3,false);
	scStartDialog();
	scStopScript();

export coffee:
	scWaitForActor(BLAKE);
	scActorTalk(TECHCAM, DIALOG_STRINGS,3);
	goto expell;
	
export sandwich:
	scWaitForActor(BLAKE);
	scActorTalk(TECHCAM, DIALOG_STRINGS,6);
	scWaitForActor(TECHCAM);
	scActorTalk(TECHCAM, DIALOG_STRINGS,7);
	scWaitForActor(TECHCAM);
	if(sfGetState(SANDWICH)==1)
	{
		scActorTalk(TECHCAM, DIALOG_STRINGS,8);
		scWaitForActor(TECHCAM);
		scRemoveFromInventory(SANDWICH);
		scRemoveObjectFromGame(SANDWICH);
		bSandwichGiven=true;
	}
	scActorTalk(TECHCAM, DIALOG_STRINGS,9);
	goto expell;
}

stringpack DIALOG_STRINGS
{
#ifdef ENGLISH
"Then get outta here now!";
"Do you mean you don't know?";
"You inept, go back and find out!";
"Are you kidding? Leave now!";
"And what are you waiting for?";
"I didn't ask for coffee you moron.";

//6
"A cheese sandwich?";
"No. I didn't order that...";
"But I'll take it anyway.. I'm hungry.";
"Now, please leave this room.";
#endif

#ifdef FRENCH
"Then get outta here now!";
"Do you mean you don't know?";
"You inept, go back and find out!";
"Are you kidding? Leave now!";
"And what are you waiting for?";
"I didn't ask for coffee you moron.";

//6
"A cheese sandwich?";
"No. I didn't order that...";
"But I'll take it anyway.. I'm hungry.";
"Now, please leave this room.";
#endif

#ifdef SPANISH
"¡Pues largo de aquí!";
"¿Quieres decir que no sabes?";
"¡Inepto! ¡Ve a averiguarlo!";
"¿Estás de coña? ¡Largo de aquí!";
"¿Y a qué esperas?";
"No pedí café, idiota.";

//6
"¿Un sandwich de queso?";
"No. No pedí eso...";
"Pero me lo quedo... Tengo hambre.";
"Ahora, por favor largo de aquí.";
#endif


}


objectcode DOOR
{
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}
	WalkTo:
		scSetPosition(BLAKE,ROOM_HALLWAY,12,118);
		scChangeRoomAndStop(ROOM_HALLWAY);	
}

objectcode CONSOLE
{
	LookAt:		
		scCursorOn(false);
		scFreezeScript(202,true);
		scActorTalk(BLAKE,STDESC,0);
		scWaitForActor(BLAKE);
		scActorTalk(BLAKE,STDESC,1);
		scWaitForActor(BLAKE);
		scFreezeScript(202,false);
		scCursorOn(true);
		scStopScript();
	Use:
		if(sfGetActionObject1()!=CONSOLE)
		{
			scActorTalk(BLAKE,STEXTRA,7);
			scWaitForActor(BLAKE);		
			scStopScript();
		}
		scCursorOn(false);
		scFreezeScript(202,true);
		if(!bCamCodeSeen){
			scActorTalk(BLAKE,STDESC,2);
			scWaitForActor(BLAKE);
		}
		else
		{
			scActorTalk(BLAKE,STDESC,3);
			scWaitForActor(BLAKE);
			scPlaySFX(SFX_BEEPLE);			
			scDelay(20);
			scActorTalk(BLAKE,STDESC,4);
			scWaitForActor(BLAKE);
			bCamDeactivated=true;
			scSave();
		}
		scFreezeScript(202,false);
		scCursorOn(true);
}

stringpack STDESC 
{
#ifdef ENGLISH
	"A control console.";
	/*
	+++++++++++++++++++++++++++++++++++++++*/
	"I could deactivate a system from here.";
	
	"I need the camera code to deactivate.";
	
	"Okay. Deactivate CH-1337.";
	"Done!";
	
	//5
	"A screen showing real time data";
	"about important variables.";
	"I don't understand anything.";
		
	//8
	"A screen showing real time data";
	"about the status of city systems.";
	"I understand nothing.";
#endif

#ifdef FRENCH
	"A control console.";
	/*
	+++++++++++++++++++++++++++++++++++++++*/
	"I could deactivate a system from here.";
	
	"I need the camera code to deactivate.";
	
	"Okay. Deactivate CH-1337.";
	"Done!";
	
	//5
	"A screen showing real time data";
	"about important variables.";
	"I don't understand anything.";
		
	//8
	"A screen showing real time data";
	"about the status of city systems.";
	"I understand nothing.";
#endif

#ifdef SPANISH
	"Una consola de control.";
	/*
	+++++++++++++++++++++++++++++++++++++++*/
	"Puedo desactivar sistemas desde aquí.";
	
	"Necesito el código de la cámara.";
	
	"Vale. Desactivar CH-1337.";
	"¡Listo!";
	
	//5
	"Una pantalla con datos en tiempo real";
	"sobre variables importantes.";
	"No entiendo nada.";
		
	//8
	"Una pantalla con datos del estado de";
	"los principales sistemas de la ciudad.";
	"Me suena todo a chino.";
#endif
		
}

#define CUPCOFFEE 202

// Entry script
script 200
{
	if(!bTechcamOut)
	{
		scCursorOn(false);
		scExecuteAction(BLAKE,VERB_TALKTO,TECHCAM,255);	
	}
	
	if(bGuardInCtrlRoom)
	{
		scLoadObjectToGame(CUPCOFFEE);
		// Zzzzz
		scCursorOn(false);
		scPrint(STGUARD,0);
		scDelay(75);
		scPrint(STGUARD,1); // Clear line
		if(!bSnoringHeard)
		{
			scActorTalk(BLAKE,STGUARD,7);
			scWaitForActor(BLAKE);
			bSnoringHeard=true;
		}
		scSpawnScript(201);
		scCursorOn(true);
	}
}


stringpack STGUARD
{
#ifdef ENGLISH
	" (Zzzzzzz)";
	" ";
	
	"Uh? I nearly fall asleep!";
	"I need some coffee...";
	
	"Hey! Where are you going?";
	"You cannot be here!";
	"Sorry. I entered the wrong door.";
	
	"What is that noise?";
#endif

#ifdef FRENCH
	" (Zzzzzzz)";
	" ";
	
	"Uh? I nearly fall asleep!";
	"I need some coffee...";
	
	"Hey! Where are you going?";
	"You cannot be here!";
	"Sorry. I entered the wrong door.";
	
	"What is that noise?";
#endif

#ifdef SPANISH
	" (Zzzzzzz)";
	" ";
	
	"¿Uh? Casi me quedo dormido.";
	"Necesito un café...";
	
	"¡Eh! ¿Dónde crees que vas?";
	"¡No puedes estar aquí!";
	"Perdón. Me equivoqué de puerta.";
	
	"¿Qué es ese ruido?";
#endif
}

// Control sleeping guard
script 201
{
	scSpawnScript(202);
loop:
	if(sfGetCol(BLAKE)>13 && !bDecafReady)
	{
		// Expell script
		scChainScript(204);
	}
	scBreakHere();
	goto loop;
}
	
// Make guard snore and wake up
script 202
{
	byte nZzzs;
	
	nZzzs=0;
loop:	
	if(sfGetTalking()==255)
	{
		nZzzs=nZzzs+1;
		
		scPrint(STGUARD,0);
		scDelay(70);
		scPrint(STGUARD,1);
		
		if(nZzzs==4 && !bDecafReady)
		{
			scCursorOn(false);
			if(!sfIsNotMoving(BLAKE)){
				//stop him!
				scStopCharacterAction(BLAKE);
				//scActorWalkTo(BLAKE,sfGetCol(BLAKE),sfGetRow(BLAKE));
				//scWaitForActor(BLAKE);
			}
			scFreezeScript(201,true);
			// Make him drink coffee and expell Blake, if needed
			scChainScript(203);
			scFreezeScript(201,false);
			scCursorOn(true);
			nZzzs=0;
		}
	}
	scDelay(100);
	goto loop;
}

// Make guard drink coffee
script 203
{
	byte row;
	byte col;


	scActorTalk(GUARD,STGUARD,2);
	scWaitForActor(GUARD);
	scActorTalk(GUARD,STGUARD,3);
	scWaitForActor(GUARD);
	
	// Loop through animation
	scLookDirection(GUARD,FACING_LEFT);
	scSetAnimstate(GUARD,0);
	scDelay(10);
	row=sfGetRow(CUPCOFFEE);
	col=sfGetCol(CUPCOFFEE);
	scSetPosition(CUPCOFFEE,255,row,col);
	scSetAnimstate(GUARD,13);
	scDelay(10);
	scSetAnimstate(GUARD,14);
	scDelay(10);
	scSetAnimstate(GUARD,15);
	scDelay(10);
	scSetAnimstate(GUARD,14);
	scDelay(10);
	scSetAnimstate(GUARD,13);
	scDelay(10);
	scSetAnimstate(GUARD,0);	
	scSetPosition(CUPCOFFEE,sfGetCurrentRoom(),row,col);
	if(!bDecafReady)
		scChainScript(204); // He notices Blake!
}

// Script to expell Blake from the room
script 204
{
	scFreezeScript(202,true);
	scCursorOn(false);
	if(sfGetCol(BLAKE)>sfGetCol(GUARD))
		scLookDirection(GUARD,FACING_RIGHT);

	scActorTalk(GUARD,STGUARD,4);
	scStopCharacterAction(BLAKE);

	scWaitForActor(GUARD);
	
	if(sfGetCol(BLAKE)>sfGetCol(GUARD))
		scLookDirection(BLAKE,FACING_LEFT);

	scActorTalk(GUARD,STGUARD,5);
	scWaitForActor(GUARD);
	scActorTalk(BLAKE,STGUARD,6);
	scWaitForActor(BLAKE);
	bAutoExit=true;	
	scExecuteAction(BLAKE,VERB_WALKTO,DOOR,255);
	scWaitForActor(BLAKE);
	// Code here works... Dunno why, probably some schedule is being done or there
	// is time for running it before the objectcode thread is ran.
	scLookDirection(GUARD,FACING_RIGHT);	
}

stringpack STEXTRA{
#ifdef ENGLISH
	"A plastic cup with coffee";
	"from a coffee machine.";
	"A good dose of caffeine.";
	
	"Good idea.";
	"I will change it for mine...";
	"and let's hope for the best.";
	
	"Don't know what you want to do.";
	"I cannot use that with the console.";
	
	//8
	"Better leave it there...";
#endif

#ifdef FRENCH
	"A plastic cup with coffee";
	"from a coffee machine.";
	"A good dose of caffeine.";
	
	"Good idea.";
	"I will change it for mine...";
	"and let's hope for the best.";
	
	"Don't know what you want to do.";
	"I cannot use that with the console.";
	
	//8
	"Better leave it there...";
#endif

#ifdef SPANISH
	"Una taza de plástico con café";
	"de máquina.";
	"Una buena dosis de cafeína.";
	
	"Buena idea.";
	"Lo cambiaré por el mío...";
	"y esperemos que funcione.";
	
	"No sé qué quieres hacer.";
	"No puedo usar eso con la consola.";
	
	//8
	"Mejor lo dejo ahí...";

#endif
}

objectcode CUPCOFFEE
{
	LookAt:
		scCursorOn(false);
		scActorTalk(BLAKE,STEXTRA,0);
		scWaitForActor(BLAKE);		
		scActorTalk(BLAKE,STEXTRA,1);
		scWaitForActor(BLAKE);	
		scActorTalk(BLAKE,STEXTRA,2);
		scWaitForActor(BLAKE);				
		scCursorOn(true);
		scStopScript();
	PickUp:
		scActorTalk(BLAKE,STEXTRA,8);
		scWaitForActor(BLAKE);				
		scStopScript();
	Use:
		if(sfGetActionObject1()==DECAF)
		{
			// Player wants to exchange cups... great
			scCursorOn(false);
			scActorTalk(BLAKE,STEXTRA,3);
			scWaitForActor(BLAKE);		
			scActorTalk(BLAKE,STEXTRA,4);
			scWaitForActor(BLAKE);	
			scActorTalk(BLAKE,STEXTRA,5);
			scWaitForActor(BLAKE);
			scActorWalkTo(BLAKE,5,14);
			scWaitForActor(BLAKE);
			scLookDirection(BLAKE,FACING_UP);
			scDelay(10);
			scActorWalkTo(BLAKE,3,15);
			scWaitForActor(BLAKE);
			scLookDirection(BLAKE, FACING_RIGHT);
			scRemoveFromInventory(DECAF);
			scRemoveObjectFromGame(DECAF);
			bDecafReady=true;			
			/*bAutoExit=true;	
			scExecuteAction(BLAKE,VERB_WALKTO,DOOR,255);
			scWaitForActor(BLAKE);
			*/
			scFreezeScript(202,true);
			scChainScript(203);
			scDelay(20);
			scFreezeScript(202,false);
			scCursorOn(true);
		}
		else
		{
			scActorTalk(BLAKE,STEXTRA,6);
			scWaitForActor(BLAKE);		
		}
		scStopScript();		
}


// Object code for screens
objectcode SCREEN1{
	LookAt:
		scCursorOn(false);
		scActorTalk(BLAKE,STDESC,5);
		scWaitForActor(BLAKE);		
		scActorTalk(BLAKE,STDESC,6);
		scWaitForActor(BLAKE);	
		scActorTalk(BLAKE,STDESC,7);
		scWaitForActor(BLAKE);				
		scCursorOn(true);
}

objectcode SCREEN2{
	LookAt:
		scCursorOn(false);
		scActorTalk(BLAKE,STDESC,8);
		scWaitForActor(BLAKE);		
		scActorTalk(BLAKE,STDESC,9);
		scWaitForActor(BLAKE);	
		scActorTalk(BLAKE,STDESC,10);
		scWaitForActor(BLAKE);				
		scCursorOn(true);
}

