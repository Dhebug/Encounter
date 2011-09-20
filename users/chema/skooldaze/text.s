;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; -----------------------------------
;;            Skool Daze
;;         The Oric Version
;; -----------------------------------
;;			(c) Chema 2011
;;         enguita@gmail.com
;; -----------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Text strings
;; --------------------


__text_start

names_extras
	.asc "        "
empty_st
	.byt 0
st_char_names
	.asc "ERIC"
	.byt 0
	.dsb 9,0
	.asc "EINSTEIN"
	.byt 0
	.dsb 5,0
	.asc "ANGELFACE"
	.byt 0
	.dsb 4,0
	.asc "BOY WANDER"
	.byt 0
	.dsb 3,0
st_teacher_names
	.asc "MR ROCKITT"
	.byt 0
	.dsb 3,0
	.asc "MR WACKER"
	.byt 0
	.dsb 4,0
	.asc "MR WITHIT"
	.byt 0
	.dsb 4,0
	.asc "MR CREAK"
	.byt 0
	.dsb 5,0
	.asc "Please Sir - I cannot tell a lie . . "
	.byt 0
	.asc "REVISION"
	.byt 0
number_template
	.byt "000",0
number_question
	.byt "12 X 32",0
number_answer
	.byt "1234",0

class_names
	.asc "READING ROOM"
	.byt 0
	.asc "MAP ROOM"
	.byt 0
	.asc "WHITE ROOM"
	.byt 0
	.asc "EXAM ROOM"
	.byt 0
	.asc "LIBRARY"
	.byt 0
	.asc "DINNER"
	.byt 0
	.asc "PLAYTIME"
	.byt 0

demo_msg
	.asc "DEMO - PRESS"
	.byt 0
demo_msg2
	.asc "KEY TO PLAY"
	.byt 0

end_game_wacker
	.asc "YOU HAVE OVER 10000 LINES TO WRITE ", ERIC_NAME,". "
	.asc "DON'T COME BACK TO SCHOOL TILL YOU HAVE DONE THEM ALL... "
	.asc "PRESS A KEY TO PLAY AGAIN", SPACES_8,0

end_game_rockitt
	.asc "You have mumps ", ERIC_NAME,". Go home at once. This game is over"
	.asc SPACES_8,0
	
st_grass
	.asc PLEASESIR,ERIC_NAME," is not here", SPACES_8,0
st_hitme
	.asc PLEASESIR,ERIC_NAME," hit me", SPACES_8,0
st_bboard
	.asc PLEASESIR,ERIC_NAME," wrote on the blackboard", SPACES_8,0

reprimands
	.asc "DON'T SIT ON",0, "THE STAIRS",0 
	.asc "THE ROOM",0, "IS PRIVATE",0 
	.asc "GET TO WHERE",0, "YOU SHOULD BE",0 
	.asc "NOW FIND",0, "A SEAT",0 
	.asc "GET OFF",0, "THE FLOOR",0 
	.asc "COME ALONG",0, "WITH ME BOY",0 
	.asc "HURRY UP",0, "YOU HORROR",0 
	.asc "DON'T TRY MY",0, "PATIENCE BOY",0 
	.asc "NOW DON'T",0, "DO IT AGAIN",0 
	.asc "DON'T TELL",0, "TALES",0 
	.asc "NEVER BE",0, "LATE AGAIN",0 
	.asc "AND STAY",0, "THIS TIME",0 
	.asc "DON'T TOUCH",0, "BLACKBOARDS",0 
	.asc "CATAPULTS",0, "ARE FORBIDDEN",0 
	.asc "DON'T HIT",0, "YOUR MATES",0 
	.asc "YOU ARE NOT",0, "A KANGAROO",0 
reprimand_2000
	.asc "TAKE 2000 LINES YOU NASTY BOY",SPACES_8,0 

st_lines
	.asc "000 lines"
	.byt 0

sit_messages
	.asc "RIGHT! SIT DOWN MY LITTLE CHERUBS"
	.byt SPACES_8
	.byt 0
	.asc "COME ON CHAPS - SETTLE DOWN"
	.byt SPACES_8
	.byt 0
	.asc "BE QUIET AND SEATED YOU NASTY LITTLE BOYS"
	.byt SPACES_8
	.byt 0
	.asc "SILENCE! OR I'LL CANE THE LOT OF YOU"
	.byt SPACES_8
	.byt 0

class_messages
st_write_essay
	.byt "WRITE AN ESSAY WITH THIS TITLE"
	.byt SPACES_8
	.byt 0
st_page_book
	.byt "TURN TO PAGE "
	.byt NUM_TEMPLATE
	.byt " OF YOUR BOOKS, BE SILENT AND START READING"
	.byt SPACES_8
	.byt 0
st_question_book
	.byt "ANSWER THE QUESTIONS ON PAGE "
	.byt NUM_TEMPLATE
	.byt " OF YOUR LOVELY TEXTBOOK"
	.byt SPACES_8
	.byt 0

st_chemical_name
	.asc "Tin",0
	.asc "Mercury",0
	.asc "Gold",0
	.asc "Silver",0
	.asc "Platinum",0
	.asc "Copper",0
	.asc "Magnesium",0
	.asc "Lead",0
	.asc "Manganese",0
	.asc "Antimony",0
	.asc "Arsenic",0
	.asc "Potassium",0
	.asc "Sodium",0
	.asc "Chlorine",0
	.asc "Zinc",0
	.asc "Tungsten",0
	.asc "Caesium",0
	.asc "Silicon",0
	.asc "Phosphorus",0
	.asc "Bromine",0
	.asc "Hyrogen",0
st_chemical_sym
	.asc "Sn",0
	.asc "Hg",0
	.asc "Au",0
	.asc "Ag",0
	.asc "Pt",0
	.asc "Cu",0
	.asc "Mg",0
	.asc "Pb",0
	.asc "Mn",0
	.asc "Sb",0
	.asc "As",0
	.asc "K",0
	.asc "Na",0
	.asc "Cl",0
	.asc "Zn",0
	.asc "W",0
	.asc "Cs",0
	.asc "Si",0
	.asc "P",0
	.asc "Br",0
	.asc "H",0

st_capitals
	.asc "Berne",0       
	.asc "Helsinki",0    
	.asc "Reykjavik",0   
	.asc "Budapest",0
	.asc "Bucharest",0  
	.asc "Tirana",0 
	.asc "Jakarta",0    
	.asc "Pyongyang",0   
	.asc "Vientiane",0   
	.asc "Islamabad",0   
	.asc "Rangoon",0     
	.asc "Ankara",0      	
	.asc "Amman",0       
	.asc "Gabarone",0    
	.asc "Lusaka",0      
	.asc "Monrovia",0    
	.asc "La Paz",0      
	.asc "Caracas",0     
	.asc "Quito",0       
	.asc "Paramaribo",0  
	.asc "Santiago",0    

st_countries
	.asc "Switzerland",0
	.asc "Finland",0
	.asc "Iceland",0     
	.asc "Hungary",0     
	.asc "Romania",0     
	.asc "Albania",0     
	.asc "Indonesia",0   
	.asc "North Korea",0 
	.asc "Laos",0        
	.asc "Pakistan",0    
	.asc "Burma",0       
	.asc "Turkey",0      
	.asc "Jordan",0      
	.asc "Botswana",0    
	.asc "Zambia",0      
	.asc "Liberia",0     
	.asc "Bolivia",0     
	.asc "Venezuela",0   
	.asc "Ecuador",0     
	.asc "Surinam",0     
	.asc "Chile",0       

st_years
	.asc "1066",0       
	.asc "1265",0       
	.asc "1314",0       
	.asc "1346",0       
	.asc "1356",0       
	.asc "1403",0       
	.asc "1415",0       
	.asc "1485",0       
	.asc "1513",0       
	.asc "1571",0       
	.asc "1014",0       
	.asc "1685",0       
	.asc "1746",0       
	.asc "1775",0       
	.asc "1781",0       
	.asc "1805",0       
	.asc "1815",0       
	.asc "1812",0       
	.asc "1836",0       
	.asc "1863",0       
	.asc "1854",0       
st_battles
	.asc "Hastings",0   
	.asc "Evesham",0    
	.asc "Bannockburn",0
	.asc "Crecy",0      
	.asc "Poitiers",0   
	.asc "Shrewsbury",0 
	.asc "Agincourt",0  
	.asc "Bosworth",0   
	.asc "Flodden",0    
	.asc "Lepanto",0    
	.asc "Clontarf",0   
	.asc "Sedgemoor",0  
	.asc "Culloden",0   
	.asc "Lexington",0  
	.asc "Yorktown",0   
	.asc "Trafalgar",0  
	.asc "Waterloo",0   
	.asc "Borodino",0   
	.asc "San Jacinto",0
	.asc "Gettysburg",0 
	.asc "Balaclava",0  

st_questions
	.asc "WHAT IS ", MUL_QUESTION, "?", SPACES_8,0
	.asc "WHAT ELEMENT HAS THE SYMBOL ",TEMPLATE_QUESTION, "?",SPACES_8,0
	.asc "WHAT IS THE CHEMICAL SYMBOL FOR ",TEMPLATE_QUESTION,"?",SPACES_8,0
	.asc "WHAT'S THE CAPITAL OF ",TEMPLATE_QUESTION,"?",SPACES_8,0
	.asc "WHICH COUNTRY'S CAPITAL IS ",TEMPLATE_QUESTION,"?",SPACES_8,0
	.asc "WHEN WAS THE BATTLE OF ",TEMPLATE_QUESTION,"?",SPACES_8,0
	.asc "WHICH BATTLE OCCURRED IN ",TEMPLATE_QUESTION,"?",SPACES_8,0
st_q_batt
	.asc "WHAT HAPPENED IN THE YEAR THAT I WAS BORN?", SPACES_8,0
st_ans
	.asc PLEASESIR, "It's ", MUL_ANSWER, SPACES_8,0
 	.asc PLEASESIR, "It is ", TEMPLATE_ANSWER, SPACES_8,0
	.asc PLEASESIR, "It was in ", TEMPLATE_ANSWER, SPACES_8,0
st_ans_batt
	.asc PLEASESIR, "It was the BATTLE OF ", TEMPLATE_ANSWER, SPACES_8,0

st_bwboard
	.asc "i hate",NEWLINE,"fizziks",0
	.asc "i hate sums",0
	.asc "skool rools",NEWLINE,"o k",0
	.asc "i hate skool",0
	.asc "speling iz",NEWLINE,"boaring",0
	.asc "i love",NEWLINE,"SPACE:1999",0
	.asc "1337",NEWLINE,"is grate",0 
	.asc "skool dinners",NEWLINE,"are orrible",0
st_teachboard
	.asc "Industrial",NEWLINE,"Revolution",0
	.asc "The Norman",NEWLINE,"Conquest",0
	.asc "The Wars of",NEWLINE,"the Roses",0
	.asc "The Spanish",NEWLINE,"Armada",0
	.asc "The First",NEWLINE,"Crusade",0
	.asc "Magna Carta",0
	.asc "The Boston",NEWLINE,"Tea Party",0
	.asc "The Black",NEWLINE,"Death",0

	.asc "The Periodic",NEWLINE,"Table",0
	.asc "Splitting",NEWLINE,"The Atom",0
	.asc "Explosions I",NEWLINE,"have known",0
	.asc "How to blow",NEWLINE,"yourself up",0
	.asc "Things to do",NEWLINE,"with TNT",0
	.asc "Chemistry",NEWLINE,"of dynamite",0
	.asc "First aid",NEWLINE,"for chemists",0
	.asc "Fast ways to",NEWLINE,"open doors",0

	.asc "THE 47 TIMES",NEWLINE,"TABLE",0
	.asc "QUADRATIC",NEWLINE,"EQUATIONS",0
	.asc "WHY SUMS ARE",NEWLINE,"FUN",0
	.asc "VECTORS AND",NEWLINE,"MATRICES",0
	.asc "ISOSCELES",NEWLINE,"TRIANGLES",0
	.asc "PYTHAGORAS",NEWLINE,"THEOREM",0
	.asc "FACTORS",0
	.asc "THE AREA OF",NEWLINE,"A CIRCLE",0

	.asc "MANCHESTER",NEWLINE,"MONSOONS",0
	.asc "THE CLIMATE",NEWLINE,"OF CLAPHAM",0
	.asc "THE PEAKS",NEWLINE,"OF PERU",0
	.asc "THE GLASGOW",NEWLINE,"RAIN-FOREST",0
	.asc "THE EXPORTS",NEWLINE,"OF FIJI",0
	.asc "ACTIVE",NEWLINE,"VOLCANOES",0
	.asc "POP MUSIC IN",NEWLINE,"ANTARCTICA",0
	.asc "THE UPLANDS",NEWLINE,"OF RUTLAND",0


st_mumps
	.asc "Don't let ", ANG_NAME, " touch you this playtime - He's got mumps", SPACES_8,0
st_einstein
	.asc EINST_NAME, " is going to tell ",WACKER_NAME, " what you're up to. "
	.asc "You must stop him getting to his study this break", SPACES_8,0
st_peashooter
	.asc BOYW_NAME, " has hidden a pea-shooter with your name on it on the fire-escape."
	.asc " If ", WACKER_NAME, " gets there before ", BOYW_NAME, " you'll get lines", SPACES_8,0

st_pressU
	.asc "Press 'U' if you understood", SPACES_8,0

st_safeletter
	.byt 0,0
st_space
	.asc " ",0

st_putnames
	.asc "Do you want to put in your own names Y/N?",0
st_castof
	.asc "CAST OF CHARACTERS",0
st_pressc
	.asc "PRESS 'C' TO CHANGE NAME",0
st_entername 
	.asc "ENTER NEW NAME",0
st_casttitles
	.asc "OUR HERO",0
	.asc "THE SWOT",0
	.asc "THE BULLY",0
	.asc "THE TEARAWAY",0
	.asc "TEACHER",0
	.asc "HEADMASTER",0
	.asc "TEACHER",0
	.asc "MASTER",0 
st_casttitles2
	.asc "THE SCIENCE",0 
	.asc "THE",0 
	.asc "THE GEOGRAPHY",0 
	.asc "THE HISTORY",0 

st_gamefinished
	.asc "WELL DONE! GO",0
st_gamefinished2
	.asc "UP A YEAR,0
__text_end

#echo **** Text:
#print (__text_end-__text_start)

