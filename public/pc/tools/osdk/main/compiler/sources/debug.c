#ifdef DEBUG
/* lprint - print the nodelist beginning at p */
static void lprint(Node p, char *s) 
{
	fprint(2, "node list%s:\n", s);
	if (p) 
	{
		char buf[100];
		sprintf(buf, "%-4s%-8s%-8s%-8s%-7s%-13s%s"," #", "op", "kids", "syms", "count", "uses", "sets");
		fprint(2, "%s\n", buf);
	}
	for ( ; p; p = p->x.next)
		nprint(p);
}

/* nprint - print a line describing node p */
static void nprint(Node p) 
{
	int i;
	char *kids = "", *syms = "", buf[200];

	if (p->kids[0]) 
	{
		static char buf[100];
		buf[0] = 0;
		for (i = 0; i < MAXKIDS && p->kids[i]; i++)
			sprintf(buf + strlen(buf), "%3d", p->kids[i]->x.id);
		kids = &buf[1];
	}
	if (p->syms[0] && p->syms[0]->x.name) 
	{
		static char buf[100];
		buf[0] = 0;
		for (i = 0; i < MAXSYMS && p->syms[i]; i++) 
		{
			if (p->syms[i]->x.name)
				sprintf(buf + strlen(buf), " %s", p->syms[i]->x.name);
			if (p->syms[i]->u.c.loc)
				sprintf(buf + strlen(buf), "=%s", p->syms[i]->u.c.loc->name);
		}
		syms = &buf[1];
	}
	sprintf(buf, "%2d. %-8s%-8s%-8s %2d    %-13s",p->x.id, opname(p->op), kids, syms, p->count, rnames(uses(p)));
	sprintf(buf + strlen(buf), "%s", rnames(sets(p)));
	fprint(2, "%s\n", buf);
}

/* rnames - return names of registers given by mask m */
static char *rnames(unsigned m) 
{
	static char buf[100];
	int r;

	buf[0] = buf[1] = 0;
	for (r = 0; r < nregs; r++)
		if (m&(1<<r))
			sprintf(buf + strlen(buf), " r%d", r);
	return &buf[1];
}
#endif
