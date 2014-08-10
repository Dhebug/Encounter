/* string.h */

#ifndef _STRING_

#define _STRING_


/* Copy s2 to s1, return s1 */

extern char *strcpy(char *s1,char *s2);


/* Use malloc() to allocate enough memory for the given string. Copy the */
/* string to the new memory block, and return a pointer to that block.   */

extern char *strdup(char *s);


/* Compare two strings. */

   /* Returns: <0  if s1<s2,  */
   /*          ==0 if s1==s2, */
   /*          >0  if s1>s2,  */

extern int strcmp(char *s1,char * s2);

#define strcoll strcmp


/* Return the length of the string s. */

   /* The terminating null does not count. */

extern int strlen(char *s);


/* Copy s2 to s1, return s1+strlen(s2) */

extern char *stpcpy(char *s1,char *s2);


/* s1 becomes the concatenation of s1 and s2. s1 is returned. */

extern char *strcat(char *s1,char *s2);


/* Returns a pointer to the first occurence of the character c in the
   string s. If c does not occur in s, NULL is returned. */

extern char *strchr(char *s,char c);


/* Returns a pointer to the last occurence of the character c in the
   string s. If c does not occur in s, NULL is returned. */

extern char *strrchr(char *s,char c);


/* Compares two strings in a case-insensitive manner. */

   /* Returns: <0  if s1<s2,  */
   /*          ==0 if s1==s2, */
   /*          >0  if s1>s2,  */

extern int *strcmpi(char *s1,char *s2);


/* stricmp is exactly the same as strcmpi */

#define stricmp strcmpi


/* Returns the index of (NOT pointer to) the first character of s1 which
   also appears in s2. If s1 contains none of the characters in s2,
   strlen(s1) is returned. This will point to the terminating null '\0'
   of s1. */

extern int strcspn(char *s1,char *s2);


/* Returns the index of (NOT pointer to) the first character of s1 that
   does NOT appear in s2. If s1 only contains characters that occur in
   s2, strlen(s1) is returned. */

extern int strspn(char *s1,char *s2);


/* Same as strcspn() above, but returns a pointer instead of an
   index. */

extern char *strpbrk(char *s1, char *s2);


/* Use _tolower(c) to convert s to lower case. Returns s. */

extern char *strlwr(char *s);


/* Use _toupper(c) to convert s to upper case. Returns s. */

extern char *strupr(char *s);


/* Reverses s, and returns it. For example, strrev("ORIC") returns
   "CIRO" */

extern char *strrev(char *s);


/* Fills a string s with a given character c, returns s. */

extern char *strset(char *s, char c);


/* Finds the first occurence of the substring needle in the string
   haystack. Returns a pointer to the substring inside the string, or
   NULL if the substring does not occur in the string. */

extern char *strstr(char *haystack, char *needle);


/* This function splits a string into 'tokens' separated by any of the
   delimiters specified in delim. The first call to strtok should be of
   the form strtok(string_to_parse, ", \n"). This will replace the first
   occurence of either ",", " ", or "\n" (newline) with a terminating
   null '\0', and return the first token of the line.

   Subsequent calls should be like this: strtok(NULL, ", \n"). In this
   case (assuming you have not destroyed the string you pointed to
   previously), the next token will be returned. Returned tokens are
   always null terminated and never contain any of the characters
   specified in delim.

   If no more tokens can be found, NULL is returned. See the example
   programs (strings.s) for an sample of exactly how this works. */

extern char *strtok(char *s, char *delim);


/* Append n characters from s2 to s1, null-terminate the resultant
   string, and return s1 (the new string). */

extern char *strncat(char *s1, char *s2, int n);


/* Same as strcmp(), but only the first n characters are compared. */

extern int strncmp(char *s1, char *s2, int n);


/* Copies n characters from s2 onto s1. CAUTION: the terminating null
   '\0' will NOT get copied if it is not within the first n characters
   of s2. strncpy() returns the new string s1. This function is used
   to make sure we don't copy too many characters onto a string buffer. */

extern char *strncpy(char *s1, char *s2, int n);


/* Same as strcmpi (or stricmp), but only compares the first n
   characters. */

extern char *strncmpi(char *s1, char *s2, int n);


/* Same as strncmpi. */

#define strnicmp strncmpi


/* Same as strnset, but fills the first n characters of s with c. If
   n>strlen(s), only the characters up to the terminating null '\0'
   are set. */

extern char *strnset(char *s, char c, int n);


/* Store the character c (only the low order byte will be used) in the
   first count bytes of the buffer. Return a pointer to the buffer. */

extern void *memset(void *buffer, int c, int count);

#endif /* _STRING_ */

/* end of file string.h */

