/* Watcom compiler */
#include <i86.h>
#include <bios.h>
#include <stdio.h>
#define TRACK_SIZE 6400
char *version="Writedsk 2.1";
unsigned char track[TRACK_SIZE];
char pad[256];
char chrntab[40][4];
int ptr;
int drive;
int adr;
char __far *biosparams;
struct diskinfo_t di;

search_id()
{
	for(;ptr<TRACK_SIZE;ptr++)
		if ( track[ptr]==0 
		  && track[ptr+1]==0
		  && track[ptr+2]==0
		  && track[ptr+3]==0
		  && track[ptr+4]==0xA1
		  && track[ptr+5]==0xA1
		  && track[ptr+6]==0xA1
		  && track[ptr+7]==0xFE) {
			ptr+=8;
			return;
		}
}

find_data()
{
	for(;ptr<TRACK_SIZE;ptr++)
		if ( track[ptr]==0xA1
		  && track[ptr+1]==0xA1
		  && track[ptr+2]==0xA1
		  && track[ptr+3]==0xFB) {
			ptr+=4;
			return;
		}
}

int write_sector(char *buf,char chrn[4],int track,int head)
{
	struct diskinfo_t di;
	int try, status;

	biosparams[3]= chrn[3];  /* sector size */
	for(try=0;try<3;try++) {
		di.drive=drive;
		di.head=head;
		di.track=track;
		di.sector=chrn[2];
		di.nsectors=1;
		di.buffer=(char __far *)buf;
		status = _bios_disk(_DISK_WRITE,&di) >> 8 ;
		if (status==0) break;
		if (status==3) quit("\nWrite protect error\n");
	}
	return status;
}

int format_track(char __far *chrnlist,int cyl,int head,int sectors)
{
	int try,status;

	biosparams[7]=40;  /* gap */
	biosparams[4]=sectors;
	for (try=0;try<3;try++) {
		di.drive=drive;
		di.head=head;
		di.track=cyl;
		di.sector=1;
		di.nsectors=sectors;
		di.buffer=(char __far *)chrnlist;
		status = _bios_disk(_DISK_FORMAT,&di) >> 8;
		if (status) _bios_disk(_DISK_RESET,&di);
		else return 0;
	}
	return status;
}

void write_track(int cyl,int head)
{
	int sectors=0, errors, i, try;
	ptr=0;
	search_id();
	while (ptr!=TRACK_SIZE) {
		chrntab[sectors][0]=track[ptr];
		chrntab[sectors][1]=track[ptr+1];
		chrntab[sectors][2]=track[ptr+2];
		chrntab[sectors][3]=track[ptr+3];
		find_data();
		ptr+= 128 << chrntab[sectors][3];
		sectors++;
		search_id();
	}
	for(try=0;try<3;try++) {
		ptr=0; errors=0;
		for(i=0;i<sectors;i++) {
			search_id(); 
			find_data();
			if (write_sector(track+ptr,chrntab[i],cyl,head)!=0) {
				errors++;
				break;
			}
		}
		if (errors==0) { putchar('.'); fflush(stdout); return; }
		else format_track((char *)chrntab,cyl,head,sectors);
	}
	quit("\nWrite error\n");
}


init_drive_params()
{
	di.drive=drive;
	_bios_disk(8,&di); /* bizarre: l'adresse retournee n'est pas 00522, elle pointe sur
		une table de parametres mais qui n'a pas l'air de servir */
	
	di.track=79; di.sector=9; di.drive=drive;
	_bios_disk(0x18,&di);

	biosparams= *(char __far * __far *)MK_FP(0,4*0x1E);
	biosparams[3]=1;
	_bios_disk(_DISK_RESET,&di);
}

main(int argc,char *argv[])
{
	FILE *fd;
	int t,h,tracks,sides,geometry;
	char diskid[8], *signature="MFM_DISK";

	printf("%s\n",version);
	if (argc!=3) {
		printf("Usage: writedsk <disk-image> <floppy-drive:>\n");
		exit(1);
	}
	fd=fopen(argv[1],"rb");
	if (fd==NULL) {
		printf("Unable to open %s for reading\n",argv[1]);
		exit(1);
	}
	fread(diskid,8,1,fd);
	if (strncmp(diskid,signature,8)!=0) {
		printf("%s is not a disk image\n",argv[1]);
		exit(1);
	}
	if (strcmp(argv[2],"a:")==0 || strcmp(argv[2],"A:")==0)
		drive=0;
	else if (strcmp(argv[2],"b:")==0 || strcmp(argv[2],"B:")==0)
		drive=1;
	else {
		printf("Invalid floppy drive specification (%s)\n",argv[2]);
		exit(1);
	}
	fread(&sides,1,2,fd); fread(pad,1,2,fd); 
	fread(&tracks,1,2,fd); fread(pad,1,2,fd);
	fread(&geometry,1,2,fd); fread(pad,1,2,fd);
	fread(pad,256-20,1,fd);
	
	printf("Warning: this operation will erase all data on floppy !\n");
	printf("Press any key to continue or Ctrl-C to quit\n");
	getch();
	
	init_drive_params();
	for (h=0;h<sides;h++) {
		for (t=0;t<tracks;t++) {
			fread(&track,TRACK_SIZE,1,fd);
			write_track(t,h);
		}
		printf("\n");
	}
	quit("Write complete\n");
}

quit(char *msg)
{
	printf(msg);
	biosparams[3]=2;  /* restore normal sector size (512) */
	exit(0);
}
