//
// Special mode to show a system compatibility mode
//
#include <lib.h>

#include "score.h"

typedef struct 
{
    union
    {
       unsigned char bytes[4]; 
       unsigned int shorts[2]; 
    };
} Crc32;

typedef struct
{
    Crc32 CRC;
    const char* Name;
} RomFile;


extern Crc32 CRC;

RomFile KnownRoms[]=
{
    { 0xf1,0x87,0x10,0xb4,	"basic10.rom (Oric 1)" },
    { 0xc3,0xa9,0x2b,0xef,	"basic11b.rom (Atmos)" },
    { 0x1d,0x96,0xab,0x50,	"hyperbas.rom (Telestrat)" },
    { 0xB9,0x9A,0x93,0x4B,	"Atmos ROM 1.1 (LOCI patch)" },
    { 0xB5,0xD3,0x12,0xB9,	"Atmos ROM 1.1 (EREBUS patch)" },
    { 0x49,0xa7,0x4c,0x06,	"8dos.rom" },
    { 0x58,0x07,0x95,0x02,	"pravetzt.rom" },
    { 0x2B,0xCD,0xD8,0x7E,	"PRAVETZ (ORICUTRON)" },             // Strangely, does not match any CRC32 of any of the files in the ROMS folder Oo?
    { 0x68,0xb0,0xfd,0xe6,	"teleass.rom" },
    { 0xaa,0x72,0x7c,0x5d,	"telmon24.rom" },
    { 0xbc,0x6f,0x21,0xdb,	"pravetzt-1.0.rom" },
    { 0,0,0,0,0 },
};
/* Additional hashes From HashMyFiles
---- 16K ---- 
---- 8K ---- 
0c82f636		eprom8d.rom			
3e652e2a		cumana.rom			
94358dc6		telmatic.rom			
a9664a9c		microdis.rom			

---- 2K ---- 
37220e89		jasmin.rom			
5d301b9b		8dos2.rom			

---- 1K ---- 
61952e34		bd500.rom			

*/

typedef struct 
{
    const char* sound;
    const char* name;
} SoundEffect;

SoundEffect SoundEffects[]=
{
    { ZapData, "Zap" },
    { ShootData, "Shoot" },
    { PingData, "Ping" },
    { ExplodeData, "Explode" },
    { KeyClickHData, "Key Click (High)" },
    { KeyClickLData, "Key Click (Low)" },
    { 0, 0 },
};



typedef struct
{
    union 
    {
       unsigned char bytes[4]; 
       unsigned int shorts[2]; 
    };   
} TimeStamp;

typedef struct
{
    unsigned char id;
    const char* name;
    TimeStamp minTime;
    TimeStamp maxTime;
    unsigned int deltaTime;
} FilePerf;

FilePerf ImageList[]=
{
    { LOADER_PICTURE_WATCH_ALARM, "",0,0,0},
    { LOADER_PICTURE_BASEMENT_WINDOW_DARK, "",0,0,0},
    { LOADER_PICTURE_DONKEY_KONG_TOP, "",0,0,0},
    { LOADER_PICTURE_LOCATIONS_STEPS, "",0,0,0},
    { LOADER_PICTURE_SCIENCE_BOOK, "",0,0,0},
    { OUTRO_PICTURE_DESK, "",0,0,0},
    //{ 0, "",0,0,0},
    { LOADER_PICTURE_LOCATIONS_WELL, "",0,0,0},
    { LOADER_PICTURE_LOCATIONS_TOILET, "",0,0,0},
    { LOADER_PICTURE_MOTHERBOARD, "",0,0,0},
    { 0, "",0,0,0},
};

char FirstImageLoading = 1;

extern TimeStamp ProfilerCycleCountTimeStamp;
extern unsigned int ProfilerCycleCountTop;
extern unsigned int ProfilerCycleCountBottom;

extern unsigned int ProfilerFrameCount;          // 16 bits frame counter
extern unsigned int ProfilerCycleCount;          // 2 first bytes of the 24 bit counter
extern unsigned char ProfilerCycleCountLow;      // 24 bits cycle counter (should be in Zero Page, really)
extern unsigned char ProfilerCycleCountMid;      // 24 bits cycle counter (should be in Zero Page, really)
extern unsigned char ProfilerCycleCountHigh;     // 24 bits cycle counter (should be in Zero Page, really)


unsigned int GetDelta(TimeStamp* maxTime,TimeStamp* minTime)
{
    unsigned int delta;
    // Should check if the top short is different though...
    delta=maxTime->shorts[0] - minTime->shorts[0];
    return delta;
}


void GetDuration(TimeStamp* maxTime,TimeStamp* minTime,unsigned int* seconds,unsigned int* rest,unsigned int* rest2)
{
    unsigned int cyclesBy256;
    unsigned int cyclesPerSecondsBy256;
    unsigned int cyclesPerSecondsBy2560;
    unsigned int duration;
    unsigned int durationModulo;

    cyclesBy256= *((unsigned int*)(&maxTime->bytes[1]));
    cyclesPerSecondsBy256=3906;                                                                  // 1 000 000 / 256 = 3906.25
    cyclesPerSecondsBy2560=391;                                                                  // 1 000 000 / 256 = 3906.25 / 10 ) 390.625

    *seconds=cyclesBy256/3906;                     // 1 000 000 / 256 = 3906.25
    cyclesBy256-=(*seconds*3906);

    *rest   =cyclesBy256/391;                      // 1 000 000 / 256 = 3906.25 / 10 ) 390.625
    cyclesBy256-=(*rest*391);

    *rest2  =cyclesBy256/39;
}


char* StatusScreenLine=(char*)0xbb80+40*27;

void PrintWaitMessage(const char* message)
{
    // Erase the existing message
    StatusScreenLine[0]=16+4;
    StatusScreenLine[1]=3;
    memset(StatusScreenLine+2,32,40-2);
    if (message && message[0])
    {
        // Print the new message
        int length=strlen(message);
        strcpy(StatusScreenLine+20-length/2,message);
    }
}


unsigned int seconds=0;
unsigned int rest=0;
unsigned int rest2=0;
unsigned int duration=0;
unsigned int delta=0;

void main()
{
	// Install the 50hz IRQ
	System_InstallIRQ_SimpleVbl();

 	// Setup the Hires/Text mixed graphic mode
	//Text(16,7);      
    InitializeGraphicMode();

    memcpy((char*)0xb500,(char*)0x9900,8*96);

    {
        char* ScreenLine=(char*)0xbb80+40*16;          // maps to 0x3b80 on 16KB machines

        memset(ScreenLine,32,40*28);
        sprintf(ScreenLine,"%c%c%c%s%s%c",16+4,3,10,"   ENCOUNTER SYSTEM CHECK v",VERSION,0);
        ScreenLine+=40;
        sprintf(ScreenLine,"%c%c%c%s%s%c",16+4,3,10,"   ENCOUNTER SYSTEM CHECK v",VERSION,0);
        ScreenLine+=40;

        // System type (Microdisc or Jasmin) and amount of memory (the probability we got here with a 16K machine is close to absolute zero)
        {
            unsigned char ram=48;
            ScreenLine+=40;
            sprintf(ScreenLine,"System type: %s",(LoaderApiSystemType==LOADER_SYSTEM_TYPE_MICRODISC)?"Microdisc":"Jasmin");
            if (strcmp((char*)0xbb80,(char*)0x3b80)==0)
            {
                // 16k machine
                ram=16;
            }
            sprintf(ScreenLine+31,"RAM: %dKB",ram);
            ScreenLine+=40;
        }

        // Find the ROM type
        {
            unsigned char system_type = LoaderApiSystemType;   // We need to copy it, because when the ROM is enabled we can't read the overlay anymore!
            PrintWaitMessage("Computing CRC32");

            // In order to compute the CRC of the ROM, we have to make sure the ROM is actually enabled.
            // Since we just loaded from disk, it means that we currently are using the overlay ram which now contains the loader
            //
            // Enabling/disabling the overlay is different on Microdic and Jasmin.
            // To avoid crashing, we need to disable the IRQ else the system will try to access stuff that does not exist
            //

            if (system_type==LOADER_SYSTEM_TYPE_MICRODISC)
            {
                // ---------- MICRODISC ---------- 
                // On Microdisc, location $314 contains the following flags on write operations
                // bit 7: Eprom select (active low) 
                // bit 6-5: drive select (0 to 3) 
                // bit 4: side select 
                // bit 3: double density enable (0: double density, 1: single density) 
                // bit 2: along with bit 3, selects the data separator clock divisor            (1: double density, 0: single-density) 
                // bit 1: ROMDIS (active low). When 0, internal Basic rom is disabled. 
                // bit 0: enable FDC INTRQ to appear on read location $0314 and to drive cpu IRQ	
                // and $0318 bit 7 contains the state of DRQ
                asm("sei:lda #%00000010:sta $314");
            }
            else
            {
                // ---------- JASMIN ---------- 
                // Some information from the Oric Hardware Programming Guide (http://oric.free.fr/programming.html#disc)
                // The FDC 1793 (or 1773) is accessible through locations [...] 03F4-03F7 in Jasmin's electronics.
                // Jasmin's electronics also features buffers for side/drive selecting, and memory signals, 
                // but the DRQ line is connected to the system IRQ line so it allows for interrupt-driven transfers 
                // (however, two consecutives bytes are separated by 31.25 micro-seconds, so the interrupt routine 
                // has to be fast ! As an example, FT-DOS uses a dedicated interrupt routine, and does not even have 
                // time to save registers: the interrupt routine lasts 28 cycles) The end of a command has to be 
                // detected by reading the busy bit of the Status Register of the FDC.
                // location 03F8 -> bit 0: side select 
                // location 03F9 : disk controller reset (writing any value will reset the FDC) 
                // location 03FA -> bit 0: overlay ram access (1 means overlay ram enabled) 
                // location 03FB -> bit 0: ROMDIS (1 means internal Basic rom disabled) 
                // locations 03FC, 03FD, 03FE, 03FF : writing to one of these locations will select the corresponding drive 
                asm("sei:lda #0:sta $3fa:lda #0:sta $3fb");
            }

            ComputeROMCRC32();


            if (system_type==LOADER_SYSTEM_TYPE_MICRODISC)
            {
                // Microdisc
                asm("lda #%10000001:sta $314:cli");
            }
            else
            {
                // Jasmin
                asm("lda #1:sta $3fa:lda #1:sta $3fb:cli");
            }

            PrintWaitMessage("");
            ScreenLine+=40;
            sprintf(ScreenLine,"ROM CRC32: %x%x",CRC.shorts[1],CRC.shorts[0]);
            ScreenLine+=40;

            // Search matching rom
            {
                RomFile* romPtr=KnownRoms;
                while (romPtr->Name)
                {
                    if ( (romPtr->CRC.bytes[0] == CRC.bytes[3]) && 
                        (romPtr->CRC.bytes[1] == CRC.bytes[2]) && 
                        (romPtr->CRC.bytes[2] == CRC.bytes[1]) && 
                        (romPtr->CRC.bytes[3] == CRC.bytes[0]) )
                    {
                        // We have a match
                        break;
                    }
                    ++romPtr;
                }
                if (romPtr->Name)
                {
                    sprintf(ScreenLine,"Match: %s", romPtr->Name);
                }
                else
                {
                    sprintf(ScreenLine,"No known ROM found, please contact us!");
                }
                ScreenLine+=40;
            }
        }        

        {
            // Load the first picture at the default address specified in the script
            PrintWaitMessage("Loading picture");
            LoadFileAt(LOADER_PICTURE_MOTHERBOARD,0xa000);
            PrintWaitMessage("");
        }

        {
            // Loading the highscores
            PrintWaitMessage("Loading High Scores");
            LoadFileAt(LOADER_HIGH_SCORES,&gSaveGameFile);
            ScreenLine+=40;
            sprintf(ScreenLine,"Write attempts: %d",gSaveGameFile.launchCount);
            ScreenLine+=40;
            PrintWaitMessage("");
        }


        while (1)
        {
            unsigned char k;
            PrintWaitMessage("M:Music S:SoundFx R:Read W:Write");
            k=WaitKey();
            switch (k)
            {
            case 's':
            case 'S':
                {
                    // Sound test: Play each of the sound effect one after the other
                    SoundEffect* effectPtr=SoundEffects;
                    while (effectPtr->sound)
                    {
                        PrintWaitMessage(effectPtr->name);
                        PlaySound(effectPtr->sound);
                        WaitFrames(50);
                        effectPtr++;
                    }
                }
                break;

            case 'm':
            case 'M':
                {
                    // Sound test: Play the Arkos tracker intro music
                    PrintWaitMessage("Playing Music (Press any key to leave)");
                #ifdef ENABLE_MUSIC
                    PlayMusic(JingleMusic);
                #endif    
                    WaitKey();
                #ifdef ENABLE_MUSIC
                    EndMusic();
                #endif    
                    PsgStopSoundAndForceUpdate();                    
                }
                break;

            case 'w':
            case 'W':
                {
                    // Sound test: Play the Arkos tracker intro music
                    PrintWaitMessage("Write test (Ensure Protection OFF!)");
                    gSaveGameFile.launchCount++;
                    // Save back the highscores in the slot
                    SaveFileAt(LOADER_HIGH_SCORES,gHighScores);
                    PrintWaitMessage("Write test finished");
                    WaitFrames(50);
                }
                break;

            case 'r':
            case 'R':
                {
                    unsigned int passCounter;
                    unsigned int total_delay;
                    unsigned int delay;
                    unsigned int total_loaded;
                    // Disk test: Load a series of images and measure the time it takes to load

                    PrintWaitMessage("");

                    ProfilerInitialize();
                    for (passCounter=0;passCounter<10;passCounter++)
                    {
                        char buffer[80];
                        FilePerf* imagePtr=ImageList;
                        ScreenLine=(char*)0xbb80+40*18;
                        if (FirstImageLoading)
                        {
                            memset(ScreenLine,32,40*9);
                        }
                        sprintf((char*)0xbb80+40*27+2,"Pass %d/10",passCounter+1);

                        total_loaded=0;
                        while (imagePtr->id)
                        {
                            unsigned int index=imagePtr->id;


                            sprintf((char*)0xbb80+40*27+20,"%c%u bytes     ",2,total_loaded);

                            ProfileStartFunction();
                            LoadFileAt(index,0xa000);
                            ProfileEndFunction();
                            total_loaded+=5120;

                            if (FirstImageLoading)
                            {
                                imagePtr->minTime.shorts[0]=ProfilerCycleCountTimeStamp.shorts[0];
                                imagePtr->minTime.shorts[1]=ProfilerCycleCountTimeStamp.shorts[1];
                                imagePtr->maxTime.shorts[0]=ProfilerCycleCountTimeStamp.shorts[0];
                                imagePtr->maxTime.shorts[1]=ProfilerCycleCountTimeStamp.shorts[1];
                            }
                            else
                            {
                                if ( (ProfilerCycleCountTimeStamp.shorts[1]<imagePtr->minTime.shorts[1]) ||
                                ( (ProfilerCycleCountTimeStamp.shorts[1]==imagePtr->minTime.shorts[1]) && (ProfilerCycleCountTimeStamp.shorts[0]<imagePtr->minTime.shorts[0]) ) )
                                {
                                    imagePtr->minTime.shorts[0]=ProfilerCycleCountTimeStamp.shorts[0];
                                    imagePtr->minTime.shorts[1]=ProfilerCycleCountTimeStamp.shorts[1];
                                }

                                if ( (ProfilerCycleCountTimeStamp.shorts[1]>imagePtr->maxTime.shorts[1]) ||
                                ( (ProfilerCycleCountTimeStamp.shorts[1]==imagePtr->maxTime.shorts[1]) && (ProfilerCycleCountTimeStamp.shorts[0]>imagePtr->maxTime.shorts[0]) ) )
                                {
                                    imagePtr->maxTime.shorts[0]=ProfilerCycleCountTimeStamp.shorts[0];
                                    imagePtr->maxTime.shorts[1]=ProfilerCycleCountTimeStamp.shorts[1];
                                }
                            }

                            delta=GetDelta(&imagePtr->maxTime,&imagePtr->minTime);
                            GetDuration(&imagePtr->maxTime,&imagePtr->minTime,&seconds,&rest,&rest2);

                            memset(buffer,32,40);
                            sprintf(buffer,"%u    ",index);   // Image index
                            sprintf(buffer+5,"%x%x    ",imagePtr->minTime.shorts[1],imagePtr->minTime.shorts[0]);   // Min cycles
                            buffer[3]='M';
                            buffer[4]='i';
                            buffer[5]='n';
                            buffer[6]=':';

                            sprintf(buffer+16,"%x%x    ",imagePtr->maxTime.shorts[1],imagePtr->maxTime.shorts[0]);   // Max cycles
                            buffer[14]='M';
                            buffer[15]='a';
                            buffer[16]='x';
                            buffer[17]=':';

                            sprintf(buffer+25,"%u    ",delta);   // Min-Max Delta
                            sprintf(buffer+32,"%u.%u%u sec",seconds,rest,rest2);    // seconds

                            memcpy(ScreenLine,buffer,40);

                            /*
                            //sprintf(ScreenLine,"Image %d Duration %x%x%x (%u)  ",index,ProfilerCycleCountHigh,ProfilerCycleCountMid,ProfilerCycleCountLow,ProfilerCycleCount);
                            sprintf(ScreenLine,"#%x Min:%x%x Max:%x%x (%u)  ",
                                    index,
                                    imagePtr->minTime.shorts[1],imagePtr->minTime.shorts[0],
                                    imagePtr->maxTime.shorts[1],imagePtr->maxTime.shorts[0],
                                    delta);
                                    */
                            ScreenLine+=40;

                            imagePtr++;
                        }            
                        FirstImageLoading=0;
                    }
                    ProfilerTerminate();
                }
                break;
            }
        }
    }

	System_RestoreIRQ_SimpleVbl();
}


