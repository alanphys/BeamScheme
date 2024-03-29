unit bsunit;
{Revision History
 Version 0.2 released 1/8/2011
 22/8/2011  Fix field centre error,
            Fix Y resolution error for MapCheck 2
 28/09/2011 removed MultiDoc
            added invert
            added normalise
            added windowing
            fixed profile display
            fixed symmetry calculation
            cleaned up printout
 15/2/2012  Fix CAX normalisation error,
 2/4/2013   Add read for XiO Dose plane file
 20/6/2014  Removed redundant DICOM read code causing memory bug
 24/6/2014  Fixed XiO read offset by 1
            Fixed MapCheck read if dose cal file not present
            Included Min/Max as part of beam class
            Fixed panel maximise to form area
 21/5/2015  Combine open dialog and DICOM dialog
 20/7/2015  Add messaging system
 Version 0.3 released 20/7/2015
 28/6/2016  Support PTW 729 mcc
 26/8/2016  Add normalise to max
 29/9/2016  Fix PTW 729 memory error
 21/10/2016 Add PowerPDF for output
 24/10/2016 Fix Profile event misfire
 15/8/2017  Fix image integer conversion
 13/10/2017 Support IBA Matrix and StartTrack opg
 16/10/2017 Fix Diff divide by zero error
            Fix profile offset limit error
 7/12/2017  Fix even number of detectors offset
 15/12/2017 Support Brainlab iPlan Dose plane format
            Add text file format identification
 8/1/2018   Add help system
            Fix windowing error on normalise to CAX
 26/1/2018  Fix panel maximise under QT5
            Fix window level control size under max/min
 30/1/2018  Fix area symmetry off by 1
            Fix CAX for even no of detectors
            Fix image autoscale
 1/2/2018   Add mouse control for profiles
 2/2/2018   Fix off by 1 error profile limits
 Version 0.4 released 2/2/2018
 27/3/2018  Fix regional settings decimal separator
 3/4/2018   Add mean and standard deviation
            Fix profile increment
 30/4/2019  Fix DTrackbar if image max = maxlongint
 3/5/2019   Fix DICOM off by one and pointer conversion
 17/7/2019  Update about unit
 18/7/2019  Update status bar
 23/7/2019  Add expression parser
 30/7/2019  Add multipage output
 31/7/2019  Fix profile export dirs
 1/8/2019   Add expression editor
 14/8/2019  Remove auto normalisation of profile values.
            Fix previous image and profile display on open image cancel
 11/9/2019  Fix prompt for overwrite results
            Fix protocol list unsorted on reload
            Add Quit Edit menu item
 16/9/2019  Fix Y axis swapped for IBA files
 10/10/2019 Change BitButtons to SpeedButtons on protocol edit toolbar
            Fix cancel on protocol save
            Fix edit flag on protocol edit exit
            Correct result window title on edit
 23/10/2019 Updated help
            Fix click on empty Image pane crash
 25/10/2019 Fix user protocol path
 Version 0.5 released 25/10/2019
 16/4/2020  Fix various memory leaks
 6/8/2020   use Form2PDf for printing PDF
            fix SaveDialog titles
            remove results unit and PowerPDF
 24/8/2020  add get correct resolution for tiff images
 18/9/2020  fix range check error in calcparams
            add inflection points
            neaten filename display
 22/9/2020  support raw text file
 29/9/2020  shift maths routines to unit mathsfuncs
 30/9/2020  shift types and constants to unit bstypes
            use Hill function non linear regression to determine inflection points
            add copy profiles to clipboard
 1/10/2020  use parser.SetVariable for performance enhancement
            fix status warning display
            add FFF params inflection point, 0.4*InfP (20%) and 1.6*InfP (80%)
 7/10/2020  add copy results to clipboard
            make Protocol read only while not in edit mode
            add context menus for X Y profiles and results
 8/10/2020  fix duplicate text file open
            fix RAWOpen range check error
            add sigmoid slope for penumbra
            add position of max
            fix protocol name change on edit
            add profile points for FFF
 14/10/2020 add app version
 20/10/2020 fix file extensions
 5/11/2020  update help
 17/11/2020 fix resolution for tiff files
 7/12/2020  add normalisation to max for calcs
 11/12/2020 make normalisation modal, i.e. non destructive
            change toolbar panel to TToolBar
 14/12/2020 select default protocol on startup
 3/3/2021   fix FFF penumbra slope
 11/9/2021  fix recognise files with tiff extension
 4/10/2021  fix ShowProfile and refactor
            fix initialise vars
            profile draw on trackbar change
 14/10/2021 Remove sExePath in file Open
 22/10/2021 fix profile position on mouse click}



{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Menus,
  ExtCtrls, Buttons, TAGraph, TASeries, TATools, StdCtrls, Graphtype, Clipbrd,
  IntfGraphics, Spin, ComCtrls, LazHelpHTML, Grids, Tracker2, lNetComponents,
  lwebserver, FPImage, bstypes;

  { TBSForm }

type
   TBSForm = class(TForm)
   ChartToolsetY: TChartToolset;
   ChartToolsetX: TChartToolset;
   ChartToolsetXDataPointHintTool: TDataPointHintTool;
   ChartToolsetYDataPointHintTool: TDataPointHintTool;
   cbProtocol: TComboBox;
   cXProfile: TChart;
   cXprof: TLabel;
   HTMLBrowserHelpViewer: THTMLBrowserHelpViewer;
   HTMLHelpDatabase: THTMLHelpDatabase;
   HelpServer: TLHTTPServerComponent;
   ImageList: TImageList;
   Label7: TLabel;
   miResClip: TMenuItem;
   miResExp: TMenuItem;
   miYToFile: TMenuItem;
   miYToClip: TMenuItem;
   miXToFile: TMenuItem;
   miXToClip: TMenuItem;
   pmiCopytoFile: TMenuItem;
   pmiCopyClip: TMenuItem;
   miQuitEdit: TMenuItem;
   miProtocol: TMenuItem;
   miSaveP: TMenuItem;
   miEditP: TMenuItem;
   miContents: TMenuItem;
   miAbout: TMenuItem;
   miHelp: TMenuItem;
   miExportY: TMenuItem;
   miExportX: TMenuItem;
   miExport: TMenuItem;
   Panel8: TPanel;
   pmContext: TPopupMenu;
   SaveDialog: TSaveDialog;
   sbSaveP: TSpeedButton;
   sbAddP: TSpeedButton;
   sbDelP: TSpeedButton;
   sbExitP: TSpeedButton;
   StatusBar: TStatusBar;
   StatusMessages: TStringList;
   sgResults: TStringGrid;
   ToolBar: TToolBar;
   tbOpen: TToolButton;
   ToolButton1: TToolButton;
   tbInvert: TToolButton;
   tbNormCax: TToolButton;
   tbNormMax: TToolButton;
   tbCentre: TToolButton;
   ToolButton2: TToolButton;
   tbPDF: TToolButton;
   ToolButton3: TToolButton;
   tbExit: TToolButton;
   YProfile: TLineSeries;
   XProfile: TLineSeries;
   cYProf: TLabel;
   cResults: TLabel;
   cYProfile: TChart;
   DTrackBar: TDTrackBar;
   iBeam: TImage;
   Label1: TLabel;
   Label2: TLabel;
   Label3: TLabel;
   Label4: TLabel;
   Label5: TLabel;
   Label6: TLabel;
   cImage: TLabel;
   lMin: TLabel;
   Label8: TLabel;
   MainMenu: TMainMenu;
   miRestore: TMenuItem;
   miResults: TMenuItem;
   miYProfile: TMenuItem;
   miXProfile: TMenuItem;
   miImage: TMenuItem;
   Panel4: TPanel;
   Panel5: TPanel;
   Panel6: TPanel;
   Panel7: TPanel;
   pMaxMin: TPanel;
   pResults: TPanel;
   pYProfile: TPanel;
   Panel2: TPanel;
   pBeam: TPanel;
   pXProfile: TPanel;
   Panel3: TPanel;
   sbXMax: TSpeedButton;
   sbYMax: TSpeedButton;
   sbIMin: TSpeedButton;
   sbRMax: TSpeedButton;
   sbYMin: TSpeedButton;
   sbXMin: TSpeedButton;
   sbRMin: TSpeedButton;
   seXAngle: TSpinEdit;
   seXOffset: TSpinEdit;
   seXWidth: TSpinEdit;
   seYAngle: TSpinEdit;
   seYOffset: TSpinEdit;
   seYWidth: TSpinEdit;
   sbIMax: TSpeedButton;
   Window: TMenuItem;
   miPrint: TMenuItem;
   miExit: TMenuItem;
   miOpen: TMenuItem;
   miFile: TMenuItem;
   OpenDialog: TOpenDialog;
   procedure bbAddLClick(Sender: TObject);
   procedure bbDelLClick(Sender: TObject);
   procedure bbExitPClick(Sender: TObject);
   procedure bbSavePClick(Sender: TObject);
   procedure cbProtocolChange(Sender: TObject);
   procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
   procedure miResClipClick(Sender: TObject);
   procedure pmContextPopup(Sender: TObject);
   procedure pmiCopyClipClick(Sender: TObject);
   procedure pmiCopytoFileClick(Sender: TObject);
   procedure sbPDFClick(Sender: TObject);
   procedure StatusBarDrawPanel(SBar: TStatusBar;Panel: TStatusPanel; const Rect: TRect);
   procedure BSError(sError:string);
   procedure BSWarning(sWarning:string);
   procedure BSMessage(sMess:string);
   procedure ClearStatus;
   procedure ChartToolsetXDataPointHintToolHint(ATool: TDataPointHintTool;
      const APoint: TPoint; var AHint: String);
   procedure ChartToolsetYDataPointHintToolHint(ATool: TDataPointHintTool;
      const APoint: TPoint; var AHint: String);
   procedure DTrackBarChange(Sender: TObject);
   procedure DTrackBarClick(Sender: TObject);
   procedure BuildProtocolList;
   procedure LoadProtocol;
   procedure FormCreate(Sender: TObject);
   function FormHelp(Command: Word; Data: PtrInt; var CallHelp: Boolean): Boolean;
   function DICOMOpen(sFileName:string):boolean;
   procedure FormResize(Sender: TObject);
   procedure iBeamClick(Sender: TObject);
   procedure miEditPClick(Sender: TObject);
   function TextOpen(sFileName:string):boolean;
   function MapCheckOpen(sFileName:string):boolean;
   function IBAOpen(sFileName:string):boolean;
   function PTWOpen(sFileName:string):boolean;
   procedure sbCentreClick(Sender: TObject);
   procedure sbMaxNormClick(Sender: TObject);
   function XioOpen(sFileName:string):boolean;
   function BrainLabOpen(sFileName:string):boolean;
   function BMPOpen(sFileName:string):boolean;
   function HISOpen(sFileName:string):boolean;
   function RAWOpen(sFileName:string):boolean;
   procedure miExitClick(Sender: TObject);
   procedure miExportXClick(Sender: TObject);
   procedure miExportYClick(Sender: TObject);
   procedure miXClipBClick(Sender: TObject);
   procedure miYClipBClick(Sender: TObject);
   procedure miOpenClick(Sender: TObject);
   procedure miRestoreClick(Sender: TObject);
   procedure miAboutClick(Sender: TObject);
   procedure miContentsClick(Sender: TObject);
   procedure sbIMinClick(Sender: TObject);
   procedure sbInvertClick(Sender: TObject);
   procedure sbNormClick(Sender: TObject);
   procedure sbRMaxClick(Sender: TObject);
   procedure sbRMinClick(Sender: TObject);
   procedure sbXMaxClick(Sender: TObject);
   procedure sbXMinClick(Sender: TObject);
   procedure sbYMaxClick(Sender: TObject);
   procedure sbYMinClick(Sender: TObject);
   procedure seYAngleChange(Sender: TObject);
   procedure seXAngleChange(Sender: TObject);
   procedure ShowXResults(BeamParams:TBeamParams);
   procedure ShowYResults(BeamParams:TBeamParams);
   procedure sbIMaxClick(Sender: TObject);
 private
    { private declarations }
 public
    { public declarations }
   FileHandler: TFileHandler;
   CGIHandler: TCGIHandler;
   PHPCGIHandler: TPHPFastCGIHandler;
   end;

var
    BSForm       :TBSForm;
    Beam         :TBeam;
    XPArr,
    YPArr        :TPArr;
    XBParams,
    YBParams     :TBeamParams;
    sProtPath    :string;
    Safe,
    Editing      :boolean;
    Normalisation:TNorm;

procedure DisplayBeam;
procedure ShowProfile(ThebitMap:Tbitmap; Wdth:double;
   TopLeft,TopRight,BottomRight,BottomLeft:TPoint);
procedure DrawProfile(TheBitmap:TBitmap;Beam:TBeam ;Angle,Offset,Width:double;
   Profile:TLineSeries; var PArr:TPArr; var TopLeft,TopRight,BottomLeft,BottomRight:TPoint;
   var PrevW:double);


implementation

uses DICOM, define_types, types, math, StrUtils, helpintfs, aboutunit,
     LazFileUtils, Parser10, form2pdf, mathsfuncs, fileinfo;

var YPTL,                      {Y profile top right}
    YPTR,                      {Y profile top left}
    YPBL,                      {Y profile bottom right}
    YPBR:      TPoint;         {Y profile bottom left}
    XPTL,                      {X profile top right}
    XPTR,                      {X profile top left}
    XPBL,                      {X profile bottom right}
    XPBR:      TPoint;         {X profile bottom left}
    YPW,                       {Y previous width}
    XPW:       double;         {X previous width}


function GetAppVersionString(IncludeBuildInfo:Boolean=True; MinorDigits:Byte=2;
   IncludePosRelease:Boolean=False; IncludeAnyRelease:Boolean=False): String;
var VersionInfo: TVersionInfo;
begin
Result:= '';
try
  VersionInfo:= TVersionInfo.Create;
  VersionInfo.Load(HINSTANCE);
  Result:= IntToStr(VersionInfo.FixedInfo.FileVersion[0]) + '.' +
     Format('%0.*d',[MinorDigits,VersionInfo.FixedInfo.FileVersion[1]]);
  if (IncludeAnyRelease or (IncludePosRelease and (VersionInfo.FixedInfo.FileVersion[2]<>0))) then
     Result:= Result + '.' + IntToStr(VersionInfo.FixedInfo.FileVersion[2]);
  if IncludeBuildInfo then
     Result:= Result + '.' + IntToStr(VersionInfo.FixedInfo.FileVersion[3]);
 finally
   if assigned(VersionInfo) then
     VersionInfo.Free;
 end;
end; {getappversionstring}


function RobustStrToFloat(s:string):extended;
var fs:        TFormatSettings;

begin
fs := DefaultFormatSettings;
Result := 0;
   try
   Result := StrToFloat(s);
   except
   on EConvertError do         {try again using other decimal separator}
      begin
      if fs.DecimalSeparator = ',' then
         fs.DecimalSeparator := '.'
        else
         fs.DecimalSeparator := ',';
      Result := StrToFloat(s,fs);
      end;
   end;
end;

procedure DisplayBeam;
{Transfers the array data to a bitmap for viewing. Image is autoscaled}
var IntFImage  :TLazIntfImage;
    Description:TRawImageDescription;
    I,J:       integer;
    BMax,
    BMin,
    z:         double;
    Val:       word;
    GreyVal:   TFPColor;

begin
with Beam do if (Rows>0) and (Cols>0) then
   begin
   IntFImage := TLazIntFImage.Create(0,0);
   Description.Init_BPP32_B8G8R8A8_BIO_TTB(Beam.Cols-2,Beam.Rows);
   IntFImage.DataDescription := Description;

   BMax := BSForm.DTrackBar.PositionU;
   BMin := BSForm.DTrackBar.PositionL;
   if BMax <> BMin then
      for I:=0 to Beam.Rows - 1 do
        for J:=2 to Beam.Cols - 1 do
           begin
           Z := Beam.Data[I,J];
           if Z < BMin then Z := BMin;
           if Z > BMax then Z := BMax;
           Val := Round((Z - BMin)*65535/(BMax - BMin));
           GreyVal := FPColor(Val,Val,Val);
           IntFImage.Colors[J-2,I] := GreyVal;
           end;
     BSForm.iBeam.Picture.Bitmap.LoadFromIntfImage(IntFImage);
     IntFImage.Free;
   end;
end;


procedure ShowProfile(ThebitMap:Tbitmap; Wdth:double;
   TopLeft,TopRight,BottomRight,BottomLeft:TPoint);
begin
{Draw profile on array}
TheBitmap.Canvas.Pen.Color := clRed xor clWhite;
TheBitmap.Canvas.Pen.Mode := pmXor;
if Wdth > 0 then
   TheBitmap.Canvas.Polygon([TopLeft,TopRight,BottomRight,BottomLeft])
  else
   TheBitmap.Canvas.Line(TopLeft,BottomRight);
end;


procedure DrawProfile(TheBitmap:TBitmap; Beam:TBeam; Angle,Offset,Width:double;
   Profile:TLineSeries; var PArr:TPArr; var TopLeft,TopRight,BottomLeft,BottomRight:TPoint;
   var PrevW:double);
{Draw a profile on the bitmap at any angle}
var I,J,K,L,
    WI,WJ,
    LimX,
    LimY,
    OLP,OLN,
    DTBPL,                     {DTrackBar.Position Low}
    DTBPU     :longint;        {DTrackBar.Position Up}
    WNX,
    WNY,
    WPX,
    WPY,
    MidX,
    MidY,
    X,Y,
    XInc,
    YInc,
    MidP,
    PLen,
    TanA,
    Phi,
    Z,
    CMax,                      {profile max or cax value}
    CMin       :double;        {profile min value}
    Start,
    Stop:      TPoint;
    DLine:     TRect;
    OverLimit: Boolean;

begin
{clear previous profile if it exists}
Profile.Clear;
if (TopLeft.x or TopRight.x or BottomLeft.x or BottomRight.x or
   TopLeft.y or TopRight.y or BottomLeft.y or BottomRight.y <> 0) then
   ShowProfile(TheBitMap,PrevW,Topleft,Topright,BottomRight,BottomLeft);

{Draw new profile}
Angle := Angle*2*pi/360;                       //convert angle to radians
TanA := arctan(TheBitMap.Height/TheBitmap.Width); // get limit of corners
Phi := Angle + pi/2;    {add 90 degrees to get perpendicular}
LimX := TheBitmap.Width;
LimY := TheBitmap.Height;
MidX := LimX/2 - 0.5;
MidY := LimY/2 - 0.5;
PrevW := trunc((Width - 1)/2);

{get coords of wide profile}
if (Angle > -TanA) and (Angle <= TanA) then {Profile is X profile}
   begin
   TopLeft := Limit(1,0,-MidX,Phi,Offset + PrevW,MidX,MidY);
   TopRight := Limit(1,0,MidX,Phi,Offset + PrevW,MidX,MidY);
   BottomRight := Limit(1,0,MidX,Phi,Offset - PrevW,MidX,MidY);
   BottomLeft := Limit(1,0,-MidX,Phi,Offset - PrevW,MidX,MidY);
   end
  else {Profile is Y profile}
   begin
   TopLeft := Limit(0,1,-MidY,Phi,Offset + PrevW,MidX,MidY);
   TopRight := Limit(0,1,MidY,Phi,Offset + PrevW,MidX,MidY);
   BottomRight := Limit(0,1,MidY,Phi,Offset - PrevW,MidX,MidY);
   BottomLeft := Limit(0,1,-MidY,Phi,Offset - PrevW,MidX,MidY);
   end;

{Draw profile on array}
ShowProfile(TheBitMap,PrevW,Topleft,Topright,BottomRight,BottomLeft);

DLine := LimitL(Angle,Phi,TanA,Offset,MidX,MidY,0,0,LimX,LimY);
Start := DLine.TopLeft;
Stop := DLine.BottomRight;

{Add points to profile array}
PLen := sqrt(sqr(Stop.X - Start.X)+ sqr(Stop.Y - Start.Y));
Setlength(PArr,round(PLen) + 1);
For I := 0 to round(PLen) do with PArr[I] do
   begin
   x := 0;
   y := 0;
   end;
X := Start.X;
Y := Start.Y;
I := Start.Y;
J := Start.X;
XInc := (Stop.X - Start.X)/PLen;
YInc := (Stop.Y - Start.Y)/PLen;
K:= 0;
MidP := sqrt(sqr((Stop.X - Start.X)*Beam.XRes) + sqr((Stop.Y - Start.Y)*Beam.YRes))/2;
DTBPL := BSForm.DTrackBar.PositionL;
DTBPU := BSForm.DTrackBar.PositionU;

{Add first point}
OverLimit := false;
PArr[K].X := sqrt(sqr((X - Start.X)*Beam.XRes) + sqr((Y - Start.Y)*Beam.YRes)) - MidP;
Z := Beam.Data[I,J+2];
if Z < DTBPL then Z := DTBPL;
if Z > DTBPU then Z := DTBPU;
PArr[K].Y := Z;

{add wide profile}
if PrevW > 0 then
   begin
   WNX := X;
   WNY := Y;
   WPX := X;
   WPY := Y;
   OLP := 0;
   OLN := 0;
   for L:=1 to round(PrevW) do
      begin
      WNX := WNX + YInc;     {increments are inverted because slope is}
      WNY := WNY - XInc;     {perpendicular to profile}
      WPX := WPX - YInc;
      WPY := WPY + XInc;
      {add negative profile}
      WI := round(WNY);
      WJ := round(WNX);
      if (WJ >= 0) and (WJ < LimX) and (WI >= 0) and (WI < LimY) then
         begin
         Z := Beam.Data[WI,WJ+2];
         if Z < DTBPL then Z := DTBPL;
         if Z > DTBPU then Z := DTBPU;
         PArr[K].Y := PArr[K].Y + Z;
         inc(OLN);
         end
        else
         OverLimit := true;

      {add positive profile}
      WI := round(WPY);
      WJ := round(WPX);
      if (WJ >= 0) and (WJ < LimX) and (WI >= 0) and (WI < LimY) then
         begin
         Z := Beam.Data[WI,WJ+2];
         if Z < DTBPL then Z := DTBPL;
         if Z > DTBPU then Z := DTBPU;
         PArr[K].Y := PArr[K].Y + Z;
         inc(OLP);
         end
        else
         OverLimit := true;
      end;
   if OverLimit then PArr[K].Y := PArr[K].Y*Width/(OLN+1+OLP);
   end;


{add rest of points}
repeat
   X := X + XInc;
   Y := Y + YInc;
   I := Round(Y);
   J := Round(X);
   Inc(K);
   OverLimit := false;
   PArr[K].X := sqrt(sqr((X - Start.X)*Beam.XRes) + sqr((Y - Start.Y)*Beam.YRes)) - MidP;
   Z := Beam.Data[I,J+2];
   if Z < DTBPL then Z := DTBPL;
   if Z > DTBPU then Z := DTBPU;
   PArr[K].Y := Z;

   {add wide profiles}
   if PrevW > 0 then
      begin
      WNX := X;
      WNY := Y;
      WPX := X;
      WPY := Y;
      OLP := 0;
      OLN := 0;
      for L:=1 to round(PrevW) do
         begin
         WNX := WNX + YInc;     {increments are inverted because slope is}
         WNY := WNY - XInc;     {perpendicular to profile}
         WPX := WPX - YInc;
         WPY := WPY + XInc;
         {add negative profile}
         WI := round(WNY);
         WJ := round(WNX);
         if (WJ >= 0) and (WJ < LimX) and (WI >= 0) and (WI < LimY) then
            begin
            Z := Beam.Data[WI,WJ+2];
            if Z < DTBPL then Z := DTBPL;
            if Z > DTBPU then Z := DTBPU;
            PArr[K].Y := PArr[K].Y + Z;
            inc(OLN);
            end
           else
            OverLimit := true;
         {add positive profile}
         WI := round(WPY);
         WJ := round(WPX);
         if (WJ >= 0) and (WJ < LimX) and (WI >= 0) and (WI < LimY) then
            begin
            Z := Beam.Data[WI,WJ+2];
            if Z < DTBPL then Z := DTBPL;
            if Z > DTBPU then Z := DTBPU;
            PArr[K].Y := PArr[K].Y + Z;
            inc(OLP);
            end
           else
            OverLimit := true;
         end;
      if OverLimit then PArr[K].Y := PArr[K].Y*Width/(OLN+1+OLP);
      end;
   until (I = Stop.Y) and (J = Stop.X);

{normalise array}
CMax := 0;
CMin := 0;
if Normalisation <> none then
   begin
   CMax := PArr[(length(PArr) - 1) div 2].Y;
   if Normalisation = norm_max then
      for K := 0 to length(PArr) - 1 do
         if PArr[K].Y > CMax then
            CMax := PArr[K].Y;

   CMin := CMax;
   for K := 0 to length(PArr) - 1 do
      if PArr[K].Y < CMin then
         CMin := PArr[K].Y;
   end;

{write array to profile}
for K := 0 to length(PArr) - 1 do with PArr[K] do
   begin
   if Normalisation <> none then
      Y := (Y - CMin)*100/(CMax - CMin);
   if (X <> 0) or (Y <> 0) then
      Profile.AddXY(X,Y,'',clRed)
   end;
end;


{ TBSForm }

procedure TBSForm.StatusBarDrawPanel(SBar: TStatusBar;Panel: TStatusPanel;
   const Rect: TRect);
begin
with SBar.Canvas do
   begin
   Brush.Color := StatusBar.Color;
   FillRect(Rect);
   TextRect(Rect,2 + Rect.Left, 1 + Rect.Top,Panel.Text) ;
   end;
end;


procedure TBSForm.BSError(sError:string);
begin
StatusBar.SimpleText := sError;
StatusBar.Color := FaintRed;
StatusMessages.Add(StatusBar.SimpleText);
StatusBar.Hint := StatusMessages.Text;
end;


procedure TBSForm.BSWarning(sWarning:string);
begin
StatusBar.SimpleText := sWarning;
StatusBar.Color := FaintYellow;
StatusMessages.Add(StatusBar.SimpleText);
StatusBar.Hint := StatusMessages.Text;
end;


procedure TBSForm.BSMessage(sMess:string);
begin
StatusBar.SimpleText := sMess;
StatusBar.Color := FaintGreen;
StatusMessages.Add(StatusBar.SimpleText);
StatusBar.Hint := StatusMessages.Text;
end;


procedure TBSForm.ClearStatus;
begin
StatusBar.SimpleText := '';
StatusBar.Color := clDefault;
end;


procedure TBSForm.miExitClick(Sender: TObject);
begin
Close;
end;


procedure TBSForm.miExportXClick(Sender: TObject);
var Outfile:   textfile;
    I:         integer;

begin
SaveDialog.Title := 'Export profile as';
{$ifdef WINDOWS}
SaveDialog.Filter := 'Text files|*.txt|All files|*.*';
{$else}
SaveDialog.Filter := 'Text files|*.txt|All files|*';
{$endif}
SaveDialog.InitialDir := OpenDialog.InitialDir;
SaveDialog.DefaultExt := '.txt';
SaveDialog.FileName := ExtractFileNameOnly(OpenDialog.FileName);
if XPArr <> nil then
   if SaveDialog.Execute then
      begin
      AssignFile(Outfile,SaveDialog.FileName);
      Rewrite(Outfile);
      for I := 0 to length(XPArr) - 1 do
         writeln(Outfile,XPArr[I].X:5:2,',',XPArr[I].Y:5:1);
         {writeln(Outfile,XPArr[I].X,',',XPArr[I].Y);}
      CloseFile(Outfile);
      end;
end;


procedure TBSForm.miExportYClick(Sender: TObject);
var Outfile:   textfile;
    I:         integer;

begin
SaveDialog.Title := 'Export profile as';
{$ifdef WINDOWS}
SaveDialog.Filter := 'Text files|*.txt|All files|*.*';
{$else}
SaveDialog.Filter := 'Text files|*.txt|All files|*';
{$endif}
SaveDialog.InitialDir := OpenDialog.InitialDir;
SaveDialog.DefaultExt := '.txt';
SaveDialog.FileName := ExtractFileNameOnly(OpenDialog.FileName);
if YPArr <> nil then
   if SaveDialog.Execute then
      begin
      AssignFile(Outfile,SaveDialog.FileName);
      Rewrite(Outfile);
      for I := 0 to length(YPArr) - 1 do
         writeln(Outfile,YPArr[I].X:5:2,',',YPArr[I].Y:5:1);
         {writeln(Outfile,YPArr[I].X,',',YPArr[I].Y);}
      CloseFile(Outfile);
      end;
end;


procedure TBSForm.miXClipBClick(Sender: TObject);
{put the array in a comma delimited string on the clipboard}
var I          :integer;
    sClip      :string;
begin
if XPArr <> nil then
   begin
   sClip := '';
   for I := 0 to length(XPArr) - 1 do
       sClip := sClip + FloatToStrF(XPArr[I].X,ffFixed,5,2) + ',' +
          FloatToStrF(XPArr[I].Y,ffFixed,5,2) + LineEnding;
   Clipboard.AsText := sClip;
   end;
end;


procedure TBSForm.miYClipBClick(Sender: TObject);
{put the array in a comma delimited string on the clipboard}
var I          :integer;
    sClip      :string;
begin
if YPArr <> nil then
   begin
   sClip := '';
   for I := 0 to length(YPArr) - 1 do
       sClip := sClip + FloatToStrF(YPArr[I].X,ffFixed,5,2) + ',' +
          FloatToStrF(YPArr[I].Y,ffFixed,5,2) + LineEnding;
   Clipboard.AsText := sClip;
   end;
end;


procedure TBSForm.miResClipClick(Sender: TObject);
begin
sgResults.CopyToClipboard(false);
end;


procedure TBSForm.pmContextPopup(Sender: TObject);
begin
if pmContext.PopupComponent = pResults then
   begin
   pmiCopyToFile.Enabled := false;
   pmicopyToFile.Visible := false;
   end
  else
   begin
   pmiCopyToFile.Enabled := true;
   pmicopyToFile.Visible := true;
   end;
end;


procedure TBSForm.pmiCopyClipClick(Sender: TObject);
begin
if pmContext.PopupComponent = pXProfile then miXClipBClick(Sender);
if pmContext.PopupComponent = pYProfile then miYClipBClick(Sender);
if pmContext.PopupComponent = pResults then miResClipClick(Sender);
end;


procedure TBSForm.pmiCopytoFileClick(Sender: TObject);
begin
if pmContext.PopupComponent = pXProfile then miExportXClick(Sender);
if pmContext.PopupComponent = pYProfile then miExportYClick(Sender);
end;


procedure TBSForm.bbSavePClick(Sender: TObject);
var I          :integer;
    ProtName,                  {protocol name}
    ProtPath   :string;        {protocol file path}

begin
ClearStatus;
ProtName := cbProtocol.Text;
if ProtName <> '' then
   begin
   SaveDialog.Title := 'Save parameters';
   {$ifdef WINDOWS}
   ProtPath := GetAppConfigDir(true);
   SaveDialog.Filter := 'Comma delimited files|*.csv|All files|*.*';
   {$else}
   ProtPath := GetAppConfigDir(false);
   SaveDialog.Filter := 'Comma delimited files|*.csv|All files|*';
   {$endif}
   if not DirectoryExists(ProtPath) then CreateDir(ProtPath);
   SaveDialog.DefaultExt := '.csv';
   SaveDialog.FileName := AppendPathDelim(ProtPath) + DelSpace(ProtName) + '.csv';

   for I:=1 to sgResults.Rowcount-1 do
      begin
      sgResults.Cells[2,I] := '';
      sgResults.Cells[3,I] := '';
      end;

   if SaveDialog.Execute then
      begin
         try;
         sgResults.SaveToCSVFile(SaveDialog.FileName,',',false);
         except
         on E:Exception do
            BSError('Could not save protocol.');
         end;
      cbProtocol.Style := csDropDownList;
      sbSaveP.Enabled := false;
      sbSaveP.Visible := false;
      miSaveP.Enabled := false;
      miEditP.Enabled := true;
      miQuitEdit.Enabled := false;
      sbAddP.Enabled := false;
      sbAddP.Visible := false;
      sbDelP.Enabled := false;
      sbDelP.Visible := false;
      sbExitP.Enabled := false;
      sbExitP.Visible := false;
      CResults.Caption := 'Results';
      sgResults.Columns.Items[1].Visible := false;
      sgResults.Columns.Items[2].Visible := true;
      sgResults.Columns.Items[3].Visible := true;
      sgResults.Options := sgResults.Options - [goEditing];
      BuildProtocolList;
      if cbProtocol.Items.IndexOf(ProtName) >= 0 then
            cbProtocol.ItemIndex := cbProtocol.Items.IndexOf(ProtName);
      LoadProtocol;
      seXAngleChange(Self);
      seYAngleChange(Self);
      Editing := false;
      end;
   end
  else
   BSWarning('Please define a protocol name.');
end;


procedure TBSForm.cbProtocolChange(Sender: TObject);
begin
ClearStatus;
LoadProtocol;
seXAngleChange(Self);
seYAngleChange(Self);
end;


procedure TBSForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
FileHandler.Free;
CGIHandler.Free;
PHPCGIHandler.Free;
StatusMessages.Free;
Beam.Free
end;


procedure TBSForm.sbPDFClick(Sender: TObject);
begin
SaveDialog.Title := 'Save PDF as';
{$ifdef WINDOWS}
SaveDialog.Filter := 'PDF files|*.pdf|All files|*.*';
{$else}
SaveDialog.Filter := 'PDF files|*.pdf|All files|*';
{$endif}
SaveDialog.InitialDir := OpenDialog.InitialDir;
SaveDialog.DefaultExt := '.pdf';
SaveDialog.FileName := ExtractFileNameOnly(OpenDialog.FileName) + '.pdf';
if SaveDialog.Execute then FormToPDF(BSForm,SaveDialog.FileName);
end;


procedure TBSForm.bbExitPClick(Sender: TObject);
begin
ClearStatus;
cbProtocol.Style := csDropDownList;
sbSaveP.Enabled := false;
sbSaveP.Visible := false;
miSaveP.Enabled := false;
miEditP.Enabled := true;
miQuitEdit.Enabled := false;
sbAddP.Enabled := false;
sbAddP.Visible := false;
sbDelP.Enabled := false;
sbDelP.Visible := false;
sbExitP.Enabled := false;
sbExitP.Visible := false;
cResults.Caption := 'Results';
sgResults.Columns.Items[1].Visible := false;
sgResults.Columns.Items[2].Visible := true;
sgResults.Columns.Items[3].Visible := true;
sgResults.Options := sgResults.Options - [goEditing];
Editing := false;
LoadProtocol;                  {reload to wipe changes}
seXAngleChange(Self);
seYAngleChange(Self);
end;


procedure TBSForm.bbAddLClick(Sender: TObject);
begin
if sgResults.Row >= 0 then sgResults.InsertRowWithValues(sgResults.Row,['','','','']);
end;


procedure TBSForm.bbDelLClick(Sender: TObject);
begin
if sgResults.Row >= 0 then sgResults.DeleteRow(sgResults.Row);
end;


procedure TBSForm.BuildProtocolList;
var sExePath,
    sSearchPath,
    FileName   :string;
    ProtList   :TStringList;
    SearchRec  :TSearchRec;

begin
{look for parameter definition files and make list}
sExePath := ExtractFilePath(Application.ExeName);
sProtPath := AppendPathDelim(sExePath) + 'Protocols';
sSearchPath := AppendPathDelim(sProtPath) + '*.csv';
cbProtocol.Clear;
ProtList := TStringList.Create;
if FindFirst(sSearchPath,0,SearchRec) = 0 then
   begin
      repeat
      FileName := ExtractFileNameOnly(SearchRec.Name);
      ProtList.Add(Filename);
      until FindNext(Searchrec) <> 0;
   ProtList.Sort;
   cbProtocol.Items.Assign(ProtList);
   cbProtocol.ItemIndex := 0;
   end
  else
   begin
   {$ifdef WINDOWS}
   sProtPath := GetAppConfigDir(true);
   {$else}
   sProtPath := GetAppConfigDir(false);
   {$endif}
   sProtPath := AppendPathDelim(sProtPath) + 'Protocols';
   sSearchPath := AppendPathDelim(sProtPath) + '*.csv';
   if FindFirst(sSearchPath,0,SearchRec) = 0 then
      begin
        repeat
         FileName := ExtractFileNameOnly(SearchRec.Name);
         ProtList.Add(Filename);
         until FindNext(Searchrec) <> 0;
      ProtList.Sort;
      cbProtocol.Items.Assign(ProtList);
      cbProtocol.ItemIndex := 0;
      end
     else BSError('No protocol definition files found. Please create a file.');
   end;
   Findclose(SearchRec);
ProtList.Free;
if cbProtocol.Items.Count > 0 then
   cbProtocol.ItemIndex := cbProtocol.Items.IndexOf('Default');
end;


procedure TBSForm.LoadProtocol;
var FileName   :string;
begin
if (cbProtocol.Items.Count > 0) and not Editing then
   begin
   FileName := AppendPathDelim(sProtPath) + cbProtocol.Items[cbProtocol.ItemIndex] + '.csv';
   try
      sgResults.LoadFromCSVFile(FileName,',',false);
   except
      on E:Exception do
         BSError('Could not load protocol file');
      end;
   sgResults.Columns.Items[1].Width := 190;
   end;
end;


procedure TBSForm.FormCreate(Sender: TObject);
var sExePath   :string;

begin
BSForm.Caption := 'Beam Scheme v' + GetAppVersionString(false,2);
Beam := TBeam.Create;
StatusMessages := TStringList.Create;

{Set directory path to program files}
sExePath := ExtractFilePath(Application.ExeName);
SetCurrentDir(sExePath);

{start web server for online help}
FileHandler := TFileHandler.Create;
FileHandler.MimeTypeFile := sExePath + 'html' + DirectorySeparator + 'mime.types';
FileHandler.DocumentRoot := sExePath + 'html';

CGIHandler := TCGIHandler.Create;
CGIHandler.FCGIRoot := sExePath + 'html' + DirectorySeparator + 'cgi-bin';
CGIHandler.FDocumentRoot := sExePath + 'html' + DirectorySeparator + 'cgi-bin';
CGIHandler.FEnvPath := sExePath + 'html' + DirectorySeparator + 'cgi-bin';
CGIHandler.FScriptPathPrefix := 'cgi-bin' + DirectorySeparator;

PHPCGIHandler := TPHPFastCGIHandler.Create;
PHPCGIHandler.Host := 'localhost';
PHPCGIHandler.Port := 4665;
PHPCGIHandler.AppEnv := 'PHP_FCGI_CHILDREN=5:PHP_FCGI_MAX_REQUESTS=10000';
PHPCGIHandler.AppName := 'php-cgi.exe';
PHPCGIHandler.EnvPath := sExePath + 'html' + DirectorySeparator + 'cgi-bin';

HelpServer.RegisterHandler(FileHandler);
HelpServer.RegisterHandler(CGIHandler);

FileHandler.DirIndexList.Add('BSHelp.html');
FileHandler.DirIndexList.Add('index.htm');
FileHandler.DirIndexList.Add('index.php');
FileHandler.DirIndexList.Add('index.cgi');
FileHandler.RegisterHandler(PHPCGIHandler);

YPTR := Point(0,0);
YPTL := Point(0,0);
YPBR := Point(0,0);
YPBL := Point(0,0);
XPTR := Point(0,0);
XPTL := Point(0,0);
XPBR := Point(0,0);
XPBL := Point(0,0);
YPW := 0;
XPW := 0;

BuildProtocolList;
LoadProtocol;

if not HelpServer.Listen(3880) then
   begin
   BSMessage('Error starting help server. Online help may not be available. ');
   end;

Safe := true;
Editing := false;
Normalisation := none;
end;


function TBSForm.FormHelp(Command: Word; Data: PtrInt; var CallHelp: Boolean): Boolean;
var Ctrl:      TControl;
begin
Ctrl := Application.GetControlAtMouse;
if Ctrl.HelpKeyword <> '' then
   ShowHelpOrErrorForKeyword('',Ctrl.HelpKeyword)
  else
   ShowHelpOrErrorForKeyword('','HTML/BSHelp.html');
Result := True;
end;


procedure TBSForm.DTrackBarChange(Sender: TObject);
begin
if Safe then
   begin
   DTrackBar.Invalidate;
   DisplayBeam;
   ShowProfile(iBeam.Picture.Bitmap,XPW,YPTL,YPTR,YPBR,YPBL);
   ShowProfile(iBeam.Picture.Bitmap,YPW,XPTL,XPTR,XPBR,XPBL);
   end;
end;

procedure TBSForm.DTrackBarClick(Sender: TObject);
begin
if Safe then
   begin
   seXAngleChange(Self);
   seYAngleChange(Self);
   end;
end;


procedure TBSForm.ChartToolsetXDataPointHintToolHint(ATool: TDataPointHintTool;
   const APoint: TPoint; var AHint: String);
begin
AHint := '(' +
   FloatToStrF(TLineSeries(ATool.Series).Source.Item[ATool.PointIndex]^.X,ffFixed,7,1) + ',' +
   FloatToStrF(TLineSeries(ATool.Series).Source.Item[ATool.PointIndex]^.Y,ffFixed,7,1) + ')';
end;

procedure TBSForm.ChartToolsetYDataPointHintToolHint(ATool: TDataPointHintTool;
   const APoint: TPoint; var AHint: String);
begin
AHint := '(' +
   FloatToStrF(TLineSeries(ATool.Series).Source.Item[ATool.PointIndex]^.X,ffFixed,7,1) + ',' +
   FloatToStrF(TLineSeries(ATool.Series).Source.Item[ATool.PointIndex]^.Y,ffFixed,7,1) + ')';
end;


procedure TBSForm.miOpenClick(Sender: TObject);
var I          :integer;
    Dummy      :string;
    DataOK     :boolean;

begin
Safe := false;
Dummy := '';
Beam.Rows := 0;
Beam.Cols := 0;
XPTR := Point(0,0);
XPTL := Point(0,0);
XPBR := Point(0,0);
XPBL := Point(0,0);
YPTR := Point(0,0);
YPTL := Point(0,0);
YPBR := Point(0,0);
YPBL := Point(0,0);
iBeam.Picture.Clear;
XProfile.Clear;
YProfile.Clear;
for I:=1 to sgResults.Rowcount-1 do
   begin
   sgResults.Cells[2,I] := '';
   sgResults.Cells[3,I] := '';
   end;

DataOK := false;

with OpenDialog do
   begin
   DefaultExt := '.dcm';
   {$IFDEF WINDOWS}
   Filter := 'DICOM Image|*.dcm|MapCheck Text Files|*.txt|PTW|*.mcc|IBA|*.opg|Windows bitmap|*.bmp|Tiff bitmap|*.tif|JPEG image|*.jpg|HIS image|*.his|All Files|*.*';
   {$ELSE}
   Filter := 'DICOM Image|*.dcm|MapCheck, XIO, RAW Text Files|*.txt|PTW|*.mcc|IBA|*.opg|Windows bitmap|*.bmp|Tiff bitmap|*.tif;*.tiff|JPEG image|*.jpg;*jpeg|HIS image|*.his|All Files|*';
   {$ENDIF}
   Title := 'Open file';
   end;
if OpenDialog.Execute then
   begin
   Dummy := Upcase(ExtractFileExt(OpenDialog.Filename));
   if Dummy = '.DCM' then
      DataOK := DICOMOpen(OpenDialog.Filename);
   if (not DataOK) and (Dummy = '.OPG') then
      DataOK := IBAOpen(OpenDialog.Filename);
   if (not DataOK) and (Dummy = '.MCC') then
      DataOK := PTWOpen(OpenDialog.Filename);
   if (not DataOK) and (Dummy = '.HIS') then
      DataOK := HISOpen(OpenDialog.Filename);
   if (not DataOK) and (Dummy = '.BMP') then
      DataOK := BMPOpen(OpenDialog.Filename);
   if (not DataOK) and ((Dummy = '.TIF') or (Dummy = '.TIFF')) then
      DataOK := BMPOpen(OpenDialog.Filename);
   if (not DataOK) and ((Dummy = '.JPG') or (Dummy = '.JPEG')) then
      DataOK := BMPOpen(OpenDialog.Filename);
   if (not DataOK) and (Dummy = '.ALL') then
      DataOK := XiOOpen(OpenDialog.FileName);
   if not DataOK and ((Dummy = '.TXT') or (Dummy = '')) then {assume file is text}
      DataOK := TextOpen(Opendialog.FileName);

   {set limits}
   if DataOK then
      begin
      seXAngle.MaxValue := 45;
      seXAngle.MinValue := -44;
      seXAngle.Value := 0;
      seXOffset.MaxValue := Beam.Rows div 2;
      if odd(Beam.Rows) then
         seXOffset.MinValue := -(Beam.Rows div 2)
        else
         seXOffset.MinValue := -(Beam.Rows div 2) + 1;
      seXOffset.Value := 0;
      seXWidth.MaxValue := (Beam.Rows);
      seXWidth.Value := 1;
      seYAngle.MaxValue := 135;
      seYAngle.MinValue := 46;
      seYAngle.Value := 90;
      if odd(Beam.Cols - 2) then
         seYOffset.MaxValue := (Beam.Cols - 2) div 2
        else
        seYOffset.MaxValue := (Beam.Cols - 2) div 2 - 1;
      seYOffset.MinValue := -((Beam.Cols - 2) div 2);
      seYOffset.Value := 0;
      seYWidth.MaxValue := Beam.Cols - 2;
      seYWidth.Value := 1;
      if Beam.Max = maxLongint then Beam.Max := Beam.Max - 10;
      DTrackBar.Max := round(Beam.Max);
      DTrackBar.Min := round(Beam.Min);
      DTrackBar.PositionU:= round(Beam.Max);
      DTrackBar.PositionL := round(Beam.Min);
      DTrackBar.LargeChange := round((Beam.Max - Beam.Min)/20);
      DTrackBar.SmallChange := round((Beam.Max - Beam.Min)/100);
      DTrackBar.TickInterval := round((Beam.Max - Beam.Min)/20);

      {display beam}
      Safe := true;
      ClearStatus;
      DisplayBeam;
      seXAngleChange(Self);
      seYAngleChange(Self);
      Dummy := OpenDialog.FileName;
      I := cImage.Canvas.TextWidth(Dummy);
      if I >= cImage.Width then
         Dummy := leftStr(Dummy, round(Length(Dummy)*cImage.Width/(2*I) - 1)) + '...'
            + RightStr(Dummy, round(Length(Dummy)*cImage.Width/(2*I) - 1));
      cImage.Caption := Dummy;
      end
     else
      begin
      BSError('Unrecognised file or file read error.');
      end;
   end;
end;


function TBSForm.TextOpen(sFileName:string):boolean;
var Infile:    textfile;
    Dummy:     string;

begin
{look at first row of text file to determine type}
Result := false;
AssignFile(Infile, sFileName);
Reset(Infile);
readln(Infile,Dummy);
CloseFile(Infile);
if LeftStr(Dummy,10) = '** WARNING' then
   Result := MapCheckOpen(sFileName);
if not Result and (LeftStr(Dummy,8) = '0001108e') then
   Result := XiOOpen(sFileName);
if not Result and (LeftStr(Dummy,8) = 'BrainLAB') then
   Result := BrainLabOpen(sFileName);
if not Result and (Length(Dummy) > 4) then                {assume image is matrix of text values}
   Result := RAWOpen(sFileName);
end;

function TBSForm.MapCheckOpen(sFileName:string):boolean;
var I,J:       integer;
    Dummy,
    sCalFile:  string;
    Value:     double;
    Infile:    textfile;

begin
Result := false;
AssignFile(Infile, sFileName);
Reset(Infile);

readln(Infile,Dummy);
if Dummy[1] = '*' then {file is MapCheck}
   begin
   {get dimensions and scan down to interpolated data}
   sCalFile := 'Dose Interpolated';
   while (Dummy <> sCalFile) and (not eof(Infile)) do
      begin
      readln(Infile,Dummy);
      if LeftStr(Dummy,4) = 'Rows' then
         Beam.Rows := StrToInt(copy(Dummy,6,3));
      if LeftStr(Dummy,4) = 'Cols' then
         Beam.Cols := StrToInt(copy(Dummy,6,3)) + 2;  {include row and detector no}
      if LeftStr(Dummy,9) = 'Dose Info' then
         if Copy(Dummy,12,4) = 'None' then
            sCalFile := 'Interpolated';
      end;
   readln(Infile);                                {skip row header}

   Beam.Max := 0;
   Beam.Min := 1.7E308;
   if (not eof(Infile)) and (Beam.Rows <> 0) and (Beam.Cols <> 0) then
      begin
      SetLength(Beam.Data,Beam.Rows);
      for I := 0 to Beam.Rows - 1 do
         begin
         SetLength(Beam.Data[I],Beam.Cols);
         for J := 0 to Beam.Cols - 1 do
            begin
            Read(Infile, Value);
            Beam.Data[I,J] := Value;
            if Value > Beam.Max then Beam.Max := Value;
            if Value < Beam.Min then Beam.Min := Value;
            end;
         end;

      readln(Infile);
      readln(Infile);                                       {skip column numbers}
      read(Infile,Dummy);
      Dummy := RightStr(Dummy,Length(Dummy) - LastDelimiter(#9,Dummy));
      {set dimensions}
      with Beam do
         begin
         Height := Data[0,0]*2;
         Width := RobustStrToFloat(Dummy)*2;
         XRes := Height/(Rows - 1);             //number of spaces are detectors - 1
         YRes := Width/(Cols - 3)
         end;
      Result := true;
      end
     else
      begin
      BSError('File error, no data found!');
      end;
   end;
CloseFile(Infile);
end;


function TBSForm.IBAOpen(sFileName:string):boolean;
var I,J,K,
    NumSets:   integer;
    Dummy,sPart,
    sCalFile:  string;
    Value:     double;
    Infile:    textfile;

begin
Result := false;
NumSets := 0;
AssignFile(Infile, sFileName);
Reset(Infile);

readln(Infile,Dummy);
if Dummy = '<opimrtascii>' then {file is IBA}
   begin
   {get dimensions and scan down to interpolated data}
   sCalFile := '<asciibody>';
   while (Dummy <> sCalFile) and (not eof(Infile)) do
      begin
      readln(Infile,Dummy);
      sPart := ExtractDelimited(1,Dummy,[':']);
      if sPart = 'No. of Rows' then
         begin
         sPart:= ExtractDelimited(2,Dummy,[':']);
         Beam.Rows := StrToInt(sPart);
         end;
      if sPart = 'No. of Columns' then
         begin
         sPart:= ExtractDelimited(2,Dummy,[':']);
         Beam.Cols := StrToInt(sPart) + 2;  {include row and detector no}
         end;
      if sPart = 'Number of Bodies' then
         begin
         sPart:= ExtractDelimited(2,Dummy,[':']);
         NumSets := StrToInt(sPart);  {include row and detector no}
         end;
      end;
   readln(Infile);                                {skip plane position}
   readln(Infile);                                {skip blank row}
   readln(Infile,Dummy);                          {get col headers}
   sPart:= ExtractDelimited(2,Dummy,[#9]);
   readln(Infile);                                {skip Y[mm]}

   {Sum data sets}
   if (not eof(Infile)) and (Beam.Rows <> 0) and (Beam.Cols <> 0) then
      begin
      for K:=1 to NumSets do
         begin
         if K = 1 then SetLength(Beam.Data,Beam.Rows);
         for I := Beam.Rows - 1 downto 0 do
            begin
            if K = 1 then SetLength(Beam.Data[I],Beam.Cols);
            for J := 1 to Beam.Cols - 1 do
               begin
               read(Infile, Value);
               if (K = 1) or (J = 1) then Beam.Data[I,J] := Value
                  else Beam.Data[I,J] := Beam.Data[I,J] + Value;
               end;
            end;


         while (Dummy <> sCalFile) and (not eof(Infile)) do
            readln(Infile,Dummy);                       {scan to next <asciibody>}
         readln(Infile,Dummy);                                {skip plane position}
         readln(Infile,Dummy);                                {skip blank row}
         readln(Infile,Dummy);                                {get col headers}
         readln(Infile,Dummy);                                {skip Y[mm]}
         end;
      end;

   {average and get Min/Max}
   Beam.Max := 0;
   Beam.Min := 1.7E308;
   if (Beam.Rows <> 0) and (Beam.Cols <> 0) then
      begin
      for I := 0 to Beam.Rows - 1 do
         begin
         for J := 2 to Beam.Cols - 1 do
            begin
            Beam.Data[I,J] := Beam.Data[I,J]/NumSets;
            if Beam.Data[I,J] > Beam.Max then Beam.Max := Beam.Data[I,J];
            if Beam.Data[I,J] < Beam.Min then Beam.Min := Beam.Data[I,J];
            end;
         end;
      end;

   {set dimensions}
   with Beam do
      begin
      Height := Data[0,1]*0.2;
      Width := abs(RobustStrToFloat(Trim(sPart))*0.2);
      XRes := Height/(Rows - 1);             //number of spaces are detectors - 1
      YRes := Width/(Cols - 3)
      end;
   Result := true;
   end
  else
   begin
   BSError('File error, no data found!');
   end;
CloseFile(Infile);
end;


function TBSForm.PTWOpen(sFileName:string):boolean;
{PTW data is organised into a series of profile scans}
var I,J:       integer;
    Dummy:     string;
    Value:     double;
    Infile:    textfile;
    Counting:  boolean;

begin
Result := false;
AssignFile(Infile, sFileName);
Reset(Infile);

readln(Infile,Dummy);
Dummy := DelChars(Dummy,#9);
if Dummy = 'BEGIN_SCAN_DATA' then {file is PTW}
   begin
   {scan through file and get dimensions}
   I := 0;
   J := 0;
   Counting := false;
   while (not eof(infile)) and (Dummy <> 'END_SCAN_DATA') do
      begin
      if (leftstr(Dummy,11) = 'BEGIN_SCAN ') then inc(I);
      if (Dummy = 'BEGIN_DATA') then Counting := true;
      if (Dummy = 'END_DATA') then Counting := false;
      if Counting then inc(J);
      readln(Infile,Dummy);
      Dummy := DelChars(Dummy,#9);
						end;
   Beam.Rows := I;
   Beam.Cols := Round(J/I + 1);

   Reset(Infile);
   if(not eof(Infile)) and (Beam.Rows <> 0) and (Beam.Cols <> 0) then
      begin
      Beam.Max := 0;
      Beam.Min := 1.7E308;
      SetLength(Beam.Data,Beam.Rows);
      I := 0;
      Counting := false;
      readln(Infile,Dummy);
      Dummy := TrimLeftSet(Dummy,StdWordDelims);
      while (not eof(infile)) and (Dummy <> 'END_SCAN_DATA') do
         begin
         if (DelChars(Dummy,#9) = 'END_DATA') then Counting := false;
         if Counting then
            begin
            inc(J);
            Dummy := ExtractDelimited(3,Dummy,[#9]);
            Value := RobustStrToFloat(Dummy);
            Value := Value*100;                                {convert to cGy}
            Beam.Data[Beam.Rows - I,J + 1] := Value;
            if Value > Beam.Max then Beam.Max := Value;
            if Value < Beam.Min then Beam.Min := Value;
            end;
         if (DelChars(Dummy,#9) = 'BEGIN_DATA') then
            begin
            Counting := true;
            J := 0;
            end;
         if (LeftStr(Dummy,11) = 'BEGIN_SCAN ') then
            begin
            inc(I);
            SetLength(Beam.Data[Beam.Rows - I],Beam.Cols + 1);
            end;
         if LeftStr(Dummy,20) = 'SCAN_OFFAXIS_INPLANE' then
            begin
            Copy2SymbDel(Dummy,'=');
            Beam.Data[Beam.Rows - I,0] := RobustStrToFloat(Dummy);
            end;
         readln(Infile,Dummy);
         Dummy := TrimLeftSet(Dummy,StdWordDelims);
         end;
      end;

      {set dimensions}
      with Beam do
         begin
         Height := Data[0,0]/5;
         Width := Height;                      {assume square for now}
         XRes := Height/(Rows - 1);             //number of spaces are detectors - 1
         YRes := Width/(Cols - 3)
         end;
      Result := true;
   end
  else
   begin
   BSError('File error, no data found!');
   end;
CloseFile(Infile);
end;


function TBSForm.DICOMOpen(sFileName:string):boolean;

type  IntRA = array [0..0] of integer;
      IntP0 = ^IntRA;


var Infile:    file;
    sDICOMhdr: string;
    I,J,K,
    I12,
    ImageStart,
    AllocSliceSz,
    StoreSliceSz,
    StoreSliceVox,
    size:      integer;
    Value      :double;
    bImgOK:    boolean = false;
    bHdrOK:    boolean = false;
    gDICOMData:DiCOMDATA;
    lBuff,
    TmpBuff:   bYTEp0;
    lBuff16:   WordP0;
    lBuff32:   DWordP0;

begin
Beam.Rows := 0;
Beam.Cols := 0;
Result := false;
   try

      {procedure read_dicom_data(lVerboseRead,lAutoDECAT7,lReadECAToffsetTables,
         lAutodetectInterfile,lAutoDetectGenesis,lReadColorTables: boolean;
         var lDICOMdata: DICOMdata; var lHdrOK, lImageFormatOK: boolean;
         var lDynStr: string;var lFileName: string);}

      read_dicom_data(false,true,false,false,true,true,false,gDICOMdata,bHdrOK,
         bImgOK,sDICOMhdr,sFileName {infp});
      if (bImgOK) and ((gDicomData.CompressSz > 0) or
         (gDICOMdata.SamplesPerPixel > 1)) then
         begin
         BSError('This software can not read compressed or 24-bit color files.');
         bImgOK := false;
         end;
      if not bHdrOK then
         begin
         BSError('Unable to load DICOM header segment. Is this really a DICOM compliant file?');
         sDICOMhdr := '';
         end;

      if bImgOK and bHdrOK then
         begin
         
         {get dimensions}
         AllocSLiceSz := (gDICOMdata.XYZdim[1]*gDICOMdata.XYZdim[2]{height * width} *
            gDICOMdata.Allocbits_per_pixel+7) div 8 ;
         if (AllocSLiceSz) < 1 then exit;
         Beam.Cols := gDICOMData.XYZdim[1] + 2;
         Beam.Rows := gDICOMData.XYZdim[2];
         Beam.XRes := gDICOMData.XYZmm[1]/10;
         Beam.YRes := gDICOMData.XYZmm[2]/10;
         Beam.Width := gDICOMData.XYZdim[1]*gDICOMData.XYZmm[1]/10;
         Beam.Height := gDICOMData.XYZdim[2]*gDICOMData.XYZmm[2]/10;

         AssignFile(Infile, OpenDialog.FileName);
         FileMode := 0; //Read only
         Reset(Infile,1);

         ImageStart := gDicomData.ImageStart;
         if (ImageStart + AllocSliceSz) > (FileSize(Infile)) then
            begin
            BSError('This file does not have enough data for the image size.');
            closefile(Infile);
            FileMode := 2; //read/write
            exit;
            end;

         Seek(Infile, ImageStart);

         case gDICOMdata.Allocbits_per_pixel of
            8:begin
              GetMem( lbuff, AllocSliceSz);
              BlockRead(Infile, lbuff^, AllocSliceSz{, n});
              CloseFile(Infile);
              FileMode := 2; //read/write
              end;

           16:begin
              GetMem( lbuff16, AllocSliceSz);
              BlockRead(Infile, lbuff16^, AllocSliceSz{, n});
              CloseFile(Infile);
              FileMode := 2; //read/write
              end;

           12:begin
              GetMem( tmpbuff, AllocSliceSz);
              BlockRead(Infile, tmpbuff^, AllocSliceSz{, n});
              CloseFile(Infile);
              FileMode := 2; //read/write
              StoreSliceVox := gDICOMdata.XYZdim[1]*gDICOMdata.XYZdim[2];
              StoreSLiceSz := StoreSliceVox * 2;
              GetMem( lbuff16, StoreSLiceSz);
              I12 := 0;
              I := 0;
              repeat
                 lbuff16^[I] := (((tmpbuff^[I12]) shr 4) shl 8) + (((tmpbuff^[I12+1]) and 15)
                    + (((tmpbuff^[I12]) and 15) shl 4) );
                 inc(I);
                 if I < StoreSliceVox then
                    //char (((integer(tmpbuff[I12+2]) and 16) shl 4)+ (integer(tmpbuff[I12+1]) shr 4));
                    lbuff16^[i] :=  (((tmpbuff^[I12+2]) and 15) shl 8) +((((tmpbuff^[I12+1]) shr 4 )
                       shl 4)+((tmpbuff^[I12+2]) shr 4)  );
                 inc(I);
                 I12 := I12 + 3;
              until I >= StoreSliceVox;
              FreeMem( tmpbuff);
              end;
          32: begin
              GetMem( lbuff32, AllocSliceSz);
              BlockRead(Infile, lbuff32^, AllocSliceSz{, n});
              CloseFile(Infile);
              FileMode := 2; //read/write
              end;
            else exit;
            end;

         if  (gDICOMdata.Storedbits_per_pixel)  > 16 then
            begin
            size := gDicomData.XYZdim[1]*gDicomData.XYZdim[2] {2*width*height};
            if gDicomdata.little_endian <> 1 then  //convert big-endian data to Intel friendly little endian
               for i := (Size-1) downto 0 do
                   lbuff32^[i] := swap(lbuff32^[i]);

            Value := lbuff32^[0];
            Beam.Max := Value;
            Beam.Min := Value;
            I:=0;
            SetLength(Beam.Data,Beam.Rows);
            for J:= 0 to gDicomData.XYZdim[2] - 1 do
               begin
               SetLength(Beam.Data[J],Beam.Cols);
               for K:=0 to gDicomData.XYZdim[1] - 1 do
                  begin
                  Value := lbuff32^[i];
                  if Value < Beam.Min then Beam.Min := Value;
                  if Value > Beam.Max then Beam.Max := Value;
                  Beam.Data[J,K+2] := Value;
                  inc(I);
                  end;
               end;

            FreeMem( lbuff32 );
            end
          else
         {rescale and convert to 8 bit}
         if  (gDICOMdata.Storedbits_per_pixel)  > 8 then
            begin
            size := gDicomData.XYZdim[1]*gDicomData.XYZdim[2] {2*width*height};
            if gDicomdata.little_endian <> 1 then  //convert big-endian data to Intel friendly little endian
               for i := (Size-1) downto 0 do
                  lbuff16^[i] := swap(lbuff16^[i]);

            Value := lbuff16^[0];
            Beam.Max := Value;
            Beam.Min := Value;
            I := 0;
            SetLength(Beam.Data,Beam.Rows);
            for J:= 0 to gDicomData.XYZdim[2] - 1 do
               begin
               SetLength(Beam.Data[J],Beam.Cols);
               for K:=0 to gDicomData.XYZdim[1] - 1 do
                  begin
                  Value := lbuff16^[i];
                  if Value < Beam.Min then Beam.Min := Value;
                  if Value > Beam.Max then Beam.Max := Value;
                  Beam.Data[J,K+2] := Value;
                  inc(I);
                  end;
               end;
            FreeMem(lbuff16);
            end
           else
            {rescale}
            begin
            size := gDicomData.XYZdim[1]*gDicomData.XYZdim[2] {2*width*height};
            value := lbuff^[0];
            Beam.max := value;
            Beam.min := value;
            I := 0;
            SetLength(Beam.Data,Beam.Rows);
            for J:= 0 to gDicomData.XYZdim[2] - 1 do
               begin
               SetLength(Beam.Data[J],Beam.Cols);
               for K:=0 to gDicomData.XYZdim[1] - 1 do
                  begin
                  value := lbuff^[i];
                  if value < Beam.min then Beam.min := value;
                  if value > Beam.max then Beam.max := value;
                  Beam.Data[J,K+2] := Value;
                  inc(I);
                  end;
               end;
            FreeMem(lBuff);
            end;
         Result := true;
         end
        else
         begin
         BSError('File error, no data found!');
         end;
     except
       BSError('File error, corrupt file');
     end;
end;


function TBSForm.HISOpen(sFileName:string):boolean;
var Infile:    file of word;
    I,J,K,
    size       :integer;
    FileXDim,
    FileYDim,
    ImageStart :word;
    Value      :double;
    lBuff16:   WordP0;

begin
Beam.Rows := 0;
Beam.Cols := 0;
Result := false;
   try
   AssignFile(Infile,SFileName);
   FileMode := 0; //Read only
   Reset(Infile);

   {get dimensions}
   Seek(Infile,3);
   Read(Infile,ImageStart);
   ImageStart :=ImageStart div 2; {no of 16 bit words}
   Seek(Infile,8);
   Read(Infile,FileXDim);
   Read(Infile,FileYDim);
   Beam.Cols := FileXDim + 2;
   Beam.Rows := FileYDim;
   Beam.XRes := FileXDim;
   Beam.YRes := FileYDim;
   Beam.Width := FileXDim;
   Beam.Height := FileYDim;

   Seek(Infile, ImageStart);
   Size := FileXDim*FileYDim*2;
   GetMem( lbuff16, Size);
   BlockRead(Infile, lbuff16^, Size div 2);
   CloseFile(Infile);

   Value := lbuff16^[0];
   Beam.Max := Value;
   Beam.Min := Value;
   I := 0;
   SetLength(Beam.Data,Beam.Rows);
   for J:= 0 to FileYDim - 1 do
      begin
      SetLength(Beam.Data[J],Beam.Cols);
      for K:=0 to FileXDim - 1 do
         begin
         Value := lbuff16^[i];
         if Value < Beam.Min then Beam.Min := Value;
         if Value > Beam.Max then Beam.Max := Value;
         Beam.Data[J,K+2] := Value;
         inc(I);
         end;
      end;
   FreeMem(lbuff16);
   Result := true;
   except
      BSError('File error, corrupt file');
   end;
end;


function TBSForm.XiOOpen(sFileName:string):boolean;
var I,J:       integer;
    Dummy:     string;
    cGy,                       {if dose is in Gy convert to cGy}
    Value:     double;
    Infile:    textfile;

begin
Result := false;
AssignFile(Infile, sFileName);
Reset(Infile);
cGy := 1;
for I:=1 to 16 do
   begin
   readln(Infile,Dummy);
   if LeftStr(Dummy,9) = 'DosePtsxy' then
      begin
      Beam.Cols := StrToInt(copy(Dummy,11,3)) + 2;
      Beam.Rows := StrToInt(copy(Dummy,15,3));
      end;
   if LeftStr(Dummy,9) = 'DoseResmm' then
      begin
      Beam.XRes := RobustStrToFloat(RightStr(Dummy,3));
      Beam.YRes := Beam.XRes;
      end;
   if LeftStr(Dummy,19) = 'OutputWidLenQAplane' then
      begin
      Beam.Width := RobustStrToFloat(ExtractDelimited(2,Dummy,[',']));
      Beam.Height := RobustStrToFloat(ExtractDelimited(3,Dummy,[',']));
      end;
   if LeftStr(Dummy,9) = 'DoseUnits' then
      begin
      Dummy := TrimLeft(ExtractDelimited(2,Dummy,[',']));
      if LeftStr(Dummy,2) = 'Gy' then cGy := 100;
      end;
   end;

Beam.Max := 0;
Beam.Min := 1.7E308;
if (not eof(Infile)) and (Beam.Rows <> 0) and (Beam.Cols <> 0) then
   begin
   SetLength(Beam.Data,Beam.Rows);
   for I := 0 to Beam.Rows - 1 do
      begin
      SetLength(Beam.Data[I],Beam.Cols);
      readln(Infile,Dummy);
      for J := 1 to Beam.Cols - 2 do
         begin
         Value := RobustStrToFloat(ExtractDelimited(J,Dummy,[',']))*cGy;
         Beam.Data[I,J+1] := Value;
         if Value > Beam.Max then Beam.Max := Value;
         if Value < Beam.Min then Beam.Min := Value;
         end;
      end;
   Result := true;
   end
  else
   begin
   BSError('File error, no data found!');
   end;
CloseFile(Infile);
end;


function TBSForm.RAWOpen(sFileName:string):boolean;
var I,J:       integer;
    Dummy,
    sValue:    string;
    Value:     double;
    Infile:    textfile;

begin
Result := true;
   try
   AssignFile(Infile, sFileName);
   Reset(Infile);

   Beam.Max := 0;
   Beam.Min := 1.7E308;
   I := 0;
   while not eof(Infile) and Result do
      begin
      SetLength(Beam.Data,I+1);
      readln(Infile,Dummy);
      Dummy := Tab2Space(Dummy,1);
      J := 0;
      while Result and (Dummy <> '') do
         begin
         SetLength(Beam.Data[I],J+3);
         sValue := Copy2SpaceDel(Dummy);
            try
            Value := RobustStrToFloat(sValue);
            except
            Result := false;
            end;
         Beam.Data[I,J+1] := Value;
         if Value > Beam.Max then Beam.Max := Value;
         if Value < Beam.Min then Beam.Min := Value;
         inc(J);
         end;
      inc(I);
      end;
   if Result then
      begin
      Beam.Rows := I;
      Beam.Cols := J + 2;
      Beam.XRes := 0.0334;                      {assume this is from film scanned at 76 dpi}
      Beam.YRes := 0.0334;
      end
     else
      BSError('Could not read RAW text file');
   Result := true;
   finally
   CloseFile(Infile);
   end;
end;


function TBSForm.BrainLabOpen(sFileName:string):boolean;
var I,J,K,
    NumSets:   integer;
    Dummy,sPart,
    sCalFile,
    sColHead:  string;
    cGy,                       {if dose is in Gy convert to cGy}
    Value,
    LDet,                      {position of left most value}
    RDet:      double;         {position of right most value}
    Infile:    textfile;

begin
Result := false;
NumSets := 0;
RDet := 0;
AssignFile(Infile, sFileName);
Reset(Infile);
cGy := 1;

readln(Infile,Dummy);
if LeftStr(Dummy,8) = 'BrainLAB' then {file is BrainLab}
   begin
   {get dimensions and scan down to interpolated data}
   sCalFile := '-----------------------------------------------------';
   while (Dummy <> sCalFile) and (not eof(Infile)) do
      begin
      readln(Infile,Dummy);
      sPart := ExtractDelimited(1,Dummy,[':']);
      if sPart = 'Number of Rows' then
         begin
         sPart:= ExtractDelimited(2,Dummy,[':']);
         Beam.Rows := StrToInt(sPart);
         end;
      if sPart = 'Number of Columns' then
         begin
         sPart:= ExtractDelimited(2,Dummy,[':']);
         Beam.Cols := StrToInt(sPart) + 2;  {include row and detector no}
         end;
      if sPart = 'Number of Planes' then
         begin
         sPart:= ExtractDelimited(2,Dummy,[':']);
         NumSets := StrToInt(sPart);
         end;
      if Dummy = 'Table Entries in Gy' then cGy := 100;
      end;
   readln(Infile,sColHead);                          {get col headers}

   {Sum data sets}
   if (not eof(Infile)) and (Beam.Rows <> 0) and (Beam.Cols <> 0) then
      begin
      for K:=1 to NumSets do
         begin
         if K = 1 then SetLength(Beam.Data,Beam.Rows);
         for I := 0 to Beam.Rows - 1 do
            begin
            if K = 1 then SetLength(Beam.Data[I],Beam.Cols);
            for J := 1 to Beam.Cols - 1 do
               begin
               read(Infile, Value);
               if (K = 1) then
                  begin
                  if (J = 1) then Beam.Data[I,J] := Value
                     else Beam.Data[I,J] := Value*cGy;
                  end
                 else
                  begin
                  if (J = 1) then Beam.Data[I,J] := Value
                     else Beam.Data[I,J] := Beam.Data[I,J] + Value*cGy;
                  end;
               end;
            end;


         while (Dummy <> sCalFile) and (not eof(Infile)) do
            readln(Infile,Dummy);                       {scan to next ------}
         readln(Infile,Dummy);                          {get col headers}
         end;
      end;

   {average and get Min/Max}
   Beam.Max := 0;
   Beam.Min := 1.7E308;
   if (Beam.Rows <> 0) and (Beam.Cols <> 0) then
      begin
      for I := 0 to Beam.Rows - 1 do
         begin
         for J := 2 to Beam.Cols - 1 do
            begin
            Beam.Data[I,J] := Beam.Data[I,J]/NumSets;
            if Beam.Data[I,J] > Beam.Max then Beam.Max := Beam.Data[I,J];
            if Beam.Data[I,J] < Beam.Min then Beam.Min := Beam.Data[I,J];
            end;
         end;
      end;

   {set dimensions}
   with Beam do
      begin
      LDet:= RobustStrToFloat(ExtractDelimited(2,sColHead,[#9]));
      sPart := sColHead;
      I := 3;
      while sPart <> '' do
         begin
         sPart := ExtractDelimited(I,sColHead,[#9]);
         if sPart <> '' then RDet := RobustStrToFloat(sPart);
         Inc(I);
         end;
      Width := abs(LDet - RDet)/10;
      Height := abs(Data[0,1] - Data[Beam.Rows-1,1])/10;
      XRes := Height/(Rows - 1);             //number of spaces are detectors - 1
      YRes := Width/(Cols - 3);
      end;
   Result := true;
   end
  else
   begin
   BSError('File error, no data found!');
   end;
CloseFile(Infile);
end;


function TBSForm.BMPOpen(sFileName:string):boolean;
var I,J,
    ResUnit    :integer;
    Value,
    Res        :double;
    SrcIntfImage:TLazIntfImage;
    lRawImage  :TRawImage;
    Curcolor   :TFPColor;
    sRes,
    sResUnit   :string;

begin
Res := 2.54/300;               {assume image scanned at 300 dpi}
Result := false;
lRawImage.Init;
lRawImage.Description.Init_BPP24_B8G8R8_BIO_TTB(0,0);
lRawImage.CreateData(false);
SrcIntfImage := TLazIntfImage.Create(0,0);
SrcIntfImage.SetRawImage(lRawImage);
SrcIntfImage.LoadFromFile(sFileName);
Beam.Cols := SrcIntfImage.Width + 2;
Beam.Rows := SrcIntfImage.Height;
if SrcIntfImage.ExtraCount>0 then
   try
   sResUnit := SrcIntfImage.Extra['TiffResolutionUnit'];
   ResUnit := StrToInt(sResUnit);
   sRes := SrcIntfImage.Extra['TiffXResolution'];
   case ResUnit of
      2: Res := 2.54/StrToFloat(Copy2Symb(sRes,'/'));      {res is in dpi}
      3: Res := 1/StrToFloat(Copy2Symb(sRes,'/'));         {res is in dpcm}
      end;
   except
   BSWarning('Image resolution not found, defaulting to 300 dpi');
   end;
Beam.Max := 0;
Beam.Min := 1.7E308;
if (Beam.Rows > 0) and (Beam.Cols > 0) then
   begin
   SetLength(Beam.Data,Beam.Rows);
   for I := 0 to Beam.Rows - 1 do
      begin
      SetLength(Beam.Data[I],Beam.Cols);
      for J := 1 to Beam.Cols - 2 do
         begin
         CurColor := SrcIntfImage.Colors[J-1,I];
         Value := byte(CurColor.Red);
         Beam.Data[I,J+1] := Value;
         if Value > Beam.Max then Beam.Max := Value;
         if Value < Beam.Min then Beam.Min := Value;
         end;
      end;
   Beam.XRes := Res;
   Beam.YRes := Res;
   Result := true;
   end
  else
   begin
   BSError('File error, no data found!');
   end;
SrcIntfImage.Free;
end;


procedure TBSForm.FormResize(Sender: TObject);
begin
miRestoreClick(Sender);
end;

procedure TBSForm.iBeamClick(Sender: TObject);
var MouseXY:   TPoint;
    BMPH,                      {Bitmap height}
    BMPW:      integer;        {Bitmap width}
    PX,
    PY,
    R,
    Theta,
    Phi,
    Scale,
    AR:        double;         {Aspect ratio}

begin
if iBeam.Picture.Bitmap.Height > 0 then
   begin
   MouseXY := iBeam.ScreenToControl(Mouse.CursorPos);
   BMPH := iBeam.Picture.Bitmap.Height;
   BMPW := iBeam.Picture.Bitmap.Width;
   AR := BMPW/BMPH;
   if iBeam.Height <= iBeam.Width then
      Scale := iBeam.Height
     else
      Scale := iBeam.Width;

   if AR >= 1 then
      begin
      PY := (Beam.Rows div 2) - MouseXY.Y*(Beam.Rows/Scale)*AR;
      PX := MouseXY.X*((Beam.Cols - 2)/Scale) - ((Beam.Cols -2) div 2);
      end
     else
      begin
      PY := (Beam.Rows div 2) - MouseXY.Y*(Beam.Rows/Scale);
      PX := MouseXY.X*((Beam.Cols - 2)/Scale)/AR - ((Beam.Cols -2) div 2);
      end;

   R := sqrt(PX*PX + PY*PY);
   Theta := arctan2(PX,PY);

   Phi := seXAngle.Value*2*PI/360;
   seXOffset.Value := R*cos(Theta - Phi);

   Phi := seYAngle.Value*2*PI/360;
   seYOffset.Value := R*cos(Theta - Phi);
   end;
end;


procedure TBSForm.miEditPClick(Sender: TObject);
begin
Editing := true;
cbProtocol.Style := csDropDown;
cbProtocol.Text := cbProtocol.Items[cbProtocol.ItemIndex];
sbSaveP.Enabled := true;
sbSaveP.Visible := true;
miSaveP.Enabled := true;
miEditP.Enabled := false;
miQuitEdit.Enabled := true;
sbAddP.Enabled := true;
sbAddP.Visible := true;
sbDelP.Enabled := true;
sbDelP.Visible := true;
sbExitP.Enabled := true;
sbExitP.Visible := true;
cResults.Caption := 'Edit protocol';
sgResults.Columns.Items[1].Visible := true;
sgResults.Columns.Items[2].Visible := false;
sgResults.Columns.Items[3].Visible := false;
sgResults.Options := sgResults.Options + [goEditing];
end;


procedure TBSForm.miAboutClick(Sender: TObject);
begin
  AboutForm := TAboutForm.Create(Self);
  AboutForm.Caption := 'BeamScheme version ' + GetAppVersionString(True,2,True,True);
  AboutForm.ShowModal;
  AboutForm.Free;
end;


procedure TBSForm.miContentsClick(Sender: TObject);
begin
ShowHelpOrErrorForKeyword('','HTML/BSHelp.html');
end;


procedure TBSForm.miRestoreClick(Sender: TObject);
begin
sbIMinClick(Sender);
sbXMinClick(Sender);
sbYMinClick(Sender);
sbRMinClick(Sender);
end;


procedure TBSForm.sbInvertClick(Sender: TObject);
{Invert and rescale}
var I,J        :integer;
    z          :double;

begin
XPTR := Point(0,0);
XPTL := Point(0,0);
XPBR := Point(0,0);
XPBL := Point(0,0);
YPTR := Point(0,0);
YPTL := Point(0,0);
YPBR := Point(0,0);
YPBL := Point(0,0);
if Beam.Max <> Beam.Min then
   for I:=0 to Beam.Rows - 1 do
     for J:=2 to Beam.Cols - 1 do
        begin
        Z := Beam.Data[I,J];
        Z :=(Beam.Max - Z + Beam.Min);
        Beam.Data[I,J] := Z;
        end;
DisplayBeam;
seXAngleChange(Self);
seYAngleChange(Self);
end;


procedure TBSForm.sbNormClick(Sender: TObject);
begin
if tbNormCax.Down then
   begin
   Normalisation := norm_cax;
   end
  else
   begin
   Normalisation := none;
   end;

seXAngleChange(Self);
seYAngleChange(Self);
end;


procedure TBSForm.sbMaxNormClick(Sender: TObject);
begin
if tbNormMax.Down then
   begin
   Normalisation := norm_max;
   end
else
   begin
   Normalisation := none;
   end;

seXAngleChange(Self);
seYAngleChange(Self);
end;


procedure TBSForm.sbCentreClick(Sender: TObject);
{resamples the data using bi-linear interpolation}
var I,J,
    NI,NJ,                     {new x and y coords}
    MaxI,MaxJ  :integer;
    ShiftData  :TBeamData;
    SX,SY,
    NX,NY,
    RemX,
    RemY:double;

begin
XPTR := Point(0,0);
XPTL := Point(0,0);
XPBR := Point(0,0);
XPBL := Point(0,0);
YPTR := Point(0,0);
YPTL := Point(0,0);
YPBR := Point(0,0);
YPBL := Point(0,0);
MaxI := Beam.Cols - 3;
MaxJ := Beam.Rows - 1;
with XBParams do SX := (LEdge + REdge)/(2*Beam.XRes);
with YBParams do SY := (LEdge + REdge)/(2*Beam.YRes);
SetLength(ShiftData,Beam.Rows);

for J:= 0 to MaxJ do
   begin
   SetLength(ShiftData[J],Beam.Cols);
   ShiftData[J,0] := Beam.Data[J,0];
   ShiftData[J,1] := Beam.Data[J,1];
   NY := J + SY;
   NJ := Trunc(NY);
   RemY := NY - NJ;
   if NJ < 0 then NJ := 0
     else
      if NJ > MaxJ - 1 then NJ := MaxJ - 1;
   for I:=0 to MaxI do
      begin
      NX := I + SX;
      NI := Trunc(NX);
      RemX := NX - NI;
      if NI < 0 then NI := 0
         else
         if NI > MaxI - 1 then NI := MaxI - 1;
      ShiftData[J,I+2] := Beam.Data[NJ,NI+2]*(1-RemX)*(1-RemY) + Beam.Data[NJ,NI+3]*RemX*(1-RemY)
         + Beam.Data[NJ+1,NI+2]*(1-RemX)*RemY + Beam.Data[NJ+1,NI+3]*RemX*RemY;
      end;
   end;
Beam.Data := ShiftData;
DisplayBeam;
seXAngleChange(Self);
seYAngleChange(Self);
end;


procedure TBSForm.sbIMaxClick(Sender: TObject);
begin
pBeam.Height := ClientHeight - 20;
pBeam.Width := ClientWidth;
pBeam.BringToFront;
sbIMax.Enabled := False;
sbIMax.Visible := False;
sbIMin.Left := pBeam.Width - 30;
cImage.Width := pBeam.Width - 32;
sbIMin.Enabled := True;
sbIMin.Visible := True;
lMin.Top := pMaxMin.Height - 20;
DTrackbar.Height := pMaxMin.Height - 40;
pXProfile.Hide;
pYProfile.Hide;
PResults.Hide;
end;


procedure TBSForm.sbIMinClick(Sender: TObject);
begin
pBeam.Height := (BSForm.ClientHeight - 20) div 2 - 1;
pBeam.Width := BSForm.ClientWidth div 2 - 1;
pBeam.SendToBack;
sbIMax.Left := pBeam.Width - 30;
sbIMax.Enabled := true;
sbIMax.Visible := true;
sbIMin.Left := pBeam.Width - 30;
cImage.Width := pBeam.Width - 32;
sbIMin.Enabled := false;
sbIMin.Visible := false;
pMaxMin.Height := pBeam.Height - 49;
lMin.Top := pMaxMin.Height - 20;
DTrackbar.Height := pMaxMin.Height - 40;
pXProfile.Show;
pYProfile.Show;
pResults.Show;
end;


procedure TBSForm.sbRMaxClick(Sender: TObject);
begin
pResults.Height := ClientHeight - 20;
pResults.Width := ClientWidth;
pResults.Left := 0;
pResults.Top := 0;
pResults.BringToFront;
sbRMax.Enabled := false;
sbRMax.Visible := false;
sbRMin.Left := pResults.Width - 30;
sbRMin.Enabled := true;
sbRMin.Visible := true;
pBeam.Hide;
pXProfile.Hide;
pYProfile.Hide;
end;

procedure TBSForm.sbRMinClick(Sender: TObject);
begin
pResults.Height := (BSForm.ClientHeight - 20) div 2 - 1;
pResults.Width := BSForm.ClientWidth div 2 - 1;
pResults.Left := BSForm.ClientWidth div 2;
pResults.Top := (BSForm.ClientHeight - 20) div 2;
pResults.SendToBack;
sbRMax.Left := pResults.Width - 30;
sbRMax.Enabled := true;
sbRMax.Visible := true;
sbRMin.Left := pResults.Width - 30;
sbRMin.Enabled := false;
sbRMin.Visible := false;
pBeam.Show;
pXProfile.Show;
pYProfile.Show;
end;


procedure TBSForm.sbXMaxClick(Sender: TObject);
begin
pXProfile.Height := ClientHeight - 20;
pXProfile.Width := ClientWidth;
pXProfile.Left := 0;
pXProfile.BringToFront;
sbXMax.Enabled := false;
sbXMax.Visible := false;
sbXMin.Left := pXProfile.Width - 30;
sbXMin.Enabled := true;
sbXMin.Visible := true;
pBeam.Hide;
pYProfile.Hide;
pResults.Hide;
end;


procedure TBSForm.sbXMinClick(Sender: TObject);
begin
pXProfile.Height := (BSForm.ClientHeight - 20) div 2 - 1;
pXProfile.Width := BSForm.ClientWidth div 2 - 1;
pXProfile.Left := BSForm.ClientWidth div 2 - 1;
pXProfile.SendToBack;
sbXMax.Left := pXProfile.Width - 30;
sbXMax.Enabled := true;
sbXMax.Visible := true;
sbXMin.Left := pXProfile.Width - 30;
sbXMin.Enabled := false;
sbXMin.Visible := false;
pBeam.Show;
pYProfile.Show;
PResults.Show;
end;

procedure TBSForm.sbYMaxClick(Sender: TObject);
begin
pYProfile.Height := ClientHeight - 20;
pYProfile.Width := ClientWidth;
pYProfile.Top := 0;
pYProfile.BringToFront;
sbYMax.Enabled := false;
sbYMax.Visible := false;
sbYMin.Left := pYProfile.Width - 30;
sbYMin.Enabled := true;
sbYMin.Visible := true;
pBeam.Hide;
pXProfile.Hide;
pResults.Hide;
end;


procedure TBSForm.sbYMinClick(Sender: TObject);
begin
pYProfile.Height := (BSForm.ClientHeight - 20) div 2 - 1;
pYProfile.Width := BSForm.ClientWidth div 2 - 1;
pYProfile.Top := (BSForm.ClientHeight - 20) div 2;
pYProfile.SendToBack;
sbYMax.Left := pYProfile.Width - 30;
sbYMax.Enabled := true;
sbYMax.Visible := true;
sbYMin.Left := pYProfile.Width - 30;
sbYMin.Enabled := false;
sbYMin.Visible := false;
pBeam.Show;
pXProfile.Show;
pResults.Show;
end;


procedure TBSForm.seYAngleChange(Sender: TObject);
var Angle,
    Offset,
    Wdth       :double;
    MBitmap    :TBitmap;
    ErrMsg     :string;

begin
if Safe then
   begin
   Safe := false;
   ErrMsg := '';
   ClearStatus;
   Angle := seYAngle.Value;
   Offset := -seYOffset.Value;
   Wdth := seYWidth.Value;
   if (iBeam.Picture.Bitmap <> nil) and (length(Beam.Data) <> 0) then
      begin
      MBitmap := iBeam.Picture.Bitmap;
      DrawProfile(MBitmap, Beam, Angle, Offset, Wdth,
         YProfile, YPArr, YPTL, YPTR, YPBL, YPBR, YPW);
      iBeam.Picture.Bitmap := MBitmap;
      CalcParams(YPArr, YBParams, Normalisation, ErrMsg);
      ShowYResults(YBParams);
      if ErrMsg <> '' then BSWarning(ErrMsg);
      end;
   Safe := true;
   end;
end;


procedure TBSForm.seXAngleChange(Sender: TObject);
var Angle,
    Offset,
    Wdth       :double;
    MBitmap    :TBitmap;
    ErrMsg     :string;
    StartTime,
    EndTime    :integer;

begin
if Safe then
   begin
   Safe := false;
   ErrMsg := '';
   ClearStatus;
   Angle := seXAngle.Value;
   Offset := -seXOffset.Value;
   Wdth := seXWidth.Value;
   if (iBeam.Picture.Bitmap <> nil) and (length(Beam.Data) <> 0) then
      begin
      MBitmap := iBeam.Picture.Bitmap;
      StartTime := GetTickCount64;
      DrawProfile(MBitmap, Beam, Angle, Offset, Wdth,
         XProfile, XPArr, XPTL, XPTR, XPBL, XPBR, XPW);
      iBeam.Picture.Bitmap := MBitmap;
      CalcParams(XPArr, XBParams, Normalisation, ErrMsg);
      ShowXResults(XBParams);
      EndTime := GetTickCount64 - StartTime;
      BSMessage('Parameters calculated in ' + IntToStr(EndTime) + ' ms.');
      if ErrMsg <> '' then BSWarning(ErrMsg);
      end;
   Safe := true;
   end;
end;

procedure TBSForm.ShowXResults(BeamParams:TBeamParams);
var I          :integer;
    Parser     :TParser;
    sExpr      :string;        {expression to calculate}

begin
Parser := TParser.Create(BSForm);
with BeamParams do
   begin
   {Transfer parameters to parser}
   Parser.SetVariable('ALeft',ALeft);
   Parser.SetVariable('ARight',ARight);
   Parser.SetVariable('RDiff',RDiff);
   Parser.SetVariable('ADiff',ADiff);
   Parser.SetVariable('PMax',CMax);
   Parser.SetVariable('PMin',CMin);
   Parser.SetVariable('RCAX',RCAX);
   Parser.SetVariable('MPos',MPos);
   Parser.SetVariable('LEdge',LEdge);
   Parser.SetVariable('REdge',REdge);
   Parser.SetVariable('LInf',LInf);
   Parser.SetVariable('RInf',RInf);
   Parser.SetVariable('LSlope',LSlope);
   Parser.SetVariable('RSlope',RSlope);
   Parser.SetVariable('L10',L10);
   Parser.SetVariable('R10',R10);
   Parser.SetVariable('L20',L20);
   Parser.SetVariable('R20',R20);
   Parser.SetVariable('L80',L80);
   Parser.SetVariable('R80',R80);
   Parser.SetVariable('L90',L90);
   Parser.SetVariable('R90',R90);
   Parser.SetVariable('IL20',InfL20);
   Parser.SetVariable('IR20',InfR20);
   Parser.SetVariable('IL50',InfL50);
   Parser.SetVariable('IR50',InfR50);
   Parser.SetVariable('IL80',InfL80);
   Parser.SetVariable('IR80',InfR80);
   Parser.SetVariable('LD20',LD20);
   Parser.SetVariable('RD20',RD20);
   Parser.SetVariable('LD50',LD50);
   Parser.SetVariable('RD50',RD50);
   Parser.SetVariable('LD60',LD60);
   Parser.SetVariable('RD60',RD60);
   Parser.SetVariable('LD80',LD80);
   Parser.SetVariable('RD80',RD80);
   Parser.SetVariable('N',NP);
   Parser.SetVariable('PSum',PSum);
   Parser.SetVariable('PSSqr',PSSqr);

   {calc values and write to string grid}
   for I:=1 to sgResults.RowCount-1 do
      begin
      sExpr := sgResults.Cells[1,I];
      if sExpr <> '' then
         begin
            try
            Parser.Expression:= sExpr;
            sgResults.Cells[2,I] := FloatToStrF(Parser.Value,ffFixed,4,2);
            except
               on E:Exception do
                  BSError('Could not evaluate expression, ' + sExpr);
            end;
         end
        else sgResults.Cells[2,I] := '';
      end;
   end;
end;


procedure TBSForm.ShowYResults(BeamParams:TBeamParams);
var I          :integer;
    Parser     :TParser;
    sExpr      :string;        {expression to calculate}

begin
Parser := TParser.Create(BSForm);
with BeamParams do
   begin
   {Transfer parameters to parser}
   Parser.SetVariable('ALeft',ALeft);
   Parser.SetVariable('ARight',ARight);
   Parser.SetVariable('RDiff',RDiff);
   Parser.SetVariable('ADiff',ADiff);
   Parser.SetVariable('PMax',CMax);
   Parser.SetVariable('PMin',CMin);
   Parser.SetVariable('RCAX',RCAX);
   Parser.SetVariable('MPos',MPos);
   Parser.SetVariable('LEdge',LEdge);
   Parser.SetVariable('REdge',REdge);
   Parser.SetVariable('LInf',LInf);
   Parser.SetVariable('RInf',RInf);
   Parser.SetVariable('LSlope',LSlope);
   Parser.SetVariable('RSlope',RSlope);
   Parser.SetVariable('L10',L10);
   Parser.SetVariable('R10',R10);
   Parser.SetVariable('L20',L20);
   Parser.SetVariable('R20',R20);
   Parser.SetVariable('L80',L80);
   Parser.SetVariable('R80',R80);
   Parser.SetVariable('L90',L90);
   Parser.SetVariable('R90',R90);
   Parser.SetVariable('IL20',InfL20);
   Parser.SetVariable('IR20',InfR20);
   Parser.SetVariable('IL50',InfL50);
   Parser.SetVariable('IR50',InfR50);
   Parser.SetVariable('IL80',InfL80);
   Parser.SetVariable('IR80',InfR80);
   Parser.SetVariable('LD20',LD20);
   Parser.SetVariable('RD20',RD20);
   Parser.SetVariable('LD50',LD50);
   Parser.SetVariable('RD50',RD50);
   Parser.SetVariable('LD60',LD60);
   Parser.SetVariable('RD60',RD60);
   Parser.SetVariable('LD80',LD80);
   Parser.SetVariable('RD80',RD80);
   Parser.SetVariable('N',NP);
   Parser.SetVariable('PSum',PSum);
   Parser.SetVariable('PSSqr',PSSqr);

   {calc values and write to string grid}
   for I:=1 to sgResults.RowCount-1 do
      begin
      sExpr := sgResults.Cells[1,I];
      if sExpr <> '' then
         begin
            try
            Parser.Expression:= sExpr;
            sgResults.Cells[3,I] := FloatToStrF(Parser.Value,ffFixed,4,2);
            except
               on E:Exception do
                  BSError('Could not evaluate expression, ' + sExpr);
            end;
         end
        else sgResults.Cells[3,I] := '';
      end;
   end;
end;


initialization
  {$I bsunit.lrs}

end.

