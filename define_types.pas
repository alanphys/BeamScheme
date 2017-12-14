unit define_types;
{$IFDEF FPC}      //ACC 1/7/2009
   {$mode delphi}
{$ENDIF}

interface
{$IFDEF LINUX}
   {$IFDEF FPC}  //workaround for Kylix-ACC 12/6/2009
   uses SysUtils,Dialogs,Controls,classes;
   {$ELSE}
   uses SysUtils,QDialogs,QControls,classes;
   {$ENDIF}
{$ELSE}
uses
  Windows,SysUtils,Dialogs,Controls,classes {tstrings};
{$ENDIF}

const
     PixelCountMax = 32768;
     kTab = chr(9);
     kEsc = chr(27);
     kCR = chr (13);
{$IFDEF LINUX}
{$ELSE}
       PathDelim = '\';
{$ENDIF}

type
{$IFDEF Linux}
  TRGBtriple = PACKED RECORD
        rgbtBlue,rgbtGreen,rgbtRed,trgbreserved: byte;
  end;
{$ENDIF}
  TRGBquad = PACKED RECORD
        rgbBlue,rgbGreen,rgbRed,rgbreserved: byte;
  end;

DICOMdata = record
   XYZdim: array [1..4] of integer;   //4=volume, eg time: some EC*T7 images
   XYZori: array [1..3] of integer;
   XYZmm: array [1..3] of double;
   Rotate180deg,Float,RunLengthEncoding,GenesisCpt,JPEGlosslessCpt,
   JPEGlossyCpt,ElscintCompress,MinIntensitySet: boolean;
   IntenScale,IntenIntercept,kV,mA,TR,TE,spacing,location: single;
   SiemensInterleaved {0=no,1=yes,2=not defined},SiemensSlices,SiemensMosaicX,SiemensMosaicY,CompressSz,CompressOffset,SeriesNum,AcquNum,ImageNum,Monochrome,SamplesPerPixel,PlanarConfig,ImageStart,little_endian,
   Allocbits_per_pixel,Storedbits_per_pixel,ImageSz,accession,
   PatientIDint,VolumeNumber,WindowWidth,WindowCenter,GenesisPackHdr, NamePos,StudyDatePos,MinIntensity,MaxIntensity,
   RLEredOffset,RLEgreenOffset,RLEblueOffset,RLEredSz,RLEgreenSz,RLEblueSz: integer; {must be 32-bit integer aka longint}
   AcqTime,ImgTime,PatientName,PatientID,StudyDate,modality,serietag: string;
  end;

   AHdr = packed record //Next: analyze Format Header structure
   HdrSz : longint;
   Data_Type: array [1..10] of char;
   db_name: array [1..18] of char;
   extents: longint;                            (* 32 + 4    *)
   session_error: smallint;                (* 36 + 2    *)
   regular: char;                           (* 38 + 1    *)
   hkey_un0: char;                          (* 39 + 1    *)
   dim: array[0..7] of smallint;                       (* 0 + 16    *)
   vox_units: array[1..4] of char;                      (* 16 + 4    *)
   (*   up to 3 characters for the voxels units label; i.e. mm., um., cm.*)
   cal_units: array [1..8] of char;                      (* 20 + 4    *)
   (*   up to 7 characters for the calibration units label; i.e. HU *)
   unused1: smallint;                      (* 24 + 2    *)
   datatype: smallint ;                     (* 30 + 2    *)
   bitpix: smallint;                       (* 32 + 2    *)
   dim_un0: smallint ;                      (* 34 + 2    *)
   pixdim: array[1..8]of single;                        (* 36 + 32   *)
                        (*
                                pixdim[] specifies the voxel dimensions:
                                pixdim[1] - voxel width  //in SPM [2]
                                pixdim[2] - voxel height  //in SPM [3]
                                pixdim[3] - interslice distance //in SPM [4]
                                        ..etc
                        *)
   vox_offset: single;                       (* 68 + 4    *)
   roi_scale: single;                        (* 72 + 4    *)
   zero_intercept: single;//funused1: single;                         (* 76 + 4    *)
   funused2: single;                         (* 80 + 4    *)
   cal_max: single;                          (* 84 + 4    *)
   cal_min: single;                          (* 88 + 4    *)
   compressed: longint;                         (* 92 + 4    *)
   verified: longint;                           (* 96 + 4    *)
   glmax, glmin: longint;                       (* 100 + 8   *)
   descrip: array[1..80] of char;                       (* 0 + 80    *)
   aux_file: array[1..24] of char;                      (* 80 + 24   *)
   orient: char;                            (* 104 + 1   *)
   (*originator: array [1..10] of char;*)                   (* 105 + 10  *)
   originator: array [1..5] of smallint;                    (* 105 + 10  *)
   generated: array[1..10]of char;                     (* 115 + 10  *)
   scannum: array[1..10]of char;//array [1..10] of char ..extended??                       (* 125 + 10  *)
   patient_id: array [1..10] of char;                    (* 135 + 10  *)
   exp_date: array [1..10] of char;                      (* 145 + 10  *)
   exp_time: array[1..10] of char;                      (* 155 + 10  *)
   hist_un0: array [1..3] of char;                       (* 165 + 3   *)
   views: longint;                              (* 168 + 4   *)
   vols_added: longint;                         (* 172 + 4   *)
   start_field: longint;                        (* 176 + 4   *)
   field_skip: longint;                         (* 180 + 4   *)
   omax,omin: longint;                          (* 184 + 8   *)
   smax,smin:longint;                          (* 192 + 8   *)
 end; //Analyze Header Structure

	int32  = LongInt;
	uint32 = Cardinal;
	int16  = SmallInt;
	uint16 = Word;
	int8   = ShortInt;
	uint8  = Byte;
    SingleRA0 = array [0..0] of Single;
    Singlep0 = ^SingleRA0;
    ByteRA0 = array [0..0] of byte;
    Bytep0 = ^ByteRA0;
    WordRA0 = array [0..0] of Word;
    Wordp0 = ^WordRA0;
    SmallIntRA0 = array [0..0] of SmallInt;
    SMallIntp0 = ^SmallIntRA0;
    LongIntRA0 = array [0..0] of LongInt;
    LongIntp0 = ^LongIntRA0;
    DWordRA = array [1..1] of DWord;
    DWordp = ^DWordRA;

    ByteRA = array [1..1] of byte;
    Bytep = ^ByteRA;
    WordRA = array [1..1] of Word;
    Wordp = ^WordRA;
    SmallIntRA = array [1..1] of SmallInt;
    SMallIntp = ^SmallIntRA;
    LongIntRA = array [1..1] of LongInt;
    LongIntp = ^LongIntRA;
    SingleRA = array [1..1] of Single;
    Singlep = ^SingleRA;
    DoubleRA = array [1..1] of Double;
    Doublep = ^DoubleRA;

    HistoRA = array [0..256] of longint;
    pRGBTripleArray = ^TRGBTripleArray;
    TRGBTripleArray = ARRAY[0..PixelCountMax-1] OF TRGBTriple;


function ChangeFileExtX( var lFilename: string; lExt: string): string;
procedure SwapBytes (var lAHdr: AHdr); //Swap Byte order for the Analyze type
procedure swap4(var s : LongInt); //swap 32-bit integer between long/little endian
procedure ClearHdr (var lHdr: AHdr);
procedure DICOM2AnzHdr (var lBHdr: AHdr; lAnonymize: boolean; var lFilename: string; var lDICOMdata: DicomData);
FUNCTION specialsingle (var s:single): boolean; //check if 32-bit float is Not-A-Number, infinity, etc
procedure Xswap4r ( var s:single);
procedure Xswap8r(var s : double);
function FSize (lFName: String): longint;
function {TMainForm.}FileExistsEX(Name: String): Boolean;
function ParseFileName (lFilewExt:String): string;
function ParseFileFinalDir (lFileName:String): string;
function ExtractFileDirWithPathDelim(lInFilename: string): string;
function PadStr (lValIn, lPadLenIn: integer): string;

 implementation

function ChangeFileExtX( var lFilename: string; lExt: string): string;
begin
    result := ChangeFileExt(lFilename,lExt);
end;

function PadStr (lValIn, lPadLenIn: integer): string;
var lOrigLen,lPad : integer;
begin
 lOrigLen := length(inttostr(lValIn));
 result := inttostr(lValIn);
 if lOrigLen < lPadLenIn then begin
    lOrigLen := lPadLenIn-lOrigLen;
    for lPad := 1 to lOrigLen do
        result := '0'+result;
 end;
end;

function ExtractFileDirWithPathDelim(lInFilename: string): string;
//F:\filename.ext -> 'F:\' and F:\dir\filename.ext -> 'F:\dir\'
//Despite documentation, Delphi3's ExtractFileDir does not always retain final pathdelim
var lFilePath: string;
begin
     result := '';
     lFilePath := ExtractFileDir(lInFilename);
     if length(lFilepath) < 1 then exit;
     if lFilePath[length(lFilepath)] <> pathdelim then
        lFilepath := lFilepath + pathdelim; //Delphi3 bug: sometimes forgets pathdelim
     result := lFilepath;
end;

function ParseFileFinalDir (lFileName:String): string;
var
   lLen,lInc,lPos: integer;
   lInName,lName: String;
begin
     lInName := extractfiledir(lFilename);
     lName := '';
     lLen := length(lInName);
     if  lLen < 1 then exit;
     lInc := lLen;
     repeat
              dec(lInc);
     until (lInName[lInc] = pathdelim) or (lInc = 1);
     if lInName[lInc] = pathdelim then inc(lInc); //if '\folder' then return 'folder'
     for lPos := lInc to lLen do
            lName := lName + lInName[lPos];
     ParseFileFinalDir := lName;
end;

function ParseFileName (lFilewExt:String): string;
var
   lLen,lInc: integer;
   lName: String;
begin
	lName := '';
     lLen := length(lFilewExt);
	lInc := lLen+1;
     if  lLen > 0 then
	   repeat
              dec(lInc);
        until (lFileWExt[lInc] = '.') or (lInc = 1);
     if lInc > 1 then
        for lLen := 1 to (lInc - 1) do
            lName := lName + lFileWExt[lLen]
     else
         lName := lFilewExt; //no extension
        ParseFileName := lName;
end;

 Function {TMainForm.}FileExistsEX(Name: String): Boolean;
 var
   F: File;
 begin
  result := FileExists(Name);
   if result then exit;
   //the next bit attempts to check for a file to avoid WinNT bug
   AssignFile(F, Name);
   {$I-}
   Reset(F);
   {$I+}
   Result:=IOresult = 0;
   if Result then
     CloseFile(F);
 end;


function FSize (lFName: String): longint;
var SearchRec: TSearchRec;
begin
  FSize := 0;
  if not fileexistsex(lFName) then exit;
  FindFirst(lFName, faAnyFile, SearchRec);
  FSize := SearchRec.size;
  FindClose(SearchRec);
end;
procedure Xswap8r(var s : double);
type
  swaptype = packed record
    case byte of
      0:(Word1,Word2,Word3,Word4 : word); //word is 16 bit
      //1:(float:double);
  end;
  swaptypep = ^swaptype;
var
  inguy:swaptypep;
  outguy:swaptype;
begin
  inguy := @s; //assign address of s to inguy
  outguy.Word1 := swap(inguy^.Word4);
  outguy.Word2 := swap(inguy^.Word3);
  outguy.Word3 := swap(inguy^.Word2);
  outguy.Word4 := swap(inguy^.Word1);
  inguy^.Word1 := outguy.Word1;    //added ^ - ACC 12/6/2009
  inguy^.Word2 := outguy.Word2;    //added ^ - ACC 12/6/2009
  inguy^.Word3 := outguy.Word3;    //added ^ - ACC 12/6/2009
  inguy^.Word4 := outguy.Word4;    //added ^ - ACC 12/6/2009
end;

FUNCTION specialsingle (var s:single): boolean;
//returns true if s is Infinity, NAN or Indeterminate
//4byte IEEE: msb[31] = signbit, bits[23-30] exponent, bits[0..22] mantissa
//exponent of all 1s =   Infinity, NAN or Indeterminate
CONST kSpecialExponent = 255 shl 23;
VAR Overlay: LongInt ABSOLUTE s;
BEGIN
  IF ((Overlay AND kSpecialExponent) = kSpecialExponent) THEN
     RESULT := true
  ELSE
      RESULT := false;
END;


procedure DICOM2AnzHdr (var lBHdr: AHdr; lAnonymize: boolean; var lFilename: string; var lDICOMdata: DicomData);
var lInc,lLen: integer;
   lFilenameWOPath: string;
begin
  ClearHdr(lBHdr);
if not lAnonymize then begin
  //next: put PatientID into patient_ID array
  lLen := length(lDicomData.PatientID);
  if lLen > 10 then lLen := 10; //10=size of patient_ID array
  if lLen > 0 then
     for lInc := 1 to lLen do
      lBHdr.patient_id[lInc] := lDicomData.PatientID[lInc];
  //next: put filename into aux_file array
  lFilenameWOPath := extractfilename(lFilename);
  lLen := length(lFilenameWOPath);
  if lLen > 24 then lLen := 24; //24=size of aux_file
  if lLen > 0 then
     for lInc := 1 to lLen do
       lBHdr.aux_file[lInc] := lFilenameWOPath[lInc];
  //next: put PatientName into Descrip array
  lLen := length(lDicomData.PatientName);
  if lLen > 80 then lLen := 80; //80=size of descrip array
  if lLen > 0 then
     for lInc := 1 to lLen do
      lBHdr.descrip[lInc] := lDicomData.PatientName[lInc];
  //next: put StudyDate into exp_date array
  lLen := length(lDicomData.StudyDate);
  if lLen > 10 then lLen := 10; //10=size of exp_date array
  if lLen > 0 then
     for lInc := 1 to lLen do
      lBHdr.exp_date[lInc] := lDicomData.StudyDate[lInc];
  //next: put AcqTime into exp_time array
  lLen := length(lDicomData.AcqTime);
  if lLen > 10 then lLen := 10; //10=size of exp_time array
  if lLen > 0 then
     for lInc := 1 to lLen do
      lBHdr.exp_time[lInc] := lDicomData.AcqTime[lInc];
  //next: put Modality into generated array
  lLen := length(lDicomData.modality);
  if lLen > 10 then lLen := 10; //10=size of generated array
  if lLen > 0 then
     for lInc := 1 to lLen do
      lBHdr.generated[lInc] := lDicomData.modality[lInc];

end; //Not anonymized
  //next: fill in binary data

  lBHdr.Dim[4] := 1;//132
  //NO! Offset stripped by converter!lBHdr.vox_offset := lDicomdata.ImageStart;
  lBHdr.Originator[1] := 0;
  lBHdr.Originator[2] := 0;
  lBHdr.Originator[3] := 0;
  lBHdr.Originator[1] := lDICOMdata.XYZori[1];
  lBHdr.Originator[2] := lDICOMdata.XYZori[2];
  lBHdr.Originator[3] := lDICOMdata.XYZori[3];
  lBHdr.Dim[1] := lDICOMdata.XYZdim[1];
  lBHdr.Dim[2] := lDICOMdata.XYZdim[2];
  lBHdr.Dim[3] := lDICOMdata.XYZdim[3];
  lBHdr.Dim[4] := lDICOMdata.XYZdim[4];
  //lSlicesTot := lDICOMdata.XYZdim[3];
  lBHdr.pixdim[2]:= lDICOMdata.XYZmm[1];
  lBHdr.pixdim[3]:= lDICOMdata.XYZmm[2];
  lBHdr.pixdim[4]:= lDICOMdata.XYZmm[3];
  if lDICOMdata.IntenScale <> 0 then
     lBHdr.roi_scale := lDICOMdata.IntenScale
  else
      lBHdr.roi_scale := 1;
  if not specialsingle(lDICOMdata.IntenIntercept) then
     lBHdr.zero_intercept := lDICOMdata.IntenIntercept //1406
  else lBHdr.zero_intercept := 0;
  lBHdr.bitpix := 8; //1360
  lBHdr.datatype := 2; //1360
  if lDicomData.Allocbits_per_pixel <> 8 then begin
     if lDicomData.Allocbits_per_pixel = 32 then begin
        lBHdr.bitpix := 32;
        if lDicomData.Float then
           lBHdr.datatype := 16
        else
            lBHdr.datatype := 8;
     end else if lDicomData.Allocbits_per_pixel = 64 then begin
        lBHdr.bitpix := 64;
        lBHdr.datatype := 64;;
     end else begin //16bits per pixel
         lBHdr.bitpix := 16;
         lBHdr.datatype := 4;
     end;
  end;
end;

procedure swap4(var s : LongInt);
type
  swaptype = packed record
    case byte of
      0:(Word1,Word2 : word); //word is 16 bit
      1:(Long:LongInt);
  end;
  swaptypep = ^swaptype;
var
  inguy:swaptypep;
  outguy:swaptype;
begin
  inguy := @s; //assign address of s to inguy
  outguy.Word1 := swap(inguy^.Word2);
  outguy.Word2 := swap(inguy^.Word1);
  s:=outguy.Long;
end;

procedure Xswap4r ( var s:single);
type
  swaptype = packed record
    case byte of
      0:(Word1,Word2 : word); //word is 16 bit
      //1:(float:single);
  end;
  swaptypep = ^swaptype;
var
  inguy:swaptypep;
  outguy:swaptype;
begin
  inguy := @s; //assign address of s to inguy
  outguy.Word1 := swap(inguy^.Word2);
  outguy.Word2 := swap(inguy^.Word1);
  inguy^.Word1 := outguy.Word1;        //added ^ - ACC 12/6/2009
  inguy^.Word2 := outguy.Word2;        //added ^ - ACC 12/6/2009
end;

procedure ClearHdr (var lHdr: AHdr);
var lInc: byte;
begin
    with lHdr do begin
         {set to 0}
         HdrSz := sizeof(AHdr);
         for lInc := 1 to 10 do
             Data_Type[lInc] := chr(0);
         for lInc := 1 to 18 do
             db_name[lInc] := chr(0);
         extents:=0;                            (* 32 + 4    *)
         session_error:= 0;                (* 36 + 2    *)
         regular:='r'{chr(0)};                           (* 38 + 1    *)
         hkey_un0:=chr(0);
         dim[0] := 4;                          (* 39 + 1    *)
         for lInc := 1 to 7 do
             dim[lInc] := 0;                       (* 0 + 16    *)
         for lInc := 1 to 4 do
             vox_units[lInc] := chr(0);                      (* 16 + 4    *)
         for lInc := 1 to 4 do
             cal_units[lInc] := chr(0);                      (* 20 + 4    *)
         unused1:=0;                      (* 24 + 2    *)
         datatype:=0 ;                     (* 30 + 2    *)
         bitpix:=0;                       (* 32 + 2    *)
         dim_un0:=0;                      (* 34 + 2    *)
         for lInc := 1 to 4 do
             pixdim[linc]:= 1.0;                        (* 36 + 32   *)
         vox_offset:= 0.0;
{roi scale = 1}
         //roi_scale:= 1;//0.00392157{1.1};
         zero_intercept:= 0.0;                         (* 76 + 4    *)
         funused2:= 0.0;                         (* 80 + 4    *)
         cal_max:= 0.0;                          (* 84 + 4    *)
         cal_min:= 0.0;                          (* 88 + 4    *)
         compressed:=0;                         (* 92 + 4    *)
         verified:= 0;                           (* 96 + 4    *)
         glmax:= 0;
         glmin:= 0;                       (* 100 + 8   *)
         for lInc := 1 to 80 do
             lHdr.descrip[lInc] := chr(0);{80 spaces}
         for lInc := 1 to 24 do
             lHdr.aux_file[lInc] := chr(0);{80 spaces}
         orient:= chr(0);                            (* 104 + 1   *)
         (*originator: array [1..10] of char;*)                   (* 105 + 10  *)
         for lInc := 1 to 5 do
             originator[lInc] := 0;                    (* 105 + 10  *)
         for lInc := 1 to 10 do
             generated[lInc] := chr(0);                     (* 115 + 10  *)
         for lInc := 1 to 10 do
             scannum[lInc] := chr(0);
         for lInc := 1 to 10 do
             patient_id[lInc] := chr(0);                    (* 135 + 10  *)
         for lInc := 1 to 10 do
             exp_date[lInc] := chr(0);                    (* 135 + 10  *)
         for lInc := 1 to 10 do
             exp_time[lInc] := chr(0);                    (* 135 + 10  *)
         for lInc := 1 to 3 do
             hist_un0[lInc] := chr(0);                    (* 135 + 10  *)
         views:=0;                              (* 168 + 4   *)
         vols_added:=0;                         (* 172 + 4   *)
         start_field:=0;                        (* 176 + 4   *)
         field_skip:=0;                         (* 180 + 4   *)
         omax:= 0;
         omin:= 0;                          (* 184 + 8   *)
         smax:= 0;
         smin:=0;                          (* 192 + 8   *)
{below are standard settings which are not 0}
         bitpix := 16;//vc16; {8bits per pixel, e.g. unsigned char 136}
         DataType := 4;//vc4;{2=unsigned char, 4=16bit int 136}
         //vox_offset := 0;
         Originator[1] := 0;
         Originator[2] := 0;
         Originator[3] := 0;
         Dim[1] := 256;
         Dim[2] := 256;
         Dim[3] := 1;//1341
         Dim[4] := 1; {n vols}
         glMin := 0;
         glMax := 255; {critical!}
         roi_scale := 1.0;//0.00392157{1.1};
    end;

end;

procedure SwapBytes (var lAHdr: AHdr);
var
   lInc: integer;
begin
    with lAHdr do begin
         swap4(hdrsz);
         {for lInc := 1 to 10 do
             Data_Type[lInc] := chr(0);  for chars: no need to swap 1 byte
         for lInc := 1 to 18 do
             db_name[lInc] := chr(0);}
         swap4(extents);                            (* 32 + 4    *)
         session_error := swap(session_error);                (* 36 + 2    *)
         {regular:=chr(0);                           (* 38 + 1    *)
         hkey_un0:=chr(0);}                          (* 39 + 1    *)
         for lInc := 0 to 7 do
             dim[lInc] := swap(dim[lInc]);                       (* 0 + 16    *)
         {for lInc := 1 to 4 do
             vox_units[lInc] := chr(0);                      (* 16 + 4    *)
         for lInc := 1 to 4 do
             cal_units[lInc] := chr(0);}                      (* 20 + 4    *)
         unused1:= swap(unused1);                      (* 24 + 2    *)
         datatype:= swap(datatype);                     (* 30 + 2    *)
         bitpix := swap(bitpix);                       (* 32 + 2    *)
         dim_un0:= swap(dim_un0);                      (* 34 + 2    *)
         for lInc := 1 to 4 do
             Xswap4r(pixdim[linc]);                        (* 36 + 32   *)
         Xswap4r(vox_offset);
{roi scale = 1}
         Xswap4r(roi_scale);
         Xswap4r(zero_intercept);                         (* 76 + 4    *)
         Xswap4r(funused2);                         (* 80 + 4    *)
         Xswap4r(cal_max);                          (* 84 + 4    *)
         Xswap4r(cal_min);                          (* 88 + 4    *)
         swap4(compressed);                         (* 92 + 4    *)
         swap4(verified);                           (* 96 + 4    *)
         swap4(glmax);
         swap4(glmin);                       (* 100 + 8   *)
         {for lInc := 1 to 80 do
             gAHdr.descrip[lInc] := chr(0);}{80 spaces}
         {for lInc := 1 to 24 do
             gAHdr.aux_file[lInc] := chr(0);}{24 spaces}
         orient:= chr(0);                            (* 104 + 1   *)
         (*originator: array [1..10] of char;*)                   (* 105 + 10  *)
         for lInc := 1 to 5 do
             originator[lInc] := swap(originator[lInc]);                    (* 105 + 10  *)
         swap4(views);                              (* 168 + 4   *)
         swap4(vols_added);                         (* 172 + 4   *)
         swap4(start_field);                        (* 176 + 4   *)
         swap4(field_skip);                         (* 180 + 4   *)
         swap4(omax);
         swap4(omin);                          (* 184 + 8   *)
         swap4(smax);
         swap4(smin);                          (* 192 + 8   *)
    end; {with}
end;

end.
