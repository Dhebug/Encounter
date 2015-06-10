#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <arpa/inet.h>

static FILE *fi = 0;
static FILE *fo = 0;
static char *fin = 0;
static char *fon = 0;

static int quit = 0;

/* 14 + 2 extended data in non-interleaved mode */
#define REGS 16

#define INTERLEAVED 1

#define MIN_ALLOC 128
//#define FREQ 2000000
#define FREQ 1773400
//#define FREQ 1000000

static unsigned char getb(void)
{
    int c = fgetc(fi);
    if(-1==c)
        quit = 1;
    return (unsigned char)(0xFF & c);
}


static void header(void)
{
  
}

static void convert(void)
{
    unsigned char data;
    unsigned char *frames;
    int i, j;

    struct ymheader {
      char magic[4];
      char leonard[8];
      uint32_t nb_frames;
      uint32_t attributes;
      uint16_t nb_digidrum;
      uint32_t master_clock;
      uint16_t rate;
      uint32_t loop;
      uint16_t extra;
      // digidrum
      
  
    } __attribute__ ((__packed__)) header =
	{
	  "YM5!",
	  "LeOnArD!",
	  0,
#ifdef INTERLEAVED
	  htonl(1), /* interleaved */
#else
	  0, /* not not interleaved */
#endif
	  0,
	  htonl(FREQ),
	  htons(50),
	  0,
	  0
	};

    // values from mym's player.s
    uint8_t frame[REGS] = {};// 8, 4, 8, 4, 8, 4, 5, 8, 5, 5, 5, 8, 8, 8/*, 0, 0*/ };
    const uint8_t mask[REGS] = {
      0xff, 0x0f, 0xff, 0x0f,
      0xff, 0x0f, 0x1f, 0xff,
      0x1f, 0x1f, 0x1f, 0xff,
      0xff, 0xff/*, 0x00, 0x00*/
    };
    //    fseeko(fi, 0L, SEEK_SET);
    //header.nb_frames = htonl((uint32_t)length);
    fwrite(&header, sizeof(header), 1, fo);
    fflush(fo);

    fprintf(fo,"song");
    fputc('\0', fo);
    fprintf(fo,"me");
    fputc('\0', fo);
    fprintf(fo,"no comment");
    fputc('\0', fo);
    fflush(fo);

#ifdef INTERLEAVED
    frames = malloc(REGS*MIN_ALLOC);
#endif

    while(1)
    {
      unsigned char t;
      unsigned char r, v;


        t = getb();

        if(quit)
            break;

        data = getb();
        //fprintf(stderr," $%.2X\n",data);
	t |= (data << 8) & 0xff00;

	fprintf(stderr, "t: %d\n", t);
	while (t > 0) {
#ifdef INTERLEAVED
	  memcpy(&frames[REGS * header.nb_frames], frame, sizeof(frame));
#else
	  fwrite(frame, sizeof(frame), 1, fo);
#endif
	  t--;
	  header.nb_frames++;
#ifdef INTERLEAVED
	  if (header.nb_frames % MIN_ALLOC == 0)
	    frames = realloc(frames, REGS * (header.nb_frames + MIN_ALLOC));
#endif
	}


        r = getb();
	//fprintf(stderr, "r: %d\n", r);
        //fprintf(fo," $%.2X,",data);

        v = getb();

	if (r > 15) {
	  fprintf(stderr, "r = %d\n", r);
	  //continue;
	  r &= 0x0f;
	}
	//v &= mask[r];
	//fprintf(stderr, "v: %d\n", v);
        //fprintf(fo," $%.2X\n",data);
	frame[r] = v;
    }
#ifdef INTERLEAVED
    memcpy(&frames[REGS * header.nb_frames], frame, sizeof(frame));
#else
    fwrite(frame, sizeof(frame), 1, fo);
#endif
    header.nb_frames++;

#ifdef INTERLEAVED
    for (j = 0; j < REGS; j++) {
      for (i = 0; i < header.nb_frames; i++)
	fwrite(&frames[REGS * i + j], 1, 1, fo);
    }
#endif

    fprintf(fo,"End!");
    fflush(fo);

    rewind(fo);
    header.nb_frames = htonl((uint32_t)header.nb_frames);
    fwrite(&header, sizeof(header), 1, fo);
    fflush(fo);
}


static void cleanup(void)
{
    if(fin)
    {
        free(fin);
        fin = 0;
    }
    if(fon)
    {
        free(fon);
        fon = 0;
    }

    if(fi)
    {
        fflush(fi);
        fclose(fi);
        fi = 0;
    }
    if(fo)
    {
        fflush(fo);
        fclose(fo);
        fo = 0;
    }
}

int main(int argc, char** argv)
{

    if(2==argc)
    {
        int l;
        char *p;
        fin = strdup(argv[1]);
        p = strrchr(fin,'.');
        if(p)
        {
            l = (p - fin) + 2 + 1;
            fon = malloc(l);
            strncpy(fon,fin,p-fin);
            strcat(fon,".S");
        }
        else
        {
            l = strlen(fin) + 2 + 1;
            fon = malloc(l);
            strcpy(fon,fin);
            strcat(fon,".S");
        }
        fi = fopen(fin,"rb");
        if(!fi)
        {
            perror("can't open input file\n");
            cleanup();
            return -1;
        }
        fo = fopen(fon,"wt");
        if(!fo)
        {
            perror("can't open output file\n");
            cleanup();
            return -1;
        }

        /*
         *        fprintf(stderr,"input: %s\n", fin);
         *        fprintf(stderr,"output: %s\n", fon);
         */

        convert();
        cleanup();
        return 0;
    }
    else if(3==argc)
    {
        fin = strdup(argv[1]);
        fon = strdup(argv[2]);

        fi = fopen(fin,"rb");
        if(!fi)
        {
            perror("can't open input file\n");
            cleanup();
            return -1;
        }
        fo = fopen(fon,"wt");
        if(!fo)
        {
            perror("can't open output file\n");
            cleanup();
            return -1;
        }

        /*
         *        fprintf(stderr,"input: %s\n", fin);
         *        fprintf(stderr,"output: %s\n", fon);
         */

        convert();
        cleanup();
        return 0;
    }


    perror("bad params\n");
    return -1;
}
