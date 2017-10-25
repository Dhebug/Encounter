/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"


// Scripts for the Dome City Hallway

#define CAMERA1 	200
#define CAMERA2 	201
#define CAMERA3 	202
#define POSTER1 	203
#define POSTER2 	204
#define INFO   		205
#define ART		206
#define COFFEEMACH	254


#define EXITLEFT	220
#define EXITRIGHT	221

#define DOOR1		207	// Door to Blake's room
#define DOOR2		209	// Door to nursery
#define DOOR3		211	// Door to camera control
#define DOOR4		213	// Door to map room
#define DOOR5		215	// Door to locker

// String pack for descriptions in this room

stringpack 200
{
#ifdef ENGLISH
	"The Federation looks after us.";
	"Maps available at the info area.";
	"These Federation complexes are...";
	"well, quite complex.";
	"Amiga Wave - Your retro channel.";
	"Every sunday night at 10pm.";
	"No news at the moment.";
	"They always look weird to me.";
	"That's the door to my room.";
	"That's the door to the nursery.";	//9
	"That's the door to the control room."; //10
	"Cafe-O-matic."; //11
	"There is only decaf left...";
	"I need a coin first.";
	"I don't know what you want to do.";
	"I don't like decaf, but...";
	
	"Phew... that was close."; //16 escaping from nurse
	
	"Now it is a matter of time..."; // 17 sandwich given
	
	"Hey! Where are you going?";	// 18 guard forbids entering
	"Can't you read? You can't enter there.";
	
	//20 coffee extended puzzle
	"It doesn't accept such small coins.";
	//"My one cent coin is not enough.";
	" (Clinck!)";
	" (Clanck!)";
	" (CLINCK!)";
	" (It turns on and asks for selection)";
	"Nothing happens. What did you expect?";
	" ";
	
	//27
	"No need to run the risk again.";
	
	//28
	"This door is closed.";
	"It is on, waiting for selection.";
	"That's a door.";
	
	//31
	//"That's a door to the locker room.";
#endif

#ifdef SPANISH
	"La Federación nos cuida.";
	"Mapas disponibles en información.";
	"Los complejos de la Federación son...";
	"bueno, bastante complejos.";
	"Amiga Wave - Tu canal retro.";
	"Todos los domingos a las 10pm.";
	"No hay noticias por ahora.";
	"Siempre me pareció rara.";
	"La puerta a mi habitación.";
	"La puerta a la enfermería.";	//9
	"La puerta a la sala de control."; //10
	"Café-O-matic."; //11
	"Sólo queda descafeinado...";
	"Necesito una moneda.";
	"No sé qué quieres hacer.";
	"No me gusta el descafeinado, pero...";
	
	"Buf... por poco."; //16 escaping from nurse
	
	"Ahora es cuestión de tiempo."; // 17 sandwich given
	
	"¡Eh! ¿Dónde vas?";	// 18 guard forbids entering
	"¿No sabes leer? No se puede entrar.";
	
	//20 coffee extended puzzle
	"No acepta moneda tan pequeñas.";
	" (¡Clinck!)";
	" (¡Clanck!)";
	" (¡CLINCK!)";
	" (Se enciende y pide producto)";
	"No pasa nada. ¿Qué esperabas?";
	" ";
	
	//27
	"Mejor no arriesgarse otra vez.";
	
	//28
	"Está cerrada.";
	"Está encendida, esperando selección.";
	"Eso es una puerta.";
	
	//31
	//"That's a door to the locker room.";
#endif
}


objectcode COFFEEMACH
{
	byte tmpanimstate;
	
	LookAt:
		scActorTalk(BLAKE,200,11);
		scWaitForActor(BLAKE);
		scActorTalk(BLAKE,200,12);
		scWaitForActor(BLAKE);
		if(nPushMachine==4)
		{
			scActorTalk(BLAKE,200,29);
			scWaitForActor(BLAKE);
		}
		scStopScript();
	Use:
		if(nPushMachine==4 && sfGetActionObject1()==COFFEEMACH)
		{
			scActorTalk(BLAKE,200,15);
			scWaitForActor(BLAKE);
			scActorWalkTo(BLAKE,60,13);
			scWaitForActor(BLAKE);
			scLookDirection(BLAKE,FACING_UP);
			scWaitForActor(BLAKE);
			scDelay(10);
			scLookDirection(BLAKE,FACING_DOWN);			
			scPutInInventory(DECAF);
			nPushMachine=5;
			bCoinStuck=false;
			scSave();
			scStopScript();
		}
		if(sfGetActionObject1()!=COFFEEMACH && sfGetActionObject1()!=COIN)
		{
			scActorTalk(BLAKE,200,14);
			scWaitForActor(BLAKE);
			scStopScript();
		}
		if(sfIsObjectInInventory(COIN))
		{
			scActorTalk(BLAKE,200,20);
			//scWaitForActor(BLAKE);			
		}
		else
		{
			scActorTalk(BLAKE,200,13);
			//scWaitForActor(BLAKE);
		}
		scWaitForActor(BLAKE);
		scStopScript();
	Push:
		scCursorOn(false);
		tmpanimstate=sfGetAnimstate(BLAKE);
		scSetAnimstate(BLAKE,3);
		scDelay(10);
		scSetAnimstate(BLAKE,tmpanimstate);
		if(nPushMachine<4 && bCoinStuck)
		{
			scPrint(200,21+nPushMachine);
			if(nPushMachine==3)
				scDelay(20);	// Extra delay for the last message
			nPushMachine=nPushMachine+1;
			scDelay(50);
			scPrint(200,26);

		}
		else
		{
			scActorTalk(BLAKE,200,25);
			scWaitForActor(BLAKE);	
		}
		scCursorOn(true);
			
}




objectcode CAMERA1
{
	byte actor;
	LookAt: 
		actor=sfGetActorExecutingAction();
		scActorTalk(actor,200,0);
		scWaitForActor(actor);
		scStopScript();
}
objectcode CAMERA2
{
	byte actor;
	LookAt: 
		actor=sfGetActorExecutingAction();
		scActorTalk(actor,200,0);
		scWaitForActor(actor);
		scStopScript();
}
objectcode CAMERA3
{
	byte actor;
	LookAt: 
		actor=sfGetActorExecutingAction();
		scActorTalk(actor,200,0);
		scWaitForActor(actor);
		scStopScript();
}

objectcode POSTER1
{
	byte actor;
	LookAt: 
		actor=sfGetActorExecutingAction();
		scCursorOn(false);
		scActorTalk(actor,200,1);
		scWaitForActor(actor);
		scLookDirection(actor,FACING_DOWN);
		scActorTalk(actor,200,2);
		scWaitForActor(actor);
		scActorTalk(actor,200,3);
		scWaitForActor(actor);
		if(!bReadMapPoster)
		{
			bReadMapPoster=true;
			scSave();
		}
		scCursorOn(true);
		scStopScript();
}
objectcode POSTER2
{
	byte actor;
	
	LookAt: 
		actor=sfGetActorExecutingAction();
		scCursorOn(false);
		scActorTalk(actor,200,4);
		scWaitForActor(actor);
		scActorTalk(actor,200,5);
		scWaitForActor(actor);
		scCursorOn(true);
		scStopScript();
}

objectcode INFO
{
	byte actor;
	
	LookAt: 
		actor=sfGetActorExecutingAction();
	
		if(nMsgInfo==16)
		{
			scActorTalk(actor,200,6);
			scWaitForActor(actor);
		}
		else
		{
			scCursorOn(false);
			scFreezeAllScripts(true);
			scClearRoomArea();
			scSetOverrideJump(read);
			
			scPrintAt(210,0,6,24);
			scPrintAt(210,1,6,32);
			
			scPrintAt(210,nMsgInfo+2,6,40);
			scPrintAt(210,nMsgInfo+3,6,49);
			scPrintAt(210,nMsgInfo+4,6,58);
			scPrintAt(210,nMsgInfo+5,6,67);

			nMsgInfo=nMsgInfo+4;
			scDelay(100);
			scDelay(100);
			scDelay(100);
			scDelay(100);
			scDelay(100);
		read:	
			scRedrawScreen();
			scFreezeAllScripts(false);
			scCursorOn(true);
		}		
		scStopScript();
}
objectcode ART
{
	byte actor;
	LookAt: 
		actor=sfGetActorExecutingAction();
		scActorTalk(actor,200,7);
		scWaitForActor(actor);
		scStopScript();
}

objectcode EXITLEFT
{
	byte actor;
	WalkTo:
		actor=sfGetActorExecutingAction();
		scSetPosition(actor, ROOM_INFOAREA, 14, 45);
		scLookDirection(actor, FACING_LEFT);
		scChangeRoomAndStop(ROOM_INFOAREA);
}

objectcode EXITRIGHT
{
	byte actor;
	WalkTo:
		actor=sfGetActorExecutingAction();
		scSetPosition(actor, ROOM_FOYERA, 9, 36);
		scLookDirection(actor, FACING_RIGHT);
		scChangeRoomAndStop(ROOM_FOYERA);
}


// Entry room script
script 200
{	
	tmpParam1=CAMERA1;
	scClearEvents(1);
	scSpawnScript(201);
	//scBreakHere();
	scWaitEvent(1);
	tmpParam1=CAMERA2;
	scClearEvents(1);
	scSpawnScript(201);
	//scBreakHere();
	scWaitEvent(1);
	tmpParam1=CAMERA3;
	scClearEvents(1);
	scSpawnScript(201);
	//scBreakHere();
	scWaitEvent(1);
	
	// If escaping from nurse, say
	// buff.. that was close
	// EndDialog 
	// and reset flag
	if(bEscapeFromNurse)
	{
		bEscapeFromNurse=false;
		scActorTalk(BLAKE,200,16);
		scWaitForActor(BLAKE);
	}
		
	// If the player exited automatically
	// from another room, the cursor must be
	// restored.
	if(bAutoExit){
		bAutoExit=false;
		scCursorOn(true);
	}
	
	// If the player gave the sandwich to the technician
	// spawn script that controls the events
	if(bSandwichGiven)
	{
		scSpawnScript(203);
		bSandwichGiven=false;
		bTechcamOut=true;
	}
	else
		if(!bGuardWentForCoffee)
			scSpawnScript(202);

	// Animation of screen
	scSpawnScript(210);
}

// Script for handling cameras
script 201
{
	byte CameraID;
	byte bc;
	byte cc;
	
	// Grab the parameter
	CameraID=tmpParam1;
	scSetEvents(1);
	cc=sfGetCol(CameraID);
loop:
	scDelay(sfGetRandInt(80,110));
	bc=sfGetCol(BLAKE);
	if ( ( (bc>cc) && ((bc-cc)<20) ) || ( (bc<cc) && ( (cc-bc)<20) ) ){
		scPlaySFX(SFX_TRR);
	}
	scSetAnimstate(CameraID,1);
	scDelay(5);
	scSetAnimstate(CameraID,2);
	scDelay(5);
	scSetAnimstate(CameraID,3);
	
	scDelay(sfGetRandInt(80,110));
	if ( ( (bc>cc) && ((bc-cc)<20) ) || ( (bc<cc) && ( (cc-bc)<20) ) ){
		scPlaySFX(SFX_TRR);
	}	
	scSetAnimstate(CameraID,2);
	scDelay(5);
	scSetAnimstate(CameraID,1);
	scDelay(5);
	scSetAnimstate(CameraID,0);
	
	goto loop;
}

// Guard script
script 202
{
	scDelay(sfGetRandInt(150,250));
	scLookDirection(GUARD,FACING_DOWN);
	scDelay(sfGetRandInt(150,250));
	scLookDirection(GUARD,FACING_LEFT);	
	scDelay(sfGetRandInt(150,250));
	scLookDirection(GUARD,FACING_DOWN);	
	scDelay(sfGetRandInt(150,250));
	scLookDirection(GUARD,FACING_RIGHT);	
	scRestartScript();
}

// Control of technician leaving the room
script 203
{
	byte i;
	
	// Blake says it is a matter of time...
	scCursorOn(false);
	scActorWalkTo(BLAKE,101,15);
	scWaitForActor(BLAKE);
	scLookDirection(BLAKE,FACING_RIGHT);
	scWaitForActor(BLAKE);
	scActorTalk(BLAKE,200,17);
	scWaitForActor(BLAKE);
	
	// The technician exits
	scRunObjectCode(VERB_OPEN,DOOR3,255);
	scDelay(5);
	scSetPosition(TECHCAM,ROOM_HALLWAY,12,118);
	scActorWalkTo(TECHCAM,118,13);
	scRunObjectCode(VERB_CLOSE,DOOR3,255);
	scWaitForActor(TECHCAM);
	
	// And looks for the guard...
	scLookDirection(TECHCAM,FACING_RIGHT);
	scDelay(3);
	scLookDirection(TECHCAM,FACING_LEFT);
	scDelay(3);
	scLookDirection(TECHCAM,FACING_RIGHT);
	
	// The guard enters the room
	scSetPosition(GUARD,ROOM_HALLWAY,14,127);
	scActorWalkTo(GUARD,111,12);
	scWaitForActor(GUARD);
	scLookDirection(GUARD,FACING_RIGHT);
	
	// The technician asks the guard
	scLookDirection(TECHCAM,FACING_LEFT);
	scActorTalk(TECHCAM,201,0);
	scWaitForActor(TECHCAM);
	
	for (i=1; i<7; i=i+1)
	{
		scActorTalk(GUARD,201,i);
		scWaitForActor(GUARD);
	}

	for (i=7; i<11; i=i+1)
	{
		scActorTalk(TECHCAM,201,i);
		scWaitForActor(TECHCAM);
	}	
	scActorTalk(GUARD,201,11);
	scWaitForActor(GUARD);
	
	// Each one leaves...
	scActorWalkTo(TECHCAM,70,14);
	scExecuteAction(GUARD,VERB_USE,DOOR3,255);	
	scWaitForActor(TECHCAM);
	scWaitForActor(GUARD);
	scSetPosition(GUARD,ROOM_CAMCONTROL,12,9);
	scLookDirection(GUARD,FACING_RIGHT);
	bGuardInCtrlRoom=true;
	scRemoveObjectFromGame(TECHCAM);
	scRunObjectCode(VERB_CLOSE,DOOR3,255);
	
	// Damn! It nearly worked.
	scActorTalk(BLAKE,201,12);
	scWaitForActor(BLAKE);
	
	// But now we know about the stuck coin in the machine...
	bCoinStuck=true;
	scSave();
	scCursorOn(true);
}


stringpack 201{
#ifdef ENGLISH
	/*
	+++++++++++++++++++++++++++++++++++++
	*/
	"Where were you?";
	"Sorry, sir.";
	"It is difficult to find a coffee.";
	"The machine has only decaf left.";
	"And even so, the coin of a woman";
	"just got stuck inside...";
	"I had to go to Level 3.";
	
	"Okay, okay... Listen...";
	"I have an urgency - oh my stomach!";
	"Just keep an eye on the equipment";
	"Argh, I feel horrible!";
	
	"Of course, sir!";
	
	"Damn!....";
#endif
#ifdef SPANISH
	/*
	+++++++++++++++++++++++++++++++++++++
	*/
	"¿Dónde estabas?";
	"Lo siento, señor.";
	"Es difícil hacerse con un café.";
	"En la máquina sólo hay descafeniado.";
	"Además, la moneda de una señora";
	"se acaba de quedar atascada...";
	"Tuve que ir hasta el nivel 3.";
	
	"Vale, vale... escucha...";
	"Tengo una emergencia - ¡mi estómago!";
	"Vigila el equipo, por favor.";
	"Agh, ¡me siento fatal!";
	
	"¡Por supuesto, señor!";
	
	"¡Maldita sea!...";
#endif
}

// Open a door
script 250
{
	byte door;
	door=tmpParam1;
	
	// Check the door is not already being
	// opened or closed.
	if(sfGetCostumeID(door)!=255) scStopScript();

	// Launch the time-out closing, just in case.
	scSpawnScript(252);
	scBreakHere();

	scPlaySFX(SFX_DOOR);
	
	scSetCostume(door,202,0);	
	scSetCostume(door+1,202,0);
	scSetAnimstate(door,1);
	scSetAnimstate(door+1,4);
	scDelay(5);
	scSetAnimstate(door,2);
	scSetAnimstate(door+1,5);
	scDelay(5);
	scSetAnimstate(door,3);
	scSetAnimstate(door+1,6);

}

// Close a door
script 251
{
	byte door;	
	door=tmpParam1;
	
	// Check the door is not already being
	// opened or closed.
	if(sfGetAnimstate(door)!=3) scStopScript();
	
	scPlaySFX(SFX_DOOR);
	
	scSetAnimstate(door,2);
	scSetAnimstate(door+1,5);
	scDelay(5);
	scSetAnimstate(door,1);
	scSetAnimstate(door+1,4);
	scDelay(5);
	scSetAnimstate(door,0);
	scSetAnimstate(door+1,0);
	scBreakHere();
	scSetCostume(door,255,0);
	scSetCostume(door+1,255,0);
}

// Time-out close an open door
script 252
{
	byte door;
	door=tmpParam1;
	
	scDelay(200);
	if(sfGetCostumeID(door)!=255)
	{
		tmpParam1=door;
		scChainScript(251);
	}
}

objectcode DOOR1
{
	byte actor;
		
	LookAt: scActorTalk(sfGetActorExecutingAction(), 200, 8); scStopScript();
	Open:
		tmpParam1=DOOR1;
		scChainScript(250);
		scStopScript();
	Close:
		tmpParam1=DOOR1;
		scChainScript(251);
		scStopScript();	
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}
	WalkTo:
		actor=sfGetActorExecutingAction();
		if(actor==sfGetEgo())
			scCursorOn(false);
		if(sfGetCostumeID(DOOR1)==255 || sfGetAnimstate(DOOR1)==0)
			scRunObjectCode(VERB_OPEN, DOOR1, 255);
		scSetWalkboxAsWalkable(3,true);
		scActorWalkTo(actor,6,11);
		scWaitForActor(actor);
		scSetPosition(actor, ROOM_BROOM, 14, 11);
		scLookDirection(actor, FACING_DOWN);
		if(actor==sfGetEgo())
		{
			scCursorOn(true);
			scChangeRoomAndStop(ROOM_BROOM);
		}
}

objectcode DOOR2
{
	byte actor;
		
	LookAt: scActorTalk(sfGetActorExecutingAction(), 200, 9); scStopScript();
	Open:
		tmpParam1=DOOR2;
		scChainScript(250);
		scStopScript();		
	Close:
		tmpParam1=DOOR2;
		scChainScript(251);
		scStopScript();	
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}
	WalkTo:
		actor=sfGetActorExecutingAction();
		if(actor==sfGetEgo())
			scCursorOn(false);		
		if(sfGetCostumeID(DOOR2)==255 || sfGetAnimstate(DOOR2)==0)
			scRunObjectCode(VERB_OPEN, DOOR2, 255);
		scSetWalkboxAsWalkable(5,true);
		scActorWalkTo(actor,72,11);
		scWaitForActor(actor);
		scSetPosition(actor, ROOM_NURSERY, 15, 11);
		scLookDirection(actor, FACING_UP);

		if(actor==sfGetEgo())
		{
			scCursorOn(true);				
			scChangeRoomAndStop(ROOM_NURSERY);	
		}
}

objectcode DOOR3
{
	byte actor;
		
	LookAt: scActorTalk(sfGetActorExecutingAction(), 200, 10); scStopScript();
	Open:
		if ((sfGetActorExecutingAction()==BLAKE) && (!bGuardWentForCoffee))
			goto forbid;
		
		if(bCamDeactivated) 
			goto notagain;
		
		tmpParam1=DOOR3;
		scChainScript(250);
		scStopScript();	

	Close:
		if ((sfGetActorExecutingAction()==BLAKE) && (!bGuardWentForCoffee))
			goto forbid;

		if(bCamDeactivated) 
			goto notagain;

		tmpParam1=DOOR3;
		scChainScript(251);
		scStopScript();	
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}		
	WalkTo:
		if ((sfGetActorExecutingAction()==BLAKE) && (!bGuardWentForCoffee))
			goto forbid;

		if(bCamDeactivated) 
			goto notagain;
		
		actor=sfGetActorExecutingAction();
		if(actor==sfGetEgo())
			scCursorOn(false);

		if(sfGetCostumeID(DOOR3)==255 ||  sfGetAnimstate(DOOR3)==0)
			scRunObjectCode(VERB_OPEN, DOOR3, 255);
		scSetWalkboxAsWalkable(7,true);
		scDelay(20);
		scActorWalkTo(actor,118,11);
		scWaitForActor(actor);
		scSetPosition(actor, ROOM_CAMCONTROL, 15, 3);
		scLookDirection(actor, FACING_RIGHT);
		if(actor==sfGetEgo())
		{
			scCursorOn(true);
			scChangeRoomAndStop(ROOM_CAMCONTROL);
		}
		scStopScript();
	/*
	patience:
		scActorTalk(BLAKE,200,18);
		scWaitForActor(BLAKE);
		scStopScript();
	*/	
	forbid:
		scCursorOn(false);
		scFreezeScript(202,true);
		scLookDirection(GUARD,FACING_RIGHT);
		scActorTalk(GUARD,200,18);
		scWaitForActor(GUARD);
		scActorTalk(GUARD,200,19);
		scWaitForActor(GUARD);
		scLookDirection(BLAKE,FACING_LEFT);
		scCursorOn(true);
		scFreezeScript(202,false);
		scStopScript();
	notagain:
		scActorTalk(BLAKE,200,27);
		scWaitForActor(BLAKE);
		scStopScript();
}



objectcode DOOR4
{
	byte actor;
		
	LookAt: scActorTalk(sfGetActorExecutingAction(), 200, 30); scStopScript();
	Open:
		if(!bMapContactGiven) goto doorclosed;
		tmpParam1=DOOR4;
		scChainScript(250);
		scStopScript();	

	Close:
		tmpParam1=DOOR4;
		scChainScript(251);
		scStopScript();	
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}
	WalkTo:
		if(!bMapContactGiven) goto doorclosed;

		actor=sfGetActorExecutingAction();
		if(actor==sfGetEgo())
			scCursorOn(false);
		if(sfGetCostumeID(DOOR4)==255 ||  sfGetAnimstate(DOOR4)==0)
			scRunObjectCode(VERB_OPEN, DOOR4, 255);
		scSetWalkboxAsWalkable(6,true);
		scActorWalkTo(actor,95,11);
		scWaitForActor(actor);
		scSetPosition(actor, ROOM_MAPROOM, 15, 11);
		scLookDirection(actor, FACING_UP);
		if(actor==sfGetEgo())
		{
			scCursorOn(true);
			scChangeRoomAndStop(ROOM_MAPROOM);
		}
		scStopScript();
	doorclosed:
		scActorTalk(BLAKE,200,28);
		scStopScript();
}


objectcode DOOR5
{
	byte actor;
		
	LookAt: scActorTalk(sfGetActorExecutingAction(), 200, 30); scStopScript();
	Open:
		tmpParam1=DOOR5;
		scChainScript(250);
		scStopScript();
	Close:
		tmpParam1=DOOR5;
		scChainScript(251);
		scStopScript();
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}		
	WalkTo:
		actor=sfGetActorExecutingAction();
		if(actor==sfGetEgo())
			scCursorOn(false);
		if(sfGetCostumeID(DOOR5)==255 || sfGetAnimstate(DOOR5)==0)
			scRunObjectCode(VERB_OPEN, DOOR5, 255);
		scSetWalkboxAsWalkable(4,true);
		scActorWalkTo(actor,28,11);
		scWaitForActor(actor);
		scSetPosition(actor, ROOM_LOCKER, 15, 11);
		scLookDirection(actor, FACING_UP);
		if(actor==sfGetEgo())
		{
			scCursorOn(true);
			scChangeRoomAndStop(ROOM_LOCKER);
		}
}


stringpack 210
{
#ifdef ENGLISH
	"     BREAKING NEWS";
	"     -------------";
	
	"\A_FWGREEN Scientists report a decrease of .5 in";
	"\A_FWGREEN the air toxics in the last quarter.";
	"\A_FWGREEN Though the air is still deadly, our";
	"\A_FWGREEN work is producing excellent results.";
	
	"\A_FWGREEN Three more couples have been granted";
	"\A_FWGREEN permission for procreation in this ";
	"\A_FWGREEN year's call. Send applications to the";
	"\A_FWGREEN Population Control Agency.";
	
	
	"\A_FWGREEN The Federation has approved a plan to";
	"\A_FWGREEN invest 200 billion credits in the";
	"\A_FWGREEN Main Computer Control Facility here";
	"\A_FWGREEN on planet Earth.";
	
	"\A_FWGREEN A new communication station has been";
	"\A_FWGREEN deployed in planet Saurian Major.";
	"\A_FWGREEN Experts say it will greatly improve";
	"\A_FWGREEN communications between star systems.";
	
	"\A_FWGREEN Planet Auron has finally decided to";
	"\A_FWGREEN join the Terran Federation despite";
	"\A_FWGREEN their previous stubborn government."; 
	"\A_FWGREEN Congratulations to the citizens!";
#endif
#ifdef SPANISH
	"      ULTIMA HORA";
	"      -----------";
	
	"\A_FWGREEN Los datos indican un descenso de .5";
	"\A_FWGREEN en tóxicos en el último trimestre.";
	"\A_FWGREEN Aunque el aire es aun venenoso, el";
	"\A_FWGREEN trabajo está dando resultados.";
	
	"\A_FWGREEN Se ha dado permiso de procreación a";
	"\A_FWGREEN tres parejas más en la convocatoria";
	"\A_FWGREEN de este año. Enviar solicitudes a";
	"\A_FWGREEN la Agencia de Control de Natalidad.";
		
	"\A_FWGREEN La Federación ha aprobado un plan de";
	"\A_FWGREEN inversión de 200 mill millones para";
	"\A_FWGREEN la construcción de un centro de";
	"\A_FWGREEN Control Central aquí, en la Tierra.";
	
	"\A_FWGREEN Una nueva estación de comunicaciones";
	"\A_FWGREEN se ha desplegado en Saurian Major.";
	"\A_FWGREEN Los expertos indican que mejorará";
	"\A_FWGREEN notablemente las comunicaciones.";
		
	"\A_FWGREEN El Planeta Auron ha decidido al fin";
	"\A_FWGREEN unisrse a la Federación Terrana,";
	"\A_FWGREEN pese a la tozudez de su anterior"; 
	"\A_FWGREEN Gobierno. ¡Felicidades!";

#endif
}

script 210{
	byte i;

	scDelay(sfGetRandInt(100,150));
	
	for(i=1;i<=5;i=i+1){
		scSetAnimstate(205,0);
		scDelay(20);
		scSetAnimstate(205,1);
		if ((sfGetCameraCol()>=36) && (sfGetCameraCol()<=74) )
			scPlaySFX(SFX_UIB);
		scDelay(20);		
	}

	for (i=2;i<10;i=i+1){
		scSetAnimstate(205,i);
		scDelay(10);
	}
	
	for(i=1;i<=5;i=i+1){
		scSetAnimstate(205,10);
		scDelay(20);
		scSetAnimstate(205,9);
		scDelay(20);		
	}
	scSetAnimstate(205,0);
	scRestartScript();
}


