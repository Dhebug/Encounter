/*==============================================================================

							 MemMap

==[Description]=================================================================

Generate an html file representing the memory map of provided files.

==[History]=====================================================================

==[ToDo]========================================================================

==============================================================================*/

#pragma warning( disable : 4706)
#pragma warning( disable : 4786)


#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <io.h>
#include <fcntl.h>
#include <sys/stat.h>

#include <string>
#include <map>

#include "infos.h"

#include "common.h"


const char gHtmlHeader[]=
"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\">\r\n"
"<HTML lang=fr dir=ltr>\r\n"
"	<HEAD>\r\n"
"		<meta name=\"robots\" content=\"noindex\">\r\n"
"		<meta http-equiv=\"Content-Type\" content=\"text/html;charset=iso-8859-1\">\r\n"
"		<title>{PageTitle}</title>\r\n"
"		<link href=\"{CssLink}\" rel=\"stylesheet\" type=\"text/css\">\r\n"
"	</HEAD>\r\n"
"	<BODY>\r\n";


const char gHtmlFooter[]=
"	</BODY>\r\n"
"</HTML>\r\n";




class Section
{
public:
	Section() :
		m_adress_size(4),
		m_begin_adress(0),
		m_end_adress(65535)
	{
	}

	void Generate(std::string &ref_html) const;

	std::map<int,std::string> &GetMap()
	{
		return m_map_data;
	}

public:	
	std::string					m_anchor_name;
	std::string					m_section_name;
	int							m_adress_size;
	int							m_begin_adress;
	int							m_end_adress;

	std::map<int,std::string>	m_map_data;
};


void Section::Generate(std::string &html)  const
{
	html+="<a name=\""+m_anchor_name+"\"></a>\r\n";

	html+="<h1>"+m_section_name+"</h1>\r\n";

	html+="<table border>\r\n";
	html+="<tr>\r\n";
	html+="<th>Adress</th><th>Size</th><th>Name</th>\r\n";
	html+="</tr>\r\n";

	std::map<int,std::string>::const_iterator it=m_map_data.begin();
	while (it!=m_map_data.end())
	{
		int value              =(*it).first;
		const std::string& name=(*it).second;
		++it;

		char buffer_adress[512];
		if (value&255)
		{
			sprintf(buffer_adress,"$%02x",value);
		}
		else
		{
			sprintf(buffer_adress,"<b>$%02x</b>",value);
		}

		char buffer_size[512];
		if (it!=m_map_data.end())
		{
			sprintf(buffer_size,"%d",(*it).first-value);
		}
		else
		{
			sprintf(buffer_size,"%d",m_end_adress-value);
			//sprintf(buffer_size,"???");
		}

		html+="<tr>\r\n";
		html+=(std::string)"<td>"+buffer_adress+"</td><td>"+buffer_size+"</td><td>"+name+"</td>";
		html+="</tr>\r\n";
	}
	html+="</table>\r\n";
}



enum INPUT_FORMAT
{
	INPUT_FORMAT_ORIC_XA,
	INPUT_FORMAT_ATARI_DEVPAC,
};


#define NB_ARG	4

int main(int argc,char *argv[]) 
{
	//
	// Some initialization for the common library
	//
	SetApplicationParameters(
		"MemMap",
		TOOL_VERSION_MAJOR,
		TOOL_VERSION_MINOR,
		"{ApplicationName} - Version {ApplicationVersion} - This program is a part of the OSDK\r\n"
		"\r\n"
		"Author:\r\n"
		"  Pointier Mickael\r\n"
		"\r\n"
		);


	INPUT_FORMAT inputFormat=INPUT_FORMAT_ATARI_DEVPAC;		// 0=XA / 1=Devpac

	ArgumentParser cArgumentParser(argc,argv);

	while (cArgumentParser.ProcessNextArgument())
	{
	}


    if (cArgumentParser.GetParameterCount()!=NB_ARG)
    {
		ShowError(0);
    }


	//
	// Copy last parameters
	//
	std::string	source_name(cArgumentParser.GetParameter(0));
	std::string	dest_name(cArgumentParser.GetParameter(1));
	std::string	project_name(cArgumentParser.GetParameter(2));
	std::string	css_name(cArgumentParser.GetParameter(3));

	/*
	printf("\n0=%s\n",source_name.c_str());
	printf("\n1=%s\n",dest_name.c_str());
	printf("\n2=%s\n",project_name.c_str());
	printf("\n3=%s\n",css_name.c_str());
	*/

	void* ptr_buffer_void;
	size_t size_buffer_src;

	//
	// Load the file
	//
	if (!LoadFile(source_name.c_str(),ptr_buffer_void,size_buffer_src))
	{
		printf("\nUnable to load file '%s'",source_name.c_str());
		printf("\n");
		exit(1);
	}

	unsigned char *ptr_buffer=(unsigned char*)ptr_buffer_void;

	//
	// Parse the file, and generate the list of values
	//
	std::map<std::string,Section>	Sections;

	switch (inputFormat)
	{
	case INPUT_FORMAT_ORIC_XA:
		{
			Section& section_zeropage=Sections["Zero"];
			section_zeropage.m_anchor_name	="Zero";
			section_zeropage.m_section_name	="Zero page";
			section_zeropage.m_adress_size	=2;
			section_zeropage.m_begin_adress	=0x0;
			section_zeropage.m_end_adress	=0xFF;

			Section& section_normal=Sections["Normal"];
			section_normal.m_anchor_name	="Normal";
			section_normal.m_section_name	="Normal memory";
			section_normal.m_adress_size	=4;
			section_normal.m_begin_adress	=0x400;
			section_normal.m_end_adress		=0xBFFF;

			Section& section_overlay=Sections["Overlay"];
			section_overlay.m_anchor_name	="Overlay";
			section_overlay.m_section_name	="Overlay memory";
			section_overlay.m_adress_size	=4;
			section_overlay.m_begin_adress	=0xC000;
			section_overlay.m_end_adress	=0xFFFF;
		}
		break;

	case INPUT_FORMAT_ATARI_DEVPAC:
		{
			Section& section_zeropage=Sections["Text"];
			section_zeropage.m_anchor_name	="Text";
			section_zeropage.m_section_name	="Section TEXT";
			section_zeropage.m_adress_size	=4;
			section_zeropage.m_begin_adress	=0x00;
			section_zeropage.m_end_adress	=0xFFFFFF;

			Section& section_normal=Sections["Data"];
			section_normal.m_anchor_name	="Data";
			section_normal.m_section_name	="Section DATA";
			section_normal.m_adress_size	=4;
			section_normal.m_begin_adress	=0x00;
			section_normal.m_end_adress		=0xFFFFFF;

			Section& section_overlay=Sections["Bss"];
			section_overlay.m_anchor_name	="Bss";
			section_overlay.m_section_name	="Section BSS";
			section_overlay.m_adress_size	=4;
			section_overlay.m_begin_adress	=0x00;
			section_overlay.m_end_adress	=0xFFFFFF;

			Section& section_rs=Sections["RS"];
			section_rs.m_anchor_name	="RS";
			section_rs.m_section_name	="RS offsets";
			section_rs.m_adress_size	=4;
			section_rs.m_begin_adress	=0x00;
			section_rs.m_end_adress	=0xFFFFFF;
		}
		break;
	}


	char *ptr_tok=strtok((char*)ptr_buffer," \r\n");
	while (ptr_tok)
	{
		// Address
		int value=strtol(ptr_tok,0,16);

		switch (inputFormat)
		{
		case INPUT_FORMAT_ORIC_XA:
			{
				ptr_tok=strtok(0," \r\n");
				// Name
				if (value<256)
				{
					// Zero page
					Sections["Zero"].GetMap()[value]=ptr_tok;
				}
				else
				if (value>=0xc000)
				{
					// Overlay memory
					Sections["Overlay"].GetMap()[value]=ptr_tok;
				}
				else
				{
					Sections["Normal"].GetMap()[value]=ptr_tok;
				}
			}
			break;
		case INPUT_FORMAT_ATARI_DEVPAC:
			{
				// ptr_tok:
				// A=Absolute (rs/offsets/computations)
				// R=Relocatable (addresses)
				// T=TEXT
				// D=DATA
				// B=BSS
				std::string section="Text";

				std::string token;
				do
				{
					ptr_tok=strtok(0," \r\n");
					token=ptr_tok;
					if (token=="A")			section="RS";
					else if (token=="B")	section="Bss";
					else if (token=="T")	section="Text";
					else if (token=="D")	section="Data";
				}
				while (token.size()==1);

				Sections[section].GetMap()[value]=token;
			}
		}
		ptr_tok=strtok(0," \r\n");
	}


	//
	// Generate the html file
	//
	std::string html(gHtmlHeader);

	StringReplace(html,"{PageTitle}"	,project_name);
	StringReplace(html,"{CssLink}"		,css_name);

	/*
	html+="<A href=\"#Zero\">Zero page</A><br>";
	html+="<A href=\"#Normal\">Normal memory</A><br>";
	html+="<A href=\"#Overlay\">Overlay memory</A><br>";
	*/

	html+="<table>\r\n";
	html+="<tr>\r\n";

	std::map<std::string,Section>::const_iterator it(Sections.begin());
	while (it!=Sections.end())
	{
		const Section& section=it->second;
		html+="<td valign=top>\r\n";
		section.Generate(html);
		html+="</td>\r\n";
		++it;
	}

	html+="</tr>\r\n";
	html+="</table>\r\n";

	html=html+gHtmlFooter;

	unsigned char *ptr_buffer_dst=new unsigned char[size_buffer_src+8];
	int size_buffer_dst=size_buffer_src/2;

	unsigned char *ptr_src=ptr_buffer;
	unsigned char *ptr_dst=ptr_buffer_dst;
	int i;
	for (i=0;i<size_buffer_dst;i++)
	{
		unsigned char b0=*ptr_src++;
		unsigned char b1=*ptr_src++;
		unsigned char b=(b1&0xF0)|(b0>>4);
		*ptr_dst++=b;
	}

	if (!SaveFile(dest_name.c_str(),html.c_str(),html.size()))
	{
		printf("\nUnable to save file '%s'",source_name.c_str());
		printf("\n");
		exit(1);
	}

	//
	// Make some cleaning
	//
	delete[] ptr_buffer;
	delete[] ptr_buffer_dst;

	return 0;
}


