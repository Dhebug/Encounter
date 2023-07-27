
#include "lib.h"
#include "params.h"


extern void VSync();
extern void IrqHandler();

extern Set50hzIrq();
extern Set100hzIrq();
extern Set200hzIrq();
extern Set400hzIrq();

extern void Sei();
extern void Cli();

extern void PlaySound(const char* registerList);
extern const char* SoundDataPointer;
extern unsigned char PsgPlayPosition;
extern unsigned char PsgPlayLoopIndex;

extern char ExplodeData[];
extern char ShootData[];
extern char PingData[];
extern char ZapData[];
extern char KeyClickHData[];
extern char KeyClickLData[];
extern char TypeWriterData[];

extern char IrqSpeedMask;




unsigned char Hexdigits[]="0123456789ABCDEF";

unsigned char* PrintStringScreen=(unsigned char*)0xbb80;




void PrintString(int offset,char* string)
{
	if (offset>=0)
	{
		PrintStringScreen=(unsigned char*)0xbb80+offset;
	}
	
	while (*string)
	{
		*PrintStringScreen++=*string++;
	}
}

void PrintChar(int offset,unsigned char car)
{
	if (offset>=0)
	{
		PrintStringScreen=(unsigned char*)0xbb80+offset;
	}
	*PrintStringScreen++=car;
}

void PrintHexByte(int offset,unsigned int value)
{
	char buffer[5];
	buffer[0]=Hexdigits[(value>>4)&15];
	buffer[1]=Hexdigits[(value)&15];
	buffer[2]=0;
	PrintString(offset,buffer);
}

void PrintHex12bit(int offset,unsigned int value)
{
	char buffer[5];
	buffer[0]=Hexdigits[(value>>8)&15];
	buffer[1]=Hexdigits[(value>>4)&15];
	buffer[2]=Hexdigits[(value)&15];
	buffer[3]=0;
	PrintString(offset,buffer);
}

void PrintHex(int offset,unsigned int value)
{
	char buffer[5];
	buffer[0]=Hexdigits[(value>>12)&15];
	buffer[1]=Hexdigits[(value>>8)&15];
	buffer[2]=Hexdigits[(value>>4)&15];
	buffer[3]=Hexdigits[(value)&15];
	buffer[4]=0;
	PrintString(offset,buffer);
}

void PrintDecimal(int offset,unsigned int value)
{
	char buffer[20];
	char* ptr=buffer+19;
	*ptr=0;  // Null terminator
	while (value || (ptr==buffer+19))
	{
		ptr--;
		*ptr='0'+(value%10);
		value=value/10;
	}
	//sprintf(buffer,"%d",value);
	//char* converted=itoa(value);
	PrintString(offset,ptr);
}


#define REFERENCE_CYCLES 20019         // Technically should be 19960 but that's close enough


void PrintCpuPercentage(int offset,char* label, unsigned int value,unsigned int number_irq)
{
	unsigned int total_cycles;
	unsigned int irq_cycles;

	total_cycles = value;
	irq_cycles   = total_cycles-REFERENCE_CYCLES;

    PrintString(offset,label);

    PrintString(-1," Tot:");

	PrintDecimal(-1,total_cycles);
    PrintString(-1," Irq:");
	PrintDecimal(-1,irq_cycles);

	if (number_irq)
	{
		PrintChar(-1,'/');
		PrintDecimal(-1,number_irq);
		PrintChar(-1,'=');
		PrintDecimal(-1,irq_cycles/number_irq);
	}

    PrintChar(-1,' ');
	PrintDecimal(-1,irq_cycles/(total_cycles/100));
    PrintChar(-1,'%');
}




void PrintFrequency()
{
	PrintChar(34,3);
	switch (IrqSpeedMask)
	{
	case 1:
	    PrintString(-1," 50hz");
		break;

	case 2:
	    PrintString(-1,"100hz");
		break;

	case 4:
	    PrintString(-1,"200hz");
		break;

	case 8:
	    PrintString(-1,"400hz");
		break;

	default:
	    PrintString(-1,"???  ");
		break;
	}

}




//#define PlayZap() asm("sei:lda #<_ZapData:sta _SoundDataPointer+0:lda #>_ZapData:sta _SoundDataPointer+1:lda #0:sta _PsgPlayPosition:cli");	

void DumpSound(const char* registerList)
{
	int offset=80;

	memset((char*)0xbb80+40*3,32,40*25);

    PrintString(offset,"");
	while (1)
	{
		unsigned char command = *registerList++;
		switch (command)
		{
		case SOUND_COMMAND_END: //        0      // End of the sound
			return;

		case SOUND_COMMAND_END_FRAME: //  1      // End of command list for this frame
			offset+=40;
			PrintString(offset,"");
			break;

		case SOUND_COMMAND_SET_BANK: //   2      // Change a complete set of sounds: <14 values copied to registers 0 to 13>
			PrintString(-1,"ST");
			{
				PrintChar(-1,1);
				PrintHex12bit(-1,*(const int*)registerList); // Chanel A Freq (12 bits)
				registerList+=2;
				PrintChar(-1,2);
				PrintHex12bit(-1,*(const int*)registerList); // Chanel B Freq (12 bits)
				registerList+=2;
				PrintChar(-1,4);
				PrintHex12bit(-1,*(const int*)registerList); // Chanel C Freq (12 bits)
				registerList+=2;
				PrintChar(-1,7);
				PrintHexByte(-1,*registerList++);  // Noise Freq
				PrintChar(-1,' ');
				PrintHexByte(-1,*registerList++);  // Mixer
				PrintChar(-1,1);
				PrintHexByte(-1,*registerList++);  // Vol A
				PrintChar(-1,2);
				PrintHexByte(-1,*registerList++);  // Vol B
				PrintChar(-1,4);
				PrintHexByte(-1,*registerList++);  // Vol C
				PrintChar(-1,7);
				PrintHexByte(-1,*registerList++);  // Enveloppe freq
				PrintHexByte(-1,*registerList++);
				PrintChar(-1,' ');
				PrintHexByte(-1,*registerList++);  // Enveloppe shape
			}
			break;

		case SOUND_COMMAND_SET_VALUE: //  3      // Set a register value: <register index> <value to set>
			PrintString(-1,"SetValue ");
			PrintDecimal(-1,*registerList++);
			PrintChar(-1,'=');
			PrintDecimal(-1,*registerList++);
			PrintChar(-1,' ');
			break;

		case SOUND_COMMAND_ADD_VALUE: //  4      // Add to a register:    <register index> <value to add>
			PrintString(-1,"AddValue ");
			PrintDecimal(-1,*registerList++);
			PrintString(-1,"+=");
			PrintDecimal(-1,*registerList++);
			PrintChar(-1,' ');
			break;

		case SOUND_COMMAND_REPEAT: //     5      // Defines the start of a block that will repeat "n" times: <repeat count>
			PrintString(-1,"Repeat ");
			PrintDecimal(-1,*registerList++);
			offset+=40+2;
			PrintString(offset,"");
			break;

		case SOUND_COMMAND_ENDREPEAT: //  6      // Defines the end of a repeating block
			PrintString(-1,"EndRepeat");
			offset+=40-2;
			PrintString(offset,"");
			break;

		default:
			// Unknown code
			return;
		}
	}
}


void PlaySound(const char* registerList)
{
	Sei();
	SoundDataPointer=registerList;
	PsgPlayPosition=0;                   // 255 = Done playing
	PsgPlayLoopIndex=255;                // Reset the loop position
	Cli();
	DumpSound(registerList);
}



void main()
{
	unsigned char car;
	unsigned char counter;
	unsigned int offset;
		
	cls();
    PrintString(0,"\4Sound Effect Editor 1.0");

	// Install the IRQ so we can use the keyboard
	System_InstallIRQ_SimpleVbl();
	Set200hzIrq();

	counter=0;
	while (1)
	{
		PrintFrequency();

		car=ReadKeyNoBounce();

		PrintChar(40*27,16+4);

		PrintString(-1,"Key:");
		PrintDecimal(-1,car);
		PrintString(-1,"   Counter:");
		PrintDecimal(-1,counter++);
		PrintString(-1,"   ");

		if ( (car=='q') || (car=='Q') )
		{
			// Quit
			break;
		}

		switch (car)
		{
		case '1':
            Set50hzIrq();
			break;

		case '2':
 			Set100hzIrq();
			break;

		case '3':
 			Set200hzIrq();
			break;

		case '4':
 			Set400hzIrq();
			break;

		case 'x':
		case 'X':
			PrintString(40,"\1Explode        ");
			PlaySound(ExplodeData);
			break;

		case 'p':
		case 'P':
			PrintString(40,"\1Ping          ");
			PlaySound(PingData);
			break;

		case 's':
		case 'S':
			PrintString(40,"\1Shoot       ");
			PlaySound(ShootData);
			break;

		case 'z':
		case 'Z':
			PrintString(40,"\1Zap        ");
			PlaySound(ZapData);
			break;

		case 'k':
		case 'K':
			PrintString(40,"\1Key      ");
			PlaySound(KeyClickHData);  // KeyClickLData
			break;


		case 't':
		case 'T':
			PrintString(40,"\1TypeWriter    ");
			PlaySound(TypeWriterData);
			break;
		}

	}

	System_RestoreIRQ_SimpleVbl();

	StopSound();
}




