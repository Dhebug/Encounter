/*;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ------------------------------------------
;;                 OASIS
;; Oric Adventure Script Interpreting System
;; ------------------------------------------
;;	       (c) Chema 2015
;;            enguita@gmail.com
;; ------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;*/

/* Resource managing */

/* Each resource is stored in memory with the    	*/
/* following header:					*/
/* 1 byte: Type (bits 0 to 3). 			 	*/
/*         Lock: (bit 7) 				*/
/*         Reference count (bit 4-6)			*/
/* 2 byte: size						*/ 
/* Lock bit to 1 means do not delete from memory	*/
/* Reference count 0 means resource has been nuked,	*/
/* therefore the chunk could be reasigned, but		*/
/* if the resource is loaded again before this		*/
/* it is enough to make it active again.		*/

#define RESOURCE_HEADER_SIZE		3

/* ID starting for local resources */
#define RESOURCE_LOCALS_START		200

/* Each resource has a subheader which starts with 	*/
/* 1 byte indicating the resource ID and resource	*/
/* type-dependant additional fields			*/
  
/* Types of resources (bits 0-3) */

#define RESOURCE_NULL		0
#define RESOURCE_SCRIPT		1
#define RESOURCE_ROOM		2
#define RESOURCE_COSTUME	3
#define RESOURCE_STRING		4
#define RESOURCE_OBJECT		5
#define RESOURCE_OBJECTCODE	6
#define RESOURCE_MUSIC		7
#define RESOURCE_SFX		8
#define RESOURCE_DIALOG		9	

