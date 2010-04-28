
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

#include <stdio.h>

/* Initialization of ISR */
extern void InitISR();

/* Virtual keyboard matrix                   */
/* Organized as follows:                     */
/* byte is row number (selected through AY)  */
/* bit in byte indicates the row (selected   */
/* through the VIA port B) numbered 76543210 */
/* For mapping actual keys see:              */
/* http://wiki.defence-force.org/doku.php?id=oric:hardware:oric_keyboard */

extern char KeyBank[8];

/* Function to dump the matrix into screen */
void dump_matrix();

void main()
{
	printf("Keyboard scan demo program --\n");
	printf("A virtual matrix (shown below) is\n");
	printf("updated by interrupts. Each row\n");
	printf("(0-7) is one byte in the KeyBank. \n");
	printf("Each bit represents activity (1 or 0)\n");
	printf("sensed in a given column (7-0)\nMultiple keypresses are supported.\n");

    InitISR();
	while (1)
	{
        dump_matrix();
	}
    
}


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