;Log_TextHandler.s

This covers the format for all bottom text handling

Wurlde text requires both upper and lower case letters, numerals and some punctuation marks.
Standard ascii characters 32-127 are used but unsupported characters are used to trigger control
codes for colours and codes and some optimisation techniques.

000	End of Text
001-007 Ink Colour Change (Limited to first 3 rows)
008
009
010
011
012
013     Return to next row
014-031 Trigger SFX (18)
032     Space
033     !
034     "
035	Not Used
036	Not Used
037	%
038	Not Used
039	'
040	(
041	)
042	*
043	+
044	,
045	-
046	.
047	/
048-057	0-9
058	:
059	Not Used
060	Not Used
061	Not Used
062	>
063	?
064	Not Used
065-090 A-Z
091	Not Used
092	Not Used
093	Not Used
094	Not Used
095	Not Used
096	Not Used
097-122 a-z
123     Not Used
124     Not Used
125     Not Used
126     Not Used
127	Not Used
