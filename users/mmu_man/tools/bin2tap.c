/*
 * Copyright 2006 François Revol <revol@free.fr>
 */

#include <ctype.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/param.h>
#include <fcntl.h>
#include <unistd.h>

/* XXX: LITTLE_ENDIAN only! needs some swapping around */

#define TYPE_BASIC	0x00
#define TYPE_ASM	0x80

#define SPEED_SLOW	0
#define SPEED_FAST	1

#define FILENAMEMAX (16)
struct k7header {
	unsigned char syn[3];
#define SYN 0x16 /* sync */
	unsigned char sta[1];
#define STA 0x24 /* start mark */
	/* in tape order */
	unsigned char speed; // 0=fast
	unsigned char dummy2; // unknown
	unsigned char type; // 0=basic
	unsigned char autoflag;
	uint16_t end_addr;
	uint16_t start_addr;
	unsigned char dummy; // unknown
	char filename[FILENAMEMAX+1];
};

int usagedump(void)
{
	printf("tapdump <tapfile>\n");
	return 0;
}

int usage2bin(void)
{
	printf("tap2bin <tapfile>\n");
	return 0;
}

int usage(void)
{
	printf("Usage: bin2tap [-a] [-S] [-t asm|basic] [-c] [-s addr] [-n name] <binfile> [...] <tapfile>\n");
	printf("Options:\n");
	printf("-a	set auto flag\n");
	printf("-S	set slow speed (fast is default)\n");
	printf("-t <t>	set the type to <t> (basic or asm, default is asm)\n");
	printf("-c	C64 input format (binary, start address in first 2 bytes)\n");
	//printf("-o	out input format (hex dump)\n");
	printf("-s <a>	set start address to <a> (decimal or 0xHHHH)\n");
	printf("-n <n>	set name on tape to <n>\n");
	return 0;
}

int readheader(int fd, struct k7header *h)
{
	int err, i;
	uint16_t a;
	
	err = read(fd, h, 4+4+4+1);
	if (err < 0)
		return err;
	if (err < 4+4+4+1)
		return -1;
	if (h->syn[0] != SYN)
		return -1;
	if (h->syn[1] != SYN)
		return -1;
	if (h->syn[2] != SYN)
		return -1;
	if (h->sta[0] != STA)
		return -1;
	/* addresses are little endian but reverse order on tape... */
	a = (*(uint8_t *)&h->start_addr) << 8;
	a |= *((uint8_t *)&h->start_addr+1);
	h->start_addr = a;
	a = (*(uint8_t *)&h->end_addr) << 8;
	a |= *((uint8_t *)&h->end_addr+1);
	h->end_addr = a;
	for (i = 0; i < FILENAMEMAX; i++) {
		err = read(fd, &h->filename[i], 1);
		if (err < 0)
			return err;
		if (err < 1)
			return -1;
		if (!h->filename[i])
			break;
	}
	/*read(fd, &h->filename[i], 1);*/
	/*XXX:ENDIAN!*/
	return 0;
}

int writeheader(int fd, struct k7header *h)
{
	uint16_t a;
	char z = '\0';
	int err, i;
	a = h->start_addr;
	(*(uint8_t *)&h->start_addr) = a >> 8;
	*((uint8_t *)&h->start_addr+1) = a & 0xff;
	a = h->end_addr;
	(*(uint8_t *)&h->end_addr) = a >> 8;
	*((uint8_t *)&h->end_addr+1) = a & 0xff;
	err = write(fd, h, 4+4+4+1);
	h->filename[FILENAMEMAX] = '\0';
	write(fd, h->filename, MIN(strlen(h->filename), FILENAMEMAX)+1);
	/*write(fd, &z, 1);*/
	return 0;
}

int tapdump(char *file)
{
	int fd = open(file, O_RDONLY);
	struct k7header header;
	while (readheader(fd, &header) >= 0) {
		printf("syn: %02x %02x %02x, sta: %02x\n", 
			header.syn[0], header.syn[1], header.syn[2], header.sta[0]);
		printf("auto: %02x, type: %02x, speed: %02x\n", header.autoflag, header.type, header.speed);
		printf("start: $%04x, end: $%04x\n", header.start_addr, header.end_addr);
		printf("name: %s\n", header.filename);
		if (lseek(fd, header.end_addr - header.start_addr + 1, SEEK_CUR) < 0)
			return -1;
	}
	return 0;
}

int tap2bin(char *file)
{
	int fd = open(file, O_RDONLY);
	struct k7header header;
	char *buf;
	buf = (char *)malloc(64*1024);
	while (readheader(fd, &header) >= 0) {
		char fname[FILENAMEMAX+1+3+1];
		char *p;
		int outfd;
		memset(fname, 0, FILENAMEMAX+3+1);
		strncpy(fname, header.filename, FILENAMEMAX);
		p = strchr(fname, '.');
		if (p)
			*p = '\0';
		strcat(fname, ".bin");
		outfd = open(fname, O_WRONLY|O_CREAT, 0644);
		read(fd, buf, header.end_addr - header.start_addr + 1);
		write(outfd, buf, header.end_addr - header.start_addr + 1);
		close(outfd);
		printf("written %d bytes to %s\n", header.end_addr - header.start_addr + 1, fname);
		printf("syn: %02x %02x %02x, sta: %02x\n", 
			header.syn[0], header.syn[1], header.syn[2], header.sta[0]);
		printf("auto: %02x, type: %02x, speed: %02x\n", header.autoflag, header.type, header.speed);
		printf("start: $%04x, end: $%04x\n", header.start_addr, header.end_addr);
		printf("name: %s\n", header.filename);
	}
	return 0;
}

int bin2tap(char *in, int fout, int c64, int start, int autoflag, int type, int speed, char *name)
{
	struct k7header header;
	struct k7header *h = &header;
	struct stat st;
	char *buf;
	int fin;
	memset(h, 0, sizeof(header));
	h->syn[0] = SYN;
	h->syn[1] = SYN;
	h->syn[2] = SYN;
	h->syn[3] = STA;
	h->autoflag = autoflag?1:0xc7; /* hmm... */
	h->autoflag = autoflag?1:0; /* hmm... */
	h->type = type;
	h->speed = speed;
	h->start_addr = 0x0500;
	if (start >= 0)
		h->start_addr = (uint16_t)start;
	if (name) {
		int i;
		strncpy(header.filename, name, FILENAMEMAX);
		for (i = 0; i < FILENAMEMAX; i++)
			h->filename[i] = toupper(h->filename[i]);
	}
	fin = open(in, O_RDONLY);
	if (fin < 0)
		return fin;
	fstat(fin, &st);
	if (c64) {
		uint8_t v;
		read(fin, &v, 1);
		header.start_addr = v;
		read(fin, &v, 1);
		header.start_addr |= v << 8;
		st.st_size -= 2;
	}
	header.end_addr = header.start_addr + (uint16_t)st.st_size - 1;
	writeheader(fout, &header);
	buf = (char *)malloc((uint16_t)st.st_size);
	read(fin, buf, (uint16_t)st.st_size);
	write(fout, buf, (uint16_t)st.st_size);
	free(buf);
	close(fin);
	return 0;
}

int main(int argc, char **argv)
{
	int i;
	int c64 = 0;
	int fin, fout;
	char *name = NULL;
	int start = -1;
	int autoflag = 0;
	int speed = SPEED_FAST;
	int type = TYPE_ASM;
	
	if (strstr(argv[0], "tapdump")) {
		if (argc < 2)
			return usagedump();
		return tapdump(argv[1]);
	}
	if (strstr(argv[0], "tap2bin")) {
		if (argc < 2)
			return usage2bin();
		return tap2bin(argv[1]);
	}
	if (argc < 3)
		return usage();
	fout = open(argv[argc-1], O_WRONLY|O_CREAT, 0666);
	if (fout < 0) {
		printf("can't open output file '%s'\n", argv[argc-1]);
		return 1;
	}
	argc--;
	for (i = 1; i < argc; i++) {
		if (!strcmp(argv[i], "-c"))
			c64 = 1;
		else if (!strcmp(argv[i], "-s")) {
			i++;
			if (!strncmp(argv[i], "0x", 2)) {
				start = strtol(argv[i]+2, NULL, 16);
			} else
				start = atoi(argv[i]);
			c64 = 0;
		} else if (!strcmp(argv[i], "-t")) {
			i++;
			printf("type unsupported, binary assumed\n");
		} else if (!strcmp(argv[i], "-n")) {
			i++;
			name = argv[i];
		} else if (!strcmp(argv[i], "-a")) {
			autoflag = 1;
		} else if (!strcmp(argv[i], "-S")) {
			speed = SPEED_SLOW;
		} else if (!strncmp(argv[i], "-", 1)) {
			printf("unknown option %s\n", argv[i]);
		} else {
			bin2tap(argv[i], fout, c64, start, autoflag, type, speed, name);
			/* reset for next file */
			/*c64 = 0;*/
			start = -1;
			name = NULL;
			type = TYPE_ASM;
			speed = SPEED_FAST;
			autoflag = 0;
		}
	}
	return 0;
}
