/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

#define DIALOG_SCRIPT 	220
#define DIALOG_STRINGS	221
#define DIALOG_OPTIONS 	220
#define DIALOG_1	200

#define DESC_STRINGS	200

#define CAM_SCRIPT 	200

#define EXITHALLWAY	200
#define CAMERA1		201
#define CAMERA2		202
#define SDOOR		203
#define COUCH		204

#define RAVELLA 	250

/* Dialog with Ravella */
dialog DIALOG_1: script DIALOG_SCRIPT stringpack DIALOG_OPTIONS{
#ifdef ENGLISH
	option "You said you had news about my family." active -> family;
	option "I haven't taken anything for 36 hours." active -> food;
	option "I received the book you sent me." active -> book;	
	option "One second. I'll be back." active -> exit1;	
	option "Is this some kind of practical joke?" inactive -> skeptic;
	option "No, not that again.." inactive -> skeptic;
	option "But the outside air is lethal!" inactive -> air;
	option "See you later, then." inactive -> bye;
#endif

#ifdef FRENCH
	       /***************************************/
	option "As-tu des nouvelles de ma famille?" active -> family;
	option "Je n'ai rien mangé depuis 36 heures." active -> food;
	option "J'ai reçu le livre que tu m'as envoyé." active -> book;	
	option "Une seconde. Je reviens." active -> exit1;	
	option "Est-ce que c'est une blague douteuse?" inactive -> skeptic;
	option "Non, pas ça encore.." inactive -> skeptic;
	option "Mais l'air extérieur est mortel!" inactive -> air;
	option "A plus tard, alors." inactive -> bye;
#endif

#ifdef SPANISH
	option "Dijiste que sabías algo de mi familia." active -> family;
	option "No he comido nada en 36 horas." active -> food;
	option "Recibí el libro que me enviaste." active -> book;	
	option "Un segundo. Vengo ahora." active -> exit1;	
	option "¿Es esto algún tipo de broma pesada?" inactive -> skeptic;
	option "Otra vez no..." inactive -> skeptic;
	option "¡Pero el aire fuera es letal!" inactive -> air;
	option "Entonces nos vemos luego." inactive -> bye;
#endif
}

/* Script that controls the dialog above */
script DIALOG_SCRIPT{
export family: 
	/* Blake asks about his family */
	scWaitForActor(BLAKE);
	scActorTalk(RAVELLA, DIALOG_STRINGS,7);
	scWaitForActor(RAVELLA);
	scActorTalk(RAVELLA, DIALOG_STRINGS,8);
	scWaitForActor(RAVELLA);
	scActivateDlgOption(0,false);
	goto common; // Common for continuing inside the dialog
export food:
	/* Blake sais he's been without food for 36 hours */
	scWaitForActor(BLAKE);
	scActorTalk(RAVELLA, DIALOG_STRINGS,4);
	scWaitForActor(RAVELLA);
	scActorTalk(BLAKE, DIALOG_STRINGS,3);
	scWaitForActor(BLAKE);
	scActorTalk(RAVELLA, DIALOG_STRINGS,5);
	scWaitForActor(RAVELLA);
	scActorTalk(RAVELLA, DIALOG_STRINGS,6);
	scWaitForActor(RAVELLA);
	scActivateDlgOption(1,false);
act_skeptic:	
	/* Show options where Blake shows his skepticism */
	scActivateDlgOption(4,true);
	scActivateDlgOption(5,true);
	goto common;
export book:
	/* Blake tells about the book */
	scActorTalk(RAVELLA, DIALOG_STRINGS,11);
	scWaitForActor(RAVELLA);
	scActorTalk(RAVELLA, DIALOG_STRINGS,12);
	scWaitForActor(RAVELLA);	
	scActorTalk(RAVELLA, DIALOG_STRINGS,13);
	scWaitForActor(RAVELLA);	
	/* Ravella told the information, time to activate
	the option to exit the dialog */
	scActivateDlgOption(6,true);
	scActivateDlgOption(2,false);
	scActivateDlgOption(3,false);
	scActivateDlgOption(7,true);
	goto act_skeptic;
export skeptic:
	/* Blake has shown his skepticism, Ravella insists. */
	if(sfGetRand()>128)
	{
		scActorTalk(RAVELLA, DIALOG_STRINGS,9);
		scWaitForActor(RAVELLA);
		scActorTalk(RAVELLA, DIALOG_STRINGS,10);
		scWaitForActor(RAVELLA);
	}
	else
	{
		scActorTalk(RAVELLA, DIALOG_STRINGS,17);
		scWaitForActor(RAVELLA);
		scActorTalk(RAVELLA, DIALOG_STRINGS,18);
		scWaitForActor(RAVELLA);
		scActorTalk(RAVELLA, DIALOG_STRINGS,19);
		scWaitForActor(RAVELLA);		
	}
	scActivateDlgOption(4,false);
	scActivateDlgOption(5,false);	
	goto common;
export air:
	/* Blake tells that air is unbreathable */
	scActorTalk(RAVELLA, DIALOG_STRINGS,14);
	scWaitForActor(RAVELLA);	
	scActivateDlgOption(6,false);	
common:
	scStartDialog();
	scStopScript();

export bye:
	/* Ravella tells Blake to meet her later */
	scActorTalk(RAVELLA, DIALOG_STRINGS,15);
	scWaitForActor(RAVELLA);	
	scActorTalk(RAVELLA, DIALOG_STRINGS,20);
	scWaitForActor(RAVELLA);	
	scActorTalk(RAVELLA, DIALOG_STRINGS,21);
	scWaitForActor(RAVELLA);	
	scActorTalk(RAVELLA, DIALOG_STRINGS,22);
	scWaitForActor(RAVELLA);	
	scPutInInventory(KEY);
	bMetRavella=true; // This will make here never appear again
	scSave();

export exit1:
	/* End dialog, back to commands */
	scWaitForActor(sfGetEgo());
	scLookDirection(RAVELLA, FACING_RIGHT);
	scEndDialog();
}

stringpack DIALOG_STRINGS
{
#ifdef ENGLISH
"Hello Ravella.";	// 0
"Did you have any trouble?";
"No. Nothing strange.";

"Hungry and thirsty of course!"; //3

"And how do you feel?"; // 4
"Well done.";
"The food is full of suppressants.";

"Not me.";		// 7
"The man we are meeting tonight.";

"We need to be careful."; //9
"The Federation has eyes everywhere.";

"Good. The book hides important info."; // 11
"They tell us about the door to use";
"to exit the city that way.";

"That is what they want you to think."; //14

"Just one last thing.";


"That is Ravella.";

//17
/***************************************/
"Doesn't it bother you that you spend";
"your life in a state of drug-induced";
"tranquility?";

//20
"Take this key. Room 2, locker 3B.";
"There is something for you inside.";
"I'll wait here.";

"I've already talked to her.";  // [laurentd75]: correction "talk" -> "talked" (past)
"Now I've got things to do.";

#endif

/*********** FRENCH ********************************/

#ifdef FRENCH
"Salut Ravella.";	// 0
"As-tu eu des problèmes?";
"Non. Rien de particulier.";

"Je meurs de faim et de soif, bien sûr!"; //3

"Et comment te sens-tu?"; // 4
"Tu es mieux à jeun..."; // "well done" or "bien hecho" doesn't make much sense after he says he's starving!
"La nourriture est bourrée de drogues..."; // mieux qu'"inhibiteurs" ou tranquilisants, calmants, euphorisants ?

"Moi, non. Mais l'homme que nous";		// 7
"allons voir ce soir en a, lui.";

"Non, nous devons être prudents."; //9
"La Fédération a des yeux partout...";

"Bien. Il contient des infos vitales."; // 11
"Elles nous indiqueront quelle porte il";
"faut emprunter pour sortir de la ville.";

"C'est ce qu'ils veulent que tu croies."; //14

"Juste une dernière chose:";

"C'est Ravella.";

//17
/***************************************/
"Ca ne te dérange pas de mener ta vie";
"dans un état de sérénité artificielle";
"induit par des drogues?";

//20
"Prends cette clé. Porte 2, casier 3B.";
"Il y a quelque chose pour toi dedans.";
"Je t'attendrai ici.";

"Je lui ai déjà parlé.";
"J'ai des choses à faire maintenant.";

#endif

/*********** SPANISH ****************************/

#ifdef SPANISH
"Hola Ravella.";	// 0
"¿Tuviste problemas?";
"No. Nada extraño.";

"¡Muerto de hambre, claro!"; //3

"¿Y cómo te encuentras?"; // 4
"Bien hecho.";
"La comida está llena de supresores.";

"Yo no.";		// 7
"El hombre al que conocerás hoy.";

"Tenemos que tener cuidado."; //9
"La Federación tiene mil ojos.";

/***************************************/
"Bien. Esconde información vital."; // 11
"Nos dicen la puerta que hay que usar";
"para salir de la ciudad de ese modo.";

"Eso es lo que quieren que creas."; //14

"Una última cosa.";

"Esa es Ravella.";

//17
/***************************************/
"¿No te preocupa pasar tu vida en un";
"estado de tranquilidad inducido a";
"través de drogas?"; 

//20
"Ten esto. Puerta 2, taquilla 3B."; 
"Hay algo para tí dentro.";
"Yo te espero aquí.";

"Ya he hablado con ella.";
"Ahora tengo que hacer.";
#endif

}


objectcode RAVELLA
{
	byte actor;
	LookAt: 
		actor=sfGetActorExecutingAction();
		scActorTalk(actor,DIALOG_STRINGS,16);
		scWaitForActor(actor);
		scStopScript();
	TalkTo:
		if(bMetRavella){
			scCursorOn(false);
			actor=sfGetActorExecutingAction();
			scActorTalk(actor,DIALOG_STRINGS,23);
			scWaitForActor(actor);
			scActorTalk(actor,DIALOG_STRINGS,24);
			scWaitForActor(actor);			
			scCursorOn(true);
			scStopScript();
		}
			
		scCursorOn(false);
		actor=sfGetActorExecutingAction();
		scActorTalk(actor,DIALOG_STRINGS,0);
		scWaitForActor(actor);
		scLookDirection(RAVELLA, FACING_LEFT);	
		scActorTalk(RAVELLA,DIALOG_STRINGS,1);
		//scLookDirection(RAVELLA, FACING_DOWN);	
		scWaitForActor(RAVELLA);
		scActorTalk(actor,DIALOG_STRINGS,2);
		scWaitForActor(actor);
		scCursorOn(true);
		scLoadDialog(DIALOG_1);
		scStartDialog();
}


/* Object code for some props */
objectcode CAMERA1{
	LookAt:
		scActorTalk(BLAKE,DESC_STRINGS,0);
		scStopScript();
}

objectcode CAMERA2{
	LookAt:
		scActorTalk(BLAKE,DESC_STRINGS,1);
		scWaitForActor(BLAKE);
		if(!bCamCodeSeen)
		{	
			scSave();
			bCamCodeSeen=true;
		}
		if(bCamDeactivated)
		{
			scActorTalk(BLAKE,DESC_STRINGS,9);
			scWaitForActor(BLAKE);
		}
		scStopScript();
}


stringpack DESC_STRINGS
{
#ifdef ENGLISH
	"Omnipresent.";
	"The camera code is CH-1337.";
	"That is a door to the service area.";
	// 3
	"Looks comfortable...";  // [laurentd75]: correction confortable -> comfortable
	"Not the right time for rest.";
	
	"My back hurts. Not again.";

	"It is quite heavy, but I'll try..";
	"Nope... it's too heavy to move.";
	"Hey! Look what's down here!";
	
	//9
	"This camera seems to be off.";
	
	"That's not a good idea.";
	"That camera there would notice me";
	"and the automatic detection system";
	"would issue an alarm.";
	
	//14
	"Why? That's only a service corridor.";
	
	//15
	"And heavy too...";
	"I bet nobody cleans beneath it.";
#endif

#ifdef FRENCH
	"Omniprésentes, ces caméras...";
	"Le code de la caméra est CH-1337.";
	"Une porte vers la zone de service.";
	// 3
	"Il a l'air confortable...";
	"Ce n'est pas le moment de se reposer.";
	
	"J'ai mal au dos, il vaut mieux pas...";

	"Il est lourd, mais je vais essayer...";
	"Non... Il est trop lourd à déplacer.";
	"Hé! Mais qu'y a-t-il là-dessous?";
	
	//9
	"Cette caméra semble éteinte.";
	
	"Ce n'est pas une bonne idée.";
	"Cette caméra là-haut me détecterait";
	"et le système de surveillance";
	"automatique déclencherait une alarme.";
	
	//14
	"Pourquoi? C'est un couloir de service.";
	
	//15
	"Et très lourd aussi!";
	"Personne ne doit nettoyer en-dessous...";
#endif


#ifdef SPANISH
	"Omnipresentes.";
	"El código de la cámara es CH-1337.";
	"Una puerta al área de servicio.";
	// 3
	"Parece confortable...";
	"No es momento para descansar.";
	
	"Me duele la espalda. Mejor lo dejo.";

	"Es muy pesado, pero lo intentaré...";
	"Nada. Demasiado pesado para moverlo.";
	"¡Eh! ¡Mira lo que hay aquí debajo!";
	
	//9
	"Esta cámara parece apagada.";
	
	"No es buena idea.";
	"La cámara me captará y el sistema de";
	"detección automático de intrusos";
	"lanzará una alarma.";
	
	//14
	"¿Por? Sólo es un corredor de servicio.";

	//15
	"Y pesado también.";
	"Fijo que nadie limpia debajo.";
	
#endif
}


objectcode SDOOR
{
	LookAt:
		scActorTalk(BLAKE,DESC_STRINGS,2);
		scStopScript();
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}	
	Open:		
	WalkTo:
		if (!bGotMap)
		{
			scActorTalk(BLAKE,DESC_STRINGS,14);
			scWaitForActor(BLAKE);
			scStopScript();
		}			
		
		if(bCamDeactivated)
		{
			scSetPosition(BLAKE,ROOM_SERVCORR,14,67);
			scChangeRoomAndStop(ROOM_SERVCORR);			
		}
		else
		{
			scCursorOn(false);
			scActorTalk(BLAKE,DESC_STRINGS,10);
			scWaitForActor(BLAKE);
			scActorTalk(BLAKE,DESC_STRINGS,11);
			scWaitForActor(BLAKE);
			scActorTalk(BLAKE,DESC_STRINGS,12);
			scWaitForActor(BLAKE);
			scActorTalk(BLAKE,DESC_STRINGS,13);
			scWaitForActor(BLAKE);
			scCursorOn(true);
		}
		//scStopScript();
}

objectcode EXITHALLWAY
{
	WalkTo:
		scSetPosition(BLAKE,ROOM_HALLWAY,13,124);
		scChangeRoomAndStop(ROOM_HALLWAY);
		//scStopScript();	
}

objectcode COUCH
{
	byte tmpanimstate;
	LookAt:
		scCursorOn(false);
		scActorTalk(BLAKE,DESC_STRINGS,3);
		scWaitForActor(BLAKE);
		scActorTalk(BLAKE,DESC_STRINGS,15);
		scWaitForActor(BLAKE);
		scActorTalk(BLAKE,DESC_STRINGS,16);
		scWaitForActor(BLAKE);
		scCursorOn(true);
		scStopScript();
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}
		scActorTalk(BLAKE,DESC_STRINGS,4);
		scStopScript();
	Push:
		if(bCouchPushed)
			scActorTalk(BLAKE,DESC_STRINGS,5);
		else{
			scCursorOn(false);
			scActorTalk(BLAKE,DESC_STRINGS,6);
			scWaitForActor(BLAKE);
			tmpanimstate=sfGetAnimstate(BLAKE);
			scSetAnimstate(BLAKE,3);
			scDelay(10);
			scSetAnimstate(BLAKE,tmpanimstate);
			scDelay(20);
			scSetAnimstate(BLAKE,3);
			scDelay(10);
			scSetAnimstate(BLAKE,tmpanimstate);
			scDelay(5);			
			scActorTalk(BLAKE,DESC_STRINGS,7);
			scWaitForActor(BLAKE);
			scDelay(5);
			scActorTalk(BLAKE,DESC_STRINGS,8);
			scWaitForActor(BLAKE);
			scPutInInventory(COIN);
			bCouchPushed=true;
			scSave();
			scCursorOn(true);
		}
}

script 200{
	if(!bMetRavella)
		scLoadObjectToGame(RAVELLA);
	/*
	if(bMetRavella && !bGuardWentForCoffee)
	{
		// Time to send the guard for coffee
		bGuardWentForCoffee=true;
		scSetPosition(GUARD,255,0,0);
	}*/
	
	tmpParam1=CAMERA1;
	scClearEvents(1);
	scSpawnScript(201);
	//scBreakHere();
	scWaitEvent(1);
	
	if(!bCamDeactivated)
	{
		tmpParam1=CAMERA2;
		scSpawnScript(201);
		//scBreakHere();
	}
	scStopScript();
}

/*
// Script for handling cameras
script 201
{
	byte CameraID;
	
	// Grab the parameter
	CameraID=tmpParam1;
	scSetEvents(1);
	
loop:
	scDelay(sfGetRandInt(80,110));
	
	scSetAnimstate(CameraID,1);
	scDelay(5);
	scSetAnimstate(CameraID,2);
	scDelay(5);
	scSetAnimstate(CameraID,3);
	
	scDelay(sfGetRandInt(80,110));
	scSetAnimstate(CameraID,2);
	scDelay(5);
	scSetAnimstate(CameraID,1);
	scDelay(5);
	scSetAnimstate(CameraID,0);
	
	goto loop;
}*/

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
	if ( ( (bc>cc) && ((bc-cc)<18) ) || ( (bc<cc) && ( (cc-bc)<18) ) ){
		scPlaySFX(SFX_TRR);
	}
	scSetAnimstate(CameraID,1);
	scDelay(5);
	scSetAnimstate(CameraID,2);
	scDelay(5);
	scSetAnimstate(CameraID,3);
	
	scDelay(sfGetRandInt(80,110));
	if ( ( (bc>cc) && ((bc-cc)<38) ) || ( (bc<cc) && ( (cc-bc)<38) ) ){
		scPlaySFX(SFX_TRR);
	}	
	scSetAnimstate(CameraID,2);
	scDelay(5);
	scSetAnimstate(CameraID,1);
	scDelay(5);
	scSetAnimstate(CameraID,0);
	
	goto loop;
}