unit mathsfuncs;
{various high level maths functions}

{$mode objfpc}{$H+}

interface

uses
   Classes, SysUtils, bstypes;

function LReg(X1,X2,Y1,Y2,X:double):double;
function Limit(A,B,C,Phi0,R0,MidX,MidY:double):TPoint;
function LimitL(Angle,Phi,TanA,Offset,MidX,MidY:double; LowerX,LowerY,UpperX,UpperY:integer):TRect;
procedure CalcParams(PArr:TPArr; var BeamParams:TBeamParams; var ErrMsg:string);

implementation

uses math, utypes, unlfit, uhillfit, uerrors;

const
   MaxIter = 1000;             {maximum number of iterations for optimisation}
   Tol = 1.0E-4;               {required precision}

function LReg(X1,X2,Y1,Y2,X:double):double;
var m,c:       double;
begin
if X1 <> X2 then m := (Y2 - Y1)/(X2 - X1) else m := 1E6;
c := (Y1 + Y2 - m*(X1 + X2))/2;
LReg := X*m + c;
end;


function ILReg(X1,X2,Y1,Y2,Y:double):double;
var m,c:       double;
begin
if X1 <> X2 then m := (Y2 - Y1)/(X2 - X1) else m := 1E6;
c := (Y1 + Y2 - m*(X1 + X2))/2;
if m <> 0 then ILReg := (Y - c)/m else ILREG := 1E6;
end;


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
      if TL.Y >= UpperY then
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
      if BR.Y >= UpperY then
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
      if TL.X >= UpperX then
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
      if BR.X >= UpperX then
         begin {must intersect right axis}
         BR := Limit(1,0,MidX,Phi,Offset,MidX,MidY);
         end;
   end;
Result.TopLeft := TL;
Result.BottomRight := BR;
end;


function HillFunc(X:float; B:TVector):double;
{calculates the value of the Hill function at x}
begin
if X > 0 then
   Result := B[0] + (B[1] - B[0])/(1.0 + Power(B[2]/X, B[3]))
  else
   Result := B[0];
end;


function InvHillFunc(Y:float; B:TVector):double;
{calculates the inverse Hill function at y}
begin
if (Y > min(B[0],B[1])) and (Y < max(B[0],B[1])) and (B[3] <> 0) then
   Result := B[2]*power((Y - B[0])/(B[1] - Y),1/B[3])
  else
   Result := 0;
end;


procedure CalcInfPoints(PArr:TPArr; var InfP,InfS,Inf20,Inf50,Inf80:double; var ErrMsg:string);
{Perform non-linear regression on Hill function to get inflection point}
var I,
    N          :integer;       {number of points}
    B,                         {parameters: B[0] high limit, B[1] low limit, B[2] initial inf point, B[3] slope}
    X,                         {X values}
    Y          :TVector;       {Y values}
    V          :TMatrix;       {variance-covariance matrix}
    IPDose,                    {dose value at inflection point}
    XMax,                      {max of X values}
    YMax,                      {max of Y values}
    Xsign      :double;        {sign of x values}

begin
N := length(PArr);
DimVector(X,N);
DimVector(Y,N);
DimVector(B,4);
DimMatrix(V,4,4);
InfP := 0;
InfS := 0;
Inf20 := 0;
Inf50 := 0;
Inf80 := 0;

{transfer values to X,Y. LMath derived from Fortran lower array index starts at 1}
YMax := PArr[0].Y;
XMax := abs(PArr[0].X);
for I:=0 to N-1 do
   begin
   X[I+1] := abs(PArr[I].X);                {can't have negative axis for Hill func}
   Y[I+1] := PArr[i].Y;
   if X[I+1] > XMax then XMax := X[I+1];
   if Y[I+1] > YMax then YMax := Y[I+1];
   end;

{Ymax and K are assumed to be positive but n can be negative}
SetParamBounds(0, 0, Ymax*1.5);           {high and low level must be in Y range}
SetParamBounds(1, 0, Ymax*1.5);
SetParamBounds(2, 0, Xmax*1.5);           {inflection point can't be outside X range}
SetParamBounds(3, -100, 100);             {slope should not exceed 100}

{Set algorithm}
SetOptAlgo(NL_SIMP);

HillFit(X, Y, 1, N, True, MaxIter, Tol, B, V);

if MathErr = MatOk then
   begin
   Xsign := sign(PArr[0].X);
   InfP := B[2]*power((B[3]-1)/(B[3]+1),1/B[3]);
   IPDose := HillFunc(InfP,B);
   InfP := InfP*XSign;
   InfS := -XSign*B[3];
   Inf50 := InvHillFunc(abs(B[1] - B[0])*0.5,B)*Xsign;
   Inf20 := InvHillFunc(IPDose*0.4,B)*XSign;
   Inf80 := InvHillFunc(IPDose*1.6,B)*XSign;
   end
  else
    ErrMsg := ErrMsg + 'Unable to fit curve! ' + MathErrMessage + '. ';
end;


procedure CalcParams(PArr:TPArr;var BeamParams:TBeamParams; var ErrMsg:string);
var I,
    N,
    NegP,                      {Negative counter}
    PosP,                      {Positive counter}
    NegP80,                    {negative increment 80% field of view}
    NNegP80,                   {new negative increment 80% field of view}
    PosP80,                    {positive increment 80% field of view}
    NPosP80,                   {new positive increment 80% field of view}
    StartNeg,                  {Start pos for negative counter}
    StartPos,                  {Start pos for positive counter}
    LEPos,                     {Left edge index}
    REPos,                     {Right edge index}
    LPArr,                     {Array length}
    HLPArr     :integer;       {Half array length}
    HMax,
    M90,
    M80,
    M20,
    M10,
    ASum,
    ASSqr,
    RSym,
    Diff,
    Res        :double;
    PArrL,                     {array containing penumbra left}
    PArrR      :TPArr;         {array containing penumbra right}

begin
ErrMsg := '';
with BeamParams do
   begin
   {initialise parameters}
   LEdge := 0;
   REdge := 0;
   LInf := 0;
   RInf := 0;
   L10 := 0;
   R10 := 0;
   L20 := 0;
   R20 := 0;
   L90 := 0;
   R90 := 0;
   L80 := 0;
   R80 := 0;
   LD20 := 0;
   RD20 := 0;
   LD50 := 0;
   RD50 := 0;
   LD60 := 0;
   RD60 := 0;
   LD80 := 0;
   RD80 := 0;
   ALeft := 0;
   ARight := 0;
   Diff := 0;
   RSym := 0;
   ADiff := 0;
   RDiff := 0;
   Res := 0;

   {get field size}
   CMax := 0;
   CMin := 0;
   LPArr := length(PArr) - 1;
   HLParr := (length(PArr) div 2);
   if LPArr > 0 then
      begin

      {initialise vars}
      if not odd(LPArr) then
         begin
         CMax := PArr[HLPArr].Y;
         MPos := PArr[HLPArr].X;
         end
        else
         begin
         CMax := (PArr[HLPArr].Y + PArr[HLPArr - 1].Y)/2;
         MPos := (PArr[HLPArr].X + PArr[HLPArr - 1].X)/2;
         end;
      CMin := CMax;
      {for I:=0 to LPArr do
         if PArr[I].Y < CMin
            then CMin := PArr[I].Y;}
      RCAX := CMax;

      {Leave it to the user to normalise values. Most arrays are already normalised}
      {HMax := (CMax-CMin)*0.5 + CMin;
      M90 := (CMax-CMin)*0.9 + CMin;
      M80 := (CMax-CMin)*0.8 + CMin;
      M20 := (CMax-CMin)*0.2 + CMin;
      M10 := (CMax-CMin)*0.1 + CMin;}

      HMax := CMax*0.5;
      M90 := CMax*0.9;
      M80 := CMax*0.8;
      M20 := CMax*0.2;
      M10 := CMax*0.1;
      I := 0;
      if not odd(LPArr) then
         begin                        {symmetric around central detector}
         StartNeg := LPArr div 2 - 1;
         StartPos := LPArr div 2 + 1;
         ASum := PArr[LPArr div 2].Y;
         ASSqr := sqr(ASum);
         N := 1;
         end
        else
         begin                        {central detectors straddle axis}
         StartNeg := LPArr div 2;
         StartPos := LPArr div 2 + 1;
         ASum := 0;
         ASSqr := 0;
         N := 0;
         end;
      NegP := StartNeg;
      PosP := StartPos;
      NNegP80 := StartNeg;
      NPosP80 := StartPos;
      NegP80 := 0;
      PosP80 := 0;
      LEPos := StartNeg;
      REPos := StartPos;
      if LPArr > 2 then Res := PArr[HLPArr + 1].X - PArr[HLPArr].X;
      while (I < HLPArr) and not((PArr[NegP].Y = 0) and (PArr[NegP].X = 0)
         and (PArr[PosP].Y = 0) and (PArr[PosP].X = 0)) do
         begin
         if LEdge = 0 then
            begin
            if PArr[NegP].Y <= HMax then
               begin
               LEdge := ILReg(PArr[NegP].X,PArr[NegP+1].X,PArr[NegP].Y,PArr[NegP+1].Y,HMax);
               LEPos := NegP;
               ALeft := ALeft + HMax*abs(LEdge-PArr[NegP+1].X);
	       end
              else
               begin
               ALeft := ALeft + PArr[NegP].Y*Res;
               if NegP80 <> NNegP80 then
                  begin
                  NegP80 := NNegP80;
                  {use regression for symmetry as points may not be symmetric}
                  {ALeft := ALeft + LReg(PArr[NegP80].X,PArr[NegP80+1].X,PArr[NegP80].Y,
                     PArr[NegP80+1].Y,trunc(-I*Res*0.8)); }
                  if PArr[NegP80].Y > CMax then
                     begin
                     CMax := PArr[NegP80].Y;
                     MPos := PArr[NegP80].X
                     end;
                  if PArr[NegP80].Y < CMin then CMin := PArr[NegP80].Y;
                  ASum := ASum + PArr[NegP80].Y;
                  ASSqr := ASSqr + sqr(PArr[NegP80].Y);
                  Inc(N);
                 end;
               end;
            end;
         if REdge = 0 then
            begin
            if PArr[PosP].Y <= HMax then
               begin
               REdge := ILReg(PArr[PosP].X,PArr[PosP-1].X,PArr[PosP].Y,PArr[PosP-1].Y,HMax);
               REPos := PosP;
               ARight := ARight + HMax*abs(REdge - PArr[PosP-1].X);
	       end
              else
               begin
               ARight := ARight + PArr[PosP].Y*Res;
               if PosP80 <> NPosP80 then
                  begin
                  PosP80 := NPosP80;
                  {ARight := ARight + LReg(PArr[PosP80].X,PArr[PosP80-1].X,PArr[PosP80].Y,
                     PArr[PosP80-1].Y,trunc(I*Res*0.8)); }
                  if PArr[PosP80].Y > CMax then
                     begin
                     CMax := PArr[PosP80].Y;
                     MPos := PArr[PosP80].X;
                     end;
                  if PArr[PosP80].Y < CMin then CMin := PArr[PosP80].Y;
                  if PArr[PosP80].Y > 0 then RSym:= PArr[NegP80].Y/PArr[PosP80].Y
                     else RSym := 1;
                  if (RSym < 1.0) and (RSym <> 0) then RSym := 1/RSym;
                  if RDiff < RSym then RDiff := RSym;
                  Diff := abs(PArr[NegP80].Y - PArr[PosP80].Y);
                  if ADiff < Diff then ADiff := Diff;
                  ASum := ASum + PArr[PosP80].Y;
                  ASSqr := ASSqr + sqr(PArr[PosP80].Y);
                  Inc(N);
                  end;
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
         NNegP80 := StartNeg - Trunc(I*0.8);
         NPosP80 := StartPos + Trunc(I*0.8);
         end;
      NP := N;
      PSum := ASum;
      PSSqr := ASSqr;

      {get left inflection point}
      if abs(LEdge) < 3.5 then
         PArrL := copy(PArr,0,HLPArr)       {copy half profile}
        else
         PArrL := copy(PArr,0,NegP80);      {copy from tail to 80% of field size}
      CalcInfPoints(PArrL,LInf,LSlope,InfL20,InfL50,InfL80,ErrMsg);

      {get right inflection point}
      if abs(REdge) < 3.5 then
         PArrR := copy(PArr,HLPArr,LPArr-HLPArr){copy half profile}
        else
         PArrR := copy(PArr,PosP80,LPArr-PosP80);{copy from 80% of field size to tail}
      CalcInfPoints(PArrR,RInf,RSlope,InfR20,InfR50,InfR80,ErrMsg);

      {get left dose points}
      NegP := StartNeg - Trunc((StartNeg - LEPos)*0.20);
      LD20 := LReg(PArr[NegP+1].X,PArr[NegP].X,PArr[NegP+1].Y,PArr[NegP].Y,LInf*0.20);
      NegP := StartNeg - Trunc((StartNeg - LEPos)*0.50);
      LD50 := LReg(PArr[NegP+1].X,PArr[NegP].X,PArr[NegP+1].Y,PArr[NegP].Y,LInf*0.50);
      NegP := StartNeg - Trunc((StartNeg - LEPos)*0.60);
      LD60 := LReg(PArr[NegP+1].X,PArr[NegP].X,PArr[NegP+1].Y,PArr[NegP].Y,LInf*0.60);
      NegP := StartNeg - Trunc((StartNeg - LEPos)*0.80);
      LD80 := LReg(PArr[NegP+1].X,PArr[NegP].X,PArr[NegP+1].Y,PArr[NegP].Y,LInf*0.80);

      {get right dose points}
      PosP := StartPos + Trunc((REPos - StartPos)*0.20);
      RD20 := LReg(PArr[PosP-1].X,PArr[PosP].X,PArr[PosP-1].Y,PArr[PosP].Y,RInf*0.20);
      PosP := StartPos + Trunc((REPos - StartPos)*0.50);
      RD50 := LReg(PArr[PosP-1].X,PArr[PosP].X,PArr[PosP-1].Y,PArr[PosP].Y,RInf*0.50);
      PosP := StartPos + Trunc((REPos - StartPos)*0.60);
      RD60 := LReg(PArr[PosP-1].X,PArr[PosP].X,PArr[PosP-1].Y,PArr[PosP].Y,RInf*0.60);
      PosP := StartPos + Trunc((REPos - StartPos)*0.80);
      RD80 := LReg(PArr[PosP-1].X,PArr[PosP].X,PArr[PosP-1].Y,PArr[PosP].Y,RInf*0.80);

      end;
   end;
end;


end.

