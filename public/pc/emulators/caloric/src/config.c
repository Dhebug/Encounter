/*
 *	config.c - config screen
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


#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <setjmp.h>

#include <unistd.h>
//#include <glib.h>

#include "caloric.h"
#include "hardware.h"
#include "keyb_us.h"
#include "traps.h"

extern char atmos;
extern char telestrat;
extern char disk;
extern char jasmin;
extern char acia;

extern char Kbd_Matrix[];
extern char env_screen,exit_menu;
extern int Com_port,Com_Addr;
extern char Tick;
extern char disk_name[4][256];
extern char drives[4];
extern char write_only[4];
extern char joystick,joystickport;
extern char sound;
extern int cycles;
extern char screen_mode;
extern int addr_char_gen0,addr_char_gen1;
extern char disk;
extern char telestrat;
extern FILE *tape_handle;
extern char tape_name[];
extern char protected_tape;
extern char record;
extern char HardwareTape;
extern char charset[],charset2[];
extern char output_name[];
extern char messages[][41];
extern char hard_screen;
static void open_list(void);
static void init_list(void);
static void close_list(void);
static int read_dir_entry(char *buf);
static void print_screen(void);
static int menu(void);
static void print_clockspeed(void);
static void print_machine(void);
static void print_tape_pos(void);
static void print_zoom(void);
void reinvoke_fdc_command (void);  /* 1793.S */

static unsigned char *screen=Oric_Mem+0xBB80;
static int cursor=0;
static int paper_color=0x16, ink_color=0;
static int select_paper_color=0x14, select_ink_color=2;
static int select_choice=13;
static jmp_buf context;
extern int zoom_changed;

void clear_screen(void)
{
	int i;
	memset(screen,' ',28*40);
	for(i=0;i<28;i++) {
		screen[i*40]=paper_color;
		screen[i*40+1]=ink_color;
	}
	cursor=2;
}

void set_cursor(int n)
{
	cursor=n;
}

void print_char(char c)
{
	screen[cursor++]=c;
}

void print(const char *str)
{
	while(*str) {
		if (*str>=0) screen[cursor++]=*str++;
		else { screen[cursor++]='?'; str++; }
	}
}

void print_line(char *str)
{
	int i=cursor%40;
	for(;i<40;i++) {
		if (*str<0) { screen[cursor++]='?'; str++; }
		else if (*str) screen[cursor++]=*str++;
		else screen[cursor++]=' ';
	}
	cursor+=2;
}

void select_line(int line)
{
	cursor=line*40;
	screen[cursor]=select_paper_color;
	screen[cursor+1]=select_ink_color;
}

void unselect_line(int line)
{
	cursor=line*40;
	screen[cursor]=paper_color;
	screen[cursor+1]=ink_color;
}

void home(void)
{
	cursor=0;
}
/***************************************************************************/
static FILE *dir_file;
static int last_entry;

static void print_screen_hardware(void)
{
	int i,drive;

	clear_screen();
	printf("Entré");
	for(i=21;i<=26;i++) screen[40*i]=0x12;
	set_cursor(0);
/*  0 */{
		size_t n;
		size_t padding;
		const char *left = "Caloric PROUT";
		n = strlen (left) + strlen (VERSION);
		if (n > 40)
			padding = 0;
		else
			padding = (40 - n) / 2;
		while (padding-- > 0)
			print_char(' ');
		print(left);
		print(VERSION);
		print_line("");
	}
/*  1 */print_line("");
/*  2 */print_char('\012');print_line(messages[1]);
/*  3 */print_char('\012');print_line(messages[1]);
/*  4 */print_line("      01234567        04152637");

}


static void open_list(void)
{
	char buf[256];
	dir_file=fopen(output_name,"r");
	if (dir_file==NULL) {
		exit(1);
	}
	init_list();
	last_entry=0;
	while(read_dir_entry(buf)) {
		last_entry++;
	}
	last_entry--;
	init_list();
}

static void init_list(void)
{
	char buf[256];
	rewind(dir_file);
	read_dir_entry(buf);
}

static void close_list(void)
{
	fclose(dir_file);
}

static int read_dir_entry(char *buf)
{
	if (fgets(buf,256,dir_file)) {
        strcpy(buf+10, "lulz");
		//strcpy(buf+10,buf+32); strcpy(buf+20,buf+33);
		return 1;
	} else buf[0]=0;
	return 0;
}

void get_entry_name(int file_choice,char *file_name)
{
	int i;
	char ext[4];
	ext[0]=0;
	init_list();
	for(i=0;i<=file_choice;i++)
		read_dir_entry(file_name);
	sscanf(file_name+20,"%s",file_name);

}

/***************************************************************************/
#define UP 1
#define DN 2
#define LFT 3
#define RGH 4
#define RET 5
#define ESC 6
#define PGUP 7
#define PGDN 8
#define SPACE 9
#define DEL 10

extern void display_frame();

int test_key(void)
{
	int ctrl,key=0;
	if (exit_menu) longjmp(context,1);	/* exit_menu positionne par l'appui sur F1 */
	ctrl=Kbd_Matrix[2] & 0x10;
	if (Kbd_Matrix[7] & 0x20) key=RET;
	if (Kbd_Matrix[1] & 0x20) key=ESC;
	if (Kbd_Matrix[4] & 0x20) key=LFT;
	if (Kbd_Matrix[4] & 0x80) key=RGH;
	if (Kbd_Matrix[4] & 0x08) key=UP;
	if (Kbd_Matrix[4] & 0x40) key=DN;
	if (Kbd_Matrix[4] & 0x01) key=SPACE;
	if (Kbd_Matrix[5] & 0x20) key=DEL;
	if (key==UP && ctrl) return PGUP;
	if (key==DN && ctrl) return PGDN;
	return key;
}

void delay(void)
{
	if (env_screen) {
		print_screen();
		select_line(select_choice);
	}
	if (hard_screen)
        {
            print_screen_hardware();
            select_line(select_choice);
        }

	display_frame();
	Tick=0;
}

int get_key(void)
{
	static int last_key=0;
	static int repeat=0;
	int key,i;
	key=test_key();
	if (key==last_key && key!=0) {
		if (repeat==0)
			for (i=0;i<10;i++) {
				delay();
				key=test_key();
				if (key!=last_key) break;
			}
		else {
			for (i=0;i<2;i++) delay();     /* 1/25 s */
			key=test_key();
		}
		if (key==last_key) repeat++;
		else repeat=0;
	} else repeat=0;
	last_key=key;
	return key;
}

int get_command(void)
{
	int key=0;
	while (key==0) {
		key=get_key();
		if (key==0) delay();
	}
	return key;
}

void wait_esc_depressed(void)
{
	while(get_key()==ESC);
}

/***************************************************************************/
void print_dir(int from_line)
{
	int i;
	char buf[256];
	init_list();
	clear_screen();
	for(i=0;i<from_line;i++) read_dir_entry(buf);
	for(;i<from_line+28;i++) {
		read_dir_entry(buf);
		if (i>last_entry) buf[0]=0;
		print_line(buf);
	}
}

int manage_dir_list(void)
{
	int window_first_line=0;
	int select_entry=0;
	int command;
	for(;;) {
		print_dir(window_first_line);
		select_line(select_entry-window_first_line);
		command=get_command();
		switch(command) {
			case UP:
				if (window_first_line==select_entry) {
					if (window_first_line) {
						window_first_line--;
						select_entry--;
					}
				} else select_entry--;
				break;
			case PGUP:
				if (window_first_line>26) {
					window_first_line-=26;
					select_entry-=26;
				} else {
					select_entry-=window_first_line;
					window_first_line=0;
				}
				break;
			case DN:
				if (select_entry<last_entry) {
					if (window_first_line+27==select_entry) {
						window_first_line++;
						select_entry++;
					} else select_entry++;
				}
				break;
			case PGDN:
				if (window_first_line+27+26<last_entry) {
					window_first_line+=26;
					select_entry+=26;
				} else {
					select_entry+=last_entry-27-window_first_line;
					window_first_line=last_entry-27;
				}
				break;
			case RET:
				return select_entry;
			case ESC:
				return -1;
		}
	}
}

char *file_select(char file_name[])
{
	int file_choice;
#ifdef USE_READDIR
	DIR *dir;
	char path[256];
#endif

	for(;;) {
#ifdef USE_READDIR
		dir = opendir (".");
		if (dir == NULL)
		{
		  if (getcwd (path, sizeof path) == NULL)
		    strcpy (path, ".");  /* Le moindre effort vaincra */
		  err ("%s: %s", path, strerror (errno));
		}
		else
		{
		  struct dirent dirent;

		  while ((dirent = readdir (dir)) != NULL)
		  {
		    ;
		  }
		}
		closedir (dir);
#else
		if (freopen (output_name, "w", stdout) == NULL)
		  err ("%s: %s", output_name, strerror (errno));
		system ("ls -al");
#endif
		open_list();
		env_screen=0;
		file_choice=manage_dir_list();
		env_screen=1;
		if (file_choice==-1) { close_list(); return NULL; }
		get_entry_name(file_choice,file_name);
		close_list();
		if (chdir(file_name)) return file_name;
	}
}

static char screen_copy[0xC000-0xB500];
static int hires_save;

void save_screen(void)
{
	memcpy(screen_copy,Oric_Mem+0xB500,0xC000-0xB500);
	memcpy(Oric_Mem+0xB500,charset,96*8);
	memcpy(Oric_Mem+0xB900,charset2,80*8);
	hires_save=hires;
	hires=0;

}

void restore_screen(void)
{
	memcpy(Oric_Mem+0xB500,screen_copy,0xC000-0xB500);
	hires=hires_save;

}

void config_screen(void)
{
	char filename[256];
	int command,drive;

	save_screen();
	env_screen=1;
	exit_menu=0;
	if (setjmp(context)) {
		restore_screen();
		env_screen=0;
		if (disk) reinvoke_fdc_command();
		return;
	}
	for(;;) {
		command=menu();
		switch(select_choice) {
			case 7:
			case 8:
			case 9:
			case 10:
				drive=select_choice-7;
				if (!drives[drive]) break;
				if (command==DEL) Close_Disk(drive);
				if (command==SPACE) Create_Disk(drive);
				if (command==RET && file_select(filename))
					Open_Disk(filename,drive);
				break;
			case 12:
				HardwareTape^=1;
				if (HardwareTape) Unpatch_ROM();
				else Patch_ROM();
				break;
			case 13:
				if (command==DEL) Close_Tape();
				if (command==SPACE) Create_Tape();
				if (command==RET && file_select(filename))
					Open_Tape(filename);
				break;
			case 14:
				if (HardwareTape) record^=1;
				break;
			case 19:
				break;
			case 20:
				if (telestrat) {
					if (joystick) {
						joystick=0;
						joystickport=1;
					} else if (joystickport) {
						joystickport=0;
						enable_keypad();
					} else {
						disable_keypad();
						joystick=1;
					}
				} else {
					if (joystick) enable_keypad();
					else disable_keypad();
					joystick^=1;
				}
				break;

		}
	}
}




static void print_screen(void)
{
	int i,drive;

	clear_screen();
	for(i=21;i<=26;i++) screen[40*i]=0x12;
	set_cursor(0);
/*  0 */{
		size_t n;
		size_t padding;
		const char *left = "Caloric ";
		n = strlen (left) + strlen (VERSION);
		if (n > 40)
			padding = 0;
		else
			padding = (40 - n) / 2;
		while (padding-- > 0)
			print_char(' ');
		print(left);
		print(VERSION);
		print_line("");
	}
	// atmos
/*  1 */print("Machine :");print_char('\001'); print_machine();
        //print_char('\001');
        print("Zoom :");print_char('\001');  print_zoom();
        print_line("");
        //print_line("Telestrat");
/*  2 *///print_char('\012');print_line(messages[1]);
/*  3 *///print_char('\012');print_line(messages[1]);
/*  4 */print_line("      01234567        04152637");
/*  5 */ print_line("      \x10\x11\x12\x13\x14\x15\x16\x17\x16       \x10\x14\x11\x15\x12\x16\x13\x17\x16");
/*  6 */print_line("");
/*  7 */if (disk && drives[0]) {
		if (disk_name[0][0]==0) print("    ");
		else if (write_only[0]) print("\011\040\041\010");
		else print("\011\040\040\010");
	        print(messages[2]);print_char('\001');print_line(disk_name[0]);
	} else print_line("");
/*  8 */if (disk && drives[1]) {
		if (disk_name[1][0]==0) print("    ");
		else if (write_only[1]) print("\011\040\041\010");
		else print("\011\040\040\010");
	        print(messages[3]);print_char('\001');print_line(disk_name[1]);
	} else print_line("");
/*  9 */if (disk && drives[2]) {
		if (disk_name[2][0]==0) print("    ");
		else if (write_only[2]) print("\011\040\041\010");
		else print("\011\040\040\010");
	        print(messages[4]);print_char('\001');print_line(disk_name[2]);
	} else print_line("");
/* 10 */if (disk && drives[3]) {
		if (disk_name[3][0]==0) print("    ");
		else if (write_only[3]) print("\011\040\041\010");
		else print("\011\040\040\010");
	        print(messages[5]);print_char('\001');print_line(disk_name[3]);
	} else print_line("");
/* 11 */print_line("");
/* 12 */print(messages[6]);print_char('\001');print_line(HardwareTape?messages[7]:messages[8]);
/* 13 */if (HardwareTape) {
		if (tape_name[0]==0) print("    ");
		else if (protected_tape) {
			print("\011\042\041\010");
		} else {
			print("\011\043\044\010");
		}
                print(messages[9]);print_char('\001');print_line(tape_name);
/* 14 */        print(messages[10]);
		print_char(0);
		print("\011\046\047\001");
		if (record) print_char('\053');
		else print_char('\054');
		print_char(0);
		print("\052\051\011\050\051\010");
		print(messages[14]); print_char('\001'); print_tape_pos();
	} else { print_line(""); print_line(""); }
/* 15 */print_line("");
/* 16 */print(messages[15]);print_char('\001');print_clockspeed();
/* 17 */print_line("");
/* 18 */print(messages[16]);print_char('\001');print_line(sound?messages[7]:messages[8]);
/* 19 */print_line("");
/* 20 */print(messages[20]);print_char('\001');print_line(joystickport?messages[21]:joystick?messages[22]:messages[23]);
/* 21 */print_line("\004F1      F2      F3      F4      F5");
/* 22 *///print_line("Return Hardware Keyboard Double Initial");// messages[24]
        print_line(messages[24]);
/* 23 */print_line(messages[25]);
/* 24 */print_line("\004F6      F7      F8      F9      F10");
/* 25 */print_line(messages[26]);
/* 26 */print_line(messages[27]);
/* 27 */cursor-=2;
	switch(select_choice) {
        case 1:

		case 7:
		case 8:
		case 9:
		case 10:
			drive=select_choice-7;
			if (drives[drive]) {
				if (disk_name[drive][0])
					print_line(messages[28]);
				else
					print_line(messages[29]);
			} else print_line(messages[30]);
			break;
		case 12:
			print_line(messages[31]);
			break;
		case 13:
			if (HardwareTape) {
				if (tape_name[0])
					print_line(messages[28]);
				else
					print_line(messages[32]);
			} else print_line(messages[30]);
			break;
		case 14:
			if (HardwareTape)
				print_line(messages[33]);
			else print_line(messages[30]);
			break;
		case 16:
			print_line(messages[34]);
			break;
		case 18:
		case 20:
			print_line(messages[31]);
			break;
		default:
			print_line(messages[30]);
			break;
	}
	select_line(select_choice);
}

static int menu(void)
{
    int command;

    for(;;) {
	print_screen();
	command=get_command();
	switch(command) {
		case UP:
			//if ((disk && select_choice>1) || select_choice>12)
            if ((select_choice>2) || select_choice>12)
				select_choice--;
			break;
		case DN:
			if (select_choice<20) select_choice++;
			break;
		case LFT:
            if (select_choice==1)
                {
                if (atmos==1 && telestrat==0)
                    {
                    atmos=0;
                    telestrat=0;
                    disk=0;
                    acia=0;
                    jasmin=0;
                    //machine_changed=1; // 0 pour oric-1, 1 pour atmos, 2 pour télestrat
                    }
                else
                    if (atmos==0 && telestrat==1)
                        {
                        atmos=1;
                        telestrat=0;
                        //machine_changed=1;
                        //machine_changed=2;
                        }
                }
             if (select_choice==2)
                if (zoom_changed!=1)
                    zoom_changed=zoom_changed-1;

			if (select_choice==16)
				if (cycles>2000) cycles-=2000;
			if (select_choice==13 && HardwareTape) protect_tape();
			if (select_choice==14 && HardwareTape)
				if (tape_handle) {
					int pos=ftell(tape_handle);
					if (pos>4800/8) fseek(tape_handle,pos-4800/8,SEEK_SET);
					else rewind(tape_handle);
				}
			break;
		case RGH:
            if (select_choice==1)
                {
                if (atmos==1 && telestrat==0)
                    {
                    atmos=0;
                    telestrat=1;
                    disk=1;
                    jasmin=0; acia=1;
                    }
                else
                    if (atmos==0 && telestrat==0)
                        {
                        atmos=1;
                        telestrat=0;
                        }
                }
        if (select_choice==2)
                if (zoom_changed!=3)
                    zoom_changed=zoom_changed+1;

			if (select_choice==16)
				if (cycles<2000000-2000) cycles+=2000;
			if (select_choice==13 && HardwareTape) unprotect_tape();
			if (select_choice==14 && HardwareTape)
				if (tape_handle) {
					int pos=ftell(tape_handle);
					fseek(tape_handle,0,SEEK_END);
					if (pos+4800/8<ftell(tape_handle))
						fseek(tape_handle,pos+4800/8,SEEK_SET);
				}
			break;
		case RET:
		case SPACE:
		case DEL:
		case ESC:
			return command;
	}
    }
}

static void print_clockspeed(void)
{
	char buf[20];
	double mhz = cycles / 20000.0;

	sprintf (buf, "%.6g MHz", mhz);
	print_line(buf);
}

static void print_machine(void)
{
	char buf[20];
	if (atmos==1)
        sprintf (buf,"%s","Atmos");
    else
        if (telestrat==1)
            sprintf (buf,"%s","Telestrat");
                else
                    sprintf (buf,"%s","Oric-1");
	print_line(buf);
}


static void print_zoom(void)
{
	char buf[20];
    sprintf (buf,"x%d",zoom_changed);
	print_line(buf);
}


static void print_tape_pos(void)
{
	int tens_minutes,minutes,tens_seconds,seconds=0;
	if (tape_handle) seconds=8*ftell(tape_handle)/4800;
	minutes=seconds/60; seconds=seconds%60;
	tens_minutes=minutes/10; minutes=minutes%10;
	tens_seconds=seconds/10; seconds=seconds%10;
	print_char(tens_minutes+'0');print_char(minutes+'0');
	print_char('\'');
	print_char(tens_seconds+'0');print_char(seconds+'0');
	print_line("\"");
}

