
/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

#define ST_INTRO	107

#define TIMING		120

/* 2nd part of the intro to episode 3           */
/* I made this script global because else it'd  */
/* get nuked when changing rooms, so this was   */
/* easier...					*/
script 16
{	
	byte i;
	byte a;
		
	// Lock the stringpack so it is not nuked when changing rooms
	scLockResource(RESOURCE_STRING,ST_INTRO);
	scSetFadeEffect(1);
	bBallDefeated=true; // This is for testing
	
	// Remove the lamp from the inventory
	scRemoveFromInventory(LAMP);
	
	scLoadRoom(ROOM_LIBDECK);
	
	// I guess these will be already loaded, but it does
	// no harm to make sure.
	scLoadObjectToGame(GAN);
	scLoadObjectToGame(AVON);
	//scLoadObjectToGame(BLAKE);
	scLoadObjectToGame(JENNA);
	scLoadObjectToGame(VILA);	
	
	// Put them where they should be
	scSetPosition(GAN,ROOM_LIBDECK,12,17);
	scLookDirection(GAN,FACING_DOWN);
	scSetPosition(AVON,ROOM_LIBDECK,11,33);
	scLookDirection(AVON,FACING_RIGHT);
	scSetPosition(JENNA,ROOM_LIBDECK,8,13);
	scLookDirection(JENNA,FACING_DOWN);
	scSetPosition(BLAKE,ROOM_LIBDECK,14,39);
	scLookDirection(BLAKE,FACING_LEFT);
	scSetPosition(VILA,ROOM_LIBDECK,13,47);
	scLookDirection(VILA,FACING_RIGHT);
	scSetCameraAt(sfGetCol(BLAKE));
	
	// Set the destination for ESC press
	scSetOverrideJump(here);
	
	// Issue a break, so the scene is rendered.
	scBreakHere();
	
	for(i=0;i<=8;i=i+1){
		if((i==0)||(i==1)||(i==3)||(i==4)) a=GAN;
		if((i==2)||(i==5)||(i==6)||(i==8)) a=BLAKE;
		if (i==7){
			a=AVON;
			scLookDirection(AVON,FACING_LEFT);
		}
		
		if(i==2){
			scLookDirection(VILA,FACING_LEFT);
			scActorWalkTo(BLAKE,13,12);
			scWaitForActor(BLAKE);
			scLookDirection(BLAKE,FACING_RIGHT);
			scDelay(30);
		} 
		
		scActorTalk(a,ST_INTRO,i);
		scWaitForActor(a);
	}
	for(i=9;i<=17;i=i+1){
		if( (i>=12)&&(i<=14) ) a=BLAKE; 
		else a=AVON;
		scActorTalk(a,ST_INTRO,i);
		scWaitForActor(a);		
	}

	for(i=18;i<=32;i=i+1){
		a=AVON;
		if((i==18)||(i==19)||(i==23)||(i==24)) a=BLAKE;
		if((i==28)) a=GAN;

		if(i==19) scPanCamera(32);

		if(i==20){
			scPrint(ST_INTRO,i);
			scChainScript(203); 	// Zen talks using script 203
		}
		else{
			scActorTalk(a,ST_INTRO,i);
			scWaitForActor(a);					
		}
	}		
	
	for(i=33;i<=39;i=i+1){
		a=JENNA;
		if(i==37) a=VILA;
		
		scActorTalk(a,ST_INTRO,i);
		scWaitForActor(a);		
	}
	
	scActorTalk(BLAKE,ST_INTRO,40);
	scWaitForActor(BLAKE);	
	scDelay(50);
	
here:
	// Back to the teleport. Avon talks about the transponder
	// And Blake and Jenna are teleported down to the surface
	scClearRoomArea();
	scLoadRoom(ROOM_LIBTELEPORT);
	scSetPosition(AVON,ROOM_LIBTELEPORT,15,32);
	scLookDirection(AVON,FACING_LEFT);
	scSetPosition(JENNA,ROOM_LIBTELEPORT,13,2);
	scLookDirection(JENNA,FACING_RIGHT);
	scSetPosition(BLAKE,ROOM_LIBTELEPORT,14,0);
	scLookDirection(BLAKE,FACING_RIGHT);
	if(!sfIsObjectInInventory(BRACELET))
		scPutInInventory(BRACELET);
	if(!sfIsObjectInInventory(GUN))
		scPutInInventory(GUN);
	if(!sfIsObjectInInventory(BRACELETS))
		scPutInInventory(BRACELETS);
	scBreakHere();
	//scSetOverrideJump(here2);
	
	for(i=41;i<=46;i=i+1){
		scActorTalk(AVON,ST_INTRO,i);
		scWaitForActor(AVON);
	}
	scActorTalk(BLAKE,ST_INTRO,47);
	scWaitForActor(BLAKE);

	// Teleport
	scClearEvents(1);
	scPlaySFX(SFX_TELEPORT);
	tmpParam1=BLAKE;
	scClearEvents(2);
	scSpawnScript(6);
	scWaitEvent(2);		
	tmpParam1=JENNA;
	scChainScript(6);

	scLoadRoom(ROOM_FOREST);
	scBreakHere();

	scClearEvents(1);
	scPlaySFX(SFX_TELEPORT);
	
	scClearEvents(2);
	tmpParam1=JENNA;	
	tmpParam2=12;
	tmpParam3=14;
	scSpawnScript(7);
	scWaitEvent(2);
	tmpParam1=BLAKE;
	tmpParam2=9;
	tmpParam3=17;
	scChainScript(7);	
	
	// Continue the scene...
	scDelay(30);
	scActorTalk(JENNA,ST_INTRO,48);
	scWaitForActor(JENNA);
	scActorTalk(JENNA,ST_INTRO,49);
	scWaitForActor(JENNA);
	scActorWalkTo(JENNA,38,12);
	scWaitForActor(JENNA);
	scSetPosition(JENNA,ROOM_SWAMP,10,2);
	scActorWalkTo(BLAKE,38,9);
	scWaitForActor(BLAKE);
	scLoadRoom(ROOM_SWAMP);
	scSetPosition(BLAKE,ROOM_SWAMP,12,0);	
	scDelay(30);		
	scActorTalk(JENNA,ST_INTRO,50);
	scWaitForActor(JENNA);
	scPanCamera(25);
	scWaitForCamera();
	scDelay(50);
	scPanCamera(0);
	scActorTalk(JENNA,ST_INTRO,51);
	scWaitForActor(JENNA);
here2:	
	// Unkock the stringpack, we're done.
	scUnlockResource(RESOURCE_STRING,ST_INTRO);
	// Let's put the fade effect we are using all the time back
	scSetFadeEffect(1+128);
	
	// Initialize variables
	bLogTaken=false;
	bCenteroOrbit=true;
	bCygnusOrbit=false;
	//bCellPlaced=false; Initialized in script 0
	bDoorPuzzleDone=false;
	bIntroBaseDone=false;
	bCouplet1Known=false;
	bCouplet2Known=false;
	bCouplet3Known=false;
	bCouplet4Known=false;
	bCouplet5Known=false;
	bCupTaken=false;
	bGuardLeftCommon=false;
	bLaundryMesgSeen=false;
	bUniformTaken=false;
	bShiftTimeFound=false;
	bClockTampered=false;
	bGuardLeftCells=false;
	bCellFound=false;
	bCallyFound=false;
	bSwitchInstalled=false;
	bTransmitterInstalled=false;
	
	
	
	// Show verbs back, save and finish.
	scShowVerbs(true);
	scSave();
}


stringpack ST_INTRO{
#ifdef ENGLISH
/***************************************/
// Gan 0,1
"Blake!";
"Look at this message we intercepted.";
//Blake 2
"Ravella...";
//Gan 3,4
"She's been transferred to Centero for";
"interrogation and purging.";
//Blake 5,6
"They'll destroy her there.";
"We have to prevent it.";
//Avon 7
"And what do you propose?";
//Blake 8
"We'll rescue her.";

//Avon 9,10,11
"I thought it was agreed we wouldn't";
"do anything without discussing it";
"thoroughly.";
//Blake 12, 13, 14
"It was also agreed that anybody could";
"opt out at any time.";
"Just tell me when you want to leave.";
/***************************************/
//Avon 15,16,17
"Oh, I will. But in the meantime I think";
"we have a right to know what it is";
"you're planning.";



//Blake 18,19
"Zen, set a course for Centero,";
"speed standard by two.";
//Zen, 20
" Speed and course confirmed.";
//Avon 21, 22
"That falls a little short of my idea";
"of a thorough discussion.";
//BLake 23,24
"She was a leader of the resistance.";
"And a good friend.";
// Avon 25,26,27
"Another idealist, poor but honest.";
"I shall look forward to our meeting";
"with eager anticipation.";

//Gan 28
"How will we enter the detention area?";
//Avon 29,30,31,32
"Those installations are shielded";
"against scanners. With no information";
"I cannot teleport you inside.";
"You'll have to find a way in.";

//Jenna  33, 34, 35,36
"I knew a group of traders who used to";
"operate in Centero. They got their";
"share of drugs from the base.";
"They had access to the service tunnels.";

//Vila  37
"Had?...";
//Jenna 38,39
"The Feds found out. They used lethal";
"gas to kill everyone.";
//Blake 40
"That'll be our way in.";

/***************************************/
// At the teleport
//Avon 41-46
"I've given Jenna a transponder which";
"will adapt the signal of the bracelet";
"so it can pass through the shield.";
"That way I can teleport you, and";
"anyone wearing a bracelet near you";
"back even from inside a cell.";

//Blake 47
"Great. Put us down, then.";

// Jenna 48
"There was an entrance through a cave.";
"This way.";
"There you are. That cave over there.";
"But there was a bridge to cross...";

#endif

#ifdef FRENCH
/***************************************/
// Gan 0,1
"Blake!";
"Regarde ce message qu'on a intercepté.";
//Blake 2
"Ravella...";
//Gan 3,4
"Elle a été transférée sur Centero pour";
"y etre interrogée et y purger sa peine.";
//Blake 5,6
"Ils la détruiront, la-bas...";
"Nous devons les en empecher.";
//Avon 7
"Et que proposes-tu?";
//Blake 8
"Nous allons aller la sauver.";

//Avon 9,10,11
"Je croyais qu'on s'était mis d'accord";
"qu'on ne ferait rien sans en discuter";
"de facon approfondie.";
//Blake 12, 13, 14
"On était aussi d'accord que chacun";
"pourrait partir quand il le voudrait.";
"Si tu souhaites partir, dis-le moi.";
/***************************************/
//Avon 15,16,17
"Oh, je le ferai. Mais en attendant,";
"je pense que nous avons le droit de";
"savoir ce que tu projettes de faire."; // ou "ce que tu prépares"



//Blake 18,19
"Zen, fais route vers Centero,";
"vitesse standard fois deux.";
//Zen, 20
" Route et vitesse confirmées.";
//Avon 21, 22
"Ce n'est pas exactement l'idée que je";
"me faisais d'une discussion sérieuse.";
//BLake 23,24
"C'était une chef de la résistance...";
"... et une bonne amie.";
// Avon 25,26,27
"Une autre idéaliste..."; // [laurentd75]: adding "pauvre mais honnete." would exceed max line length and add nothing to the storyline
"Il me tarde de la rencontrer afin de";
"découvrir qui elle est vraiment.";

//Gan 28
"Comment entrerons-nous dans la prison?";
//Avon 29,30,31,32
"Ces installations sont protégées contre"; // [laurentd75] "à l'épreuve des" ou "protégées contre"
"les scanners. Sans plus d'informations,";
"je ne peux pas vous y téléporter. Il";
"faut trouver un autre moyen d'entrer.";

//Jenna  33, 34, 35,36
"Je connaissais un groupe de trafiquants";
"sur Centero qui passaient la drogue via";
"des complices dans la base. Ils avaient";
"acces aux tunnels de service.";

//Vila  37
"Ils avaient?...";
//Jenna 38,39
"Les Fédéraux l'ont découvert. Ils les";
"ont tous éliminés avec un gaz mortel.";
//Blake 40
"Et bien voila par ou nous entrerons."; // ou: "Et bien ce sera notre porte d'entrée."

/***************************************/
// At the teleport
//Avon 41-46
"J'ai donné un transpondeur a Jenna qui";
"adapte le signal des bracelets pour"; // [laurentd75]: see also "ocode_trasponder.os"
"qu'il puisse pénétrer le blindage."; // "qu'il puisse passer a travers le blindage.";
"De cette facon je pourrai vous faire";
"revenir, ainsi que quiconque portant";
"un bracelet, meme depuis une cellule.";

//Blake 47
"Excellent. Envoie-nous la-bas alors.";

// Jenna 48
"On entrait a partir d'une grotte.";
"Par ici...";
"Voila. Cette grotte la-bas... Mais";
"il y avait un pont pour traverser...";

#endif

#ifdef SPANISH
/***************************************/
// Gan 0,1
"Blake!";
"Mira este mensaje que interceptamos.";
//Blake 2
"Ravella...";
//Gan 3,4
"La han enviado a Centero para";
"interrogarla.";
//Blake 5,6
"La destruirán allí.";
"Tenemos que evitarlo.";
//Avon 7
"¿Y qué propones?";
//Blake 8
"La rescataremos.";

//Avon 9,10,11
"Pensé que habíamos quedado en que";
"no haríamos nada sin discutirlo";
"primero a fondo.";
//Blake 12, 13, 14
"También acordamos que cualquiera";
"podía dejarlo cuando quisiera.";
"Solo dime cuándo quieres irte.";
/***************************************/
//Avon 15,16,17
"Oh, lo haré, pero mientras pienso que";
"tenemos derecho a saber que es lo que";
"tienes planeado.";

//Blake 18,19
"Zen, pon rumbo a Centero.";
"Velocidad estándar por dos";
//Zen, 20
" Velocidad y rumbo confirmados.";
//Avon 21, 22
"Eso no se parece para nada a mi idea";
"de una discusión a fondo.";
//BLake 23,24
"Era una líder de la resistencia.";
"Y una gran amiga.";

// Avon 25,26,27
"Otra idealista, pobre pero honesta.";
"No puedo esperar a que llegue el";
"momento de conocerla.";

//Gan 28
"¿Cómo entraremos en el bloque prisión?";
//Avon 29,30,31,32
"Esas instalaciones están apantalladas";
"contra escáneres. Sin información no";
"puedo teleportaros dentro.";
"Deberéis encontrar el modo de entrar.";

//Jenna  33, 34, 35,36
"Conocí un grupo de comerciantes que";
"solían operar en Centero. Conseguían";
"su suministro de drogas de la base.";
"Tenían un acceso al túnel de servicio.";

//Vila  37
"¿Tenían?...";
//Jenna 38,39
"Los Federales lo averiguaron. Usaron";
"gas letal para eliminarlos a todos.";
//Blake 40
"Entraremos por ahí.";

/***************************************/
// At the teleport
//Avon 41-46
"Dí a Jenna un transpondedor que adapta";
"la señal de la pulsera para que pueda";
"atravesar la pantalla. De ese modo";
"podré teleportaros, a todos los que";
"estéis cerca y llevéis la pulsera, de";
"nuevo a bordo, incluso desde una celda";

//Blake 47
"Perfecto. Bájanos, entonces.";

// Jenna 48
"Se entraba a través de una cueva.";
"Por aquí.";
"Ahí está. La cueva al otro lado.";
"Pero había un puente para cruzar...";

#endif	
}



