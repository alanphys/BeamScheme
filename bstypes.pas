unit bstypes;

{$mode objfpc}{$H+}

interface

uses
   Classes, Graphics;

const pi = 3.14159265359;
      FaintRed:    TColor = $7979ff;
      FaintYellow: TColor = $cffcff;
      FaintGreen:  TColor = $e4ffd3;

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
     ALeft,                    {area under profile left of CAX}
     Aright,                   {area under profile right of CAX}
     ADiff,                    {Absolute difference of points equidistant from CAX}
     RDiff,                    {Relative ratio of points equidistant from CAX}
     CMax,                     {Maximum value}
     CMin,                     {Minimum value}
     RCAX,                     {Central axis value}
     LEdge,                    {Position of left edge 50%}
     REdge,                    {Position of right edge 50%}
     LInf,                     {Position of left inflection point}
     RInf,                     {Position of right inflection point}
     L10,                      {10% of CAX value left of CAX}
     R10,                      {10% of CAX value right of CAX}
     L20,                      {20% of CAX value left of CAX}
     R20,                      {20% of CAX value right of CAX}
     L80,                      {80% of CAX value left of CAX}
     R80,                      {80% of CAX value right of CAX}
     L90,                      {90% of CAX value left of CAX}
     R90,                      {90% of CAX value right of CAX}
     PSum,                     {Sum of profile values}
     PSSqr,                    {Squared sum of profile values}
     NP        :double;        {Number of points in 80 of profile}
    end;


implementation

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


end.

