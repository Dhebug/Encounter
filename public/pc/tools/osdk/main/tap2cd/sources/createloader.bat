%OSDK%\bin\xa loader.s
%OSDK%\bin\bin2txt -f1 a.o65 loader_crc.h loader_check_crc
%OSDK%\bin\xa loader_no_checksum.s
%OSDK%\bin\bin2txt -f1 a.o65 loader_nocrc.h loader_no_check
%OSDK%\bin\xa loader_df.s
%OSDK%\bin\bin2txt -f1 a.o65 loader_df.h loader_df
