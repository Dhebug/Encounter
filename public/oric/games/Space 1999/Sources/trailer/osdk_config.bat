@ECHO OFF

::
:: Set the build paremeters
::
SET OSDKADDR=$600
SET OSDKNAME=INTRO
SET OSDKFILE=main draw sound draw_df_logo text sequences
SET OSDKFILE=%OSDKFILE% pic_logo pic_landau pic_bain pic_producer pic_itc pic_episode pic_morse pic_sylvia pic_font pic_defenceforce pic_misc
SET OSDKFILE=%OSDKFILE% tables 
SET OSDKFILE=%OSDKFILE% costable 

::SET OSDKFILE=pouet
::SET OSDKLINK=-B
SET OSDKTAPNAME="SPINTRO"
SET OSDKDISK= BUILD/%OSDKNAME%.TAP
SET OSDKINIST="HIRES:SPINTRO"

::SET OSDKDOSBOX=




