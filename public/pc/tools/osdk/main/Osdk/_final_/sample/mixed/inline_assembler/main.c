//
// TEST_3
//
// This is a "HELLO WORLD" sample using
// an assembly code routine to display
// the message
//


// Declare the assembly code function
void SimplePrint(const char *ptr_message);


void main()
{
	asm("lda #16+1:sta $bb80");
	SimplePrint("Hello World !");

	{
		char i;
		for (i=0;i<256;i++)
		{
			asm("lda %i:tax:and #7:ora #16:sta $bb80+40,x");

		}


	}
}
