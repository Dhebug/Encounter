
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
        while (!gCurrentStreamStop);   // Can be triggered by END, WAIT, END_AND_REFRESH
	}
}


#ifdef ENABLE_CHEATS

char gDebuggerItemId=0;   // Global so it get remembered from the last time we were in the debugger

void GameDebugger()
{
    // Description of scenes is on line 17
    char increment;
    char car;
    location* locationPtr=0;
    item* itemPtr=0;
    char* currentLine=(char*)0xbb80+40*16;
    sprintf(currentLine+2,"Debugger%c",7);

    while (1)
    {
       	char shift=0;

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
            gCurrentLocation += e_LOC_COUNT_;
        }
        while (gCurrentLocation>=e_LOC_COUNT_)
        {
            gCurrentLocation -= e_LOC_COUNT_;
        }

        currentLine=(char*)0xbb80+40*17;
        memset(currentLine,' ',40*11);

        // Locations from 0 to e_LOC_COUNT_-1
        locationPtr=&gLocations[gCurrentLocation];
        // Memory location and id
        sprintf(currentLine,"%c%c$%x:Location %d",16+4,3,locationPtr,gCurrentLocation);    
        currentLine+=40;

        //sprintf(currentLine,"%s",gLocations[gCurrentLocation].description);      // Description is now in the script
        sprintf(currentLine+36,"-%d ",gCurrentLocation);    
        currentLine+=80;

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
        if (itemPtr->flags & ITEM_FLAG_IMMOVABLE)    
        {
            sprintf(currentLine+35,"HEAVY");
        }
        if (itemPtr->flags & ITEM_FLAG_ATTACHED)    
        {
            sprintf(currentLine+15,"ATTACHED");
        }
        if (itemPtr->flags & ITEM_FLAG_DISABLED)    
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
        case e_LOC_INVENTORY:
            sprintf(currentLine,"Loc:INVENTORY");    
            break;

        case e_LOC_NONE:
            sprintf(currentLine,"Loc:DISABLED");    
            break;

        default:
            //sprintf(currentLine,"Loc:%s",gLocations[itemPtr->location].description);    
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

        increment=shift?5:1;
        switch (car)
        {
        case KEY_ESC:
            LoadScene();
            return;

        case KEY_LEFT:
            gDebuggerItemId-=increment;
            break;
        case KEY_RIGHT:
            gDebuggerItemId+=increment;
            break;

        case KEY_UP:
            gCurrentLocation-=increment;
            break;
        case KEY_DOWN:
            gCurrentLocation+=increment;
            break;

        case KEY_RETURN:
            if (itemPtr->location<e_LOC_COUNT_)
            {
                gCurrentLocation=itemPtr->location;
            }
            break;
        }
    }
}
#endif
