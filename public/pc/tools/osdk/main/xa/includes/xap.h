

extern char BufferLine[MAXLINE];



//#define PROCESSOR_USES_MAP

#ifdef PROCESSOR_USES_MAP

class List
{
public:
	std::string					m_search;
	std::string					m_replace;
	std::vector<std::string>	m_parameters;
};

#else

struct List
{
	char *search;
	int  search_length;
	char *replace;
	int  parameters;
	int  nextindex;
};

#endif




class Preprocessor
{
public:

	enum 
	{
		e_command_echo,	// 0
		e_command_include,	// 1
		e_command_define,	// 2
		e_command_undef,	// 3
		e_command_prdef,	// 4
		e_command_print,	// 5
		e_command_ifdef,	// 6
		e_command_ifndef,	// 7
		e_command_else,	// 8
		e_command_endif,	// 9
		e_command_ifldef,	// 10
		e_command_iflused,	// 11
		e_command_if,		// 12
		e_command_file,	// 13
		_e_command_max_
	};


public:
	int Init(void);
	void Close(void);
	void Terminate(void);

	ErrorCode GetLine(char *t);

	int suchdef(char *t);
	int CheckForPreprocessorCommand(char s[]);

	ErrorCode pp_replace(char *ptr_output,char *ptr_input,int a,int b);
	ErrorCode HandleCommand(char *ptr_preprocessor_directive);

	ErrorCode command_define(char *k);
	ErrorCode command_include(char*);
	ErrorCode command_ifdef(char*);
	ErrorCode command_ifndef(char*);
	ErrorCode command_else(char*);
	ErrorCode command_endif(char*);
	ErrorCode command_echo(char*);
	ErrorCode command_if(char*);
	ErrorCode command_print(char*);
	ErrorCode command_prdef(char*);
	ErrorCode command_ifldef(char*);
	ErrorCode command_iflused(char*);
	ErrorCode command_undef(char*);
	ErrorCode command_file(char*);

	int ga_pp(void)
	{
		return m_CurrentListIndex;
	}

	int gm_pp(void)
	{
		return ANZDEF;
	}

	long gm_ppm(void)
	{
		return MAX_PREPROCESSOR_BUFFER_SIZE;
	}

	long ga_ppm(void)
	{
		return MAX_PREPROCESSOR_BUFFER_SIZE-m_FreeMemory;
	}

public:
#ifdef PROCESSOR_USES_MAP
	std::map<std::string,List>	gPreprocessor_ReplaceMap;
#else
	List 	     		*gListArray;
	int 				hashindex[256];
	unsigned int		m_CurrentListIndex;
	unsigned long 		m_FreeMemory;
#endif
	char 				*m_CurrentBufferPtr;
	PreprocessorFile_c	*m_CurrentFile;
	bool				m_FlagNewLineFound;
	bool				m_FlagNewFileFound;
	int       			m_LogicalOpcodesStack;	//!< Contains one bit for each level of #if / #ifdef ...encountered during preprocessing
	char      			m_BufferLine[MAXLINE];
};


extern Preprocessor		gPreprocessor;

