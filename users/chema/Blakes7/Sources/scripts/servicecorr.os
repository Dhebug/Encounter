
/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"

#define GRATING		200
#define EXITDOOR	201


objectcode EXITDOOR
{
	WalkTo:
		scSetPosition(BLAKE,ROOM_FOYERA,16,4);
		scChangeRoomAndStop(ROOM_FOYERA);
}

objectcode GRATING
{
	LookAt:
		scCursorOn(false);
		scActorTalk(BLAKE,200, 0);
		scWaitForActor(BLAKE);
		scLookDirection(BLAKE,FACING_DOWN);
		if (!bGratingOpen)
		{
			scActorTalk(BLAKE,200, 1);
			scWaitForActor(BLAKE);
		}
		scCursorOn(true);
		scStopScript();

	Open:
	Push:
	Pull:
	Use:		
	WalkTo:
		if(sfGetActionObject1()==GRATING && !bGratingOpen)
		{
			scDelay(10);
			scCursorOn(false);
			scLookDirection(BLAKE,FACING_DOWN);
			scActorTalk(BLAKE,200, 2);
			scWaitForActor(BLAKE);			
			scActorTalk(BLAKE,200, 1);
			scWaitForActor(BLAKE);
			scCursorOn(true);
			scStopScript();
		}
		
		if(sfGetActionObject1()==GRATING && bGratingOpen)
		{
			scSetPosition(BLAKE,ROOM_SERVEXIT,13,22);
			scChangeRoomAndStop(ROOM_SERVEXIT);
			scStopScript();
		}
		
		if(sfGetActionObject1()!=COIN)
		{
			scDelay(10);
			scLookDirection(BLAKE,FACING_DOWN);
			scActorTalk(BLAKE,200, 3);
			scWaitForActor(BLAKE);			
		}
		else
		{
			scCursorOn(false);
			scActorTalk(BLAKE,200, 4);
			scWaitForActor(BLAKE);
			scDelay(10);
			scActorTalk(BLAKE,200, 5);
			scWaitForActor(BLAKE);
			scDelay(10);
			scPlaySFX(SFX_CHUIC);
			scSetAnimstate(GRATING,1);
			scBreakHere();
			scLookDirection(BLAKE,FACING_DOWN);
			scActorTalk(BLAKE,200, 6);
			scWaitForActor(BLAKE);
			bGratingOpen=true;
			scCursorOn(true);
		}
			
	
}

#define VALVE 		202
#define SCREEN		203
#define CONTROLS 	204
#define PANEL		205
#define EXTIN		206
#define CABINET		207

objectcode EXTIN
{
	LookAt:
		scActorTalk(BLAKE,200, 7);
		scStopScript();
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}		
	PickUp:
		scActorTalk(BLAKE,200, 8);
		scStopScript();
}

objectcode CABINET{
	LookAt:
		scActorTalk(BLAKE,200, 9);
		scStopScript();
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}			
	Open:
		scActorTalk(BLAKE,200, 10);
		scStopScript();
}

objectcode PANEL{
	LookAt:
		scActorTalk(BLAKE,200, 11);
		scStopScript();	
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}			
		scCursorOn(false);
		scActorTalk(BLAKE,200, 12);
		scWaitForActor(BLAKE);
		scActorTalk(BLAKE,200, 13);
		scWaitForActor(BLAKE);
		scSpawnScript(210);
		scCursorOn(true);
		//scStopScript();
}

objectcode CONTROLS{
	LookAt:
		scActorTalk(BLAKE,200, 14);
		scStopScript();	
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}			
		scActorTalk(BLAKE,200, 15);
		//scStopScript();	
}

objectcode VALVE{
	LookAt:
		scActorTalk(BLAKE,200, 16);
		scStopScript();	
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}			
	Open:
	Close:
		scCursorOn(false);
		scActorTalk(BLAKE,200, 17);
		scWaitForActor(BLAKE);
		scSpawnScript(210);
		scCursorOn(true);
		//scStopScript();	
}

objectcode SCREEN{
	LookAt:
		scCursorOn(false);
		//scLookDirection(BLAKE,FACING_LEFT);
		scActorTalk(BLAKE,200,22+tmpParam1);
		scWaitForActor(BLAKE);
		scLookDirection(BLAKE,FACING_DOWN);
		scActorTalk(BLAKE,200,26);
		scWaitForActor(BLAKE);
		scCursorOn(true);
		//scStopScript();
}

// Script that handles actions on elements
// that produce sounds :)
script 210
{
	scDelay(50);
	tmpParam1=tmpParam1+1;
	if(tmpParam1==4) 
		tmpParam1=0;
	scPrint(200,18+tmpParam1);
	if(tmpParam1==0){
		scPlaySFX(SFX_PICK);
		scWaitForTune();
		scPlaySFX(SFX_PICK);
	}
	if(tmpParam1==1){
		scPlaySFX(SFX_PIC);
		scWaitForTune();
		scPlaySFX(SFX_PIC);
	}
	if(tmpParam1==2){
		scPlaySFX(SFX_PICK);
		scWaitForTune();
		scPlaySFX(SFX_PIC);
	}
	if(tmpParam1==3){
		scPlaySFX(SFX_PIC);
		scWaitForTune();
		scPlaySFX(SFX_PICK);
	}
		
	scDelay(50);
	scPrint(200,27);
}

script 211{
	tmpParam1=0;
}

stringpack 200 {
#ifdef ENGLISH
	/*++++++++++++++++++++++++++++++++++++++ */
	"It leads to the ventilation system.";
	"The grid is firmly screwed to the wall.";
	"I can't.";
	//3
	"It doesn't help to remove the grid.";
	"The coin fits in the slot perfectly!";
	"One more... and...";
	"Ready.";
	//7
	"It's big, red, and important.";
	"Why? There's no fire.";
	//9
	"It's the typical electrical cabinet.";
	"I can't. It's closed.";
	// 11
	"Figures, lights and buttons.";
	"I have no idea how to operate it.";
	"I'll press a random button...";
	// 14
	"This is completely unfathomable!";
	"I would not know how to.";
	//16
	"A manual valve. This one is easy!";
	"Okay, let's turn it...";
	//18
	" (Beep, beep)";
	" (Boop, boop)";
	" (Beep, boop)";
	" (Boop, beep)";
	//22
	"A bar is flashing in red and blue.";
	"A blue square is flashing.";
	"'Level of g-beamflux low', it says...";
	"'Squiringenyzer ON', it says...";
	//26
	"Whatever that means...";
	" ";
#endif

#ifdef SPANISH
	/*++++++++++++++++++++++++++++++++++++++ */
	"Conduce al sistema de ventilación.";
	"La rejilla está atornillada a la pared.";
	"No puedo.";
	//3
	"Eso no me ayuda a quitar la rejilla.";
	"Perfecta para la ranura del tornillo.";
	"Uno más... y...";
	"Listo.";
	//7
	"Es grande, rojo e importante.";
	"¿Por qué? No hay fuego.";
	//9
	"Es el típico cuadro eléctrico.";
	"No puedo, está cerrado.";
	// 11
	"Números, luces y botones.";
	"No tengo ni idea de cómo funciona.";
	"Pulsaré un botón al azar...";
	// 14
	"¡Completamente insondable!";
	"No sabría cómo hacerlo.";
	//16
	"Una válvula manual. Esta es fácil.";
	"Vamos a girarla...";
	//18
	" (Bip, bip)";
	" (Bop, bop)";
	" (Bip, bop)";
	" (Bop, bip)";
	//22
	"Una barra parpadea en azul y rojo.";
	"Parpadea un cuadrado azul.";
	"Dice: 'Nivel de g-beamflux bajo'...";
	"Dice: 'Squiringenyzer ON'...";
	//26
	"Lo que eso signifique...";
	" ";
#endif
}
