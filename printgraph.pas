unit printgraph;

{$mode objfpc}{$H+}

interface

uses
  Classes, TAGraph, TAChartAxis, Printers, Graphics;

type

TPrintChart = class(TChart)
   public
   procedure Print(PrintRect:TRect);
   end;

implementation


procedure TPrintChart.Print(PrintRect:TRect);
var PrevBGPS,
   PrevLGPS:   TChartAxisPen;
   pBitMap:    TBitmap;
begin
{  PrevBGPS := BottomAxis.Grid;
  BottomAxis.Grid.Style := psSolid;
  PrevLGPS := LeftAxis.Grid;
  LeftAxis.Grid.Style := psSolid;
  PaintOnCanvas(Printer.Canvas,PrintRect);
  BottomAxis.Grid := PrevBGPS;
  LeftAxis.Grid := PrevLGPS;}
  pBitMap := TBitMap.Create;
  PBitMap.Width := Width;
  PBitMap.Height := Height;
  pBitmap := TBitMap(SaveToImage(TBitMap));
  Printer.Canvas.CopyRect(PrintRect,pBitmap.Canvas,REct(0,0,Width,Height));
end;

end.

