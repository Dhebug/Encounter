/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

#define EXHALLWAY	200
#define CAMERA 		201
#define BPOSTER		202
#define SPOSTER		203


// String pack for descriptions in this room
#define STDESC  	200

// Entry script
script 200 
{
	// Launch room scripts
	scSpawnScript(210); // Camera
	scSpawnScript(202); // Man

}

// Script that animates the camera
script 210
{
	scDelay(sfGetRandInt(80,110));
	scSetAnimstate(CAMERA,1);
	scDelay(5);
	scSetAnimstate(CAMERA,2);
	scDelay(5);
	scSetAnimstate(CAMERA,3);
	scDelay(sfGetRandInt(80,110));
	scSetAnimstate(CAMERA,2);
	scDelay(5);
	scSetAnimstate(CAMERA,1);
	scDelay(5);
	scSetAnimstate(CAMERA,0);
	scRestartScript();
}

// Script that animates the man at the desk
script 202
{
	scDelay(sfGetRandInt(150,250));
	scLookDirection(INFOMAN,FACING_DOWN);
	scDelay(sfGetRandInt(150,250));
	scLookDirection(INFOMAN,FACING_LEFT);	
	scDelay(sfGetRandInt(150,250));
	scLookDirection(INFOMAN,FACING_DOWN);	
	scDelay(sfGetRandInt(150,250));
	scLookDirection(INFOMAN,FACING_RIGHT);	
	scRestartScript();
}

objectcode EXHALLWAY{
	WalkTo:
		// It may be time to move the man at the info desk
		if(bMapContactGiven && (sfGetRoom(INFOMAN)!=ROOM_MAPROOM)){
			scTerminateScript(202);
			scLookDirection(INFOMAN,FACING_RIGHT);			
			scSetPosition(INFOMAN,ROOM_MAPROOM,14,5);
		}
		scSetPosition(BLAKE,ROOM_HALLWAY,13,1);
		scChangeRoomAndStop(ROOM_HALLWAY);
}

objectcode CAMERA{
	LookAt:
		scActorTalk(BLAKE,STDESC,0);
}

objectcode BPOSTER
{
	LookAt:
		scCursorOn(false);
		scActorTalk(BLAKE,STDESC,1);
		scWaitForActor(BLAKE);
		scLookDirection(BLAKE,FACING_DOWN);
		scActorTalk(BLAKE,STDESC,2);
		scWaitForActor(BLAKE);
		scActorTalk(BLAKE,STDESC,3);
		scWaitForActor(BLAKE);
		scActorTalk(BLAKE,STDESC,4);
		scWaitForActor(BLAKE);
		scCursorOn(true);
}

objectcode SPOSTER{
	LookAt:
		scCursorOn(false);
		scActorTalk(BLAKE,STDESC,5);
		scWaitForActor(BLAKE);
		scLookDirection(BLAKE,FACING_DOWN);
		scActorTalk(BLAKE,STDESC,6);
		scWaitForActor(BLAKE);
		scCursorOn(true);	
}

stringpack STDESC	
{
#ifdef ENGLISH
	"Yes, another security camera.";
	"Save your planet.";
	"We all work here with one aim:";
	"To make Earth habitable again.";
	"That is the Federation's plan.";
	"Join the Federation Security Corps.";
	"No, thank you.";
#endif

#ifdef FRENCH
	"Encore une autre caméra de sécurité...";
	"Sauve ta planete.";
	"Nous travaillons tous dans le meme but:";
	"rendre la Terre habitable de nouveau.";
	"Ceci est l'objectif de la Fédération."; // [laurentd75]: "objectif" rather than "plan" here
	"Enrole-toi dans le Service de Sécurité.";
	"Non merci...";
#endif
#ifdef SPANISH
	"Sí. Otra cámara de seguridad.";
	"Salva tu planeta.";
	"Todos trabajamos con un fin:";
	"Hacer la Tierra habitable de nuevo.";
	"Ese es el plan de la Federación.";
	"Alístate en el Cuerpo de Seguridad.";
	"No, gracias.";
#endif
}


/* Dialog with staff member on the info area */
#define DIALOG_1	200
#define DIALOG_SCRIPT	201
#define MAN1 		INFOMAN
#define DIALOG_STRINGS 	201
#define DIALOG_OPTIONS  202


dialog DIALOG_1: script DIALOG_SCRIPT stringpack DIALOG_OPTIONS{
#ifdef ENGLISH
	option "I need a map of the complex." inactive -> map;
	option "Yes, I need info on the city exits." inactive -> exits;
	option "Nothing, thank you." active -> bye;
#endif
#ifdef FRENCH
	option "Il me faudrait un plan du complexe." inactive -> map;
	option "Je cherche les sorties de la ville." inactive -> exits;
	option "Non rien, merci." active -> bye;
#endif
#ifdef SPANISH
	option "Necesito un mapa del complejo." inactive -> map;
	option "Necesito las salidas de la ciudad." inactive -> exits;
	option "Nada, gracias." active -> bye;
#endif

}

/* Script that controls the dialog above */
script DIALOG_SCRIPT{
	byte i;
export map:
	for(i=9;i<12;i=i+1)
	{
		scActorTalk(MAN1, DIALOG_STRINGS,i);
		scWaitForActor(MAN1);		
	}
	scActivateDlgOption(0,false);
	if(bMetRavella)
		scActivateDlgOption(1,true);
	scStartDialog();
	scStopScript();
export exits:
	for(i=12;i<=16;i=i+1)
	{
		scActorTalk(MAN1, DIALOG_STRINGS,i);
		scWaitForActor(MAN1);		
	}	
	bMapContactGiven=true;
	scActorTalk(BLAKE,DIALOG_STRINGS,17);
	scWaitForActor(BLAKE);
	scSave();
	// Flow to bye
export bye:
	scActorTalk(MAN1, DIALOG_STRINGS,2);
	scWaitForActor(MAN1);
	if(!bManTalkedBoutCoffee)
	{
		bManTalkedBoutCoffee=true;
		scDelay(25);
	
		for(i=3;i<6;i=i+1)
		{
			scActorTalk(MAN1, DIALOG_STRINGS,i);
			scWaitForActor(MAN1);		
		}
		scActorTalk(BLAKE, DIALOG_STRINGS,6);
		scWaitForActor(BLAKE);	
		scActorTalk(MAN1, DIALOG_STRINGS,7);
		scWaitForActor(MAN1);
		scActorTalk(MAN1, DIALOG_STRINGS,8);
		scWaitForActor(MAN1);
	}
	scFreezeScript(202,false);
	scEndDialog();
}

stringpack DIALOG_STRINGS
{
	// Description and initial sentences
#ifdef ENGLISH
	/*++++++++++++++++++++++++++++++++++++++*/
	"He seems willing to help.";
	"Good evening. What can I do for you?";
	
	//2
	"No problem. Have a nice day.";
	"Uh, by the way, do you know";
	"if they have refilled the coffee";
	"machine yet?";
	"No, sorry.";
	"It's ok. My shift ends in a minute";
	"But it'd be nice to have a coffee.";
	//9
	"I'm sorry but I just ran out of them.";
	"I will receive more tomorrow.";
	"Are you looking for something specific?";
	//12
	"Oh, that doesn't appear on usual maps.";
	//"You need tech maps, which are ilegal...";
	"They are in maintenance areas, not ";
	"accessible for regular citizens.";
	"Mmm, I may know somebody who can help.";
	//"if you have something to trade.";
	"Ask in door 4 in the main corridor.";
	//17
	"Okay, thanks indeed.";
	//18
	"I can't accept anything, sir.";
#endif

#ifdef FRENCH
	/*++++++++++++++++++++++++++++++++++++++*/
	"Il a l'air disposé a m'aider.";
	"Bonsoir, que puis-je faire pour vous?";
	
	//2
	"Pas de probleme. Bonne journée.";
	"Au fait, savez-vous s'ils ont enfin";
	"réapprovisionné la machine a café";
	"qui se trouve dans le couloir?";
	"Non, désolé.";
	"Tant pis. Mon service finit bientot,";
	"mais j'aurais bien aimé avoir un café.";
	//9
	"Désolé, mais je n'en ai plus.";
	"J'en recevrai d'autres demain.";
	"Cherchez-vous une chose en particulier?";
	//12
	"Oh, ca n'apparait pas sur les plans.";
	//"You need tech maps, which are ilegal...";
	"Elles se trouvent dans les zones";
	"de service, interdites au public.";  // "de service" ou "d'entretien"...
	"Mais je connais quelqu'un qui saurait.";
	//"if you have something to trade.";
	"Demandez en porte 4 dans le couloir.";
	//17
	"Ok, merci beaucoup.";
	//18
	"Je ne peux rien accepter, monsieur.";
#endif


#ifdef SPANISH
	/*++++++++++++++++++++++++++++++++++++++*/
	"Parece encantado de ayudar.";
	"Buenas, ¿qué puedo hacer por usted?";
	
	//2
	"Ningún problema. Tenga un buen día.";
	"Ah, por cierto, ¿sabe por casualidad";
	"si han rellenado por fin la máquina";
	"de café del pasillo?";
	"No, lo siento.";
	"Vaya. Mi turno acaba enseguida, pero";
	"necesitaba una taza de café.";
	//9
	"Lo siento, pero se me han acabado.";
	"Me llegan más mañana.";
	"¿Buscaba algo en particular?";
	//12
	"Uy, eso no aparece en los mapas.";
	"Son áreas de mantenimiento y están"; // [laurentd75] mismatch with English version: "They are IN maintenance areas"
	"prohibidas para ciudadanos regulares.";
	"Mmmm, pero conozco a alguien...";
	"Pregunte en la puerta 4 del pasillo.";
	//17
	"Vale. Gracias por todo.";
	//18
	"No puedo aceptar regalos, señor.";
#endif

}


