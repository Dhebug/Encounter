
#include "common.h"
#include "params.h"
#include "game_defines.h"

typedef void (*ByteStreamCallback)();
extern ByteStreamCallback ByteStreamCallbacks[_COMMAND_COUNT];



unsigned int* jumpLocation;
char check = 0;


// The various commands:
// - COMMAND_END indicates the end of the stream
// - COMMAND_BUBBLE draws speech bubble and requires a number of parameters:
//   - Number of bubbles
//   - Main color
//   - For each bubble: X,Y,W,H,
// - COMMAND_TEXT
//   - x,y,color,message
void HandleByteStream()
{
	if (gDelayStream)
	{
		// _VblCounter
		gDelayStream--;
		return;
	}

	if (gCurrentStream)
	{
		gDrawAddress = (unsigned char*)0xa000;
        gCurrentStreamStop = 0;
		do
		{
			unsigned char command=*gCurrentStream++;
            if (command>=_COMMAND_COUNT)
            {
                Panic();
            }
            ByteStreamCallbacks[command]();
		}
        while (!gCurrentStreamStop);
	}
}


#ifdef ENABLE_CHEATS

char gDebuggerItemId=0;   // Global so it get remembered from the last time we were in the debugger

void GameDebugger()
{
    // Description of scenes is on line 17
    char car;
    location* locationPtr=0;
    item* itemPtr=0;
    char* currentLine=(char*)0xbb80+40*16;
    sprintf(currentLine+2,"Debugger%c",7);

    while (1)
    {
       	int shift=0;

        while (gDebuggerItemId<0)
        {
            gDebuggerItemId += e_ITEM_COUNT_;
        }
        while (gDebuggerItemId>=e_ITEM_COUNT_)
        {
            gDebuggerItemId -= e_ITEM_COUNT_;
        }

        while (gCurrentLocation<0)
        {
            gCurrentLocation += e_LOCATION_COUNT_;
        }
        while (gCurrentLocation>=e_LOCATION_COUNT_)
        {
            gCurrentLocation -= e_LOCATION_COUNT_;
        }

        currentLine=(char*)0xbb80+40*17;
        memset(currentLine,' ',40*11);

        // Locations from 0 to e_LOCATION_COUNT_-1
        locationPtr=&gLocations[gCurrentLocation];
        // Memory location and id
        sprintf(currentLine,"%c%c$%x:Location %d",16+4,3,locationPtr,gCurrentLocation);    
        currentLine+=40;

        sprintf(currentLine,"%s",gLocations[gCurrentLocation].description);    
        sprintf(currentLine+36,"-%d ",gCurrentLocation);    
        currentLine+=40;
        currentLine+=40;

        // Items from 0 to e_ITEM_COUNT_-1
        itemPtr=&gItems[gDebuggerItemId];
        // Memory location, id and description
        sprintf(currentLine,"%c$%x:Item %d - %s",3,itemPtr,gDebuggerItemId,itemPtr->description);    
        currentLine+=40;
        if (itemPtr->associated_item!=255)
        {
            char associatedItemId=itemPtr->associated_item;
            item* associatedItemPtr=&gItems[associatedItemId];
            // Memory location, id and description
            sprintf(currentLine,"%c$%x:Alias %d - %s",6,associatedItemPtr,associatedItemId,associatedItemPtr->description);    
            currentLine+=40;
        }
        // Flags
        sprintf(currentLine,"Flags:%d",itemPtr->flags);    
        if (itemPtr->flags & ITEM_FLAG_IS_CONTAINER)    
        {
            sprintf(currentLine+31,"CONTAINER");
        }
        if (itemPtr->usable_containers)    
        {
            sprintf(currentLine+26,"NEED-CONTAINER");
        }
        if (itemPtr->flags & ITEM_FLAG_HEAVY)    
        {
            sprintf(currentLine+35,"HEAVY");
        }
        if (itemPtr->flags & ITEM_FLAG_EVAPORATES)    
        {
            sprintf(currentLine+15,"EVAPORATES");
        }
        if (itemPtr->flags & ITEM_FLAG_ALIAS_ITEM)    
        {
            sprintf(currentLine+15,"ALIAS");
        }
        if (itemPtr->flags & ITEM_FLAG_DEAD)    
        {
            sprintf(currentLine+9,"DEAD");
        }
        currentLine+=40;

        // Possible containers
        if (itemPtr->usable_containers)
        {
            char container=itemPtr->usable_containers;
            sprintf(currentLine,"Containers:%d %cTIN%cBUC%cBOX%cNET%cBAG%cBOT%c",
                container,
                (container&1)>>0,
                (container&2)>>1,
                (container&4)>>2,
                (container&8)>>3,
                (container&16)>>4,
                (container&32)>>5,
                7
            );
            currentLine+=40;
        }

        // Item location
        switch (itemPtr->location)
        {
        case e_LOCATION_INVENTORY:
            sprintf(currentLine,"Loc:INVENTORY");    
            break;

        case e_LOCATION_NONE:
            sprintf(currentLine,"Loc:DISABLED");    
            break;

        default:
            sprintf(currentLine,"Loc:%s",gLocations[itemPtr->location].description);    
            break;
        }
        sprintf(currentLine+36,"-%d ",itemPtr->location);    
        currentLine+=40;

        // Erase the last line if the decription was too long and overflew onto the next line
        memset(currentLine,32,40);
        currentLine+=40;

        car=WaitKey();
		if ((KeyBank[4] & 16))	// SHIFT code
		{
			shift=1;
		}

        if (car==KEY_ESC)
        {
            break;
        }
        else
        {
            switch (car)
            {
            case KEY_LEFT:
                if (shift)   gDebuggerItemId-=5;
                else         gDebuggerItemId--;
                break;
            case KEY_RIGHT:
                if (shift)   gDebuggerItemId+=5;
                else         gDebuggerItemId++;
                break;

            case KEY_UP:
                if (shift)   gCurrentLocation-=5;
                else         gCurrentLocation--;
                break;
            case KEY_DOWN:
                if (shift)   gCurrentLocation+=5;
                else         gCurrentLocation++;
                break;

            case KEY_RETURN:
                if (itemPtr->location<e_LOCATION_COUNT_)
                {
                    gCurrentLocation=itemPtr->location;
                }
                break;
            }
        }
    }

    LoadScene();
}
#endif
