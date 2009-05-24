&start
PRINT "Are you a (b)oy or a (g)irl ?"
GET A$
IF A$="B" OR A$="b" THEN GOSUB &boy ELSE GOSUB &girl
PRINT "Hello ";B$;" !!!"
GOTO &start
&boy
B$="boy":RETURN
&girl
B$="girl":RETURN