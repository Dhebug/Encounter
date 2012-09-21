// -*- c-basic-offset: 8 -*-
// C Header File
// Created 20/08/2007; 02:26:54

#if defined(__GNU_C__) || defined(__TIGCC_ENV__)
#define _A_PACKED __attribute__ ((packed))
#else
#define _A_PACKED 
#endif

#if 0
//ORIC OSDK doesn't like unions of structs...
typedef union {
	struct {
	int8 m /*__attribute__ ((packed))*/;	//magnitude (integral) part
	uint8 f /*__attribute__ ((packed))*/;	//fractional part
	} _A_PACKED ;
	int16 data;
} fpfloat;
#endif
typedef int16 _fp_full_t;
typedef int8 _fp_frac_t;
/* so make it simpler */
typedef _fp_full_t fpfloat;
#define _FPSH 8
#define FP_MAG(fp) ((int8)(((fp) >> _FPSH) & 0xff))
#define FP_FRAC(fp) ((uint8)((fp) & 0xff))
#define FP_MAKE(mag,frac) ((_fp_full_t)mag << _FPSH | ((uint8)frac))

extern void _fp_init(void);

#define COS_TABLE_SH (8)
#define COS_TABLE_SZ (1<<COS_TABLE_SH)
// stuff the cos and sin tables together
#define COSSIN_TABLE_SZ (COS_TABLE_SZ + COS_TABLE_SZ / 4)
extern fpfloat _fp_sin_table[COSSIN_TABLE_SZ];
extern fpfloat *_fp_cos_table;

#if defined(__GNU_C__) || defined(__TIGCC_ENV__)
#define FPINLINE static inline
#else
#define FPINLINE static 
#endif

/* do not even try to use 64 bit types */
#define NO64 1



#define FPPI	((fpfloat)(_fp_full_t)(M_PI * (float)(((_fp_full_t)1) << _FPSH)))
#define FPHALF_PI	((fpfloat)(_fp_full_t)(M_PI_2 * (float)(((_fp_full_t)1) << _FPSH)))
/*#define FPTWO_PI	((fpfloat){(_fp_full_t)(2 * M_PI * (float)(((_fp_full_t)1) << _FPSH))})*/

#define FPTWO_PI ((fpfloat)(_fp_full_t)(2 * M_PI * (float)(((_fp_full_t)1) << _FPSH)))

#define FPZERO	((fpfloat)0x0000)
#define FPONE	((fpfloat)0x0100)

FPINLINE myint fp_to_int(fpfloat f)
{
	return FP_MAG(f);
}

FPINLINE fpfloat int_to_fp(myint i)
{
	fpfloat f;// = {{i, 0}};
	f = FP_MAKE(i, 0);
	return f;
}

#define fp_to_float(f) ((float)(f) / (float)((_fp_full_t)1 << _FPSH))
#define float_to_fp(f) ((fpfloat)(_fp_full_t)((f) * (float)((_fp_full_t)1 << _FPSH)))
/* OSDK doesn't like it!
FPINLINE fpfloat float_to_fp(float f)
{
  fpfloat v;
  v = (_fp_full_t)(f * (float)((_fp_full_t)1 << _FPSH));
  return v;
}
*/

#define fplt(a,b)		((a)<(b))
#define fple(a,b)		((a)<=(b))
#define fpgt(a,b)		((a)>(b))
#define fpge(a,b)		((a)>=(b))
#define fpeq(a,b)		((a)==(b))
#define fpne(a,b)		((a)!=(b))

FPINLINE fpfloat fpadd(fpfloat a, fpfloat b)
{
	//return (fpfloat) ( (*(int32*)&a) + (*(int32*)&b) );
	a += b;
	return a;
}

FPINLINE fpfloat fpaddi(fpfloat a, myint b)
{
	int8 v = FP_MAG(a);
	v += b;
	a = FP_MAKE(v, FP_FRAC(a));
	return (a);
}

FPINLINE fpfloat fpsub(fpfloat a, fpfloat b)
{
	a -= b;
	return a;
}

FPINLINE fpfloat fpmul(fpfloat a, fpfloat b)
{
	fpfloat ret;
	
	/*
	  int32 big = (int32)a * b;
	  ret = big >> _FPSH;
	*/
	// it's wrong...
	//ret.data = (a.data >> _FPSH/2) * (b.data >> _FPSH/2);
	//printf("%04x*%04x=%04x\n",a.data,b.data,ret.data);
	//ret = (a >> _FPSH/2) * (b >> _FPSH/2);
	
	ret =  ((((int16)FP_MAG(a) * FP_MAG(b))<<_FPSH) +	\
		((int16)FP_MAG(a) * FP_FRAC(b)) +			\
		((int16)FP_FRAC(a) * FP_MAG(b)) +			\
		(((int16)FP_FRAC(a) * FP_FRAC(b))>>_FPSH));
	
	return ret;
}

FPINLINE fpfloat fpdiv(fpfloat a, fpfloat b)
{
	int32 big;
	fpfloat ret;
	if (fpeq(b, FPZERO))
		return a;
	big = (((int32)a) << _FPSH) / (int32)b;
	ret = big;
/*	if (big > 0)
		ret.data = big >> 16;
	else
		ret.data = -((-big) >> 16);*/
	//XXX
	return ret;
}

FPINLINE fpfloat fpcos(fpfloat a)
{
	myint index;
	fpfloat twopi = FPTWO_PI;
	//a.data %= v.data; // restrict to 2*pi
	/*while (fpge(a, FPTWO_PI))
		a = fpsub(a, FPTWO_PI);
	while (fplt(a, FPZERO))
		a = fpadd(a, FPTWO_PI);*/
	//a.data = a.data % (uint32)v.data;// -- doesn't seem to work !?
	//index = a.data * (COS_TABLE_SZ) / v.data;
	index = ((int32)(a) << COS_TABLE_SH) / (FPTWO_PI);
	//index /= twopi.data;
	index &= ((1<<COS_TABLE_SH)-1);
	// safety
	ASSERTF(index >= 0, "%d", index);
	ASSERTF(index < COS_TABLE_SZ, "%d", index);
	//index = min(COS_TABLE_SZ, index);
	//index = max(0, index);
	//printf("%04x\n",_fp_cos_table[index].data);
	return _fp_cos_table[index];
}

FPINLINE fpfloat fpsin(fpfloat a)
{
	//return fpcos(fpsub(FPHALF_PI, a));
	//fpfloat v = FPTWO_PI;
	myint index;
	//index = ((FPHALF_PI).data - a.data) * (COS_TABLE_SZ) / (FPTWO_PI).data;
	index = ((int32)a << (COS_TABLE_SH)) / (FPTWO_PI);
	index &= ((1<<COS_TABLE_SH)-1);
	// safety
	ASSERTF(index >= 0, "%d", index);
	ASSERTF(index < COS_TABLE_SZ, "%d", index);
	//index = min(COS_TABLE_SZ, index);
	//index = max(0, index);
	return _fp_sin_table[index];
}

// faster trigo for integer angle:
// 0 -> 0 rad; 256 -> 2PI rad
FPINLINE fpfloat fpcosB(myint a)
{
	return _fp_cos_table[a & ((1<<COS_TABLE_SH)-1)];
}

FPINLINE fpfloat fpsinB(myint a)
{
	return _fp_sin_table[a & ((1<<COS_TABLE_SH)-1)];
}

