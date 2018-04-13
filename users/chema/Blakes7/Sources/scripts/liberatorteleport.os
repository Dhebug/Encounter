/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"


/* Scripts for the Liberator teleport room */

#define FIRSTTELEST	200

#define EXIT 		200
#define GUNS 		201
#define BRACELETBOX 	202
#define TELEPORTCTRL 	203
#define TELEPORTCABIN	204

objectcode EXIT{
	Use:
		if(sfGetActionObject2()!=255){
			//trying to use something on exit
			scActorTalk(sfGetActorExecutingAction(),FIRSTTELEST,15);
			scStopScript();
		}
		// Let it flow to WalkTo
	WalkTo:
		tmpParam1=0; // Do not reenter!
		scSetPosition(sfGetActorExecutingAction(),ROOM_LIBZEN,11,5);
		scLookDirection(sfGetActorExecutingAction(),FACING_DOWN);
		scChangeRoomAndStop(ROOM_LIBZEN);
}

objectcode GUNS{
	//Use:
	PickUp:
		if(!sfIsObjectInInventory(GUN)){
			scPutInInventory(GUN);
		}
		else{
			scActorTalk(sfGetActorExecutingAction(),FIRSTTELEST,14);
			scWaitForActor(sfGetActorExecutingAction());
		}
		if(!bGunSeen){
			scChainScript(202);
		}
		scStopScript();
	WalkTo:
	LookAt:
		scSpawnScript(202);

}

objectcode BRACELETBOX{
	WalkTo:
	LookAt:
		scSpawnScript(203);		
		scStopScript();
	//Use:
	PickUp:
		if(!sfIsObjectInInventory(BRACELET)){
			scPutInInventory(BRACELET);
		}
		else{
			scActorTalk(sfGetActorExecutingAction(),FIRSTTELEST,14);
			scWaitForActor(sfGetActorExecutingAction());
		}
		if( (!sfIsObjectInInventory(BRACELETS)) && bCygnusOrbit){
			scCursorOn(false);
			scActorTalk(sfGetActorExecutingAction(),FIRSTTELEST,13);
			scWaitForActor(sfGetActorExecutingAction());
			scPutInInventory(BRACELETS);
			scCursorOn(true);			
		}
		if(!bBraceletSeen){
			scSpawnScript(203);
		}
		
}

objectcode TELEPORTCTRL{
	Use:
		if((sfGetEgo()==AVON)&&(sfGetActionObject1()==WSWITCH)){
			// We are preparing the remote operation in final of Ep 3
			scCursorOn(false);
			scActorTalk(AVON,FIRSTTELEST,16);
			scWaitForActor(AVON);
			scRemoveFromInventory(WSWITCH);
			scDelay(20);
			scLookDirection(AVON,FACING_DOWN);
			scActorTalk(AVON,FIRSTTELEST,17);
			scWaitForActor(AVON);
			scActorTalk(AVON,FIRSTTELEST,18);
			scWaitForActor(AVON);
			bSwitchInstalled=true;
			scCursorOn(true);
			scSave();
			scStopScript();
		}
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}
	
		if(sfGetActorExecutingAction()==AVON){
			scActorTalk(AVON,FIRSTTELEST,19);
			scWaitForActor(AVON);	
		}
		else{
			scActorTalk(sfGetActorExecutingAction(),FIRSTTELEST,10);
			scWaitForActor(sfGetActorExecutingAction());
		}
		scStopScript();
	WalkTo:
	LookAt:
		scActorTalk(sfGetActorExecutingAction(),FIRSTTELEST,11);
		scWaitForActor(sfGetActorExecutingAction());	
		scStopScript();
}


objectcode TELEPORTCABIN{
	byte a;
	
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}	
	WalkTo:
		a=sfGetActorExecutingAction();
		scActorWalkTo(a,1,13);
		scWaitForActor(a);
		scLookDirection(a,FACING_RIGHT);
		scStopScript();

	LookAt:
		scActorTalk(sfGetActorExecutingAction(),FIRSTTELEST,12);
		scWaitForActor(sfGetActorExecutingAction());	
		scStopScript();
}

// Handle talking to Avon when in Cygnus Orbit (Entry script)
script 200{
	if((bCygnusOrbit) && (!bTelIntroduced)){
		scSpawnScript(201);
		bTelIntroduced=true;
	}
}

script 201{
	byte i;
	scCursorOn(false);
	scBreakHere();
	scActorWalkTo(BLAKE,21,14);
	for (i=0;i<=5;i=i+1){
		scActorTalk(AVON,FIRSTTELEST,i);
		scWaitForActor(AVON);
	}
	scCursorOn(true);
}


// Handle showing the gun picture
script 202{
		scCursorOn(false);
		scActorTalk(sfGetEgo(),FIRSTTELEST,8);
		scWaitForActor(sfGetEgo());
		scActorTalk(sfGetEgo(),FIRSTTELEST,9);
		scWaitForActor(sfGetEgo());
		bGunSeen=true;	
		scLoadRoom(200);
		scDelay(100);
		scCursorOn(true);	// Must be here, as scLoadRoom stops all the local scripts	
		scLoadRoom(ROOM_LIBTELEPORT);
}


// Handle showing the bracelet picture
script 203{
		scCursorOn(false);
		scActorTalk(sfGetEgo(),FIRSTTELEST,6);
		scWaitForActor(sfGetEgo());
		scActorTalk(sfGetEgo(),FIRSTTELEST,7);
		scWaitForActor(sfGetEgo());
		//scCursorOn(true);
		bBraceletSeen=true;	
		scLoadRoom(201);
		scDelay(100);
		scCursorOn(true);
		scLoadRoom(ROOM_LIBTELEPORT);
}

stringpack FIRSTTELEST {
#ifdef ENGLISH
	/**************************************/
	"Do you know what is all this for?"; // [laurentd75]: NOTE: WRONG TEXT COLOR (this should be spoken by Blake, but is displayed using Avon's colour)
	"I bet it is a Teleport system.";
	"You need one of those bracelets.";
	"I think I could teleport you to any";
	"given coordinates, within a range.";
	"Go to the cabin and use the bracelet.";
	
	//6
	"These bracelets seem to serve as";
	"communication devices as well. ";
	
	//8
	"It's full of strange handheld things.";
	"Some kind of weapon, it seems...";
	
	//10
	"I don't know how to operate it.";
	"A lot of lights, panels and switches.";
	
	//12
	"A strange cabin...";
	
	//13
	"I will take a few to bring up my crew.";
	"I already have mine.";
	
	//15
	"I don't understand.";
	
	// 16
	"Okay. I'll install this here...";
	"and when it receives the signal, the";
	"teleport will operate.";
	"And who will I teleport?";
	
#endif

#ifdef FRENCH
	/**************************************/
	"Sais-tu à quoi peut servir tout ça?"; // [laurentd75]: bug? (spoken by Kerr Avon, should be spoken by Blake)
	"Un système de téléportation, je pense.";
	"Tu as besoin de l'un de ces bracelets.";
	"Je pense que je pourrais te téléporter";
	"n'importe où, dans un périmètre donné.";
	"Le bracelet s'active dans la cabine.";

	//6
	"Ces bracelets semblent aussi servir";
	"de dispositifs de communication.";
	
	//8
	"C'est rempli d'appareils portatifs.";
	"On dirait des armes extra-terrestres..";
	
	//10
	"Je ne sais pas comment l'utiliser.";
	"Plein de voyants et de commandes...";
	
	//12
	"C'est une cabine à l'aspect étrange.";
	
	//13
	"J'en prends aussi pour les autres.";
	"J'ai déjà le mien.";
	
	//15
	"Je ne comprends pas.";
	
	// 16
	"Bien. Je vais installer ça ici...";
	"et quand il recevra le signal, le";
	"téléporteur s'activera.";
	"Et qui vais-je téléporter?";
	
#endif

#ifdef SPANISH
	/**************************************/
	"¿Sabes para qué sirve todo esto?";
	"Es un sistema de teletransporte.";
	"Necesitas una de esas pulseras.";
	"Creo que puedo transportarte a ";
	"cualquier punto, dentro de un rango.";
	"Entra en la cabina y usa la pulsera.";
	
	//6
	"Estas pulseras parecen servir como";
	"dispositivos de comunicación también. ";
	
	//8
	"Contiene unos chismes portátiles.";
	"Parece algún tipo de arma...";
	
	//10
	"No sé cómo hacerlo funcionar.";
	"Un montón de luces, paneles y teclas.";
	
	//12
	"Una cabina de aspecto extraño.";
	
	//13
	"Cogeré también para traer a los demás.";
	"Ya tengo la mía.";
	
	//15
	"No te entiendo.";

	// 16
	/************************************/
	"Bien. Instalaré esto aquí...";
	"y cuando reciba la señal, el";
	"teletransporte se activará.";
	"¿Y a quién voy a teleportar?";
#endif
}




