/* ctype.h */

#ifndef _CTYPE_

#define _CTYPE_


/* Check if c is alphabetic. */

   /* Returns 1 if yes, 0 if no. */

extern int isalpha(char c);


/* Check if c is an upper case character. */

extern int isupper(char c);


/* Check if c is a lower case character. */

extern int islower(char c);


/* Check if c is a decimal digit. */

extern int isdigit(char c);


/* Check if c is a white space character. */

extern int isspace(char c);


/* Check if c is a character used in punctuation. */

extern int ispunct(char c);


/* Check if c is a printable ASCII character.*/

extern int isprint(char c);


/* Check if c is an ASCII control character. */

extern int iscntrl(char c);


/* Check if c is an ASCII character. */

extern int isascii(char c);


/* Return c converted to upper case. */

extern char toupper(char c);


/* Return c converted to lower case. */

extern char tolower(char c);


/* Return c with the 8th bit stripped off. */

extern char toascii(char c);


#endif /* _CTYPE_

/* end of file ctype.h */

