
#ifndef _UNDEFINED_LABELS_H_
#define _UNDEFINED_LABELS_H_

class UndefinedLabels
{
public:
	UndefinedLabels();
	~UndefinedLabels();

	void Clear();

	int u_label(int labnr);
	void u_write(FILE *fp);

public:
	int		*m_ulist;
	int 	m_un;
	int 	m_um;
};

#endif

