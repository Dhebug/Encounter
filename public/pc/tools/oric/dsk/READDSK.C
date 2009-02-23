/* Watcom compiler */
#include <i86.h>
#include <bios.h>
#include <stdio.h>
char *version="Readdsk 2.0";
char diskid[8]="MFM_DISK";
char pad[256];
int drive;
int tracks=0,sectors=0,sides=2;
char __far *biosparams;
struct diskinfo_t di;
FILE *fd;

/***********************************************************************************/
/*  writing to the virtual disk                                                    */
/***********************************************************************************/

unsigned char trackbuf[6400];
int ptr_track;
int crc;

int crctab[256]={
	0x0000, 0x1021, 0x2042, 0x3063, 0x4084, 0x50A5, 0x60C6, 0x70E7,
	0x8108, 0x9129, 0xA14A, 0xB16B, 0xC18C, 0xD1AD, 0xE1CE, 0xF1EF,
	0x1231, 0x0210, 0x3273, 0x2252, 0x52B5, 0x4294, 0x72F7, 0x62D6,
	0x9339, 0x8318, 0xB37B, 0xA35A, 0xD3BD, 0xC39C, 0xF3FF, 0xE3DE,
	0x2462, 0x3443, 0x0420, 0x1401, 0x64E6, 0x74C7, 0x44A4, 0x5485,
	0xA56A, 0xB54B, 0x8528, 0x9509, 0xE5EE, 0xF5CF, 0xC5AC, 0xD58D,
	0x3653, 0x2672, 0x1611, 0x0630, 0x76D7, 0x66F6, 0x5695, 0x46B4,
	0xB75B, 0xA77A, 0x9719, 0x8738, 0xF7DF, 0xE7FE, 0xD79D, 0xC7BC,
	0x48C4, 0x58E5, 0x6886, 0x78A7, 0x0840, 0x1861, 0x2802, 0x3823,
	0xC9CC, 0xD9ED, 0xE98E, 0xF9AF, 0x8948, 0x9969, 0xA90A, 0xB92B,
	0x5AF5, 0x4AD4, 0x7AB7, 0x6A96, 0x1A71, 0x0A50, 0x3A33, 0x2A12,
	0xDBFD, 0xCBDC, 0xFBBF, 0xEB9E, 0x9B79, 0x8B58, 0xBB3B, 0xAB1A,
	0x6CA6, 0x7C87, 0x4CE4, 0x5CC5, 0x2C22, 0x3C03, 0x0C60, 0x1C41,
	0xEDAE, 0xFD8F, 0xCDEC, 0xDDCD, 0xAD2A, 0xBD0B, 0x8D68, 0x9D49,
	0x7E97, 0x6EB6, 0x5ED5, 0x4EF4, 0x3E13, 0x2E32, 0x1E51, 0x0E70,
	0xFF9F, 0xEFBE, 0xDFDD, 0xCFFC, 0xBF1B, 0xAF3A, 0x9F59, 0x8F78, 
	0x9188, 0x81A9, 0xB1CA, 0xA1EB, 0xD10C, 0xC12D, 0xF14E, 0xE16F,
	0x1080, 0x00A1, 0x30C2, 0x20E3, 0x5004, 0x4025, 0x7046, 0x6067,
	0x83B9, 0x9398, 0xA3FB, 0xB3DA, 0xC33D, 0xD31C, 0xE37F, 0xF35E,
	0x02B1, 0x1290, 0x22F3, 0x32D2, 0x4235, 0x5214, 0x6277, 0x7256,
	0xB5EA, 0xA5CB, 0x95A8, 0x8589, 0xF56E, 0xE54F, 0xD52C, 0xC50D,
	0x34E2, 0x24C3, 0x14A0, 0x0481, 0x7466, 0x6447, 0x5424, 0x4405,
	0xA7DB, 0xB7FA, 0x8799, 0x97B8, 0xE75F, 0xF77E, 0xC71D, 0xD73C,
	0x26D3, 0x36F2, 0x0691, 0x16B0, 0x6657, 0x7676, 0x4615, 0x5634,
	0xD94C, 0xC96D, 0xF90E, 0xE92F, 0x99C8, 0x89E9, 0xB98A, 0xA9AB,
	0x5844, 0x4865, 0x7806, 0x6827, 0x18C0, 0x08E1, 0x3882, 0x28A3,
	0xCB7D, 0xDB5C, 0xEB3F, 0xFB1E, 0x8BF9, 0x9BD8, 0xABBB, 0xBB9A,
	0x4A75, 0x5A54, 0x6A37, 0x7A16, 0x0AF1, 0x1AD0, 0x2AB3, 0x3A92,
	0xFD2E, 0xED0F, 0xDD6C, 0xCD4D, 0xBDAA, 0xAD8B, 0x9DE8, 0x8DC9,
	0x7C26, 0x6C07, 0x5C64, 0x4C45, 0x3CA2, 0x2C83, 0x1CE0, 0x0CC1,
	0xEF1F, 0xFF3E, 0xCF5D, 0xDF7C, 0xAF9B, 0xBFBA, 0x8FD9, 0x9FF8,
	0x6E17, 0x7E36, 0x4E55, 0x5E74, 0x2E93, 0x3EB2, 0x0ED1, 0x1EF0
};


reset_crc()
{
	crc=0xFFFF;
}

int get_crc()
{
	return crc;
}

store_byte(int val)
{
	trackbuf[ptr_track++]=val;
	crc=crctab[(crc>>8)^val]^((crc&0xFF)<<8);
}

store_address_mark(int mark)
{
	reset_crc();
	store_byte(0xA1);
	store_byte(0xA1);
	store_byte(0xA1);
	store_byte(mark);
}

store_id(int cyl,int head,int record,int n)
{
	store_address_mark(0xFE);
	store_byte(cyl);
	store_byte(head);
	store_byte(record);
	store_byte(n);
}

store_data(char buf[],int n)
{
	int i, nbytes=128<<n;
	store_address_mark(0xFB);
	for (i=0;i<nbytes;i++) store_byte(buf[i]);
}

store_crc()
{
	int crc=get_crc();
	store_byte(crc>>8);
	store_byte(crc&0xFF);
}

store_bad_crc()
{
	store_byte(0);
	store_byte(0);
}

store_gap(int size,int val)
{
	int i;
	for (i=0;i<size;i++) store_byte(val);
}

store_sector(char buf[],int cyl,int head,int sect,int sectsize)
{
	store_gap(12,0);
	store_id(cyl,head,sect,sectsize);
	store_crc();
	store_gap(22,0x4E);
	store_gap(12,0)
	store_data(buf,sectsize);
	store_crc();
	store_gap(40,0x4E);
}

store_sector_bad_crc(char buf[],int cyl,int head,int sect,int sectsize)
{
	store_gap(12,0);
	store_id(cyl,head,sect,sectsize);
	store_crc();
	store_gap(22,0x4E);
	store_gap(12,0)
	store_data(buf,sectsize);
	store_bad_crc();
	store_gap(40,0x4E);
}

init_track()
{
	int i;
	for (i=0;i<6400;i++) trackbuf[i]=0x4E;
	ptr_track=0;
}

flush_track(FILE *fd)
{
	int i;
	fwrite(trackbuf,6400,1,fd);
}

/*********************************************************************************/
/*      Reading floppy at bios level                                             */
/*********************************************************************************/
#define OK 0
#define BADCRC 0x10
unsigned char buf[1024];

int read_sector(int cyl,int head,int sect)
{
	struct diskinfo_t di;
	int try, status;

	for(try=0;try<3;try++) {
		di.drive=drive;
		di.head=head;
		di.track=cyl;
		di.sector=sect;
		di.nsectors=1;
		di.buffer=(char __far *)buf;
		status = _bios_disk(_DISK_READ,&di) >> 8 ;
		if (status==OK) break;
	}
	return status;
}

void read_track(int cyl,int head,int sectsize)
{
	int sectmax;
	if (sectors) sectmax=sectors;
	else switch (sectsize) {
		case 0: sectmax=35; break; /* I don't know how many 128-bytes sectors fit in */
		case 1: sectmax=18; break; /* 256-bytes sectors */
		case 2: sectmax=10; break; /* 512-bytes sectors */
		case 3: sectmax=5; break; /* 1024-bytes sectors */
	}
	init_track();
	for (i=1;i<=sectmax;i++) {
		status=read_sector(cyl,head,i);
		if (status==OK) store_sector(buf,cyl,head,i,sectsize);
		else if (status==BADCRC) store_sector_badcrc(buf,cyl,head,i,sectsize);
		else break;
	}
}

int test_track(int track,int side,int &sectsize)
{
	int n= (*sectsize);
	int status;

	do {
		status=read_sector(track,side,1,*sectsize);
		if (status==OK || status==BADCRC) return status;
		(*sectsize) = ((*sectsize)+1)&3);
		biosparams[3]=(*sectsize);
		di.drive=drive;
		_bios_disk(_DISK_RESET,&di);
	} while (*sectsize!=n);
	return status;
}
		

int transfer_side(int side, FILE *fd)
{
	int ntrack;
	sectsize=biosparams[3]=1;		/* most often, 256-bytes sectors will be read */
	di.drive=drive;
	_bios_disk(_DISK_RESET,&di);

	if (tracks) ntrack=tracks;
	for (i=0;i<ntrack;i++) {
		status=test_track(i,side,&sectsize);
		if (status!=OK && status!=BADCRC) return i;
		printf("Reading side %d track %d\n",side,i);
		read_track(i,side,sectsize);
		flush_track(fd);
	}
	return ntrack;
}


quit(char *msg)
{
	printf(msg);
	biosparams[3]=2;  /* restore normal sector size (512) */
	exit(0);
}

usage()
{
	printf("Usage: readdsk [options] <floppy-drive:> <disk-image>\n");
	printf("Options:\n");
	printf("\t-1 (read one side only)\n");
	printf("\t-t:nn (specify number of tracks, e.g -t:42)\n");
	printf("\t-s:nn (specify number of sectors per track, e.g -s:17)\n");
	printf("Nota: specifying the sectors per track number prevents the program from searching\n");
	printf("inexistent sectors\n");
	exit(1);
}

int scan_arg(char *arg)
{
	if (arg[0]!=':' && arg[0]!='=') usage();
	return atoi(arg+1);
}

main(int argc,char *argv[])
{
	FILE *fd;
	int t,h,tracks,sides,geometry;
	char diskid[8], *signature="MFM_DISK";

	printf("%s\n",version);
	if (argc<3) usage();
	for (i=1; i<argc-2; i++) {
		if (argv[i][0]!='-' && argv[i][0]!='/') usage();
		switch (argv[i][1]) {
			case '1': sides=1; break;
			case 't': tracks=scan_arg(argv[i]+2); break;
			case 's': sectors=scan_arg(argv[i]+2); break;
			default: usage();
		}
	}
	if (strcmp(argv[i],"a:")==0 || strcmp(argv[i],"A:")==0)
		drive=0;
	else if (strcmp(argv[i],"b:")==0 || strcmp(argv[i],"B:")==0)
		drive=1;
	else {
		printf("Invalid floppy drive specification (%s)\n",argv[2]);
		exit(1);
	}
	fd=fopen(argv[argc-1],"wb");
	if (fd==NULL) {
                printf("Unable to open %s for writing\n",argv[argc-1]);
		exit(1);
	}
	fwrite(pad,256,1,fd);
	biosparams= *(char __far * __far *)MK_FP(0,4*0x1E);

	tracks=transfer_side(0,fd);
	if (sides>1) transfer_side(1,fd);

	rewind(fd);
	fwrite(diskid,8,1,fd);
	fwrite(&sides,1,2,fd); fwrite(pad,1,2,fd); 
	fwrite(&tracks,1,2,fd); fwrite(pad,1,2,fd);
	fwrite(&geometry,1,2,fd); fwrite(pad,1,2,fd);
	fclose(fd);	
}

