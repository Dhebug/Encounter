/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

#define ST_LONDONDECK	103

#define DELTALK 75

/* Script with that manages the scene where the */
/* London meets the Liberator			*/
/* I made this script global because else it'd  */
/* get nuked when changing rooms, so this was   */
/* easier...					*/
script 4
{	
	byte i;

	if(bBallDefeated){
		// This is the moment when the Liberator Leaves
		for (i=37; i<52; i=i+1){
			scPrint(ST_LONDONDECK,i);
			scDelay(120);
		}
		scPrint(ST_LONDONDECK,36);
		scPlaySFX(SFX_MINITUNE1);
		scWaitForTune();
		
		scChangeRoomAndStop(ROOM_LIBDECK);
	}
	
	
	scSetOverrideJump(here);
	scLockResource(RESOURCE_STRING,ST_LONDONDECK);	
	
	// Conversation in the London's Deck	
	for (i=0; i<=36; i=i+1){
		scPrint(ST_LONDONDECK,i);
		scDelay(120);
		
		if(i==7)
			scLoadRoom(200);
		/*if(i==27)
			scLoadRoom(18);*/
	}
	
	scPlaySFX(SFX_MINITUNE1);
	scWaitForTune();
	
here:
	scUnlockResource(RESOURCE_STRING,ST_LONDONDECK);
	scFadeToBlack();
	
	
	// Load some objects at the Liberator
	scLoadObjectToGame(SCISSORS); 
	scSetAnimstate(SCISSORS,1);
	scLoadObjectToGame(WRENCH);
	scSetAnimstate(WRENCH,4);
	scLoadObjectToGame(PLIERS);
	scSetAnimstate(PLIERS,3);
	scLoadObjectToGame(SPRAY);
	scSetAnimstate(SPRAY,2);

	// Change to liberator /interior with Blake, Avon and Jenna.
	scSetPosition(AVON, ROOM_LIBPASS, 16,25);
	scLookDirection(AVON,FACING_UP);
	scSetPosition(BLAKE, ROOM_LIBPASS, 16,18);
	scLookDirection(BLAKE,FACING_RIGHT);
	scLoadObjectToGame(JENNA);
	scSetPosition(JENNA, ROOM_LIBPASS, 16,12);
	scLookDirection(JENNA,FACING_UP);

	
	// Entering the liberator
	scLoadRoom(ROOM_LIBPASS);
	scBreakHere();

	scActorWalkTo(BLAKE,sfGetCol(BLAKE), 14);
	scActorWalkTo(JENNA,sfGetCol(JENNA), 15);
	scActorWalkTo(AVON,sfGetCol(AVON), 15);
	scWaitForActor(BLAKE);
	scLookDirection(BLAKE,FACING_LEFT);
	scWaitForActor(JENNA);
	scLookDirection(JENNA,FACING_RIGHT);
	scWaitForActor(AVON);
	scLookDirection(AVON,FACING_LEFT);
	
	// Conversation in the passageway
	for(i=0;i<=3;i=i+3){
		scActorTalk(JENNA,200,i);
		scWaitForActor(JENNA);
		scActorTalk(AVON,200,i+1);
		scWaitForActor(AVON);
		scActorTalk(BLAKE,200,i+2);
		scWaitForActor(BLAKE);		
	}	
	
	// They move on
	scActorWalkTo(BLAKE,18,11);
	scActorWalkTo(JENNA,19,11);
	scActorWalkTo(AVON,21,13);
	scWaitForActor(BLAKE);
	scWaitForActor(JENNA);
	scWaitForActor(AVON);
	scLookDirection(AVON,FACING_UP);
	scBreakHere();
	
	// Entering deck
	scLoadRoom(ROOM_LIBDECK);
	scSetPosition(BLAKE, ROOM_LIBDECK, 14,12);
	scLookDirection(BLAKE,FACING_RIGHT);
	scSetPosition(JENNA, ROOM_LIBDECK, 16,8);
	scLookDirection(JENNA,FACING_RIGHT);
	scSetPosition(AVON, ROOM_LIBDECK, 13,5);
	scLookDirection(AVON,FACING_RIGHT);
	scDelay(50);
	scActorTalk(JENNA,200,11);
	scWaitForActor(JENNA);
	scActorTalk(AVON,200,12);
	scWaitForActor(AVON);
	
	// Wait until the ballrobot looks at them
loop:
	scBreakHere();
	if(sfGetAnimstate(BALLROBOT)!=0) goto loop;
	scFreezeScript(210,true);
	
	// Hipnotize Jenna
	scPrint(200,0);
	scDelay(DELTALK);
	scPrint(200,3);
	scDelay(DELTALK);
	scPrint(200,4);
	scDelay(DELTALK);
	scActorTalk(JENNA,200,5);
	scWaitForActor(JENNA);
	scActorTalk(JENNA,200,6);
	scWaitForActor(JENNA);
	scSetAnimstate(JENNA,11);

	scFreezeScript(210,false);
	scDelay(50);
	
loop2:
	scBreakHere();
	if(sfGetAnimstate(BALLROBOT)!=0) goto loop2;
	scFreezeScript(210,true);
	
	// Hipnotize Avon
	scPrint(200,1);
	scDelay(DELTALK);
	scPrint(200,3);
	scDelay(DELTALK);
	scPrint(200,4);
	scDelay(DELTALK);
	scActorTalk(AVON,200,7);
	scWaitForActor(AVON);
	scActorTalk(AVON,200,8);
	scWaitForActor(AVON);
	scSetAnimstate(AVON,11);
	
	scFreezeScript(210,false);
	scDelay(50);
loop3:
	scBreakHere();
	if(sfGetAnimstate(BALLROBOT)!=0) goto loop3;
	scFreezeScript(210,true);	
	
	// Try with Blake
	scPrint(200,2);
	scDelay(DELTALK);
	scPrint(200,3);
	scDelay(DELTALK);
	scPrint(200,9);
	scDelay(DELTALK);
	scPrint(200,10);

	scFreezeScript(210,false);
	scBreakHere();
	
	scActorTalk(BLAKE,200,13);
	scWaitForActor(BLAKE);

	
	scShowVerbs(true);
	scSave();
	
	// Simon's bug report: Saving does not keep walkbox state
	// So let's do this here, which is executing after load the
	// above savepoint.
	scSetWalkboxAsWalkable(1,false);
	scSetWalkboxAsWalkable(11,false);
	scSetWalkboxAsWalkable(8,false);
}


stringpack ST_LONDONDECK{
#ifdef ENGLISH
	/**************************************/
	"\A_FWYELLOW All systems working sir.";
	"\A_FWCYAN Let's check our position.";
	"\A_FWCYAN We are surely way off route.";
	
	"\A_FWCYAN Get me a blind reading on that echo.";
	"\A_FWYELLOW Yes, sir.";
	"\A_FWCYAN These readings have got to be wrong!";
	"\A_FWYELLOW We've got the scan back.";
	"\A_FWCYAN Right, get me a picture.";
	
	
	"\A_FWYELLOW I don't believe it!";
	"\A_FWCYAN Take us in as close as you can.";
	"\A_FWYELLOW Yes sir.";
	"\A_FWYELLOW Where could it have come from?";
	"\A_FWCYAN I've never seen a ship like that."; 
	"\A_FWCYAN She seems to be drifting.";
	"\A_FWCYAN Mr. Raiker. Maintain this distance.";
	"\A_FWYELLOW Right, sir.";
	
	"\A_FWYELLOW Readings indicate she is disabled.";
	"\A_FWYELLOW No power, just basic life support.";
	"\A_FWYELLOW No signs of life on board.";
	"\A_FWYELLOW I don't think she could move.";
	"\A_FWYELLOW If she's been completely abandoned...";
	"\A_FWCYAN We could put on a boarding party.";
	"\A_FWCYAN Who knows what could be inside?";
	"\A_FWYELLOW It could be worth millions!";
	"\A_FWCYAN I don't have enough personnel...";
	"\A_FWCYAN and I can't risk anybody boarding an";
	"\A_FWCYAN unknown ship.";
	"\A_FWCYAN There may be some protection system.";
	
	"\A_FWYELLOW Maybe there is another option...";
	"\A_FWYELLOW Those prisoners who rioted...";
	"\A_FWYELLOW They could check if it's safe";
	"\A_FWYELLOW to send a boarding party across.";
	"\A_FWYELLOW If something goes wrong... who'd care?";
	"\A_FWCYAN Wise idea, Mr Raiker.";
	"\A_FWCYAN Send Blake, Avon, and Stannis.";
	"\A_FWYELLOW Yes, sir!";
	" ";

	"\A_FWYELLOW Sir! The unknown ship is moving!";
	"\A_FWYELLOW They have detached and are escaping!";
	"\A_FWCYAN But how? the ship was disabled!";
	"\A_FWYELLOW They cannot be piloting that!";
	"\A_FWCYAN Intercept it! Use our weapons!";
	"\A_FWYELLOW Yes, sir! Arming weapons...";
	"\A_FWCYAN How can they move so fast?";
	"\A_FWYELLOW They are getting out of range, sir.";
	"\A_FWCYAN Follow them at full speed, Mr. Raiker!";
	"\A_FWYELLOW I've lost them! They're gone, sir";
	"\A_FWCYAN What have we done?";
	"\A_FWYELLOW I can try to calculate...";
	"\A_FWCYAN Leave it, Mr. Raiker.";
	"\A_FWCYAN It's too late. Send a report,";
	"\A_FWCYAN and let's continue our mission.";	
#endif

#ifdef FRENCH
	/**************************************<--  max: 38 chars => YELLOW -> col 56, CYAN-> col 54 **/
	"\A_FWYELLOW Tous les systemes sont opérationnels.";
	"\A_FWCYAN Vérifions notre position.";
	"\A_FWCYAN Nous nous sommes écartés de la route.";
	
	"\A_FWCYAN Donnez-moi une lecture de cet écho.";
	"\A_FWYELLOW Oui, monsieur.";
	"\A_FWCYAN Ces données doivent etre incorrectes!";
	"\A_FWYELLOW Nous avons un retour.";
	"\A_FWCYAN Bien, affichez-moi l'image.";
	
	 	
	"\A_FWYELLOW Je ne peux pas le croire!";
	"\A_FWCYAN Approchez-vous aussi pres que possible";
	"\A_FWYELLOW Oui monsieur.";
	"\A_FWYELLOW D'ou peut-il bien provenir?";
	"\A_FWCYAN Je n'ai jamais vu de vaisseau pareil."; 
	"\A_FWCYAN Il a l'air d'etre a la dérive.";
	"\A_FWCYAN M. Raiker, maintenez la distance.";
	"\A_FWYELLOW A vos ordres, monsieur.";
	
	"\A_FWYELLOW Selon nos données, il est désemparé."; // "en panne", "désemparé","avarié" ou "hors d'usage" est mieux que "désactivé"
	"\A_FWYELLOW Seul le systeme de survie fonctionne."; // "systeme de maintien de la vie" : trop long... => "systeme de [sur]vie"?
	"\A_FWYELLOW Aucun signe de vie a bord.";
	"\A_FWYELLOW Il ne peut surement plus se déplacer.";
	"\A_FWYELLOW S'il a été completement abandonné...";
	"\A_FWCYAN On pourrait envoyer une équipe.";
	"\A_FWCYAN Qui sait ce qu'il y a a l'intérieur?";
	"\A_FWYELLOW Ca pourrait valoir des millions!";
	"\A_FWCYAN Je n'ai pas assez de personnel...";
	"\A_FWCYAN et ne veux risquer la vie de personne";
	"\A_FWCYAN en pénétrant dans un vaisseau inconnu,";
	"\A_FWCYAN qui peut avoir un systeme anti-intrus.";

	"\A_FWYELLOW Il y a peut-etre une autre option...";
	"\A_FWYELLOW Ces prisonniers qui se sont mutinés...";
	"\A_FWYELLOW Ils pourraient aller vérifier si on";
	"\A_FWYELLOW peut envoyer une équipe sans risque.";
	"\A_FWYELLOW Si ca tourne mal, qui s'en souciera?";
	"\A_FWCYAN C'est une tres sage idée, M. Raiker.";
	"\A_FWCYAN Envoyez Blake, Avon, et Stannis.";
	"\A_FWYELLOW Oui, monsieur!";
	" ";

	"\A_FWYELLOW Monsieur! Le vaisseau se déplace!";
	"\A_FWYELLOW Ils se sont dégagés et s'échappent!";
	"\A_FWCYAN Mais comment? Il semblait hors d'usage!"; // le vaisseau était désemparé/avarié/désactivé/immobilisé
	"\A_FWYELLOW Ils ne peuvent piloter cet engin-la!";
	"\A_FWCYAN Interceptez-les! Employez les armes!";
	"\A_FWYELLOW Oui monsieur! Activation des armes...";
	"\A_FWCYAN Comment peuvent-ils aller si vite?";
	"\A_FWYELLOW Ils vont passer hors de portée.";
	"\A_FWCYAN Suivez-les a pleine vitesse!";
	"\A_FWYELLOW Je les ai perdus! Ils ont disparu!";
	"\A_FWCYAN Qu'avons-nous fait?";
	"\A_FWYELLOW Je peux essayer de calculer...";
	"\A_FWCYAN Laissez, M. Raiker.";
	"\A_FWCYAN C'est trop tard. Envoyez un rapport,";
	"\A_FWCYAN et continuons notre mission.";	
#endif

#ifdef SPANISH
	/**************************************/
	"\A_FWYELLOW Todos los sistemas listos.";
	"\A_FWCYAN Compruebe nuestra posición.";
	"\A_FWCYAN Nos hemos salido de la ruta.";
	
	"\A_FWCYAN Deme una lectura de ese eco.";
	"\A_FWYELLOW Sí, señor.";
	"\A_FWCYAN ¡Estos datos deben estar mal!";
	"\A_FWYELLOW Tenemos retorno.";
	"\A_FWCYAN Bien, deme la imagen.";
	
	
	"\A_FWYELLOW ¡No puedo creerlo!";  // [laurentd75]: corrected "ceerlo" --> "creerlo"
	"\A_FWCYAN Llévenos tan cerca como pueda.";
	"\A_FWYELLOW Sí, señor.";
	"\A_FWYELLOW ¿De dónde habrá salido?";
	"\A_FWCYAN Nunca he visto algo como eso."; 
	"\A_FWCYAN Parece a la deriva.";
	"\A_FWCYAN Sr. Raiker, mantenga distancia.";
	"\A_FWYELLOW A la orden, señor.";
	          /**************************************/
	"\A_FWYELLOW Según los datos, está deshabilitada.";
	"\A_FWYELLOW Sin energía, sólo soporte vital.";
	"\A_FWYELLOW No hay señales de vida a bordo.";
	"\A_FWYELLOW No creo que pueda moverse.";
	"\A_FWYELLOW Si está abandonada...";
	"\A_FWCYAN Podríamos mandar un equipo.";
	"\A_FWCYAN ¿Quién sabe lo que habrá dentro?";
	"\A_FWYELLOW ¡Podría valer millones!";
	"\A_FWCYAN No tengo suficiente personal...";
	"\A_FWCYAN y no puedo arriesgar a nadie";
	"\A_FWCYAN abordando una nave desconocida.";
	"\A_FWCYAN Podría haber sistemas anti-intrusos.";
	
	"\A_FWYELLOW Igual hay otra opción...";
	"\A_FWYELLOW Los que se amotinaron...";
	"\A_FWYELLOW Que comprueben si es seguro mandar";
	"\A_FWYELLOW un equipo a bordo. Si algo va mal,";
	"\A_FWYELLOW ¿quién va a hacer preguntas?";
	"\A_FWCYAN Buena idea, Sr. Raiker.";
	"\A_FWCYAN Envíe a Blake, Avon, y Stannis.";
	"\A_FWYELLOW ¡Sí, señor!";
	" ";

	"\A_FWYELLOW ¡Señor! ¡La nave se está moviendo!";
	"\A_FWYELLOW ¡Se han soltado y escapan!";
	"\A_FWCYAN ¿Cómo? ¡Estaba deshabilitada!";
	"\A_FWYELLOW ¡No pueden estar pilotándola!";
	"\A_FWCYAN ¡Deténgala! ¡Use las armas!";
	"\A_FWYELLOW Sí señor, preparando armas...";
	"\A_FWCYAN ¿Cómo se mueven tan deprisa?";
	"\A_FWYELLOW Se salen de rango, señor.";
	"\A_FWCYAN ¡Sígalas a toda potencia!";
	"\A_FWYELLOW Las he perdido. Han huído, señor.";
	"\A_FWCYAN ¿Qué hemos hecho?";
	"\A_FWYELLOW Puedo intentar calcular...";
	"\A_FWCYAN Déjelo, Sr. Raiker.";
	"\A_FWCYAN Demasiado Tarde. Emita un informe";
	"\A_FWCYAN y continuemos con la misión.";	
#endif
}


/*
RAIKER	We have power back sir.
LEYLAN	About time.
[Artix enters]

ARTIX	We have normal functions on all systems. They're phasing them in now.
LEYLAN	Have we got scan yet?
ARTIX	Not yet.
LEYLAN	Get me a blind reading on that echo.
ARTIX	It's very close.
RAIKER	These readings have got to be wrong!
ARTIX	We've got the scan back.
LEYLAN	Right, get me a picture.
[Switch to a view of the Liberator]

[Switch back to the flight deck]

RAIKER	I don't believe it!
LEYLAN	Take us in as close as you can Mr. Raiker.
RAIKER	Yes sir.
ARTIX	Where could it have come from?
LEYLAN	I've never seen a ship like that before in my life. She seems to be drifting, Mr. Raiker. Maintain this distance.
RAIKER	Right, sir.*/