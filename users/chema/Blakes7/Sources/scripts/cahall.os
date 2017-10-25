/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"


// Scripts for the church interior of Cygnus Alpha
#define HALLMAIN 200

// META: Another entry script unused

stringpack HALLMAIN{
#ifdef ENGLISH
	/***************************************/
	"His blessings are upon you.";
	"Speak and He will hear you.";

	"I am thy true servant.";

	"The souls from the outer darkness";
	"are amongst us?";

	"They are in the place of the novices.";

	"Good. Come and pray with me.";
	"Only from His hand comes life...";
	"And from His wrath comes death.";

	//9
	"With other souls to do His work...";
	"there will be a chance for me ...";
	"... for the faithful...";
	"to rise to the priesthood.";

	"He will not fail you.";
	"You will be rewarded."; 
	
	//15
	"Master. I've found something...";
	"I think there is an intruder.";
	/***************************************/	
	
	"Can't be. The prisoners were observed";
	"from the moment they landed.";
	
	"Maybe someone else came in his own";
	"spaceship... Show us.";
#endif
#ifdef SPANISH
	/***************************************/
	"Sus bendiciones estén contigo.";
	"Habla y serás escuchado.";
	
	"Soy Su seguro servidor.";

	"¿Las almas de la oscuridad exterior";
	"están entre nosotros?";

	"En la habitación de los novicios.";

	"Bien. Ven y reza conmigo.";
	"Sólo de Su mano viene la vida...";
	"Y de Su ira viene la muerte.";

	//9
	"Con más almas para Su trabajo...";
	"habrá una oportunidad para mí...";
	"... para los fieles...";
	"de alcanzar el sacerdocio.";

	"El no te fallará.";
	"Serás recompensado.";
	
	//15
	"Maestro. He encontrado algo...";
	"Creo que hay intrusos.";
	/***************************************/	

	"Imposible. Los prisioneros fueron";
	"observados desde que aterrizaron.";	

	"Quizás alguien más vino en su propia";
	"nave... Muéstranos.";	
#endif
	
}
// Entry script
script 200{
	scStopScript();

}


