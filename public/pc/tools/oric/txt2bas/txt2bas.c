#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char *keywords[]= {
"END","EDIT","STORE","RECALL","TRON","TROFF","POP","PLOT",
"PULL","LORES","DOKE","REPEAT","UNTIL","FOR","LLIST","LPRINT","NEXT","DATA",
"INPUT","DIM","CLS","READ","LET","GOTO","RUN","IF","RESTORE","GOSUB","RETURN",
"REM","HIMEM","GRAB","RELEASE","TEXT","HIRES","SHOOT","EXPLODE","ZAP","PING",
"SOUND","MUSIC","PLAY","CURSET","CURMOV","DRAW","CIRCLE","PATTERN","FILL",
"CHAR","PAPER","INK","STOP","ON","WAIT","CLOAD","CSAVE","DEF","POKE","PRINT",
"CONT","LIST","CLEAR","GET","CALL","!","NEW","TAB(","TO","FN","SPC(","@",
"AUTO","ELSE","THEN","NOT","STEP","+","-","*","/","^","AND","OR",">","=","<",
"SGN","INT","ABS","USR","FRE","POS","HEX$","&","SQR","RND","LN????","EXP","COS",
"SIN","TAN","ATN","PEEK","DEEK","LOG","LEN","STR$","VAL","ASC","CHR$","PI",
"TRUE","FALSE","KEY$","SCRN","POINT","LEFT$","RIGHT$","MID$"
};

unsigned char buf[48*1024];
unsigned char head[14]={ 0x16,0x16,0x16,0x24,0,0,0,0,0,0,5,1,0,0 };

int search_keyword(char *str);

int main(int argc, char **argv)
{
	unsigned int i, number, end, lastptr, adr;
	int j,ptr,keyw,string,rem,data;
	unsigned char ligne[256];
	FILE *in,*out;
	if (argc!=3) {
		perror("Usage : txt2bas txtfile <Oric-BASIC-file>\n");
		exit(1);
	}
	in=fopen(argv[1],"r");
	if (in==NULL) { perror("Can't open input file\n"); exit(1); }
	out=fopen(argv[2],"wb");
	if (out==NULL) { perror("Can't open file for writing\n"); exit(1); }

	i=0;
	while(1) {
		buf[i++]=0; buf[i++]=0;
		if(fscanf(in,"%u",&number)==0) break;
		buf[i++]=number&0xFF; buf[i++]=number>>8;
		j=0; while((ligne[j]=getc(in))!='\n') j++; ligne[j]=0;
		ptr=0; rem=0; string=0; data=0;
		if (ligne[ptr]==' ') ptr++;
		while(ligne[ptr]) {
		    if (rem) {
			buf[i++]=ligne[ptr++];
		    } else if (string) {
			if (ligne[ptr]=='"') string=0;
			buf[i++]=ligne[ptr++];
		    } else if (data) {
			if (ligne[ptr]==':') data=0;
			buf[i++]=ligne[ptr++];
		    } else {
			keyw=search_keyword((char*)(ligne+ptr));
			if (keyw==29 || ligne[ptr]=='\'') rem=1;
			if (keyw==17) data=1;
			if (ligne[ptr]=='"') string=1;
			if (keyw>=0) {
				buf[i++]=keyw+128; ptr+=strlen(keywords[keyw]);
			} else {
				buf[i++]=ligne[ptr++];
			}
		    }
		}
		buf[i++]=0;
	}
	buf[i++]=0;
	end=0x501+i; head[8]=end>>8; head[9]=end&0xFF;
	for(j=4,lastptr=0;j<i;j++)
		if (buf[j]==0) {
			adr=0x500+j+1;
			buf[lastptr]=adr&0xFF; buf[lastptr+1]=adr>>8;
			lastptr=j+1;
			j+=4;
		}
	fwrite(head,1,14,out);
	fwrite(buf,1,i,out); fclose(out);
    return 0;
}

int search_keyword(char *str)
{
	int i;
	for (i=0;i<sizeof(keywords)/sizeof(char *);i++)
		if (strncmp(keywords[i],str,strlen(keywords[i]))==0)
			return i;
	return -1;
}
