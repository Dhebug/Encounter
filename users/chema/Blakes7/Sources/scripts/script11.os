/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

/* The stringpack is contained here. As there is a scLoadRoom call it cannot be local
 or it would be discarded. It can be given any global id, as long as there is no other 
 stringpack resource with the same one. And still it should be locked before calling
 scLoadRoom and unlocked afterwards */


#define STLOCAL	100

// Script that handles the final scenes in episode II
script 11{
	byte i;
	byte who;

	scLockResource(RESOURCE_SCRIPT,100);


	/* We are in the Cygnus Alpha cells, beam people up */
	scShowVerbs(false);
	scActorTalk(BLAKE,STLOCAL,0);
	scWaitForActor(BLAKE);
	scActorTalk(BLAKE,STLOCAL,1);
	scWaitForActor(BLAKE);		

	scClearEvents(1);
	scPlaySFX(SFX_TELEPORT);
	tmpParam1=VILA;
	scClearEvents(2);
	scSpawnScript(6);
	scWaitEvent(2);	
	tmpParam1=GAN;
	scChainScript(6);
	
	scSetPosition(VILA,ROOM_LIBTELEPORT,12,20);
	scSetPosition(GAN,ROOM_LIBTELEPORT,15,18);
	scLookDirection(VILA,FACING_LEFT);
	scLookDirection(GAN,FACING_LEFT);

	
	scClearEvents(1);
	scPlaySFX(SFX_TELEPORT);
	tmpParam1=BLAKE;
	scChainScript(6);
	

	/* Now change to liberator teleport room and make Blake and Vargas teleport in */

	scLoadObjectToGame(VARGAS); // When testing VARGAS may never have been loaded.
	scLockResource(RESOURCE_STRING,STLOCAL);
	scLoadRoom(ROOM_LIBTELEPORT);
	
	scClearEvents(1);
	scPlaySFX(SFX_TELEPORT);

	scClearEvents(2);
	tmpParam1=VARGAS;	
	tmpParam2=14;
	tmpParam3=0;
	scSpawnScript(7);
	scWaitEvent(2);
	tmpParam1=BLAKE;
	tmpParam2=13;
	tmpParam3=2;
	scChainScript(7);
	
	/* Ready for the end sequence */
	scDelay(50);
	
	scActorWalkTo(VARGAS,5,14);
	scWaitForActor(VARGAS);
	scLookDirection(VARGAS,FACING_RIGHT);
	scBreakHere();
	
	scActorTalk(VARGAS,STLOCAL,2);
	scWaitForActor(VARGAS);	
	scSetCostume(VARGAS,17,1);
	scBreakHere();
	
	for (i=3;i<=18;i=i+1){
		if(i==4) {			
			scActorWalkTo(BLAKE,10,14);
			scWaitForActor(BLAKE);
			scLookDirection(BLAKE,FACING_LEFT);
			scBreakHere();
		}
		who=VARGAS;
		if(i==7) who=AVON;
		if((i==9)||(i==10)) who=BLAKE;
		scActorTalk(who,STLOCAL,i);
		scWaitForActor(who);
		
		if(i==16){
			scSpawnScript(100);
			// Wait for Blake to push Vargas!
			scShowVerbs(true);
			scClearEvents(4);
			scWaitEvent(4);
			scShowVerbs(false);
			// Say Don't move!
			//scActorTalk(VARGAS,STLOCAL,37);
			//scWaitForActor(VARGAS);			
		}
	}
	scTerminateScript(100);
	scUnlockResource(RESOURCE_SCRIPT,100);

	scSetAnimstate(VARGAS,1);
	scPrint(STLOCAL,19);
	scSetAnimstate(AVON,3);
	scDelay(50);
	scClearEvents(1);
	scPlaySFX(SFX_TELEPORT);
	tmpParam1=VARGAS;
	scSetAnimstate(AVON,0);
	scChainScript(6);
	scPrint(STLOCAL,20);
	
	scLookDirection(BLAKE,FACING_RIGHT);
	scBreakHere();
	scActorTalk(BLAKE,STLOCAL,21);
	scWaitForActor(BLAKE);
	scDelay(60);
	scActorTalk(AVON,STLOCAL,22);
	scWaitForActor(AVON);
	scPlaySFX(SFX_SUCCESS);
	scWaitForTune();
	scRemoveObjectFromGame(VARGAS);
	
	
	// Now Jenna enters
	scSetPosition(JENNA,ROOM_LIBTELEPORT,10,23);
	scLookDirection(JENNA,FACING_DOWN);
	scLookDirection(GAN,FACING_RIGHT);
	scLookDirection(VILA,FACING_RIGHT);
	scBreakHere();
	for (i=23;i<=26;i=i+1){
		scActorTalk(JENNA,STLOCAL,i);
		scWaitForActor(JENNA);
	}
	
	scActorTalk(BLAKE,STLOCAL,27);
	scWaitForActor(BLAKE);
	scActorTalk(BLAKE,STLOCAL,28);
	scWaitForActor(BLAKE);

	scActorTalk(VILA,STLOCAL,29);
	scWaitForActor(VILA);
	scActorTalk(VILA,STLOCAL,30);
	scWaitForActor(VILA);
	
	for (i=31;i<=34;i=i+1){
		scActorTalk(BLAKE,STLOCAL,i);
		if(i==31)
		 scLookDirection(VILA,FACING_LEFT);
		scWaitForActor(BLAKE);
	}

	scActorTalk(VILA,STLOCAL,35);
	scWaitForActor(VILA);
	scActorTalk(AVON,STLOCAL,36);
	scLookDirection(VILA,FACING_RIGHT);	
	scWaitForActor(AVON);
	
	scPlaySFX(SFX_MINITUNE1);
	scWaitForTune();	
	scSetBWPalette();
	scPlayTune(ENDEP_TUNE);
	scWaitForTune();	
		
		
	scUnlockResource(RESOURCE_STRING,STLOCAL);	
	//scShowVerbs(true);
	scClearRoomArea();
	scSave();
	scSpawnScript(15);
}

stringpack STLOCAL{
#ifdef ENGLISH	
	/***************************************/
	"Avon, this is Blake.";
	"I found them! Bring us up.";
	
	"Ha ha! I knew it!";
	
	//3
	"Now stand back all of you!";
	"I am aiming a weapon, am I not?";
	"You'll take this ship down to the";
	"surface.";
	//7
	"We're already moving away.";
	"Then get it back.";
	
	//9
	"If you kill us, there is no way you";
	"can run this ship.";
	
	//11
	"I ruled. A small prison planet with";
	"never more than five hundred people.";
	"But with this. With this I could rule";
	"a thousand planets!";
	
	"For that prize, do you think I would";
	"hesitate to kill you? -- NOW!";
	
	"I was their priest. I shall return to";
	"them a god...";
	
	"\A_FWWHITE+A_FWGREEN*8+192 A GOOOOOD!";
	" ";
	//21
	/***************************************/
	"Good! You teleported him into space!";
	"He was causing me a headache.";
	
	//23
	"Blake! Zen has detected a fleet";
	"of ships coming to this system.";
	"He identified them as Federation";
	"pursuit ships.";
	
	//27
	"Okay, set a course to get away from";
	"them. Maximum speed.";
	
	//29
	"If we can outrun them, we have the";
	"whole universe to hide in.";
	
	//31
	"Except that we're not going to hide.";
	"Very soon now the Federation ships will";
	"know exactly where we are.";
	"Or at least where we've been.";
	
	//35
	"I don't follow you.";
	"Oh, but you do. And that's the problem.";
	
	//37
	"I said don't move!";
	
#endif

#ifdef FRENCH	
	/***************************************/
	"Avon, c'est Blake.";
	"Je les ai trouvés! Ramene-nous!";
	
	"Ha ha! Je le savais!";
	
	//3
	"Maintenant, reculez-vous tous!";
	"J'ai une arme pointée sur vous, non?";
	"Vous allez faire atterrir ce vaisseau";
	"a la surface immédiatement.";
	//7
	"Mais on s'éloigne déja de la planete.";
	"Alors faites demi-tour.";
	
	//9
	"Si vous nous tuez, vous ne pourrez";
	"jamais piloter ce vaisseau.";
	
	//11
	"Je régnais sur une petite planete";
	"prison de moins de 500 personnes.";
	"Mais avec ca... Avec ca, je pourrais";
	"régner sur un millier de planetes!";
	
	"Pour un tel enjeu, croyez-vous que";
	"j'hésiterais a vous tuer? ALLONS!";
	
	"J'étais leur pretre... Maintenant";
	"je vais devenir leur dieu...";
	
	"\A_FWWHITE+A_FWGREEN*8+192 LEUR DIEUUU!";
	" ";
	//21
	/***************************************/
	"Bien! Tu l'as téléporté dans l'espace!";
	"Il commencait a me faire mal au crane.";
	
	//23
	"Blake! Zen a détecté une flotte de";
	"vaisseaux venant vers ce systeme.";
	"Il les a identifiés comme étant des";
	"vaisseaux de poursuite fédéraux.";
	
	//27
	"Ok, définis un cap pour leur échapper.";
	"Vitesse maximale.";
	
	//29
	"Si nous pouvons les semer, nous aurons";
	"l'univers entier pour nous cacher.";
	
	//31
	"Sauf que nous n'allons pas nous cacher.";
	"Bientot, les vaisseaux de la Fédération";
	"sauront exactement ou nous sommes.";
	"Ou au moins ou nous avons été.";
	
	//35
	"Je ne te suis pas.";
	"Ah, mais si. Et la est le probleme...";
	
	//37
	"J'ai dit ne bougez pas!";
	
#endif

#ifdef SPANISH
	/***************************************/
	"Avon, soy Blake.";
	"Les he encontrado. Súbenos.";
	
	"¡Jajaja! ¡lo sabía!";
	
	//3
	"¡Atrás todo el mundo!";
	"Esto es un arma, ¿verdad?";
	"Llevaréis esta nave a la superficie";
	"inmediatamente.";
	//7
	"Ya nos estamos alejando del planeta.";
	"Pues da la vuelta.";
	
	//9
	"Si nos asesinas no habrá manera de";
	"que puedas pilotar esta nave.";
	
	//11
	"Yo gobernaba. Un pequeño planeta";
	"prisión con nunca más de 500 personas.";
	"Pero con esto. ¡Con esto yo podría";
	"gobernar mil planetas!";
	
	"Con esa recompensa ¿piensas que";
	"dudaría lo más mínimo? -- ¡AHORA!";
	
	"Yo fui su Sacerdote. Ahora regresaré";
	"como su dios...";
	
	"\A_FWWHITE+A_FWGREEN*8+192 ¡SU DIOOOOOOOS!";
	" ";
	//21
	/***************************************/
	"¡Bien! ¡lo teleportaste al espacio!";
	"Me estaba levantando dolor de cabeza.";

	
	//23
	"¡Blake! Zen ha detectado una flota";
	"de naves dirigiéndose a este sistema.";
	"Los ha identificado como naves de";
	"persecución de la Federación.";
	
	//27
	"De acuerdo. Marca un curso para";
	"alejarnos de ellos. Velocidad máxima.";
	
	//29
	"Si somos más rápidos que ellos tenemos";
	"todo el universo para escondernos.";
	
	//31
	"Solo que no nos esconderemos.";
	"Pronto la Federación tendrá noticias";
	"exactas de dónde estamos.";
	"O al menos de dónde hemos estado.";
	
	//35
	"No te sigo.";
	"Pero lo haces. Ese es el problema.";	

	//37
	"¡He dicho que no os mováis!";
#endif
}		
		
		
		
// Avoid Blake moving
// I keep this script as global as I did for the fading colors in the intro
// it is a trick to avoid it to be discarded at the scLoadRoom. In addition
// I have to lock it and unlock when necessary.
// Same thing is used for the strings. Both resources are ID 100.
// BEWARE! No saving/restoring in the midpoint of this script!!!
script 100{
	if( (sfGetCol(BLAKE)!=10) || (sfGetRow(BLAKE)!=14) )
	{
		scCursorOn(false);		
		scActorTalk(VARGAS,STLOCAL,37);
		scStopCharacterAction(BLAKE);		
		scWaitForActor(VARGAS);
		scActorWalkTo(BLAKE,10,14);
		scWaitForActor(BLAKE);
		scLookDirection(BLAKE,FACING_LEFT);
		scCursorOn(true);
	}
	scDelay(2);
	scRestartScript();
}
		