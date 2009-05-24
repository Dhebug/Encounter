 
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <vector>
#include <map>

#include "xah.h"
#include "xah2.h"

#include "xar.h"
#include "xa.h"
#include "xam.h"
#include "xal.h"
#include "xat.h"
#include "xap.h"




#define hashcode(n,l)  (n[0]&0x0f)|(((l-1)?(n[1]&0x0f):0)<<4)

#define VALBEF    6


static char *Preprocessor_CommandList[]=
{ 
	"echo",
	"include",
	"define",
	"undef",
	"printdef",
	"print",
	"ifdef",
	"ifndef",
	"else",
	"endif",
	"ifldef",
	"iflused",
	"if",
	"file"
};



PreprocessorFile_c PreprocessorFile_c::FileList[MAXFILE+1];
PreprocessorFile_c *PreprocessorFile_c::CurrentFile=0;
int       		   PreprocessorFile_c::CurrentFileNum=0;

char 					BufferLine[MAXLINE];

Preprocessor			gPreprocessor;



// This function is called with a pointer on the first character of the 
// preprocessor directive, minus the starting # symbol
int Preprocessor::HandleCommand(char *ptr_preprocessor_directive)
{
	int er=1;
	int command_id=CheckForPreprocessorCommand(ptr_preprocessor_directive);
	if (command_id>=0)
	{
		//
		// We found a valid preprocessor command
		//
		if (command_id==e_command_define)
		{
			// Break area
			command_id=e_command_define;
		}
		
		if (m_LogicalOpcodesStack && (command_id<VALBEF))
		{
			er=0;
		}
		else
		{
			int directive_lenght=(int)strlen(Preprocessor_CommandList[command_id]);
			while (isspace(ptr_preprocessor_directive[directive_lenght])) directive_lenght++;

			switch (command_id)
			{
			case e_command_echo:	// 0
				er=command_echo(ptr_preprocessor_directive+directive_lenght);
				break;
			case e_command_include:	// 1
				er=command_include(ptr_preprocessor_directive+directive_lenght);
				break;
			case e_command_define:	// 2
				er=command_define(ptr_preprocessor_directive+directive_lenght);
				break;
			case e_command_undef:	// 3
				er=command_undef(ptr_preprocessor_directive+directive_lenght);
				break;
			case e_command_prdef:	// 4
				er=command_prdef(ptr_preprocessor_directive+directive_lenght);
				break;
			case e_command_print:	// 5
				er=command_print(ptr_preprocessor_directive+directive_lenght);
				break;
			case e_command_ifdef:	// 6
				er=command_ifdef(ptr_preprocessor_directive+directive_lenght);
				break;
			case e_command_ifndef:	// 7
				er=command_ifndef(ptr_preprocessor_directive+directive_lenght);
				break;
			case e_command_else:	// 8
				er=command_else(ptr_preprocessor_directive+directive_lenght);
				break;
			case e_command_endif:	// 9
				er=command_endif(ptr_preprocessor_directive+directive_lenght);
				break;
			case e_command_ifldef:	// 10
				er=command_ifldef(ptr_preprocessor_directive+directive_lenght);
				break;
			case e_command_iflused:	// 11
				er=command_iflused(ptr_preprocessor_directive+directive_lenght);
				break;
			case e_command_if:		// 12
				er=command_if(ptr_preprocessor_directive+directive_lenght);
				break;
			case e_command_file:	// 13
				er=command_file(ptr_preprocessor_directive+directive_lenght);
				break;
			default:
				break;
			}			
		}
	}
	return er;
}

int Preprocessor::command_ifdef(char *t)
{
     m_LogicalOpcodesStack=(m_LogicalOpcodesStack<<1)+( suchdef(t) ? 0 : 1 );
     return E_OK;
}

int Preprocessor::command_ifndef(char *t)
{
     m_LogicalOpcodesStack=(m_LogicalOpcodesStack<<1)+( suchdef(t) ? 1 : 0 );
     return E_OK;
}

int Preprocessor::command_ifldef(char *t)
{
	m_LogicalOpcodesStack=(m_LogicalOpcodesStack<<1)+( ll_pdef(t) ? 1 : 0 );
	return E_OK;
}

int Preprocessor::command_iflused(char *t)
{
	int n;

	m_LogicalOpcodesStack=(m_LogicalOpcodesStack<<1)+( LabelTableLookUp(t,&n) ? 1 : 0 );
	return E_OK;
}

int Preprocessor::command_echo(char *t)
{
	int er;
	
	if ((er=pp_replace(BufferLine,t,-1,m_CurrentListIndex)))
	{
		errout(er);
	}
	else
	{
		logout(BufferLine);
		logout("\n");
	}
	return E_OK;
}

int Preprocessor::command_print(char *t)
{
	int f,a,er;
	
	logout(t);
	if ((er=pp_replace(BufferLine,t,-1,m_CurrentListIndex)))
	{
		logout("\n");
		errout(er);
	}
	else
	{
		logout("=");
		logout(BufferLine);
		logout("=");
		er=b_term(BufferLine,&a,&f,TablePcSegment[segment]);
		if (er)
		{
			logout("\n");
			errout(er);
		}
		else
		{ 
			sprintf(BufferLine,"%d\n",a); 
			logout(BufferLine); 
		}
	}
	
	return E_OK;
}

int Preprocessor::command_if(char *t)
{
	int a,f,l,er;
	
	if ((er=pp_replace(BufferLine,t,-1,m_CurrentListIndex)))
	{
		errout(er);
	}
	else
	{
		gDsbLen = 1;
		f=b_term(BufferLine,&a,&l,TablePcSegment[segment]);
		gDsbLen = 0;
		
		if ((!m_LogicalOpcodesStack) && f)     
		{
			errout(f);
		}
		else
		{
			m_LogicalOpcodesStack=(m_LogicalOpcodesStack<<1)+( a ? 0 : 1 );
		}
	}
	return E_OK;
}

int Preprocessor::command_else(char *t)
{
     m_LogicalOpcodesStack ^=1;
     return E_OK;
}

int Preprocessor::command_endif(char *t)
{
     m_LogicalOpcodesStack=m_LogicalOpcodesStack>>1;
     return E_OK;
}

/* pp_undef is a great hack to get it working fast... */
int Preprocessor::command_undef(char *t) 
{
#ifdef PROCESSOR_USES_MAP
	std::map<std::string,List>::iterator it=gPreprocessor_ReplaceMap.find(t);
	if (it!=gPreprocessor_ReplaceMap.end())
	{
		gPreprocessor_ReplaceMap.erase(it);
	}
#else
	int i;

	if ((i=suchdef(t))) 
	{
		i+=m_CurrentListIndex;
		gListArray[i].search_length=0;
	}
#endif
	return E_OK;
}

int Preprocessor::command_prdef(char *t)
{
#ifdef PROCESSOR_USES_MAP
	std::map<std::string,List>::iterator it=gPreprocessor_ReplaceMap.find(t);
	if (it!=gPreprocessor_ReplaceMap.end())
	{
		const List& entry=it->second;

		sprintf(BufferLine,"\n%s",entry.m_search.c_str());
		if (!entry.m_parameters.empty())
		{
			sprintf(BufferLine+strlen(BufferLine),"(");
			for (unsigned int j=0;j<entry.m_parameters.size();j++)
			{
				sprintf(BufferLine+strlen(BufferLine),"%s%c",entry.m_parameters[j],(j==entry.m_parameters.size()-1) ? ',' : ')');
			}
		}
		sprintf(BufferLine+strlen(BufferLine),"=%s\n",entry.m_replace.c_str());
		logout(BufferLine);
	}
#else
	char *x;
	int i,j;
	
	if ((i=suchdef(t)))
	{
		i+=m_CurrentListIndex;
		x=gListArray[i].search;
		sprintf(BufferLine,"\n%s",x);
		if (gListArray[i].parameters)
		{
			sprintf(BufferLine+strlen(BufferLine),"(");
			for (j=0;j<gListArray[i].parameters;j++)
			{
				x+=strlen(x)+1;
				sprintf(BufferLine+strlen(BufferLine),"%s%c",x,(gListArray[i].parameters-j-1) ? ',' : ')');
			}
		}
		sprintf(BufferLine+strlen(BufferLine),"=%s\n",gListArray[i].replace);
		logout(BufferLine);
	}
#endif
	return E_OK;
}




int Preprocessor::suchdef(char *t)
{
#ifdef PROCESSOR_USES_MAP
	std::map<std::string,List>::iterator it=gPreprocessor_ReplaceMap.find(t);
	if (it!=gPreprocessor_ReplaceMap.end())
	{
		return 1;
	}
	return 0;
#else
     int i=0,j,k,l=0;

     while(t[l]!=' ' && t[l]!=0) l++;

     if (m_CurrentListIndex)
     {
       i=hashindex[hashcode(t,l)];
     
       do   /*for(i=0;i<m_CurrentListIndex;i++)*/
       {
          k=gListArray[i].search_length;
          j=0;

          if(k && (k==l))
          {
               while((t[j]==gListArray[i].search[j])&&j<k) j++;
               if(j==k)
                    break;
          }
          
          if (!i)
          {
               i=m_CurrentListIndex;
               break;
          }
          
          i=gListArray[i].nextindex;
               
       } 
	   while (1);
     }     
     return i-m_CurrentListIndex;
#endif
}

    
int Preprocessor::command_define(char *k)
{
#ifdef PROCESSOR_USES_MAP
	//std::map<std::string,List>::iterator it=gPreprocessor_ReplaceMap.find(t);

	List entry;

	int i;
	unsigned int j;

	char *t=k;

	for(i=0; (t[i]!=' ') && (t[i]!=0) && (t[i]!='(') ;i++)
	{
		entry.m_search+=t[i];
	}

	if (t[i]=='(')
	{
		while (t[i]!=')' && t[i]!=0)
		{
			i++;
			
			for(j=0; t[i+j]!=')' && t[i+j]!=',' && t[i+j]!=0;j++);

			std::string parameter(t+i,j);
			entry.m_parameters.push_back(parameter);
			
			i+=j;
		}
		if(t[i]==')')
			i++;
	}
	while(t[i]==' ')
	{
		i++;
	}
	t+=i;

	char h[MAXLINE*2];
	pp_replace(h,t,-1,0);

	t=h;     

	entry.m_replace=t;

	gPreprocessor_ReplaceMap[entry.m_search]=entry;

	return E_OK;

#else
	int er=E_OK;
	int i,hash,rl;
	char h[MAXLINE*2],*t;
	unsigned int j;
	
	t=k;
	
	if(m_CurrentListIndex>=ANZDEF || m_FreeMemory<MAXLINE*2)
		return E_OUT_OF_MEMORY;
/*
     printf("define:mem=%04lx\n",m_CurrentBufferPtr);
     getchar();
*/   
     rl=m_CurrentListIndex++;
     
     gListArray[rl].search=m_CurrentBufferPtr;
     for(i=0; (t[i]!=' ') && (t[i]!=0) && (t[i]!='(') ;i++)
	 {
		 *m_CurrentBufferPtr++=t[i];
	 }
     *m_CurrentBufferPtr++=0;
     m_FreeMemory-=i+1;
     gListArray[rl].search_length=i;
     gListArray[rl].parameters=0;
	 gListArray[rl].replace=0;
	 gListArray[rl].nextindex=0;


/*   printf("define:%s\nlen1=%d\n",gListArray[rl].search,gListArray[rl].search_length);
     getchar();
*/

     if(t[i]=='(')
     {
          while(t[i]!=')' && t[i]!=0)
          {
               i++;
               gListArray[rl].parameters++;
               for(j=0; t[i+j]!=')' && t[i+j]!=',' && t[i+j]!=0;j++);
               if(j<m_FreeMemory)
               {
                    strncpy(m_CurrentBufferPtr,t+i,j);
                    m_CurrentBufferPtr+=j;
                    *m_CurrentBufferPtr++=0;
                    m_FreeMemory-=j+1;
               }
               i+=j;
          }
          if(t[i]==')')
               i++;
     }
     while(t[i]==' ')
          i++;
     t+=i;
     
     pp_replace(h,t,-1,0);

     t=h;     

     gListArray[rl].replace=m_CurrentBufferPtr;
     strcpy(m_CurrentBufferPtr,t);
     m_CurrentBufferPtr+=strlen(t)+1;
     if(!er)
     {
          hash=hashcode(gListArray[rl].search,gListArray[rl].search_length);
          gListArray[rl].nextindex=hashindex[hash];
          hashindex[hash]=rl;
     } 
	 else
	 {
          m_CurrentListIndex=rl;
	 }
     
     return er;
#endif
}


int Preprocessor::CheckForPreprocessorCommand(char s[])
{
	int i,j,l;
	static char t[MAXLINE];
	
	for(i=0; s[i]!=0; i++)
	{
		t[i]=tolower(s[i]);
	}
	t[i]=0;
	
	for(i=0;i<_e_command_max_;i++)
	{
		l=(int)strlen(Preprocessor_CommandList[i]);
		
		for(j=0;j<l;j++)
		{
			if(t[j]!=Preprocessor_CommandList[i][j])
			{
				break;
			}
		}
		if(j==l)
		{
			break;
		}
	}
	return (i==_e_command_max_)? -1 : i;
}

int Preprocessor::pp_replace(char *ptr_output,char *ptr_input,int a,int b)
{
#ifdef PROCESSOR_USES_MAP
	/*
	std::map<std::string,List>::iterator it=gPreprocessor_ReplaceMap.find(t);
	if (it!=gPreprocessor_ReplaceMap.end())
	{
		gPreprocessor_ReplaceMap.erase(it);
	}  
	*/
     char *t=ptr_output;
	 char c,*x,*y,*mx,*rs;
     int i,l,n,sl,d,ld;
	 int er=E_OK;
	 int bFlagInQuotedString;
	 int ParenthesisCounter;
     char fti[MAXLINE],fto[MAXLINE];

     strcpy(t,ptr_input);

     if (gPreprocessor_ReplaceMap.empty())
     {
		 return E_OK;
	 }

	 // Get the first token
       while (t[0]!=0)
       {
          while(!isalpha(t[0]) && t[0]!='_')
		  {
               if(t[0]==0)
			   {
                    break;    /*return E_OK;*/
			   }
               else
               {
                    t++;
                    ptr_input++;
               }
		  }
         
          for(l=0;isalnum(t[l])||t[l]=='_';l++);
          ld=l;

          if(a<0)
          {
			  std::map<std::string,List>::iterator it=gPreprocessor_ReplaceMap.find(t);
			  if (it!=gPreprocessor_ReplaceMap.end())
			  {
				const List& entry=it->second;

				sl=entry.m_search.size();

                         rs=gListArray[n].replace;
                         
                         if(gListArray[n].parameters)        
                         {
                              strcpy(fti,gListArray[n].replace);

                              if (m_CurrentListIndex+gListArray[n].parameters>=ANZDEF || m_FreeMemory<MAXLINE*2)
                                   er=E_OUT_OF_MEMORY;
                              else
                              {
                                   y=t+sl;
                                   x=gListArray[n].search+sl+1;
                                   if(*y!='(')
                                        er=E_SYNTAX;
                                   else
                                   {
                                        mx=m_CurrentBufferPtr-1;
                                        for(i=0;i<gListArray[n].parameters;i++)
                                        {
                                             gListArray[m_CurrentListIndex+i].search=x;
                                             gListArray[m_CurrentListIndex+i].search_length=(int)strlen(x);
                                             x+=strlen(x)+1;
                                             gListArray[m_CurrentListIndex+i].parameters=0;
                                             gListArray[m_CurrentListIndex+i].replace=mx+1;
                                             c=*(++mx)=*(++y);
                                             bFlagInQuotedString=ParenthesisCounter=0;
                                             while (c!=0 
                                                  && ((bFlagInQuotedString!=0 
                                                       || ParenthesisCounter!=0) 
                                                       || (c!=',' 
                                                       && c!=')') 
                                                       )
                                                  )
                                             {
                                                  if (c=='\"')
                                                       bFlagInQuotedString^=1;

                                                  if (!bFlagInQuotedString)
                                                  {
                                                       if(c=='(')
                                                            ParenthesisCounter++;

                                                       if(c==')')
                                                            ParenthesisCounter--;
                                                  }     
                                                  c=*(++mx)=*(++y);
                                             }
                                             *mx=0;

                                             if(c!=((i==gListArray[n].parameters-1) ? ')' : ','))
                                             {
                                                  er=E_PARENTHESIS_MISMATCH;
                                                  break;
                                             }
                                        }   
                                        if(!er)
                                             er=pp_replace(fto,fti,m_CurrentListIndex,m_CurrentListIndex+i);
                                        sl=(int)((long)y+1L-(long)t);
                                        rs=fto;
                                   }    
                              }
                              if(er)
                                   return er;
                         }

                         d=(int)strlen(rs)-sl;

                         if(strlen(ptr_output)+d>=MAXLINE)
                              return E_OUT_OF_MEMORY;

                          strcpy(t+sl+d,ptr_input+sl);

                         i=0;
                         while((c=rs[i]))
                              t[i++]=c;
                         l=sl+d;/*=0;*/
                         break;
                    }
               }
               if(!n)
                    break;
                    
               n=gListArray[n].nextindex;
               
            } 
			while(1);
          } 
		  else
          {
            for(n=b-1;n>=a;n--)
            {
               sl=gListArray[n].search_length;
          
               if(sl && (sl==l))
               {
                    i=0;
                    x=gListArray[n].search;
                    while(t[i]==*x++ && t[i])
                         i++;

                    if(i==sl)
                    {     
                         rs=gListArray[n].replace;
                         d=(int)strlen(rs)-sl;

                         if (strlen(ptr_output)+d>=MAXLINE)
                              return E_OUT_OF_MEMORY;
                         if(d)
                              strcpy(t+sl+d,ptr_input+sl);
                              
                         i=0;
                         while((c=rs[i]))
                              t[i++]=c;
                         l+=d;/*0;*/
                         break;
                    }
               }
            }
          }
          ptr_input+=ld;
          t+=l;
       }
     }
     return E_OK;

#else

     char *t=ptr_output;
	 int er=E_OK;

     strcpy(t,ptr_input);

     if (m_CurrentListIndex)
     {
	   // For each token in the input string
	   // (Token being defined as a valid symbol containing only letters and underscores)
       while (t[0]!=0)
       {
          while(!isalpha(t[0]) && t[0]!='_')
               if(t[0]==0)
                    break;    /*return E_OK;*/
               else
               {
                    t++;
                    ptr_input++;
               }
         
	      int l;
          for(l=0;isalnum(t[l])||t[l]=='_';l++);
          int ld=l;

          if (a<0)
          {
       	    char fto[MAXLINE];

            int n=hashindex[hashcode(t,l)];
            
            do      
            {
               int sl=gListArray[n].search_length;
          
               if(sl && (sl==l))
               {
				   // Same length, check each character
                    int i=0;
                    char* x=gListArray[n].search;
                    while(t[i]==*x++ && t[i])
                         i++;

                    if(i==sl)
                    {     
						// Found a match
                         char* rs=gListArray[n].replace;
                         
                         if(gListArray[n].parameters)        
                         {
							  char fti[MAXLINE];
                              strcpy(fti,gListArray[n].replace);

                              if (m_CurrentListIndex+gListArray[n].parameters>=ANZDEF || m_FreeMemory<MAXLINE*2)
                                   er=E_OUT_OF_MEMORY;
                              else
                              {
                                   char* y=t+sl;
                                   x=gListArray[n].search+sl+1;
                                   if(*y!='(')
                                        er=E_SYNTAX;
                                   else
                                   {
                                        char* mx=m_CurrentBufferPtr-1;
                                        for(i=0;i<gListArray[n].parameters;i++)
                                        {
                                             gListArray[m_CurrentListIndex+i].search=x;
                                             gListArray[m_CurrentListIndex+i].search_length=(int)strlen(x);
                                             x+=strlen(x)+1;
                                             gListArray[m_CurrentListIndex+i].parameters=0;
                                             gListArray[m_CurrentListIndex+i].replace=mx+1;
                                             char c=*(++mx)=*(++y);

											 int ParenthesisCounter=0;
											 int bFlagInQuotedString=0;
                                             
                                             while (c!=0 
                                                  && ((bFlagInQuotedString!=0 
                                                       || ParenthesisCounter!=0) 
                                                       || (c!=',' 
                                                       && c!=')') 
                                                       )
                                                  )
                                             {
                                                  if (c=='\"')
                                                       bFlagInQuotedString^=1;

                                                  if (!bFlagInQuotedString)
                                                  {
                                                       if(c=='(')
                                                            ParenthesisCounter++;

                                                       if(c==')')
                                                            ParenthesisCounter--;
                                                  }     
                                                  c=*(++mx)=*(++y);
                                             }
                                             *mx=0;

                                             if(c!=((i==gListArray[n].parameters-1) ? ')' : ','))
                                             {
                                                  er=E_PARENTHESIS_MISMATCH;
                                                  break;
                                             }
                                        }   
                                        if(!er)
                                             er=pp_replace(fto,fti,m_CurrentListIndex,m_CurrentListIndex+i);
                                        sl=(int)((long)y+1L-(long)t);
                                        rs=fto;
                                   }    
                              }
                              if(er)
                                   return er;
                         }

                         int d=(int)strlen(rs)-sl;

                         if(strlen(ptr_output)+d>=MAXLINE)
                              return E_OUT_OF_MEMORY;

                          strcpy(t+sl+d,ptr_input+sl);

                         i=0;
						 char c;
                         while((c=rs[i]))
                              t[i++]=c;
                         l=sl+d;/*=0;*/
                         break;
                    }
               }
               if(!n)
                    break;
                    
               n=gListArray[n].nextindex;
               
            } 
			while(1);
          } 
		  else
          {
            for (int n=b-1;n>=a;n--)
            {
               int sl=gListArray[n].search_length;
          
               if(sl && (sl==l))
               {
                    int i=0;
                    char* x=gListArray[n].search;
                    while(t[i]==*x++ && t[i])
                         i++;

                    if(i==sl)
                    {     
                         char* rs=gListArray[n].replace;
                         int d=(int)strlen(rs)-sl;

                         if (strlen(ptr_output)+d>=MAXLINE)
                              return E_OUT_OF_MEMORY;
                         if (d)
                              strcpy(t+sl+d,ptr_input+sl);
                              
                         i=0;
						 char c;
                         while((c=rs[i]))
                              t[i++]=c;
                         l+=d;/*0;*/
                         break;
                    }
               }
            }
          }
          ptr_input+=ld;
          t+=l;
       }
     }
     return E_OK;
#endif
}


int Preprocessor::Init(void)
{
	int er;
	
	for (er=0;er<256;er++)
	{
		hashindex[er]=0;
	}
	
	PreprocessorFile_c::CurrentFileNum=0;
	PreprocessorFile_c::CurrentFile=PreprocessorFile_c::FileList;
	
	er=0;
	m_CurrentBufferPtr=(char*)malloc(MAX_PREPROCESSOR_BUFFER_SIZE);
	if (!m_CurrentBufferPtr) 
	{
		er=E_OUT_OF_MEMORY;
	}
	
	m_FreeMemory=MAX_PREPROCESSOR_BUFFER_SIZE;
	m_CurrentListIndex=0;
	m_FlagNewLineFound=true;
	m_FlagNewFileFound=true;
	if (!er) 
	{
		gListArray=(List*)malloc((long)ANZDEF*sizeof(List));
		if (!gListArray) 
		{
			er=E_OUT_OF_MEMORY;
		}
	}
	return er;
}


void Preprocessor::Close(void)
{
	if (PreprocessorFile_c::CurrentFile->m_block_depth != b_depth()) 
	{
		fprintf(stderr, "Blocks not consistent in file %s: start depth=%d, end depth=%d\n",PreprocessorFile_c::CurrentFile->m_file_name.c_str(), PreprocessorFile_c::CurrentFile->m_block_depth, b_depth());
	}
	fclose(PreprocessorFile_c::CurrentFile->m_pfile_handle);
}

void Preprocessor::Terminate(void) 
{ 
}


int icl_close(int *c)
{
	if (!PreprocessorFile_c::CurrentFileNum)	return E_EOF;
	
	if (PreprocessorFile_c::CurrentFile->m_block_depth != b_depth()) 
	{
		fprintf(stderr, "Blocks not consistent in file %s: start depth=%d, end depth=%d\n",PreprocessorFile_c::CurrentFile->m_file_name.c_str(),PreprocessorFile_c::CurrentFile->m_block_depth, b_depth());
	}
	
	fclose(PreprocessorFile_c::CurrentFile->m_pfile_handle);

	PreprocessorFile_c::CurrentFileNum--;
	PreprocessorFile_c::CurrentFile--;

	gPreprocessor.m_FlagNewFileFound=true;
	*c='\n';
	
	return E_OK;
}


int Preprocessor::command_include(char *ptr_included_filename)
{
	pp_replace(BufferLine,ptr_included_filename,-1,m_CurrentListIndex);
	
	if (PreprocessorFile_c::CurrentFileNum>=MAXFILE)
	{
		return -1;
	}
	
	// Locate starting quotes or < symbols around the filename
	int		j,i=0;
	if (BufferLine[i]=='<' || BufferLine[i]=='"')
	{
		i++;
	}
	
	// Then do the same for closing ones
	for (j=i;BufferLine[j];j++)
	{
		if (BufferLine[j]=='>' || BufferLine[j]=='"')
		{
			BufferLine[j]=0;
		}
	}
	
	// And open the file !
	FILE *file_handle=xfopen(BufferLine+i,"r");
	if (!file_handle)
	{
		// For some reason the file could not be opened.
		// This leads to the #include directive to fail
		return ERR_FILE_NOT_FOUND;
	}
	
	setvbuf(file_handle,NULL,_IOFBF,BUFSIZE);
	
	// We have now one more file in the stack
	PreprocessorFile_c::AddFile(BufferLine+i,file_handle,b_depth());

	m_FlagNewFileFound=true;
	
	return 0;
}

// tmp\linked.s -o build\final.out -e build\xaerr.txt -l build\symbols -bt $600
// C:\osdk\tmp\linked.s -o C:\osdk\tmp\final.out -e C:\osdk\tmp\xaerr.txt -l C:\osdk\tmp\symbols -bt $600
int Preprocessor::command_file(char *tt)
{
	int		j,i=0;
	
	pp_replace(BufferLine,tt,-1,m_CurrentListIndex);
	
	if (PreprocessorFile_c::CurrentFileNum>=MAXFILE)
	{
		return -1;
	}
	
	if (BufferLine[i]=='<' || BufferLine[i]=='"')
	{
		i++;
	}
	
	for (j=i;BufferLine[j];j++)
	{
		if (BufferLine[j]=='>' || BufferLine[j]=='"')
		{
			BufferLine[j]=0;
		}
	}
		
	PreprocessorFile_c::CurrentFile->m_file_name=BufferLine+i;
	PreprocessorFile_c::CurrentFile->m_current_line=0;

	// To force the assembler to take these parameters into consideration...
	// ...else we will have correct error messages during pass 1, but not during pass 2 !!!
	m_FlagNewLineFound=true;
	m_FlagNewFileFound=true;

	/*
	PreprocessorFile_c::CurrentFile->bdepth=b_depth();
	PreprocessorFile_c::CurrentFile->m_p_line_buffer=NULL;
	m_FlagNewFileFound=true;
	*/
	return E_OK;
}



int Preprocessor::GetLine(char *ptr_destination_line)
{
	int c,er=E_OK;
	int read_lenght;
	int total_line_lenght;
	
	m_LogicalOpcodesStack =0;
	
	m_CurrentFile=PreprocessorFile_c::CurrentFile;
	
	do 
	{
		// Extract from the buffer a complete line
		c=PreprocessorFile_c::CurrentFile->GetLine(m_BufferLine, MAXLINE, &read_lenght);

		// continuation lines
		total_line_lenght = read_lenght;
		while (c=='\n' && total_line_lenght && m_BufferLine[total_line_lenght-1]=='\\') 
		{
			c=PreprocessorFile_c::CurrentFile->GetLine(m_BufferLine + total_line_lenght-1,MAXLINE-total_line_lenght,&read_lenght);
			total_line_lenght += read_lenght-1;
		}

		if (m_BufferLine[0]=='#')
		{
			//
			// If first character of the line is a '#', we have to
			// call the preprocessor command interpretor.
			//
			if ((er=Preprocessor::HandleCommand(m_BufferLine+1)))
			{
				if (er!=1)
				{
					logout(m_BufferLine);
					logout("\n");
				}
			}
		} 
		else
		{
			er=1;
		}
		
		if(c==EOF)
		{
			er=icl_close(&c);
		}
		
	} 
	while (!er || (m_LogicalOpcodesStack && er!=E_EOF));
	
	if (!er || m_LogicalOpcodesStack)
	{
		m_BufferLine[0]=0;
	}
	
	er= (er==1) ? E_OK : er ;
	
	bool doIt=true;
	while (!er && doIt)
	{
		doIt=false;
		er=pp_replace(ptr_destination_line,m_BufferLine,-1,m_CurrentListIndex);	
		if (!er)
		{
			// We do a hack to force multiple levels of token resolution...
			// Hope it will not generate horrible side effects
			if (strcmp(ptr_destination_line,m_BufferLine)!=0)
			{
				strcpy(m_BufferLine,ptr_destination_line);
				doIt=true;
			}
		}
	}
	if (!er && m_FlagNewFileFound)		er=E_NEWFILE;
	if (!er && m_FlagNewLineFound)		er=E_NEWLINE;

	m_FlagNewLineFound=false;
	m_FlagNewFileFound=false;
	
	m_CurrentFile=PreprocessorFile_c::CurrentFile;
	m_CurrentFile->m_p_line_buffer=m_BufferLine;
	
	return er;
}







// -----------------------------------------------------------------------------
//
//                            PreprocessorFile_c
//
// -----------------------------------------------------------------------------


// Returns the next character from the file, taking care of counting lines,
// skipping illegal characters and C style bloc comments.
// Warning: Having a file that contains stuff like //****** will fail badly.
// I need to handle C++ likecomments in this function... crap
int PreprocessorFile_c::ReadNextFilteredCharacter()
{
	int c;
	int flag_in_c_bloc_comment=0;
	
	do
	{
		// Skip ^M codes
		while ((c=getc(m_pfile_handle))==13);
		
		// Check for end of C style bloc comment
		if (flag_in_c_bloc_comment && (c=='*'))
		{
			int temp_car=getc(m_pfile_handle);
			if (temp_car!='/')
			{
				ungetc(temp_car,m_pfile_handle);
			}
			else
			{
				flag_in_c_bloc_comment--;
				// Skip ^M codes
				while ((c=getc(m_pfile_handle))==13);
			}
		}
		
		if (c=='\n')
		{
			PreprocessorFile_c::CurrentFile->m_current_line++;
			gPreprocessor.m_FlagNewLineFound=true;
		} 
		else
		if (c=='/')
		{
			// Check for beginning of C style bloc comment
			int temp_car=getc(m_pfile_handle);
			if (temp_car!='*')
			{
                ungetc(temp_car,m_pfile_handle);
			}
			else
			{
                flag_in_c_bloc_comment++;
			}
		}			
	} 
	while (flag_in_c_bloc_comment && (c!=EOF));
	
	if (c=='\t')
	{
		// Replace tabs by spaces.
		c=' ';
	}
	
	return c;
}

int PreprocessorFile_c::GetLine(char *ptr_destination_line,int max_buffer_size,int *returned_lenght)
{
	int c,i;
	
	i=0;
	
	do 
	{
		c=ReadNextFilteredCharacter();
		
		if (c==EOF || c=='\n')
		{
			ptr_destination_line[i]=0;
			break;
		}
		ptr_destination_line[i]=c;
		i= (i<max_buffer_size-1) ? i+1 : max_buffer_size-1;
	} 
	while (1);
	*returned_lenght = i;
	return c;
}



