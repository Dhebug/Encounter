//
// This programs shows how to use the various joystick interfaces
// 
// This is a complete for the OSDK article and Oriclopedia video:
// - https://osdk.org/index.php?page=articles&ref=ART17
// - https://www.youtube.com/watch?v=_xfpVoIJbSw
//
#include <lib.h>


char FlipFlop=1;

void NewHandler()
{
	SAVE_COMPILER_REGISTERS;

	FlipFlop=-FlipFlop;
	if (FlipFlop)
	{
		if (OsdkJoystickType==JOYSTICK_INTERFACE_NOTHING)
		{
			// Pretend we are a joystick by converting keyboard key codes
			OsdkJoystick_0=0;
			OsdkJoystick_1=0;

			// The system keyboard handler only support one key press at a time,
			// but custom keyboard handler can handle multiple key presses, so this
			// is a viable option.
			//
			// See: https://osdk.org/index.php?page=articles&ref=ART16#title8
			//
			switch (peek(0x208))
			{
			case 172:
				OsdkJoystick_0 |= JOYSTICK_LEFT;
				break;
			case 180:
				OsdkJoystick_0 |= JOYSTICK_DOWN;
				break;
			case 132:
				OsdkJoystick_0 |= JOYSTICK_FIRE;
				break;
			case 156:
				OsdkJoystick_0 |= JOYSTICK_UP;
				break;
			case 188:
				OsdkJoystick_0 |= JOYSTICK_RIGHT;
				break;
			}
		}
		else
		{
			// Read the joystick interface
			joystick_read();
		}
	}

	RESTORE_COMPILER_REGISTER;
}



char* GetInterfaceName(unsigned char interfaceName)
{
	switch (interfaceName)
	{
	case JOYSTICK_INTERFACE_NOTHING:    return "Arrows + Space bar";
	case JOYSTICK_INTERFACE_IJK:        return "IJK/Stingy/Egoist";
	case JOYSTICK_INTERFACE_PASE:       return "PASE/Altai/Mageco";
	case JOYSTICK_INTERFACE_TELESTRAT:  return "Telestrat/Twilighte";
	case JOYSTICK_INTERFACE_OPEL:       return "OPEL";
	case JOYSTICK_INTERFACE_DKTRONICS:  return "Dk'Tronics";
	default:                            return "<Unknown>";
	}
}


void PrintInterfaces()
{
	int interface;

    for (interface=0;interface<_JOYSTICK_INTERFACE_COUNT_;interface++)
    {
	    sprintf((char*)(0xbb80+40*(3+interface)),"%c%c- #%d: %s     ",16+6,(interface==OsdkJoystickType)?1:4,interface+1,GetInterfaceName(interface));
    }
}

void PrintDirections(char* screen,unsigned char mask,char* label)
{
    sprintf(screen+40*0,"%c%s",3,label);

    sprintf(screen+40*2+2,"%cLeft  %c",(mask & JOYSTICK_LEFT)?16+1:16+2,16+4);
    sprintf(screen+40*3+2,"%cRight %c",(mask & JOYSTICK_RIGHT)?16+1:16+2,16+4);
    sprintf(screen+40*4+2,"%cUp    %c",(mask & JOYSTICK_UP)?16+1:16+2,16+4);
    sprintf(screen+40*5+2,"%cDown  %c",(mask & JOYSTICK_DOWN)?16+1:16+2,16+4);
    sprintf(screen+40*6+2,"%cFire  %c",(mask & JOYSTICK_FIRE)?16+1:16+2,16+4);
	sprintf(screen+40*7+2,"%cValue%c%c%d%c  ",16+3,7,16+4,mask,0);    
}

void main()
{
    setflags(SCREEN); // So we don't get the blinking cursor frozen after we disabled the IRQ

    paper(4);
    ink(0);
    cls();
    sprintf((char*)(0xbb80),"%c%c  OSDK Joystick Interface Test 1.2%c     ",16+3,1,3);
    sprintf((char*)(0xbb80+40*2),"%c%cUse 1/2/3/4/5/6 to select",16+6,4);

	OsdkJoystickType=JOYSTICK_INTERFACE_IJK;

	chain_irq_handler(NewHandler); 
	while (1)
	{
		char k;
		char v;
		PrintInterfaces();

		k=key();
		switch (k)
		{
		case '1':
		case '!':
			OsdkJoystickType=JOYSTICK_INTERFACE_NOTHING;
			break;

		case '2':
		case '@':
			OsdkJoystickType=JOYSTICK_INTERFACE_IJK;
			break;

		case '3':
		case '#':
			OsdkJoystickType=JOYSTICK_INTERFACE_PASE;
			break;

		case '4':
		case '$':
			OsdkJoystickType=JOYSTICK_INTERFACE_TELESTRAT;
			break;

		case '5':
		case '%':
			OsdkJoystickType=JOYSTICK_INTERFACE_OPEL;
			break;

		case '6':
		case '^':
			OsdkJoystickType=JOYSTICK_INTERFACE_DKTRONICS;
			break;
		}

		joystick_type_select(OsdkJoystickType);

		PrintDirections((char*)(0xbb80+40*10+4),OsdkJoystick_0,"Left Port");
		PrintDirections((char*)(0xbb80+40*10+4+20),OsdkJoystick_1,"Right Port");
	}
	uninstall_irq_handler();
}

