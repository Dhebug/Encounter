;IssueLog.s

20081123 Keyboard Delay is disabled in some editors			FIXED(Now in optimised IRQ)
20081123 Need to write Help Screen/Editor				FIXED(No Edit yet though)
20081123 Need to finish play routine					FIXED(Not tested yet though)
20081123 Need to write commands to jump between editors			FIXED(But sorely need full scn)
20081123 Need to code Escape from Menu Editor				FIXED
20081123 Need to code Return in Menu Editor				FIXED
20081123 Need to code Play monitor					FIXED
20081123 Need to sort Pattern Editor Highlighting and Cut/Copy/Paste/Merge	FIXED
20081123 Need to sort Event Editor Highlighting and Cut/Copy/Paste		FIXED
20081123 Need to sort Effect Editor Highlighting and Cut/Copy/Paste/Merge	FIXED
20081123 Need to sort Sedoric File Routines and create Directory Editor	FIXED
20081123 Glow Each Editor title when active				FIXED
20081124 Need to manage screen layouts(also restore after file or Help)	FIXED
20081124 Add Edit Keys in Help(if memory permits)				FIXED
20081124 Need to update Editor name in Help				FIXED
20081124 Need to manage/show/remove Song name in Event Title		REMOVED
20081124 Need to update Effect Number and name in Effect Title		FIXED
20081124 Need to have lookup in Pattern for Effect Number and name effect their	FIXED(status)
20081124 Need to have lookup in pattern for Command to set specific parms	FIXED(status)
20081124 Need to have lookup in events for behaviour and settings commands	FIXED(status)
20081127 Reduce Event Entry to two entries when in editor			FIXED
20081127 Need to have common key combos for jumping between editors		FIXED
20081127 Need Generic name input (For new filename,Effect name & New Song name)	FIXED
20081127 Sort out File Help text numbers				FIXED
20081127 Sort columns in help editor (Pattern descriptions overlap)		FIXED
20081127 Update Pattern Legend with config from Events			FIXED
20081128 Set Pattern config from Events					FIXED
20081128 Set effect number from current pattern entry			FIXED
20081128 Protect Effect editor against infinite loops			FIXED
20081129 No controls to change command parms in Pattern Editor(Inc Crashes!!)	FIXED
20081129 No Rest command in Pattern Editor				FIXED
20081129 Need to sort changing Note Volume,Effect cos no work atm :(		FIXED
20081129 Add new key to effect editor to Enter Current Effect Name		FIXED
20081129 Need to control size of editors				FIXED
20081129 Sort Helpplot for Effects(Fields overlap)			FIXED
20081130 Code Play Options in Pattern Editor				FIXED
20081130 Code Play Options in Effect Editor				FIXED
20081130 Code or Remove Play options in File Editor			DISABLED
20081130 Code Insert/Delete in Events, Effects & Patterns			FIXED
20081130 Last Saved or Loaded filename needs to update in file statusbar	FIXED
20081130 Test PlayRoutine						FIXED
20081130 Add Return as optional key for Loading in File Editor		FIXED
20081130 When a key already used in helpplot bad message displayed 		FIXED
20081130 Add Feature that allows one to preload music when app started	ADDMENU
20081130 Sort short screen when odd rows cannot reach last line of display	FIXED
20081130 Add Event key to assign next 8 free patterns to the row		RETHOUGHT
20081130 Change Pattern Display to Clear Inactive track rather than show Rests	FIXED
20081130 Key needed in Event Editor to 'Assign Pattern Command to H'		FIXED
20081130 Relocate key codes & window dims to end of Music data and cover save	FIXED
20081130 Naming effect doesn't appear whilst typing			FIXED
20081201 Code Print option in File Editor				UTILITY
20081201 Reset Cursor when entering Help window				FIXED
20081201 Investigate possibility of having Generic Pattern Command (not just H)	DISMISSED(See Notes)
20081201 Jump over inactive tracks in pattern editor			FIXED
20081201 Letters used to identify Track sources in Pattern legend are wrong	FIXED
20081201 Investigate changing pattern editor cursor to 2 chars over note	DISMISSED
20081202 Need key for VRest in Pattern Editor(or autoset on changing vol in rst)FIXED
20081202 Command not Shown in status whilst in pattern editor		FIXED
20081202 Mimic fields not displayed right in Event Editor			FIXED
20081203 Show Grabbed data and code grab/drop				FIXED
20081203 Code Drive ID in File Editor					FIXED
20081203 Prompting cyan MUSIC in File editor				FIXED
20081203 File editor Crashing when saving new filename			FIXED
20081203 File editor crashing when attempting to load ???(new) music		FIXED
20081203 Code New Pattern Editor Key to Toggle Command Flag on current track	FIXED
20081203 Command Track byte is not being reset somewhere			FIXED
20081203 If H is Command Track this should be shown in pattern legend SS like c	FIXED
20081203 Code Last/Next in Pattern Editor(Code present but not working)	FIXED
20081204 Remove or Code Move Up/Down in Pattern Editor			FIXED
20081204 Pattern Editor Insert and Delete NOW does weird shit(h is related)!!	FIXED
20081204 Special Rest should be inserted on h if Command (Insert/Delete)	FIXED
20081204 Toggle Command H in event editor doesn't toggle, only sets		FIXED
20081204 Row wide event editor command no longer works!			FIXED
20081204 Need New song naming command in Event Editor			FIXED
20081204 Need ways of changing row wide command values in event editor	FIXED
20081204 some row wide event commands display as RESERVED			FIXED
20081206 Need to update prProcEvents with data changes to rwc event formats	FIXED
20081206 Need to optimise somewhat, approaching $B500			FIXED
20081207 Event RWC Loop Row should say --- instead of values over 127		FIXED
20081208 Grabbed not shown in editors (need to consolidate status and title)	FIXED
20081208 Need List editor key to commence play from cursor			FIXED
20081208 Replace Effect delay setting in event command(no delay anymore)	FIXED
20081208 Protect against event looping to same row			FIXED
20081223 Inc/Dec should work in reverse for Loop(SFX)			FIXED
20081223 Inc/Dec Loop can exceed range(SFX)				FIXED
20081223 File save misses first entry (or blacks it)			FIXED
20081223 Save corrupts Play Char graphic				FIXED
20081223 Need List Command to assign new patterns for row (using prev pat mix)  FIXED
20081223 Replace EVENT with LIST then can unify Keys			FIXED
20081223 When disk full, prog freezes (err not trapped)
20081228 Add Song number in Menu and permit setting it			FIXED
20081228 Change EFFECT to SFX						FIXED
20081228 Unify keys for EFFECT to SFX and EVENT to LIST			FIXED
20081228 Dec Volume in SFX Editor crashes				FIXED
20081229 Reset Event RWC does not reset but decs				FIXED
20081229 Pattern Vol should be 0-63 if higher res				FIXED
20081229 =/- New song name should at least allow input on row		FIXED
20081229 pr sfx crashes on loop(loop possibly calcs incorrect offset)		FIXED
20081229 sharing disables SFX						FIXED
20081230 Reduce Effect Entries to 64(Frees 4K)				FIXED
20081231 Implement Digidrum, VPW and SID				DISABLED
20081232 For Digidrum reduce Patterns to 96(Frees 4K for Digidrums) Add rule	DISABLED
20090103 Display contextual info for Patterns (more than just Effect name)
20090103 How do we protect against playing non-existant digidrum?		DISABLED
20090103 Add list nav keys to select song				FIXED
20090104 EG Period in pr (SFX) is SET EG but in editor is INC/DEC		FIXED
20090106 Default List Command Parameters when entering new command line	FIXED
20090106 Need to test pr when Multiple Track rows in List and with diff config	FIXED
20090106 Implement Pattern Names? (Ask Baggio)				CONSTRAINT
20090106 Show current Resolution,note,volume in Effect Editor somewhere	FIXED
20090106 Resolutions not working(may need to rework to be track dependant?)	FIXED
20090107 Reflect Octave in Pattern if Octave RWC set in List		FIXED
20090107 Permit Pattern Keys 567 for Octave if within range			FIXED
20090107 Update Date in Data						ONGOING
20090107 Right Justify Editor description in Help Editor & clear space	FIXED
20090107 Toggle (Space) should prompt New Song Name rather than -/=		FIXED
20090107 Show Current Song in List					FIXED
20090107 Need new List key for Play Song				FIXED
20090107 Need new List key for Play Row(Pattern)				FIXED
20090107 Prevent Pattern Cursor move into Rested Track			FIXED
20090107 No Pattern key for V-Rest					FIXED
20090107 Need 'Cancel Loop Condition' key for ed and code in pr		FIXED
20090107 Insert/Delete in SFX should update Loop
20090107 ValidateSFX still permits infinite loops				FIXED
20090108 SFX Loop command defaults to point to same row			FIXED
20090110 Accelerate SFX Proc by using tables
20090110 Code Patterns Trigger In Command				FIXED
20090110 Code Patterns Trigger Out Command				FIXED
20090110 Code Patterns Pitchbend Command				FIXED
20090110 List Copy Last does not copy all settings			FIXED
20090110 List Copy Next does not copy all settings			FIXED
20090110 May need messages to give feedback to command failures		CONSTRAINT
20090110 List FunctC on RWC causes corruption				FIXED
20090110 Assigning CommandH does not init Pattern(may need common REST value)	FIXED
20090110 CTRLX in Pattern CommandH does not plot Command Rests(see above)	FIXED
20090110 Nav Right into CommandH:command descript delayed			FIXED
20090110 Add Pattern "8","9" Keys for extended octave range			FIXED
20090110 Set default Grabbed Pattern data				FIXED
20090110 Pattern Bar command not coded					FIXED
20090110 Pattern CTRLA not working					REMOVED
20090110 Pattern Paste Merge corrupts Patterns				FIXED
20090110 Inversed T appearing in Menu to left of Channels			FIXED
20090110 No Pattern Command to Set Command/s in H				FIXED
20090110 Patterns Funct Up/Down should only move Pattern Entry(not row)	FIXED
20090110 showing CommandH affected Tracks is wrong (showed G for Track B)	FIXED
20090110 Need to group Keys in Help					FIXED
20090110 Need to speed up display in Help				CONSTRAINT
20090110 SFX Copy Last is Wrong					FIXED
20090110 Shorten SFX "Infinite loop/s" text, overwrites Grabbed		FIXED
20090110 Esc from file help editor crashes system				FIXED
20090112 Lookup for Pattern Command H Is wrong				FIXED
20090112 Show Play progression in List/Pattern and possibly SFX		FIXED
20090112 Jumping to Files initially sometimes corrupts first? filename	FIXED
20090112 Ensure Music and sfx is not playing when sfx is modified		FIXED
20090112 Return has stopped working in Files(fnLoad)			FIXED
20090113 List command grab/drop should work individual tracks if not RWC row	FIXED
20090113 Need List command to stop&silence music				FIXED
20090113 Need Pattern command to stop&silence music			FIXED
20090113 Need SFX command to stop&silence music				FIXED
20090113 List RWC SFX Rate not making a difference			FIXED
20090113 Change "DIGI RATE" to "MUSIC IRQ" and "SFX RATE" to "SFX IRQ"	FIXED
20090113 List RWC SFX Behaviour Flag not coded				FIXED
20090113 List RWC Octaves should be limited to 5 ranges (0-4,1-5,2-6,3-7,4-8)	FIXED
20090113 Add new RWC for SHARING IRQ and RESOLUTIONS IRQ?			FIXED
20090115 SFX Play stopped working(Volume shows 16!)			FIXED
20090116 Need List Command To Toggle Blue Cursor Row			FIXED
20090116 SFX Play not sounding(SFX Validation seems dependant on play state)	FIXED
20090117 63 appearing as C- in Pattern Index				FIXED
20090117 Need Key to toggle blue row in Pattern Editor			FIXED
20090117 Blue row in pattern appearing two rows above cursor		FIXED
20090117 RWC Octave should be changed to RWC Note Offsets			FIXED
20090117 Play Monitor Displays Inverse on row when in Help Editor		FIXED
20090117 SFX Inc/Dec Loop reversed again(And showing blank sometimes)		FIXED
20090117 List Octave RWC occasionally allows jump to strange pattern config	FIXED
20090117 By not linking SFX to Pats and List means we can jump from sfx to pats DISMISSED
20090118 SFX Naming edits in wrong place				FIXED
20090118 First Note of Pattern plays wrong note (or could be remaining notes)	FIXED
20090118 If read dir returns less files than cursor, cursor sits on empty entry	FIXED
20090118 Playing pattern from List or Pattern does not track from song start	FIXED
20090119 Del in List Track entry should act like pattern setting entry to Rest	CONSTRAINT
20090120 some loops in SFX are not permitting exit but still report valid sfx	FIXED
20090120 increase mimic Time delay by delaying history capture/store?		FIXED
20090121 When entering Notes on Rests always enters C,should enter Note pressed	FIXED
20090121 Combining pitchbend with mimic slows play,eventual crash and wrong dir	FIXED
20090125 Pitchbend with mimic sending note down rather than up		FIXED
20090125 repeating play of pattern suddenly sets IRQ to 1F4 and freezes	FIXED
20090125 The sfx name in pattern editor is always for the first sfx only	FIXED
20090125 SFX Editor doesn't permit CTRL-D on row 00			FIXED
20090125 SFX Filter not implemented					FIXED
20090125 SFX Keys show a bit messed up around Counter command		FIXED
20090126 SFX Displayed(and possibly played) in sfx ed does not include offset	FIXED
20090126 Type shown in File editor status is corrupt			FIXED
20090126 CTRL I/CTRL D in SFX cuts not with END SFX			FIXED
20090126 Change Pattern Volume for EG Track to EG Wave			FIXED
20090127 Last/Next Entry only working on Track A				FIXED
20090201 List Loop is not working(Corrupts sound)				FIXED
20090201 Shift Return in List Editor not always plays current Song(alt)
20090205 Raised res Pattern view of EG or Noise should show 0-15(is play too?)	FIXED
20090206 When 3 tracks playing Track 4 shows same as 3(should be inactive)	FIXED
20090207 Play Pattern Not picking up song events until song played
20090207 Noise Track: Effect not doing anything				FIXED
20090207 If possible add music kbd using R-P and make optional sequencer

20090208 Explicitly playing Wave does not write register			FIXED
20090210 Noise and EG SS Real Channel mix is incorrect			FIXED
20090211 Tone Switch in SFX is not on correct Channel for SS		FIXED
20090211 Tone switch is back to front in player				FIXED
20090211 Default filter should be music					FIXED
20090211 Grabbed Pattern entry does not observe vol hires
20090211 Need auto assign for individual track				FIXED
20090212 Need Pattern command to grab/drop individual sfx/volume field	FIXED
20090212 Need List command to play from cursor onwards			FIXED
20090212 jsr "Shift S" before play song					FIXED
20090214 Should be allowed to ins/del multiple columns thru highlighting	FIXED
20090214 Problem pasting multiple columns beyond bottom row			FIXED
20090214 Add transpose option in highlighting area			FIXED
20090214 Pattern/List Home/End should be page up/down(16) instead		FIXED
20090214 SFX:Since filter must be in loop no need for FILTER OFF		FIXED
20090214 Need command to assign next unused sfx

20090214 SFX name shown in pattern should not appear if rest or vrst or bar
20090215 Pitchbending EG or Noise should act directly on value		FIXED
20090220 Pitchbend method is slow					FIXED
20090220 Need to sort out Command Track H to expand com range to full 16	FIXED
20090220 The default channel spread should be none for Pitchbend		FIXED
20090220 Remove Pattern Toggle key(replace with EG Period command)		FIXED
20090220 Optimise Play routine by using 256 Byte Note tables(or maybe 96x2)
20090220 Remove Menu, Play, Song options and replace with help bar/music kbd?	FIXED
20090221 Assigning Track H as Command should also assign new Track		FIXED
20090221 Prevent setting SS in List beyond 19 (Then remove SPARE texts)	FIXED
20090221 Remove code and checks for DVS					FIXED
20090221 Prevent jumping to non existant Pattern combo from SFX
20090221 Rewrite Song Tracking and replace into all areas
20090221 Add List key to Clear out Pattern in Track(or do so with auto assign)
20090221 Grabbing Rest or Bar in Pattern grabs note equiv
20090221 ESC should be Help Page					FIXED
20090221 special key in help should quit app				FIXED
20090221 Prohibit inc/dec/del of Command Track H Command ID			FIXED
20090221 Add new Pattern keys for EG cycle and EG Period			FIXED
20090221 Sort out contextual text for new Command H format in Patterns	FIXED
20090221 Need new RWC for Noise/EG Off/Tone				CONSTRAINT
20090221 Track Pattern cursor appears regardless of pattern			CONSTRAINT
20090222 Add List key to clear out Music(Or permit Highlight to be DEL)
20090225 Loading a new piece should always go to first entry in list
20090228 Status line of Effect gets corrupted
20090228 Effect not playing in effect editor
20090228 Delete & CTRL X key should work in Effect Editor			FIXED
20090228 Highlighting does not inverse List RWC rows			FIXED
20090228 Entering Pattern should at least place cursor on active pattern	FIXED
20090303 FUNC C should toggle Command Track existance			FIXED

