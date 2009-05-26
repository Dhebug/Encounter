__texts_start

//#define FRENCH_VERSION
#ifndef FRENCH_VERSION

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Game texts...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Object descriptions
; Tiles with SPECIAL set
infopost  
    .asc "Information post"
    .byt 0
alien_plant
    .asc "Alien plant"
    .byt 0
meds_lab
    .asc "Medicine synthesizer"
    .byt 0
benes_name
    .asc "Sandra Benes"
    .byt 0
control_name
    .asc "Door control unit"
    .byt 0
circuit_name
    .asc "Main circuit"
    .byt 0
monitor_name
    .asc "Computer monitor"
    .byt 0
passcode_name
    .asc "Passcode: "
    .byt 0
Berg_pass     
    .byt A_FWGREEN
    .asc "Bergman Quarter"
    .byt 0
Crew_pass     
    .byt A_FWGREEN
    .asc "Crew Quarters"
    .byt 0
Pool_pass 
    .byt A_FWGREEN
    .asc "Pool"
    .byt 0    
Storage_pass  
    .byt A_FWGREEN
    .asc "Storage area"
    .byt 0
Power_pass
    .byt A_FWGREEN
    .asc "Power room"
    .byt 0    
Hyd_pass  
    .byt A_FWGREEN
    .asc "Hydroponics Quarantine"
    .byt 0    
Door_ctrl_pass
    .byt A_FWGREEN
    .asc "Door control"
    .byt 0
no_commlock_pass
    .asc "You need a commlock to get it"
    .byt 0

; Not in passcode bytes
benes_qtr
    .byt A_FWGREEN
    .asc "Benes Quarter"
    .byt 0

morrow_qtr
    .byt A_FWGREEN
    .asc "Morrows Quarter"
    .byt 0

h_general
    .byt A_FWGREEN
    .asc "Russel General"
    .byt 0

k_general
    .byt A_FWGREEN
    .asc "Koenig General"
    .byt 0


; Objects
Koenig_name
    .asc "John Koenig"
    .byt 0

Helena_name
    .asc "Helena Russel"
    .byt 0

Commlink_name
    .asc "Commlock (Koenig)"
    .byt 0

CommlinkH_name
    .asc "Commlock (Russel)"
    .byt 0


Medkit_name
    .asc "Medkit"
    .byt 0
Notepad_name
    .asc "Notepad"
    .byt 0
Battery_name
    .asc "Battery"
    .byt 0
plantjuice_name
    .asc "Vial of plantjuice"
    .byt 0
compound_name
    .asc "Medicine for Benes"
    .byt 0

key_name
    .asc "Key"
    .byt 0

relay_name
    .asc "Red Relay from Herring Electronics"
    .byt 0

resistor_name
    .asc "Resistor"
    .byt 0

chip_name
    .asc "Memory chip"
    .byt 0

fuse_name
    .asc "Fuse"
    .byt 0
inductor_name
    .asc "Inductor"
    .byt 0
screwdriver_name
    .asc "Screwdriver"
    .byt 0
wire_name
    .asc "Coil of wire"
    .byt 0
oil_name
    .asc "Olive oil"
    .byt 0

;Chair_name was here

zx81_name
    .asc "ZX81 cleaning robot"
    .byt 0
No_name
    .asc "No item selected"
    .byt 0


; Messages from characters

Helena_comlock
    .byt "Helena:"
    .byt 0
Helena_1
    .byt A_FWGREEN
    .asc "John, I need your help in meds."
    .byt 0
Helena_2
    .byt A_FWGREEN
    .asc "Let's share our passcodes."
    .byt 0
Helena_3
    .byt A_FWGREEN
    .asc "Hurry up, John."
    .byt 0

key
    .byt A_FWRED
    .asc "            (KEY)"   
    .byt 0

Helena_spch_1
    .byt 6
    .asc "Benes is critically ill. I can treat"
    .byt 0
    .asc "her, but I need an ingredient that"
    .byt 0
    .asc "can only be extracted from an alien"
    .byt 0
    .asc "plant, and the notebook from my room."
    .byt 0
    .asc "The plant can be found in"
    .byt 0
    .asc "hydroponics, isolated in quarantine."
    .byt 0
Helena_spch_2
    .byt 3
    .asc "Thank you, John."
    .byt 0
    .asc "I need to get back to my laboratory" 
    .byt 0
    .asc "to prepare the medicine."
    .byt 0

Benes_spch_1a
    .byt 7
    .asc "Enabling power is twofold, you must"
    .byt 0
    .asc "first fix the generator and then the"
    .byt 0
    .asc "computer. I had actually fixed the"
    .byt 0
    .asc "generator, but the circuit I built"
    .byt 0
    .asc "was not strong enough and blew up in"
    .byt 0
    .asc "my face. The circuit... Paul... "
    .byt 0
    .asc "... passcode..."
    .byt 0

Benes_uncon
    .asc "Benes in unconscious"
    .byt 0

Benes_awake
    .asc "Commlock signal: Benes is awake."
    .byt 0

Benes_intro
    .asc "Benes opens her eyes and tries to"
    .byt 13
    .asc "speak:"
    .byt 0

Benes_end
    .asc "She falls back into unconsciousness."
    .byt 0

Benes_spch_2
    .byt 5
    .asc "To fix the computer you have to"
    .byt 0
    .asc "replace the control circuit."
    .byt 0
    .asc "You can use one from the Life"
    .byt 0
    .asc "Support control... my passcode..."
    .byt 0
    .asc "be careful... open circuit..."
    .byt 0

Koenig_spch_1
    .byt 2
    .asc "Go and prepare the medicine."
    .byt 0
    .asc "I will take care of Benes."
    .byt 0

restore_power_msg
    .byt 3
    .asc "We need to get power restored with" 
    .byt 0
    .asc "the circtuit Sandra suggested."
    .byt 0
    .asc "She also mentioned Paul..."
    .byt 0

restore_comp_msg
    .byt 3
    .asc "We need to get the computer repaired"
    .byt 0
    .asc "as Sandra suggested. But there was a "
    .byt 0
    .asc "danger..."
    .byt 0

pauls_list_msg
    .asc "The screen shows the design of a"
    .byt 13
    .asc "simple circuit along with some"
    .byt 13 
    .asc "kind of list:"
    .byt 13
    .byt "Ba:HYP, In:APH, Re:HSI"
    .byt 0

; Game messages
alarm_pwr_msg
    .asc "WARNING: Power system failing"
    .byt 0
gameover_msg
    .asc "GAME OVER"
    .byt 0
gamefinished_msg
    .asc "MISSION ACCOMPLISHED"
    .byt 0
helenadead_msg
    .asc "Dr. Russell dies"
    .byt 0
koenigdead_msg
    .asc "Commander Koenig dies"
    .byt 0
benesdead_msg
    .asc "Sandra Benes dies"
    .byt 0
lowpower_msg
    .byt 1
    .asc "WARNING: Power low!"
    .byt 0
lowlifesup_msg
    .byt 1
    .asc "WARNING: Life support systems low!"
    .byt 0
cannottake_msg
    .asc "Can not take that"
    .byt 0
cantdrop_msg
    .asc "Can not drop it here"
    .byt 0
no_space_inv
    .asc "Can not take more objects"
    .byt 0
cantopendoor
    .asc "The door is locked"
    .byt 0
door_jammed
    .asc "This door is jammed..."
    .byt 0
lubricate_door_msg
    .asc "You lubricate the door with oil"
    .byt 0
bergmandoor_msg
    .asc "A sign says: Dr. Bergman"
    .byt 0
keynofits_msg
    .asc "This key does not fit in this door"
    .byt 0
keyfits_msg
    .asc "You open the door with the key"
    .byt 0
unpowered_msg
    .asc " (unpowered)"
    .byt 0
powered_msg
    .asc " (working)"
    .byt 0
newpass_msg
    .asc "New passcode downloaded in commlock"
    .byt 0
plant_taken_msg
    .asc "You already got enough juice"
    .byt 0
plant_taking_msg
    .asc "You take a vial of juice"
    .byt 0
create_medicine_msg
    .asc "You create a medicine for Benes"
    .byt 0
dont_know_msg
    .asc "I do not know how to use this"
    .byt 0

;notnow_msg
;    .asc "Better not... yet"
;    .byt 0

need_pass
    .asc "You need a passcode to operate this"
    .byt 0

missing_notepad_msg
    .asc "I need my notes to prepare the"
    .byt 13
    .asc "medicine"
    .byt 0

cure_koenig_msg
    .asc "You cure Koenig"
    .byt 0

door_ctrlo_msg
    .asc "A red light lits"
    .byt 0

door_ctrlc_msg
    .asc "The red light turns off"
    .byt 0

wrong_panel_msg
    .asc "Cannnot use it here"
    .byt 0
needcircuit_msg
    .asc "Don't know the circuit to build"
    .byt 0
place_item_msg
    .asc "You place the item in the circuit"
    .byt 0
wrong_item_msg
    .asc "This item does not fit in the circuit"
    .byt 0
power_repaired_msg
    .asc "Power working... now the computer"
    .byt 0
no_screwdriver_msg
    .asc "Can not get the chip out without"
    .byt 13
    .asc "a proper tool"
    .byt 0
burntout_chip_msg
    .asc "There is a burnt out chip here"
    .byt 0
get_chip_msg
    .asc "You take out the chip out of"
    .byt 13
    .asc "the socket"
    .byt 0
already_fixed_msg
    .asc "Better not touch it, now it is"
    .byt 13
    .asc "working"
    .byt 0
place_chip_msg
    .asc "You replace the burnt out chip"
    .byt 13
;power_restored_msg
    .asc "You restored power to Alpha"
    .byt 13
    .asc "Well done!!!"
    .byt 0
ls_fail_msg
    .asc "You open a vital circuit!"
    .byt 0
ls_back_msg
    .asc "Life support is back working"
    .byt 0
ls_bypassed_msg
    .asc "You create an electrical bypass and" 
    .byt 13
    .asc "the danger ends"
    .byt 0
put_fuse_msg
    .asc "You replace the broken fuse"
    .byt 0
not_fuse_msg
    .asc "The Synthesizer seems to be broken..."
    .byt 13
    .asc "no lights turn on."
    .byt 13
    .asc "Maybe it is easy to fix..."
    .byt 0
;no_fix_msg
;    .asc "Cannot fix it with this..."
;    .byt 0
no_medicine_msg
    .asc "Cannot create a medicine"
    .byt 13
    .asc "with this"
    .byt 0

hundred_msg
    .asc "100"
    .byt 0
percent_msg
    .asc " percent"
    .byt 0
infopost_menu_msg
    .asc " "
    .byt A_FWGREEN
    .asc "Save game        "    ; 17 chars
    .asc "  "
    .asc "Passcodes       "     ; 16 chars
    .byt 32,13
    .asc " "
    .byt A_FWGREEN
    .asc "Restore game     "
    .asc "  "
    .asc "Sound Volume    "
    .byt 32,13
    .asc " "
    .byt A_FWGREEN
    .asc "Alpha Status     "
    .asc "  "
    .asc "Game progress   "
    .byt 32,13
    .asc " "
    .byt A_FWGREEN
    .asc "Cinema           "
    .asc "  "
    .asc "Exit            "
    .byt 32,0

gamesaved_msg
    .asc "Game saved"
    .byt 0
gamerestored_msg
    .asc "Game restored"
    .byt 0
sure_to_save_msg
    .asc "Press CTRL to save game"
    .byt 0
sure_to_restore_msg
    .asc "Press CTRL to restore saved game"
    .byt 0
anykey_msg
    .asc "ESC to skip"
    .byt 0
abort_msg
    .asc "Skipped"
    .byt 0
invalidsave_msg
    .asc "Invalid savepoint"
    .byt 0

infopost_start
    .byt A_FWYELLOW
    .asc "       Alpha Information Post"
    .byt 0
infopower_msg
    .byt A_FWGREEN
    .asc " Power Status: "
    .byt 0
infols_msg
    .byt A_FWGREEN
    .asc " Life Support: "
    .byt 0

info_tv_intro
    .byt A_FWGREEN
    .asc "On this week:"
    .byt 0
tv_1_msg
    .byt A_FWGREEN
    .asc " Star Trek III: The Search for Spock"
    .byt 0
tv_2_msg
    .byt A_FWGREEN
    .asc " The Thunderbirds"
    .byt 0
tv_3_msg
    .byt A_FWGREEN
    .asc " 2001: A Space Odyssey"
    .byt 0
tv_4_msg
    .byt A_FWGREEN
    .asc " Mission:Impossible"
    .byt 0


toggle_msg  
    .asc "Now controlling "
    .byt 0
can_toggle_msg
    .asc "You can switch characters now"
    .byt 0
cant_toggle_msg
    .asc "Can not switch characters now"
    .byt 0
cant_toggle_msg2
    .asc "Not while there is an open door"
    .byt 0



; Lifts
lift_speech  
    .asc "Select level: "
    .byt 0 
liftno_msg
    .asc "Lifts unpowered"
    .byt 0

; Room names
main_mission_name
    .asc "  Main Mission  "
    .byt 0
corridor_name
    .asc "    Corridor    "
    .byt 0

command_room_name
    .asc "  Command Room  "
    .byt 0
koenig_quart_name
    .asc "  Koenig Quart. "
    .byt 0
russel_quart_name
    .asc " Russell Quart. "
    .byt 0

benes_quart_name
    .asc "  Benes Quart.  "
    .byt 0

bergman_quart_name
    .asc " Bergman Quart. "
    .byt 0

morrow_quart_name
    .asc " Morrow Quart.  "
    .byt 0

hisec_name
    .asc "Hi-Sec Isolation"
    .byt 0

security_name
    .asc "    Security    "
    .byt 0

life_support_name
    .asc "  Life Support  "
    .byt 0

meds_lab_name
    .asc "  Medical Labs  "
    .byt 0

astro_name
    .asc "  Astrophysics  "
    .byt 0

power_name
    .asc "   Power Room   "
    .byt 0

computer_name
    .asc " Computer Room  "
    .byt 0

storage_name
    .asc "    Storage     "
    .byt 0

chem_lab_name
    .asc " Chemical Labs  "
    .byt 0

research_name
    .asc " Research Labs  "
    .byt 0

meds_name
    .asc "  Medical Wing  "
    .byt 0

dining_name
    .asc "     Dining     "
    .byt 0

lounge_name
    .asc "     Lounge     "
    .byt 0

quarters_name
    .asc " Crew Quarters  "
    .byt 0

leisure_name
    .asc "  Leisure Area  "
    .byt 0

hydroponics_name
    .asc "  Hydroponics   "
    .byt 0

;; For floor names
levelH_name
    .asc "Level H        "
    .byt 0

levelG_name
    .asc "Level G        "
    .byt 0

levelCTRL_name
    .asc "Control Systems"
    .byt 0

levelMM_name
    .asc "Main Mission   "
    .byt 0

version_name
    .asc " ESC to start  "
    .byt 0


; Sound setting
sound_menu_txt
    .asc "Select level: "
    .byt 0
sound_high_name
    .asc "Disturb neighbours"
    .byt 0
sound_med_name
    .asc "Nice background   "
    .byt 0
sound_low_name
    .asc "Got a headache    "
    .byt 0
sound_off_name
    .asc "Late at night     "
    .byt 0

infoprogress_msg
    .asc "You have solved a "
    .byt 0



end_speech1_msg
    .asc "Helena: Radiation level safe."
    .byt 13
    .asc "Danger has passed John..."
    .byt 0

end_speech2_msg
    .asc "Koenig: Systems working..."
    .byt 13
    .asc "It was close this time..."
    .byt 0

end_speech3_msg
    .asc "Koenig: Computer, unseal lower levels."
    .byt 13
    .asc "Let's bring the Alphans back!"
    .byt 0 


; For key mapping
keylist_msg
    .byt A_FWGREEN
    .asc "             Game Keys"
    .byt 13
    .asc "    M   Forward   B    Backwards"
    .byt 13
    .asc "    Z,X Turn      CTRL Get, use"
    .byt 13
    .asc "    ESC Drop      -,=  Object select"
    .byt 13
    .asc "    T Toggle character"
    .byt 0

; For initial scroller
; 23 characters max per line
; this   "                       "

scroll_text
    .byt 92 ; Number of lines
    .asc " "
    .byt 0
    .asc " "
    .byt 0
    .asc " "
    .byt 0
    .asc " "
    .byt 0
    .asc "The runaway moon... the"
    .byt 0
    .asc "castaways of Moonbase"
    .byt 0
    .asc "Alpha... hurtling"
    .byt 0
    .asc "across space, blasted"
    .byt 0
    .asc "from the Earth's orbit"
    .byt 0
    .asc "by a nuclear explosion,"
    .byt 0
    .asc "far far from the solar"
    .byt 0
    .asc "system."
    .byt 0
    .asc " "
    .byt 0
    .asc "They wayward journey"
    .byt 0
    .asc "through the universe,"
    .byt 0 
    .asc "takes them towards an"
    .byt 0
    .asc "unknown energy field"
    .byt 0
    .asc "which threatens their"
    .byt 0
    .asc "existance. Enormous"
    .byt 0
    .asc "radiation has affected"
    .byt 0
    .asc "their power system and"
    .byt 0
    .asc "all personnel has been"
    .byt 0
    .asc "evacuated to the more"
    .byt 0
    .asc "secure underground"
    .byt 0
    .asc "levels of the base."
    .byt 0
    .asc " "
    .byt 0
    .asc "All but Commander John"
    .byt 0
    .asc "Koenig, who will risk"
    .byt 0
    .asc "his life to repair the"
    .byt 0
    .asc "affected systems and"
    .byt 0
    .asc "restore power to"
    .byt 0
    .asc "Moonbase Alpha."
    .byt 0
    .asc " "
    .byt 0
    .asc "His only doubt is if"
    .byt 0
    .asc "Doctor Russell..."
    .byt 0
    .asc "Helena, managed to get"
    .byt 0
    .asc "the injured Sandra" 
    .byt 0 
    .asc "Benes down to the"
    .byt 0
    .asc "underground levels"
    .byt 0
    .asc "before they were"
    .byt 0
    .asc "sealed..."
    .byt 0
    .asc " "
    .byt 0
    .asc " "
    .byt 0
    .asc " "
    .byt 0
    .asc "This game is based on"
    .byt 0
    .asc "the SPACE:1999 TV"
    .byt 0
    .asc "series, and is using"
    .byt 0
    .asc "NOISE, the Novel Oric"
    .byt 0
    .asc "ISometric Engine, and"
    .byt 0
    .asc "WHITE, World-Handling"
    .byt 0
    .asc "and Interaction with"
    .byt 0
    .asc "The Environment layer."
    .byt 0
    .asc " "
    .byt 0
    .asc "This program has been"
    .byt 0
    .asc "created using the OSDK,"
    .byt 0
    .asc "the Oric Software"
    .byt 0
    .asc "Develompent Kit."
    .byt 0
    .asc " "
    .byt 0
    .asc "      Programming"
    .byt 0
    .asc "    (the buggy code)"
    .byt 0
    .asc "         Chema"
    .byt 0
    .asc " "
    .byt 0
    .asc "   Graphics and sound"
    .byt 0
    .asc "(all praise the Master)"
    .byt 0
    .asc "       Twilighte"
    .byt 0
    .asc " "
    .byt 0
    .asc "       Game Intro"
    .byt 0
    .asc "     (the Demo Man)"
    .byt 0
    .asc "          Dbug"
    .byt 0
    .asc " "
    .byt 0
    .asc "     Additional Code"
    .byt 0
    .asc "   (the bugless code)"
    .byt 0
    .asc "       Twilighte"
    .byt 0
    .asc " "
    .byt 0
    .asc "Incredible intro scenes"
    .byt 0
    .asc "    converted by Sam"
    .byt 0
    .asc " "
    .byt 0
    .asc "         2008"
    .byt 0
    .asc " "
    .byt 0
    .asc " Remember to visit the"
    .byt 0
    .asc "     Oric forums at"
    .byt 0
    .asc " www.defence-force.org"
    .byt 0
    .asc " "
    .byt 0
    .asc " And the fantascit site"
    .byt 0
    .asc "   www.oricgames.com"
    .byt 0
    .asc " "
    .byt 0
    .asc "Remember there are maps"
    .byt 0
    .asc "of Alpha in the manual."
    .byt 0
    .asc "Will you need them?"
    .byt 0
    .asc " "
    .byt 0
    .asc " "
    .byt 0
    .asc " "
    .byt 0
    .asc " "
    .byt 0
    

#else

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Game texts...
;
; French version: Put * to represent ç
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Object descriptions
; Tiles with SPECIAL set
infopost  
    .asc "Terminal d'infos"
    .byt 0
alien_plant
    .asc "Plante Alien"
    .byt 0
meds_lab
    .asc "Synthetiseur Medical"
    .byt 0
benes_name
    .asc "Sandra Benes"
    .byt 0
control_name
    .asc "Panneau de commande des portes"
    .byt 0
circuit_name
    .asc "circuit principal"
    .byt 0
monitor_name
    .asc "Console Ordinateur"
    .byt 0
passcode_name
    .asc "Passcode: "
    .byt 0
Berg_pass     
    .byt A_FWGREEN
    .asc "Quartier Bergman"
    .byt 0
Crew_pass     
    .byt A_FWGREEN
    .asc "Quartier Equipage"
    .byt 0
Pool_pass 
    .byt A_FWGREEN
    .asc "Piscine"
    .byt 0    
Storage_pass  
    .byt A_FWGREEN
    .asc "Reserve"
    .byt 0
Power_pass
    .byt A_FWGREEN
    .asc "Salle du generateur"
    .byt 0    
Hyd_pass  ;
    .byt A_FWGREEN
    .asc "Quarantaine Hydroponique "
    .byt 0    
Door_ctrl_pass
    .byt A_FWGREEN
    .asc "Controle Porte"
    .byt 0
no_commlock_pass
    .asc "Radio-Passe requis"
    .byt 0

; Not in passcode bytes
benes_qtr
    .byt A_FWGREEN
    .asc "Quartier Benes"
    .byt 0

morrow_qtr
    .byt A_FWGREEN
    .asc "Quartier Morrows"
    .byt 0

h_general
    .byt A_FWGREEN
    .asc "Russel General"
    .byt 0

k_general
    .byt A_FWGREEN
    .asc "Koenig General"
    .byt 0


; Objects
Koenig_name
    .asc "John Koenig"
    .byt 0

Helena_name
    .asc "Helena Russel"
    .byt 0

Commlink_name
    .asc "Radio-Passe (Koenig)"
    .byt 0

CommlinkH_name
    .asc "Radio-Passe (Russel)"
    .byt 0


Medkit_name
    .asc "Medikit"
    .byt 0
Notepad_name
    .asc "Blocnote"
    .byt 0
Battery_name
    .asc "Batterie"
    .byt 0
plantjuice_name
    .asc "Elixir vegetal"
    .byt 0
compound_name
    .asc "Potion pour Benes"
    .byt 0

key_name
    .asc "Clef"
    .byt 0

relay_name;
    .asc "Relais rouge d'Herring Electronics"
    .byt 0

resistor_name
    .asc "Resistance"
    .byt 0

chip_name
    .asc "Puce Memoire"
    .byt 0

fuse_name
    .asc "Fusible"
    .byt 0
inductor_name
    .asc "Inducteur"
    .byt 0
screwdriver_name
    .asc "Tournevis"
    .byt 0
wire_name
    .asc "Fil de fer"
    .byt 0
oil_name
    .asc "Huile d'olive"
    .byt 0

;Chair_name was here

zx81_name
    .asc "ZX81 robot nettoyeur"
    .byt 0
No_name
    .asc "Pas d'objet choisi"
    .byt 0


; Messages from characters

Helena_comlock
    .byt "Helena:"
    .byt 0
Helena_1
    .byt A_FWGREEN
    .asc "John, viens m'aider a l'infirmerie"
    .byt 0
Helena_2
    .byt A_FWGREEN
    .asc "Nous devons partager nos passcodes"
    .byt 0
Helena_3
    .byt A_FWGREEN
    .asc "Vite, John."
    .byt 0

key
    .byt A_FWRED; 
    .asc "            (PRESS)"   
    .byt 0

Helena_spch_1;
    .byt 6
    .asc "Benes est tres malade, pour la"
    .byt 0
    .asc "soigner, il me faut un ingredient qui"
    .byt 0
    .asc "ne peut etre extrait que de plantes"
    .byt 0
    .asc "aliens, qui sont stockees dans"
    .byt 0
    .asc "l'hydroponique, mais en quarantaine"
    .byt 0
    .asc "et mes notes sont dans ma chambre."
    .byt 0
Helena_spch_2
    .byt 3
    .asc "Merci, John."
    .byt 0
    .asc "Je dois retourner a mon laboratoire" 
    .byt 0
    .asc "pour preparer la potion."
    .byt 0

Benes_spch_1a
    .byt 7
    .asc "Retablir l'energie requiert deux"
    .byt 0
    .asc "actions d'abord reparer le generateur"
    .byt 0
    .asc "puis l'ordinateur. J'ai deja bricole"
    .byt 0
    .asc "le generateur, mais avec un circuit"
    .byt 0
    .asc "bien trop faible et il a m'a eclate"
    .byt 0
    .asc "au visage. Le circuit... Paul... "
    .byt 0
    .asc "... passcode..."
    .byt 0

Benes_uncon
    .asc "Benes inconsciente."
    .byt 0

Benes_awake
    .asc "Signal Radio-Passe: Benes s'eveille."
    .byt 0

Benes_intro
    .asc "Benes ouvre les yeux et essaie"
    .byt 13
    .asc "de parler:"
    .byt 0

Benes_end
    .asc "Elle retombe dans le coma."
    .byt 0

Benes_spch_2; MAXIMUS  error ****
    .byt 5
    .asc "Pour reparer l'ordinateur tu dois"
    .byt 0
    .asc "changer le circuit de controle"
    .byt 0
    .asc "prends en un dans le tableau"
    .byt 0
    .asc "des systemes vitaux.. mon passcode..."
    .byt 0
    .asc "prudence.. ouvre le circuit..."
    .byt 0

Koenig_spch_1
    .byt 2
    .asc "Vas preparer le medicament."
    .byt 0
    .asc "Je vais veiller Benes."
    .byt 0

restore_power_msg
    .byt 3
    .asc "On doit retablir l'energie avec" 
    .byt 0
    .asc "le circuit propose par Sandra."
    .byt 0
    .asc "Elle a aussi parle de Paul..."
    .byt 0

restore_comp_msg
    .byt 3
    .asc "On doit reparer l'ordinateur"
    .byt 0
    .asc "comme Sandra l'a dit. mais il y a"
    .byt 0
    .asc "un danger..."
    .byt 0

pauls_list_msg
    .asc "L'ecran montre le schema d'un"
    .byt 13
    .asc "simple circuit ainsi qu'une"
    .byt 13 
    .asc "sorte de liste:"
    .byt 13
    .byt "Ba:HYP, In:APH, Re:HS"
    .byt 0

; Game messages
alarm_pwr_msg
    .asc "WARNING: Panne systeme Electrique."
    .byt 0
gameover_msg
    .asc "GAME OVER"
    .byt 0
gamefinished_msg
    .asc "MISSION ACCOMPLIE"
    .byt 0
helenadead_msg
    .asc "Dr. Russell est morte."
    .byt 0
koenigdead_msg
    .asc "Commandant Koenig est mort."
    .byt 0
benesdead_msg
    .asc "Sandra Benes est morte."
    .byt 0
lowpower_msg
    .byt 1
    .asc "WARNING: Energie faible!"
    .byt 0
lowlifesup_msg
    .byt 1
    .asc "WARNING: systemes vitaux faibles!"
    .byt 0
cannottake_msg; MAXIMUS error ****
    .asc "Impossible de prendre ca."
    .byt 0
cantdrop_msg; MAXIMUS error ****
    .asc "Impossible a poser ici."
    .byt 0
no_space_inv; MAXIMUS error ****
    .asc "Impossible de prendre plus d'objects."
    .byt 0
cantopendoor; MAXIMUS error ****
    .asc "La porte est verrouillee."
    .byt 0
door_jammed
    .asc "Cette porte est bloquee..."
    .byt 0
lubricate_door_msg
    .asc "Vous degrippez la porte avec l'huile."
    .byt 0
bergmandoor_msg
    .asc "Il est ecrit: Dr. Bergman."
    .byt 0
keynofits_msg
    .asc "Cette clef n'ouvre pas cette porte."
    .byt 0
keyfits_msg
    .asc "Vous ouvrez la porte avec la clef."
    .byt 0
unpowered_msg
    .asc " (eteint)"
    .byt 0
powered_msg
    .asc " (allume)"
    .byt 0
newpass_msg
    .asc "Nouveau passcode transmis"
    .byt 13
    .asc "au Radio-Passe"
    .byt 0
plant_taken_msg; 
    .asc "Vous avez assez d'extrait."
    .byt 0
plant_taking_msg; 
    .asc "Vous prenez une dose d'extrait."
    .byt 0
create_medicine_msg
    .asc "Vous creez une potion pour Benes."
    .byt 0
dont_know_msg
    .asc "Je ne sais pas comment utiliser *a."
    .byt 0

;notnow_msg
;    .asc "C'est pas le moment !"
;    .byt 0

need_pass
    .asc "Il faut un passcode pour utiliser *a."
    .byt 0

missing_notepad_msg
    .asc "J'ai besoin de mes notes pour"
    .byt 13
    .asc "preparer le medicament."
    .byt 0

cure_koenig_msg
    .asc "Vous soignez Koenig."
    .byt 0

door_ctrlo_msg
    .asc "Une lumiere rouge s'allume."
    .byt 0

door_ctrlc_msg
    .asc "La lumiere rouge s'eteint."
    .byt 0

wrong_panel_msg; 
    .asc "Impossible d'utiliser cela ici."
    .byt 0
place_item_msg
    .asc "Vous placez l'objet dans le circuit."
    .byt 0
wrong_item_msg
    .asc "Cet objet ne s'adapte pas au circuit."
    .byt 0
power_repaired_msg
    .asc "Energie OK... au tour de l'ordinateur."
    .byt 0
no_screwdriver_msg; 
    .asc "Impossible de retirer la puce"
    .byt 13
    .asc "sans le bon outil."
    .byt 0
burntout_chip_msg; 
    .asc "Il y a une puce HS ici."
    .byt 0
get_chip_msg
    .asc "Vous retirez la puce de son"
    .byt 13
    .asc "support."
    .byt 0
already_fixed_msg
    .asc "Mieux vaut ne pas le toucher pendant"
    .byt 13
    .asc "qu'il fonctionne."
    .byt 0
place_chip_msg
    .asc "Vous remplacez la puce grillee."
    .byt 13
;power_restored_msg
    .asc "Vous avez retabli l'energie de Alpha."
    .byt 13
    .asc "C'est du Bon boulot !!!"
    .byt 0
ls_fail_msg;
    .asc "Systeme vitaux en panne !"
    .byt 0
ls_back_msg; 
    .asc "Systemes vitaux repares"
    .byt 0
ls_bypassed_msg
    .asc "Vous creez un court-circuit et" 
    .byt 13
    .asc "le danger cesse"
    .byt 0
put_fuse_msg
    .asc "Vous changez le fusible HS"
    .byt 0
not_fuse_msg
    .asc "Le Synthetiseur semble en panne..."
    .byt 13
    .asc "aucun voyant ne s'allume."
    .byt 13; 
    .asc "Cela semble simple a reparer..."
    .byt 0
;no_fix_msg
;    .asc "impossible a reparer avec *a..."
;    .byt 0
no_medicine_msg
    .asc "Impossible de faire un medicament"
    .byt 13
    .asc "avec *a"
    .byt 0

hundred_msg
    .asc "100"
    .byt 0
percent_msg
    .asc " pourcent"
    .byt 0
infopost_menu_msg
    .asc " "
    .byt A_FWGREEN
    .asc "Sauvegarde       "    ; 17 chars
    .asc "  "
    .asc "Passcodes       "     ; 16 chars
    .byt 32,13
    .asc " "
    .byt A_FWGREEN
    .asc "Charger jeu      "
    .asc "  "
    .asc "Sound Volume    "
    .byt 32,13
    .asc " "
    .byt A_FWGREEN
    .asc "Alpha Status     "
    .asc "  "
    .asc "Progress du jeu "     ; NEED TRANSLATION TO Game progress ****** > LATIN WORD > same in french (like idem) *********
    .byt 32,13
    .asc " "
    .byt A_FWGREEN
    .asc "Cinema           "
    .asc "  "
    .asc "Exit            "
    .byt 32,0

gamesaved_msg
    .asc "Partie sauvegardee"
    .byt 0
gamerestored_msg
    .asc "Partie chargee"
    .byt 0
sure_to_save_msg
    .asc "Pressez CTRL pour sauver"
    .byt 0
sure_to_restore_msg
    .asc "Pressez CTRL pour charger la partie"
    .byt 0
anykey_msg; 
    .asc "ESC pour passer"
    .byt 0
abort_msg; 
    .asc "annulee."
    .byt 0
invalidsave_msg
    .asc "Sauvegarde Invalide"
    .byt 0

infopost_start
    .byt A_FWYELLOW
    .asc "     Borne d'Information Alpha"
    .byt 0
infopower_msg
    .byt A_FWGREEN
    .asc " Energie: "
    .byt 0
infols_msg
    .byt A_FWGREEN
    .asc " Systemes Vitaux: "
    .byt 0

info_tv_intro
    .byt A_FWGREEN
    .asc "Cette semaine:"
    .byt 0
tv_1_msg
    .byt A_FWGREEN
    .asc " Star Trek III: Spock a disparu"
    .byt 0
tv_2_msg
    .byt A_FWGREEN
    .asc " The Thunderbirds"
    .byt 0
tv_3_msg
    .byt A_FWGREEN
    .asc " 2001: l'odyssee de l'Espace"
    .byt 0
tv_4_msg
    .byt A_FWGREEN
    .asc " Mission Impossible"
    .byt 0


toggle_msg  
    .asc "Vous controllez "
    .byt 0
can_toggle_msg
    .asc "Vous pouvez changer de personnage"
    .byt 0
cant_toggle_msg
    .asc "Impossible de changer de personnage"
    .byt 0
cant_toggle_msg2
    .asc "Impossible avec une porte ouverte"
    .byt 0



; Lifts
lift_speech  
    .asc "Quel niveau: "
    .byt 0 
liftno_msg
    .asc "Ascenceur sans electricite"
    .byt 0

; Room names
main_mission_name
    .asc "Poste  Principal"
    .byt 0
corridor_name
    .asc "    Corridor    "
    .byt 0

command_room_name
    .asc "  Commandement  "
    .byt 0
koenig_quart_name
    .asc "  Koenig Quart. "
    .byt 0
russel_quart_name
    .asc " Russell Quart. "
    .byt 0

benes_quart_name
    .asc "  Benes Quart.  "
    .byt 0

bergman_quart_name
    .asc " Bergman Quart. "
    .byt 0

morrow_quart_name
    .asc " Morrow Quart.  "
    .byt 0

hisec_name;
    .asc "  Hte-Securite  "
    .byt 0

security_name
    .asc "    Securite    "
    .byt 0

life_support_name; 
    .asc "Systemes  vitaux"
    .byt 0

meds_lab_name
    .asc "  Labo medical  "
    .byt 0

astro_name
    .asc " Astrophysique  "
    .byt 0

power_name
    .asc "  Generateur    "
    .byt 0

computer_name
    .asc "   Ordinateur   "
    .byt 0

storage_name
    .asc "    Reserve     "
    .byt 0

chem_lab_name;
    .asc "  Labo chimie   "
    .byt 0

research_name
    .asc " Labo Recherche "
    .byt 0

meds_name; 
    .asc " Centre Medical "
    .byt 0

dining_name
    .asc "    Cantines    "
    .byt 0

lounge_name
    .asc "     Salon      "
    .byt 0

quarters_name;
    .asc "Cabines Equipage"
    .byt 0

leisure_name
    .asc "  Zone Detente  "
    .byt 0

hydroponics_name; 
    .asc " Hydroponique  "
    .byt 0

;; For floor names
levelH_name
    .asc "Niveau H        "
    .byt 0

levelG_name
    .asc "Niveau G        "
    .byt 0

levelCTRL_name
    .asc "Systemes        "
    .byt 0

levelMM_name
    .asc "Poste Principal "
    .byt 0


;************** Need translation *****************************>  JOB DONE BOSS - MAXIMUS  :-)  ******
; ALSO ITEM 7 of MENU (see above) >>  OK :-)

version_name
    .asc " ESC pour jouer "
    .byt 0

infoprogress_msg
    .asc "Vous avez resolu  "
    .byt 0

needcircuit_msg
    .asc "ignore le circuit requis"
    .byt 0

; Sound setting
sound_menu_txt
    .asc "Niveau sonore: "
    .byt 0
sound_high_name
    .asc "Deranger les voisins"
    .byt 0
sound_med_name
    .asc "Ambiance agreable   "
    .byt 0
sound_low_name
    .asc "J'ai la migraine    "
    .byt 0
sound_off_name
    .asc "Il est trés tard    "
    .byt 0


end_speech1_msg
    .asc "Helena: faible niveau de Radiation."
    .byt 13
    .asc "Tout danger est ecarte John..."
    .byt 0

end_speech2_msg
    .asc "Koenig: les Systemes fonctionnent..."
    .byt 13
    .asc "mais de justesse cette fois..."
    .byt 0

end_speech3_msg
    .asc "Koenig: Ordinateurr, deverouille les"
    .byt 13
    .asc "niveaux inferieurs."
    .byt 13
    .asc "Rappelons les habitants d'Alpha."
    .byt 0 


; For key mapping
keylist_msg
    .byt A_FWGREEN
    .asc "          Controles"
    .byt 13
    .asc "    M   Avancer   B    Reculer"
    .byt 13
    .asc "    Z,X Tourner   CTRL Action"
    .byt 13
    .asc "    ESC Poser     -,=  Objet"
    .byt 13
    .asc "    T Changer de Personnage"
    .byt 0


; this   "                       "
scroll_text
    .byt 92 ; Number of lines
    .asc " "
    .byt 0
    .asc " "
    .byt 0
    .asc " "
    .byt 0
    .asc " "
    .byt 0
    .asc "La lune a la derive..."
    .byt 0
    .asc "les naufrages de la"
    .byt 0
    .asc "Base Alpha... projetee"
    .byt 0
    .asc "dans l'espace, expulsee"
    .byt 0
    .asc "de son orbite terrestre"
    .byt 0
    .asc "par une explosion,"
    .byt 0
    .asc "nucleaire loin du"
    .byt 0
    .asc "systeme solaire."
    .byt 0
    .asc " "
    .byt 0
    .asc "Leur capricieux voyage"
    .byt 0
    .asc "a travers l'Univers,"
    .byt 0 
    .asc "les conduit face a un"
    .byt 0
    .asc "champ d'energie inconnu"
    .byt 0
    .asc "qui menace leur"
    .byt 0
    .asc "existence. d'enormes"
    .byt 0
    .asc "radiations ont altere"
    .byt 0
    .asc "la centrale d'energie"
    .byt 0
    .asc "et tout le personnel a"
    .byt 0
    .asc "ete evacue par securite"
    .byt 0
    .asc "vers les niveaux"
    .byt 0
    .asc "inferieurs de la base."
    .byt 0
    .asc " "
    .byt 0
    .asc "Tous sauf Commander"
    .byt 0
    .asc "John Koenig, qui risque"
    .byt 0
    .asc "sa vie pour reparer les"
    .byt 0
    .asc "systemes en panne et"
    .byt 0
    .asc "retablir l'energie dans"
    .byt 0
    .asc "la base lunaire Alpha."
    .byt 0
    .asc " "
    .byt 0
    .asc "Sa seule inquietude:"
    .byt 0
    .asc "Doctor Russell..."
    .byt 0
    .asc "Helena, chargee de "
    .byt 0
    .asc "descendre Sandra Benes" 
    .byt 0 
    .asc "gravement blessee vers"
    .byt 0
    .asc "les niveaux inferieurs"
    .byt 0
    .asc "avant qu'ils ne soient"
    .byt 0
    .asc "verrouilles..."
    .byt 0
    .asc " "
    .byt 0
    .asc " "
    .byt 0
    .asc " "
    .byt 0
    .asc "Ce jeu est inspire par"
    .byt 0
    .asc "la serie TV Cosmos1999,"
    .byt 0
    .asc "il utilise NOISE: Novel"
    .byt 0
    .asc "Oric ISometric Engine"
    .byt 0
    .asc "and WHITE:"
    .byt 0
    .asc "World-Handling"
    .byt 0
    .asc "and Interaction with"
    .byt 0
    .asc "The Environment layer."
    .byt 0
    .asc " "
    .byt 0
    .asc "Ce programme a ete"
    .byt 0
    .asc "cree avec l'OSDK,"
    .byt 0
    .asc "the Oric Software"
    .byt 0
    .asc "Develompent Kit."
    .byt 0
    .asc " "
    .byt 0
    .asc "      Programmation"
    .byt 0
    .asc "    (the buggy code)"
    .byt 0
    .asc "         Chema"
    .byt 0
    .asc " "
    .byt 0
    .asc "   Graphisme et sons"
    .byt 0
    .asc "(Compliments au Maitre)"
    .byt 0
    .asc "       Twilighte"
    .byt 0
    .asc " "
    .byt 0
    .asc "       Game Intro"
    .byt 0
    .asc "     (the Demo Man)"
    .byt 0
    .asc "          Dbug"
    .byt 0
    .asc " "
    .byt 0
    .asc "     Additional Code"
    .byt 0
    .asc "   (the bugless code)"
    .byt 0
    .asc "       Twilighte"
    .byt 0
    .asc " "
    .byt 0
    .asc "Incredible intro scenes"
    .byt 0
    .asc "    converted by Sam"
    .byt 0
    .asc " "
    .byt 0
    .asc "         2008"
    .byt 0
    .asc " "
    .byt 0
    .asc " Pensez a visiter les"
    .byt 0
    .asc "     forums Oric  "
    .byt 0
    .asc " www.defence-force.org"
    .byt 0
    .asc " "
    .byt 0
    .asc " Et le site de jeux: "
    .byt 0
    .asc "  www.oricgames.com"
    .byt 0
    .asc " "
    .byt 0
    .asc "Les cartes d'Alpha sont"
    .byt 0
    .asc "fournies dans le manuel"
    .byt 0
    .asc "Au cas ou vous seriez" 
    .byt 0
    .asc "perdu ?"
    .byt 0
    .asc " "
    .byt 0
    .asc " "
    .byt 0
    .asc " "
    .byt 0
    
#endif

__texts_end

#echo Size of texts in bytes:
#print (__texts_end - __texts_start)
#echo