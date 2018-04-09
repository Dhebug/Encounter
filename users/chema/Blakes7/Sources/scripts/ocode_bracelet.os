/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

/* Object command script and strings */

stringpack BRACELET
{
#ifdef ENGLISH	
	/***************************************/
	"I can use it for teleporting and";
	"communication with the Liberator.";
	"Okay, put me down.";
	"Bring me up.";
	//4
	"I have to be in the teleport cabin.";
	"I can't do that with the bracelet.";
	//6
	"And who will operate the teleport?";
	"I'd better not go unarmed.";
	"Zen, turn the air conditioning off.";
	"I don't need to get back now.";
	"I can't without the transponder.";
#endif
#ifdef FRENCH	
	/***************************************/
	"On peut l'utiliser pour se téléporter";
	"et communiquer avec le Libérateur.";
	"Ok. Téléporte-moi.";
	"Ramene-moi dans le vaisseau.";  // ou bien: "Ramene-moi.", "Fais-moi revenir", "Remonte-moi dans le vaisseau";
	//4
	"Il faut que je sois dans la cabine.";
	"Je ne peux pas sans le bracelet.";
	//6
	"Et qui va actionner le téléporteur?";
	"Mieux vaudrait ne pas y aller désarmé.";
	"Zen, éteins la climatisation.";
	"Pas besoin de revenir maintenant.";
	"Je ne peux pas sans le transpondeur.";
#endif
#ifdef SPANISH
	/***************************************/
	"Se puede usar para teleportarse y para";
	"comunicaciones con El Libertador.";
	"De acuerdo. Bájame.";
	"Súbeme.";
	//4
	"Tengo que estar en la cabina.";
	"No puedo hacer eso con la pulsera.";
	// 6
	"¿Quién va a operar el teletransporte?";
	"Es mejor no ir desarmado.";
	"Zen, apaga el aire acondicionado.";
	"No necesito regresar ahora.";
	"No puedo sin el transpondedor.";
#endif
	
}

objectcode BRACELET
{
	byte room;
	byte actor;
	
	LookAt:
		actor=sfGetActorExecutingAction();
		scCursorOn(false);
		scActorTalk(actor,BRACELET,0);
		scWaitForActor(actor);
		scActorTalk(actor,BRACELET,1);
		scWaitForActor(actor);
		scCursorOn(true);
		scStopScript();
	Use:
		actor=sfGetActorExecutingAction();
		if(sfGetActionObject1()!=BRACELET){
			// Can't use anything with bracelet
			scLookDirection(actor,FACING_DOWN);
			scActorTalk(actor,BRACELET,5);
			scStopScript();
		}
		
		room=sfGetCurrentRoom();
		
		/* Now some special cases:
		 - if in Cygnus Alpha's cells, then launch the 
		 end of episode II scene.*/
		 
		if(room==ROOM_CACELLS){
			scSpawnScript(11);
			scStopScript();
		}
		
		/* Check usual working modes */
		if(room == ROOM_LIBDECK || room == ROOM_LIBPASS || room == ROOM_LIBWORKSHOP || room == ROOM_LIBZEN || room == ROOM_LIBCARGO){
			// Cannot be onboard the Liberator and not in the teleport cabin 
			scActorTalk(actor,BRACELET,4);
			scWaitForActor(actor);
			scStopScript();
		}
		if(room != ROOM_LIBTELEPORT){
			// If we are in EP3 and we are Avon... don't let the player
			// get back
			if(actor==AVON){
				// If Avon is in the Cell Entry Travis has not been
				// neutralized so don't do anything (there is a script
				// handling this), else say we don't want to.
				/*if(room!=ROOM_CELLENTRY){
					scActorTalk(actor,BRACELET,9);
					scWaitForActor(actor);
				}*/
				scActorTalk(actor,BRACELET,9);
				scWaitForActor(actor);				
				scStopScript();				
			}
			// If we are in EP3 and we don't have the transponder...
			if( (actor==BLAKE) && bCenteroOrbit && bClockTampered && (room!=ROOM_SERVICE)){
				scActorTalk(actor,BRACELET,10);
				scWaitForActor(actor);
				scStopScript();			
			}			
			// If we are in EP3 and solved the door puzzle, don't let
			// the player get back.			
			if(bCenteroOrbit && bDoorPuzzleDone){
				scActorTalk(actor,BRACELET,9);
				scWaitForActor(actor);
				scStopScript();			
			}
			
			// Get back to the Liberator
			scCursorOn(false);
			scActorTalk(actor,BRACELET,3);
			scWaitForActor(actor);

			scClearEvents(1);
			scPlaySFX(SFX_TELEPORT);
			tmpParam1=actor;
			scChainScript(6);
			
			scLoadRoom(ROOM_LIBTELEPORT);
			scBreakHere();
			scClearEvents(1);
			scPlaySFX(SFX_TELEPORT);
	
			tmpParam1=actor;
			tmpParam2=13;
			tmpParam3=1;
			scChainScript(7);
			scCursorOn(true);
			scStopScript();
		}
		// If we arrive here, we are in the teleport room
		// check if in the cabin and teleport down depending
		// on the game state. I am reusing the var room.
		room=sfGetWalkbox(actor);
		// Walkboxes whitin the cabin are 3,4,5 and 6
		if(room<3 || room>6){
			scActorTalk(actor,BRACELET,4);
			scWaitForActor(actor);
			scStopScript();
		}
		
		// Everything correct, now act depending on the 
		// game status
		
		// If it is AVON, then make sure we have tampered the system
		if(actor==AVON){
			if((!bSwitchInstalled)||(!bTransmitterInstalled)){
				scActorTalk(actor,BRACELET,6);
				scStopScript();
			}
			if(!sfIsObjectInInventory(GUN)){
				scActorTalk(actor,BRACELET,7);
				scStopScript();
			}
		}
		
		scCursorOn(false);
		if(actor!=AVON)
			scActorTalk(actor,BRACELET,2);
		else
			scActorTalk(actor,BRACELET,8);
		scWaitForActor(actor);

		scClearEvents(1);
		scPlaySFX(SFX_TELEPORT);
		tmpParam1=actor;
		scChainScript(6);
		
		if(bCygnusOrbit)
		{
			room=ROOM_CAPIT;
			tmpParam2=15;
			tmpParam3=9;
		}
		
		if(bCenteroOrbit)
		{
			if(actor!=AVON){
				room=ROOM_FOREST;
				tmpParam2=9;
				tmpParam3=17;
			} else{
				room=ROOM_SERVICE;
				tmpParam2=15;
				tmpParam3=14;		
			}
		}
		
		// Okay this is a hack to prevent the stringpack to be nuked
		// while the object code is running in memory and, thus, is not nuked. 
		scLockResource(RESOURCE_STRING,BRACELET);
		scLoadRoom(room);
		scBreakHere();
		scClearEvents(1);
		scPlaySFX(SFX_TELEPORT);
	
		tmpParam1=actor;
		scChainScript(7);
		scCursorOn(true);
		scUnlockResource(RESOURCE_STRING,BRACELET);
					
		scStopScript();

}



