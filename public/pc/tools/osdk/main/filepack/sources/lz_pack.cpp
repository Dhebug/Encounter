

#include <stdio.h>
#include <stdlib.h>
#include <memory.h>



#define max(a,b)	((a)>(b)?(a):(b))



// ne doit jamais depasser 16 les deux !!!
//4
#define _LZ77_NB_BIT_SIZE	4
#define _LZ77_NB_BIT_OFFSET	12
#define _LZ77_MAX_SIZE	  	(1<<_LZ77_NB_BIT_SIZE)			//  1<<4      -> 16
#define _LZ77_MAX_OFFSET	((1<<_LZ77_NB_BIT_OFFSET)+1)	//  1<<12		-> 4096+1 = 4097
#define	_LZ77_ROOT			(_LZ77_MAX_OFFSET)

#define	_LZ77_SEARCH_SIZE	(_LZ77_MAX_SIZE+1)


typedef struct
{
	short	smaller_child;
	short	larger_child;
	short	parent;
	short	branch;				// par quel branche du parent est il venue
}LZ77_TREE;


LZ77_TREE	BigTree[_LZ77_MAX_OFFSET+2];

unsigned char gLZ77_XorMask=0;

long LZ77_Compress(void* buf_src_void,void *buf_dest_void,long size_buf_src)
{
	unsigned char *buf_src =(unsigned char*)buf_src_void;
	unsigned char *buf_dest=(unsigned char*)buf_dest_void;
	LZ77_TREE	*tree,*real_tree,*current_tree,*del_tree;

	unsigned char	*ptr_decoding_mask;
	unsigned char	*ptr_search_src;

	unsigned char	andvalue;

	long			nb_rec;
	long			size;
	long			delta_value;
	long			offset_src;

	short			i,k;
	short			best_match;
	short			best_node;
	short			current_node;
	short			num_tree;
	short			search_index;
	short			branch_value;



	real_tree=BigTree;

	// ruse pour eviter les test kan les child sont … -1
	// mon tableau commence … +1 donc ce ki sera patch‚ en 0
	// rien … faire !!
	tree=real_tree+1;


	// init tree
	memset(tree,-1,(_LZ77_MAX_OFFSET+1)*sizeof(LZ77_TREE));

	offset_src=0;

	nb_rec=1;

	size=0;
	andvalue=0;

	while (offset_src+nb_rec-1<size_buf_src)
	{
		//
		// Reload encoding type mask
		//
		if (!andvalue)
		{
			andvalue=1;

			ptr_decoding_mask=buf_dest++;
			*ptr_decoding_mask=0;			// No match
			size++;
		}

		// delete string de 'num_index'
		// en recherchant ds tree celui ki a 'num_index+last advance'
		while (nb_rec>0)
		{
			i=(short)(offset_src % _LZ77_MAX_OFFSET);
			num_tree=i;
			current_tree=&tree[i];

			if (current_tree->parent>=0)
			{
				// supprime ca
				if ( (current_tree->smaller_child<0) || (current_tree->larger_child<0) )
				{ // facile a faire
					branch_value=current_tree->larger_child;
					if (branch_value>=0)
					{
						tree[branch_value].parent=current_tree->parent;
						tree[branch_value].branch=current_tree->branch;
					}
					else 
					{
						branch_value=current_tree->smaller_child;
						if (branch_value>=0)
						{
							tree[branch_value].parent=current_tree->parent;
							tree[branch_value].branch=current_tree->branch;
						}
						else // no child
						{
							branch_value=-1;
						}
					}
				}
				else
				{

					// supprime noeud ki a 2 fils
					// d'ou ruse :
					// au choix rechercher le plus grand du fils 'larger'
					// ou recherche le plus grand du fils 'smaller'
					// de toute facon ca revient au meme.... ( ce qui est logique d'ailleur)

					branch_value=current_tree->smaller_child;
					del_tree=&tree[branch_value];

					if (del_tree->larger_child<0)
						current_tree->smaller_child=del_tree->smaller_child;
					else
					{
						while (del_tree->larger_child>=0)
						{
							branch_value=del_tree->larger_child;
							del_tree=&tree[branch_value];
						}

						// supprime del
						tree[del_tree->parent].larger_child=del_tree->smaller_child;
					}

					tree[del_tree->smaller_child].parent=del_tree->parent;
					tree[del_tree->smaller_child].branch=del_tree->branch;

					//remplacement
					del_tree->smaller_child=current_tree->smaller_child;
					del_tree->larger_child =current_tree->larger_child;

					tree[del_tree->smaller_child].parent=branch_value;
					tree[del_tree->larger_child].parent =branch_value;

					del_tree->parent=current_tree->parent;
					del_tree->branch=current_tree->branch;
				}

				// update chez parent de i
				if (!current_tree->branch)	tree[current_tree->parent].smaller_child=branch_value;
				else						tree[current_tree->parent].larger_child =branch_value;
			}

			current_tree->larger_child =-1;
			current_tree->smaller_child=-1;

			// donc on va ecrire ds tree[numtree]
			current_node=tree[_LZ77_ROOT].smaller_child;	// init with root


			if (current_node<0) // remplis racine de l'arbre...
			{
				tree[num_tree].parent=_LZ77_ROOT;
				tree[num_tree].branch=0; 		// weil immer smaller branch for root
				tree[_LZ77_ROOT].smaller_child=num_tree;
				best_match=0;
			}
			else
			{
				best_match=2;
				best_node=0;
				while (1)
				{
					i=num_tree-current_node; // offset
					if (i<0)	i+=(_LZ77_MAX_OFFSET);

					//k= _SearchSequence(src-i,src,_LZ77_MAX_SIZE+2);

					ptr_search_src=buf_src-i;

					search_index=0;
					while (ptr_search_src[search_index] == buf_src[search_index])
					{
						if (search_index==_LZ77_SEARCH_SIZE)	break;
						search_index++;
					}

					delta_value=ptr_search_src[search_index] - buf_src[search_index];
					//k=_LZ77_SEARCH_SIZE-search_index;	   // 17-


					if ( (search_index==_LZ77_SEARCH_SIZE) && (!delta_value) )
					{ 
						//
						// 1) On a trouvé une chaine de la taille maximale
						// possible pour l'encoding...
						// On stocke cette entrée, et on se casse.
						// On ne trouvera jamais mieux !
						//
						tree[num_tree]=tree[current_node];

						// on s'occupe du parent
						if (!tree[num_tree].branch)		tree[tree[num_tree].parent].smaller_child=num_tree;
						else							tree[tree[num_tree].parent].larger_child =num_tree;

						// et des fils
						tree[tree[num_tree].smaller_child].parent=num_tree;
						tree[tree[num_tree].larger_child].parent =num_tree;

						// on efface l'ancien noeud proprement...
						tree[current_node].parent=-1;

						best_match=_LZ77_MAX_SIZE+2;	// 18 octets à copier=maximum possible avec l'encodage 4:12
						best_node =current_node;
						break;
					}
					else
					{
						//
						// 2) On a pas trouvé une chaine de taille maximale
						//
						k=_LZ77_SEARCH_SIZE-(_LZ77_SEARCH_SIZE-search_index);
						if (k>best_match)
						{
							best_match=k;
							best_node=current_node;
						}

						if (delta_value>=0)
						{	// suivre larger
							k=tree[current_node].larger_child;
							if (k<0)
							{
								tree[num_tree].parent			=current_node;
								tree[current_node].larger_child	=num_tree;
								tree[num_tree].branch			=-1; 		// comming from larger
								break;
							}
							else	current_node=k;

						}
						else // suivre smaller
						{
							k=tree[current_node].smaller_child;
							if (k<0)
							{
								tree[num_tree].parent			=current_node;
								tree[current_node].smaller_child=num_tree;
								tree[num_tree].branch			=0; 		// comming from smaller
								break;
							}
							else	current_node=k;
						}
					}

				}
			}

			nb_rec--;
			if (nb_rec>0)
			{
				buf_src++;
				offset_src++;
			}
		}

		// bindage de taille
		if (size>=size_buf_src-2)
		{
			return -1;
		}

		nb_rec=best_match;
		//value>>=1;
		if ( (nb_rec>2) && (offset_src+nb_rec<=size_buf_src) ) // 2 match 0 bits win ....
		{ 
			unsigned int	value_short;

			//
			// Copy with offset
			//
			i=(offset_src % (_LZ77_MAX_OFFSET))-best_node;
			if (i<0)	i+=(_LZ77_MAX_OFFSET);

			value_short=((nb_rec-3)<<(16-_LZ77_NB_BIT_SIZE)) | (i-1);

			*buf_dest++=(unsigned char)(value_short & 255);
			*buf_dest++=(unsigned char)(value_short>>8);
			size+=2;
			if (gLZ77_XorMask)	*ptr_decoding_mask|=andvalue;
		}
		else
		{
			//
			// Just put the byte, without compression
			// and put '1' in the encoding mask
			//
			if (!gLZ77_XorMask)	*ptr_decoding_mask|=andvalue;

			*buf_dest++=*buf_src;
			size++;

			nb_rec=1;
		}

		offset_src++;
		buf_src++;

		andvalue<<=1;
	}
	return size;
	//return ((size+3)&(~3));
}


void LZ77_UnCompress(void* buf_src_void,void* buf_dest_void, long size)
{
	unsigned char *buf_src =(unsigned char*)buf_src_void;
	unsigned char *buf_dest=(unsigned char*)buf_dest_void;

	unsigned char	value;
	unsigned char	andvalue;
	long	offset,nb;

	andvalue=0;
	while (size>0)
	{
		//
		// Reload encoding type mask
		//
		if (!andvalue)
		{
			andvalue=1;
			value=(*buf_src++);
		}
		if ((value^gLZ77_XorMask) & andvalue)
		{ 
			//
			// Copy 1 unsigned char
			//
			*buf_dest++=*buf_src++;
			size--;
		}
		else
		{
			//
			// Copy with offset
			//
			// At this point, the source pointer points to a two byte
			// value that actually contains a 4 bits counter, and a 
			// 12 bit offset to point back into the depacked stream.
			// The counter is in the 4 high order bits.
			//
			offset = buf_src[0];			// Read 16 bits non alligned datas...
			offset|=(buf_src[1]&0x0F)<<8;
			offset+=1;
			
			nb	   =(buf_src[1]>>4)+3;

			buf_src+=2;

			size-=nb;
			while (nb>0)
			{
				*buf_dest++=*(buf_dest-offset);
				nb--;
			}
		}
		andvalue<<=1;
	}
}




long LZ77_ComputeDelta(unsigned char *buf_comp,long size_uncomp,long size_comp)
{
	unsigned char	value;
	unsigned char	andvalue;
	long	offset,nb;
	long	offset_comp;
	long	offset_uncomp;
	long	max_delta_space;


	offset_comp=size_uncomp-size_comp;
	offset_uncomp=0;
	max_delta_space=0;

	andvalue=0;
	while (size_uncomp>0)
	{
		//
		// Reload encoding type mask
		//
		if (!andvalue)
		{
			andvalue=1;
			value=*buf_comp++;
			offset_comp++;
		}
		if (value & andvalue)
		{ 
			//
			// Copy 1 unsigned char
			//
			buf_comp++;
			offset_uncomp++;
			if (offset_comp<=offset_uncomp)
			{
				max_delta_space=max(offset_uncomp-offset_comp+1,max_delta_space);
			}
			offset_comp++;
			size_uncomp--;
		}
		else
		{
			//
			// Copy with offset
			//
			offset =*buf_comp++; // Read 16 bits non alligned datas...
			offset|=(*buf_comp++)<<8;

			nb=(offset & (0xff >> (8-_LZ77_NB_BIT_SIZE)) )+2+1;
			offset=((offset>>_LZ77_NB_BIT_SIZE) & (0xffff >> (16-_LZ77_NB_BIT_OFFSET)))  +1;

			size_uncomp-=nb;
			offset_uncomp+=nb;
			if (offset_comp<=offset_uncomp)
			{
				max_delta_space=max(offset_uncomp-offset_comp+1,max_delta_space);
			}
			offset_comp+=2;

		}
		andvalue<<=1;
	}
	return((max_delta_space+3)&(~3)); // padd to four.
}


