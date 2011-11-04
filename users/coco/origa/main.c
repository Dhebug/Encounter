//
// TOWER OF ORIGA 
// Programmation : 25/07/2011 > xx/08/2011
// Programme principal
// 

//#define	Oric	1
//#define	Debug	1

#include <origa.h>
//#include <stdio.h>

// --------------------------------------------------------------
// Variables et fonctions de ROUT_DIVERS.S

extern unsigned char Random ;
void InitRandomize();
void GetRandomize();		// Retourne en A et Random (2 octets) la valeur

// --------------------------------------------------------------
// Variables et fonctions de ROUT_KEYBOARD.S

/**********************************************/
/* Example program for reading the Oric's     */
/* keyboard. All keys are scanned and a       */
/* virtual matrix of 8 bytes is updated at    */
/* each IRQ.                                  */
/*                                            */
/* Idea: Dbug                                 */
/* Main code: Twiligthe                       */
/* Adaptation & final implementation: Chema   */
/*                                            */
/* 2010                                       */ 
/**********************************************/
/* Virtual keyboard matrix                    */
/* Organized as follows:                      */
/* byte is row number (selected through AY)   */
/* bit in byte indicates the row (selected    */
/* through the VIA port B) numbered 76543210  */
/* For mapping actual keys see:               */
/* http://wiki.defence-force.org/doku.php?id=oric:hardware:oric_keyboard */

extern char KeyBank[8];
extern char tmpTime;			/* Compteur de 1/25e de seconde */
extern void InitISR();			/* Initialization of ISR */
void dump_matrix();				/* Function to dump the matrix into screen */
extern char ReadKey();
extern char ReadKeyNoBounce();
extern char oldKey ;

// --------------------------------------------------------------
// Variables et fonctions en mode text ROUT_TEXT.S

void TextPlot(char x_pos,char y_pos,const char *ptr_message);	// Affiche une chaine de caracteres
void TextClear();												// Efface la page écran TEXT
void CharCopyText();											// Recopie le jeu de caracteres en mode TEXT
void CharCopyHires();											// Recopie le jeu de caracteres en mode HIRES
void HiresLocal();
void TextLocal();

// --------------------------------------------------------------
//Variables et fonctions en mode haute resolution ROUT_HIRES.S

void HiresClear();												// Efface la page graphique
void HiresClearText();											// Efface les 3 lignes de texte de la page graphique
void ScreenCopyHires();											// Transfere à l'écran une zone graphique

// --------------------------------------------------------------
//Variables et fonctions en mode haute resolution ROUT_HIRES.S

void HiresClear();												// Efface la page graphique
void HiresClearText();											// Efface les 3 lignes de texte de la page graphique
void FlipToScreen();
 
// --------------------------------------------------------------
// Declaration des fonctions C



// --------------------------------------------------------------
// Fonctions intégrées au programme
//

/* Routine to dump the matrix into screen */
void dump_matrix()
{
    char * start;
    char i,j;
    char mask=1;
     
    start=(char *)(0xbfe0-350);
    for (j=0;j<8;j++)
    {
        for(i=0;i<8;i++)
            {
                *start = (KeyBank[j] & mask ? '1' : '0');
                start--;
                mask=mask<<1;
            }
        
        mask=1;
        start+=(48);
    }
}

// --------------------------------------------------------
// Attente de touche fonction, retourne le code de la touche
unsigned char get_functionkey()			// demande un clavier non presse, retourne une touche
{
	unsigned char iii=0;
	while (peek(0x209)!=0x38) 
	{ 
		iii=peek(0x209);
	}
	do
	{
		iii=peek(0x209);
	}
	while (iii==0x38);
	return iii;
}

/* 
	Programme principal
*/ 

void main()
{
// Variables
	unsigned char alea=0;
	unsigned char iii=0;
	unsigned char touche=0;

// Programme

    InitISR();							// Initialisation du clavier
   	CharCopyText();						// MAJ du jeu de caracteres
	InitRandomize();					// Initialisation du générateur de nombres aléatoires
	alea=peek(&Random+1);				// Initialisation des nombres aleatoires
    
	TextClear();						// Effacer l'ecran text en noir, encre non définie
	
	TextPlot (10,01,"\4Tower of Origa V0.00");
	TextPlot (01,04,"\6Origa vous souhaite la bienvenue !");
	TextPlot (01,06,"\6Le monde ne sera bientot plus car");
	TextPlot (01,07,"\6avec mon mariage avec Ki, et la");
	TextPlot (01,8,"\6reunification des royaumes des");
	TextPlot (01,9,"\6tenebres la legende sera enfin");
	TextPlot (01,10,"\6realisee et mon regne durera a jamais");
	TextPlot (05,18,"\3----------------------------");
	TextPlot (05,19,"\3Pressez SHIFT pour continuer");
	TextPlot (05,20,"\3----------------------------");
	TextPlot (06,26,"\6 (c) 2011 DMA CONCEPT");

	do
	{	
		touche=ReadKeyNoBounce();
	}
	while (touche!=7 && touche!=8) ;
	
	TextClear();
	HiresLocal();
	CharCopyHires();
	ScreenCopyHires();

	do
	{	
		touche=ReadKeyNoBounce();
	}
	while (touche!=7 && touche!=8) 	;
	
	HiresClear();
	CharCopyHires();
	TextPlot (5,25,"\6Tower of Origa V0.00");	
	
/*	
// demande de la saisie de la touche LSHIFT ou RSHIFT
	do
	{
		touche = get_functionkey();
	}
	while(touche!=164 && touche!=167);
*/
	
	do
	{	
		touche=ReadKeyNoBounce();
	}
	while (touche!=7 && touche!=8) 	;
	TextLocal();
	CharCopyText();
	TextClear();
	TextPlot (10,01,"\4Tower of Origa V0.00");

	do
	{	
		touche=ReadKeyNoBounce();
	}
	while (touche!=7 && touche!=8) 	;	
	
}
