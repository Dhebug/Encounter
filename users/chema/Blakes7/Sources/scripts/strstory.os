/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

// Strings for automatic responses - pack 0

#include "globals.h"

stringpack 200{
#ifdef ENGLISH
	"\A_FWGREEN Resistance...";
	"\A_FWMAGENTA TRAITOR!";
	"\A_FWRED MURDER";
	"\A_FWYELLOW Mind Control...";
	"\A_FWCYAN PAIN";
	"\A_FWWHITE SUFFERING";

	"\A_FWWHITE Calm down, Roj Blake.";
	"\A_FWWHITE It was just a nightmare.";
	" ";
	"\A_FWWHITE You know who you are. Your family is";
	"\A_FWWHITE safe in the outer colonies. That was";
	"\A_FWWHITE the deal with the Federation:";
	"\A_FWWHITE 10 years working on Earth to pay for";
	"\A_FWWHITE the transport and relocation.";
	"\A_FWWHITE Then start a new life in a clean world.";
	" ";
	"\A_FWWHITE Will they be alright?";
#endif
#ifdef FRENCH
	// caution, maxcol 44
	"\A_FWGREEN Résistance...";
	"\A_FWMAGENTA TRAITRE!";
	"\A_FWRED MEURTRE";
	"\A_FWYELLOW Lavage de cerveau..."; // Better than "Manipulation de l'esprit..",
	                                    // see https://fr.wikipedia.org/wiki/Blake%27s_7
	"\A_FWCYAN DOULEUR";
	"\A_FWWHITE SOUFFRANCE";

	"\A_FWWHITE Calme-toi, Roj Blake.";  // test accents: " - àâçéêèîôùû";
	"\A_FWWHITE C'était juste un cauchemar.";
	" ";
	"\A_FWWHITE Tu sais qui tu es. Ta famille vit dans";
	"\A_FWWHITE les colonies extérieures. C'était le";
	"\A_FWWHITE marché conclu avec la Fédération:";
	"\A_FWWHITE 10 ans à travailler pour pouvoir payer"; // "10 ans de travail sur Terre pour payer";
	"\A_FWWHITE le transport et le déménagement. Puis";
	"\A_FWWHITE une nouvelle vie dans un monde neuf."; // [laurentd75]: slight change for French version
	" ";
	"\A_FWWHITE Est-ce qu'ils vont bien au moins?"; // [laurentd75]: slight change for French version
#endif
#ifdef SPANISH
	"\A_FWGREEN Resistencia...";
	"\A_FWMAGENTA ¡TRAIDOR!";
	"\A_FWRED ASESINATO";
	"\A_FWYELLOW Control mental...";
	"\A_FWCYAN DOLOR";
	"\A_FWWHITE SUFRIMIENTO";

	"\A_FWWHITE Calma, Roj Blake.";
	"\A_FWWHITE Sólo fue una pesadilla.";
	" ";
	"\A_FWWHITE Sabes quién eres. Tu familia vive";
	"\A_FWWHITE en las colonias exteriores. Ese fue";
	"\A_FWWHITE el trato con la Federación:";
	"\A_FWWHITE 10 años trabajando aquí para pagar";
	"\A_FWWHITE el transporte y la mudanza.";
	"\A_FWWHITE Y una nueva vida en un mundo limpio.";
	" ";
	"\A_FWWHITE ¿Estarán bien?";
#endif
}