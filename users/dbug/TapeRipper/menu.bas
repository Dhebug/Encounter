#labels
    POKE #BB80+36,0     ' Remove the CAPS text
    ST=PEEK(#26A)       ' Save the old status
    GOSUB load_prefix   ' Default prefix
    POKE #26A,2         ' Hide the cursor
    INK 2
start    
    GOSUB display_title
    PRINT"Please make your selection:"
    PRINT"- H: Display help"
    PRINT"- R: Start ripping"
    PRINT"- P: Change prefix [";NM$;"]"
    PRINT"- S: Tape Speed: ";:IF PEEK(#24D) THEN PRINT"SLOW" ELSE PRINT"FAST"
    PRINT"- L: List all rips"
    PRINT"- T: Test ripped file"
    PRINT"- Q: Quit"
loop    
    GET K$
    IF K$="H" OR K$="h" THEN GOTO help_page_1
    IF K$="R" OR K$="r" THEN GOTO start_rip
    IF K$="P" OR K$="p" THEN GOTO change_prefix
    IF K$="S" OR K$="s" THEN GOTO change_speed
    IF K$="L" OR K$="l" THEN GOTO list_rips
    IF K$="T" OR K$="t" THEN GOTO test_rip
    IF K$="Q" OR K$="q" THEN GOTO quit
    GOTO loop

quit
    POKE #26A,ST    ' Restore the original status
    END

' The Filename is of the form 9.3 (13 characters null terminated)
' OSDK_0500.TR1 with <prefix>_<loadaddress>.TR<part number>
' and is stored just after the video memory

' BFF2 O
' BFF3 S
' BFF4 D
' BFF5 K
' BFF6 A
' BFF7 0
' BFF8 0
' BFF9 0
' BFFA 0
' BFFB .
' BFFC T
' BFFD R
' BFFE 1
' BFFF 0
' C000 ---- ROM

change_speed
    IF PEEK(#24D) THEN POKE #24D,0 ELSE POKE #24D,1
    GOTO start

' Write the 'NNNN-000.TR1' string in top of memory
' This will be used by the Assembly module as the
' filename to save to disk
save_prefix
    NA$=NM$+"A0000.TR0"+CHR$(0)
    FOR I=1 TO LEN(NA$)
      POKE #BFF2+I-1,ASC(MID$(NA$,I,1))
    NEXT
    RETURN

load_prefix
    ' Check if we already initialized the prefix in memory
    IF PEEK(#BFF6)<>ASC("-") OR PEEK(#BFFB)<>ASC(".") OR PEEK(#BFFF)<>0 THEN NM$="OSDK":GOTO save_prefix
    ' Read back the memory area to extract the prefix
    NM$=CHR$(PEEK(#BFF2))+CHR$(PEEK(#BFF3))+CHR$(PEEK(#BFF4))+CHR$(PEEK(#BFF5))
    RETURN    

change_prefix
    GOSUB display_title
    PRINT"Current prefix: ";NM$
    INPUT"New prefix (4 characters): ";PR$
    IF LEN(PR$)=4 THEN NM$=PR$:GOSUB save_prefix:GOTO start
    PRINT"Not a valid prefix"
    GET K$
    GOTO start

start_rip
    GOSUB display_title
    ' Check if there are already some ripped files with this prefix
    SEARCH NM$+"*.TR*"
    IF EF=0 THEN GOTO continue_rip
    PRINT"There are already some rips for this prefix"
    DIR NM$+"*.TR*"
    PRINT"Delete them and proceed? (y/n)"
loop_delete_rip    
    GET K$
    IF K$="Y" OR K$="y" THEN GOTO delete_and_continue_rip 
    IF K$="N" OR K$="n" THEN GOTO start 
    GOTO loop_delete_rip

delete_and_continue_rip
    ' We use DESTROY instead of DEL to disable the Y/n confirmation on each file
    DESTROY NM$+"*.TR*"
    GOSUB display_title
continue_rip    
    PRINT"~S~A~L      Ripping in progress"
    PRINT
    PRINT"         Press RESET to quit"
    LOAD"RIPTAP.COM"
    ' Not supposed to happen
    PRINT"Load error??"
    GET K$
    END

list_rips
    GOSUB display_title
    SEARCH "*.TR*"
    IF EF=0 THEN PRINT"No rips found"
    IF EF=1 THEN DIR"*.TR*"    
    GET K$
    GOTO start

test_rip    
    GOSUB display_title
    SEARCH NM$+"*.TR*"
    IF EF=0 THEN PRINT"No rips found":GET K$:GOTO start
    PRINT"Available rips:"
    DIR NM$+"*.TR*"
    PRINT
    PRINT"You can load these by using"
    PRINT"LOAD"+CHR$(34)+NM$+"<adress>.TR<number>"+CHR$(34)+",A#<adress>"
    PRINT"CALL #<adress>"
    GET K$
    GOTO start

help_page_1    
    ' First page of Help
    GOSUB display_title
    PRINT"TapeRipper is designed to be an easy"
    PRINT"to use program to transfer tapes to a"
    PRINT"floppy disk to facilitate archiving."
    PRINT
    PRINT"The traditionnal method is to record"
    PRINT"the waveform on a modern PC, then use"
    PRINT"software to decode the signal, but it"
    PRINT"requires some time to master it."
    PRINT
    PRINT"With TapeRipper you need a disk drive"
    PRINT"(Microdisc, Cumulus or Cumana Reborn)"
    PRINT
    PRINT"First you make sure the software loads"
    PRINT"properly from tape... Then you rip it!"
    PRINT
    PRINT"The program will load each bloc from"
    PRINT"tape, and then immediately save it to"
    PRINT"disc with incremented numbers."
    PRINT
    PRINT"~C     <press any key for more>"
    GET K$
help_page_2
    ' Second page of Help
    GOSUB display_title
    PRINT"The keyboard is not active during the"
    PRINT"Load and Save operations, the only way"
    PRINT"to quit is to press the RESET button."
    PRINT
    PRINT"Using a cable with a remote connector"
    PRINT"will allow your Oric to automatically"
    PRINT"start and stop the tape drive, making"
    PRINT"the process much more relaxing."
    PRINT
    PRINT"The four letters prefix is used to do"
    PRINT"multiple rips with distinct names."
    PRINT
    PRINT"~C     <press any key for more>"
    GET K$

    GOTO start

display_title
    CLS
    PRINT"~Q"
    PRINT"~T~C~JTapeRipper 2.1 - "+CHR$(96)+" Defence Force"
    PRINT"~T~C~JTapeRipper 2.1 - "+CHR$(96)+" Defence Force"
    PRINT"~Q"
    PRINT
    RETURN