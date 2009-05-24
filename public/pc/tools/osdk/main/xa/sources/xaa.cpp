

#include <stdio.h>
 
#include "xah.h"

#include "xar.h"
#include "xa.h"
#include "xal.h"
#include "xaa.h"
#include "xat.h"

static int OperatorPriorityTable[]= 
{ 
	P_START,
	P_ADD,
	P_ADD,
	P_MULT,
	P_MULT,
	P_SHIFT,
	P_SHIFT,
	P_CMP,
    P_CMP,
	P_EQU,
	P_CMP,
	P_CMP,
	P_EQU,
	P_AND,
	P_XOR,
	P_OR,
    P_LAND,
	P_LOR 
};

static int pp;
static int pcc;
static int fundef;

static int evaluate_term(signed char*,int operator_priority,int*,int*,int*);
static int get_code_operator(signed char*,OPERATOR_e* ptr_code_operator);
static int perform_operation(int*,int,OPERATOR_e code_operator);

#define   cval(s)   256*((s)[1]&255)+((s)[0]&255)
#define   lval(s)   (65536*256)*((s)[3]&255)+65536*((s)[2]&255)+256*((s)[1]&255)+((s)[0]&255)

/* s=source string, v=value to return, l= len xpc=segment+offs, pfl=which seg, label=???, f=allow undefined refernces */

int evaluate_expression(signed char *s,int *v,int *l,int xpc,int *pfl,int *label,int f)
{
	int er=E_OK;
	int afl = 0;
	int bfl;
	
	*pfl = 0;
	fundef = f;
	
	pp=0;
	pcc=xpc;
	
	if (s[0]=='<')
	{
		pp++;
		er=evaluate_term(s,P_START,v,&afl, label);
		bfl = afl & (A_MASK>>8);
		if ( bfl && (bfl != (A_ADR>>8)) && (bfl != (A_LOW>>8)) ) 
		{
			errout(W_LOWACC);
		}
		if (afl) *pfl=A_LOW | ((afl<<8) & A_FMASK);
		*v = *v & 255;
	} 
	else
	if (s[pp]=='>')
	{    
		pp++;
		er=evaluate_term(s,P_START,v,&afl, label);
		bfl = afl & (A_MASK>>8);
		if ( bfl && (bfl != (A_ADR>>8)) && (bfl != (A_HIGH>>8)) ) 
		{
			errout(W_HIGHACC);
		}
		if (afl) *pfl=A_HIGH | ((afl<<8) & A_FMASK) | (*v & 255);
		*v=(*v>>8)&255;
	}
	else 
	if (s[pp]=='^')
	{
		pp++;
		er=evaluate_term(s,P_START,v,&afl,label);
		bfl = afl & (A_MASK>>8);
		if ( bfl && (bfl != (A_ADR>>8)) && (bfl != (A_HIGH>>8)) ) 
		{
			errout(W_HIGHACC);
		}
		if (afl) *pfl=A_MSB | ((afl<<8) & A_FMASK);
		*v=(*v>>16)&65535;
	}
	else 
	{
		er=evaluate_term(s,P_START,v,&afl, label);
		bfl = afl & (A_MASK>>8);
		if (bfl && (bfl != (A_ADR>>8)) ) 
		{
			errout(W_ADDRACC);
		}
		if (afl) *pfl = A_ADR | ((afl<<8) & A_FMASK);
	}
	
	*l=pp;
	return er;
}

static int evaluate_term(signed char *s,int operator_priority, int *v, int *nafl, int *label)
{
	int er=E_OK;
	OPERATOR_e o;
	int w;
	int mf=1;
	int afl=0;
	
	while (s[pp]=='-')
	{
		pp++;
		mf=-mf;
	}
	
	if (s[pp]=='(')
	{
		pp++;
		if (!(er=evaluate_term(s,P_START,v,&afl,label)))
		{
			if (s[pp]!=')')
				er=E_SYNTAX;
			else 
				pp++;
		}
	} 
	else
	if (s[pp]==T_LABEL)
	{
		er=l_get(cval(s+pp+1),v, &afl);
		if (er==ERR_UNDEFINED_LABEL && (segment!=eSEGMENT_ABS) && fundef ) 
		{
			if ( nolink || (afl==eSEGMENT_UNDEF)) 
			{
				er = E_OK;
				*v = 0;
				afl = eSEGMENT_UNDEF;
				*label = cval(s+pp+1);
			}
		}
		pp+=3;
	}
	else
	if (s[pp]==T_VALUE)
	{
		*v=lval(s+pp+1);
		pp+=5;
		// printf("value: v=%04x\n",*v);
	}
	else
	if (s[pp]==T_POINTER)
	{
		afl = s[pp+1];
		*v=cval(s+pp+2);
		pp+=4;
		// printf("pointer: v=%04x, afl=%04x\n",*v,afl);
	}
	else
	if (s[pp]=='*')
	{
		*v=pcc;
		pp++;
		afl = segment;
	}
	else
	{
		er=E_SYNTAX;
	}
					
	*v *= mf;
	
	while (!er && s[pp]!=')' && s[pp]!=']' && s[pp]!=',' && s[pp]!=T_END)
	{
		er=get_code_operator(s,&o);
		
		if (!er && OperatorPriorityTable[o]>operator_priority)
		{
			// New operator has higher priority that previous one
			pp+=1;
			if (!(er=evaluate_term(s,OperatorPriorityTable[o],&w, nafl, label)))
			{
				if (afl || *nafl) 
				{	
					// check pointer arithmetic 
					if ((afl == *nafl) && (afl!=eSEGMENT_UNDEF) && o==eOPERATOR_SUBTRACT) 
					{
						// subtract two pointers 
						afl = 0; 	
					} 
					else 
					if (((afl && !*nafl) || (*nafl && !afl)) && o==eOPERATOR_ADD) 
					{
						// add constant to pointer
						afl=(afl | *nafl);  
					} 
					else 
					if ((afl && !*nafl) && o==eOPERATOR_SUBTRACT) 
					{
						// subtract constant from pointer
						afl=(afl | *nafl);  
					} 
					else 
					{
						if (segment!=eSEGMENT_ABS) 
						{ 
							if (!gDsbLen)
							{
								er=E_ILLPOINTER;
							}
						}
						afl=0;
					}
				}
				
				if (!er) 
				{
					er=perform_operation(v,w,o);
				}
			}
		} 
		else 
		{
			// Lower level priority operation
			break;
		}
	}
	*nafl = afl;
	return er;
}


static int get_code_operator(signed char *s,OPERATOR_e *ptr_code_operator)
{
     int er;

	 OPERATOR_e code_operator=(OPERATOR_e)(s[pp]);

     if ( (code_operator<=eOPERATOR_NONE) || (code_operator>=_eOPERATOR_MAX_) )
          er=E_SYNTAX;
     else
          er=E_OK;

	 *ptr_code_operator=code_operator;
     return er;
}
    
     
static int perform_operation(int *w,int w2,OPERATOR_e code_operator)
{
     int er=E_OK;
     switch (code_operator) 
	 {
     case eOPERATOR_ADD:
          *w +=w2;
          break;

     case eOPERATOR_SUBTRACT:
          *w -=w2;
          break;

     case eOPERATOR_MULTIPLY:
          *w *=w2;
          break;

     case eOPERATOR_DIVIDE:
          if (w!=0)
               *w /=w2;
          else
               er =E_DIV;
          break;

     case eOPERATOR_SHIFTRIGHT:
          *w >>=w2;
          break;

     case eOPERATOR_SHIFTLEFT:
          *w <<=w2;
          break;

     case eOPERATOR_INFERIOR:
          *w = *w<w2;
          break;

     case eOPERATOR_SUPERIOR:
          *w = *w>w2;
          break;
     case eOPERATOR_EQUAL:
          *w = *w==w2;
          break;

     case eOPERATOR_INFERIOR_OR_EQUAL:
          *w = *w<=w2;
          break;

     case eOPERATOR_SUPERIOR_OR_EQUAL:
          *w = *w>=w2;
          break;

     case eOPERATOR_DIFFERENT:
          *w = *w!=w2;
          break;

     case eOPERATOR_BINARY_AND:
          *w &=w2;
          break;

     case eOPERATOR_XOR:
          *w ^=w2;
          break;

     case eOPERATOR_BINARY_OR:
          *w |=w2;
          break;

     case eOPERATOR_LOGICAL_AND:
          *w =*w&&w2;
          break;

     case eOPERATOR_LOGICAL_OR:
          *w =*w||w2;
          break;
     }
     return er;
}

