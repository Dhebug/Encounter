// C Header File
// Created 19/08/2007; 18:32:28

#include "global.h"
#define __BUILDING_FPMATH__
#include "fpmath.h"
#include "math.h"

#ifndef NOFPMATH

fpfloat _fp_sin_table[COSSIN_TABLE_SZ];
// sin(a+pi/2) = cos(a)
fpfloat *_fp_cos_table = &_fp_sin_table[COS_TABLE_SZ/4];

void _fp_init(void)
{
	int i;
	//ASSERT(sizeof(short)==2);
	ASSERT(sizeof(uint8)==1);
	ASSERT(sizeof(int8)==1);
	ASSERT(sizeof(uint16)==2);
	ASSERT(sizeof(int16)==2);
	//ASSERT(sizeof(uint32)==4);
	//ASSERT(sizeof(int32)==4);
	ASSERT(sizeof(fpfloat)==sizeof(_fp_full_t));
	//ASSERTF(sizeof(fpfloat)==2, "%ld", sizeof(fpfloat));
	//
	//_fp_cos_table = &_fp_sin_table[COS_TABLE_SZ/4];
	/*
	for (i = 0; i < COSSIN_TABLE_SZ-1; i++) {
		_fp_sin_table[i] = float_to_fp(sin((float)(i%COS_TABLE_SZ)*2*M_PI/(COS_TABLE_SZ)));
		//printf("%04x\n",_fp_cos_table[i].data);
	}
	*/
	// faster
	for (i = 0; i < COS_TABLE_SZ/2; i++) {
		//printf(":: %x\n", (int)(sin(i*2*M_PI/(COS_TABLE_SZ))*(1<<_FPSH)));
		_fp_sin_table[i] = float_to_fp(sin((i/*%COS_TABLE_SZ*/)*2*M_PI/(COS_TABLE_SZ)));
		//printf("%x\n",_fp_sin_table[i]/*.data*/);
		//printf(":%d\n", (int)(10*fp_to_float(_fp_sin_table[i])));
	}
	for (; i < COS_TABLE_SZ; i++) {
		_fp_sin_table[i] = - _fp_sin_table[i - COS_TABLE_SZ/2];
		//printf(":%d\n", (int)(10*fp_to_float(_fp_sin_table[i])));
	}
	for (; i < COSSIN_TABLE_SZ; i++) {
		_fp_sin_table[i] = _fp_sin_table[i%COS_TABLE_SZ];
		//printf(":%d\n", (int)(10*fp_to_float(_fp_sin_table[i])));
	}
	
}

#if 0
/*
A,B * C,D
S=signof(A,B)
T=signof(C,D)
a=abs(A); ...
= Sa,b * Sc,d
= (Sa + .1 * Sb) * (Tc + .1 * Td)
= (Sa + .1 * Sb) * Tc + (Sa + .1 * Sb) * .1 * Td
= S*T*a*c + .1*S*T*b*c + S*T*a*.1*d + .1*S*T*b*.1*d
*/
fpfloat fpmul(fpfloat a, fpfloat b)
{
#if 0
	int sa, sb;
	//int acc;
	sa = a.i < 0 ? -1 : 1;
	sb = b.i < 0 ? -1 : 1;
#endif
	int64 big = (int64)a.data * b.data;
	fpfloat ret;
	ret.data = big >> 16;
	//XXX
	return ret;
}

fpfloat fpdiv(fpfloat a, fpfloat b)
{
	int64 big = (int64)a.data / b.data;
	fpfloat ret;
	ret.data = big >> 16;
	//XXX
	return ret;
}

fpfloat fpsin(fpfloat a)
{
	return fpcos(fpsub(FPHALF_PI, a));
}

fpfloat fpcos(fpfloat a)
{
	fpfloat v = FPTWO_PI;
	int index;
	a.data %= v.data; // restrict to 2*pi
	if (fpge(a, FPPI)) { // to pi
		a = fpsub(FPTWO_PI, a);
	}
	v = FPHALF_PI;
	if (fpge(a, FPHALF_PI)) {
		index = ((FPPI).data - a.data) * (COS_TABLE_SZ-1) / v.data;
		// safety (no I don't trust my own code :p)
		//index = min(COS_TABLE_SZ, index);
		//index = max(0, index);
		v.data = - _fp_cos_table[index].data;
	} else {
		index = a.data * (COS_TABLE_SZ-1) / v.data;
		// safety
		//index = min(COS_TABLE_SZ, index);
		//index = max(0, index);
		v.data = _fp_cos_table[index].data;
	}
	return v;
}
#endif

#endif /* NOFPMATH */
