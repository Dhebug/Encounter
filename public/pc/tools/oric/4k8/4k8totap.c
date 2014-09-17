#include <stdio.h>
#include <stdlib.h>

int sync_ok=0;
int offset;
FILE *in, *out;

void synchronize(void);
int getbyte(void);

int main(int argc,char **argv)
{
        printf(".4k8 -> .tap 1.0\n");
        if (argc!=3) { printf("Usage: %s file.4k8 file.tap\n",argv[0]); exit(1);}
	in=fopen(argv[1],"rb"); out=fopen(argv[2],"wb");
	if (in==NULL || out==NULL) { printf("Unable to open file\n"); exit(1);}

	synchronize();
	sync_ok=1;
        while (!feof(in)) putc(getbyte(),out);
        fclose(in); fclose(out);
	exit(0);
}


int getsample()
{
        static int shifter, shiftcount=0;
        if (shiftcount==0) {
                shiftcount=8;
                if (feof(in)) shifter=0x55;
                else shifter=getc(in);
        }
        shiftcount--;
        shifter<<=1;
        return (shifter>>8) & 1;
}

int getbit()
{
        int length=0;
        do length++; while (getsample()==1);
        do length++; while (getsample()==0);
        return length<3 ? 1 : 0;
}

int getbyte(void)
{
	int decaleur=0,byte=0,i,bit,sum=0;
	getbit();
	while(getbit()==1);
	for(i=0;i<8;i++) decaleur=(decaleur<<1)|getbit();
	for(i=0;i<8;i++) {
		bit=decaleur&1;
		decaleur=decaleur>>1;
		byte=(byte<<1)|bit;
		sum+=bit;
	}
	if ((sum&1)==getbit() && sync_ok) printf("parity error at offset $%x\n",offset);
	return byte;
}

void synchronize(void)
{
	int decaleur=0,val;
	printf("Searching synchro...\n");
	while(1) {
		while((decaleur&0xff) != 0x68)
                        decaleur=(decaleur<<1)|getbit();
		if (getbyte()!=0x16) continue;
		if (getbyte()!=0x16) continue;
		if (getbyte()!=0x16) continue;
		do {
			val=getbyte();
		} while (val==0x16);
		if (val==0x24) break;
	}
        printf("Synchro found, byte coding...\n");
	putc(0x16,out); putc(0x16,out); putc(0x16,out); putc(0x24,out);
}

