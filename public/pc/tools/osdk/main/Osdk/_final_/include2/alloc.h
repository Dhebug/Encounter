/* alloc.h */

#ifndef _ALLOC_

#define _ALLOC_

/* This header file has a horrible amount of comments. Sorry about this --
   memory allocation is a tricky job, and I want to make sure everything
   is clear (to me, mostly). Oh, it will also help new users get accustomed to
   some of the most heavily used C library functions (at least on larger
   systems -- not much call for malloc(1<<20) on an Oric!). :-)   - Alexios */


/* Heap manager variables */


/* stacksize is the size of the C (*NOT* the CPU) stack. This is an upward
   stack which starts at the point where program code ends (endcode label).
   You can change this variable _BEFORE_ the heap is initialised (i.e.
   before the first call to heapinit() or malloc(), or immediately after a call
   to freall(). Its default value is 512 bytes. If you do not use heap
   functions, you need not worry about this. */

extern unsigned int stacksize;


/* heapovh is the size in bytes of the memory block descriptor (MBD), which
   precedes (in RAM) all malloc()ed memory blocks. The ABSOLUTE MINIMUM
   (and default) is 4 bytes (a pointer to the next block, and the length of the
   block). It may be changed by the user or for later expansion (swapping to
   floppy, etc.). Be sure to change it _BEFORE_ any calls to heapinit() or
   malloc(), or immediately after a call to freall(). */

extern unsigned char heapovh;


/* heapstart points to the beginning of the heap in memory. This is initialised
   automatically by heapinit() (which is executed by malloc() the first time
   malloc() is called). There is usually no need to change this. Please note,
   this is the beginning of the HEAP. The first MBD may or may not be there.
   See heapdesc. */

extern unsigned int heapstart;


/* heapend points to the end of the heap + 1. That is, it points to the first
   byte in memory which should NOT be allocated to the heap. The default value
   is 0xb400 (the character table for the TEXT mode). If you plan to use HIRES
   with memory allocation, you should assign 0x9800 to heapend. You can change
   it any time you like, but, if you do so AFTER the first call to malloc() or
   heapinit(), be sure to call heapupdate if you want heapsize and coreleft to
   return the right results. */

extern unsigned int heapend;


/* heapdesc simply points to the first MBD in the heap. It contains NULL
   (0x0000) if the heap contains no memory block descriptors. */

extern unsigned int heapdesc;


/* nheapdesc is the number of memory blocks allocated in the heap. DO NOT
   CHANGE THIS VARIABLE, unless you particularly like broken statistics (it
   will not interfere with the correct operation of the memory (de)allocation
   functions). */

extern unsigned int nheapdesc;


/* nheapbytes is the number of bytes allocated in the heap. This includes the
   MBDs. For example, if heapovh=4 and you've allocated three blocks with sizes
   256, 300 and 1024 respectively, nheapbytes will be equal to 4+256 + 4+300 +
   4+1024 = 1592 bytes. DO NOT CHANGE THIS VARIABLE, unless you particularly
   like broken statistics (it will not interfere with the correct operation of
   the memory (de)allocation functions). */

extern unsigned int nheapbytes;


/* heapsize is calculated by heapinit() or heapupdate(). It contains the result
   of the expression heapend-heapstart. */

extern unsigned int heapsize;




/* Prototypes for memory allocation functions follow. */


/* Initialise the heap. Call heapupdate() as well. You DO NOT need to call this
   function explicitly: malloc() invokes it when first called. */

extern void heapinit();


/* Recalculates heapsize to account for run-time changes in heapstart or
   heapend. */

extern void heapupdate();


/* Allocates a block of size bytes and initialises all bytes to zero. Returns a
   pointer to the memory block. If the block cannot be allocated, NULL is
   returned. */

#define zalloc(size) (memset(malloc(size),0x00,size)


/* Allocates a block able to accommodate an array of num_elems elements, each
   of which is elem_size bytes long. All bytes in the memory block are
   initialised to zero. Returns a pointer to the newly allocated memory block.
   If the block cannot be allocated, NULL is returned. */

#define calloc(num_elems,elem_size) (zalloc((num_elems)*(elem_size)))


/* This is the main allocation function. It allocates a memory block of
   num_bytes bytes, and returns a pointer to the block. If the block cannot be
   allocated (too fragmented heap or too little memory), NULL is returned. */

extern void *malloc(unsigned int num_bytes);


/* free() deallocates the memory block pointed to by p, which is the value
   returned by malloc() when the memory block was allocated. Nothing will
   happen if the pointer does not point to a valid and existing memory block.
   */

extern void free(void *p);


/* freeall is a macro which marks all the heap as deallocated. The next
   call to malloc() will re-initialise the heap and start over. */

#define freeall (heapstart=heapdesc=nheapdesc=nheapbytes=0)


/* coreleft returns the free heap memory in bytes. */

#define coreleft (heapsize-nheapbytes)


/* this is the basic structure of an MBD. */

typedef struct memdesc {
     struct memdesc *next;      /* pointer to the next MBD in memory.    */
     unsigned int   len;        /* length of this memory block + heapovh */
} memdesc;


/* Traverses through all MBDs. The first call to heapwalk should be
   heapwalk(NULL). This returns the first MBD in memory (the actual memory
   block starts heapovh bytes after the MBD). Feeding back this result to
   heapwalk() will return the next MBD and so on. NULL will be returned if
   there are no more MBDs. Example:

   {
        memdesc *m=NULL;
        int i=0;

        while((m=heapwalk(m))!=NULL){
                printf("Block %d starts at 0x%x. Length: %d\n",
                        i++,
                        (unsigned int)m+heapovh,
                        m->len-heapovh);
        }
   }

   */

#define heapwalk(current) ((current)==NULL?(memdesc*)heapdesc:(current)->next)


/* Dynamically changes the size of a memory block mem_address, from its current
   size to newsize bytes. Returns a pointer to the new memory block. The
   pointer returned may or may not differ from mem_address, but realloc
   guarrantees the first min(current_size,newsize) bytes have the same values
   as the corresponding bytes in the old block (it will invoke memcpy() to copy
   bytes to the new block, if necessary).

   Calling realloc() with a mem_address of NULL is the same as calling
   malloc(newsize). Calling realloc() with newsize==0 is the same as calling
   free(mem_address).
   */

extern void *realloc(void *mem_address, unsigned int newsize);

#endif /* _ALLOC_ */

/* end of file alloc.h */

