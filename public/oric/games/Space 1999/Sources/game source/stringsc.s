__texts_start

#define FRENCH_VERSION
#ifndef FRENCH_VERSION

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Game texts...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Object descriptions
; Tiles with SPECIAL set
infopost  
    .asc "îfŠm²¶­oä"
    .byt 0
alien_plant
    .asc "ái…­l†t"
    .byt 0
meds_lab
    .asc "MôŒåyn’izƒ"
    .byt 0
benes_name
    .asc "SĞr‘¼’"
    .byt 0
control_name
    .asc "DoŠ õóê°š"
    .byt 0
circuit_name
    .asc "MaŒ Ìš"
    .byt 0
monitor_name
    .asc "C¢put“m‰šŠ"
    .byt 0
passcode_name
    .asc "PÃÖ·¬"
    .byt 0
Berg_pass     
    .byt A_FWGREEN
    .asc "BÛmİÓƒ"
    .byt 0
Crew_pass     
    .byt A_FWGREEN
    .asc "Cw Óƒs"
    .byt 0
Pool_pass 
    .byt A_FWGREEN
    .asc "Pool"
    .byt 0    
Storage_pass  
    .byt A_FWGREEN
    .asc "StŠagaa"
    .byt 0
Power_pass
    .byt A_FWGREEN
    .asc "P³“—¢"
    .byt 0    
Hyd_pass  
    .byt A_FWGREEN
    .asc "Hyd—p‰™„Á†tŒe"
    .byt 0    
Door_ctrl_pass
    .byt A_FWGREEN
    .asc "DoŠ õól"
    .byt 0
no_commlock_pass
    .asc "âòã‘cşøck ¿é‡š"
    .byt 0

; Not in passcode bytes
benes_qtr
    .byt A_FWGREEN
    .asc "ÿÓƒ"
    .byt 0

morrow_qtr
    .byt A_FWGREEN
    .asc "MŠ—w„Óƒ"
    .byt 0

h_general
    .byt A_FWGREEN
    .asc "Ru”˜ G…ƒœ"
    .byt 0

k_general
    .byt A_FWGREEN
    .asc "à G…ƒœ"
    .byt 0


; Objects
Koenig_name
    .asc "John à"
    .byt 0

Helena_name
    .asc "H˜…‘Ru”˜"
    .byt 0

Commlink_name
    .asc "Cşøck (à)"
    .byt 0

CommlinkH_name
    .asc "Cşøck (Ru”˜)"
    .byt 0


Medkit_name
    .asc "M¹kš"
    .byt 0
Notepad_name
    .asc "Nopad"
    .byt 0
Battery_name
    .asc "B²tƒy"
    .byt 0
plantjuice_name
    .asc "Viıú­l†tju™e"
    .byt 0
compound_name
    .asc "MôŒfŠ ¼’"
    .byt 0

key_name
    .asc "Key"
    .byt 0

relay_name
    .asc "RãR˜aºf—m HƒrÇ E±cë‰™s"
    .byt 0

resistor_name
    .asc "R’¡tŠ"
    .byt 0

chip_name
    .asc "MÍŠº´ip"
    .byt 0

fuse_name
    .asc "Fûe"
    .byt 0
inductor_name
    .asc "îductŠ"
    .byt 0
screwdriver_name
    .asc "Scwdrivƒ"
    .byt 0
wire_name
    .asc "Coª ú wi"
    .byt 0
oil_name
    .asc "Olivoª"
    .byt 0

;Chair_name was here

zx81_name
    .asc "ZX81 c±†Ç —bot"
    .byt 0
No_name
    .asc "N¦iËì˜Éd"
    .byt 0


; Messages from characters

Helena_comlock
    .byt "H˜…a:"
    .byt 0
Helena_1
    .byt A_FWGREEN
    .asc "John§I òãyÀ h˜p Œ m¹s."
    .byt 0
Helena_2
    .byt A_FWGREEN
    .asc "Lµ'„shÀ­ÃÖd’."
    .byt 0
Helena_3
    .byt A_FWGREEN
    .asc "H£rºup§John."
    .byt 0

key
    .byt A_FWRED
    .asc "«‚(KEY)"   
    .byt 0

Helena_spch_1
    .byt 6
    .asc "ÿ¯crš™œlºªlíI cİt²"
    .byt 0
    .asc "hƒ§bu‡I òãİÇö…‡²"
    .byt 0
    .asc "cİ‰lºbexë®•f—m İœi…"
    .byt 0
    .asc "pl†t§†•›Îbook f—m mº—¢."
    .byt 0
    .asc "Âül†‡cİbfˆn•Œ"
    .byt 0
    .asc "hyd—p‰™s§¡olğ•Œ ¾†tŒÈ"
    .byt 0
Helena_spch_2
    .byt 3
    .asc "Â†k yˆ§John."
    .byt 0
    .asc "I òã¿é‡b®k ¿mºlÕŠ²Šy" 
    .byt 0
    .asc "¿pÚ›môŒÈ"
    .byt 0

Benes_spch_1a
    .byt 7
    .asc "EnÕlÇ­³“¯twúold§yÊmuä"
    .byt 0
    .asc "fŸs‡fixæg…ƒ²Š †•… e"
    .byt 0
    .asc "c¢putƒíI ha•®tuœlºfixãe"
    .byt 0
    .asc "g…ƒ²Š§bu‡›Ì½I buªt"
    .byt 0
    .asc "wçÎ‡är‰g …ˆgh †•b±w up Œ"
    .byt 0
    .asc "mºf®È ÂÌš P l "
    .byt 0
    .asc "­ÃÖ·"
    .byt 0

Benes_uncon
    .asc "ÿŒ °õsciˆs"
    .byt 0

Benes_awake
    .asc "Cşøckì¥nœ¬ÿ¯awakÈ"
    .byt 0

Benes_intro
    .asc "ÿop…„h“ey†•ëito"
    .byt 13
    .asc "speak:"
    .byt 0

Benes_end
    .asc "Shfœl„b®k Œ¿°õsciˆsn’s."
    .byt 0

Benes_spch_2
    .byt 5
    .asc "T¦fixæc¢put“yÊhavto"
    .byt 0
    .asc "pl®›õóêÌš."
    .byt 0
    .asc "âcİû‰f—mæLife"
    .byt 0
    .asc "SuppŠ‡õól my­ÃÖ·"
    .byt 0
    .asc "bcaful op… Ìš"
    .byt 0

Koenig_spch_1
    .byt 2
    .asc "G¦†•pÚ›môŒÈ"
    .byt 0
    .asc "I wªêtakcú ¼’."
    .byt 0

restore_power_msg
    .byt 3
    .asc "Wòã¿é‡p³“äŠãwi" 
    .byt 0
    .asc "›Åctu½SĞr‘sugg’d."
    .byt 0
    .asc "Shœs¦m…t¶ãP l"
    .byt 0

restore_comp_msg
    .byt 3
    .asc "Wòã¿é‡›c¢put“paid"
    .byt 0
    .asc "çSĞr‘sugg’díBu‡ƒwç‘"
    .byt 0
    .asc "÷gƒ"
    .byt 0

pauls_list_msg
    .asc "Âåc…ìh³„›d’¥n ú a"
    .byt 13
    .asc "simp–Ì½œ‰g wiì¢e"
    .byt 13 
    .asc "kŒ•ú l¡t:"
    .byt 13
    .byt "Ba:HYP§î:APH§Re:HSI"
    .byt 0

; Game messages
alarm_pwr_msg
    .asc "WARNING¬P³“sß faªÇ"
    .byt 0
gameover_msg
    .asc "GAME OVER"
    .byt 0
gamefinished_msg
    .asc "MISSION ACCOMPLISHED"
    .byt 0
helenadead_msg
    .asc "DríRu”˜êö’"
    .byt 0
koenigdead_msg
    .asc "CşĞ“à ö’"
    .byt 0
benesdead_msg
    .asc "SĞr‘ÿö’"
    .byt 0
lowpower_msg
    .byt 1
    .asc "WARNING¬P³“l³!"
    .byt 0
lowlifesup_msg
    .byt 1
    .asc "WARNING¬LifåuppŠ‡sß„l³!"
    .byt 0
cannottake_msg
    .asc "CİÎ‡tak²"
    .byt 0
cantdrop_msg
    .asc "CİÎ‡d—p ½hƒe"
    .byt 0
no_space_inv
    .asc "CİÎ‡takmŠobjÉts"
    .byt 0
cantopendoor
    .asc "ÂdoŠ ¯øck¹"
    .byt 0
door_jammed
    .asc "Â¯doŠ ¯j¸m¹"
    .byt 0
lubricate_door_msg
    .asc "âlubr™²›doŠ wi oª"
    .byt 0
bergmandoor_msg
    .asc "Aì¥nìaÆ¬DríBÛm†"
    .byt 0
keynofits_msg
    .asc "Â¯keºdoÎ‡f½Œ ¯doŠ"
    .byt 0
keyfits_msg
    .asc "âop…ædoŠ wiækey"
    .byt 0
unpowered_msg
    .asc " (°p³ƒ¹)"
    .byt 0
powered_msg
    .asc " (wŠkÇ)"
    .byt 0
newpass_msg
    .asc "New­ÃÖ©d³nøa·•Œ cşøck"
    .byt 0
plant_taken_msg
    .asc "âœadºgo‡…ˆgh ju™e"
    .byt 0
plant_taking_msg
    .asc "âtak‘viıú ju™e"
    .byt 0
create_medicine_msg
    .asc "âc²‘môŒfŠ ¼’"
    .byt 0
dont_know_msg
    .asc "I d¦Î‡kn³ h³ ¿û¡"
    .byt 0

;notnow_msg
;    .asc "Bµt“Ît yµ"
;    .byt 0

need_pass
    .asc "âòã‘pÃÖ©¿opƒ²¡"
    .byt 0

missing_notepad_msg
    .asc "I òãmºÎ„¿pÚe"
    .byt 13
    .asc "môŒe"
    .byt 0

cure_koenig_msg
    .asc "âc£à"
    .byt 0

door_ctrlo_msg
    .asc "A •l¥h‡lšs"
    .byt 0

door_ctrlc_msg
    .asc "Â•l¥h‡t£n„úf"
    .byt 0

wrong_panel_msg
    .asc "C†nÎ‡û½hƒe"
    .byt 0
needcircuit_msg
    .asc "D‰'‡kn³æÌ½¿buªd"
    .byt 0
place_item_msg
    .asc "Yˆ­l®›iË ŒæÌš"
    .byt 0
wrong_item_msg
    .asc "Â¯iË doÎ‡f½ŒæÌš"
    .byt 0
power_repaired_msg
    .asc "P³“wŠkÇ n³æc¢putƒ"
    .byt 0
no_screwdriver_msg
    .asc "CİÎ‡é‡›´ip ˆ‡wiˆt"
    .byt 13
    .asc "‘p—p“tool"
    .byt 0
burntout_chip_msg
    .asc "Âƒ¯‘b£n‡ˆ‡´ip hƒe"
    .byt 0
get_chip_msg
    .asc "âtakˆ‡›´ip ˆ‡ú"
    .byt 13
    .asc "›sockµ"
    .byt 0
already_fixed_msg
    .asc "Bµt“Î‡tˆ´ š§n³ ½¡"
    .byt 13
    .asc "wŠkÇ"
    .byt 0
place_chip_msg
    .asc "âpl®›b£n‡ˆ‡´ip"
    .byt 13
;power_restored_msg
    .asc "âäŠãp³“¿áØa"
    .byt 13
    .asc "W˜êd‰e!!!"
    .byt 0
ls_fail_msg
    .asc "âop… ‘všıÌš!"
    .byt 0
ls_back_msg
    .asc "LifåuppŠ‡¯b®k wŠkÇ"
    .byt 0
ls_bypassed_msg
    .asc "âc²İ˜Éë™ıbypas„Ğ" 
    .byt 13
    .asc "›÷g“…ds"
    .byt 0
put_fuse_msg
    .asc "âpl®›b—k… fûe"
    .byt 0
not_fuse_msg
    .asc "ÂSyn’iz“seÍ„¿bb—k…"
    .byt 13
    .asc "n¦l¥ht„t£n ‰."
    .byt 13
    .asc "Mayb½¯easº¿fix"
    .byt 0
;no_fix_msg
;    .asc "C†Î‡fix ½wi ¡"
;    .byt 0
no_medicine_msg
    .asc "C†Î‡c²‘môŒe"
    .byt 13
    .asc "wi ¡"
    .byt 0

hundred_msg
    .asc "100"
    .byt 0
percent_msg
    .asc "­ƒc…t"
    .byt 0
infopost_menu_msg
    .asc " "
    .byt A_FWGREEN
    .asc "Savg¸e«"    ; 17 chars
    .asc "€"
    .asc "PÃÖd’‚¨"     ; 16 chars
    .byt 32,13
    .asc " "
    .byt A_FWGREEN
    .asc "R’tŠg¸eÏ"
    .asc "€"
    .asc "Sˆn•Volume‚"
    .byt 32,13
    .asc " "
    .byt A_FWGREEN
    .asc "áØ‘St²ûÏ"
    .asc "€"
    .asc "G¸ü—g”¨"
    .byt 32,13
    .asc " "
    .byt A_FWGREEN
    .asc "CŒÍa«¨"
    .asc "€"
    .asc "Exš«‚"
    .byt 32,0

gamesaved_msg
    .asc "G¸åñd"
    .byt 0
gamerestored_msg
    .asc "G¸äŠ¹"
    .byt 0
sure_to_save_msg
    .asc "Ps„CTRL ¿savg¸e"
    .byt 0
sure_to_restore_msg
    .asc "Ps„CTRL ¿äŠåñ•g¸e"
    .byt 0
anykey_msg
    .asc "ESC ¿skip"
    .byt 0
abort_msg
    .asc "Skipp¹"
    .byt 0
invalidsave_msg
    .asc "îvœi•sñÙŒt"
    .byt 0

infopost_start
    .byt A_FWYELLOW
    .asc "‚¨áØ‘îfŠm²¶ Poä"
    .byt 0
infopower_msg
    .byt A_FWGREEN
    .asc " P³“St²û¬"
    .byt 0
infols_msg
    .byt A_FWGREEN
    .asc " LifSuppŠt¬"
    .byt 0

info_tv_intro
    .byt A_FWGREEN
    .asc "On ¯week:"
    .byt 0
tv_1_msg
    .byt A_FWGREEN
    .asc " St Tk III¬ÂSe´ fŠ SÙck"
    .byt 0
tv_2_msg
    .byt A_FWGREEN
    .asc " ÂÂ°dƒbŸds"
    .byt 0
tv_3_msg
    .byt A_FWGREEN
    .asc " 2001¬A Sp®Ody”ey"
    .byt 0
tv_4_msg
    .byt A_FWGREEN
    .asc " Mi”¶:ImÙ”Ñ±"
    .byt 0


toggle_msg  
    .asc "N³ õóllÇ "
    .byt 0
can_toggle_msg
    .asc "âcİswš´ ´®tƒ„n³"
    .byt 0
cant_toggle_msg
    .asc "CİÎ‡swš´ ´®tƒ„n³"
    .byt 0
cant_toggle_msg2
    .asc "No‡whi–ƒ¯İop… doŠ"
    .byt 0



; Lifts
lift_speech  
    .asc "S˜É‡±v˜¬"
    .byt 0 
liftno_msg
    .asc "Lift„°p³ƒ¹"
    .byt 0

; Room names
main_mission_name
    .asc "€MaŒ Mi”¶€"
    .byt 0
corridor_name
    .asc "‚CŠridŠ‚"
    .byt 0

command_room_name
    .asc "€Cş†•Ro¢€"
    .byt 0
koenig_quart_name
    .asc "€à Óí"
    .byt 0
russel_quart_name
    .asc " Ru”˜êÓí"
    .byt 0

benes_quart_name
    .asc "€ÿÓ.€"
    .byt 0

bergman_quart_name
    .asc " BÛmİÓí"
    .byt 0

morrow_quart_name
    .asc " MŠ—w Ó.€"
    .byt 0

hisec_name
    .asc "Hi-SÉ Isol²¶"
    .byt 0

security_name
    .asc "‚SÉ£šy‚"
    .byt 0

life_support_name
    .asc "€LifSuppŠt€"
    .byt 0

meds_lab_name
    .asc "€MôıLÕs€"
    .byt 0

astro_name
    .asc "€Aä—ØÆ™s€"
    .byt 0

power_name
    .asc "¨P³“Ro¢¨"
    .byt 0

computer_name
    .asc " C¢put“Ro¢€"
    .byt 0

storage_name
    .asc "‚StŠaéÏ"
    .byt 0

chem_lab_name
    .asc " ChÍ™ıLÕs€"
    .byt 0

research_name
    .asc " R’e´ LÕs€"
    .byt 0

meds_name
    .asc "€MôıWÇ€"
    .byt 0

dining_name
    .asc "ÏDŒÇÏ"
    .byt 0

lounge_name
    .asc "ÏLˆnéÏ"
    .byt 0

quarters_name
    .asc " Cw Óƒs€"
    .byt 0

leisure_name
    .asc "€Le¡£Aa€"
    .byt 0

hydroponics_name
    .asc "€Hyd—p‰™s¨"
    .byt 0

;; For floor names
levelH_name
    .asc "Lev˜ H«"
    .byt 0

levelG_name
    .asc "Lev˜ G«"
    .byt 0

levelCTRL_name
    .asc "C‰óêSßs"
    .byt 0

levelMM_name
    .asc "MaŒ Mi”¶¨"
    .byt 0

version_name
    .asc " ESC ¿ä»€"
    .byt 0


; Sound setting
sound_menu_txt
    .asc "S˜É‡±v˜¬"
    .byt 0
sound_high_name
    .asc "D¡t£b ò¥hbÀs"
    .byt 0
sound_med_name
    .asc "N™b®kgrˆnd¨"
    .byt 0
sound_low_name
    .asc "Go‡‘head®he‚"
    .byt 0
sound_off_name
    .asc "L²a‡n¥htÏ"
    .byt 0

infoprogress_msg
    .asc "âhavåol¤•‘"
    .byt 0



end_speech1_msg
    .asc "H˜…a¬Raö²¶ ±v˜ìafÈ"
    .byt 13
    .asc "D†g“hçpÃãJohn"
    .byt 0

end_speech2_msg
    .asc "à¬Sß„wŠkÇ"
    .byt 13
    .asc "I‡wçcøs¯time"
    .byt 0

end_speech3_msg
    .asc "à¬C¢putƒ§°seıl³“±v˜s."
    .byt 13
    .asc "Lµ'„brÇæáØ†„b®k!"
    .byt 0 


; For key mapping
keylist_msg
    .byt A_FWGREEN
    .asc "«ÏG¸KeÆ"
    .byt 13
    .asc "‚M¨FŠwd¨B‚B®kwds"
    .byt 13
    .asc "‚Z,X T£n‚€CTRL Gµ§ûe"
    .byt 13
    .asc "‚ESC D—p‚€-,=€ObjÉ‡s˜Ét"
    .byt 13
    .asc "‚T Togg–´®tƒ"
    .byt 0

; For initial scroller
; 23 characters max per line
; this   "««‚¨"

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
    .asc "Âr°awaºmo‰ e"
    .byt 0
    .asc "caäaway„ú Mo‰base"
    .byt 0
    .asc "áØa h£tlÇ"
    .byt 0
    .asc "®—s„sp®e§blasd"
    .byt 0
    .asc "f—mæE'„Šbš"
    .byt 0
    .asc "bº‘nuc± expøs¶,"
    .byt 0
    .asc "f f f—mæsol"
    .byt 0
    .asc "sß."
    .byt 0
    .asc " "
    .byt 0
    .asc "Âeºwayw•jÀòy"
    .byt 0
    .asc "rˆghæ°ivƒse,"
    .byt 0 
    .asc "takÍ t³d„†"
    .byt 0
    .asc "°kn³n …Ûºfi˜d"
    .byt 0
    .asc "wh™h ²…„eŸ"
    .byt 0
    .asc "ex¡t†cÈ EnŠmˆs"
    .byt 0
    .asc "raö²¶ hçaffÉd"
    .byt 0
    .asc "eŸ­³“sß Ğ"
    .byt 0
    .asc "œl­ƒs‰n˜ hçbe…"
    .byt 0
    .asc "ev®uğ•¿›mŠe"
    .byt 0
    .asc "sÉ£°dÛrˆnd"
    .byt 0
    .asc "±v˜„úæbasÈ"
    .byt 0
    .asc " "
    .byt 0
    .asc "áêbu‡CşĞ“John"
    .byt 0
    .asc "à§wh¦wªêr¡k"
    .byt 0
    .asc "h¯lif¿paŸ e"
    .byt 0
    .asc "affÉ•sß„Ğ"
    .byt 0
    .asc "äŠü³“to"
    .byt 0
    .asc "Mo‰basáØa."
    .byt 0
    .asc " "
    .byt 0
    .asc "H¯‰lºdˆb‡¯if"
    .byt 0
    .asc "DoctŠ Ru”˜l"
    .byt 0
    .asc "H˜…a§m†agã¿gµ"
    .byt 0
    .asc "›Œju•SĞra" 
    .byt 0 
    .asc "ÿd³n ¿e"
    .byt 0
    .asc "°dÛrˆn•±v˜s"
    .byt 0
    .asc "befŠeºwƒe"
    .byt 0
    .asc "seœ¹"
    .byt 0
    .asc " "
    .byt 0
    .asc " "
    .byt 0
    .asc " "
    .byt 0
    .asc "Â¯g¸¯basã‰"
    .byt 0
    .asc "›SPACE:1999 TV"
    .byt 0
    .asc "sƒi’§†•¯ûÇ"
    .byt 0
    .asc "NOISE§›Nov˜ Or™"
    .byt 0
    .asc "IS¢µr™ EngŒe§Ğ"
    .byt 0
    .asc "WHITE§WŠld-HĞlÇ"
    .byt 0
    .asc "†•îtƒ®t¶ wi"
    .byt 0
    .asc "ÂEnvŸ‰m…‡layƒ."
    .byt 0
    .asc " "
    .byt 0
    .asc "Â¯p—gr¸ hçbe…"
    .byt 0
    .asc "cğ•ûÇæOSDK,"
    .byt 0
    .asc "›Or™ Sútwa"
    .byt 0
    .asc "Dev˜¢p…‡Kš."
    .byt 0
    .asc " "
    .byt 0
    .asc "‚€P—gr¸mÇ"
    .byt 0
    .asc "‚(›buggºÖ·)"
    .byt 0
    .asc "« ChÍa"
    .byt 0
    .asc " "
    .byt 0
    .asc "¨GraØ™„†•sˆnd"
    .byt 0
    .asc "(œl­ra¡›Maäƒ)"
    .byt 0
    .asc "‚¨Twª¥h"
    .byt 0
    .asc " "
    .byt 0
    .asc "‚¨G¸îó"
    .byt 0
    .asc "Ï(›DÍ¦M†)"
    .byt 0
    .asc "«€Dbug"
    .byt 0
    .asc " "
    .byt 0
    .asc "ÏAddš¶ıCo·"
    .byt 0
    .asc "¨(›bugl’„Ö·)"
    .byt 0
    .asc "‚¨Twª¥h"
    .byt 0
    .asc " "
    .byt 0
    .asc "îcdÑ–Œóìc…’"
    .byt 0
    .asc "‚õvƒ•bºS¸"
    .byt 0
    .asc " "
    .byt 0
    .asc "« 2008"
    .byt 0
    .asc " "
    .byt 0
    .asc " RÍÍb“¿v¡½e"
    .byt 0
    .asc "ÏOr™ fŠum„²"
    .byt 0
    .asc " www.·f…ce-fŠcÈŠg"
    .byt 0
    .asc " "
    .byt 0
    .asc " An•›f†tasc½si"
    .byt 0
    .asc "¨www.Š™g¸’.c¢"
    .byt 0
    .asc " "
    .byt 0
    .asc "RÍÍb“ƒmaps"
    .byt 0
    .asc "ú áØ‘Œæm†uœ."
    .byt 0
    .asc "WªêyÊòãÍ?"
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
    .asc "TƒmŒıèŒfos"
    .byt 0
alien_plant
    .asc "Pl†tái…"
    .byt 0
meds_lab
    .asc "Synµ¡e£ Môœ"
    .byt 0
benes_name
    .asc "SĞr‘¼’"
    .byt 0
control_name
    .asc "P†ò  ©cş†©dpŠs"
    .byt 0
circuit_name
    .asc "Ì½prŒcipœ"
    .byt 0
monitor_name
    .asc "C‰so–OrdŒğ£"
    .byt 0
passcode_name
    .asc "PÃÖ·¬"
    .byt 0
Berg_pass     
    .byt A_FWGREEN
    .asc "Ói“BÛm†"
    .byt 0
Crew_pass     
    .byt A_FWGREEN
    .asc "Ói“E¾ipaé"
    .byt 0
Pool_pass 
    .byt A_FWGREEN
    .asc "P¡cŒe"
    .byt 0    
Storage_pass  
    .byt A_FWGREEN
    .asc "R’ƒ¤"
    .byt 0
Power_pass
    .byt A_FWGREEN
    .asc "Sœ–du g…ƒğ£"
    .byt 0    
Hyd_pass  ;
    .byt A_FWGREEN
    .asc "Á†taŒHyd—p‰i¾"
    .byt 0    
Door_ctrl_pass
    .byt A_FWGREEN
    .asc "C‰ó–PŠ"
    .byt 0
no_commlock_pass
    .asc "Raöo-PÃ¾¡"
    .byt 0

; Not in passcode bytes
benes_qtr
    .byt A_FWGREEN
    .asc "Ói“¼’"
    .byt 0

morrow_qtr
    .byt A_FWGREEN
    .asc "Ói“MŠ—ws"
    .byt 0

h_general
    .byt A_FWGREEN
    .asc "Ru”˜ G…ƒœ"
    .byt 0

k_general
    .byt A_FWGREEN
    .asc "à G…ƒœ"
    .byt 0


; Objects
Koenig_name
    .asc "John à"
    .byt 0

Helena_name
    .asc "H˜…‘Ru”˜"
    .byt 0

Commlink_name
    .asc "Raöo-PÃ(à)"
    .byt 0

CommlinkH_name
    .asc "Raöo-PÃ(Ru”˜)"
    .byt 0


Medkit_name
    .asc "M¹ikš"
    .byt 0
Notepad_name
    .asc "BøcÎ"
    .byt 0
Battery_name
    .asc "B²tƒie"
    .byt 0
plantjuice_name
    .asc "ElixŸ ¤gµœ"
    .byt 0
compound_name
    .asc "Pot¶­À ¼’"
    .byt 0

key_name
    .asc "C±f"
    .byt 0

relay_name;
    .asc "R˜a¯rˆgèHƒrÇ E±cë‰™s"
    .byt 0

resistor_name
    .asc "R’¡t†ce"
    .byt 0

chip_name
    .asc "PucMÍoi"
    .byt 0

fuse_name
    .asc "FûÑ±"
    .byt 0
inductor_name
    .asc "îduc£"
    .byt 0
screwdriver_name
    .asc "TÀòv¡"
    .byt 0
wire_name
    .asc "Fª ©fƒ"
    .byt 0
oil_name
    .asc "Hui–èoli¤"
    .byt 0

;Chair_name was here

zx81_name
    .asc "ZX81 —bo‡nµtoye£"
    .byt 0
No_name
    .asc "Pçèobje‡´o¡i"
    .byt 0


; Messages from characters

Helena_comlock
    .byt "H˜…a:"
    .byt 0
Helena_1
    .byt A_FWGREEN
    .asc "John§vi…„m'aid“‘×ŒfŸmƒie"
    .byt 0
Helena_2
    .byt A_FWGREEN
    .asc "NŞ·v‰„p»ag“Î„pÃÖd’"
    .byt 0
Helena_3
    .byt A_FWGREEN
    .asc "Vi§John."
    .byt 0

key
    .byt A_FWRED; 
    .asc "«‚(PRESS)"   
    .byt 0

Helena_spch_1;
    .byt 6
    .asc "ÿ’‡t„mœa·§pÀ la"
    .byt 0
    .asc "so¥nƒ§ª mf ‡° Çö…‡¾i"
    .byt 0
    .asc "nüeu‡µrexëa½¾©pl†s"
    .byt 0
    .asc "œi…s§¾iì‰‡äocke÷s"
    .byt 0
    .asc "×hyd—p‰i¾e§ma¯… ¾†taŒe"
    .byt 0
    .asc "e‡mÎ„s‰‡÷„m‘´¸b."
    .byt 0
Helena_spch_2
    .byt 3
    .asc "Mƒci§John."
    .byt 0
    .asc "Jdo¯tÀn“‘m‰ lÕŠ²oi" 
    .byt 0
    .asc "pÀ­Ú“ùÙt¶."
    .byt 0

Benes_spch_1a
    .byt 7
    .asc "RµÕlŸ ×…Ûi¾iƒ‡·ux"
    .byt 0
    .asc "®t¶„èÕŠ•Ú“–g…ƒğ£"
    .byt 0
    .asc "pu¯×ŠdŒğ£íJ'ai ·j‘br™o±"
    .byt 0
    .asc "–g…ƒğ£§ma¯ñc ° Ìš"
    .byt 0
    .asc "bi… óp faÑ–e‡ª ‘m'‘Élğ"
    .byt 0
    .asc "  v¡agÈ LÌš P l "
    .byt 0
    .asc "­ÃÖ·"
    .byt 0

Benes_uncon
    .asc "ÿŒõsci…."
    .byt 0

Benes_awake
    .asc "S¥nıRaöo-PÃe¬ÿs'e¤ª±."
    .byt 0

Benes_intro
    .asc "ÿˆvrlyeux e‡’saie"
    .byt 13
    .asc "©Úlƒ:"
    .byt 0

Benes_end
    .asc "El–t¢b÷„–c¢a."
    .byt 0

Benes_spch_2; MAXIMUS  error ****
    .byt 5
    .asc "PÀ Ú“×ŠdŒğ£ tu do¡"
    .byt 0
    .asc "´†g“–Ì½©õó±"
    .byt 0
    .asc "pr…d„… ° ÷„–tÕ± "
    .byt 0
    .asc "dsßvš x‹ m‰­ÃÖ·"
    .byt 0
    .asc "prud…ce‹ ˆvr–Ìš"
    .byt 0

Koenig_spch_1
    .byt 2
    .asc "VçpÚ“–mô¸…t."
    .byt 0
    .asc "Jva¯¤ªl“¼’."
    .byt 0

restore_power_msg
    .byt 3
    .asc "On do½tÕlŸ ×…Ûiñc" 
    .byt 0
    .asc "–Ì½p—ÙsÚ SĞra."
    .byt 0
    .asc "El–‘ ”i­–©P l"
    .byt 0

restore_comp_msg
    .byt 3
    .asc "On do½Ú“×ŠdŒğ£"
    .byt 0
    .asc "cşSĞr‘×‘dšíma¯ª ºa"
    .byt 0
    .asc "° ÷gƒ"
    .byt 0

pauls_list_msg
    .asc "L'Érİm‰ë–s´Í‘è°"
    .byt 13
    .asc "simp–Ì½aŒsi ¾'°e"
    .byt 13 
    .asc "sŠt©l¡:"
    .byt 13
    .byt "Ba:HYP§î:APH§Re:HS"
    .byt 0

; Game messages
alarm_pwr_msg
    .asc "WARNING¬P†nåßE±cëi¾È"
    .byt 0
gameover_msg
    .asc "GAME OVER"
    .byt 0
gamefinished_msg
    .asc "MISSION ACCOMPLIE"
    .byt 0
helenadead_msg
    .asc "DríRu”˜ê’‡mŠ."
    .byt 0
koenigdead_msg
    .asc "CşĞ†‡à ’‡mŠt."
    .byt 0
benesdead_msg
    .asc "SĞr‘ÿ’‡mŠ."
    .byt 0
lowpower_msg
    .byt 1
    .asc "WARNING¬EnÛifaÑ±!"
    .byt 0
lowlifesup_msg
    .byt 1
    .asc "WARNING¬sßvš x faÑl’!"
    .byt 0
cannottake_msg; MAXIMUS error ****
    .asc "ImÙ”Ñ–©pr…drca."
    .byt 0
cantdrop_msg; MAXIMUS error ****
    .asc "ImÙ”Ñ–‘Ùs“™i."
    .byt 0
no_space_inv; MAXIMUS error ****
    .asc "ImÙ”Ñ–©pr…drülu„èobjÉts."
    .byt 0
cantopendoor; MAXIMUS error ****
    .asc "L‘pŠt’‡vƒrˆª±È"
    .byt 0
door_jammed
    .asc "CµtüŠt’‡bø¾ee"
    .byt 0
lubricate_door_msg
    .asc "ï·grippeÒùpŠtñc ×huªÈ"
    .byt 0
bergmandoor_msg
    .asc "Iê’‡Érš¬DríBÛm†."
    .byt 0
keynofits_msg
    .asc "Cµtc±f n'ˆvrüçcµtüŠ."
    .byt 0
keyfits_msg
    .asc "ïˆvÒùpŠtñc ùc±f."
    .byt 0
unpowered_msg
    .asc " (eŒt)"
    .byt 0
powered_msg
    .asc " (œlume)"
    .byt 0
newpass_msg
    .asc "Nˆ¤ ­ÃÖ©ë†sm¡"
    .byt 13
    .asc "  Raöo-PÃe"
    .byt 0
plant_taken_msg; 
    .asc "ïñÒÃeÒèexëaš."
    .byt 0
plant_taking_msg; 
    .asc "ïpr…eÒ°dosèexëaš."
    .byt 0
create_medicine_msg
    .asc "ïceÒ°Ùt¶­À ¼’."
    .byt 0
dont_know_msg
    .asc "Jnåa¯pçcş…‡utª¡“*a."
    .byt 0

;notnow_msg
;    .asc "C'’‡pç–m¢…‡!"
;    .byt 0

need_pass
    .asc "Iêf ‡°­ÃÖ©pÀ utª¡“*a."
    .byt 0

missing_notepad_msg
    .asc "J'ai b’oŒ ©mÎ„pÀ"
    .byt 13
    .asc "pÚ“–mô¸…t."
    .byt 0

cure_koenig_msg
    .asc "ïso¥òÒà."
    .byt 0

door_ctrlo_msg
    .asc "Unlumiƒrˆgå'œlumÈ"
    .byt 0

door_ctrlc_msg
    .asc "L‘lumiƒrˆgå'eŒt."
    .byt 0

wrong_panel_msg; 
    .asc "ImÙ”Ñ–èutª¡“c˜‘™i."
    .byt 0
place_item_msg
    .asc "ïpl®eÒ×obje‡÷„–Ìš."
    .byt 0
wrong_item_msg
    .asc "Ce‡obje‡nå'adaptüç  Ìš."
    .byt 0
power_repaired_msg
    .asc "EnÛiOK   tÀ ©×ŠdŒğ£."
    .byt 0
no_screwdriver_msg; 
    .asc "ImÙ”Ñ–©tŸ“ùpuce"
    .byt 13
    .asc "s†„–b‰ ˆtª."
    .byt 0
burntout_chip_msg; 
    .asc "Iêº‘°üucHS ™i."
    .byt 0
get_chip_msg
    .asc "ïtiÒùpuc©s‰"
    .byt 13
    .asc "suppŠt."
    .byt 0
already_fixed_msg
    .asc "Mieux v ‡nüç–tˆ´“p…÷t"
    .byt 13
    .asc "¾'ª f‰ct¶nÈ"
    .byt 0
place_chip_msg
    .asc "ïmpl®eÒùpucgrª±È"
    .byt 13
;power_restored_msg
    .asc "ïñÒtÕli ×…Ûi©áØa."
    .byt 13
    .asc "C'’‡du B‰ bˆø‡!!!"
    .byt 0
ls_fail_msg;
    .asc "Sßvš x …­†n!"
    .byt 0
ls_back_msg; 
    .asc "Sßvš x pas"
    .byt 0
ls_bypassed_msg
    .asc "ïceÒ° cÀt-Ì½µ" 
    .byt 13
    .asc "–÷g“c’se"
    .byt 0
put_fuse_msg
    .asc "ï´†éÒ–fûÑ–HS"
    .byt 0
not_fuse_msg
    .asc "LSynµ¡e£ìÍb–…­†ò"
    .byt 13
    .asc " c° voy†‡nå'œlumÈ"
    .byt 13; 
    .asc "C˜‘sÍb–simp–‘Úƒ"
    .byt 0
;no_fix_msg
;    .asc "imÙ”Ñ–‘Ú“ñc *a"
;    .byt 0
no_medicine_msg
    .asc "ImÙ”Ñ–©faŸ° mô¸…t"
    .byt 13
    .asc "ñc *a"
    .byt 0

hundred_msg
    .asc "100"
    .byt 0
percent_msg
    .asc "­Àc…t"
    .byt 0
infopost_menu_msg
    .asc " "
    .byt A_FWGREEN
    .asc "S ¤g·‚¨"    ; 17 chars
    .asc "€"
    .asc "PÃÖd’‚¨"     ; 16 chars
    .byt 32,13
    .asc " "
    .byt A_FWGREEN
    .asc "Chg“jeu‚€"
    .asc "€"
    .asc "Sˆn•Volume‚"
    .byt 32,13
    .asc " "
    .byt A_FWGREEN
    .asc "áØ‘St²ûÏ"
    .asc "€"
    .asc "P—gs„du jeu "     ; NEED TRANSLATION TO Game progress ****** > LATIN WORD > same in french (like idem) *********
    .byt 32,13
    .asc " "
    .byt A_FWGREEN
    .asc "CŒÍa«¨"
    .asc "€"
    .asc "Exš«‚"
    .byt 32,0

gamesaved_msg
    .asc "P»iå ¤g·e"
    .byt 0
gamerestored_msg
    .asc "P»i´ée"
    .byt 0
sure_to_save_msg
    .asc "P”eÒCTRL­Àì vƒ"
    .byt 0
sure_to_restore_msg
    .asc "P”eÒCTRL­À ´g“ùp»ie"
    .byt 0
anykey_msg; 
    .asc "ESC­À­Ãƒ"
    .byt 0
abort_msg; 
    .asc "†nu±È"
    .byt 0
invalidsave_msg
    .asc "S ¤g©îvœi·"
    .byt 0

infopost_start
    .byt A_FWYELLOW
    .asc "ÏBŠnèîfŠm²¶ áØa"
    .byt 0
infopower_msg
    .byt A_FWGREEN
    .asc " EnÛie¬"
    .byt 0
infols_msg
    .byt A_FWGREEN
    .asc " SßVš x¬"
    .byt 0

info_tv_intro
    .byt A_FWGREEN
    .asc "CµtåÍaŒe:"
    .byt 0
tv_1_msg
    .byt A_FWGREEN
    .asc " St Tk III¬SÙck ‘d¡Úu"
    .byt 0
tv_2_msg
    .byt A_FWGREEN
    .asc " ÂÂ°dƒbŸds"
    .byt 0
tv_3_msg
    .byt A_FWGREEN
    .asc " 2001¬×ody”e©×Esp®e"
    .byt 0
tv_4_msg
    .byt A_FWGREEN
    .asc " Mi”¶ ImÙ”Ñ±"
    .byt 0


toggle_msg  
    .asc "ïõól±Ò"
    .byt 0
can_toggle_msg
    .asc "ïpˆ¤Ò´†g“©pƒs‰naé"
    .byt 0
cant_toggle_msg
    .asc "ImÙ”Ñ–©´†g“©pƒs‰naé"
    .byt 0
cant_toggle_msg2
    .asc "ImÙ”Ñ–ñc °üŠtˆvƒ"
    .byt 0



; Lifts
lift_speech  
    .asc "Á˜ ni¤ ¬"
    .byt 0 
liftno_msg
    .asc "Asc…ce£ì†„˜Éë™i"
    .byt 0

; Room names
main_mission_name
    .asc "Pos€PrŒcipœ"
    .byt 0
corridor_name
    .asc "‚CŠridŠ‚"
    .byt 0

command_room_name
    .asc "€Cş†·m…t€"
    .byt 0
koenig_quart_name
    .asc "€à Óí"
    .byt 0
russel_quart_name
    .asc " Ru”˜êÓí"
    .byt 0

benes_quart_name
    .asc "€ÿÓ.€"
    .byt 0

bergman_quart_name
    .asc " BÛmİÓí"
    .byt 0

morrow_quart_name
    .asc " MŠ—w Ó.€"
    .byt 0

hisec_name;
    .asc "€H-SÉ£i€"
    .byt 0

security_name
    .asc "‚SÉ£i‚"
    .byt 0

life_support_name; 
    .asc "Sß’€vš x"
    .byt 0

meds_lab_name
    .asc "€LÕ¦môœ€"
    .byt 0

astro_name
    .asc " Aä—ØÆi¾e€"
    .byt 0

power_name
    .asc "€G…ƒğ£‚"
    .byt 0

computer_name
    .asc "¨OrdŒğ£¨"
    .byt 0

storage_name
    .asc "‚R’ƒ¤Ï"
    .byt 0

chem_lab_name;
    .asc "€LÕ¦´imie¨"
    .byt 0

research_name
    .asc " LÕ¦Re´ƒ´"
    .byt 0

meds_name; 
    .asc " C…ëMôı"
    .byt 0

dining_name
    .asc "‚C†tŒ’‚"
    .byt 0

lounge_name
    .asc "ÏSœ‰‚€"
    .byt 0

quarters_name;
    .asc "CÕŒE¾ipaé"
    .byt 0

leisure_name
    .asc "€Z‰Dµ…€"
    .byt 0

hydroponics_name; 
    .asc " Hyd—p‰i¾e€"
    .byt 0

;; For floor names
levelH_name
    .asc "Ni¤  H«"
    .byt 0

levelG_name
    .asc "Ni¤  G«"
    .byt 0

levelCTRL_name
    .asc "Sß’«"
    .byt 0

levelMM_name
    .asc "PoäPrŒcipı"
    .byt 0


;************** Need translation *****************************>  JOB DONE BOSS - MAXIMUS  :-)  ******
; ALSO ITEM 7 of MENU (see above) >>  OK :-)

version_name
    .asc " ESC­À jˆ“"
    .byt 0

infoprogress_msg
    .asc "ïñÒsolu€"
    .byt 0

needcircuit_msg
    .asc "¥nŠ–Ì½¾¡"
    .byt 0

; Sound setting
sound_menu_txt
    .asc "Ni¤ ì‰Še¬"
    .byt 0
sound_high_name
    .asc "Dƒ†g“lvo¡Œs"
    .byt 0
sound_med_name
    .asc "Ambi†cagÕ±¨"
    .byt 0
sound_low_name
    .asc "J'ai ùm¥raŒe‚"
    .byt 0
sound_off_name
    .asc "Iê’‡ëé„td‚"
    .byt 0


end_speech1_msg
    .asc "H˜…a¬faÑ–ni¤  ©Raö²¶."
    .byt 13
    .asc "Tˆ‡÷g“’‡É»John"
    .byt 0

end_speech2_msg
    .asc "à¬lSßf‰ct¶n…t"
    .byt 13
    .asc "ma¯©jû”cµtfo¡"
    .byt 0

end_speech3_msg
    .asc "à¬OrdŒğ£r§·vƒˆª–l’"
    .byt 13
    .asc "ni¤ x Œfƒie£s."
    .byt 13
    .asc "Rapp˜‰„lhÕš†t„èáØa."
    .byt 0 


; For key mapping
keylist_msg
    .byt A_FWGREEN
    .asc "«€C‰ól’"
    .byt 13
    .asc "‚M¨Av†cƒ¨B‚ReÄlƒ"
    .byt 13
    .asc "‚Z,X TÀnƒ¨CTRL Act¶"
    .byt 13
    .asc "‚ESC PosƒÏ-,=€Objµ"
    .byt 13
    .asc "‚T Ch†g“©Pƒs‰naé"
    .byt 0


; this   "««‚¨"
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
    .asc "L‘l°‘ùdƒi¤"
    .byt 0
    .asc "ln frag©la"
    .byt 0
    .asc "BasáØa­—jee"
    .byt 0
    .asc "÷„×’p®e§expulsee"
    .byt 0
    .asc "©s‰ Šbštƒä"
    .byt 0
    .asc "Ú °expøs¶,"
    .byt 0
    .asc "nuc±aŸøŒ du"
    .byt 0
    .asc "sßåolai."
    .byt 0
    .asc " "
    .byt 0
    .asc "Le£ capr™ieux voyaé"
    .byt 0
    .asc "‘ëavƒ„×Univƒs,"
    .byt 0 
    .asc "lõdu½f®‘°"
    .byt 0
    .asc "´¸p è…ÛiŒõnu"
    .byt 0
    .asc "¾i m…®±£"
    .byt 0
    .asc "ex¡t…cÈ è…Šm’"
    .byt 0
    .asc "raö²¶„‰‡œtƒe"
    .byt 0
    .asc "ùc…ëa–è…Ûie"
    .byt 0
    .asc "e‡tˆ‡–pƒs‰n˜ a"
    .byt 0
    .asc "µev®uÚìÉ£i"
    .byt 0
    .asc "vƒ„lni¤ x"
    .byt 0
    .asc "Œfƒie£„©ùbasÈ"
    .byt 0
    .asc " "
    .byt 0
    .asc "TŞs f CşĞƒ"
    .byt 0
    .asc "John à§¾i r¡¾e"
    .byt 0
    .asc "s‘viüÀ Ú“l’"
    .byt 0
    .asc "sß…­†nµ"
    .byt 0
    .asc "tÕlŸ ×…Ûi÷s"
    .byt 0
    .asc "ùbasl°aŸáØa."
    .byt 0
    .asc " "
    .byt 0
    .asc "S‘seu–Œ¾iµu·:"
    .byt 0
    .asc "DoctŠ Ru”˜l"
    .byt 0
    .asc "H˜…a§´é©"
    .byt 0
    .asc "d’c…drSĞr‘¼’" 
    .byt 0 
    .asc "grñm…‡bl’sevƒs"
    .byt 0
    .asc "lni¤ x Œfƒie£s"
    .byt 0
    .asc "av†‡¾'ª„nåoi…t"
    .byt 0
    .asc "vƒrˆªl’"
    .byt 0
    .asc " "
    .byt 0
    .asc " "
    .byt 0
    .asc " "
    .byt 0
    .asc "Cjeu ’‡ŒspŸÚ"
    .byt 0
    .asc "ùsƒiTV Cosmos1999,"
    .byt 0
    .asc "ª utª¡NOISE¬Nov˜"
    .byt 0
    .asc "Or™ IS¢µr™ EngŒe"
    .byt 0
    .asc "†•WHITE:"
    .byt 0
    .asc "WŠld-HĞlÇ"
    .byt 0
    .asc "†•îtƒ®t¶ wi"
    .byt 0
    .asc "ÂEnvŸ‰m…‡layƒ."
    .byt 0
    .asc " "
    .byt 0
    .asc "Cü—gr¸m‘e"
    .byt 0
    .asc "cñc ×OSDK,"
    .byt 0
    .asc "›Or™ Sútwa"
    .byt 0
    .asc "Dev˜¢p…‡Kš."
    .byt 0
    .asc " "
    .byt 0
    .asc "‚€P—gr¸m²¶"
    .byt 0
    .asc "‚(›buggºÖ·)"
    .byt 0
    .asc "« ChÍa"
    .byt 0
    .asc " "
    .byt 0
    .asc "¨GraØ¡me‡s‰s"
    .byt 0
    .asc "(C¢plim…t„  Maš)"
    .byt 0
    .asc "‚¨Twª¥h"
    .byt 0
    .asc " "
    .byt 0
    .asc "‚¨G¸îó"
    .byt 0
    .asc "Ï(›DÍ¦M†)"
    .byt 0
    .asc "«€Dbug"
    .byt 0
    .asc " "
    .byt 0
    .asc "ÏAddš¶ıCo·"
    .byt 0
    .asc "¨(›bugl’„Ö·)"
    .byt 0
    .asc "‚¨Twª¥h"
    .byt 0
    .asc " "
    .byt 0
    .asc "îcdÑ–Œóìc…’"
    .byt 0
    .asc "‚õvƒ•bºS¸"
    .byt 0
    .asc " "
    .byt 0
    .asc "« 2008"
    .byt 0
    .asc " "
    .byt 0
    .asc " P…seÒ‘v¡š“l’"
    .byt 0
    .asc "ÏfŠum„Or™€"
    .byt 0
    .asc " www.·f…ce-fŠcÈŠg"
    .byt 0
    .asc " "
    .byt 0
    .asc " E‡–sš©jeux¬"
    .byt 0
    .asc "€www.Š™g¸’.c¢"
    .byt 0
    .asc " "
    .byt 0
    .asc "Lc„èáØ‘s‰t"
    .byt 0
    .asc "fÀni÷„–m†u˜"
    .byt 0
    .asc "Au cçÊvŞsƒiez" 
    .byt 0
    .asc "pƒdu ?"
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

__grammar_start
Grammar
.byt 32, 32
.byt 101, 32
.byt 128, 128
.byt 101, 114
.byt 115, 32
.byt 101, 110
.byt 97, 110
.byt 116, 32
.byt 111, 117
.byt 111, 110
.byt 111, 114
.byt 46, 46
.byt 105, 110
.byt 116, 104
.byt 114, 101
.byt 116, 101
.byt 97, 114
.byt 97, 32
.byt 101, 115
.byt 131, 32
.byt 115, 115
.byt 100, 32
.byt 108, 129
.byt 114, 111
.byt 101, 108
.byt 105, 99
.byt 105, 116
.byt 141, 129
.byt 97, 108
.byt 139, 46
.byt 101, 132
.byt 105, 114
.byt 97, 117
.byt 105, 115
.byt 111, 109
.byt 117, 114
.byt 118, 101
.byt 105, 103
.byt 111, 32
.byt 44, 32
.byt 128, 32
.byt 100, 129
.byt 105, 108
.byt 130, 130
.byt 58, 32
.byt 32, 112
.byt 97, 99
.byt 105, 132
.byt 117, 110
.byt 108, 101
.byt 97, 116
.byt 111, 119
.byt 99, 104
.byt 101, 116
.byt 105, 137
.byt 100, 101
.byt 97, 109
.byt 101, 100
.byt 121, 32
.byt 144, 116
.byt 66, 133
.byt 105, 135
.byt 113, 117
.byt 116, 166
.byt 136, 114
.byt 81, 117
.byt 84, 104
.byt 97, 148
.byt 99, 117
.byt 99, 159
.byt 121, 115
.byt 140, 103
.byt 101, 46
.byt 101, 99
.byt 136, 32
.byt 143, 109
.byt 197, 196
.byt 101, 109
.byt 110, 111
.byt 130, 32
.byt 134, 100
.byt 105, 98
.byt 122, 32
.byt 193, 187
.byt 75, 111
.byt 97, 98
.byt 99, 111
.byt 108, 39
.byt 112, 104
.byt 112, 111
.byt 112, 144
.byt 131, 103
.byt 133, 165
.byt 134, 32
.byt 136, 132
.byt 198, 203
.byt 212, 220
.byt 65, 108
.byt 89, 202
.byt 101, 149
.byt 115, 116
.byt 129, 115
.byt 32, 155
.byt 97, 132
.byt 100, 39
.byt 103, 101
.byt 108, 32
.byt 116, 114
.byt 32, 115
.byt 46, 32
.byt 73, 110
.byt 86, 222
.byt 97, 143
.byt 97, 164
.byt 110, 101
.byt 116, 151
.byt 185, 153
.byt 99, 137
.byt 100, 105
.byt 100, 134
.byt 108, 111
.byt 108, 145
.byt 111, 102
.byt 117, 115
.byt 129, 112
.byt 156, 32
.byt 162, 109
.byt 188, 158
__grammar_end


#echo Size of grammar in bytes:
#print (__grammar_end - __grammar_start)
#echo

