
#ifndef XAH2_H
#define XAH2_H

#include  <string.h>

#include "xam.h"

class PreprocessorFile_c
{
public:
	PreprocessorFile_c()
	{
		m_current_line=0;
		m_block_depth=0;
		m_pfile_handle=0;
		m_p_line_buffer=0;
	}


	int ReadNextFilteredCharacter();
	int GetLine(char *ptr_destination_line,int max_buffer_size,int *returned_lenght);

	//
	// Static methods
	//
	static int Open(const char *file_name,int block_depth)
	{
		CurrentFile->m_file_name=file_name;
		CurrentFile->m_current_line=0;
		CurrentFile->m_block_depth=block_depth;
		CurrentFile->m_pfile_handle=xfopen(file_name,"rt");
		CurrentFile->m_p_line_buffer=NULL;    
		
		return (((long)CurrentFile->m_pfile_handle)==0l);
	}

	static void AddFile(const char* file_name,FILE* pHandle,int block_depth)
	{
		// We have now one more file in the stack
		CurrentFileNum++;
		CurrentFile++;
		
		// Store data for this new file
		CurrentFile->m_file_name=file_name;
		CurrentFile->m_current_line=0;
		CurrentFile->m_block_depth=block_depth;
		CurrentFile->m_p_line_buffer=NULL;
		CurrentFile->m_pfile_handle=pHandle;
	}

	static PreprocessorFile_c *GetCurrentFile() 
	{
		return CurrentFile;
	}

public:
	std::string	m_file_name;
	int		m_current_line;
	int		m_block_depth;
	FILE	*m_pfile_handle;
	char	*m_p_line_buffer;

	//
	// Static methods
	//
	static PreprocessorFile_c FileList[MAXFILE+1];
	static PreprocessorFile_c *CurrentFile;
	static int       		  CurrentFileNum;
};

#endif

