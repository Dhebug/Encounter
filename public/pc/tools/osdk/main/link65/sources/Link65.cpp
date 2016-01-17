/*

The 6502 Linker, for the lcc or similar, that produce .s files to be processed later by a cross assembler
(See infos.h for details and version history)

*/



#include "infos.h"

#define _GNU_SOURCE 1 /* for fcloseall() */
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <memory.h>
#include <ctype.h>

#ifndef POSIX
#include <direct.h>
#else
#include <unistd.h>
#include <limits.h>
#define stricmp strcasecmp
#define _MAX_PATH PATH_MAX
// From https://groups.google.com/forum/#!topic/gnu.gcc.help/0dKxhmV4voE
void _splitpath(const char* Path,char* Drive,char* Directory,char*
                Filename,char* Extension)
{
  char* CopyOfPath = (char*) Path;
  int Counter = 0;
  int Last = 0;
  int Rest = 0;

  // no drives available in linux .
  // extensions are not common in linux
  // but considered anyway
  Drive = NULL;

  while(*CopyOfPath != '\0')
  {
    // search for the last slash
    while(*CopyOfPath != '/' && *CopyOfPath != '\0')
    {
      CopyOfPath++;
      Counter++;
    }
    if(*CopyOfPath == '/')
    {
      CopyOfPath++;
      Counter++;
      Last = Counter;
    }
    else
      Rest = Counter - Last;
  }
  // directory is the first part of the path until the
  // last slash appears
  strncpy(Directory,Path,Last);
  // strncpy doesnt add a '\0'
  Directory[Last] = '\0';
  // Filename is the part behind the last slahs
  strcpy(Filename,CopyOfPath -= Rest);
  // get extension if there is any
  while(*Filename != '\0')
  {
    // the part behind the point is called extension in windows systems
    // at least that is what i thought apperantly the '.' is used as part
    // of the extension too .
    if(*Filename == '.')
    {
      while(*Filename != '\0')
      {
        *Extension = *Filename;
        Extension++;
        Filename++;
      }
    }
    if(*Filename != '\0')
    {Filename++;}
  }
  *Extension = '\0';
  return;
}

// Abstract:   Make a path out of its parts
// Parameters: Path: Object to be made
//             Drive: Logical drive , only for compatibility , notconsidered
//             Directory: Directory part of path
//             Filename: File part of path
//             Extension: Extension part of path (includes the leading point)
// Returns:    Path is changed
// Comment:    Note that the concept of an extension is not available in Linux,
//             nevertheless it is considered

void _makepath(char* Path,const char* Drive,const char* Directory,
               const char* File,const char* Extension)
{
  while(*Drive != '\0' && Drive != NULL)
  {
    *Path = *Drive;
    Path++;
    Drive++;
  }
  while(*Directory != '\0' && Directory != NULL)
  {
    *Path = *Directory;
    Path ++;
    Directory ++;
  }
  while(*File != '\0' && File != NULL)
  {
    *Path = *File;
    Path ++;
    File ++;
  }
  while(*Extension != '\0' && Extension != NULL)
  {
    *Path = *Extension;
    Path ++;
    Extension ++;
  }
  *Path = '\0';
  return;
}

// Abstract:   Change the current working directory
// Parameters: Directory: The Directory which should be the workingdirectory.
// Returns:    0 for success , other for error
// Comment:    The command doesnt fork() , thus the directory is changed for
//             The actual process and not for a forked one which would betrue
//             for system("cd DIR");

int _chdir(const char* Directory)
{
  chdir(Directory);
  return 0;
}
#endif


#include "common.h"

// Disable the warning C4706 -> assignment within conditional expression
// Allow us to use Warning level 4 instead of level 3
#pragma warning( disable : 4706)
#pragma warning( disable : 4786)	// Debug symbols thing

#include <vector>
#include <string>
#include <set>
#include <cctype>

#define NB_ARG	2


#define MAX_LINE_SIZE	4096	// XA is limited to 2048



// Structure for labels in a pair of : label_name/resolved_flag
struct ReferencedLabelEntry_c
{
  bool		m_bIsResolved;
  std::string label_name;
};

// Lib index structure in pair of : label_name/file_containing_label
struct LabelEntry_c
{
  std::string label_name;
  std::string file_name;
};

class FileEntry_c
{
public:
  FileEntry_c() :
    m_nSortPriority(0)
  {}

public:
  std::string	m_cFileName;
  int			m_nSortPriority;
};


bool gFlagKeepComments=false;			// Use -C option to control
bool gFlagIncludeHeader=true;			// Use -B option to force to 0
bool gFlagEnableFileDirective=false;	// Use -F option to enable (force to one)
bool gFlagVerbose=false;				// Use -V option to enable
bool gFlagQuiet=false;					// Use -Q option to enable (note: seems to work the other way arround !)
bool gFlagLibrarian=false;				// Use -L option to enable

char *label;




// gInputFileList contains filenames to be linked.
// nflist is 1 for file given in command line or 0 for files given from lib file index, 2 for tail. It's used for sort...
std::vector<FileEntry_c>			gInputFileList;
std::vector<LabelEntry_c>			gLibraryReferencesList;
std::vector<ReferencedLabelEntry_c>	gReferencedLabelsList;
std::set<std::string>				gDefinedLabelsList;


//
// Some pre-declarations...
//
bool ParseFile(const std::string& filename);



std::string FilterLine(const std::string& cSourceLine)
{
  static bool flag_in_comment_bloc=false;			// Used by the parser to know that we are currently parsing a bloc of comments

  std::string outline;
  outline.reserve(MAX_LINE_SIZE);

  const char* source_line=cSourceLine.c_str();
  while (char car=*source_line++)
  {
    if (flag_in_comment_bloc)						// In a C block comment - that one may have been started on another line
    {
      if ( (car=='*') && (*source_line=='/') )
      {
        // Found end of C block comment
        source_line++;
        flag_in_comment_bloc=false;
      }
    }
    else
    {
      if (car=='\"')
      {
        // Found start of quoted string
        do
        {
          outline+=car;
          car=*source_line++;
        }
        while (car && (car!='\"'));
        if (car)
        {
          outline+=car;
        }
      }
      else
        if (car==';')
        {
          // Found start of assembler line comment - just stop here
          return outline;
        }
        else
          if ( (car=='/') && (*source_line=='*') )
          {
            // Found start of C block comment
            source_line++;
            flag_in_comment_bloc=true;
          }
          else
            if ( (car=='/') && (*source_line=='/') )
            {
              // Found start of C++ line comment - just stop here
              return outline;
            }
            else
            {
              // Any other character
              outline+=car;
            }
    }
  }
  return outline;
}

#if 0
std::string FilterLine(const std::string& cSourceLine)
{
  static bool flag_in_comment_bloc=false;			// Used by the parser to know that we are currently parsing a bloc of comments

  char inpline[MAX_LINE_SIZE+1];
  assert(sizeof(inpline)>cSourceLine.size());
  strcpy(inpline,cSourceLine.c_str());

  //
  // Checking for a end of C bloc comment
  //
  if (flag_in_comment_bloc)
  {
    char *ptr_line=strstr(inpline,"*/");
    if (ptr_line)
    {
      //
      // Finalize the comment
      //
      *ptr_line=0;
      strcpy(inpline+2,ptr_line);
      flag_in_comment_bloc=false;
    }
    else
    {
      //
      // We are still in the bloc
      //
      inpline[0]=0;
    }
  }

  //
  // Filtering of C++ like comments
  //
  {
    char *ptr_line=strstr(inpline,"//");
    if (ptr_line)
    {
      *ptr_line=0;
    }
  }

  //
  // Filtering of assembly comments
  //
  {
    char *ptr_line=strchr(inpline,';');
    if (ptr_line)
    {
      *ptr_line=0;
    }
  }

  //
  // Checking for a beginning of C bloc comment
  //
  if (!flag_in_comment_bloc)
  {
    char *ptr_line=strstr(inpline,"/*");
    if (ptr_line)
    {
      *ptr_line=0;
      flag_in_comment_bloc=true;
    }
  }

  return std::string(inpline);
}
#endif


/*
C:\OSDK\BIN\link65.exe -d C:\OSDK\lib/ -o C:\OSDK\TMP\linked.s -s C:\OSDK\TMP\ -q main
*/

//
// Parse a line. Mask out comment lines and null lines.
// Clear ending comments.
// Return defined labels in label var, with return value of 1
// Return labels used by JSR, JMP, LDA, STA in label var, with ret value of 2
//
int parseline(const std::string cInputLine,bool parseIncludeFiles)
{
  char *tmp;

  char inpline[MAX_LINE_SIZE+1];
  assert(sizeof(inpline)>cInputLine.size());
  strncpy(inpline,cInputLine.c_str(),MAX_LINE_SIZE);
  inpline[MAX_LINE_SIZE]=0;

  int len=strlen(inpline);

  //
  // Return if comment line or too small line
  //
  if (inpline[0] ==';')	return 0;
  if (len < 2)				return 0;

  //
  // Is a label defined..? (first char in line is what we want)
  //
  if ((inpline[0] !=' ') && (inpline[0] != 9))
  {
    label=strtok(inpline," *+-;\\\n/\t,");
    if (!label)
    {
      //
      // No token was found
      //
      return 0;
    }

    if (label[0]=='#')
    {
      //
      // It's a preprocessor directive
      //
      if (!stricmp(label,"#define"))	// MIKE: Do not need problems with #define (for XA equates)
      {
        //
        // #define is always followed by something that can be considered as a label.
        // For the linker that means that we have to add this 'label' in the list of
        // things to consider as internal linkage. (no need to lookup in the librarie)
        //
        // Read define name
        label=strtok(NULL," *+-;\\\n/\t,()");
        return 1;
      }
      else if (!stricmp(label,"#include"))
      {
        //
        // Problem with #include is that they may contain labels,
        // but we do not want to insert the content of the file,
        // so basically we should just recurse on the name without
        // including the content.
        // A kind of "label eater", really.
        //
        // Read define name
        //const char* pcFilename=strtok(NULL," \"*+-;\\\n/\t,()");
        const char* pcFilename=strtok(NULL," \"*+-;\n/\t,()");
        if (parseIncludeFiles)
        {
          ParseFile(pcFilename);
        }
        /*
        if (!stricmp(pcFilename,"GenericEditorRoutines.s"))
        {
        printf("toto");
        }
        ParseFile(pcFilename);
        */
        return 0;
      }
      //
      // Other '#' directives are not considered as labels.
      //
      return 0;
    }
    else
      if ((label[0]=='.') && ((label[1]=='(') || (label[1]==')')) )
      {
        // Opening or closing a local scope, not considered as label
        return 0;
      }
      else
      {
        //
        // Something else (probably a label)
        //
        return 1;
      }
  }

  //
  // Check for JMP or JSR and for the following label
  //
  int status = 0;
  tmp=strtok(inpline," *+-;\\\n/\t,()");
  while (tmp != NULL)
  {
    if (status == 1)
      break;

    if (!stricmp(tmp,"JSR"))		status = 1;
    else
    if (!stricmp(tmp,"JMP"))		status = 1;
    else
    if (!stricmp(tmp,"LDA"))		status = 1;
    else
    if (!stricmp(tmp,"STA"))		status = 1;
    else
    if (!stricmp(tmp,"LDX"))		status = 1;
    else
    if (!stricmp(tmp,"STX"))		status = 1;
    else
    if (!stricmp(tmp,"LDY"))		status = 1;
    else
    if (!stricmp(tmp,"STY"))		status = 1;

    //
    // Get next token in same line. This is the way strtok works
    //
    tmp=strtok(NULL," *+-;\\\n/\t,()");
  }
  if (tmp)
  {
    if ((status == 1)  && tmp[0] != '$' && tmp[0] != '(' && tmp[0] != '#' && !isdigit(tmp[0]))
    {
      label = tmp;
      return(2);
    }
    if ((status == 1) && (tmp[0] == '#') )
    {
      if (tmp[1] == 'H' || tmp[1] == 'L')
      {
        //
        // HIGH / LOW syntax
        //
        tmp=strtok(NULL," *+-;\\\n/\t,()<>");
        if (tmp != NULL && tmp[0] != '$' && tmp[0] != '(' && tmp[0] != '#' && !isdigit(tmp[0]))
        {
          label=tmp;
          return 2;
        }
      }
      else
      if (tmp[1]=='<' || tmp[1]=='>')
      {
        // < / > syntax
        if (tmp[2])
        {
          tmp+=2;
        }
        else
        {
          tmp=strtok(NULL," *+-;\\\n/\t,()<>");
        }

        if (tmp != NULL && tmp[0] != '$' && tmp[0] != '(' && tmp[0] != '#' && !isdigit(tmp[0]))
        {
          label=tmp;
          return 2;
        }
      }
    }
  }
  return 0;
}



void outall()
{
#ifndef _POSIX_VERSION
  flushall();
#endif
  fcloseall();
}

//
// Simple function that prints error message/calls outall.
// Simplifies the look of the main program
//
void linkerror(const char *msg)
{
  printf(msg);
  outall();
}




bool ParseFile(const std::string& filename)
{
  std::vector<std::string> cTextData;
  if (!LoadText(filename.c_str(),cTextData))
  {
    printf("\nCannot open %s \n",filename.c_str());
    outall();
    exit(1);
  }

  if (gFlagVerbose)
    printf("\nScanning file %s " ,filename.c_str());

  bool parseIncludeFiles=false;
  size_t sizeFileName=filename.size();
  if ( (sizeFileName>=2) && 
       (filename[sizeFileName-2]=='.') &&
       std::tolower(filename[sizeFileName-1]=='s')
     )   // Quick hack, we parse the includes in the assembler files, need proper detection of format
  {
    parseIncludeFiles=true;
  }


  unsigned int i;

  // Scanning the file
  std::vector<std::string>::const_iterator cItText=cTextData.begin();
  while (cItText!=cTextData.end())
  {
    //  Get line file and parse it
    const std::string& cCurrentLine=*cItText;

    std::string cFilteredLine=FilterLine(cCurrentLine);
    int state=parseline(cFilteredLine,parseIncludeFiles);

    std::string cFoundLabel;
    if (state && label)
    {
      cFoundLabel=label;
    }

    //  Oh, a label defined. Stuff it in storage
    if (state==1)
    {
      std::set<std::string>::iterator cIt=gDefinedLabelsList.find(cFoundLabel);
      if (cIt!=gDefinedLabelsList.end())
      {
        // Found the label in the list.
        // It's a duplicate definition... does not mean it's an error, because XA handles allows local labels !
        //printf("\nError ! Duplicate label : %s\n",label);
        //outall();
        //exit(1);
        //break;
      }
      else
      {
        // Insert new label in the set
        gDefinedLabelsList.insert(cFoundLabel);
      }
    }
    else
      if (state == 2)
      {
        // A label reference.
        // Store it if not already in list.
        bool bUndefinedLabel=true;
        for (i=0;i<gReferencedLabelsList.size();i++)
        {
          if (gReferencedLabelsList[i].label_name==cFoundLabel)
          {
            bUndefinedLabel=false;
            break;
          }
        }

        if (bUndefinedLabel)
        {
          // Allocate memory for label name and store it
          ReferencedLabelEntry_c cLabelEntry;
          cLabelEntry.label_name		=cFoundLabel;
          cLabelEntry.m_bIsResolved	=false;

          gReferencedLabelsList.push_back(cLabelEntry);
        }
      }
      ++cItText;
  }

  return true;
}




bool LoadLibrary(const std::string& path_library_files)
{
  std::string ndxstr=path_library_files+"library.ndx";

  std::vector<std::string> cTextData;
  if (!LoadText(ndxstr.c_str(),cTextData))
  {
    printf("Cannot open Index file : %s \n",ndxstr.c_str());
    exit(1);
  }

  if (gFlagVerbose)
    printf("Reading lib index file\n");

  LabelEntry_c cLabelEntry;
  cLabelEntry.file_name	="";
  cLabelEntry.label_name	="";

  std::vector<std::string>::const_iterator cItText=cTextData.begin();
  while (cItText!=cTextData.end())
  {
    //  Get line file and parse it
    std::string cCurrentLine=StringTrim(*cItText);

    // Lines that indicate files start with -
    //if (cCurrentLine[0] < 32)
    //	break;

    if (!cCurrentLine.empty())
    {
      if (cCurrentLine[0] == '-')
      {
        // Found a file indicator. Check if already used, if not start using it in table
        cLabelEntry.file_name=path_library_files+(cCurrentLine.c_str()+1);
        // check for duplicate
        for (unsigned int i=0;i<gLibraryReferencesList.size();i++)
        {
          if (cLabelEntry.file_name==gLibraryReferencesList[i].file_name)
          {
            printf("Duplicate file %s in lib index\n",cLabelEntry.file_name.c_str());
            outall();
            exit(1);
          }
        }
      }
      else
      {
        // Found a label. Check if already used, if not put it in table
        if (cLabelEntry.file_name.size()<2)
        {
          linkerror("Error with file line indicator\n");
          exit(1);
        }

        cLabelEntry.label_name=cCurrentLine;

        // Check if label is duplicate
        for (unsigned int i=0;i<gLibraryReferencesList.size();i++)
        {
          if (cLabelEntry.label_name==gLibraryReferencesList[i].label_name)
          {
            printf("Duplicate label %s in lib index file\n",cLabelEntry.label_name.c_str());
            outall();
            exit(1);
          }
        }

        // One more entry in the table
        gLibraryReferencesList.push_back(cLabelEntry);
      }
    }
    ++cItText;
  }

  return true;
}





int main(int argc,char **argv)
{
  //
  // Some initialization for the common library
  //
  SetApplicationParameters(
    "Link65",
    TOOL_VERSION_MAJOR,
    TOOL_VERSION_MINOR,
    "{ApplicationName} - Version {ApplicationVersion} - This program is a part of the OSDK\r\n"
    "\r\n"
    "Author:\r\n"
    "  Vagelis Blathras\r\n"
    "Maintainer:\r\n"
    "  Mickael Pointier (aka Dbug)\r\n"
    "  dbug@defence-force.org\r\n"
    "  http://www.defence-force.org\r\n"
    "\r\n"
    "Purpose:\r\n"
    "  Gluing together a set of 6502 assembly source codes, and solve the external\r\n"
    "  references by looking up missing ones in the library files.\r\n"
    "\r\n"
    "Usage : {ApplicationName} [options] file1 file2 ...\n"
    "Options:\r\n"
    "  -d : Directory to find library files.Next arg in line is the dir name.\r\n"
    "       e.g : link65 -d /usr/oric/lib/ test.s\r\n"
    "  -s : Directory to find source files.Next arg in line is the dir name.\r\n"
    "  -o : Output file. Default is go.s . Next arg in line is the file name.\r\n"
    "       e.g : link65 -o out.s test.s\r\n"
    "  -l : Print out defined labels.Usefull when building lib index files.\r\n"
    "  -v : Verbose output.\r\n"
    "  -q : Quiet mode.\r\n"
    "  -b : Bare linking (don't include header and tail).\r\n"
    "  -f : Insert #file directives (require expanded XA assembler).\r\n"
    "  -cn: Defines if comments should be kept (-c1) or removed (-c0) [Default]. \r\n"
    );


  // Init the path_library_files variable with default library directory and the output_file_name var with the default go.s
  std::string path_library_files("lib6502\\");
  std::string path_source_files("");
  std::string output_file_name("go.s");

  ArgumentParser cArgumentParser(argc,argv);

  while (cArgumentParser.ProcessNextArgument())
  {
    if (cArgumentParser.IsSwitch("-q") || cArgumentParser.IsSwitch("-Q"))
    {
      // Quiet mode.
      gFlagQuiet=true;
    }
    else
    if (cArgumentParser.IsSwitch("-l") || cArgumentParser.IsSwitch("-L"))
    {
      // Print out defined labels (Useful when building lib index files)
      gFlagLibrarian=true;
    }
    else
    if (cArgumentParser.IsSwitch("-v") || cArgumentParser.IsSwitch("-V"))
    {
      // Verbose output.
      gFlagVerbose=true;
    }
    else
    if (cArgumentParser.IsSwitch("-d") || cArgumentParser.IsSwitch("-D"))
    {
      // Directory to find library files.Next arg in line is the dir name. e.g : link65 -d /usr/oric/lib/ test.s
      if (!cArgumentParser.ProcessNextArgument() || !cArgumentParser.IsParameter())
      {
        printf(" Must have dir name after -d option\n");
        exit(1);
      }
      path_library_files=cArgumentParser.GetStringValue();
    }
    else
    if (cArgumentParser.IsSwitch("-s") || cArgumentParser.IsSwitch("-S"))
    {
      // Directory to find source files.Next arg in line is the dir name
      if (!cArgumentParser.ProcessNextArgument() || !cArgumentParser.IsParameter())
      {
        printf(" Must have dir name after -s option\n");
        exit(1);
      }
      path_source_files=cArgumentParser.GetStringValue();
    }
    else
    if (cArgumentParser.IsSwitch("-o") || cArgumentParser.IsSwitch("-O"))
    {
      // Output file. Default is go.s . Next arg in line is the file name. e.g : link65 -o out.s test.s
      if (!cArgumentParser.ProcessNextArgument() || !cArgumentParser.IsParameter())
      {
        printf(" Must have file name after -o option\n");
        exit(1);
      }
      output_file_name=cArgumentParser.GetStringValue();
    }
    else
    if (cArgumentParser.IsSwitch("-b") || cArgumentParser.IsSwitch("-B"))
    {
      // Bare linking, does not add "header" and "tail" to the list
      gFlagIncludeHeader=false;
    }
    else
    if (cArgumentParser.IsSwitch("-f") || cArgumentParser.IsSwitch("-F"))
    {
      // Enable the #file directive (require expanded XA assembler)
      gFlagEnableFileDirective=true;
    }
    else
    if (cArgumentParser.IsParameter())
    {
      // Not a switch
      FileEntry_c cFileEntry;

      if (gFlagIncludeHeader && gInputFileList.empty())
      {
        // header.s is the first file used.
        // So reserve the 0 place in array for after option scanning, to put there the dir name too if needed.
        cFileEntry.m_cFileName	  =path_library_files;
        cFileEntry.m_cFileName   +="header.s";
        cFileEntry.m_nSortPriority=0;
        gInputFileList.push_back(cFileEntry);
      }

      //
      // Then we add the new file
      //
      cFileEntry.m_cFileName	  =path_source_files;
      cFileEntry.m_cFileName   +=cArgumentParser.GetStringValue();
      cFileEntry.m_nSortPriority=1;
      gInputFileList.push_back(cFileEntry);
    }
    else
    if (cArgumentParser.IsSwitch("-c"))
    {
      //comments: [-c]
      //	0 => remove comments
      // 	1 => keep comments
      gFlagKeepComments=cArgumentParser.GetBooleanValue(false);
    }
    else
    {
      // Unknown argument
      printf("Invalid option %s \n",cArgumentParser.GetRemainingStuff());
      exit(1);
    }
  }

  if (cArgumentParser.GetParameterCount())
  {
    ShowError(0);
  }


  if (!gFlagQuiet)
  {
    printf("\nLink65: 6502 Linker, by Vagelis Blathras. Version %d.%3d\n\n",TOOL_VERSION_MAJOR,TOOL_VERSION_MINOR);
  }


  if (gFlagIncludeHeader)
  {
    // Now put the tail.s .
    // Give it nflist of 2 to put it last in file list after the sort
    FileEntry_c cFileEntry;
    cFileEntry.m_cFileName	  =path_library_files;
    cFileEntry.m_cFileName   +="tail.s";
    cFileEntry.m_nSortPriority=2;
    gInputFileList.push_back(cFileEntry);
  }


  // Open and scan Index file for labels - file pair list
  LoadLibrary(path_library_files);

  int state;
  unsigned int i,j;
  unsigned int k,l;

  // Scanning files loop
  for (k=0;k<gInputFileList.size();k++)
  {
    // Skip header.s file if gFlagLibrarian option is on
    if (gFlagLibrarian && k == 0)
    {
      k=1;
    }

    //char filename[255];
    //strcpy(filename,gInputFileList[k].m_cFileName.c_str());
    ParseFile(gInputFileList[k].m_cFileName);

    //
    // Check if used labels are defined inside the files
    //
    std::vector<ReferencedLabelEntry_c>::iterator cItReferenced=gReferencedLabelsList.begin();
    while  (cItReferenced!=gReferencedLabelsList.end())
    {
      ReferencedLabelEntry_c& cLabelEntry=*cItReferenced;
      std::set<std::string>::iterator cIt=gDefinedLabelsList.find(cLabelEntry.label_name);
      if (cIt!=gDefinedLabelsList.end())
      {
        // Found the label in the definition list
        cLabelEntry.m_bIsResolved=true;
      }
      ++cItReferenced;
    }

    if (!gFlagLibrarian)
    {
      // Check for not resolved labels.
      // If defined in lib file index then insert their file right after in the list
      for (i=0;i<gReferencedLabelsList.size();i++)
      {
        // Unresolved label and -l option off. If -l option is on don't care
        ReferencedLabelEntry_c& cReferencedLabelEntry=gReferencedLabelsList[i];
        if (!cReferencedLabelEntry.m_bIsResolved)
        {
          // Act for unresolved label
          for (j=0;j<gLibraryReferencesList.size();j++)
          {
            LabelEntry_c& cLabelEntry=gLibraryReferencesList[j];
            // If in lib file index, take file and put it in gInputFileList if not already there
            if (cReferencedLabelEntry.label_name==cLabelEntry.label_name)
            {
              bool labstate=true;
              for (l=0;l<gInputFileList.size();l++)
              {
                FileEntry_c& cFileEntry=gInputFileList[l];
                if (cFileEntry.m_cFileName==cLabelEntry.file_name)
                {
                  labstate=false;
                  break;
                }
              }

              // Not present : labstate == 1 , insert file in list
              if (labstate)
              {
                FileEntry_c	cNewEntry;
                gInputFileList.push_back(cNewEntry);

                // NICE TRICK : Insert lib file in file list to be processed immediately.
                // With this labels used by the lib file will be resolved, without the need for multiple passes
                for (l=gInputFileList.size()-1;l>k+1;l--)
                {
                  gInputFileList[l]=gInputFileList[l-1];
                }
                FileEntry_c& cFileEntry=gInputFileList[k+1];
                cFileEntry.m_cFileName		=cLabelEntry.file_name;
                cFileEntry.m_nSortPriority	=1;
              }
              else
              {
                break;
              }
            }
          }
        }
      }
    }
  }

  if (gFlagVerbose)
    printf("\nend scanning files \n\n");

  state=0;

  if (gFlagLibrarian)
  {
    // If -l option just print labels and then exit
    printf("\nDefined Labels : \n");

    std::set<std::string>::iterator cIt=gDefinedLabelsList.begin();
    while (cIt!=gDefinedLabelsList.end())
    {
      const std::string& cLabelName=*cIt;
      printf("%s\n",cLabelName.c_str());
      ++cIt;
    }
    outall();
    return(0);
  }
  else
  {
    // Check for Unresolved external references.
    // Print them all before exiting
    for (i=0;i<gReferencedLabelsList.size();i++)
    {
      ReferencedLabelEntry_c& cReferencedLabelEntry=gReferencedLabelsList[i];
      if (!cReferencedLabelEntry.m_bIsResolved)
      {
        printf("Unresolved external: %s\n",cReferencedLabelEntry.label_name.c_str());
        state=1;
      }
    }
  }

  if (state == 1)
  {
    linkerror("Errors durink link.\n");
    exit(1);
  }


  // Combine all files in list in a nice big juicy go.s or file selected
  FILE *gofile=fopen(output_file_name.c_str(),"wb");
  if (!gofile)
  {
    linkerror("Cannot open output file for writing\n");
    exit(1);
  }

  //
  // Add a simple header to the linked file
  //
  fprintf(gofile,
    "//\r\n"
    "// This file was generated by Link65 version %d.%03d \r\n"
    "// Do not edit by hand\r\n"
    "//\r\n"
    ,TOOL_VERSION_MAJOR,TOOL_VERSION_MINOR);


  // Get lines from all files and put them in go.s
  for (k=0;k<gInputFileList.size();k++)
  {
    if (gFlagVerbose)
    {
      printf("Linking %s\n",gInputFileList[k].m_cFileName.c_str());
    }

    //
    // Then insert the name of the included file
    //
    if (gFlagEnableFileDirective)
    {
      char current_directory[_MAX_PATH+1];
      char filename[_MAX_PATH];
      char dummy[_MAX_PATH];

      getcwd(current_directory,_MAX_PATH);
      _splitpath(gInputFileList[k].m_cFileName.c_str(),dummy,dummy,filename,dummy);

      fprintf(gofile,"#file \"%s\\%s.s\"\r\n",current_directory,filename);
    }

    // Mike: The code should really reuse the previously loaded/parsed files
    std::vector<std::string> cTextData;
    if (!LoadText(gInputFileList[k].m_cFileName.c_str(),cTextData))
    {
      printf("\nCannot open %s \n",gInputFileList[k].m_cFileName.c_str());
      outall();
      exit(1);
    }

    std::vector<std::string>::const_iterator cItText=cTextData.begin();
    while (cItText!=cTextData.end())
    {
      //  Get line file and parse it
      const std::string& cCurrentLine=*cItText;
      if (gFlagKeepComments)
      {
        fprintf(gofile,"%s\r\n",cCurrentLine.c_str());
      }
      else
      {
        std::string cFilteredLine=FilterLine(cCurrentLine);
        fprintf(gofile,"%s\r\n",cFilteredLine.c_str());
      }
      ++cItText;
    }
  }

  outall();
  return(0);
}


