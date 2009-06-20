program taptap;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  classes,windows;

procedure Tips;
begin
  WriteLn('Syntax :');
  Writeln('--------');
  Writeln('Catalog :');
  Writeln('  ',ExtractFileName(ParamStr(0)),' cat <File>');
  Writeln('    <File>.... : Tap file to be processed - mandatory');
  writeln('  Example : ',ExtractFileName(ParamStr(0)),' cat myfile.tap');
  writeln;
  Writeln('Rename an Oric file in a .tap File :');
  writeln('  ',ExtractFileName(ParamStr(0)),' ren <TapFile> <Newname> <FileIndex>');
  writeln('    <FromFile>. : Tap file to be processed - mandatory');
  writeln('    <NewName>.. : New file name of the oric file to be processed -mandatory');
  writeln('                  The New oric file name can be specified');
  writeln('                  in 2 different ways');
  writeln('                  - as a string : in that case it must be');
  writeln('                    enclosed between quotes');
  writeln('                    examples : "Space Invaders", "Terror of the deep",...');
  writeln('                  - as a succession of 8 bits hexadecimal');
  writeln('                    values (2 digits each), without any space');
  writeln('                    It then permits to have some text attributes');
  writeln('                    into the oric title : ink or paper color, blink...');
  writeln('                        (please refer to Oric manual for values).');
  writeln('                    In that case, the string must be preceeded by');
  writeln('                    the # symbol and the null hexadecimal values (INK 0)');
  writeln('                    are forbidden.');
  writeln('                    example : #0148656C6C6F07');
  writeln('                    ...will print "Hello" in red on the status line');
  writeln('                       while loading.');
  writeln('    <FileIndex> : File index in Tap File, 0 is the 1st file,');
  writeln('                  index 1 the 2nd, etc - Mandatory');
  writeln;
// TODO :
//  Writeln('Split a tap File :');
//  Writeln('Join a tap File :');
  writeln('Set Auto run On or Off :');
  writeln('   Simply write');
  writeln('  ',ExtractFileName(ParamStr(0)),' AutoOn <TapFile> <FileIndex>');
  writeln('   or');
  writeln('  ',ExtractFileName(ParamStr(0)),' AutoOff <TapFile> <FileIndex>');
end;

function GetTempFile(const Extension: string): string;
var
  Buffer: array[0..MAX_PATH] of Char;
begin
  repeat
    GetTempPath(SizeOf(Buffer) - 1, Buffer);
    GetTempFileName(Buffer, '~', 0, Buffer);
    Result := ChangeFileExt(Buffer, Extension);
  until not FileExists(Result);
end;

procedure SetAuto(value:boolean);
var f1:TFileStream;
    b:byte;
    hheader:array[0..8] of byte;
    name:string;
    index,i,j,r,size:integer;
    AddrDeb,AddrFin:integer;
    TempFile,bb,cc:string;
begin
  index:=0;
  f1:=TFileStream.Create(ParamStr(2),fmOpenReadWrite);
  try
    f1.Position:=0;
    while (f1.Position<f1.size) do
    begin
      b:=$16;
      while (b=$16) do r:=f1.Read(b,1); // read synchro (0x24 included)
      if (f1.Position>=f1.size) then break;

      //header
      for i:=0 to 8 do
      begin
         if ((i=3) and (index<>StrToIntDef(ParamStr(3),-1))) then begin
                       if value then b:=$C7 else b:=0;
                       f1.Write(b,1);
                     end
         else r:=f1.Read(b,1);
      end;

      //Name
      name:='';
      repeat
        r:=f1.Read(b,1);
      until ((b=0) or (r=0));

      //data
      AddrDeb:=hheader[6]*256+hheader[7];
      AddrFin:=hheader[4]*256+hheader[5];
      size:=AddrFin-AddrDeb+1;
      for i:=0 to size-1 do r:=f1.Read(b,1);
      inc(index);
    end;
  finally
    f1.Free;
  end;
end;

procedure rename;
var f1,f2:TFileStream;
    b:byte;
    hheader:array[0..8] of byte;
    name:string;
    index,i,j,r,size:integer;
    AddrDeb,AddrFin:integer;
    TempFile,bb,cc:string;
begin
  index:=0;
  TempFile:=GetTempFile('.~tp');
  f1:=TFileStream.Create(ParamStr(2),fmOpenRead);
  f2:=tfilestream.Create(TempFile,fmCreate);
  try
    f1.Position:=0;
    while (f1.Position<f1.size) do
    begin
      b:=$16;
      while (b=$16) do begin
                         r:=f1.Read(b,1); // read synchro (0x24 included)
                         if r=1 then f2.Write(b,1);
                       end;
      if (f1.Position>=f1.size) then break;

      //header
      for i:=0 to 8 do
      begin
         r:=f1.Read(b,1);
         hheader[i]:=b;
         if r=1 then f2.Write(b,1);
      end;

      //Name
      name:='';
      repeat
        r:=f1.Read(b,1);
        if ((index<>StrToIntDef(ParamStr(4),-1)) and (r=1))
        then f2.Write(b,1);
      until ((b=0) or (r=0));

      if (index=StrToIntDef(ParamStr(4),-1)) then
      begin
        bb:=ParamStr(3);
        case bb[1] of
          '#':begin
                    j:=(length(bb)-1) div 2;
                    for i:=0 to j-1 do
                    begin
                      cc:='$'+bb[2*i+1]+bb[2*i+2];
                      r:=StrToIntdef(cc,-1);
                      if r>0 then b:=r
                             else b:=32;
                      f2.Write(b,1);
                    end;
                  end
          else for i:=1 to length(bb) do f2.Write(bb[i],1);
        end;
        b:=0;
        f2.Write(b,1);
      end;

      //data
      AddrDeb:=hheader[6]*256+hheader[7];
      AddrFin:=hheader[4]*256+hheader[5];
      size:=AddrFin-AddrDeb+1;
      for i:=0 to size-1 do begin
                              r:=f1.Read(b,1);
                              if r=1 then f2.Write(b,1);
                           end;
      inc(index);
    end;
  finally
    f1.Free;
    f2.Free;
    CopyFile(PChar(TempFile),PChar(ParamStr(2)),false);
    SysUtils.DeleteFile(TempFile);
  end;
end;

procedure catalog(FileName:string);
var f1:TFileStream;
    b:byte;
    size:integer;
    hheader:array[0..8] of byte;
    name:string;
    namehex:string;
    index,i:integer;
    AddrDeb,AddrFin:integer;
    specialname:boolean;
begin
  index:=0;
  f1:=TFileStream.Create(FileName,fmOpenRead);
  try
    writeln('Catalog of "',extractfilename(FileName),'"');
    f1.Position:=0;
    while (f1.Position<f1.size) do
    begin
      specialname:=false;
      b:=$16;
      while (b=$16) do f1.Read(b,1); // read synchro (0x24 included)
      if (f1.Position>=f1.size) then break;

      //header
      for i:=0 to 8 do
      begin
         f1.Read(b,1);
         hheader[i]:=b;
      end;

      //Name
      name:='';
      namehex:='';
      repeat
        i:=f1.Read(b,1);
        if ((b<>0) and (i<>0)) then
        begin
           namehex:=namehex+IntToHex(b,2)+' ';
           if b>=32 then name:=name+chr(b)
           else begin
                   specialname:=true;
                   name:=name+' ';
                end;
        end;
      until ((b=0) or (i=0));
      AddrDeb:=hheader[6]*256+hheader[7];
      AddrFin:=hheader[4]*256+hheader[5];
      size:=AddrFin-AddrDeb+1;

      writeln('Index.... : ',index);
      write('Name..... : ',name);
      if specialname then writeln('('+namehex+')')
                     else writeln;
      write('File kind : ');
      case hheader[2] of
        $00:writeln('BASIC');
        $40:writeln('Array');
        $80:writeln('Machine code or memory bloc');
        else writeln('#',inttohex(hheader[2],2));
      end;
      write('Auto..... : ');
      case hheader[3] of
        $00:writeln('No');
      else writeln('Yes (#',inttohex(hheader[3],2),')');
      end;
      writeln('Starting Address : #',IntToHex(AddrDeb,4));
      writeln('Ending   Address : #',IntToHex(AddrFin,4));
      writeln('Size............ : ',size,' bytes');
      writeln;
      //data
      for i:=0 to size-1 do begin
                              f1.Read(b,1);
                           end;
      inc(index);
    end;
  finally
    f1.Free;
  end;
end;

procedure ExecuteProgram;
var command:string;
begin
  if ParamCount=0
  then begin
          tips;
          exit;
       end;
  if ParamCount>1
  then command:=ParamStr(1);
  if uppercase(command)='CAT' then
  begin
    if ((ParamCount=2) and FileExists(ParamStr(2)))
    then catalog(ParamStr(2))
    else begin
           case ParamCount of
           1:writeln('Not enough parameters !');
           2:writeln('The file ',ParamStr(2),' does not exist !');
           else writeln('too many parameters !');
           end;
           tips;
           exit;
         end;
  end
  else if uppercase(command)='REN' then
  begin
    if ParamCount<4 then
    begin
      writeln('Not enough parameters !');
      tips;
      exit;
    end;
    if ParamCount>4 then
    begin
      writeln('Too many parameters !');
      tips;
      exit;
    end;
    if ParamCount=4 then
    begin
      if not FileExists(ParamStr(2)) then
      begin
        writeln('The file ',ParamStr(2),' does not exist !');
        tips;
        exit;
      end;
      rename;
     end;

  end
  else if uppercase(command)='AUTOON' then
  begin
    if ParamCount<3 then
    begin
      writeln('Not enough parameters !');
      tips;
      exit;
    end;
    if ParamCount>3 then
    begin
      writeln('Too many parameters !');
      tips;
      exit;
    end;
    if ParamCount=3 then
    begin
      if not FileExists(ParamStr(2)) then
      begin
        writeln('The file ',ParamStr(2),' does not exist !');
        tips;
        exit;
      end;
      SetAuto(true);
    end;

  end
  else if uppercase(command)='AUTOOFF' then
  begin
    if ParamCount<3 then
    begin
      writeln('Not enough parameters !');
      tips;
      exit;
    end;
    if ParamCount>3 then
    begin
      writeln('Too many parameters !');
      tips;
      exit;
    end;
    if ParamCount=3 then
    begin
      if not FileExists(ParamStr(2)) then
      begin
        writeln('The file ',ParamStr(2),' does not exist !');
        tips;
        exit;
      end;
      SetAuto(false);
    end;
  end
  // TODO ???
  //else if command='split' then
  //  begin
  //  end
  //  else if command='join' then
  //  begin
  //  end
  else tips;
end;
begin
  try
    ExecuteProgram;
  except
    //Gérer la condition d'erreur
    WriteLn('Error encountered, this program terminates...');
    //Définir ExitCode <> 0 pour indiquer la condition d'erreur (par convention)
    tips;
    ExitCode := 1;
  end;
end. 