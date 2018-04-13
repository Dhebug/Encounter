/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

#define ST_LIBERATORFIRST	104

#define DELTALK 75

/* Script with that manages the scene where the */
/* team take control of the Liberator */
script 5
{	
	byte i;
	
	scShowVerbs(false);

	scLockResource(RESOURCE_STRING,ST_LIBERATORFIRST);	

	for(i=0;i<3;i=i+1){
		scActorTalk(JENNA,ST_LIBERATORFIRST,i);
		scWaitForActor(JENNA);
	}

	scActorTalk(AVON,ST_LIBERATORFIRST,3);
	scWaitForActor(AVON);
	scActorTalk(AVON,ST_LIBERATORFIRST,4);
	scWaitForActor(AVON);

	for(i=5;i<=8;i=i+1){
		scActorTalk(BLAKE,ST_LIBERATORFIRST,i);
		scWaitForActor(BLAKE);
	}
	
	scActorTalk(AVON,ST_LIBERATORFIRST,9);
	scWaitForActor(AVON);

	// Move actors to command chairs:
	scExecuteAction(AVON,VERB_WALKTO,204,255);
	scExecuteAction(JENNA,VERB_WALKTO,203,255);
	scActorWalkTo(BLAKE,22,14);
	scWaitForActor(AVON);
	scLookDirection(BLAKE,FACING_LEFT);
	scDelay(150);
	scActorTalk(AVON,ST_LIBERATORFIRST,10);
	scWaitForActor(AVON);
	scWaitForActor(AVON);
	scActorTalk(AVON,ST_LIBERATORFIRST,11);
	scWaitForActor(AVON);

	scWaitForActor(JENNA);
	for(i=12;i<=15;i=i+1){
		scActorTalk(JENNA,ST_LIBERATORFIRST,i);
		scWaitForActor(JENNA);
	}
	
	// Zen wakes up
	scPrint(ST_LIBERATORFIRST,16);
	scChainScript(203);

	scActorTalk(BLAKE,ST_LIBERATORFIRST,17);
	scWaitForActor(BLAKE);

	/*scActorWalkTo(AVON,47,14);
	scActorWalkTo(BLAKE,37,14);
	scActorWalkTo(JENNA,30,16);
	scWaitForActor(BLAKE);
	scWaitForActor(JENNA);
	scWaitForActor(AVON);
	scLookDirection(AVON,FACING_LEFT);
	scLookDirection(JENNA,FACING_RIGHT);
	scLookDirection(BLAKE,FACING_RIGHT);
	*/
	scActorWalkTo(BLAKE,34,14);
	scWaitForActor(BLAKE);
	
	scPrint(ST_LIBERATORFIRST,18);
	scChainScript(203);


	scActorTalk(AVON,ST_LIBERATORFIRST,19);
	scWaitForActor(AVON);

	scPrint(ST_LIBERATORFIRST,20);
	scChainScript(203);
	scPrint(ST_LIBERATORFIRST,21);
	scChainScript(203);
	scPrint(ST_LIBERATORFIRST,22);
	scChainScript(203);


	scActorTalk(JENNA,ST_LIBERATORFIRST,23);
	scWaitForActor(JENNA);
	scActorTalk(JENNA,ST_LIBERATORFIRST,24);
	scWaitForActor(JENNA);
	
	for(i=25;i<=27;i=i+1){
		scActorTalk(BLAKE,ST_LIBERATORFIRST,i);
		scWaitForActor(BLAKE);
	}
	
	scPrint(ST_LIBERATORFIRST,28);
	scChainScript(203);
		
	
	// Go to london...
	scLoadRoom(ROOM_LONDONDECK);
	
lw:	scBreakHere();
	if(sfGetCurrentRoom()==ROOM_LONDONDECK) goto lw;
	
	// Done. Now the final dialogue...		

	scActorTalk(JENNA,ST_LIBERATORFIRST,29);
	scWaitForActor(JENNA);
	scActorTalk(JENNA,ST_LIBERATORFIRST,30);
	scWaitForActor(JENNA);

	scLookDirection(BLAKE,FACING_LEFT);
	
	scActorTalk(BLAKE,ST_LIBERATORFIRST,31);
	scWaitForActor(BLAKE);
	scActorTalk(BLAKE,ST_LIBERATORFIRST,32);
	scWaitForActor(BLAKE);

	scActorTalk(AVON,ST_LIBERATORFIRST,33);
	scWaitForActor(AVON);

	scActorTalk(BLAKE,ST_LIBERATORFIRST,34);
	scWaitForActor(BLAKE);
	scActorTalk(BLAKE,ST_LIBERATORFIRST,35);
	scWaitForActor(BLAKE);

	scActorTalk(AVON,ST_LIBERATORFIRST,36);
	scWaitForActor(AVON);
	scActorTalk(JENNA,ST_LIBERATORFIRST,37);
	scWaitForActor(JENNA);
	scActorTalk(AVON,ST_LIBERATORFIRST,38);
	scWaitForActor(AVON);
	scActorTalk(AVON,ST_LIBERATORFIRST,39);
	scWaitForActor(AVON);
	scActorTalk(BLAKE,ST_LIBERATORFIRST,40);
	scWaitForActor(BLAKE);
	
	scLookDirection(BLAKE,FACING_RIGHT);
	scActorTalk(BLAKE,ST_LIBERATORFIRST,41);
	scWaitForActor(BLAKE);
	scLookDirection(BLAKE,FACING_RIGHT);
	scActorTalk(BLAKE,ST_LIBERATORFIRST,42);
	scWaitForActor(BLAKE);
	
	scPrint(ST_LIBERATORFIRST,28);
	scChainScript(203);

	scActorTalk(BLAKE,ST_LIBERATORFIRST,43);
	scWaitForActor(BLAKE);
	scActorTalk(BLAKE,ST_LIBERATORFIRST,44);
	scWaitForActor(BLAKE);

	
	scPlaySFX(SFX_SUCCESS);
	scWaitForTune();
	
		
	i=sfGetFadeEffect();
	scSetFadeEffect(130);
	scLoadRoom(ROOM_CAEXTERIOR);
	scChainScript(8);
	
	scSetPosition(AVON,ROOM_LIBTELEPORT,15,32);
	scLookDirection(AVON,FACING_LEFT);
	
	scLoadRoom(ROOM_LIBDECK);
	scSetCameraAt(40);
	scSetFadeEffect(i);
	scBreakHere();
	
	scSetPosition(VARGAS, 0, 16, 27);
	scSetPosition(MONK2, 0, 16, 21);
	scSetPosition(MONK1, 0, 16, 12);

	
	scPrint(ST_LIBERATORFIRST,45);
	scChainScript(203);
	scPrint(ST_LIBERATORFIRST,46);
	scChainScript(203);
	scUnlockResource(RESOURCE_STRING,ST_LIBERATORFIRST);
	
	scRemoveFromInventory(CATPULT);
	if(sfIsObjectInInventory(PLIERS)){
		scRemoveFromInventory(PLIERS);
		//scLoadObjetToGame(PLIERS);
	}
	
	if(sfIsObjectInInventory(WRENCH)){
		scRemoveFromInventory(WRENCH);
		//scLoadObjectToGame(WRENCH);
	}
	
	if(sfIsObjectInInventory(SCISSORS)){
		scRemoveFromInventory(SCISSORS);
		//scLoadObjectToGame(SCISSORS);
	}
	
	bCygnusOrbit=true;
	
	scShowVerbs(true);
	scCursorOn(true);
	scSave();
}




stringpack ST_LIBERATORFIRST{
#ifdef ENGLISH
	/*************************************/
	// Jenna: 0
	"What happened?";
	"I saw my mother.";
	"She was leaving me... again.";
	
	// Avon: 3
	"And I saw my brother about to die,";
	"and I couldn't do anything.";
	
	// Blake: 5
	"That... thing... was using your";
	"minds and memories against you.";
	"I guess it failed with me, as I had";
	"my memories erased by the Federation.";
	
	// Avon: 9
	"Let's examine the ship...";
	"Okay. I have powered on the basic";
	"systems of the ship.";
	
	// Jenna: 12
	"These controls are strange...";
	"Let me try....";
	"AAAAAAHHH!";
	"She's got into my mind! Stop it!";

	// ZEN: 16 - dialogue
	" Welcome Jenna Stannis.";
	"Who is it?";
	" Zen. Welcome Roj Blake.";
	"You're a computer.";
	" As you say, Kerr Avon.";
	" The Liberator is ready.";
	" Set speed and course.";
	
	//23
	"The Liberator...";
	"Yes, that name came to my mind.";
	
	"Zen, close the entry hatch and";
	"manoeuvre the ship away from";
	"the London's sensor range.";
	
	" Confirmed...";
	
	//------
	
	//29
	/*************************************/
	"We're free. We've got a ship.";
	"We can go anywhere we like.";
	
	"We will go to Cygnus Alpha.";
	"We'll free the rest of the group.";
	"WHAT!?";
	"With this ship and a full crew, then";
	"we CAN start fighting back!";
	"You can't be serious...";
	"What's the alternative?";
	//38
	"Leave. I'm free.";
	"And I intend to stay that way.";
	"And I need a crew.";
	"Zen. Set course to Cygnus Alpha.";
	"Speed standard.";
	
	//43
	"Oh, I'd better put this pipe back";
	"in its place.";
	
	//45
	" The Liberator is in stationary";
	" orbit over planet Cygnus Alpha.";
#endif

#ifdef FRENCH
	/*************************************/
	// Jenna: 0
	"Que s'est-il passé?";
	"J'ai vu ma mère.";
	"Elle m'abandonnait... de nouveau.";
	
	// Avon: 3
	"Et moi, j'ai vu mon frère sur le point";
	"de mourir, et j'étais impuissant.";
	
	// Blake: 5
	"Cette... chose... utilisait votre";
	"esprit et vos souvenirs contre vous.";
	"Ca a du échouer avec moi, car";
	"la Fédération a effacé mes souvenirs.";
	
	// Avon: 9
	"Examinons ce vaisseau...";
	"Ok. Je viens d'alimenter les systèmes";
	"principaux du vaisseau.";
	
	// Jenna: 12
	"Ces commandes sont étranges...";
	"Laisse-moi essayer....";
	"AAAAAAHHH!";
	"Il est dans mon esprit! Arrêtez-le!"; // l'ordinateur => masculin

	// ZEN: 16 - dialogue
	" Bonjour Jenna Stannis.";
	"Qui êtes-vous?";
	" Zen. Bienvenue, Roj Blake.";
	"Tu es un ordinateur?";
	" En effet, Kerr Avon.";
	" Le Libérateur est prêt.";
	" Veuillez indiquer cap et vitesse.";
	
	//23
	"Le Libérateur...";
	"Oui, ce nom m'est venu à l'esprit.";
	
	"Zen, ferme le sas d'entrée et";
	"manoeuvre le vaisseau hors de portée";
	"des scanners du London.";
	
	" Confirmé...";
	
	//------
	
	//29
	/*************************************/
	"Nous sommes libres, avec un vaisseau.";
	"Nous pouvons aller où nous voulons.";
	
	"Nous irons sur Cygnus Alpha.";
	"Nous libèrerons le reste du groupe.";
	"QUOI!?";
	"Avec ce vaisseau et un équipage au";
	"complet, nous POURRONS contrattaquer!"; // contrattaquer, variante de "contre-attaquer", cf. https://bit.ly/2JbN0mU
	"Tu n'es pas sérieux...";
	"Quelle est l'alternative?";
	//38
	"Partir. Je suis libre.";
	"Et j'ai l'intention de le rester.";
	"Et moi, j'ai besoin d'un équipage.";
	"Zen, fais route vers Cygnus Alpha.";
	"Vitesse standard.";
	
	//43
	"Oh, je ferais mieux de remettre";
	"ce tuyau à sa place.";
	
	//45
	" Le Libérateur est en orbite";
	" stationnaire autour de Cygnus Alpha.";
#endif

#ifdef SPANISH
	/*************************************/
	// Jenna: 0
	"¿Qué ha pasado?";
	"Ví a mi madre.";
	"Me abandonaba... otra vez.";
	
	// Avon: 3
	"Y yo a mi hermano a punto de morir,";
	"y no podía hacer nada.";
	
	// Blake: 5
	"Esa cosa usaba vuestras mentes y";
	"recuerdos contra vosotros.";
	"Supongo que conmigo no pudo por el";
	"borrado que me hizo la Federación.";
	
	// Avon: 9
	"Examinemos la nave...";
	"Listo. Acabo de devolver la energía";
	"a los sistemas principales.";
	
	// Jenna: 12
	"Estos controles son muy extraños.";
	"Déjame intentar....";
	"¡AAAAAAHHH!";
	"¡Se ha metido en mi cabeza! ¡Párala!";

	// ZEN: 16 - dialogue
	" Bienvenida Jenna Stannis.";
	"¿Quién eres?";
	" Zen. Bienvenido Roj Blake.";
	"Eres una computadora.";
	" Lo que tú digas, Kerr Avon.";
	" El Libertador está listo.";
	" Marque velocidad y rumbo.";
	
	//23
	"El Libertador...";
	"Sí, ese nombre me vino a la cabeza.";
	
	"Zen, cierra la escotilla de entrada";
	"y maniobra la nave lejos del rango";
	"de La Londres.";
	
	" Confirmado...";
	
	//------
	
	//29
	/*************************************/
	"Somos libres. Tenemos una nave.";
	"Podemos ir donde queramos.";
	
	"Iremos a Cygnus Alpha.";
	"Liberaremos al resto del grupo.";
	"¿¡COMO DICES!?";
	"¡Con esta nave y una tripulación";
	"PODEMOS empezar a contraatacar!";
	"No hablas en serio...";
	"¿Qué alternativa hay?";
	//38
	"Marcharme. Soy libre.";
	"Y pretendo seguir siéndolo.";
	"Y yo necesito una tripulación.";
	"Zen. Pon rumbo a Cygnus Alpha.";
	"Velocidad estándar.";

	//43
	"Ah, mejor dejo este trozo de tubería";
	"donde estaba.";
		
	//45
	" El Libertador está en órbita estable";
	" sobre el planeta Cygnus Alpha.";
#endif
	

	
	
}
	




