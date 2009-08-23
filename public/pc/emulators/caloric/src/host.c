/*
 *	host.c - various stuff
 *	FF sometime in 1994-1997
 */

/*
Parts of this file copyright 1994-1997 Fabrice Francès.
Parts of this file copyright 2000-2003 André Majorel.

This program is free software; you can redistribute it and/or modify it under
the terms of version 2 of the GNU General Public License as published by the
Free Software Foundation.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program; if not, write to the Free Software Foundation, Inc., 59 Temple
Place, Suite 330, Boston, MA 02111-1307, USA.
*/

#include "config.h"
#include <ctype.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <time.h>

#include <unistd.h>
#if HAVE_IOPERM
#  include <sys/io.h>
#endif
#include <sys/types.h>
#include <sys/stat.h>

#include "caloric.h"
#include "dsp.h"
#include "hardware.h"
#include "keyb_us.h"
#include "traps.h"


static void parse_rcfile (const char *setup, FILE *setup_fp);

extern char Eprom[8192];
extern char Banks[8][16384];
extern char RomBank[8];
extern int Bank_point;
extern int Eprom_start;
extern char ram_pattern;
extern int Com_port, Com_Addr, serial_desc;
extern int cycles,initial_cycles;
extern char sound;
extern char joystick,joystickport,acia,rtclock,printer;
extern char jasmin,telestrat,disk;
extern int rs232;

static char *temppath="";
char output_name[64]="", dump_name[128]="";
char serial_name[64]="", printer_name[128]="";
static char oric1_name[128]="", atmos_name[128]="", bank_name[8][128]={"","","","","","","",""};
static char microdisc_name[128]="", jasmin_name[128]="";
char atmos=1;
char messages[35][41];
int quit_on_trap;
int zoom;
int debugger = 0;

int machine_changed=0;
int zoom_changed=1;
int current_machine;

void Load_ROM(unsigned char *rom_adr)
{
  const char *basename = atmos ? atmos_name : oric1_name;
  char *pathname;
  FILE *rom_fp;

  pathname = locate_file (basename, datapath);
  if (pathname == NULL)
  {
    err ("%s: not found", basename);
    exit (1);
  }
  rom_fp = fopen (pathname, "rb");
  if (rom_fp == NULL)
  {
    err ("%s: %s", pathname, strerror (errno));
    exit (1);
  }
  if (fread (rom_adr, 16384, 1, rom_fp) != 1)
  {
    err ("%s: read error", pathname);
    exit (1);
  }
  fclose (rom_fp);
  free (pathname);
}

void Load_EPROM()
{
  const char *basename = jasmin ? jasmin_name : microdisc_name;
  char *pathname;
  FILE *eprom_fp;
  int size;

  pathname = locate_file (basename, datapath);
  if (pathname == NULL)
  {
    err ("%s: not found", basename);
    exit (1);
  }
  eprom_fp = fopen (pathname, "rb");
  if (eprom_fp == NULL)
  {
    err ("%s: %s", pathname, strerror (errno));
    exit (1);
  }
  size = fread (Eprom, 1, 16384, eprom_fp);
  if (size < 1)
  {
    err ("%s: read error", pathname);
    exit (1);
  }
  if (size < 16384)
    memcpy (Eprom + 16384 - size, Eprom, size);
  Eprom_start = 0x10000 - size;
  Bank_point = Eprom_start;
  fclose (eprom_fp);
  free (pathname);
}

/*****************************************************************************/
void Load_Banks()
{
  int i, size;
  for (i = 1; i < 8; i++)
  {
    char *pathname;
    if (bank_name[i][0]=='\0')
      continue;
    pathname = locate_file (bank_name[i], datapath);
    if (pathname == NULL)
    {
      err ("bank #%d: %s: not found", i, pathname);
    }
    else
    {
      FILE *rom_fp = fopen (pathname, "rb");
      if (rom_fp == NULL)
      {
	err ("bank #%d: %s: %s", i, pathname, strerror (errno));
      }
      else
      {
	RomBank[i] = 1;
	size = fread (Banks[i], 1, 16384, rom_fp);
	if (size < 16384)
	  memcpy ((char *) (Banks + i) + 16384 - size, Banks + i, size);
	fclose (rom_fp);
      }
      free (pathname);
    }
  }
  Bank_point=0xC000;
  if (!RomBank[7]) {
	  err ("no bank #7");
	  err ("check your caloricrc");
	  exit(1);
  }
}

/***************************************************************************/
char tape_name[256]="";
extern FILE *tape_handle;
extern char protected_tape;

int Open_Tape(const char *name)
{
	err ("Open_Tape(%s)", name);	/* FIXME DEBUG */
	if (tape_handle) Close_Tape();
	protected_tape=0;
	tape_handle=fopen(name,"r+b");
	if (tape_handle==NULL) {
		tape_handle=fopen(name,"rb");
		if (tape_handle==NULL) return 0;
		protected_tape=1;
	}
	strcpy(tape_name,name);
	return 1;
}

void protect_tape(void)
{
	if (!tape_handle) return;
	fclose(tape_handle);
	tape_handle=NULL;
	chmod(tape_name,0444);
	Open_Tape(tape_name);
}

void unprotect_tape(void)
{
	if (!tape_handle) return;
	fclose(tape_handle);
	tape_handle=NULL;
	chmod(tape_name,0644);
	Open_Tape(tape_name);
}

void Close_Tape(void)
{
	err ("Close_Tape()");		/* FIXME DEBUG */
	if (tape_handle) fclose(tape_handle);
	tape_handle=NULL;
	tape_name[0]=0;
}

void Create_Tape(void)
{
	if (tape_handle) fclose(tape_handle);
	tape_name[0]=0;
	protected_tape=0;
	tape_handle=fopen("________","w+b");
	if (tape_handle==NULL) return;
	strcpy(tape_name,"________");
}

/***************************************************************************/

/***************************************************************************/
extern int nbdisks;
extern char diskbuf[8192];
extern FILE *fd[4];
extern char write_only[4];
extern char drives[4];

static int current_drive;
static char diskid[8];
static int sides[4];
static int tracks[4];
static int geometry[4];                /* 1 : whole side 0 first */
static char disk_signature[]="MFM_DISK";
char disk_name[4][256]={ "", "", "", "" };

int Open_Disk(char *name,int drive)
{
	Close_Disk(drive);
	write_only[drive]=0;
	fd[drive]=fopen(name,"r+b");
	if (fd[drive]==NULL) {
		fd[drive]=fopen(name,"rb");
		if (fd[drive]==NULL) return 0;
		write_only[drive]=1;
	}
	fread(diskid,8,1,fd[drive]);
	if (strncmp(diskid,disk_signature,8)!=0) {
		err("%s is not an Oric disk image",name);
		return 0;
	}
	fread(&sides[drive],1,4,fd[drive]);
	fread(&tracks[drive],1,4,fd[drive]);
	fread(&geometry[drive],1,4,fd[drive]);
	strcpy(disk_name[drive],name);
	return 1;
}

void Close_Disk(int drive)
{
	if (fd[drive]) fclose(fd[drive]);
	fd[drive]=NULL;
	disk_name[drive][0]=0;
}

int Create_Disk(int drive)
{
	if (fd[drive]) fclose(fd[drive]);
	disk_name[drive][0]=0;
	write_only[drive]=0;
	fd[drive]=fopen("________.dsk","w+b");
	if (fd[drive]==NULL) return 0;
	strcpy(disk_name[drive],"________.dsk");
	return 1;
}

void disk_flushbuf(void)
{
	if (fd[current_drive]!=NULL) {
		fwrite(diskbuf,6400,1,fd[current_drive]);
		fseek(fd[current_drive],-6400,SEEK_CUR);
	}
}


void disk_read_track(int drive,int side,int track)
{
	long offset=(side*tracks[drive]+track)*6400+256;
	current_drive=drive;
	memset(diskbuf,0,6400);
	if (fd[drive]!=NULL) {
		fseek(fd[drive],offset,SEEK_SET);
		fread(diskbuf,6400,1,fd[drive]);
		fseek(fd[drive],-6400,SEEK_CUR);
	}
}

int disk_format(int drive,int side,int track)
{
	long offset;
	if (fd[drive]==NULL) {
		if (Create_Disk(drive)==0) return 1;
	}
	if (write_only[drive]) return 1;
	if (side+1>sides[drive]) sides[drive]=side+1;
	if (track+1>tracks[drive]) tracks[drive]=track+1;
	offset=(side*tracks[drive]+track)*6400+256;
	fseek(fd[drive],0,SEEK_SET);
	fwrite(disk_signature,8,1,fd[drive]);
	fwrite(&sides[drive],4,1,fd[drive]);
	fwrite(&tracks[drive],4,1,fd[drive]);
	fwrite(&geometry,4,1,fd[drive]);
	fseek(fd[drive],offset,SEEK_SET);
	fwrite(diskbuf,6400,1,fd[drive]);
	return 0;
}

/***************************************************************************/

void Save_hardcopy()
{

}

/***************************************************************************/
extern char State[64];
static const char dump_pathname[] = "Dump";  /* FIXME use dump_name instead ? */

void Dump(char *mem)
{
	FILE *dump_fd;
	dump_fd=fopen(dump_pathname,"wb");
	if (dump_fd!=NULL) {
		fwrite(mem,1,65536,dump_fd);
		fwrite(State,1,64,dump_fd);
		fclose(dump_fd);
	}
}

void Load_Dump(unsigned char *mem)
{
	FILE *dump_fd;
	dump_fd=fopen(dump_pathname,"rb");
	if (dump_fd==NULL) {
		err("%s: %s",dump_pathname,strerror(errno));
		err("Dump file %s does not exist",dump_pathname);
		err("(Please check caloricrc)");
		exit(1);
	}
	fread(mem,1,65536,dump_fd);
	fread(State,1,64,dump_fd);
	fclose(dump_fd);
}

/***************************************************************************/

static FILE    *printfd=NULL;

void Start_Printer()
{
	printfd=fopen(printer_name,"wb");
	if (printfd==NULL) {
		err("%s: %s",printer_name,strerror(errno));
		err("Can't open printer output %s",printer_name);
		err("(Please check it or modify caloricrc)");
		exit(1);
	}
}

void Printer(char c)
{
	if (printfd) putc(c,printfd);
}

/***************************************************************************/
void Start_RS232(void)
{
	if (*serial_name == '\0') {
		serial_desc = -1;
	}
	else {
#ifdef O_NDELAY
		serial_desc=open(serial_name,O_RDWR | O_NDELAY);
#else
#ifdef O_NONBLOCK
		serial_desc=open(serial_name,O_RDWR | O_NONBLOCK);
#else
		serial_desc = -1;
#endif
#endif
		if (serial_desc==-1) {
			err("%s: %s",serial_name,strerror(errno));
			err("Can't open communication port %s",serial_name);
			err("(Please check it or modify caloricrc)");
			exit(1);
		}
	}
}
/***************************************************************************/

int init(int argc, char *argv[])
{
	int speed_index,restart=0;
	int g;
    zoom = 1;
debugger=1;
current_machine=1;
	while ((g = getopt (argc, argv, "1aA:djJpQrs:S:tX:z:g")) != EOF) {
		if      (g == '1') { telestrat=0; atmos=0; current_machine=0; }
		else if (g == 'a') { telestrat=0; atmos=1; current_machine=1;}
		else if (g == 'A') { audio_device=optarg; }
		else if (g == 'd') {  disk=1; }
		else if (g == 'j') { telestrat=0; jasmin=1; disk=1; }
		else if (g == 'J') { joystickport=1; }
		else if (g == 'p') { joystick=1; disable_keypad(); }
		else if (g == 'Q') { quit_on_trap = 1; }
		else if (g == 'r') { restart=1; }
		else if (g == 'g') { debugger=1; }
		else if (g == 's') {
			sscanf (optarg, "%d", &speed_index);
			if (speed_index<10) {
				err("Speed index of %d%% ? Surely you're "
					"joking, Mr. Feynman...",speed_index);
				exit(1);
			}
			initial_cycles=cycles=200*speed_index;
		}
		else if (g == 'S') {
			if (strcmp (optarg, "sdl") == 0)
				audio_method = AM_SDL;
			else if (strcmp (optarg, "arts") == 0)
				audio_method = AM_ARTS;
			else if (strcmp (optarg, "auto") == 0)
				audio_method = AM_ARTS_OSS;
			else if (strcmp (optarg, "oss") == 0)
				audio_method = AM_OSS;
			else if (strcmp (optarg, "alsa") == 0)
				audio_method = AM_ALSA;

			else {
				err ("the sound output method must be \"alsa\", \"arts\""
					", \"auto\" or \"oss\"");
				exit (1);
			}
		}
		else if (g == 't') { telestrat=1; disk=1; current_machine=2;}

		else if (g == 'z')
		{
		  zoom = atoi(optarg);
		  if (zoom < 1)
		  {
		    err ("the zoom factor must be greater than 1");
		    exit (1);
		  }
		}
		else
			exit(1);
	}
	{
		int n;

		for (n = optind; n < argc; n++)
			if (Open_Disk(argv[n],nbdisks++))
				disk=1;
	}

	if (telestrat) { disk=1; jasmin=0; acia=1; }
	if (jasmin) { disk=1; }

	if (joystick) joystickport=0;
	if (printer) Start_Printer();
	if (acia && *serial_name != '\0')
	{
#if HAVE_IOPERM
	  if (ioperm(0x3f8, 8, 1) != 0)	/* ttyS0 */
	  {
	    err("ioperm(0x3f8,8): %s, disabling 6551 emulation",
		strerror (errno));
	    goto rs232_fini;
	  }
	  if (ioperm(0x2f8, 8, 1) != 0)	/* ttyS1 */
	  {
	    err("ioperm(0x2f8,8): %s, disabling 6551 emulation",
		strerror (errno));
	    goto rs232_fini;
	  }
	  rs232 = 1;
rs232_fini:
	  ;
#else
	  err("ioperm not available on this platform,"
	      " disabling 6551 emulation");
#endif
	}
	if (rs232) Start_RS232();



	Init_Hard();
	if (telestrat) {
		Load_Banks();
	} else {
		if (disk) {
			Load_EPROM();
		}
		Load_ROM(Oric_Mem+0x10000);
	}
	if (restart) Load_Dump(Oric_Mem);
	Patch_ROM();
	return restart;
}

void redirect_output(void)
{
	sprintf(output_name,"/tmp/euphoric.lst");
	freopen(output_name,"w",stdout);
	rewind(stdout);
}

void delete_output(void)
{
	unlink(output_name);
}

void remove_eol(char *str)
{
	int i;
	for(i=strlen(str)-1; str[i]==' ' || str[i]=='\r' || str[i]=='\n'; i--)
		str[i]='\0';
}

void setup(char *env[])
{
  int i;
  const char **p;
  int count = 0;
  FILE *fp;
  for (i = 0; i < 35; i++)
    messages[i][0] = 0;
  for(i=0;env[i]!=NULL;i++)
  {
    if (strncmp (env[i], "TEMP=", 5) == 0)
      temppath = (&env[i][5]);
  }

  for (p = rcfiles; *p != NULL; p++)
  {

    char *pathname = NULL;

    pathname = expand_path (*p);
     #ifdef DEBUG_RELEASE
      printf("Trying to find %s in %s\n",*p,pathname);
     #endif

    fp = fopen (pathname, "r");
    if (fp == NULL)
    {
      if (errno != ENOENT)
	err("warning: %s: %s", pathname, strerror (errno));
     #ifdef DEBUG_RELEASE
      printf("Can't found %s\n",pathname);
     #endif


    }
    else
    {
      parse_rcfile (pathname, fp);
      #ifdef DEBUG_RELEASE
      printf("Reading %s\n",pathname);
      #endif
      count++;
      fclose (fp);
    }
    free (pathname);
  }
 // #endif
  if (count == 0)
    err("warning: no config file found");
}

static void parse_rcfile (const char *setup, FILE *setup_fp)
{
	char line[256];
	float frequency;

	while(!feof(setup_fp)) {
		fgets(line,256,setup_fp);
		remove_eol(line);
		if (strncmp(line,"Computer=",9)==0) {
			if (strcmp(line+9,"Oric1")==0)
				;
			else if (strcmp(line+9,"Atmos")==0)
				atmos=1;
			else if (strcmp(line+9,"Telestrat")==0 || strcmp(line+9,"Stratos")==0)
				telestrat=1;
		} else if (strncmp(line,"DiskController=",15)==0) {
			if (strcmp(line+15,"Microdisc")==0)
				disk=1;
			else if (strcmp(line+15,"Jasmin")==0)
				jasmin=1;
		} else if (strncmp(line,"Oric1Rom=",9)==0) {
			strcpy(oric1_name,line+9);
		} else if (strncmp(line,"AtmosRom=",9)==0) {
			strcpy(atmos_name,line+9);
		} else if (strncmp(line,"MicrodiscEprom=",15)==0) {
			strcpy(microdisc_name,line+15);
		} else if (strncmp(line,"JasminEprom=",12)==0) {
			strcpy(jasmin_name,line+12);
		} else if (strncmp(line,"Bank7=",6)==0) {
			strcpy(bank_name[7],line+6);
		} else if (strncmp(line,"Bank6=",6)==0) {
			strcpy(bank_name[6],line+6);
		} else if (strncmp(line,"Bank5=",6)==0) {
			strcpy(bank_name[5],line+6);
		} else if (strncmp(line,"Bank4=",6)==0) {
			strcpy(bank_name[4],line+6);
		} else if (strncmp(line,"Bank3=",6)==0) {
			strcpy(bank_name[3],line+6);
		} else if (strncmp(line,"Bank2=",6)==0) {
			strcpy(bank_name[2],line+6);
		} else if (strncmp(line,"Bank1=",6)==0) {
			strcpy(bank_name[1],line+6);
		} else if (strncmp(line,"RamPattern=",11)==0) {
			ram_pattern=line[11]&1;
		} else if (strncmp(line,"DriveA=",7)==0) {
			drives[0]=(line[7]!='N' && line[7]!='n');
		} else if (strncmp(line,"DriveB=",7)==0) {
			drives[1]=(line[7]!='N' && line[7]!='n');
		} else if (strncmp(line,"DriveC=",7)==0) {
			drives[2]=(line[7]!='N' && line[7]!='n');
		} else if (strncmp(line,"DriveD=",7)==0) {
			drives[3]=(line[7]!='N' && line[7]!='n');
		} else if (strncmp(line,"Clock=",6)==0) {
			sscanf(line+6,"%f",&frequency);
			initial_cycles=cycles=((int)(frequency*10.0))*2000;
		} else if (strncmp(line,"AsynchronousController=",23)==0) {
			acia=(line[23]!='N' && line[23]!='n');
		} else if (strncmp(line,"SerialPort=",11)==0) {
			strcpy(serial_name,line+11);
		} else if (strncmp(line,"RealTimeClock=",14)==0) {
			rtclock=(line[14]!='N' && line[14]!='n');
		} else if (strncmp(line,"Joystick=",9)==0) {
			joystick=(line[9]!='N' && line[9]!='n');
		} else if (strncmp(line,"JoystickPort=",13)==0) {
			joystickport=(line[13]!='N' && line[13]!='n');
		} else if (strncmp(line,"Printer=",8)==0) {
			printer=(line[8]!='N' && line[8]!='N');
		} else if (strncmp(line,"PrinterOutput=",14)==0) {
			strcpy(printer_name,line+14);
		} else if (strncmp(line,"DumpFile=",9)==0) {
			strcpy(dump_name,line+9);
		} else if (line[0]>='0' && line[0]<='9' && line[1]>='0' && line[1]<='9' && line[2]=='=') {
			int number=(line[0]-'0')*10+line[1]-'0';
			if (number<35) {
				strncpy(messages[number],line+3,41);
				messages[number][40]=0;
			}
		}
	}
}
