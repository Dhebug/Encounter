




//
// MYM music player
// 31.1.2000 Marq/Lieves!Tuore & Fit (marq@iki.fi)
// 7.8.2001 Dbug (dbug@defence-force.org) Oric version.


#include <lib.h>

#define REGS	14			// Number of PSG registers
#define FRAG	128			// Number of rows to compress at a time 
#define OFFNUM	14			// Bits needed to store off+num of FRAG
#define OFFHALF	(OFFNUM/2)



// ========================= externs

extern	void		VSync();
extern	void		TimeIrqHandler();



void DoLoad();

void PsgPlay();

void ReadBits();
void PlayerInit();

void PlayerCopyUnchanged();
void PlayerCopyPacked();

void PlayerUnpackBlock();
void PlayerUnpackRegister();



extern unsigned char PsgVbl;
//extern unsigned char PsgControl;
//extern unsigned char PsgData;

//extern unsigned char ReadBitCount;
//extern unsigned char ReadBitResult;

extern unsigned int MusicRowCount;

extern unsigned char PlayerBuffer[];

extern unsigned int PlayerVbl;

extern unsigned char PlayerVblRow;

extern unsigned char PlayerRegister;

extern unsigned char PlayerRegCurrentValue;

extern unsigned char PlayerRegisterBitCount;

extern unsigned char *PlayerRegPointer;


extern unsigned char PlayerUnpackCount;
extern int PlayerUnpackOffset;

extern unsigned char PlayerCounter;

// ========================= externs




void main()
{
	unsigned char	reg;
	unsigned char	count;
	unsigned char	decount;




	//
	// Display a message...
	//
	printf("MYM Music player - v0.001\r\n");

	//
	// Load the song
	//
	printf("Loading music \r\n");
	/*
	strcpy((char*)0x27f,"music.tap");
	DoLoad();

	zap();
	*/


	//
	//  Read the number of rows
	//
	PlayerInit();

	//
	// Unpack a 1792 bytes blocs...
	//
	PlayerUnpackBlock();
	printf("Number of rows: %d\r\n",MusicRowCount);
	printf("Playing music\r\n");


	//
	// Install the irq handler
	//
    chain_irq_handler(TimeIrqHandler);

	//
	// Unpack the data
	//
	while (1)
	{
		while (PlayerVbl<MusicRowCount)
		{
			PlayerVbl+=FRAG;

			PlayerRegister=0;
			decount=9;
			for (count=0;count<FRAG;count++)
			{
				//
				// Unpack one register list
				// in not finished
				//
				if (PlayerRegister<14)
				{
					decount--;
					if (!decount)
					{
						PlayerUnpackRegister();
						PlayerRegister++;
						decount=9;
					}
				}
				else
				{
					if ((PlayerVbl+count)>=MusicRowCount)
					{
						goto restart;
					}
				}

				//
				// Play the serie of registers
				//
				PsgPlay();
				PsgVbl++;
				VSync();
			}
		}
restart:
		PlayerVbl=0;
		PlayerVblRow=0;
		PsgVbl=0;
	}
}



