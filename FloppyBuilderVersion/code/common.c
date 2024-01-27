//
// Stuff which is common to the intro and the game
// (c) 2023-2024 Dbug / Defence Force
//

#include "common.h"




void SetLineAddress(char* address)
{
	gPrintAddress=address;
}

void PrintLine(const char* message)
{
	strcpy(gPrintAddress,message);	
	gPrintAddress+=40;
}


void PrintMultiLine(const char* message)
{
    char* printAddress=gPrintAddress;
    while (1)
    {
        char car = *message++;
        if (car>=0)
        {
            *printAddress++=car;
        }
        else
        {
            switch ((unsigned char)car)
            {
            case TEXT_END:
                return;
                
            case TEXT_CRLF:
                gPrintAddress+=40;
                printAddress=gPrintAddress;
                break;
            }
        }
    }
}

void PrintWord(const char* message)
{
	char car;
	while (car=*message++)
	{
		*gPrintAddress++=car;
	}
 }


