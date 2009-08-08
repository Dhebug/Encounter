;CommonDefines.s

;32-95	0-63 Numerics
;96-107	0-11 Notes
;108-117	0-9  Single Digits
;118-118	Hyphen
;119-120	Bar Graphic
;121-122	Rest Graphic
;123-123	Channel Command Flag
;124-124  Command Graphic
;125-127  3 Spare Characters

#define SIXTYFOUR_CHARACTERBASE	32
#define SINGLEDIGITS_CHARACTERBASE	108
#define COMMAND_CHARACTER		124
#define HYPHEN_CHARACTER		118
#define BAR_CHARACTER		119
#define SPARE_CHARACTER1		120
#define SPARE_CHARACTER2		121
#define SPARE_CHARACTER3		122
#define CHANNELCOMMANDFLAG_CHARACTER	123
#define MIMICLEFT_CHARACTER		125
#define MIMICRIGHT_CHARACTER		126
#define TRACKPARTITION_CHARACTER	127

#define SYS_IRQVECTOR		$245

#define VIA_PORTB			$0300
#define VIA_T1CL 			$0304
#define VIA_T1CH 			$0305
#define VIA_T1LL 			$0306
#define VIA_T1LH 			$0307
#define VIA_T2CL                	$0308
#define VIA_T2LL                	$0308
#define VIA_T2CH 			$0309
#define VIA_SR   			$030A
#define VIA_ACR  			$030b
#define VIA_PCR  			$030c
#define VIA_IFR  			$030D
#define VIA_IER  			$030E
#define VIA_PORTA			$030F

#define PCR_SETREGISTER		$FF
#define PCR_SETINACTIVE		$DD
#define PCR_WRITEVALUE		$FD
#define PCR_CB2PULSEMODE		%10111101

;#define DVS_SID			3
;#define DVS_BUZZER			4
;#define DVS_PULSAR			5
;#define DVS_DIGIDRUMLO		6
;#define DVS_DIGIDRUMHI		7

#define PORTB_KEYROW		7
#define PORTB_KEYBIT		8

#define SOFT_CTRL			4
#define SOFT_SHFT			1
#define SOFT_FUNC			3

#define AY_REGISTERS		0
#define AY_PITCHAL			0
#define AY_PITCHAH                      1
#define AY_PITCHBL                      2
#define AY_PITCHBH                      3
#define AY_PITCHCL                      4
#define AY_PITCHCH                      5
#define AY_NOISE                        6
#define AY_STATUS                       7
#define AY_VOLUMEA                      8
#define AY_VOLUMEB                      9
#define AY_VOLUMEC                      10
#define AY_PERIODL                      11
#define AY_PERIODH                      12
#define AY_EGCYCLE                      13
#define AY_REGCOLUMN		14

#define AYRegisterReference		$BFE0

#define TRACKPROPERTY_ACTIVEPATTERN	%00010000
#define TRACKPROPERTY_ACTIVETIMESLOT	%00100000
#define TRACKPROPERTY_ACTIVEEFFECT	%01000000
#define TRACKPROPERTY_NOTEISVALUE	%10000000

#define DSM_CLEARPREVIOUS		64
#define DSM_INVERT			128

#define SwitchOutROM		$04F2
#define SwitchInROM			$04F2
#define DiscErrorNumber		$04FD

#define BIT0			1
#define BIT1			2
#define BIT2			4
#define BIT3			8
#define BIT4			16
#define BIT5			32
#define BIT6			64
#define BIT7			128

#define PARTITION_NAVIGATE		128
#define PARTITION_MODIFY		129
#define PARTITION_OPERATERS		130
#define PARTITION_COPYING		131
#define PARTITION_PLAY		132
