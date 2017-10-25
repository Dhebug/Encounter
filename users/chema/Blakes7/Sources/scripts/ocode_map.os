/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
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