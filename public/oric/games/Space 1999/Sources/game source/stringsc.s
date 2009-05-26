__texts_start

#define FRENCH_VERSION
#ifndef FRENCH_VERSION

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Game texts...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Object descriptions
; Tiles with SPECIAL set
infopost  
    .asc "�f�m���o�"
    .byt 0
alien_plant
    .asc "�i��l�t"
    .byt 0
meds_lab
    .asc "M��yn��iz�"
    .byt 0
benes_name
    .asc "S�r���"
    .byt 0
control_name
    .asc "Do� ��갚"
    .byt 0
circuit_name
    .asc "Ma� ̚"
    .byt 0
monitor_name
    .asc "C�put�m���"
    .byt 0
passcode_name
    .asc "P�ַ�"
    .byt 0
Berg_pass     
    .byt A_FWGREEN
    .asc "B�m�Ӄ"
    .byt 0
Crew_pass     
    .byt A_FWGREEN
    .asc "C�w Ӄs"
    .byt 0
Pool_pass 
    .byt A_FWGREEN
    .asc "Pool"
    .byt 0    
Storage_pass  
    .byt A_FWGREEN
    .asc "St�ag�a�a"
    .byt 0
Power_pass
    .byt A_FWGREEN
    .asc "P����"
    .byt 0    
Hyd_pass  
    .byt A_FWGREEN
    .asc "Hyd�p������t�e"
    .byt 0    
Door_ctrl_pass
    .byt A_FWGREEN
    .asc "Do� ��l"
    .byt 0
no_commlock_pass
    .asc "���c��ck �釚"
    .byt 0

; Not in passcode bytes
benes_qtr
    .byt A_FWGREEN
    .asc "�Ӄ"
    .byt 0

morrow_qtr
    .byt A_FWGREEN
    .asc "M��w�Ӄ"
    .byt 0

h_general
    .byt A_FWGREEN
    .asc "Ru�� G���"
    .byt 0

k_general
    .byt A_FWGREEN
    .asc "� G���"
    .byt 0


; Objects
Koenig_name
    .asc "John �"
    .byt 0

Helena_name
    .asc "H���Ru��"
    .byt 0

Commlink_name
    .asc "C��ck (�)"
    .byt 0

CommlinkH_name
    .asc "C��ck (Ru��)"
    .byt 0


Medkit_name
    .asc "M�k�"
    .byt 0
Notepad_name
    .asc "No�pad"
    .byt 0
Battery_name
    .asc "B�t�y"
    .byt 0
plantjuice_name
    .asc "Vi���l�tju�e"
    .byt 0
compound_name
    .asc "M�f� ��"
    .byt 0

key_name
    .asc "Key"
    .byt 0

relay_name
    .asc "R�R�a�f�m H�r� E�c뉙s"
    .byt 0

resistor_name
    .asc "R��t�"
    .byt 0

chip_name
    .asc "M͊��ip"
    .byt 0

fuse_name
    .asc "F�e"
    .byt 0
inductor_name
    .asc "�duct�"
    .byt 0
screwdriver_name
    .asc "Sc�wdriv�"
    .byt 0
wire_name
    .asc "Co� � wi�"
    .byt 0
oil_name
    .asc "Oliv�o�"
    .byt 0

;Chair_name was here

zx81_name
    .asc "ZX81 c��� �bot"
    .byt 0
No_name
    .asc "N�i��ɏd"
    .byt 0


; Messages from characters

Helena_comlock
    .byt "H��a:"
    .byt 0
Helena_1
    .byt A_FWGREEN
    .asc "John�I ��y� h�p � m�s."
    .byt 0
Helena_2
    .byt A_FWGREEN
    .asc "L�'�sh������d�."
    .byt 0
Helena_3
    .byt A_FWGREEN
    .asc "H�r�up�John."
    .byt 0

key
    .byt A_FWRED
    .asc "��(KEY)"   
    .byt 0

Helena_spch_1
    .byt 6
    .asc "��cr���l��l�I c�t��"
    .byt 0
    .asc "h��bu�I ���ǎ�����"
    .byt 0
    .asc "c݉l�b�ex뮏�f�m ݜi�"
    .byt 0
    .asc "pl�t����Ώbook f�m m���."
    .byt 0
    .asc "��l��c�b�f�n��"
    .byt 0
    .asc "hyd�p��s��ol� ���t��"
    .byt 0
Helena_spch_2
    .byt 3
    .asc "k y��John."
    .byt 0
    .asc "I ���b�k �m�lՊ��y" 
    .byt 0
    .asc "�p�ځ�m��"
    .byt 0

Benes_spch_1a
    .byt 7
    .asc "En�lǭ���tw�old�y�mu�"
    .byt 0
    .asc "f�s�fix�g���� ���� �e"
    .byt 0
    .asc "c�put��I ha��tu�l�fix�e"
    .byt 0
    .asc "g�����bu��̽I bu�t"
    .byt 0
    .asc "w�·�r�g ��gh ��b�w up �"
    .byt 0
    .asc "m�f�� ̚� P�l� "
    .byt 0
    .asc "���ַ�"
    .byt 0

Benes_uncon
    .asc "�� ��sci�s"
    .byt 0

Benes_awake
    .asc "C��ck�n����awak�"
    .byt 0

Benes_intro
    .asc "�op��h�ey����i�to"
    .byt 13
    .asc "speak:"
    .byt 0

Benes_end
    .asc "Sh�f�l�b�k ����sci�sn�s."
    .byt 0

Benes_spch_2
    .byt 5
    .asc "T�fix�c�put�y�hav�to"
    .byt 0
    .asc "�pl������̚."
    .byt 0
    .asc "�c�����f�m�Life"
    .byt 0
    .asc "Supp����l� my��ַ�"
    .byt 0
    .asc "b�ca�ful� op� ̚�"
    .byt 0

Koenig_spch_1
    .byt 2
    .asc "G���p�ځ�m��"
    .byt 0
    .asc "I w��tak�c��� ��."
    .byt 0

restore_power_msg
    .byt 3
    .asc "W����p�����wi�" 
    .byt 0
    .asc "��ctu�S�r�sugg��d."
    .byt 0
    .asc "Sh��s�m�t��P�l�"
    .byt 0

restore_comp_msg
    .byt 3
    .asc "W���釛c�put��pai�d"
    .byt 0
    .asc "�S�r�sugg��d�Bu����w�"
    .byt 0
    .asc "�g��"
    .byt 0

pauls_list_msg
    .asc "��c���h���d��n � a"
    .byt 13
    .asc "simp�̽��g wi��e"
    .byt 13 
    .asc "k��� l�t:"
    .byt 13
    .byt "Ba:HYP��:APH�Re:HSI"
    .byt 0

; Game messages
alarm_pwr_msg
    .asc "WARNING�P��s� fa��"
    .byt 0
gameover_msg
    .asc "GAME OVER"
    .byt 0
gamefinished_msg
    .asc "MISSION ACCOMPLISHED"
    .byt 0
helenadead_msg
    .asc "Dr�Ru�����"
    .byt 0
koenigdead_msg
    .asc "C�Г� ��"
    .byt 0
benesdead_msg
    .asc "S�r����"
    .byt 0
lowpower_msg
    .byt 1
    .asc "WARNING�P��l�!"
    .byt 0
lowlifesup_msg
    .byt 1
    .asc "WARNING�Lif�upp��s߄l�!"
    .byt 0
cannottake_msg
    .asc "C�·tak���"
    .byt 0
cantdrop_msg
    .asc "C�·d�p �h�e"
    .byt 0
no_space_inv
    .asc "C�·tak�m��obj�ts"
    .byt 0
cantopendoor
    .asc "do� ��ck�"
    .byt 0
door_jammed
    .asc "¯do� �j�m��"
    .byt 0
lubricate_door_msg
    .asc "�lubr����do� wi� o�"
    .byt 0
bergmandoor_msg
    .asc "A�n�aƬDr�B�m�"
    .byt 0
keynofits_msg
    .asc "¯ke�do�·f�� ��do�"
    .byt 0
keyfits_msg
    .asc "�op��do� wi��key"
    .byt 0
unpowered_msg
    .asc " (�p���)"
    .byt 0
powered_msg
    .asc " (w�k�)"
    .byt 0
newpass_msg
    .asc "New��֩d�n�a��� c��ck"
    .byt 0
plant_taken_msg
    .asc "✎ad�go���gh ju�e"
    .byt 0
plant_taking_msg
    .asc "�tak��vi�� ju�e"
    .byt 0
create_medicine_msg
    .asc "�c����m�f� ��"
    .byt 0
dont_know_msg
    .asc "I d�·kn� h� �����"
    .byt 0

;notnow_msg
;    .asc "B�t��t� y�"
;    .byt 0

need_pass
    .asc "���p�֩�op�����"
    .byt 0

missing_notepad_msg
    .asc "I ��m�Ώ��p�ځ�e"
    .byt 13
    .asc "m�e"
    .byt 0

cure_koenig_msg
    .asc "�c���"
    .byt 0

door_ctrlo_msg
    .asc "A ��l�h�l�s"
    .byt 0

door_ctrlc_msg
    .asc "��l�h�t�n��f"
    .byt 0

wrong_panel_msg
    .asc "C�n·���h�e"
    .byt 0
needcircuit_msg
    .asc "D�'�kn��̽�bu�d"
    .byt 0
place_item_msg
    .asc "Y��l���i� ��̚"
    .byt 0
wrong_item_msg
    .asc "¯i� do�·f���̚"
    .byt 0
power_repaired_msg
    .asc "P��w�kǝ n��c�put�"
    .byt 0
no_screwdriver_msg
    .asc "C�·釛�ip ��wi��t"
    .byt 13
    .asc "�p�p�tool"
    .byt 0
burntout_chip_msg
    .asc "���b�n����ip h�e"
    .byt 0
get_chip_msg
    .asc "�tak�����ip ���"
    .byt 13
    .asc "�sock�"
    .byt 0
already_fixed_msg
    .asc "B�t�·t�� ��n� ��"
    .byt 13
    .asc "w�k�"
    .byt 0
place_chip_msg
    .asc "�pl���b�n����ip"
    .byt 13
;power_restored_msg
    .asc "���p�����a"
    .byt 13
    .asc "W��d�e!!!"
    .byt 0
ls_fail_msg
    .asc "�op� �v��̚!"
    .byt 0
ls_back_msg
    .asc "Lif�upp���b�k w�k�"
    .byt 0
ls_bypassed_msg
    .asc "�c���ݘ���bypas��" 
    .byt 13
    .asc "��g��ds"
    .byt 0
put_fuse_msg
    .asc "�pl���b�k� f�e"
    .byt 0
not_fuse_msg
    .asc "Syn��iz�së́�b�b�k��"
    .byt 13
    .asc "n�l�ht�t�n �."
    .byt 13
    .asc "Mayb���eas��fix�"
    .byt 0
;no_fix_msg
;    .asc "C�·fix �wi� ���"
;    .byt 0
no_medicine_msg
    .asc "C�·c����m�e"
    .byt 13
    .asc "wi� ��"
    .byt 0

hundred_msg
    .asc "100"
    .byt 0
percent_msg
    .asc "��c�t"
    .byt 0
infopost_menu_msg
    .asc " "
    .byt A_FWGREEN
    .asc "Sav�g�e�"    ; 17 chars
    .asc "�"
    .asc "P��d���"     ; 16 chars
    .byt 32,13
    .asc " "
    .byt A_FWGREEN
    .asc "R�t��g�e�"
    .asc "�"
    .asc "S�n�Volume�"
    .byt 32,13
    .asc " "
    .byt A_FWGREEN
    .asc "�ؑSt���"
    .asc "�"
    .asc "G���g���"
    .byt 32,13
    .asc " "
    .byt A_FWGREEN
    .asc "C��a��"
    .asc "�"
    .asc "Ex���"
    .byt 32,0

gamesaved_msg
    .asc "G���d"
    .byt 0
gamerestored_msg
    .asc "G���䊹"
    .byt 0
sure_to_save_msg
    .asc "P�s�CTRL �sav�g�e"
    .byt 0
sure_to_restore_msg
    .asc "P�s�CTRL �����g�e"
    .byt 0
anykey_msg
    .asc "ESC �skip"
    .byt 0
abort_msg
    .asc "Skipp�"
    .byt 0
invalidsave_msg
    .asc "�v�i�s�ٌt"
    .byt 0

infopost_start
    .byt A_FWYELLOW
    .asc "���ؑ�f�m�� Po�"
    .byt 0
infopower_msg
    .byt A_FWGREEN
    .asc " P��St���"
    .byt 0
infols_msg
    .byt A_FWGREEN
    .asc " Lif�Supp�t�"
    .byt 0

info_tv_intro
    .byt A_FWGREEN
    .asc "On ��week:"
    .byt 0
tv_1_msg
    .byt A_FWGREEN
    .asc " St� T�k III�Se�� f� S�ck"
    .byt 0
tv_2_msg
    .byt A_FWGREEN
    .asc " °d�b�ds"
    .byt 0
tv_3_msg
    .byt A_FWGREEN
    .asc " 2001�A Sp��Ody�ey"
    .byt 0
tv_4_msg
    .byt A_FWGREEN
    .asc " Mi��:Imٔѱ"
    .byt 0


toggle_msg  
    .asc "N� ��ll� "
    .byt 0
can_toggle_msg
    .asc "�c�sw�� ���t��n�"
    .byt 0
cant_toggle_msg
    .asc "C�·sw�� ���t��n�"
    .byt 0
cant_toggle_msg2
    .asc "No�whi������op� do�"
    .byt 0



; Lifts
lift_speech  
    .asc "S�ɇ�v��"
    .byt 0 
liftno_msg
    .asc "Lift��p���"
    .byt 0

; Room names
main_mission_name
    .asc "�Ma� Mi���"
    .byt 0
corridor_name
    .asc "�C�rid��"
    .byt 0

command_room_name
    .asc "�C���Ro��"
    .byt 0
koenig_quart_name
    .asc "�� ��"
    .byt 0
russel_quart_name
    .asc " Ru�����"
    .byt 0

benes_quart_name
    .asc "���.�"
    .byt 0

bergman_quart_name
    .asc " B�m���"
    .byt 0

morrow_quart_name
    .asc " M��w �.�"
    .byt 0

hisec_name
    .asc "Hi-S� Isol��"
    .byt 0

security_name
    .asc "�Sɣ�y�"
    .byt 0

life_support_name
    .asc "�Lif�Supp�t�"
    .byt 0

meds_lab_name
    .asc "�M��L�s�"
    .byt 0

astro_name
    .asc "�A��ƙs�"
    .byt 0

power_name
    .asc "�P��Ro��"
    .byt 0

computer_name
    .asc " C�put�Ro��"
    .byt 0

storage_name
    .asc "�St�a��"
    .byt 0

chem_lab_name
    .asc " Ch͙�L�s�"
    .byt 0

research_name
    .asc " R�e�� L�s�"
    .byt 0

meds_name
    .asc "�M��Wǀ"
    .byt 0

dining_name
    .asc "�D���"
    .byt 0

lounge_name
    .asc "�L�n��"
    .byt 0

quarters_name
    .asc " C�w Ӄs�"
    .byt 0

leisure_name
    .asc "�Le���A�a�"
    .byt 0

hydroponics_name
    .asc "�Hyd�p��s�"
    .byt 0

;; For floor names
levelH_name
    .asc "Lev� H�"
    .byt 0

levelG_name
    .asc "Lev� G�"
    .byt 0

levelCTRL_name
    .asc "C���S�s"
    .byt 0

levelMM_name
    .asc "Ma� Mi���"
    .byt 0

version_name
    .asc " ESC �什"
    .byt 0


; Sound setting
sound_menu_txt
    .asc "S�ɇ�v��"
    .byt 0
sound_high_name
    .asc "D�t�b �hb�s"
    .byt 0
sound_med_name
    .asc "N��b�kgr�nd�"
    .byt 0
sound_low_name
    .asc "Go��head�he�"
    .byt 0
sound_off_name
    .asc "L��a�n�ht�"
    .byt 0

infoprogress_msg
    .asc "�hav�ol���"
    .byt 0



end_speech1_msg
    .asc "H��a�Ra��� �v��af�"
    .byt 13
    .asc "D�g�h�p��John�"
    .byt 0

end_speech2_msg
    .asc "�S߄w�kǝ"
    .byt 13
    .asc "I�w�c�s���time�"
    .byt 0

end_speech3_msg
    .asc "�C�put���se�l���v�s."
    .byt 13
    .asc "L�'�br���؆�b�k!"
    .byt 0 


; For key mapping
keylist_msg
    .byt A_FWGREEN
    .asc "��G��Ke�"
    .byt 13
    .asc "�M�F�w�d�B�B�kw�ds"
    .byt 13
    .asc "�Z,X T�n��CTRL G���e"
    .byt 13
    .asc "�ESC D�p��-,=�Objɇs��t"
    .byt 13
    .asc "�T Togg����t�"
    .byt 0

; For initial scroller
; 23 characters max per line
; this   "����"

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
    .asc "r�awa�mo�� �e"
    .byt 0
    .asc "ca�away�� Mo�base"
    .byt 0
    .asc "��a� h�tl�"
    .byt 0
    .asc "��s�sp�e�blas�d"
    .byt 0
    .asc "f�m�E��'��b�"
    .byt 0
    .asc "b��nuc�� exp�s�,"
    .byt 0
    .asc "f� f� f�m�sol�"
    .byt 0
    .asc "s�."
    .byt 0
    .asc " "
    .byt 0
    .asc "�e�wayw��j��y"
    .byt 0
    .asc "�r�gh�iv�se,"
    .byt 0 
    .asc "tak��� t��d��"
    .byt 0
    .asc "�kn�n �ۺfi�d"
    .byt 0
    .asc "wh�h ������e�"
    .byt 0
    .asc "ex�t�c� En�m�s"
    .byt 0
    .asc "ra��� h�affɏd"
    .byt 0
    .asc "�e����s� �"
    .byt 0
    .asc "�l��s�n� h�be�"
    .byt 0
    .asc "ev�u𕿛m�e"
    .byt 0
    .asc "sɣ��d�r�nd"
    .byt 0
    .asc "�v����bas�"
    .byt 0
    .asc " "
    .byt 0
    .asc "��bu�C�ГJohn"
    .byt 0
    .asc "�wh�w��r�k"
    .byt 0
    .asc "h�lif���pa� �e"
    .byt 0
    .asc "affɏ�s߄�"
    .byt 0
    .asc "�����to"
    .byt 0
    .asc "Mo�bas���a."
    .byt 0
    .asc " "
    .byt 0
    .asc "H��l�d�b��if"
    .byt 0
    .asc "Doct� Ru��l�"
    .byt 0
    .asc "H��a�m�ag�g�"
    .byt 0
    .asc "��ju��S�ra" 
    .byt 0 
    .asc "�d�n ��e"
    .byt 0
    .asc "�d�r�n��v�s"
    .byt 0
    .asc "bef���e�w�e"
    .byt 0
    .asc "se���"
    .byt 0
    .asc " "
    .byt 0
    .asc " "
    .byt 0
    .asc " "
    .byt 0
    .asc "¯g���bas�"
    .byt 0
    .asc "�SPACE:1999 TV"
    .byt 0
    .asc "s�i�������"
    .byt 0
    .asc "NOISE��Nov� Or�"
    .byt 0
    .asc "IS��r� Eng�e��"
    .byt 0
    .asc "WHITE�W�ld-H�l�"
    .byt 0
    .asc "���t��t� wi�"
    .byt 0
    .asc "Env��m��lay�."
    .byt 0
    .asc " "
    .byt 0
    .asc "¯p�gr� h�be�"
    .byt 0
    .asc "c�����OSDK,"
    .byt 0
    .asc "�Or� S�twa�"
    .byt 0
    .asc "Dev��p��K�."
    .byt 0
    .asc " "
    .byt 0
    .asc "��P�gr�m�"
    .byt 0
    .asc "�(�bugg�ַ)"
    .byt 0
    .asc "� Ch�a"
    .byt 0
    .asc " "
    .byt 0
    .asc "�Graؙ���s�nd"
    .byt 0
    .asc "(�l�ra���Ma�)"
    .byt 0
    .asc "��Tw��h�"
    .byt 0
    .asc " "
    .byt 0
    .asc "��G����"
    .byt 0
    .asc "�(�DͦM�)"
    .byt 0
    .asc "��Dbug"
    .byt 0
    .asc " "
    .byt 0
    .asc "�Add���Co�"
    .byt 0
    .asc "�(�bugl��ַ)"
    .byt 0
    .asc "��Tw��h�"
    .byt 0
    .asc " "
    .byt 0
    .asc "�c�dі���c��"
    .byt 0
    .asc "��v���b�S�"
    .byt 0
    .asc " "
    .byt 0
    .asc "� 2008"
    .byt 0
    .asc " "
    .byt 0
    .asc " R��b��v���e"
    .byt 0
    .asc "�Or� f�um��"
    .byt 0
    .asc " www.�f�ce-f�cȊg"
    .byt 0
    .asc " "
    .byt 0
    .asc " An��f�tasc�si�"
    .byt 0
    .asc "�www.��g��.c�"
    .byt 0
    .asc " "
    .byt 0
    .asc "R��b������maps"
    .byt 0
    .asc "� �ؑ��m�u�."
    .byt 0
    .asc "W��y����?"
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
; French version: Put * to represent �
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Object descriptions
; Tiles with SPECIAL set
infopost  
    .asc "T�m���fos"
    .byt 0
alien_plant
    .asc "Pl�t��i�"
    .byt 0
meds_lab
    .asc "Syn���e� M��"
    .byt 0
benes_name
    .asc "S�r���"
    .byt 0
control_name
    .asc "P�� �c���d�p��s"
    .byt 0
circuit_name
    .asc "̽pr�cip�"
    .byt 0
monitor_name
    .asc "C�so�Ord��"
    .byt 0
passcode_name
    .asc "P�ַ�"
    .byt 0
Berg_pass     
    .byt A_FWGREEN
    .asc "�i�B�m�"
    .byt 0
Crew_pass     
    .byt A_FWGREEN
    .asc "�i�E�ipa�"
    .byt 0
Pool_pass 
    .byt A_FWGREEN
    .asc "P�c�e"
    .byt 0    
Storage_pass  
    .byt A_FWGREEN
    .asc "R���"
    .byt 0
Power_pass
    .byt A_FWGREEN
    .asc "S��du g���"
    .byt 0    
Hyd_pass  ;
    .byt A_FWGREEN
    .asc "���ta��Hyd�p�i��"
    .byt 0    
Door_ctrl_pass
    .byt A_FWGREEN
    .asc "C��P��"
    .byt 0
no_commlock_pass
    .asc "Ra�o-PÁ���"
    .byt 0

; Not in passcode bytes
benes_qtr
    .byt A_FWGREEN
    .asc "�i���"
    .byt 0

morrow_qtr
    .byt A_FWGREEN
    .asc "�i�M��ws"
    .byt 0

h_general
    .byt A_FWGREEN
    .asc "Ru�� G���"
    .byt 0

k_general
    .byt A_FWGREEN
    .asc "� G���"
    .byt 0


; Objects
Koenig_name
    .asc "John �"
    .byt 0

Helena_name
    .asc "H���Ru��"
    .byt 0

Commlink_name
    .asc "Ra�o-PÁ(�)"
    .byt 0

CommlinkH_name
    .asc "Ra�o-PÁ(Ru��)"
    .byt 0


Medkit_name
    .asc "M�ik�"
    .byt 0
Notepad_name
    .asc "B�cΏ"
    .byt 0
Battery_name
    .asc "B�t�ie"
    .byt 0
plantjuice_name
    .asc "Elix� �g��"
    .byt 0
compound_name
    .asc "Pot��� ��"
    .byt 0

key_name
    .asc "C�f"
    .byt 0

relay_name;
    .asc "R�a�r�g��H�r� E�c뉙s"
    .byt 0

resistor_name
    .asc "R��t�ce"
    .byt 0

chip_name
    .asc "Puc�M�oi�"
    .byt 0

fuse_name
    .asc "F�ѱ"
    .byt 0
inductor_name
    .asc "�duc��"
    .byt 0
screwdriver_name
    .asc "T��v�"
    .byt 0
wire_name
    .asc "F� �f�"
    .byt 0
oil_name
    .asc "Hui��oli�"
    .byt 0

;Chair_name was here

zx81_name
    .asc "ZX81 �bo�n�toye�"
    .byt 0
No_name
    .asc "P��obje��o�i"
    .byt 0


; Messages from characters

Helena_comlock
    .byt "H��a:"
    .byt 0
Helena_1
    .byt A_FWGREEN
    .asc "John�vi��m'aid��׌f�m�ie"
    .byt 0
Helena_2
    .byt A_FWGREEN
    .asc "N޷v��p�ag�΄p��d�"
    .byt 0
Helena_3
    .byt A_FWGREEN
    .asc "Vi��John."
    .byt 0

key
    .byt A_FWRED; 
    .asc "��(PRESS)"   
    .byt 0

Helena_spch_1;
    .byt 6
    .asc "���t��m�a��p� la"
    .byt 0
    .asc "so�n��� m�f��� ǎ����i"
    .byt 0
    .asc "n�eu��r�ex�a����pl��s"
    .byt 0
    .asc "�i�s��i쉇�ocke��s"
    .byt 0
    .asc "�hyd�p�i�e�ma�� ���ta�e"
    .byt 0
    .asc "e�m�Ώ�s����m���b�."
    .byt 0
Helena_spch_2
    .byt 3
    .asc "M�ci�John."
    .byt 0
    .asc "J�do��t�n��m� lՊ�oi�" 
    .byt 0
    .asc "p���ړ��t�."
    .byt 0

Benes_spch_1a
    .byt 7
    .asc "R��l� ׅ�i���i���ux"
    .byt 0
    .asc "�t���Պ��ړ�g���"
    .byt 0
    .asc "pu�׊d���J'ai �j�br�o�"
    .byt 0
    .asc "�g���ma��c � ̚"
    .byt 0
    .asc "bi� �p faіe�� �m'��l�"
    .byt 0
    .asc "� v�ag� L�̚� P�l� "
    .byt 0
    .asc "���ַ�"
    .byt 0

Benes_uncon
    .asc "���sci��."
    .byt 0

Benes_awake
    .asc "S�n�Ra�o-P�e��s'e���."
    .byt 0

Benes_intro
    .asc "��vr�l�yeux e��saie"
    .byt 13
    .asc "��l�:"
    .byt 0

Benes_end
    .asc "El��t�b����c�a."
    .byt 0

Benes_spch_2; MAXIMUS  error ****
    .byt 5
    .asc "P� �ړ׊d�� tu do�"
    .byt 0
    .asc "��g��̽���"
    .byt 0
    .asc "pr�d�� � ���tձ�"
    .byt 0
    .asc "d�sߞv��x� m���ַ�"
    .byt 0
    .asc "prud�ce� �vr��̚�"
    .byt 0

Koenig_spch_1
    .byt 2
    .asc "V�p�ړ�m���t."
    .byt 0
    .asc "J�va���l���."
    .byt 0

restore_power_msg
    .byt 3
    .asc "On do��t�l� ׅ�i��c" 
    .byt 0
    .asc "�̽p��s�� S�ra."
    .byt 0
    .asc "El����i����P�l�"
    .byt 0

restore_comp_msg
    .byt 3
    .asc "On do��ړ׊d��"
    .byt 0
    .asc "c��S�r�בd��ma�� �a"
    .byt 0
    .asc "� �g��"
    .byt 0

pauls_list_msg
    .asc "L'�r�m�끖s�͑�"
    .byt 13
    .asc "simp�̽a�si �'�e"
    .byt 13 
    .asc "s�t��l��:"
    .byt 13
    .byt "Ba:HYP��:APH�Re:HS"
    .byt 0

; Game messages
alarm_pwr_msg
    .asc "WARNING�P�n�߁E�c�i��"
    .byt 0
gameover_msg
    .asc "GAME OVER"
    .byt 0
gamefinished_msg
    .asc "MISSION ACCOMPLIE"
    .byt 0
helenadead_msg
    .asc "Dr�Ru��ꒇm��."
    .byt 0
koenigdead_msg
    .asc "C�І�� ��m�t."
    .byt 0
benesdead_msg
    .asc "S�r����m��."
    .byt 0
lowpower_msg
    .byt 1
    .asc "WARNING�En�i�faѱ!"
    .byt 0
lowlifesup_msg
    .byt 1
    .asc "WARNING�sߞv��x fa�l�!"
    .byt 0
cannottake_msg; MAXIMUS error ****
    .asc "Imٔі�pr�dr�ca."
    .byt 0
cantdrop_msg; MAXIMUS error ****
    .asc "Imٔі��s��i."
    .byt 0
no_space_inv; MAXIMUS error ****
    .asc "Imٔі�pr�dr�lu��obj�ts."
    .byt 0
cantopendoor; MAXIMUS error ****
    .asc "L�p�t���v�r����"
    .byt 0
door_jammed
    .asc "C�t��t���b��ee�"
    .byt 0
lubricate_door_msg
    .asc "�grippe��p�t��c �hu��"
    .byt 0
bergmandoor_msg
    .asc "Iꒇ�r��Dr�B�m�."
    .byt 0
keynofits_msg
    .asc "C�t�c�f n'�vr��c�t���."
    .byt 0
keyfits_msg
    .asc "�v���p�t��c �c�f."
    .byt 0
unpowered_msg
    .asc " (e��t)"
    .byt 0
powered_msg
    .asc " (�lume)"
    .byt 0
newpass_msg
    .asc "N�����֩�sm�"
    .byt 13
    .asc "� Ra�o-P�e"
    .byt 0
plant_taken_msg; 
    .asc "����e��ex�a�."
    .byt 0
plant_taking_msg; 
    .asc "�pr�eҰ�dos��ex�a�."
    .byt 0
create_medicine_msg
    .asc "�c�eҰ��t��� ��."
    .byt 0
dont_know_msg
    .asc "J�n�a�p�c���ut���*a."
    .byt 0

;notnow_msg
;    .asc "C'��p�m���!"
;    .byt 0

need_pass
    .asc "I�f�����֩p� ut���*a."
    .byt 0

missing_notepad_msg
    .asc "J'ai b�o� �m�Ώ�p�"
    .byt 13
    .asc "p�ړ�m���t."
    .byt 0

cure_koenig_msg
    .asc "�so����."
    .byt 0

door_ctrlo_msg
    .asc "Un�lumi��r�g�'�lum�"
    .byt 0

door_ctrlc_msg
    .asc "L�lumi��r�g�'e��t."
    .byt 0

wrong_panel_msg; 
    .asc "Imٔі�ut���c���i."
    .byt 0
place_item_msg
    .asc "�pl�e��obje����̚."
    .byt 0
wrong_item_msg
    .asc "Ce�obje�n�'adapt�� ̚."
    .byt 0
power_repaired_msg
    .asc "En�i�OK� � t� �׊d��."
    .byt 0
no_screwdriver_msg; 
    .asc "Imٔі��t���puce"
    .byt 13
    .asc "s���b� �t�."
    .byt 0
burntout_chip_msg; 
    .asc "I꺑��uc�HS �i."
    .byt 0
get_chip_msg
    .asc "�ti���puc��s�"
    .byt 13
    .asc "supp�t."
    .byt 0
already_fixed_msg
    .asc "Mieux v��n��t���p��t"
    .byt 13
    .asc "�'� f�ct�n�"
    .byt 0
place_chip_msg
    .asc "�mpl�e��puc�gr���"
    .byt 13
;power_restored_msg
    .asc "��Ҏt�li ׅ�i����a."
    .byt 13
    .asc "C'��du B� b���!!!"
    .byt 0
ls_fail_msg;
    .asc "S߁v��x ���n�!"
    .byt 0
ls_back_msg; 
    .asc "Sߞv��x �pa�s"
    .byt 0
ls_bypassed_msg
    .asc "�c�eҰ c�t-̽�" 
    .byt 13
    .asc "��g�c�se"
    .byt 0
put_fuse_msg
    .asc "ﴆ�Җf�іHS"
    .byt 0
not_fuse_msg
    .asc "L�Syn���e���b�����"
    .byt 13
    .asc "�c� voy��n�'�lum�"
    .byt 13; 
    .asc "C��s�b�simp���ڃ�"
    .byt 0
;no_fix_msg
;    .asc "imٔі��ړ�c *a�"
;    .byt 0
no_medicine_msg
    .asc "Imٔі�fa��� m���t"
    .byt 13
    .asc "�c *a"
    .byt 0

hundred_msg
    .asc "100"
    .byt 0
percent_msg
    .asc "��c�t"
    .byt 0
infopost_menu_msg
    .asc " "
    .byt A_FWGREEN
    .asc "S��g����"    ; 17 chars
    .asc "�"
    .asc "P��d���"     ; 16 chars
    .byt 32,13
    .asc " "
    .byt A_FWGREEN
    .asc "Ch�g�jeu��"
    .asc "�"
    .asc "S�n�Volume�"
    .byt 32,13
    .asc " "
    .byt A_FWGREEN
    .asc "�ؑSt���"
    .asc "�"
    .asc "P�g�s�du jeu "     ; NEED TRANSLATION TO Game progress ****** > LATIN WORD > same in french (like idem) *********
    .byt 32,13
    .asc " "
    .byt A_FWGREEN
    .asc "C��a��"
    .asc "�"
    .asc "Ex���"
    .byt 32,0

gamesaved_msg
    .asc "P�i堤g��e"
    .byt 0
gamerestored_msg
    .asc "P�i����e"
    .byt 0
sure_to_save_msg
    .asc "P��e�CTRL���v�"
    .byt 0
sure_to_restore_msg
    .asc "P��e�CTRL�� ��g��p�ie"
    .byt 0
anykey_msg; 
    .asc "ESC���Ã"
    .byt 0
abort_msg; 
    .asc "�nu��"
    .byt 0
invalidsave_msg
    .asc "S��g���v�i�"
    .byt 0

infopost_start
    .byt A_FWYELLOW
    .asc "�B�n���f�m�� ��a"
    .byt 0
infopower_msg
    .byt A_FWGREEN
    .asc " En�ie�"
    .byt 0
infols_msg
    .byt A_FWGREEN
    .asc " SߞV��x�"
    .byt 0

info_tv_intro
    .byt A_FWGREEN
    .asc "C�t��a�e:"
    .byt 0
tv_1_msg
    .byt A_FWGREEN
    .asc " St� T�k III�S�ck �d��u"
    .byt 0
tv_2_msg
    .byt A_FWGREEN
    .asc " °d�b�ds"
    .byt 0
tv_3_msg
    .byt A_FWGREEN
    .asc " 2001��ody�e���Esp�e"
    .byt 0
tv_4_msg
    .byt A_FWGREEN
    .asc " Mi�� Imٔѱ"
    .byt 0


toggle_msg  
    .asc "���l��"
    .byt 0
can_toggle_msg
    .asc "�p��Ҵ�g��p�s�na�"
    .byt 0
cant_toggle_msg
    .asc "Imٔі���g��p�s�na�"
    .byt 0
cant_toggle_msg2
    .asc "Imٔі�c ���t��v��"
    .byt 0



; Lifts
lift_speech  
    .asc "�� ni���"
    .byt 0 
liftno_msg
    .asc "Asc�ce�솄���i�"
    .byt 0

; Room names
main_mission_name
    .asc "Pos��Pr�cip�"
    .byt 0
corridor_name
    .asc "�C�rid��"
    .byt 0

command_room_name
    .asc "�C���m�t�"
    .byt 0
koenig_quart_name
    .asc "�� ��"
    .byt 0
russel_quart_name
    .asc " Ru�����"
    .byt 0

benes_quart_name
    .asc "���.�"
    .byt 0

bergman_quart_name
    .asc " B�m���"
    .byt 0

morrow_quart_name
    .asc " M��w �.�"
    .byt 0

hisec_name;
    .asc "�H�-Sɣi��"
    .byt 0

security_name
    .asc "�Sɣi��"
    .byt 0

life_support_name; 
    .asc "Sߒ�v��x"
    .byt 0

meds_lab_name
    .asc "�Lզm���"
    .byt 0

astro_name
    .asc " A���i�e�"
    .byt 0

power_name
    .asc "�G���"
    .byt 0

computer_name
    .asc "�Ord��"
    .byt 0

storage_name
    .asc "�R����"
    .byt 0

chem_lab_name;
    .asc "�Lզ�imie�"
    .byt 0

research_name
    .asc " LզRe����"
    .byt 0

meds_name; 
    .asc " C��M��"
    .byt 0

dining_name
    .asc "�C�t���"
    .byt 0

lounge_name
    .asc "�S����"
    .byt 0

quarters_name;
    .asc "CՌ�E�ipa�"
    .byt 0

leisure_name
    .asc "�Z��D����"
    .byt 0

hydroponics_name; 
    .asc " Hyd�p�i�e�"
    .byt 0

;; For floor names
levelH_name
    .asc "Ni�� H�"
    .byt 0

levelG_name
    .asc "Ni�� G�"
    .byt 0

levelCTRL_name
    .asc "Sߒ�"
    .byt 0

levelMM_name
    .asc "Po�Pr�cip�"
    .byt 0


;************** Need translation *****************************>  JOB DONE BOSS - MAXIMUS  :-)  ******
; ALSO ITEM 7 of MENU (see above) >>  OK :-)

version_name
    .asc " ESC�� j��"
    .byt 0

infoprogress_msg
    .asc "��Ҏsolu�"
    .byt 0

needcircuit_msg
    .asc "�n���̽���"
    .byt 0

; Sound setting
sound_menu_txt
    .asc "Ni��쉊e�"
    .byt 0
sound_high_name
    .asc "D��g�l�vo��s"
    .byt 0
sound_med_name
    .asc "Ambi�c�ag�ձ�"
    .byt 0
sound_low_name
    .asc "J'ai �m�ra�e�"
    .byt 0
sound_off_name
    .asc "Iꒇ��t�d�"
    .byt 0


end_speech1_msg
    .asc "H��a�faіni�� �Ra���."
    .byt 13
    .asc "T���g���ɻ�John�"
    .byt 0

end_speech2_msg
    .asc "�l�Sߞf�ct�n�t�"
    .byt 13
    .asc "ma��j����c�t�fo��"
    .byt 0

end_speech3_msg
    .asc "�Ord��r��v����l�"
    .byt 13
    .asc "ni��x �f�ie�s."
    .byt 13
    .asc "Rapp���l�h՚�t����a."
    .byt 0 


; For key mapping
keylist_msg
    .byt A_FWGREEN
    .asc "��C��l�"
    .byt 13
    .asc "�M�Av�c��B�Re�l�"
    .byt 13
    .asc "�Z,X T�n��CTRL Act�"
    .byt 13
    .asc "�ESC Pos��-,=�Obj�"
    .byt 13
    .asc "�T Ch�g��P�s�na�"
    .byt 0


; this   "����"
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
    .asc "L�l����d�i��"
    .byt 0
    .asc "l�n�frag��la"
    .byt 0
    .asc "Bas���a���je�e"
    .byt 0
    .asc "��גp�e�expulsee"
    .byt 0
    .asc "�s� �b��t���"
    .byt 0
    .asc "� ��exp�s�,"
    .byt 0
    .asc "nuc�a���� du"
    .byt 0
    .asc "s��olai�."
    .byt 0
    .asc " "
    .byt 0
    .asc "Le� capr�ieux voya�"
    .byt 0
    .asc "��av���Univ�s,"
    .byt 0 
    .asc "l��du�f����"
    .byt 0
    .asc "��p ��i���nu"
    .byt 0
    .asc "�i m�����"
    .byt 0
    .asc "ex�t�c� 腊m�"
    .byt 0
    .asc "ra�������t�e"
    .byt 0
    .asc "�c��a���ie"
    .byt 0
    .asc "e�t���p�s�n� a"
    .byt 0
    .asc "��ev�u���ɣi�"
    .byt 0
    .asc "v��l�ni��x"
    .byt 0
    .asc "�f�ie����bas�"
    .byt 0
    .asc " "
    .byt 0
    .asc "T�s�f C�Ѓ"
    .byt 0
    .asc "John ৾i r��e"
    .byt 0
    .asc "s�vi�� �ړl�"
    .byt 0
    .asc "sߞ���n��"
    .byt 0
    .asc "�t�l� ׅ�i��s"
    .byt 0
    .asc "�bas�l�a����a."
    .byt 0
    .asc " "
    .byt 0
    .asc "S�seu���i�u�:"
    .byt 0
    .asc "Doct� Ru��l�"
    .byt 0
    .asc "H��a���適"
    .byt 0
    .asc "d�c�dr�S�r���" 
    .byt 0 
    .asc "gr�m��bl�se�v�s"
    .byt 0
    .asc "l�ni��x �f�ie�s"
    .byt 0
    .asc "av���'��n�oi�t"
    .byt 0
    .asc "v�r��l��"
    .byt 0
    .asc " "
    .byt 0
    .asc " "
    .byt 0
    .asc " "
    .byt 0
    .asc "C�jeu ���sp���"
    .byt 0
    .asc "�s�i�TV Cosmos1999,"
    .byt 0
    .asc "� ut���NOISE�Nov�"
    .byt 0
    .asc "Or� IS��r� Eng�e"
    .byt 0
    .asc "��WHITE:"
    .byt 0
    .asc "W�ld-H�l�"
    .byt 0
    .asc "���t��t� wi�"
    .byt 0
    .asc "Env��m��lay�."
    .byt 0
    .asc " "
    .byt 0
    .asc "C��gr�m��e�"
    .byt 0
    .asc "c���c �OSDK,"
    .byt 0
    .asc "�Or� S�twa�"
    .byt 0
    .asc "Dev��p��K�."
    .byt 0
    .asc " "
    .byt 0
    .asc "��P�gr�m��"
    .byt 0
    .asc "�(�bugg�ַ)"
    .byt 0
    .asc "� Ch�a"
    .byt 0
    .asc " "
    .byt 0
    .asc "�Graءm�e�s�s"
    .byt 0
    .asc "(C�plim�t�� Ma��)"
    .byt 0
    .asc "��Tw��h�"
    .byt 0
    .asc " "
    .byt 0
    .asc "��G����"
    .byt 0
    .asc "�(�DͦM�)"
    .byt 0
    .asc "��Dbug"
    .byt 0
    .asc " "
    .byt 0
    .asc "�Add���Co�"
    .byt 0
    .asc "�(�bugl��ַ)"
    .byt 0
    .asc "��Tw��h�"
    .byt 0
    .asc " "
    .byt 0
    .asc "�c�dі���c��"
    .byt 0
    .asc "��v���b�S�"
    .byt 0
    .asc " "
    .byt 0
    .asc "� 2008"
    .byt 0
    .asc " "
    .byt 0
    .asc " P�seґv���l�"
    .byt 0
    .asc "�f�um�Or��"
    .byt 0
    .asc " www.�f�ce-f�cȊg"
    .byt 0
    .asc " "
    .byt 0
    .asc " E��s���jeux�"
    .byt 0
    .asc "�www.��g��.c�"
    .byt 0
    .asc " "
    .byt 0
    .asc "L�c�����ؑs�t"
    .byt 0
    .asc "f�ni����m�u�"
    .byt 0
    .asc "Au c��v�s�iez" 
    .byt 0
    .asc "p�du ?"
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

