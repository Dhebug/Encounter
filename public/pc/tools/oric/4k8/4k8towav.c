#include <stdio.h>
#include <stdlib.h>

FILE *fd, *fd2;
struct {
	char sig[4];
	int riff_size;
	char datasig[4];
	char fmtsig[4];
	int fmtsize;
	short tag;
	short channels;
	int freq;
	int bytes_per_sec;
	short byte_per_sample;
	short bits_per_sample;
	char samplesig[4];
	int length;
} sample_riff= {"RIFF",0,"WAVE","fmt ",16,1,1,4800,4800,1,8,"data",0};

int main(int argc,char *argv[])
{
	int i,c,size;

	if (argc!=3) {
		printf("Usage: oric2wav <tape_image> <wav_file>\n");
		exit(1);
	}
	fd=fopen(argv[1],"rb");
	if (fd==NULL) {
		printf("Unable to open %s\n",argv[1]);
		exit(1);
	}
	fd2=fopen(argv[2],"wb");
	if (fd2==NULL) {
		printf("Unable to open %s\n",argv[2]);
		exit(1);
	}
	fseek(fd,0,SEEK_END); size=ftell(fd); fseek(fd,0,SEEK_SET);
	sample_riff.length=size*8;
	sample_riff.riff_size=sample_riff.length+36;
	fwrite(&sample_riff,1,sizeof(sample_riff),fd2);
	for(i=0;i<size;i++) {
		c=fgetc(fd);
                fputc(c&0x80?0xE0:0x20,fd2);
                fputc(c&0x40?0xE0:0x20,fd2);
                fputc(c&0x20?0xE0:0x20,fd2);
                fputc(c&0x10?0xE0:0x20,fd2);
                fputc(c&0x08?0xE0:0x20,fd2);
                fputc(c&0x04?0xE0:0x20,fd2);
                fputc(c&0x02?0xE0:0x20,fd2);
                fputc(c&0x01?0xE0:0x20,fd2);
	}
    return 0;
}

