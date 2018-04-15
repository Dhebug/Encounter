/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

script 200{
	// Clean Blake's inventory
	scRemoveFromInventory(COIN);
	scRemoveFromInventory(MAP);

	scSpawnScript(201);
}

script 201
{
	byte i;

	scRemoveObjectFromGame(SERVALAN);
	scRemoveObjectFromGame(TRAVIS);
	
	scDelay(50);
	for (i=0; i<15; i=i+3)
	{
		scPrintAt(200,i,0,112);
		scPrintAt(200,i+1,0,120);
		scPrintAt(200,i+2,0,128);
		scDelay(200);
		scDelay(200);
		scPrintAt(200,20,0,112);
		scPrintAt(200,20,0,120);
		scPrintAt(200,20,0,128);		
	}
	
	scDelay(30);
	scPrintAt(200,15,0,112);
	scPrintAt(200,16,0,120);
	scDelay(200);
	scDelay(100);
	scPrintAt(200,20,0,112);
	scPrintAt(200,20,0,120);	
	
	scPrintAt(200,17,0,112);
	scPrintAt(200,18,0,120);
	scDelay(200);
	scDelay(100);
	scPrintAt(200,20,0,112);
	scPrintAt(200,20,0,120);	
	
	scPrintAt(200,19,0,112);
	scDelay(200);
	scPlaySFX(SFX_MINITUNE1);
	scWaitForTune();	
	//scDelay(100);
	scPrintAt(200,20,0,112);

	scPlayTune(ENDEP_TUNE);
	scWaitForTune();	
	scFadeToBlack();
		
	// Launch episode 2 intro
	scSpawnScript(3);
	scSave();
}

stringpack 200{
#ifdef ENGLISH
	/*++++++++++++++++++++++++++++++++++++++ */
	"By the authority of the Terran";
	"Federation the accused has been found";
	"guilty on the following charges:";
	"Kidnapping, Assault on a Minor, ";
	"Attempting to Corrupt Minors, ";
	"and Child Abuse.";
	
	//6
	"His crimes have been accorded a";
	"Category Nine rating, and as such are";
	"adjudged most grave. Roj Blake...";
	
	//9
	"it is the sentence of this tribunal";
	"that you be transported to the penal";
	"colony on the planet Cygnus Alpha,";
	"where you will remain for the rest of";
	"your natural life.";
	" ";

	//15
	"\A_FWYELLOW But the evidence is false!";
	"\A_FWYELLOW These charges are lies!";
	
	//17
	"Take a long look at this planet. It's" ;
	"the last time you'll ever see it.";
	
	//19
	"\A_FWYELLOW No, I'm coming back.";
	
	//20
	"                                        ";
#endif

#ifdef FRENCH
	/*++++++++++++++++++++++++++++++++++++++ */
	"De par l'autorité de la Fédération";
	"Terranne, nous déclarons l'accusé";
	"coupable des charges suivantes:";
	"Rapt, agression sur un mineur, ";
	"tentative de corruption de mineur, ";
	"et abus sur mineur.";
	
	//6
	"Ces crimes sont de neuvième catégorie,";
	"et en tant que tels, ils sont jugés";
	"extrêmement graves. Roj Blake,...";
	
	//9
	"le tribunal ordonne que vous soyez";
	"transféré sur la planète Cygnus Alpha";
	"au sein de la colonie pénitentiaire,";
	"dans laquelle vous demeurerez pour";
	"le restant de vos jours.";
	" ";

	//15
	"\A_FWYELLOW Mais les preuves ont été truquées!";
	"\A_FWYELLOW Ces accusations sont mensongères!";
	
	//17
	"Regardez bien cette planète... C'est la";
	"dernière fois que vous la contemplez...";
	
	//19
	"\A_FWYELLOW Non, je reviendrai!";
	
	//20
	"                                        ";
#endif

#ifdef SPANISH
	/*++++++++++++++++++++++++++++++++++++++ */
	"Bajo la autoridad de la Federación";
	"Terrana, declaramos al acusado";
	"culpable de los siguientes cargos:";

	"Secuestro, Asalto a un Menor,";
	"Intento de Corrupción de Menores, y";
	"Abuso de Menores.";
	
	//6
	"Estos crímines se han declarado de";
	"Categoría Nueve y, por tanto, son";
	"declarados Muy Graves. Roj Blake...";

	//9
	"es la Sentencia de este Tribunal que";
	"sea transportado a la colonia penal";
	"en el planeta prisión Cygnus Alpha,";
	"donde permanecerá hasta el final de";
	"su vida natural.";
	" ";

	//15
	"\A_FWYELLOW ¡Pero las pruebas son falsas!";
	"\A_FWYELLOW ¡Los cargos son mentiras!";
	
	//17
	"Mire bien este planeta y su luna. Es"; 
	"la última vez que podrá contemplarlo.";
	
	//19
	"\A_FWYELLOW No. Volveré.";
	
	//20
	"                                        ";

#endif
}
