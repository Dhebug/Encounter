/* some useful constants */

#define	M_E		2.7182818284590452354	/* e */
#define	M_LOG2E		1.4426950408889634074	/* log 2e */
#define	M_LOG10E	0.43429448190325182765	/* log 10e */
#define	M_LN2		0.69314718055994530942	/* log e2 */
#define	M_LN10		2.30258509299404568402	/* log e10 */
#define	M_PI		3.14159265358979323846	/* pi */
#define	M_PI_2		1.57079632679489661923	/* pi/2 */
#define	M_PI_4		0.78539816339744830962	/* pi/4 */
#define	M_1_PI		0.31830988618379067154	/* 1/pi */
#define	M_2_PI		0.63661977236758134308	/* 2/pi */
#define	M_2_SQRTPI	1.12837916709551257390	/* 2/sqrt(pi) */
#define	M_SQRT2		1.41421356237309504880	/* sqrt(2) */
#define	M_SQRT1_2	0.70710678118654752440	/* 1/sqrt(2) */

/* trigonometric functions */

double atn(double x);
double cos(double x);
double sin(double x);
double tan(double x);

/* logarithmic functions */

double exp(double x);
double log(double x);
double log10(double x);

/* power functions */

double pow(double x,double y);  /* x to the power y */
double sqrt(double x);

/* extract integral and fractional parts : fractional part of x is return as 
      result while integral part is stored in the variable whose address is
	given as second argument */

double modf(double x, double *iptr);

/* absolute value */

double fabs(double x);

/* compute a polynomial using Horner's scheme */
/* Note: this is not a standard call at all... but this can be used to
        compute missing functions at machine code speed on the Oric */
/* coefficients must be stored starting with the highest degree, e.g:

        double coef[]={ 1.0/120, 1.0/24, 1.0/6, 1.0/2, 1.0, 1.0 };
        double r = horner( x, 5, coef);

        will compute x^5/120 + x^4/24 + x^3/6 + x^2/2 + x + 1
*/

double horner(double x, int degree, double coefficients[]);
