
/*
ZX Spectrum Pro Tracker 3.0x - 3.6x modules player
Designed to compile for Atari ST with MC68000 processor
Used in Vortex Tracker II in PT3 to SNDH converter
To work on other MC68K based systems simply replace 'ROut' procedure
Based on Ay_Emul sources, tables packed via Ivan Roshin's algorithms

(c)2003-2006 S.V.Bulba

http://bulba.at.kz is
- Micro ST (Win32 SNDH player)
- AY Emulator (Win32 AY-3-8910/12 and YM2149F emulator/player/converter/ripper
- Vortex Tracker II (Win32 AY/YM music editor)
- and many other AY/YM soundchips related

Author Sergey Bulba <vorobey@mail.khstu.ru>
*/

#include "lib.h"

#define VALUE_RANGE_CHECK(command,min,max)	((command>=min) && (command<=max))
#define ord(value)							value
#define abs(value)							(value)<0?-(value):(value)

union tmodtypes 
{
	/*0: */
	char index[1];		// 65536
	/*1: */
	struct 
	{
		char pt3_musicname[99];
		char pt3_tontableid;
		char pt3_delay;
		char pt3_numberofpositions;
		char pt3_loopposition;
		int pt3_patternspointer;
		int pt3_samplespointers[32];
		int pt3_ornamentspointers[16];
		char pt3_positionlist[65356-201];
	} s1;
};


union tregisteray 
{
	/*0:*/
	unsigned char index[14];
	/*1:*/
	struct 
	{
		unsigned int tona;
		unsigned int tonb;
		unsigned int tonc;
		unsigned char noise;
		unsigned char mixer;
		unsigned char amplitudea;
		unsigned char amplitudeb;
		unsigned char amplitudec;
		unsigned char envelopel;
		unsigned char envelopeh;
		unsigned char envtype;
	} s1;
} ;


struct pt3_channel_parameters 
{
	int address_in_pattern,
		ornamentpointer,
		samplepointer,
		ton;
	char loop_ornament_position,
		ornament_length,
		position_in_ornament,
		loop_sample_position,
		sample_length,
		position_in_sample,
		volume,
		number_of_notes_to_skip,
		note,
		slide_to_note,
		amplitude;
	char envelope_enabled,
		enabled,
		simplegliss;
	int current_amplitude_sliding,
		current_noise_sliding,
		current_envelope_sliding,
		ton_slide_count,
		current_onoff,
		onoff_delay,
		offon_delay,
		ton_slide_delay,
		current_ton_sliding,
		ton_accumulator,
		ton_slide_step,
		ton_delta;
	int note_skip_counter;
};

struct pt3_parameters
{
	unsigned int pt3_version;
	unsigned int cur_env_slide;
	unsigned int env_slide_add;
	unsigned int patptr;
	unsigned char cur_env_delay;
	unsigned char env_delay;
	unsigned char noise_base;
	unsigned char delay;
	unsigned char addtonoise;
	unsigned char delaycounter;
	unsigned char currentposition;
	unsigned char _pad_;				// Unused
};

//typedef int[96] 	pt3tonetable;
//typedef char[16][16] pt3voltable;

struct tplvars 
{
	char t_pack[54];
	char tc[66];
	char nt_data[8][2];
	union 
	{
		/*0:*/
		char pt3voltable[16][16]; 		//  vt	// typedef char[16][16] pt3voltable;
		// Created Volume Table   
		/*1:*/
		struct 
		{
			union tregisteray r;
			int env_base;
			int tt[50-1];
		} s1; 
		// Tone tables data temporary depacked here   
		/*2:*/
		unsigned char v[256];
	} vt_;

	int pt3tonetable[96]; 		// pt3tonetable typedef int[96] 	pt3tonetable;
	// Created Note Table  
	struct pt3_parameters pt3;
	struct pt3_channel_parameters pt3_a;
	struct pt3_channel_parameters pt3_b;
	struct pt3_channel_parameters pt3_c;
};

//9 tables total are:
/*Table #0 of Pro Tracker 3.3x - 3.4r*/
/*Table #0 of Pro Tracker 3.4x - 3.5x*/
/*Table #1 of Pro Tracker 3.3x - 3.5x)*/
/*Table #2 of Pro Tracker 3.4r*/
/*Table #2 of Pro Tracker 3.4x - 3.5x*/
/*Table #3 of Pro Tracker 3.4r*/
/*Table #3 of Pro Tracker 3.4x - 3.5x*/
/*Volume table of Pro Tracker 3.3x - 3.4x*/
/*Volume table of Pro Tracker 3.5x*/

// first 12 values of tone tables (packed) 
const unsigned char t_pack1[54] = 
{
	0x6ec*2 / 256,0x6ec*2 % 256,
	0x755-0x6ec,
	0x7c5-0x755,
	0x83b-0x7c5,
	0x8b8-0x83b,
	0x93d-0x8b8,
	0x9ca-0x93d,
	0xa5f-0x9ca,
	0xafc-0xa5f,
	0xba4-0xafc,
	0xc55-0xba4,
	0xd10-0xc55,
	0x66d*2 / 256,0x66d*2 % 256,
	0x6cf-0x66d,
	0x737-0x6cf,
	0x7a4-0x737,
	0x819-0x7a4,
	0x894-0x819,
	0x917-0x894,
	0x9a1-0x917,
	0xa33-0x9a1,
	0xacf-0xa33,
	0xb73-0xacf,
	0xc22-0xb73,
	0xcda-0xc22,
	0x704*2 / 256,0x704*2 % 256,
	0x76e-0x704,
	0x7e0-0x76e,
	0x858-0x7e0,
	0x8d6-0x858,
	0x95c-0x8d6,
	0x9ec-0x95c,
	0xa82-0x9ec,
	0xb22-0xa82,
	0xbcc-0xb22,
	0xc80-0xbcc,
	0xd3e-0xc80,
	0x7e0*2 / 256,0x7e0*2 % 256,
	0x858-0x7e0,
	0x8e0-0x858,
	0x960-0x8e0,
	0x9f0-0x960,
	0xa88-0x9f0,
	0xb28-0xa88,
	0xbd8-0xb28,
	0xc80-0xbd8,
	0xd60-0xc80,
	0xe10-0xd60,
	0xef8-0xe10,
	0/*Dummy*/
};

// tone tables corrections 
#define tcold_0 0
#define tcold_1 12
#define tcold_2 14
#define tcold_3 33
#define tcnew_0 42
#define tcnew_1 tcold_1
#define tcnew_2 53
#define tcnew_3 32

const unsigned char tc1[66] = 
{
	0+1,0x4+1,0x8+1,0xa+1,0xc+1,0xe+1,0x12+1,0x14+1,
	0x18+1,0x24+1,0x3c+1,0,
	0x5c+1,0,
	0x30+1,0x36+1,0x4c+1,0x52+1,0x5e+1,0x70+1,0x82,0x8c,0x9c,
	0x9e,0xa0,0xa6,0xa8,0xaa,0xac,0xae,0xae,0,
	0x56+1,
	0x1e+1,0x22+1,0x24+1,0x28+1,0x2c+1,0x2e+1,0x32+1,0xbe+1,0,
	0x1c+1,0x20+1,0x22+1,0x26+1,0x2a+1,0x2c+1,0x30+1,0x54+1,
	0xbc+1,0xbe+1,0,
	0x1a+1,0x20+1,0x24+1,0x28+1,0x2a+1,0x3a+1,0x4c+1,0x5e+1,
	0xba+1,0xbc+1,0xbe+1,0,
	0/*Dummy*/
};

// first 12 values of tone tables (depacked structure) 
#define t_old_1  0
#define t_old_2  t_old_1+24
#define t_old_3  t_old_2+24
#define t_old_0  t_old_3+2
#define t_new_0  t_old_0
#define t_new_1  t_old_1
#define t_new_2  t_new_0+24
#define t_new_3  t_old_3

const unsigned char nt_data1[8][2] = 
{
	{t_new_0,tcnew_0},
	{t_old_0+1,tcold_0},
	{t_new_1+1,tcnew_1},
	{t_old_1+1,tcold_1},
	{t_new_2,tcnew_2},
	{t_old_2,tcold_2},
	{t_new_3,tcnew_3},
	{t_old_3,tcold_3}
};

struct tplvars vars;
#include "music.c"		// _MusicData: tmodtypes




void rout()
{
	int i;
	*(char*)(0xbb80)^=128;

	for( i = 0; i <= 12; i ++)
	{
		w8912(i,vars.vt_.s1.r.index[i]);		
		//*(char*)(0xff8800) = i;
		//*(char*)(0xff8802) = vars.vt_.s1.r.index[i];
	}
	if ((int)(vars.vt_.s1.r.s1.envtype) != -1) 
	{
		w8912(13,vars.vt_.s1.r.s1.envtype);		
		//*(char*)(0xff8800) = 13;
		//*(char*)(0xff8802) = vars.vt_.s1.r.s1.envtype;
	}
}

unsigned int mw(unsigned char l,unsigned char h)
{
	
	int mw_result;
	mw_result = l + ((int)(h) << 8);
	return mw_result;
}

unsigned int iw(unsigned int w)
{
	return w;
	//int iw_result;
	//iw_result = (w << 8) | (w >> 8);
	//return iw_result;
}

void pt3init()
{
	int i,j,k,l,m;
	char a;
	int w;
	char fl;

	{
		struct tplvars* with = &vars; 

		printf("Size: %d \r\n",sizeof(with->vt_));
		printf("Size: %d \r\n",sizeof(with->pt3tonetable));
		printf("Size: %d \r\n",sizeof(with->pt3));
		printf("Size: %d \r\n",sizeof(with->pt3_a)*3);
		// 256{vt} + 192{nt} + 16{pt3} + 48*3{pt3_a+pt3_b+pt3_c}
		for( i = 0; i <= sizeof(with->vt_) + sizeof(with->pt3tonetable) + sizeof(with->pt3) + sizeof(with->pt3_a)*3 - 1; i ++)
		{
			with->vt_.v[i] = 0;
		}

		// note table data depacker  i = 0; j = 49-1;
		printf("Note table depacker \r\n");
		do 
		{
			a = with->t_pack[i]; i += 1;
			if (a < 15*2) 
			{
				w = ((int)(a) << 8) + with->t_pack[i]; 
				i += 1;
			}
			else
			{
				w += a + a;
			}
			with->vt_.s1.tt[j] = w; 
			j -= 1;
		} 
		while (!(j < 0));

		printf("Note table creator \r\n");
		{		
			struct pt3_parameters* with1 = &with->pt3;
			union tmodtypes* with2 = (union tmodtypes*)(&_MusicData);

			
			with1->pt3_version = 6;
			if ((with2->index[13] >= 0x30) && (with2->index[13] <= 0x39)) 
				with1->pt3_version = with2->index[13] - 0x30;

			// NoteTableCreator (c) Ivan Roshin     
			// A - NoteTableNumber*2+VersionForNoteTable     
			// (xx1b - 3.xx..3.4r, xx0b - 3.4x..3.6x..VTII1.0)    
			a = (with2->s1.pt3_tontableid << 1) & 7;
			if (with1->pt3_version < 4)  a += 1;

			j = with->nt_data[a][0];
			fl = (j & 1) != 0;
			j >>= 1;
			for( i = 0; i <= 11; i ++)
			{
				w = with->vt_.s1.tt[j]; j += 1;
				l = i;
				for( k = 0; k <= 7; k ++)
				{
					m = ord(! fl && ((w & 1) != 0));
					w >>= 1;
					with->pt3tonetable[l] = w + m;
					l += 12;
				}
			}

			j = with->nt_data[a][1];
			if (j == tcold_1)  with->pt3tonetable[23] = 0x3fd;
			while (1)
			{
				i = with->tc[j]; 
				if (i == 0)  break;
				
				if ((i & 1) != 0) 
					with->pt3tonetable[i >> 1] -= 1;
				else
					with->pt3tonetable[i >> 1] += 1;
				j += 1;
			} 

			//printf("Volume table creator \r\n");
			
			// VolTableCreator (c) Ivan Roshin     
			// VersionForVolumeTable (0..4 - 3.xx..3.4x; 5.. - 3.5x..3.6x..VTII1.0)
			w = 0;
			i = 0x11;
			fl = with1->pt3_version >= 5;
			if (! fl) 
			{
				w = 0x10;
				i = 0x10;
			}

			j = 16;
			do 
			{
				w += i;
				l = 0;
				do 
				{
					k = l >> 8;
					if (fl && ((l & 128) != 0))  k += 1;
					with->vt_.v[j] = k;
					l += w;
					j += 1;
				} 
				while (!((j & 15) == 0));
				if ((w & 255) == 0x77)  w += 1;
			} 
			while (!(j == 256));


			with1->delaycounter = 1;
			with1->delay = with2->s1.pt3_delay;
			with1->patptr = mw(with2->index[103],with2->index[104]);
			w = with1->patptr + with2->s1.pt3_positionlist[0] * 2;
			with->pt3_a.address_in_pattern = mw(with2->index[w + 0],with2->index[w + 1]);
			with->pt3_b.address_in_pattern = mw(with2->index[w + 2],with2->index[w + 3]);
			with->pt3_c.address_in_pattern = mw(with2->index[w + 4],with2->index[w + 5]);
		}

		{
			struct pt3_channel_parameters* with1 = &with->pt3_a;
			union tmodtypes* with2 = (union tmodtypes*)(&_MusicData); 

			with1->ornamentpointer = mw(with2->index[169],with2->index[170]);
			with1->loop_ornament_position = with2->index[with1->ornamentpointer];
			with1->ornamentpointer += 1;
			with1->ornament_length = with2->index[with1->ornamentpointer];
			with1->ornamentpointer += 1;
			with1->samplepointer = mw(with2->index[107],with2->index[108]);
			with1->loop_sample_position = with2->index[with1->samplepointer];
			with1->samplepointer += 1;
			with1->sample_length = with2->index[with1->samplepointer];
			with1->samplepointer += 1;
			with1->volume = 15;
			with1->note_skip_counter = 1;
		}

		{
			struct pt3_channel_parameters* with1 = &with->pt3_b; 

			with1->ornamentpointer = with->pt3_a.ornamentpointer;
			with1->loop_ornament_position = with->pt3_a.loop_ornament_position;
			with1->ornament_length = with->pt3_a.ornament_length;
			with1->samplepointer = with->pt3_a.samplepointer;
			with1->loop_sample_position = with->pt3_a.loop_sample_position;
			with1->sample_length = with->pt3_a.sample_length;
			with1->volume = 15;
			with1->note_skip_counter = 1;
		}

		{
			struct pt3_channel_parameters* with1 = &with->pt3_c; 

			with1->ornamentpointer = with->pt3_a.ornamentpointer;
			with1->loop_ornament_position = with->pt3_a.loop_ornament_position;
			with1->ornament_length = with->pt3_a.ornament_length;
			with1->samplepointer = with->pt3_a.samplepointer;
			with1->loop_sample_position = with->pt3_a.loop_sample_position;
			with1->sample_length = with->pt3_a.sample_length;
			with1->volume = 15;
			with1->note_skip_counter = 1;
		}

	}

	rout();
}

void pl();


static void p(struct pt3_channel_parameters* chan)
{
	char quit;
	char flag9,flag8,flag5,flag4,flag3,flag2,flag1;
	char counter;
	int prnote,prsliding;
	int wp;

	prnote = chan->note;
	prsliding = chan->current_ton_sliding;
	quit = 0;
	counter = 0;
	flag9 = 0; flag8 = 0; flag5 = 0; flag4 = 0;
	flag3 = 0; flag2 = 0; flag1 = 0;
	{ 
		struct tplvars* with = &vars; 
	{
		union tmodtypes* with2 = (union tmodtypes*)(&_MusicData); 

		do 
		{
			unsigned char command=with2->index[chan->address_in_pattern];
			if (VALUE_RANGE_CHECK(command,0xf0,0xff))
			{
				wp = 169 + (with2->index[chan->address_in_pattern] - 0xf0) * 2;
				chan->ornamentpointer = mw(with2->index[wp],with2->index[wp + 1]);
				chan->loop_ornament_position = with2->index[chan->ornamentpointer];
				chan->ornamentpointer += 1;
				chan->ornament_length = with2->index[chan->ornamentpointer];
				chan->ornamentpointer += 1;
				chan->address_in_pattern += 1;
				wp = 105 + with2->index[chan->address_in_pattern];
				chan->samplepointer = mw(with2->index[wp],with2->index[wp + 1]);
				chan->loop_sample_position = with2->index[chan->samplepointer];
				chan->samplepointer += 1;
				chan->sample_length = with2->index[chan->samplepointer];
				chan->samplepointer += 1;
				chan->envelope_enabled = 0;
				chan->position_in_ornament = 0;
			}
			else
			if (VALUE_RANGE_CHECK(command,0xd1,0xef))
			{
				wp = 105 + (with2->index[chan->address_in_pattern] - 0xd0) * 2;
				chan->samplepointer = mw(with2->index[wp],with2->index[wp + 1]);
				chan->loop_sample_position = with2->index[chan->samplepointer];
				chan->samplepointer += 1;
				chan->sample_length = with2->index[chan->samplepointer];
				chan->samplepointer += 1;
			}
			else
			if (command==0xd0)
				quit = 1;
			else
			if (VALUE_RANGE_CHECK(command,0xc1,0xcf))
			{
				chan->volume = with2->index[chan->address_in_pattern] - 0xc0;
			}
			else
			if (command==0xc0)
			{
				chan->position_in_sample = 0;
				chan->current_amplitude_sliding = 0;
				chan->current_noise_sliding = 0;
				chan->current_envelope_sliding = 0;
				chan->position_in_ornament = 0;
				chan->ton_slide_count = 0;
				chan->current_ton_sliding = 0;
				chan->ton_accumulator = 0;
				chan->current_onoff = 0;
				chan->enabled = 0;
				quit = 1;
			}
			else
			if (VALUE_RANGE_CHECK(command, 0xb2,0xbf))
			{
				chan->envelope_enabled = 1;
				with->vt_.s1.r.s1.envtype = with2->index[chan->address_in_pattern] - 0xb1;
				chan->address_in_pattern += 1;
				{
					struct pt3_parameters* with3 = &with->pt3; 
		
					// not big-endian
					with->vt_.s1.env_base = mw(with2->index[chan->address_in_pattern + 1],with2->index[chan->address_in_pattern]);
					chan->address_in_pattern += 1;
					chan->position_in_ornament = 0;
					with3->cur_env_slide = 0;
					with3->cur_env_delay = 0;
				}
			}
			else
			if (command==0xb1)
			{
				chan->address_in_pattern += 1;
				chan->number_of_notes_to_skip = with2->index[chan->address_in_pattern];
			}
			else
			if (command==0xb0)
			{
				chan->envelope_enabled = 0;
				chan->position_in_ornament = 0;
			}
			else
			if (VALUE_RANGE_CHECK(command, 0x50, 0xaf))
			{
				chan->note = with2->index[chan->address_in_pattern] - 0x50;
				chan->position_in_sample = 0;
				chan->current_amplitude_sliding = 0;
				chan->current_noise_sliding = 0;
				chan->current_envelope_sliding = 0;
				chan->position_in_ornament = 0;
				chan->ton_slide_count = 0;
				chan->current_ton_sliding = 0;
				chan->ton_accumulator = 0;
				chan->current_onoff = 0;
				chan->enabled = 1;
				quit = 1;
			}
			else
			if (VALUE_RANGE_CHECK(command, 0x40,0x4f))
			{
				wp = 169 + (with2->index[chan->address_in_pattern] - 0x40) * 2;
				chan->ornamentpointer = mw(with2->index[wp],with2->index[wp + 1]);
				chan->loop_ornament_position = with2->index[chan->ornamentpointer];
				chan->ornamentpointer += 1;
				chan->ornament_length = with2->index[chan->ornamentpointer];
				chan->ornamentpointer += 1;
				chan->position_in_ornament = 0;
			}
			else
			if (VALUE_RANGE_CHECK(command, 0x20,0x3f))
			{
				with->pt3.noise_base = with2->index[chan->address_in_pattern] - 0x20;
			}
			else
			if (VALUE_RANGE_CHECK(command, 0x10,0x1f))
			{
				if (with2->index[chan->address_in_pattern] == 0x10) 
					chan->envelope_enabled = 0;
				else
				{
					with->vt_.s1.r.s1.envtype = with2->index[chan->address_in_pattern] - 0x10;
					chan->address_in_pattern += 1;
					{
						struct pt3_parameters* with3 = &with->pt3; 
		
						// not big-endian
						with->vt_.s1.env_base = mw(with2->index[chan->address_in_pattern + 1],with2->index[chan->address_in_pattern]);
						chan->address_in_pattern += 1;
						chan->envelope_enabled = 1;
						with3->cur_env_slide = 0;
						with3->cur_env_delay = 0;
					}
				}
				chan->address_in_pattern += 1;
				wp = 105 + with2->index[chan->address_in_pattern];
				chan->samplepointer = mw(with2->index[wp],with2->index[wp + 1]);
				chan->loop_sample_position = with2->index[chan->samplepointer];
				chan->samplepointer += 1;
				chan->sample_length = with2->index[chan->samplepointer];
				chan->samplepointer += 1;
				chan->position_in_ornament = 0;
			}
			else
			if (command==0x9)
			{
				counter += 1;
				flag9 = counter;
			}
			else
			if (command==0x8)
			{
				counter += 1;
				flag8 = counter;
			}
			else
			if (command==0x5)
			{
				counter += 1;
				flag5 = counter;
			}
			else
			if (command==0x4)
			{
				counter += 1;
				flag4 = counter;
			}
			else
			if (command==0x3)
			{
				counter += 1;
				flag3 = counter;
			}
			else
			if (command==0x2)
			{
				counter += 1;
				flag2 = counter;
			}
			else
			if (command==0x1)
			{
				counter += 1;
				flag1 = counter;
			}
			chan->address_in_pattern += 1;
		} while (!quit);
		
		while (counter > 0) 
		{
			if (counter == flag1) 
			{
				chan->ton_slide_delay = with2->index[chan->address_in_pattern];
				chan->ton_slide_count = chan->ton_slide_delay;
				chan->address_in_pattern += 1;
				chan->ton_slide_step = mw(with2->index[chan->address_in_pattern],with2->index[chan->address_in_pattern + 1]);
				chan->address_in_pattern += 2;
				chan->simplegliss = 1;
				chan->current_onoff = 0;
			}
			else if (counter == flag2) 
			{
				chan->simplegliss = 0;
				chan->current_onoff = 0;
				chan->ton_slide_delay = with2->index[chan->address_in_pattern];
				chan->ton_slide_count = chan->ton_slide_delay;
				chan->address_in_pattern += 3;
				chan->ton_slide_step = abs((int)(mw(with2->index[chan->address_in_pattern],with2->index[chan->address_in_pattern + 1])));
				chan->address_in_pattern += 2;
				chan->ton_delta = with->pt3tonetable[chan->note] - with->pt3tonetable[prnote];
				chan->slide_to_note = chan->note;
				chan->note = prnote;
				if (with->pt3.pt3_version >= 6) 
					chan->current_ton_sliding = prsliding;
				if (chan->ton_delta - chan->current_ton_sliding < 0) 
					chan->ton_slide_step = -chan->ton_slide_step;
			}
			else if (counter == flag3) 
			{
				chan->position_in_sample = with2->index[chan->address_in_pattern];
				chan->address_in_pattern += 1;
			}
			else if (counter == flag4) 
			{
				chan->position_in_ornament = with2->index[chan->address_in_pattern];
				chan->address_in_pattern += 1;
			}
			else if (counter == flag5) 
			{
				chan->onoff_delay = with2->index[chan->address_in_pattern];
				chan->address_in_pattern += 1;
				chan->offon_delay = with2->index[chan->address_in_pattern];
				chan->current_onoff = chan->onoff_delay;
				chan->address_in_pattern += 1;
				chan->ton_slide_count = 0;
				chan->current_ton_sliding = 0;
			}
			else if (counter == flag8) 
			{
				{
					struct pt3_parameters* with3 = &with->pt3; 

					with3->env_delay = with2->index[chan->address_in_pattern];
					with3->cur_env_delay = with3->env_delay;
					chan->address_in_pattern += 1;
					with3->env_slide_add = mw(with2->index[chan->address_in_pattern],with2->index[chan->address_in_pattern + 1]);
				}
				chan->address_in_pattern += 2;
			}
			else if (counter == flag9) 
			{
				with->pt3.delay = with2->index[chan->address_in_pattern];
				chan->address_in_pattern += 1;
			}
			counter -= 1;
		}
		chan->note_skip_counter = chan->number_of_notes_to_skip;
	}}
}


static char tempmixer;

static int addtoenv;


static void c(struct pt3_channel_parameters* chan)
{
	char j,b1,b0;
	int w,wp;

	{ 
		struct tplvars* with = &vars; 
	{
		union tmodtypes* with2 = (union tmodtypes*)(&_MusicData); 

		if (chan->enabled) 
		{
			wp = chan->samplepointer + chan->position_in_sample * 4;
			chan->ton = mw(with2->index[wp + 2],with2->index[wp + 3]);
			chan->ton += chan->ton_accumulator;
			b0 = with2->index[wp];
			b1 = with2->index[wp + 1];
			if ((b1 & 0x40) != 0) 
				chan->ton_accumulator = chan->ton;
			j = chan->note + with2->index[chan->ornamentpointer + chan->position_in_ornament];
			if ((int)(j) < 0)  j = 0;
			else if (j > 95)  j = 95;
			w = with->pt3tonetable[j];
			chan->ton = (chan->ton + chan->current_ton_sliding + w) & 0xfff;
			if (chan->ton_slide_count > 0) 
			{
				chan->ton_slide_count -= 1;
				if (chan->ton_slide_count == 0) 
				{
					chan->current_ton_sliding += chan->ton_slide_step;
					chan->ton_slide_count = chan->ton_slide_delay;
					if (! chan->simplegliss) 
						if (((chan->ton_slide_step < 0) && (chan->current_ton_sliding <= chan->ton_delta)) ||
							((chan->ton_slide_step >= 0) && (chan->current_ton_sliding >= chan->ton_delta))) 
						{
							chan->note = chan->slide_to_note;
							chan->ton_slide_count = 0;
							chan->current_ton_sliding = 0;
						}
				}
			}
			chan->amplitude = b1 & 0xf;
			if ((b0 & 0x80) != 0) 
				if ((b0 & 0x40) != 0) 
				{
					if (chan->current_amplitude_sliding < 15) 
						chan->current_amplitude_sliding += 1;
				}
				else if (chan->current_amplitude_sliding > -15) 
					chan->current_amplitude_sliding -= 1;
			chan->amplitude += chan->current_amplitude_sliding;
			if ((int)(chan->amplitude) < 0)  chan->amplitude = 0;
			else if (chan->amplitude > 15)  chan->amplitude = 15;
			chan->amplitude = with->vt_.pt3voltable[chan->volume][chan->amplitude];
			if (((b0 & 1) == 0) && chan->envelope_enabled) 
				chan->amplitude = chan->amplitude | 16;
			if ((b1 & 0x80) != 0) 
			{
				if ((b0 & 0x20) != 0) 
					j = ((b0 >> 1) | 0xf0) + chan->current_envelope_sliding;
				else
					j = ((b0 >> 1) & 0xf) + chan->current_envelope_sliding;
				if ((b1 & 0x20) != 0)  chan->current_envelope_sliding = j;
				addtoenv += j;
			}
			else
			{
				with->pt3.addtonoise = (b0 >> 1) + chan->current_noise_sliding;
				if ((b1 & 0x20) != 0) 
					chan->current_noise_sliding = with->pt3.addtonoise;
			}
			tempmixer = ((b1 >> 1) & 0x48) | tempmixer;
			chan->position_in_sample += 1;
			if (chan->position_in_sample >= chan->sample_length) 
				chan->position_in_sample = chan->loop_sample_position;
			chan->position_in_ornament += 1;
			if (chan->position_in_ornament >= chan->ornament_length) 
				chan->position_in_ornament = chan->loop_ornament_position;
		}
		else
			chan->amplitude = 0;
		tempmixer = tempmixer >> 1;
		if (chan->current_onoff > 0) 
		{
			chan->current_onoff -= 1;
			if (chan->current_onoff == 0) 
			{
				chan->enabled = ! chan->enabled;
				if (chan->enabled)  chan->current_onoff = chan->onoff_delay;
				else chan->current_onoff = chan->offon_delay;
			}
		}
	}}
}

void pl()
{
	int wp;
	{
		struct tplvars* with = &vars; 


		with->vt_.s1.r.s1.envtype = -1;
		{
			struct pt3_parameters* with1 = &with->pt3; 

			with1->delaycounter -= 1;
			if (with1->delaycounter == 0) 
			{
				{
					struct pt3_channel_parameters* with2 = &with->pt3_a; 

					with2->note_skip_counter -= 1;
					if (with2->note_skip_counter == 0) 
					{
						union tmodtypes* with3 = (union tmodtypes*)(&_MusicData); 

						if (with3->index[with2->address_in_pattern] == 0) 
						{
							with1->currentposition += 1;
							if (with1->currentposition == with3->s1.pt3_numberofpositions) 
								with1->currentposition = with3->s1.pt3_loopposition;
							wp = with1->patptr + with3->s1.pt3_positionlist[with1->currentposition] * 2;
							with2->address_in_pattern = mw(with3->index[wp + 0],with3->index[wp + 1]);
							with->pt3_b.address_in_pattern = mw(with3->index[wp + 2],with3->index[wp + 3]);
							with->pt3_c.address_in_pattern = mw(with3->index[wp + 4],with3->index[wp + 5]);
							with1->noise_base = 0;
						}
						p(&with->pt3_a);
					}
				}
				{
					struct pt3_channel_parameters* with2 = &with->pt3_b; 

					with2->note_skip_counter -= 1;
					if (with2->note_skip_counter == 0) 
						p(&with->pt3_b);
				}
				{
					struct pt3_channel_parameters* with2 = &with->pt3_c; 

					with2->note_skip_counter -= 1;
					if (with2->note_skip_counter == 0) 
						p(&with->pt3_c);
				}
				with1->delaycounter = with1->delay;
			}

			addtoenv = 0;
			tempmixer = 0;
			c(&with->pt3_a);
			c(&with->pt3_b);
			c(&with->pt3_c);

			with->vt_.s1.r.s1.mixer = tempmixer;

			with->vt_.s1.r.s1.tona = iw(with->pt3_a.ton);
			with->vt_.s1.r.s1.tonb = iw(with->pt3_b.ton);
			with->vt_.s1.r.s1.tonc = iw(with->pt3_c.ton);

			with->vt_.s1.r.s1.amplitudea = with->pt3_a.amplitude;
			with->vt_.s1.r.s1.amplitudeb = with->pt3_b.amplitude;
			with->vt_.s1.r.s1.amplitudec = with->pt3_c.amplitude;

			with->vt_.s1.r.s1.noise = (with1->noise_base + with1->addtonoise) & 31;

			wp = with->vt_.s1.env_base + addtoenv + with1->cur_env_slide;
			with->vt_.s1.r.s1.envelopel = wp;
			with->vt_.s1.r.s1.envelopeh = wp >> 8;

			if (with1->cur_env_delay > 0) 
			{
				with1->cur_env_delay -= 1;
				if (with1->cur_env_delay == 0) 
				{
					with1->cur_env_delay = with1->env_delay;
					with1->cur_env_slide += with1->env_slide_add;
				}
			}
		}

	}
	rout();
}

/*
void pt3init()
{
}

void pl()
{
}
*/


