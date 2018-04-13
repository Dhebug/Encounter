/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

/* Object command script and strings */

objectcode MAP
{
	LookAt:
		scCursorOn(false);
		scActorTalk(BLAKE,MAP,0);
		scWaitForActor(BLAKE);
		scActorTalk(BLAKE,MAP,1);
		scWaitForActor(BLAKE);		
		scDelay(5);
		scActorTalk(BLAKE,MAP,2);
		scWaitForActor(BLAKE);	
		scActorTalk(BLAKE,MAP,3);
		scWaitForActor(BLAKE);	
		scDelay(10);
		scActorTalk(BLAKE,MAP,4);
		scWaitForActor(BLAKE);	
		scActorTalk(BLAKE,MAP,5);
		scWaitForActor(BLAKE);			
		scCursorOn(true);
		scStopScript();
	Use:
		scCursorOn(false);
		scActorTalk(BLAKE,MAP,6);
		scWaitForActor(BLAKE);
		scActorTalk(BLAKE,MAP,7);
		scWaitForActor(BLAKE);	
		scCursorOn(true);
		scStopScript();
}

stringpack MAP
{
#ifdef ENGLISH
	/*
	 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx */
	"A technical map showing exit 172.";
	"Interesting....";
	"It is possible to reach it from the";
	"ventilation system in this level.";
	"And there is an access inside the";
	"service corridor.";
	// 6
	"I can use the map once I get inside";
	"the ventilation system.";
#endif

#ifdef FRENCH
	/*
	 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx */
	 
	 // [laurentd75]: see "blakesroom.os" and "maproom.os": 
	 // in the French version we need to use 162 instead of 172
	
	"Un plan technique de la sortie 162."; 
	"Intéressant...";
	"Il est possible de l'atteindre depuis";
	"le système de ventilation à ce niveau.";
	"Et il y a un accès depuis le couloir";
	"de service.";
	// 6
	"Je pourrai utiliser le plan dès que je";
	"serai dans le système de ventilation.";
#endif

#ifdef SPANISH
	/*
	 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx */
	"Un mapa técnico con la salida 172.";
	"Interesante...";
	"Se puede alcanzar desde el sistema de";
	"ventilación de este nivel. ";
	"Y hay un acceso desde el corredor de";
	"servicio del pasillo.";
	// 6
	"Podré usar el mapa cuando acceda al";
	"sistema de ventilación.";
#endif	
		
}