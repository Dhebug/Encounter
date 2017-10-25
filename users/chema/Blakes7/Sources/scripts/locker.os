/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"

// Script for locker room


#define EXIT		200
#define BUCKET		201
#define VCLEANER	202
#define LADDER		203
#define BOTTLES		204
#define SIGN		205

#define LOCKER1B	206
#define LOCKER2B	207
#define LOCKER3B	208
#define LOCKER4B	209

#define LOCKER1A	210
#define LOCKER2A	211
#define LOCKER3A	212
#define LOCKER4A	213

#define ENVELOPE	214

script 200{	
	byte i;
	
	bTryOpenLockers=false;
	bTryKeyLockers=false;
	if(bEnvelopeExamined)
	{
		scCursorOn(false);
		for(i=0;i<=5;i=i+1)
		{
			scActorTalk(BLAKE,201,8+i);
			scWaitForActor(BLAKE);	
		}
		bEnvelopeExamined=false;	
		scSave();
		scCursorOn(true);
	}
}

objectcode EXIT{
	byte actor;
	WalkTo:
		actor=sfGetActorExecutingAction();
		scSetPosition(actor, ROOM_HALLWAY, 13, 28);
		scLookDirection(actor, FACING_DOWN);
		if(actor==sfGetEgo())
			scChangeRoomAndStop(ROOM_HALLWAY);
}

objectcode BUCKET{
	LookAt:
		scActorTalk(BLAKE,200,0);
		scWaitForActor(BLAKE);
		scStopScript();
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}	
	PickUp:
		scActorTalk(BLAKE,200,sfGetRandInt(6,9));
		scWaitForActor(BLAKE);
		scStopScript();
}

objectcode VCLEANER{
	LookAt:
		scActorTalk(BLAKE,200,1);
		scWaitForActor(BLAKE);
		scStopScript();
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}
	PickUp:
		scActorTalk(BLAKE,200,sfGetRandInt(6,9));
		scWaitForActor(BLAKE);
		scStopScript();
}

objectcode LADDER{
	LookAt:
		scActorTalk(BLAKE,200,2);
		scWaitForActor(BLAKE);
		scStopScript();
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}
	PickUp:
		scActorTalk(BLAKE,200,sfGetRandInt(6,9));
		scWaitForActor(BLAKE);
		scStopScript();
}

objectcode BOTTLES{
	LookAt:
		scActorTalk(BLAKE,200,3);
		scWaitForActor(BLAKE);
		scStopScript();
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}
	PickUp:
		scActorTalk(BLAKE,200,sfGetRandInt(6,9));
		scWaitForActor(BLAKE);
		scStopScript();
}

objectcode SIGN{
	LookAt:
		scActorTalk(BLAKE,200,4);
		scWaitForActor(BLAKE);
		scStopScript();
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}
	PickUp:
		scActorTalk(BLAKE,200,sfGetRandInt(6,9));
		scWaitForActor(BLAKE);
		scStopScript();
}

objectcode LOCKER1A{
	LookAt:
		scActorTalk(BLAKE,200,5);
		scWaitForActor(BLAKE);
		scStopScript();
	Use:
	Open:
		scChainScript(201);
		scStopScript();
}
objectcode LOCKER2A{
	LookAt:
		scActorTalk(BLAKE,200,5);
		scWaitForActor(BLAKE);
		scStopScript();
	Use:
	Open:
		scChainScript(201);
		scStopScript();
}objectcode LOCKER3A{
	LookAt:
		scActorTalk(BLAKE,200,5);
		scWaitForActor(BLAKE);
		scStopScript();
	Use:
	Open:
		scChainScript(201);
		scStopScript();
}objectcode LOCKER4A{
	LookAt:
		scActorTalk(BLAKE,200,5);
		scWaitForActor(BLAKE);
		scStopScript();
	Use:
	Open:
		scChainScript(201);
		scStopScript();
}objectcode LOCKER1B{
	LookAt:
		scActorTalk(BLAKE,200,5);
		scWaitForActor(BLAKE);
		scStopScript();
	Use:
	Open:
		scChainScript(201);
		scStopScript();
}objectcode LOCKER2B{
	LookAt:
		scActorTalk(BLAKE,200,5);
		scWaitForActor(BLAKE);
		scStopScript();
	Use:
	Open:
		scChainScript(201);
		scStopScript();
}objectcode LOCKER3B{
	LookAt:
		scActorTalk(BLAKE,200,5);
		scWaitForActor(BLAKE);
		scStopScript();
	Use:
	Open:
		scChainScript(201);
		scStopScript();
}objectcode LOCKER4B{
	LookAt:
		scActorTalk(BLAKE,200,5);
		scWaitForActor(BLAKE);
		scStopScript();
	Use:
	Open:
		scChainScript(201);
		scStopScript();
}


objectcode ENVELOPE{
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}
	PickUp:
	Open:
	LookAt:
		scActorTalk(BLAKE,200,20);
		scWaitForActor(BLAKE);	
		// Launch envelope sequence
		scSpawnScript(202);			
}


script 202{
	byte i;
	byte ef;
	
	scShowVerbs(false);
	
	scActorWalkTo(BLAKE,15,15);
	scWaitForActor(BLAKE);
	scLookDirection(BLAKE, FACING_UP);

	scSetAnimstate(LOCKER3B,0);
	scRemoveObjectFromGame(ENVELOPE);
	
	for(i=0;i<=6;i=i+1)
	{
		if(i==1)
			scLookDirection(BLAKE, FACING_DOWN);
		scActorTalk(BLAKE,201,i);
		scWaitForActor(BLAKE);	
	}
	ef=sfGetFadeEffect();
	scSetFadeEffect(0);
	scLoadRoom(200);
	scBreakHere();
	scDelay(50);
	scPrintAt(201,7,30,0);
	scDelay(100);
	scSetFadeEffect(ef);

	scShowVerbs(true);
	scRemoveFromInventory(KEY);		
	bEnvelopeExamined=true;
	
	if(!bGuardWentForCoffee)
	{
		// Time to send the guard for coffee
		bGuardWentForCoffee=true;
		scSetPosition(GUARD,255,0,0);
	}

	scLoadRoom(ROOM_LOCKER);		
}

stringpack 201{
#ifdef ENGLISH	
	/***************************************/
	"What's this... An empty paper...";
	"Wait! an image is being formed...";
	"It's a picture. That's me!";
	"But who are those people?...";
	"And where are we?";
	//5
	"My mind... is in darkness..";
	"Oh! I'm sick!";
	//7
	"Aaaaarghhhh!!";
	//8
	"What was that?"; 
	"As if a monster came out of my closet,";
	"and suddenly retreated...";
	//11
	"The picture has disappeared again.";
	"Ravella will have a lot of things to";
	"explain. Time to meet her again!";
#endif

#ifdef SPANISH
	/***************************************/
	"¿Qué es esto? un papel en blanco...";
	"¡Un momento! se forma una imagen...";
	"Una foto. ¡Ese soy yo!";
	"Pero ¿quién es esa gente?";
	"Y ¿dónde estamos?";
	//5
	"Mi mente... todo está borroso...";
	"¡Me estoy mareando!";
	//7
	"Aaaaarghhhh!!";
	//8
	"¿Qué ha sido eso?"; 
	"Como si un monstruo se asomase a la";
	"puerta y, de pronto, se marchase...";
	//11
	"La foto se ha borrado de nuevo.";
	"Ravella tiene mucho que explicar.";
	"¡Es hora de volver a verla!";
#endif	
}

stringpack 200{
#ifdef ENGLISH	
	"A bucket and a mop.";
	"Cyclonic? Maybe...";
	"Looks pretty robust.";
	"Various cleaning products.";
	"It reads: Warning. Wet floor.";
	"A locker. Nothing special.";
	
	//6
	"No time for cleaning now!";
	"What do you expect me to do with it?";
	"I prefer to leave it here.";
	"No use for what we have in hand now.";
	
	//10
	"The locker is closed.";
	"This locker is also closed.";
	"This one is closed too.";
	"Closed. It seems all are.";
	
	//14
	"The key does not fit.";
	"The key doen't fit here either.";
	"Nope. Not for this one.";
	"Aha! It fits... uh, no.";
	
	//18
	"It fits... good.";
	
	//19
	"That won't help.";
	
	//20
	"Okay, let's see what this is all about.";
#endif
#ifdef SPANISH
	"Un caldero y una fregona.";
	"¿Ciclónica? Quizás...";
	"Parece bastante robusta.";
	"Varios productos de limpieza.";
	"Pone: Cuidado, suelo húmedo.";
	"Una taquilla. Nada en especial.";
	
	//6
	"¡No es momento de ponerse a limpiar!";
	"¿Y qué esperas que haga con eso?";
	"Prefiero que se quede aquí.";
	"No es útil para nuestros propósitos.";
	
	//10
	"La taquilla está cerrada.";
	"Esta taquilla también está cerrada.";
	"Y esta también está cerrada.";
	"Cerrada. Creo que todas lo están.";
	
	//14
	"La llave no vale para ésta.";
	"Tampoco vale para ésta otra.";
	"No. No es la de ésta.";
	"¡Ajá! Entra... ah, que no.";
	
	//18
	"Esta sí. Perfecto.";
	
	//19
	"Eso no va a ayudar.";
	
	//20
	"A ver de qué va todo esto.";
#endif	
}


script 201
{
	byte s;
	if (sfGetActionVerb()==VERB_USE)
	{
		if(sfGetActionObject1()!=KEY)
		{
			scActorTalk(BLAKE,200,19);
			scWaitForActor(BLAKE);	
			scStopScript();
		}
		
		if(sfGetActionObject2()==LOCKER3B)
		{
			scActorTalk(BLAKE,200,18);
			scWaitForActor(BLAKE);	
			// Open the locker here
			scSetAnimstate(LOCKER3B,1);
			scLoadObjectToGame(ENVELOPE);
			//scRemoveObjectFromGame(LOCKER3B);
		}
		else
		{
			if(!bTryKeyLockers)
			{
				s=14;
				bTryKeyLockers=true;
			}
			else
				s=sfGetRandInt(15,17);
			
			scActorTalk(BLAKE,200,s);
			scWaitForActor(BLAKE);
		}
		scStopScript();
	}
	
	if(!bTryOpenLockers)
	{
		s=10;
		bTryOpenLockers=true;
	}
	else
	{
		s=sfGetRandInt(11,13);
	}
	scActorTalk(BLAKE,200,s);
	scWaitForActor(BLAKE);
}

