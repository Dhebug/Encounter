/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR en cours	*/
/****************************/

#include "globals.h"

// Scripts for Blake's room

#define DOOR		200
#define DRAWER		202
#define LAMP		203
#define BOOK		204
#define BALL		205
#define PICTURE		206
#define SCREEN		207



script 201{
	/*
	// I am setting the costume for these objects here
	// because that way they can be local, saving
	// entries in disk. Anyway they are not used
	// anywhere else.
	if(sfGetRoom(SANDWICH)==sfGetCurrentRoom())
	{
		scSetCostume(SANDWICH,210,0);
		scSetAnimstate(SANDWICH,0);
	}
	if(sfGetRoom(MUG)==sfGetCurrentRoom())
	{
		scSetCostume(MUG,211,0);
		scSetAnimstate(MUG,0);
	}
	*/
}

// Stringpack with the introduction sentences
stringpack 200{
#ifdef ENGLISH
	"I have a meeting with Ravella.";
	"She has some information...";
#endif
#ifdef FRENCH
	"J'ai une reunion avec Ravella";
	"Elle a des informations";
#endif
#ifdef SPANISH
	"Tengo una cita con Ravella.";
	"Dice que tiene información...";
#endif
}

// String pack for descriptions in this room
#define STDESC  	201
stringpack STDESC
{
#ifdef ENGLISH
	"There's nothing of interest.";
	"It reminds me of something...";
	"A Brave New World...";
	"Ravella ordered it for me.";
	
	// 4
	"Just another lamp.";
	"My family...";
	"Nothing interesting at the moment.";
	"My room's exit door.";
	
	//8
	"The only food I can eat.";
	"I promised Ravella.";
	"But I hate cheese.";
	
	//11
	"The mug I bought last month.";
	"It is empty.";
	
	//13
	"I prefer it here.";
	"I'd like to keep it in my room.";
	"I don't see the use of moving that.";
	"Why would I pick that up?";
	
	//17
	"No time for reading now. Pity.";
	"I could turn it on, but why?";
	"No time for watching TV now.";
	
	//20
	"I have not even started it yet.";
	"There is a dog-ear on page 172.";
#endif

#ifdef FRENCH
	"Il n'y a rien d'interessant.";
	"It reminds me of something...";
	"A Brave New World...";
	"Ravella ordered it for me.";
	
	// 4
	"Juste une lampe.";
	"Ma famille..";
	"Rien d'interessant pour le moment.";
	"La porte de sortie.";
	
	//8
	"The only food I can eat.";
	"I promised Ravella.";
	"Je hais le fromage";
	
	//11
	"Le mug achete le mois passe.";
	"Il est vide.";
	
	//13
	"I prefer it here.";
	"I'd like to keep it in my room.";
	"I don't see the use of moving that.";
	"Why would I pick that up?";
	
	//17
	"No time for reading now. Pity.";
	"I could turn it on, but why?";
	"No time for watching TV now.";
	
	//20
	"I have not even started it yet.";
	"There is a dog-ear on page 172.";
#endif

#ifdef SPANISH
	"No hay nada interesante.";
	"Me recuerda a algo....";
	"Un Mundo Feliz...";
	"Ravella lo pidió para mí.";

	// 4
	"Solo es otra lámpara.";
	"Mi familia...";
	"No hay nada interesante por ahora.";
	"La puerta de salida.";
	
	//8
	"La única comida que puedo tomar.";
	"Se lo prometí a Ravella.";
	"Pero odio el queso.";
	
	//11
	"La taza que compré hace un mes.";
	"Está vacía.";
	
	//13
	"Déjalo aquí.";
	"Lo quiero en mi habitación.";
	"No veo por qué lo voy a mover.";
	"¿Para qué quieres que lo coja?";
	
	//17
	"No tengo tiempo para leer. Lástima.";
	"Podría encenderla, pero ¿para qué?";
	"No tengo tiempo para ver la tele.";
	
	//20
	"Ni lo he empezado todavía.";
	"Tiene un doblez en la página 172.";
#endif
	
}

objectcode DRAWER
{
	Open:
	LookAt: 
		scActorTalk(BLAKE,STDESC,0);
		scWaitForActor(BLAKE);
		scStopScript();
}
objectcode LAMP
{
	PickUp:	
		scActorTalk(BLAKE,STDESC,sfGetRandInt(13,16));
		scWaitForActor(BLAKE);
		scStopScript();
	
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}
		scActorTalk(BLAKE,STDESC,18);
		scWaitForActor(BLAKE);
		scStopScript();	
	LookAt: 
		scActorTalk(BLAKE,STDESC,1);
		scWaitForActor(BLAKE);
		scStopScript();
}
objectcode BOOK
{
	PickUp:	
		scActorTalk(BLAKE,STDESC,sfGetRandInt(13,16));
		scWaitForActor(BLAKE);
		scStopScript();
	
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}	
	Open:
		scCursorOn(false);
		scActorTalk(BLAKE,STDESC,17);
		scWaitForActor(BLAKE);
		scActorTalk(BLAKE,STDESC,20);
		scWaitForActor(BLAKE);
		scActorTalk(BLAKE,STDESC,21);
		scWaitForActor(BLAKE);		
		scCursorOn(true);
		scStopScript();	
	
	LookAt: 
		scCursorOn(false);
		scActorTalk(BLAKE,STDESC,2);
		scWaitForActor(BLAKE);
		scActorTalk(BLAKE,STDESC,3);
		scWaitForActor(BLAKE);
		scCursorOn(true);
		scStopScript();
}

objectcode BALL
{
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}	
		scActorTalk(BLAKE,STDESC,18);
		scWaitForActor(BLAKE);
		scStopScript();		
	PickUp:	
		scActorTalk(BLAKE,STDESC,sfGetRandInt(13,16));
		scWaitForActor(BLAKE);
		scStopScript();
	
	LookAt: 
		scActorTalk(BLAKE,STDESC,4);
		scWaitForActor(BLAKE);
		scStopScript();
}

objectcode PICTURE
{
	PickUp:	
		scActorTalk(BLAKE,STDESC,sfGetRandInt(13,16));
		scWaitForActor(BLAKE);
		scStopScript();

	LookAt: 
		scActorTalk(BLAKE,STDESC,5);
		scWaitForActor(BLAKE);
		scStopScript();
}

objectcode SCREEN
{
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}

		scActorTalk(BLAKE,STDESC,19);
		scWaitForActor(BLAKE);
		scStopScript();	
	
	LookAt: 
		scActorTalk(BLAKE,STDESC,6);
		scWaitForActor(BLAKE);
		scStopScript();
}


// Close door
script 251
{
	scPlaySFX(SFX_DOOR);
	scSetAnimstate(DOOR,2);
	scSetAnimstate(DOOR+1,5);
	scDelay(5);
	scSetAnimstate(DOOR,1);
	scSetAnimstate(DOOR+1,4);
	scDelay(5);
	scSetAnimstate(DOOR,0);
	scSetAnimstate(DOOR+1,0);	
}

// Time-out close an open door
script 252
{
	scDelay(200);
	if(sfGetAnimstate(DOOR)==3)
		scChainScript(251);
}


objectcode DOOR
{
	byte actor;
		
	LookAt: scActorTalk(sfGetActorExecutingAction(), STDESC, 7); scStopScript();
	Open:
		if(sfGetAnimstate(DOOR)!=0)
			scStopScript();
		scPlaySFX(SFX_DOOR);
		scSetAnimstate(DOOR,1);
		scSetAnimstate(DOOR+1,4);
		scDelay(5);
		scSetAnimstate(DOOR,2);
		scSetAnimstate(DOOR+1,5);
		scDelay(5);
		scSetAnimstate(DOOR,3);
		scSetAnimstate(DOOR+1,6);
		scSpawnScript(252);
		scStopScript();
	Close:
		if(sfGetAnimstate(DOOR)!=3)
			scStopScript();	
		scChainScript(251);
		scStopScript();

	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}
	WalkTo:
	
		actor=sfGetActorExecutingAction();
		if(actor==sfGetEgo())
			scCursorOn(false);
		if(sfGetAnimstate(DOOR)==0)
			scRunObjectCode(VERB_OPEN, DOOR, 255);
		scSetWalkboxAsWalkable(3,true);
		scActorWalkTo(actor,14,11);
		scWaitForActor(actor);
		scLookDirection(actor, FACING_UP);
		scBreakHere();
		scSetPosition(actor, ROOM_HALLWAY, 12, 6);
		scLookDirection(actor, FACING_DOWN);
		if(actor==sfGetEgo())
		{
			scCursorOn(true);
			scChangeRoomAndStop(ROOM_HALLWAY);
		}
}

