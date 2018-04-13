
/* More strings in separate file, so they can be removed from memory */
/* Traduction FR:laurentd75	*/

#include "globals.h"

#define DIALOG_EXTRAS 102

stringpack DIALOG_EXTRAS{
#ifdef ENGLISH
	/**************************************/
	//0
	"Best you could find.";
	"If it moves, I can fly it.";
	"Who knows?";
	"Nobody has ever returned to tell.";
	
	//4
	"Biometric. Palm recognition type.";
	"Hard to break. Ask our expert...";
	"The probability of surviving the";
	"first 30 hours is below 10%.";
	
	//8
	"They say these prison ships don't"; 
	"actually go all the way to Cygnus."; 
	"They wait until they're in deep space,";
	"and then dump you out of an airlock.";
	"You're a fool.";
	
	//13
	"If I am scared enough...";
	"Biometric locks are really hard,";
	"but they are prone to fail, so they";
	"usually include a keycard override.";
	"I tried to get the card from the guard";
	"before, but I took his backup battery";
	"instead. Here it is. Pity, eh?.";
	// 20
	"You ARE a fool.";
	
	//21
	"Not sure, but I will try.";
	"Sure. Count me in!";
		
	//23
	"Fake the logs to gain time to escape.";
	"With access to the computer,";
	"could it be done?";

	//26
	"Nobody on this ship could do it.";
	"Except you.";
	"Naturally.";

	//29
	"Could you pilot it, Jenna?";
	"Sure.";
	
	//31
	"I could use my charm on a guard...";
	"but I don't know how to lure one in.";
#endif

#ifdef FRENCH
	/**************************************/
	//0
	"La meilleure que tu puisses trouver.";
		/*** [laurentd75]: trying to avoid anglicisms here, like "Si ça peut voler, je peux le piloter." ***/
		/*** Some ideas: ***/
			// "Je peux piloter tout ce qui vole."
			// "Tout ce qui vole, je peux le piloter.";
			// "Je pourrais piloter n'importe quoi."; 
			// "Je pourrais piloter même un astéroide."
			// "Je peux piloter n'importe quel engin.";
	"Je peux piloter tout ce qui peut voler.";
		/***/

	"Qui sait? Jamais personne n'en est";
	"revenu pour en parler...";
	//4
	"Biométrique. Analyse la paume de main.";
	"Dur à leurrer... Demande à l'expert!"; // "casser" ou "leurrer" ou "tromper"
	"La probabilité de survivre les trente";
	"premières heures est de moins de 10%.";
	
	//8
	"On dit que ces vaisseaux-prisons ne"; 
	"vont jamais jusqu'à Cygnus, en fait."; 
	"Dès qu'ils atteignent l'espace profond";  // "Ils attendent d'être dans l'espace";
	"ils vous éjectent à partir d'un sas...";  // "profond pour vous jeter d'un sas.";
	"Tu es bête...";
	
	//13
	"Si c'est pour sauver ma peau, oui..."; // [laurentd75]: fits storyline better than "Si je suis assez effrayé, oui...";
	"Les serrures biométriques sont sûres,";
	"mais peuvent tomber en panne, alors il";
	"y a souvent aussi une carte d'accès.";
	"J'ai tenté de voler celle du garde,";
	"mais j'ai pris sa batterie de rechange";
	"à la place, dommage... La voici.";
	// 20
	"Tu es VRAIMENT bête!";
	
	//21
	"Pas sûr, mais je vais essayer.";
	"Carrément, je suis partant!";
		
	//23
	"Peut-on falsifier les registres pour";
	"gagner du temps pour s'échapper, si";
	"on arrive à accéder à l'ordinateur?";

	//26
	"Personne sur ce vaisseau ne le peut.";
	"Personne à part toi, j'imagine...";
	"Naturellement.";

	//29
	"Pourrais-tu le piloter, Jenna?";
	"Sans problème.";
	
	//31
	"Je pourrais aussi aguicher un garde,";
	"mais... comment en attirer un ici?";
#endif

#ifdef SPANISH
	/**************************************/
	//0
	"La mejor.";
	"Si se mueve, puedo pilotarla.";
	"¿Quién sabe?";
	"Nadie ha vuelto para decirlo.";
	
	//4
	"Biométrica. Reconoce la palma.";
	"Difícil. Pregunta al experto...";
	"La probabilidad de sobrevivir las";
	"primeras 30 horas es del 10%.";
	
	//8
	"Dicen que estos transportes no van"; 
	"realmente hasta Cygnus."; 
	"Llegan al espacio profundo y ahí";
	"te tiran por la escotilla.";
	"Eres un tonto.";
	
	//13
	"Si estoy suficientemente asustado.";
	"Este tipo es difícil de romper, pero";
	"falla mucho, así que suelen llevar";
	"una tarjeta de acceso adicional.";
	"Intenté robar la suya al guarda";
	"antes, pero cogí su batería de";
	"repuesto. Aquí está. Lástima.";
	// 20
	"ERES tonto.";
	
	//21
	"No estoy seguro, pero lo intentaré.";
	"¡Cuenta conmigo!";
		
	//23
	/***************************************/
	"Falsear el registro para ganar tiempo.";
	"Si accedemos a la computadora,";
	"¿es posible?";

	//26
	"Nadie aquí podría hacerlo.";
	"Excepto tú.";
	"Naturalmente.";

	//29
	"¿Podrías pilotarla, Jenna?";
	"Claro.";
	
	//31
	"Podría también seducir a un guarda...";
	"Pero no sé cómo traer a uno.";
#endif
}
