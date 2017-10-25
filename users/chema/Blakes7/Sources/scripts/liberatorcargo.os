/* Liberator Cargo bay related scripts */

#include "globals.h"


/* Scripts for the Liberator cargo bay */

// Entry script
script 200{
	if(!bDroneTaken)
		scLoadObjectToGame(DRONE);
}

script 201{
	if(!bDroneTaken)
		scRemoveObjectFromGame(DRONE);
}

objectcode 200{
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}	
	WalkTo:
		scSetPosition(sfGetActorExecutingAction(),ROOM_LIBPASS,12,34);
		scLookDirection(sfGetActorExecutingAction(),FACING_LEFT);
		scChangeRoomAndStop(ROOM_LIBPASS);
}

stringpack 200 {
#ifdef ENGLISH
	/****************************************/
	"An elastic tie down strap.";
	"It is used to hold down the cargo.";
	
	"Let me see if I can cut a piece...";
	"How do you want me to use it?";
	
	"The strap is fastened and I can't break";
 	"it with my bare hands";
	
	"A compartment with spare energy cells.";
	"Okay, I'll take one.";
	"I don't need it.";

#endif

#ifdef SPANISH
	/****************************************/
	"Una correa elástica de amarre.";
	"Se utiliza para sujetar el cargamento.";
	
	"A ver si puedo cortar un trozo...";
	"¿Cómo quieres que lo utilice?";

	"La correa está fijada y no puedo";
	"romperla con las manos.";
	
	"Hay células de energía de repuesto.";
	"Vale, cogeré una.";
	"No la necesito.";
#endif

}

// Straps
objectcode 201{
	byte a;
	LookAt:
		a=sfGetActorExecutingAction();
		scCursorOn(false);
		scActorTalk(a,200,0);
		scWaitForActor(a);
		scActorTalk(a,200,1);
		scWaitForActor(a);
		scCursorOn(true);
		scStopScript();

	PickUp:
		a=sfGetActorExecutingAction();
		scCursorOn(false);
		scActorTalk(a,200,4);
		scWaitForActor(a);
		scActorTalk(a,200,5);
		scWaitForActor(a);
		scCursorOn(true);
		scStopScript();
	Use:
		if( (sfGetActionObject1()==SCISSORS) && !bBandCut){
			scActorTalk(BLAKE,200,2);
			scWaitForActor(BLAKE);
			scPutInInventory(CINCH);
			bBandCut=true;
			scSave();
		}
		else{
			scLookDirection(sfGetActorExecutingAction(),FACING_DOWN);
			scActorTalk(sfGetActorExecutingAction(),200,3);
		}	
}

// Spare energy cell compartment
objectcode 202{
	LookAt:
		scActorTalk(sfGetActorExecutingAction(),200,6);
		scWaitForActor(sfGetActorExecutingAction());
		bEnergyCellSeen=true;
		scStopScript();

	Use:
	Open:
	PickUp:
		if(!bEnergyCellSeen){
			scActorTalk(sfGetActorExecutingAction(),200,6);
			scWaitForActor(sfGetActorExecutingAction());
			bEnergyCellSeen=true;
		}
		if(bEnergyCellTaken){
			scActorTalk(sfGetActorExecutingAction(),200,8);
			scWaitForActor(sfGetActorExecutingAction());	
		}
		else{
			scActorTalk(BLAKE,200,7);
			scWaitForActor(BLAKE);
			scPutInInventory(ECELL);
			bEnergyCellTaken=true;
			scSave();
		}
	
}