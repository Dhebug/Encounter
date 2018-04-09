/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
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

#ifdef FRENCH
	/***************************************/
	"Parle, et le Seigneur t'entendra."; // [laurentd75]: inverted the 2 sentences for easier understanding in French
	"Ses bénédictions sont sur toi.";

	"Je suis votre fidele serviteur.";

	"Les ames de l'obscur au-dela";
	"sont-elles avec nous?";

	"Dans la salle des novices.";

	"Bien. Viens et prie avec moi.";
	"Seulement de Sa main surgit la vie...";
	"Et de Sa colere descend la mort.";

	//9
	"Avec d'autres ames pour Son travail...";
	"Il y aura une opportunité pour moi...";
	"... pour tous les fideles...";
	"de s'élever au rang de pretre.";

	"Il ne te faillira pas.";
	"Tu seras récompensé.";
	
	//15
	"Maitre. J'ai trouve quelque chose...";
	"Je crois qu'il y a des intrus.";
	/***************************************/	
	
	"Impossible. Les prisonniers ont été";
	"surveillés des qu'ils ont atterri.";

	"Quelqu'un d'autre est peut-etre venu";
	"avec un autre vaisseau? Montrez-nous.";
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


