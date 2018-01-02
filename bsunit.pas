unit bsunit;
{Revision History
 Version 0.2 released 1/8/2011
 22/8/2011 Fix field centre error,
           Fix Y resolution error for MapCheck 2
 28/09/2011 removed MultiDoc
           added invert
           added normalise
           added windowing
           fixed profile display
           fixed symmetry calculation
           cleaned up printout
 15/2/2012 Fix CAX normalisation error,
 2/4/2013  Add read for XiO Dose plane file
 20/6/2014 Removed redundant DICOM read code causing memory bug
 24/6/2014 Fixed XiO read offset by 1
           Fixed MapCheck read if dose cal file not present
           Included Min/Max as part of beam class
           Fixed panel maximise to form area
 21/5/2015 Combine open dialog and DICOM dialog
 20/7/2015 Add messaging system
 Version 0.3 released 20/7/2015
 26/8/2016 Add normalise to max
 28/6/2016 Support PTW 729 mcc
 29/9/2016 Fix PTW 729 memory error
 21/10/2016 Add PowerPDF for output
 24/10/2016 Fix Profile event misfire
 15/8/2017 Fix image integer conversion
 13/10/2017 Support IBA Matrix and StartTrack opg
 16/10/2017 Fix Diff divide by zero error
            Fix profile offset limit error
 7/12/2017 Fix even number of detectors offset
 15/12/2017 Support Brainlab iPlan Dose plane format
            Add text file format identification}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Menus,
  ExtCtrls, Buttons, TAGraph, TASeries, TATools, StdCtrls, Graphtype,
  IntfGraphics, Spin, ComCtrls, Tracker2,
  FPImage;

const pi = 3.14159265359;

type

  TBeamData = array of array of double;
  
  TProfilePoint = record
     X:        double;
     y:        double;
    end;
    
  TPArr = array of TProfilePoint;
  
  TBeam = class
     Width,           {detector size in X direction}
     Height,          {detector size in Y direction}
     XRes,
     YRes,
     Min,
     Max:      double;
     Cols,
     Rows:     integer;
     Data:     TBeamData;
     constructor create;
    end;
     
  TBeamParams = record
     FSize,
     FCentre,
     ASym,
     PSym,
     Flat,
     RFlat,
     RCAX,
     LEdge,
     REdge,
     L10,
     R10,
     L20,
     R20,
     L80,
     R80,
     L90,
     R90,
     PL80,
     PR80,
     PL90,
     PR90,
     PL50,
     PR50:      double;
    end;

  { TBSForm }

  TBSForm = class(TForm)
    ChartToolsetY: TChartToolset;
    ChartToolsetX: TChartToolset;
    ChartToolsetXDataPointHintTool: TDataPointHintTool;
    ChartToolsetYDataPointHintTool: TDataPointHintTool;
     cXProfile: TChart;
     cXprof: TLabel;
     miAbout: TMenuItem;
     miHelp: TMenuItem;
     miExportY: TMenuItem;
     miExportX: TMenuItem;
     miExport: TMenuItem;
     SaveDialog: TSaveDialog;
					sbMaxNorm: TSpeedButton;
					sbCentre: TSpeedButton;
					StatusBar: TStatusBar;
     StatusMessages: TStringList;
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
     lvResults: TListView;
     MainMenu1: TMainMenu;
     miRestore: TMenuItem;
     miResults: TMenuItem;
     miYProfile: TMenuItem;
     miXProfile: TMenuItem;
     miImage: TMenuItem;
     Panel1: TPanel;
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
     sbExit: TSpeedButton;
     sbXMax: TSpeedButton;
     sbYMax: TSpeedButton;
     sbInvert: TSpeedButton;
     sbIMin: TSpeedButton;
     sbOpen: TSpeedButton;
     sbPrint: TSpeedButton;
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
     sbNorm: TSpeedButton;
     Window: TMenuItem;
     miPrint: TMenuItem;
     miExit: TMenuItem;
     miOpen: TMenuItem;
     miFile: TMenuItem;
     OpenDialog: TOpenDialog;
     procedure BSError(sWarning:string);
     procedure BSMessage(sMess:string);
     procedure ClearStatus;
     procedure ChartToolsetXDataPointHintToolHint(ATool: TDataPointHintTool;
        const APoint: TPoint; var AHint: String);
     procedure ChartToolsetYDataPointHintToolHint(ATool: TDataPointHintTool;
        const APoint: TPoint; var AHint: String);
     procedure DTrackBarChange(Sender: TObject);
     procedure DTrackBarClick(Sender: TObject);
     procedure FormCreate(Sender: TObject);
     function DICOMOpen(sFileName:string):boolean;
     procedure FormResize(Sender: TObject);
     procedure miAboutClick(Sender: TObject);
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
     procedure miExitClick(Sender: TObject);
     procedure miExportXClick(Sender: TObject);
     procedure miExportYClick(Sender: TObject);
     procedure miOpenClick(Sender: TObject);
     procedure miPDFPrint(Sender: TObject);
     procedure miRestoreClick(Sender: TObject);
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
  end; 

var
    BSForm:      TBSForm;
    Beam:        TBeam;
    XPArr,
    YPArr:       TPArr;
    XBParams,
    YBParams:    TBeamParams;
    Safe:        boolean;

procedure DisplayBeam;
procedure ShowProfile(ThebitMap:Tbitmap; Wdth:double;
   TopLeft,TopRight,BottomRight,BottomLeft:TPoint);
procedure DrawProfile(TheBitmap:TBitmap;Beam:TBeam ;Angle,Offset,Width:double;
   Profile:TSerie; var PArr:TPArr; var TopLeft,TopRight,BottomLeft,BottomRight:TPoint;
   var PrevW:double);
procedure CalcParams(PArr:TPArr; var BeamParams:TBeamParams);


implementation

uses DICOM, define_types, types, StrUtils, resunit, aboutunit;

const AllChars = [#0..#255] - DigitChars - ['.'];

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

constructor TBeam.Create;
begin
  Width :=0 ;
  Height := 0;
  XRes := 0;
  YRes := 0;
  Cols := 0;
  Rows := 0;
  Data := nil;
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
           end
     else
      for I:=0 to Beam.Rows - 1 do
        for J:=2 to Beam.Cols - 1 do
           begin
           IntFImage.Colors[J-2,I] := GreyVal;
           end;
     BSForm.iBeam.Picture.Bitmap.LoadFromIntfImage(IntFImage);
   end;
end;


procedure ShowProfile(ThebitMap:Tbitmap; Wdth:double;
   TopLeft,TopRight,BottomRight,BottomLeft:TPoint);
begin
{Draw profile on array}
TheBitmap.Canvas.Pen.Color := clRed xor clWhite;
TheBitmap.Canvas.Pen.Mode := pmXor;
if Wdth > 1 then
   TheBitmap.Canvas.Polygon([TopLeft,TopRight,BottomRight,BottomLeft])
  else
   TheBitmap.Canvas.Line(TopLeft,BottomRight);
end;


procedure DrawProfile(TheBitmap:TBitmap; Beam:TBeam; Angle,Offset,Width:double;
   Profile:TSerie; var PArr:TPArr; var TopLeft,TopRight,BottomLeft,BottomRight:TPoint;
   var PrevW:double);
{Draw a profile on the bitmap at any angle}
var I,J,K,L,
    WI,WJ,
    LimX,
    LimY,
    OLP,OLN:   longint;
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
    Z:         double;
    Start,
    Stop:      TPoint;
    DLine:     TRect;
    OverLimit: Boolean;

function Limit(A,B,C,Phi0,R0,MidX,MidY:double):TPoint;
{Calculates intersection of profile in polar coords with array limits in cartesian coords}
var X,Y        :integer;
begin
X := Round((C*sin(Phi0) - B*R0)/(A*sin(Phi0) - B*cos(Phi0)) + MidX + 0.1);
Y := Round((C*cos(Phi0) - A*R0)/(B*cos(Phi0) - A*sin(Phi0)) + MidY + 0.1);
Result.X := X;
Result.Y := Y;
end;


function LimitL(Angle,Phi,TanA,Offset,MidX,MidY:double; LowerX,LowerY,UpperX,UpperY:integer):TRect;
{Determines the intersect of the line in Polar Coordinates with the bounding rectangle}
var TL,                        {top left of line}
    BR:        TPoint;         {bottom right of line}

begin
if (Angle > -TanA) and (Angle <= TanA) then {Profile is X profile}
   begin
   {Start with left axis}
   TL := Limit(1,0,-MidX,Phi,Offset,MidX,MidY);
   if TL.Y < LowerY then
      begin {must intersect top axis}
      TL := Limit(0,1,-MidY,Phi,Offset,MidX,MidY);
      end
     else
      if TL.Y > UpperY then
         begin {must intersect bottom axis}
         TL := Limit(0,1,MidY,Phi,Offset,MidX,MidY);
         end;

   {Now do right axis}
   BR := Limit(1,0,MidX,Phi,Offset,MidX,MidY);
   if BR.Y < LowerY then
      begin {must intersect top axis}
      BR := Limit(0,1,-MidY,Phi,Offset,MidX,MidY);
      end
     else
      if BR.Y > UpperY then
         begin {must intersect bottom axis}
         BR := Limit(0,1,MidY,Phi,Offset,MidX,MidY);
         end;
   end
  else
   begin {profile is y profile}
   {Start with top axis}
   TL := Limit(0,1,-MidY,Phi,Offset,MidX,MidY);
   if TL.X < LowerX then
      begin {must intersect left axis}
      TL := Limit(1,0,-MidX,Phi,Offset,MidX,MidY);
      end
     else
      if TL.X > UpperX then
         begin {must intersect right axis}
         TL := Limit(1,0,MidX,Phi,Offset,MidX,MidY);
         end;

   {Now do bottom axis}
   BR := Limit(0,1,MidY,Phi,Offset,MidX,MidY);
   if BR.X < LowerX then
      begin {must intersect left axis}
      BR := Limit(1,0,-MidX,Phi,Offset,MidX,MidY);
      end
     else
      if BR.X > UpperX then
         begin {must intersect right axis}
         BR := Limit(1,0,MidX,Phi,Offset,MidX,MidY);
         end;
   end;
Result.TopLeft := TL;
Result.BottomRight := BR;
end;


begin
{clear previous profile if it exists}
Profile.Clear;
if (TopLeft.x or TopRight.x or BottomLeft.x or BottomRight.x or
   TopLeft.y or TopRight.y or BottomLeft.y or BottomRight.y <> 0) then
   begin
   TheBitmap.Canvas.Pen.Color := clRed xor ClWhite;
   TheBitmap.Canvas.Pen.Mode := pmXor;
   if PrevW > 0 then
      TheBitmap.Canvas.Polygon([TopLeft,TopRight,BottomRight,BottomLeft])
     else
      TheBitmap.Canvas.Line(TopLeft,BottomRight);
   end;

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
TheBitmap.Canvas.Pen.Color := clRed xor clWhite;
TheBitmap.Canvas.Pen.Mode := pmXor;
if PrevW > 0 then
   TheBitmap.Canvas.Polygon([TopLeft,TopRight,BottomRight,BottomLeft])
  else
   TheBitmap.Canvas.Line(TopLeft,BottomRight);

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

{Add first point}
OverLimit := false;
PArr[K].X := sqrt(sqr((X - Start.X)*Beam.XRes) + sqr((Y - Start.Y)*Beam.YRes)) - MidP;
Z := Beam.Data[I,J+2];
if Z < BSForm.DTrackBar.PositionL then Z := BSForm.DTrackBar.PositionL;
if Z > BSForm.DTrackBar.PositionU then Z := BSForm.DTrackBar.PositionU;
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
         if Z < BSForm.DTrackBar.PositionL then Z := BSForm.DTrackBar.PositionL;
         if Z > BSForm.DTrackBar.PositionU then Z := BSForm.DTrackBar.PositionU;
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
         if Z < BSForm.DTrackBar.PositionL then Z := BSForm.DTrackBar.PositionL;
         if Z > BSForm.DTrackBar.PositionU then Z := BSForm.DTrackBar.PositionU;
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
   if Z < BSForm.DTrackBar.PositionL then Z := BSForm.DTrackBar.PositionL;
   if Z > BSForm.DTrackBar.PositionU then Z := BSForm.DTrackBar.PositionU;
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
            if Z < BSForm.DTrackBar.PositionL then Z := BSForm.DTrackBar.PositionL;
            if Z > BSForm.DTrackBar.PositionU then Z := BSForm.DTrackBar.PositionU;
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
            if Z < BSForm.DTrackBar.PositionL then Z := BSForm.DTrackBar.PositionL;
            if Z > BSForm.DTrackBar.PositionU then Z := BSForm.DTrackBar.PositionU;
            PArr[K].Y := PArr[K].Y + Z;
            inc(OLP);
   									end
           else
            OverLimit := true;
         end;
      if OverLimit then PArr[K].Y := PArr[K].Y*Width/(OLN+1+OLP);
      end;
   until (I = Stop.Y) and (J = Stop.X);


{write array to profile}
for K := 0 to length(PArr) - 1 do with PArr[K] do
   if (X <> 0) or (Y <> 0) then Profile.AddXY(PArr[K].X,PArr[K].y,'',clRed);
end;


function LReg(X1,X2,Y1,Y2,X:double):double;
var m,c:       double;
begin
if X1 <> X2 then m := (Y2 - Y1)/(X2 - X1) else m := 1E6;
c := (Y1 + Y2 - m*(X1 + X2))/2;
LReg := X*m + c;
end;


procedure CalcParams(PArr:TPArr;var BeamParams:TBeamParams);
var I,
    NegP,
    PosP,
    NegP80,                    {negative increment 80% field of view}
    NNegP80,                   {new negative increment 80% field of view}
    PosP80,                    {positive increment 80% field of view}
    NPosP80,                   {new positive increment 80% field of view}
    LPArr,
    HLPArr:     integer;
    CMax,
    HMax,
    CMin,
    M90,
    M80,
    M20,
    M10,
    ALeft,
    ARight,
    Diff,
    Res,
    fHLPArr:   double;

function ILReg(X1,X2,Y1,Y2,Y:double):double;
var m,c:       double;
begin
if X1 <> X2 then m := (Y2 - Y1)/(X2 - X1) else m := 1E6;
c := (Y1 + Y2 - m*(X1 + X2))/2;
if m <> 0 then ILReg := (Y - c)/m else ILREG := 1E6;
end;

begin
with BeamParams do
   begin
   {initialise parameters}
   LEdge := 0;
   REdge := 0;
   L10 := 0;
   R10 := 0;
   L20 := 0;
   R20 := 0;
   L90 := 0;
   R90 := 0;
   L80 := 0;
   R80 := 0;
   ALeft := 0;
   ARight := 0;
   Diff := 0;
   PSym := 0;
   Res := 0;

   {get field size}
   CMax := 0;
   CMin := 0;
   LPArr := length(PArr) - 1;
   HLParr := (length(PArr) div 2);
   if LPArr > 0 then
      begin

      {initialise vars}
      CMax := PArr[HLPArr].Y;
      CMin := CMax;
      for I:=0 to LPArr do
         if PArr[I].Y < CMin
            then CMin := PArr[I].Y;
      RCAX := CMax;
      HMax := (CMax-CMin)*0.5 + CMin;
      M90 := (CMax-CMin)*0.9 + CMin;
      M80 := (CMax-CMin)*0.8 + CMin;
      M20 := (CMax-CMin)*0.2 + CMin;
      M10 := (CMax-CMin)*0.1 + CMin;
      I := 0;
      NegP := trunc(LPArr/2);
      PosP := round(LPArr/2);
      NNegP80 := NegP;
      NPosP80 := PosP;
      NegP80 := 0;
      PosP80 := 0;
      CMin := CMax;
      if LPArr > 2 then Res := PArr[HLPArr + 1].X - PArr[HLPArr].X;
      while (I <= HLPArr) and not((PArr[NegP].Y = 0) and (PArr[NegP].X = 0)
         and (PArr[PosP].Y = 0) and (PArr[PosP].X = 0)) do
         begin
         if LEdge = 0 then
            begin
            if PArr[NegP].Y < HMax then
               begin
               LEdge := ILReg(PArr[NegP].X,PArr[NegP+1].X,PArr[NegP].Y,PArr[NegP+1].Y,HMax);
               ALeft := ALeft + HMax*abs(LEdge-PArr[NegP].X);
	       end
              else
               if NegP80 <> NNegP80 then
                  begin
                  NegP80 := NNegP80;
                  {use regression for symmetry as points may not be symmetric}
                  {ALeft := ALeft + LReg(PArr[NegP80].X,PArr[NegP80+1].X,PArr[NegP80].Y,
                     PArr[NegP80+1].Y,trunc(-I*Res*0.8)); }
                  ALeft := ALeft + PArr[NegP].Y*Res;
                  if PArr[NegP80].Y > CMax then CMax := PArr[NegP80].Y;
                  if PArr[NegP80].Y < CMin then CMin := PArr[NegP80].Y;
                 end;
            end;
         if REdge = 0 then
            begin
            if PArr[PosP].Y < HMax then
               begin
               REdge := ILReg(PArr[PosP].X,PArr[PosP-1].X,PArr[PosP].Y,PArr[PosP-1].Y,HMax);
               ARight := ARight + HMax*abs(REdge - PArr[PosP].X);
	       end
              else
               if PosP80 <> NPosP80 then
                  begin
                  PosP80 := NPosP80;
                  {ARight := ARight + LReg(PArr[PosP80].X,PArr[PosP80-1].X,PArr[PosP80].Y,
                     PArr[PosP80-1].Y,trunc(I*Res*0.8)); }
                  ARight := ARight + PArr[PosP].Y*Res;
                  if PArr[PosP80].Y > CMax then CMax := PArr[PosP80].Y;
                  if PArr[PosP80].Y < CMin then CMin := PArr[PosP80].Y;
                  if Parr[PosP80].y > 0 then Diff:= PArr[NegP80].Y/PArr[PosP80].Y
                     else Diff := 1;
                  if (Diff < 1.0) and (Diff <> 0) then Diff := 1/(Diff);
                  if PSym < Diff then PSym := Diff;
                  end;
            end;
         if L90 = 0 then
            if PArr[NegP].Y < M90 then
               L90 := ILReg(PArr[NegP].X,PArr[NegP+1].X,PArr[NegP].Y,PArr[NegP+1].Y,M90);
         if R90 = 0 then
            if PArr[PosP].Y < M90 then
               R90 := ILReg(PArr[PosP].X,PArr[PosP-1].X,PArr[PosP].Y,PArr[PosP-1].Y,M90);
         if L80 = 0 then
            if PArr[NegP].Y < M80 then
               L80 := ILReg(PArr[NegP].X,PArr[NegP+1].X,PArr[NegP].Y,PArr[NegP+1].Y,M80);
         if R80 = 0 then
            if PArr[PosP].Y < M80 then
               R80 := ILReg(PArr[PosP].X,PArr[PosP-1].X,PArr[PosP].Y,PArr[PosP-1].Y,M80);
         if L20 = 0 then
            if PArr[NegP].Y < M20 then
               L20 := ILReg(PArr[NegP].X,PArr[NegP+1].X,PArr[NegP].Y,PArr[NegP+1].Y,M20);
         if R20 = 0 then
            if PArr[PosP].Y < M20 then
               R20 := ILReg(PArr[PosP].X,PArr[PosP-1].X,PArr[PosP].Y,PArr[PosP-1].Y,M20);
         if L10 = 0 then
            if PArr[NegP].Y < M10 then
               L10 := ILReg(PArr[NegP].X,PArr[NegP+1].X,PArr[NegP].Y,PArr[NegP+1].Y,M10);
         if R10 = 0 then
            if PArr[PosP].Y < M10 then
               R10 := ILReg(PArr[PosP].X,PArr[PosP-1].X,PArr[PosP].Y,PArr[PosP-1].Y,M10);
         Inc(I);
         Dec(NegP);
         Inc(PosP);
         NNegP80 := trunc(LPArr/2) - Trunc(I*0.8);
         NPosP80 := round(LPArr/2) + Trunc(I*0.8);
         end;
      Fsize := REdge - LEdge;
      FCentre := (REdge + LEdge)/2;
      PL90 := abs(L90 - L10);
      PR90 := abs(R90 - R10);
      PL80 := abs(L80 - L20);
      PR80 := abs(R80 - R20);
      PL50 := abs(L90 - LEdge);
      PR50 := abs(R90 - REdge);
      if (Aleft + ARight) > 0 then
         ASym := abs(ALeft - ARight)/(ALeft + ARight)*100
        else
         ASym := 0; ;
      if (CMax + CMin) > 0 then
         Flat := (CMax - CMin)/(CMax + CMin)*100 else Flat := 0;
      if CMin > 0 then RFlat := CMax/CMin*100 else RFlat := 0;
      if RCAX > 0 then RCAX := CMax*100/RCAX;
      end;
   end;
end;


{ TBSForm }

procedure TBSForm.BSError(sWarning:string);
begin
StatusBar.SimpleText := sWarning;
StatusBar.Color := clRed;
StatusMessages.Add(StatusBar.SimpleText);
StatusBar.Hint := StatusMessages.Text;
end;



procedure TBSForm.BSMessage(sMess:string);
begin
StatusBar.SimpleText := sMess;
StatusBar.Color := clYellow;
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
    sExePath:  string;

begin
sExePath := ExtractFilePath(Application.ExeName);
SetCurrentDir(sExePath);
SaveDialog.InitialDir := sExePath;
if XPArr <> nil then
   if SaveDialog.Execute then
      begin
      AssignFile(Outfile,SaveDialog.FileName);
      Rewrite(Outfile);
      for I := 0 to length(XPArr) - 1 do
        writeln(Outfile,XPArr[I].X:5:2,',',XPArr[I].Y:1:1);
      CloseFile(Outfile);
      end;
end;


procedure TBSForm.miExportYClick(Sender: TObject);
var Outfile:   textfile;
    I:         integer;
    sExePath:  string;

begin
sExePath := ExtractFilePath(Application.ExeName);
SetCurrentDir(sExePath);
SaveDialog.InitialDir := sExePath;
if YPArr <> nil then
   if SaveDialog.Execute then
      begin
      AssignFile(Outfile,SaveDialog.FileName);
      Rewrite(Outfile);
      for I := 0 to length(YPArr) - 1 do
        writeln(Outfile,YPArr[I].X:5:2,',',YPArr[I].Y:1:1);
      CloseFile(Outfile);
      end;
end;


procedure TBSForm.FormCreate(Sender: TObject);
var I          :integer;

begin
Beam := TBeam.Create;
StatusMessages := TStringList.Create;

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
lvResults.GridLines := false;
for I:=0 to lvResults.Items.Count - 1 do
   begin
   lvResults.Items[I].SubItems.Add('');
   lvResults.Items[I].SubItems.Add('');
   end;
Safe := true;
end;

procedure TBSForm.DTrackBarChange(Sender: TObject);
begin
if Safe then
   begin
	  DTrackBar.Invalidate;
	  DisplayBeam;
	  ShowProfile(iBeam.Picture.Bitmap,seYWidth.Value,YPTL,YPTR,YPBR,YPBL);
	  ShowProfile(iBeam.Picture.Bitmap,seXWidth.Value,XPTL,XPTR,XPBR,XPBL);
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
var Dummy,
    sExePath:  string;
    DataOK:    boolean;

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
{sExePath := ExtractFilePath(Application.ExeName);
SetCurrentDir(sExePath);}
DataOK := false;

with OpenDialog do
   begin
   DefaultExt := '.dcm';
   {$IFDEF win32}
   Filter := 'DICOM Image|*.dcm|MapCheck Text Files|*.txt|PTW|*.mcc|IBA|*.opg|Windows bitmap|*.bmp|Tiff bitmap|*.tif|JPEG image|*.jpg|HIS image|*.his|All Files|*.*';
   {$ELSE}
   Filter := 'DICOM Image|*.dcm|MapCheck Text Files|*.txt|PTW|*.mcc|IBA|*.opg|Windows bitmap|*.bmp|Tiff bitmap|*.tif|JPEG image|*.jpg|HIS image|*.his|All Files|*';
   {$ENDIF}
   Title := 'Open file';
   InitialDir := sExePath;
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
   if (not DataOK) and (Dummy = '.TIF') then
      DataOK := BMPOpen(OpenDialog.Filename);
   if (not DataOK) and (Dummy = '.JPG') then
      DataOK := BMPOpen(OpenDialog.Filename);
   if not DataOK then {assume file is text}
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
      DTrackBar.Max := round(Beam.Max);
      DTrackBar.Min := round(Beam.Min);
      DTrackBar.PositionU:= round(Beam.Max);
      DTrackBar.PositionL := round(Beam.Min);
      DTrackBar.LargeChange := round((Beam.Max - Beam.Min)/20);
      DTrackBar.SmallChange := round((Beam.Max - Beam.Min)/100);
      DTrackBar.TickInterval := round((Beam.Max - Beam.Min)/20);

      {display beam}
      Safe := true;
      DisplayBeam;
      seXAngleChange(Self);
      seYAngleChange(Self);
      cImage.Caption := OpenDialog.FileName;
      ClearStatus
      end
     else
      begin
      BSError('Unrecognised file');
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
if LeftStr(Dummy,8) = '0001108e' then
   Result := XiOOpen(sFileName);
if LeftStr(Dummy,8) = 'BrainLAB' then
   Result := BrainLabOpen(sFileName);
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
         Width := StrToFloat(Dummy)*2;
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
         for I := 0 to Beam.Rows - 1 do
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
      Width := abs(StrToFloat(Trim(sPart))*0.2);
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
            Value := StrToFloat(Dummy);
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
            Beam.Data[Beam.Rows - I,0] := StrToFloat(Dummy);
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
    lBuff32:   DWordP;

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

procedure TBSForm.FormResize(Sender: TObject);
begin
miRestoreClick(Sender);
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
      Beam.XRes := StrToFloat(RightStr(Dummy,3));
      Beam.YRes := Beam.XRes;
      end;
   if LeftStr(Dummy,19) = 'OutputWidLenQAplane' then
      begin
      Beam.Width := StrToFloat(ExtractDelimited(2,Dummy,[',']));
      Beam.Height := StrToFloat(ExtractDelimited(3,Dummy,[',']));
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
         Value := StrToFloat(ExtractDelimited(J,Dummy,[',']))*cGy;
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
      LDet:= StrToFloat(ExtractDelimited(2,sColHead,[#9]));
      sPart := sColHead;
      I := 3;
      while sPart <> '' do
         begin
         sPart := ExtractDelimited(I,sColHead,[#9]);
         if sPart <> '' then RDet := StrToFloat(sPart);
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
var I,J:       integer;
    Value,
    Res:       double;
    SrcIntfImage:TLazIntfImage;
    lRawImage:  TRawImage;
    Curcolor:   TFPColor;

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


procedure TBSForm.miPDFPrint(Sender: TObject);
begin
ResForm := TResForm.Create(Self);
ResForm.ShowModal;
ResForm.Free;
end;


procedure TBSForm.miAboutClick(Sender: TObject);
begin
  AboutForm := TAboutForm.Create(Self);
  AboutForm.ShowModal;
  AboutForm.Free;
end;


procedure TBSForm.miRestoreClick(Sender: TObject);
begin
sbIMinClick(Sender);
sbXMinClick(Sender);
sbYMinClick(Sender);
sbRMinClick(Sender);
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
sbIMin.Enabled := false;
sbIMin.Visible := false;
lMin.Top := pMaxMin.Height - 20;
DTrackbar.Height := pMaxMin.Height - 40;
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
var Max        :double;
    I,J        :integer;
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
Max := Beam.Data[Beam.Rows div 2,(Beam.cols - 2) div 2 + 2];
if Max <> Beam.Min then
   for I:=0 to Beam.Rows - 1 do
     for J:=2 to Beam.Cols - 1 do
        begin
        Z := Beam.Data[I,J];
        Z :=(Z - Beam.Min)*100/(Max - Beam.Min);
        Beam.Data[I,J] := Z;
        end;
Beam.Max := Beam.Max*100/Max;
Beam.Min := 0;
DTrackBar.Max := 100;
DTrackBar.Min := 0;
DTrackBar.PositionU:= 100;
DTrackBar.PositionL := 0;
DTrackBar.LargeChange := 5;
DTrackBar.SmallChange := 1;
DTrackBar.TickInterval := 5;
DisplayBeam;
seXAngleChange(Self);
seYAngleChange(Self);
end;


procedure TBSForm.sbMaxNormClick(Sender: TObject);
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
        Z :=(Z - Beam.Min)*100/(Beam.Max - Beam.Min);
        Beam.Data[I,J] := Z;
        end;
Beam.Max := 100;
Beam.Min := 0;
DTrackBar.Max := 100;
DTrackBar.Min := 0;
DTrackBar.PositionU:= 100;
DTrackBar.PositionL := 0;
DTrackBar.LargeChange := 5;
DTrackBar.SmallChange := 1;
DTrackBar.TickInterval := 5;
DisplayBeam;
seXAngleChange(Self);
seYAngleChange(Self);
end;


procedure TBSForm.sbCentreClick(Sender: TObject);
{resamples the data using bi-linear interpolation}
var I,J,
    SI,SJ,                     {x and y shift}
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
SX := XBParams.FCentre/Beam.XRes;
SY := YBParams.FCentre/Beam.YRes;
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
end;


procedure TBSForm.seYAngleChange(Sender: TObject);
var Angle,
    Offset,
    Wdth:     double;
    MBitmap:   TBitmap;

begin
if Safe then
   begin
   Angle := seYAngle.Value;
	  Offset := -seYOffset.Value;
	  Wdth := seYWidth.Value;
	  if (iBeam.Picture.Bitmap <> nil) and (length(Beam.Data) <> 0) then
	     begin
	     MBitmap := iBeam.Picture.Bitmap;
	     DrawProfile(MBitmap,Beam,Angle,Offset,Wdth,
	        YProfile,YPArr, YPTL,YPTR,YPBL,YPBR,YPW);
	     iBeam.Picture.Bitmap := MBitmap;
	     CalcParams(YPArr,YBParams);
	     ShowYResults(YBParams);
	     end;
			end;
end;


procedure TBSForm.seXAngleChange(Sender: TObject);
var Angle,
    Offset,
    Wdth:     double;
    MBitmap:   TBitmap;

begin
if Safe then
  begin
	  Angle := seXAngle.Value;
	  Offset := -seXOffset.Value;
	  Wdth := seXWidth.Value;
	  if (iBeam.Picture.Bitmap <> nil) and (length(Beam.Data) <> 0) then
	     begin
	     MBitmap := iBeam.Picture.Bitmap;
	     DrawProfile(MBitmap,Beam,Angle,Offset,Wdth,
	        XProfile,XPArr,XPTL,XPTR,XPBL,XPBR,XPW);
	     iBeam.Picture.Bitmap := MBitmap;
	     CalcParams(XPArr,XBParams);
	     ShowXResults(XBParams);
	     end;
		end;
end;

procedure TBSForm.ShowXResults(BeamParams:TBeamParams);
var I          :integer;

begin
I := 1;
with BeamParams do
   begin
   lvResults.Items[I].SubItems[0] := '(' + FloatToStrF(LEdge,ffFixed,4,2) +',' +
      FloatToStrF(REdge,ffFixed,4,2) + ')';
   Inc(I);
   lvResults.Items[I].SubItems[0] := FloatToStrF(FCentre,ffFixed,4,2);
   Inc(I);
   lvResults.Items[I].SubItems[0] := FloatToStrF(FSize,ffFixed,4,2);
   Inc(I);
   Inc(I);
   lvResults.Items[I].SubItems[0] := '(' + FloatToStrF(PL90,ffFixed,4,2) +',' +
      FloatToStrF(PR90,ffFixed,4,2) + ')';
   Inc(I);
   lvResults.Items[I].SubItems[0] := '(' + FloatToStrF(PL80,ffFixed,4,2) +',' +
      FloatToStrF(PR80,ffFixed,4,2) + ')';
   Inc(I);
   lvResults.Items[I].SubItems[0] := '(' + FloatToStrF(PL50,ffFixed,4,2) +',' +
      FloatToStrF(PR50,ffFixed,4,2) + ')';
   Inc(I);
   Inc(I);
   lvResults.Items[I].SubItems[0] := FloatToStrf(ASym,ffFixed,3,2) + ' %';
   Inc(I);
   lvResults.Items[I].SubItems[0] := FloatToStrf(PSym,ffFixed,4,3);
   Inc(I);
   lvResults.Items[I].SubItems[0] := FloatToStrf((PSym - 1)*100,ffFixed,3,2) + ' %';
   Inc(I);
   Inc(I);
   lvResults.Items[I].SubItems[0] := FloatToStrf(Flat,ffFixed,3,2) + ' %';
   Inc(I);
   lvResults.Items[I].SubItems[0] := FloatToStrf(RFlat,ffFixed,3,2) + ' %';
   Inc(I);
   lvResults.Items[I].SubItems[0] := FloatToStrf(RCAX,ffFixed,3,2) + ' %';
   end;
end;


procedure TBSForm.ShowYResults(BeamParams:TBeamParams);
var I          :integer;

begin
I := 1;
with BeamParams do
   begin
   lvResults.Items[I].SubItems[1] := '(' + FloatToStrF(LEdge,ffFixed,4,2) +',' +
      FloatToStrF(REdge,ffFixed,4,2) + ')';
   Inc(I);
   lvResults.Items[I].SubItems[1] := FloatToStrF(FCentre,ffFixed,4,2);
   Inc(I);
   lvResults.Items[I].SubItems[1] := FloatToStrF(FSize,ffFixed,4,2);
   Inc(I);
   Inc(I);
   lvResults.Items[I].SubItems[1] := '(' + FloatToStrF(PL90,ffFixed,4,2) +',' +
      FloatToStrF(PR90,ffFixed,4,2) + ')';
   Inc(I);
   lvResults.Items[I].SubItems[1] := '(' + FloatToStrF(PL80,ffFixed,4,2) +',' +
      FloatToStrF(PR80,ffFixed,4,2) + ')';
   Inc(I);
   lvResults.Items[I].SubItems[1] := '(' + FloatToStrF(PL50,ffFixed,4,2) +',' +
      FloatToStrF(PR50,ffFixed,4,2) + ')';
   Inc(I);
   Inc(I);
   lvResults.Items[I].SubItems[1] := FloatToStrf(ASym,ffFixed,3,2) + ' %';
   Inc(I);
   lvResults.Items[I].SubItems[1] := FloatToStrf(PSym,ffFixed,4,3);
   Inc(I);
   lvResults.Items[I].SubItems[1] := FloatToStrf((PSym - 1)*100,ffFixed,3,2) + ' %';
   Inc(I);
   Inc(I);
   lvResults.Items[I].SubItems[1] := FloatToStrf(Flat,ffFixed,3,2) + ' %';
   Inc(I);
   lvResults.Items[I].SubItems[1] := FloatToStrf(RFlat,ffFixed,3,2) + ' %';
   Inc(I);
   lvResults.Items[I].SubItems[1] := FloatToStrf(RCAX,ffFixed,3,2) + ' %';
   end;
end;

procedure TBSForm.sbIMaxClick(Sender: TObject);
begin
pBeam.Height := ClientHeight - 20;
pBeam.Width := ClientWidth;
pBeam.BringToFront;
sbIMax.Enabled := False;
sbIMax.Visible := False;
sbIMin.Left := pBeam.Width - 30;
sbIMin.Enabled := True;
sbIMin.Visible := True;
lMin.Top := pMaxMin.Height - 20;
DTrackbar.Height := pMaxMin.Height - 40;
end;


initialization
  {$I bsunit.lrs}

end.
