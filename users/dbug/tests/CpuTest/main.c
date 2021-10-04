//
// 6502/65c02/65816 detection code and benchmark
//
// Detection code adapted from CC65 (c) Ullrich von Bassewitz, 02.04.1999
//
//

#include "infos.h"

// Declare the assembly code function
void DetectCPU();
extern char CurrentCpu;

void main()
{
	cls();
	printf("CPU Detected: ");
	DetectCPU();
	switch (CurrentCpu)
	{
	default:
	case CPU_UNKNOWN:  	// 0
		printf("Unknown CPU");
		break;

	case CPU_6502: 		// 1
		printf("6502 (NMOS)");
		break;

	case CPU_65C02: 	// 2
		printf("6502 (CMOS)");
		break;

	case CPU_65C816: 	// 3
		printf("65C816");
		break;
	}
	printf("\r\n");

	printf("Done\r\n");
}
