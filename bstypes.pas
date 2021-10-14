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

  TNorm = (none, norm_cax, norm_max);

  TBeamData = array of array of double;

  TProfilePoint = record
     X:        double;
     y:        double;
    end;

  TPArr = array of TProfilePoint;

  TValuePos = record
     Value     :double;
     Pos       :integer;
  end;

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
     MPos,                     {Position of max}
     LEdge,                    {Position of left edge 50%}
     REdge,                    {Position of right edge 50%}
     L10,                      {10% of CAX value left of CAX}
     R10,                      {10% of CAX value right of CAX}
     L20,                      {20% of CAX value left of CAX}
     R20,                      {20% of CAX value right of CAX}
     L80,                      {80% of CAX value left of CAX}
     R80,                      {80% of CAX value right of CAX}
     L90,                      {90% of CAX value left of CAX}
     R90,                      {90% of CAX value right of CAX}
     LInf,                     {Position of left inflection point}
     RInf,                     {Position of right inflection point}
     LSlope,                   {profile slope at left inflection point}
     RSlope,                   {profile slope at right inflection point}
     InfL20,                   {0.4 times dose at left inflection point}
     InfR20,                   {0.4 times dose at right inflection point}
     InfL50,                   {Position of 50% dose level left from Hill function}
     InfR50,                   {Position of 50% dose level right from Hill function}
     InfL80,                   {1.6 times dose at left inflection point}
     InfR80,                   {1.6 times dose at right inflection point}
     LD20,                     {Left dose at 20% of field width}
     RD20,                     {Right dose at 20% of field width}
     LD50,                     {Left dose at 50% of field width}
     RD50,                     {Right dose at 50% of field width}
     LD60,                     {Left dose at 60% of field width}
     RD60,                     {Right dose at 60% of field width}
     LD80,                     {Left dose at 80% of field width}
     RD80,                     {Right dose at 80% of field width}
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

