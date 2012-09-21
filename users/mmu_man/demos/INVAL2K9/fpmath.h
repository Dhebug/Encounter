#ifndef _FPMATH_H
#define _FPMATH_H
// C Header File
// Created 19/08/2007; 18:32:28

// for PI and wrappers
#include "math.h"

#ifndef M_PI
// TiGCC can't even have a standard math.h :-(
#define M_PI PI
#define M_PI_2 HALF_PI
#endif

#ifdef NOFPMATH
// for testing purposes
typedef float fpfloat;
#define _fp_init() 
#define fp_to_int(f) ((int)(f))
#define int_to_fp(f) ((float)(f))
#define fp_to_float(f) ((float)(f))
#define float_to_fp(f) ((float)(f))
#define fplt(a,b)		((a)<(b))
#define fple(a,b)		((a)<=(b))
#define fpgt(a,b)		((a)>(b))
#define fpge(a,b)		((a)>=(b))
#define fpeq(a,b)		((a)==(b))
#define fpne(a,b)		((a)!=(b))
#define fpadd(a,b)	((a)+(b))
#define fpsub(a,b)	((a)-(b))
#define fpmul(a,b)	((a)*(b))
#define fpdiv(a,b)	((a)/(b))
#define fppow(a,b)	(pow(a,b))
#define fpsqrt(a)	(sqrt(a))
#define fpsin(a)	(sin(a))
#define fpcos(a)	(cos(a))
#define FPPI	M_PI
#define FPHALF_PI	M_PI_2
#define FPTWO_PI	(2*M_PI)
#define FPZERO	0.0
#define FPONE	1.0

#else /* !NOFPMATH */

#ifdef FPMATH_8_8
# include "fpmath_8_8.h"
#else /* FPMATH_8_8 */
# ifdef FPMATH_CUST_16
#  include "fpmath_c16.h"
# else
#  include "fpmath_16_16.h"
# endif /* FPMATH_CUST_16 */
#endif /* FPMATH_8_8 */

#endif /* NOFPMATH */

#endif /* _FPMATH_H */