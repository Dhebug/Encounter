// C Header File
// Created 20/08/2007; 02:27:16

#if defined(__GNU_C__) || defined(__TIGCC_ENV__)
#define _A_PACKED __attribute__ ((packed))
#else
#define _A_PACKED 
#endif

typedef union {
	struct {
	short int m:_FPM _A_PACKED;	// magnitude (integral) part
	short int f:_FPF _A_PACKED;	//fractional part
	} _A_PACKED;
	int16 data _A_PACKED;
} fpfloat _A_PACKED;
typedef int16 _fp_full_t _A_PACKED;
#define _FPSH _FPF

extern void __fp_init(void);

#define COS_TABLE_SH (8)
#define COS_TABLE_SZ (1<<COS_TABLE_SH)
// stuff the cos and sin tables together
#define COSSIN_TABLE_SZ (COS_TABLE_SZ + COS_TABLE_SZ / 4)
extern fpfloat __fp_sin_table[COSSIN_TABLE_SZ];
extern fpfloat *__fp_cos_table;

#define FPINLINE static inline

#define NO64 1



#define FPPI	((fpfloat)(_fp_full_t)(M_PI * (float)(((_fp_full_t)1) << _FPSH)))
#define FPHALF_PI	((fpfloat)(_fp_full_t)(M_PI_2 * (float)(((_fp_full_t)1) << _FPSH)))
#define FPTWO_PI	((fpfloat)(_fp_full_t)(2 * M_PI * (float)(((_fp_full_t)1) << _FPSH)))
#define FPZERO	((fpfloat){{0,0}})
#define FPONE	((fpfloat){{1,0}})


FPINLINE int fp_to_int(fpfloat f)
{
	return f.m;
}

FPINLINE fpfloat int_to_fp(int i)
{
	fpfloat f = {{i, 0}};
	return f;
}

#define fp_to_float(f) ((float)(f.data) / (float)((_fp_full_t)1 << _FPSH))
#define float_to_fp(f) ((fpfloat)(_fp_full_t)(f * (float)((_fp_full_t)1 << _FPSH)))

#define fplt(a,b)		((a).data<(b).data)
#define fple(a,b)		((a).data<=(b).data)
#define fpgt(a,b)		((a).data>(b).data)
#define fpge(a,b)		((a).data>=(b).data)
#define fpeq(a,b)		((a).data==(b).data)
#define fpne(a,b)		((a).data!=(b).data)

FPINLINE fpfloat fpadd(fpfloat a, fpfloat b)
{
	//return (fpfloat) ( (*(int32*)&a) + (*(int32*)&b) );
	a.data += b.data;
	return a;
}

FPINLINE fpfloat fpaddi(fpfloat a, int b)
{
	a.m += b;
	return (a);
}

FPINLINE fpfloat fpsub(fpfloat a, fpfloat b)
{
	a.data -= b.data;
	return a;
}

FPINLINE fpfloat fpmul(fpfloat a, fpfloat b)
{
#ifndef NO64
/*	int64 big = (int64)a.data * (int64)b.data;
	fpfloat ret;
	ret.data = big >> 16;*/
#else
	fpfloat ret;
	// it's wrong...
	ret.data = (a.data >> _FPSH/2) * (b.data >> _FPSH/2);
#endif
/*	if (big > 0)
		ret.data = big >> 16;
	else
		ret.data = -((-big) >> 16);*/
	//XXX
	return ret;
}

FPINLINE fpfloat fpdiv(fpfloat a, fpfloat b)
{
	fpfloat ret;
	int32 big;
	if (fpeq(b, FPZERO))
		return a;
	big = (((int32)a.data) << _FPSH) / (int32)b.data;
	ret.data = big;
/*	if (big > 0)
		ret.data = big >> 16;
	else
		ret.data = -((-big) >> 16);*/
	//XXX
	return ret;
}

FPINLINE fpfloat fpcos(fpfloat a)
{
	int index;
	//a.data %= v.data; // restrict to 2*pi
	/*while (fpge(a, FPTWO_PI))
		a = fpsub(a, FPTWO_PI);
	while (fplt(a, FPZERO))
		a = fpadd(a, FPTWO_PI);*/
	//a.data = a.data % (uint32)v.data;// -- doesn't seem to work !?
	//index = a.data * (COS_TABLE_SZ) / v.data;
	index = (a.data << COS_TABLE_SH) / (FPTWO_PI).data;
	index &= ((1<<COS_TABLE_SH)-1);
	// safety
	ASSERTF(index >= 0, "%d", index);
	ASSERTF(index < COS_TABLE_SZ, "%d", index);
	//index = min(COS_TABLE_SZ, index);
	//index = max(0, index);
	return __fp_cos_table[index];
}

FPINLINE fpfloat fpsin(fpfloat a)
{
	//return fpcos(fpsub(FPHALF_PI, a));
	//fpfloat v = FPTWO_PI;
	int index;
	//index = ((FPHALF_PI).data - a.data) * (COS_TABLE_SZ) / (FPTWO_PI).data;
	index = (((FPHALF_PI).data - a.data) << (COS_TABLE_SH)) / (FPTWO_PI).data;
	index &= ((1<<COS_TABLE_SH)-1);
	// safety
	ASSERTF(index >= 0, "%d", index);
	ASSERTF(index < COS_TABLE_SZ, "%d", index);
	//index = min(COS_TABLE_SZ, index);
	//index = max(0, index);
	return __fp_cos_table[index];
}

// faster trigo for integer angle:
// 0 -> 0 rad; 256 -> 2PI rad
FPINLINE fpfloat fpcosB(int a)
{
	return __fp_cos_table[a & ((1<<COS_TABLE_SH)-1)];
}

FPINLINE fpfloat fpsinB(int a)
{
	return __fp_sin_table[a & ((1<<COS_TABLE_SH)-1)];
}

