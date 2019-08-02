unit resunit;

{$mode objfpc}{$H+}

interface

uses
Classes, SysUtils, FileUtil, PReport, PrintersDlgs, LResources, Forms,
Controls, Graphics, Dialogs, Menus, ExtCtrls, ComCtrls;

type

{ TResForm }

TResForm = class(TForm)
    pcPage: TPageControl;
  PReport: TPReport;
  priYProf: TPRImage;
  priXProf: TPRImage;
  PrintDialog: TPrintDialog;
  prlPageNo1: TPRLabel;
  prlCopyR1: TPRLabel;
  prlTitle1: TPRLabel;
  prlXProf1: TPRLabel;
  prlXWidth: TPRLabel;
  prlXAngle: TPRLabel;
  prlYOffset: TPRLabel;
  prlYWidth: TPRLabel;
  prlYAngle: TPRLabel;
  prlXOffset: TPRLabel;
  prlDate1: TPRLabel;
  prlSource: TPRLabel;
  prlYProf1: TPRLabel;
  prlBeamP1: TPRLabel;
  prLPPage1: TPRLayoutPanel;
  PRPage1: TPRPage;
  PRRect1: TPRRect;
  rfImageList: TImageList;
  MainMenu1: TMainMenu;
  miExit: TMenuItem;
  miPrint: TMenuItem;
  miPDF: TMenuItem;
  rfSaveDialog: TSaveDialog;
  ScrollBox1: TScrollBox;
  TabSheet1: TTabSheet;
  ToolBar1: TToolBar;
  tbPDF: TToolButton;
  ToolButton1: TToolButton;
  tbPrint: TToolButton;
  ToolButton2: TToolButton;
  tbExit: TToolButton;
  procedure PaginatePDF(var prLPPage: TPRLayoutPanel);
  procedure FormCreate(Sender: TObject);
  procedure miExitClick(Sender: TObject);
  procedure tbPDFClick(Sender: TObject);
  procedure tbPrintClick(Sender: TObject);
  private
      { private declarations }
  public
      { public declarations }
  end;

var
   ResForm: TResForm;

implementation

uses bsunit, Printers;
{ TResForm }


procedure TResForm.miExitClick(Sender: TObject);
begin
Close;
end;

procedure TResForm.tbPDFClick(Sender: TObject);
var I          :integer;
    FName      :string;
    prPage     :TPRPage;

begin
FName := BSForm.OpenDialog.FileName;
FName := ChangeFileExt(FName,'.pdf');
rfSaveDialog.FileName := FName;
if rfSaveDialog.Execute then with PReport do
   begin
   Filename := rfSaveDialog.FileName;
   BeginDoc;
   for I:=0 to pcPage.PageCount-1 do
      begin;
      with pcPage.Pages[I].Controls[0] as TScrollBox do
         prPage := Controls[0] as TPRPage;
      Print(prPage);
      end;
   EndDoc;
   end;
end;


procedure TResForm.tbPrintClick(Sender: TObject);
var X1,X2,X3,
    Y1,Y2,Y3,
    XDI,
    YDI,
    I,J,K      :integer;
    XS,                        {x scale}
    YS         :single;        {y scale}
    Margin     :TRect;
    iRect      :TRect;
    prPage     :TPRPage;

procedure SetPrinterFont(PFont:TFont; AFontSize:single; AFontBold,
     AFontItalic,AFontUnderline:boolean);
begin
PFont.Size := round(AFontSize);
if AFontBold then PFont.Style := PFont.Style + [fsBold] else PFont.Style := PFont.Style - [fsBold];
if AFontItalic then PFont.Style := PFont.Style + [fsItalic] else PFont.Style := PFont.Style - [fsItalic];
if AFontUnderline then PFont.Style := PFont.Style + [fsUnderline] else PFont.Style := PFont.Style - [fsUnderline];
end;

begin
if PrintDialog.Execute then with Printer do
   begin
   BeginDoc;
   Canvas.Font.Name := 'Arial';
   XDI := Printer.XDPI;
   YDI := Printer.YDPI;
   XS := XDI/72.0;
   YS := YDI/72.0;

   {PDF already has margin so shift back by margin amount}
   Margin.Top := PaperSize.PaperRect.WorkRect.Top - PaperSize.PaperRect.PhysicalRect.Top;
   Margin.Left := PaperSize.PaperRect.WorkRect.Left - PaperSize.PaperRect.PhysicalRect.Left;

   for K:=0 to pcPage.PageCount-1 do
      with pcPage.Pages[K].Controls[0] as TScrollBox do
         begin
         if K > 0 then NewPage;
         prPage := Controls[0] as TPRPage;
         for I:=0 to PRPage.ControlCount - 1 do
            begin
            if (PRPage.Controls[I] is TPRLayoutPanel) then
               with (PRPage.Controls[I] as TPRLayoutPanel) do
                  begin
                  X1 := Round(Left*XS) - Margin.Left;
                  X2 := X1;
                  Y1 := Round(Top*YS) - Margin.Top;
                  Y2 := Y1;
                  Printer.Canvas.Font.Size := 12;
                  if Caption <> '' then
                     Printer.Canvas.TextOut(X1,Y1,Caption);
                  for J:=0 to ControlCount - 1 do
                     begin
                     if Controls[J] is TPRLabel then
                        with Controls[J] as TPRLabel do
                           begin
                           X2 := X1 + Round(Left*XS);
                           Y2 := Y1 + Round(Top*YS);
                           SetPrinterFont(Printer.Canvas.Font,FontSize,FontBold,
                              FontItalic,FontUnderline);
                           if Caption <> '' then
                              begin
                              case Alignment of
                                 taCenter: X2 := X2 + Round((Width*XS -
                                    Printer.Canvas.TextWidth(Caption))/2);
                                 taRightJustify: X2 := X2 + Round(Width*XS -
                                    Printer.Canvas.TextWidth(Caption));
                                 end; {of case}
                              Printer.Canvas.TextOut(X2,Y2,Caption);
                              end;
                           end;
                     if Controls[J] is TPRRect then
                        with Controls[J] as TPRRect do
                           begin
                           X2 := X1 + Round(Left*XS);
                           Y2 := Y1 + Round(Top*YS);
                           X3 := X1 + Round((Left + Width)*XS);
                           Y3 := Y1 + Round((Top + Height)*YS);
                           Printer.Canvas.Rectangle(X2,Y2,X3,Y3);
                           end;
                     if Controls[J] is TPRImage then
                        with Controls[J] as TPRImage do
                           begin
                           X2 := X1 + Round(Left*XS);
                           Y2 := Y1 + Round(Top*YS);
                           X3 := X1 + Round((Left + Width)*XS);
                           Y3 := Y1 + Round((Top + Height)*YS);
                           iRect := Rect(X2,Y2,X3,Y3);
                           Printer.Canvas.StretchDraw(iRect,Picture.Bitmap);
                           end;
                     end;
                  end;
            end;
      end;
   EndDoc;
   end;
end;


procedure TResForm.PaginatePDF(var prLPPage: TPRLayoutPanel);
var ScrollBox  :TScrollBox;
    TabSheet   :TTabSheet;
    PRPage     :TPRPage;
    prlTitle,
    prlBeamP,
    prlXProf,
    prlYProf,
    prlDate,
    prlCopyR,
    prlPageNo  :TPRLabel;
    prRect     :TPRRect;

begin
{create page}
TabSheet := TTabSheet.Create(pcPage);
TabSheet.PageControl := pcPage;
TabSheet.Name := 'Page' + IntToStr(pcPage.IndexOf(TabSheet) + 1);
ScrollBox := TScrollBox.Create(TabSheet);
with ScrollBox do
   begin
   Parent := TabSheet;
   Align := alClient;
   end;
PRPage := TPRPage.Create(ScrollBox);
with PRPage do
   begin
   Parent := ScrollBox;
   Top := 0;
   Left := 0;
   Height := prPage1.Height;
   Width := PRPage1.Width;
   end;
prLPPage := TPRLayoutPanel.Create(PRPage);
with prLPPage do
   begin
   Parent := PRPage;
   Top := prLPPage1.Top;
   Left := prLPPage1.Left;
   Height := prLPPage1.Height;
   Width := prLPPage1.Width;
   end;

{replicate title}
prRect := TPRRect.Create(prLPPage);
with prRect do
   begin
   Parent := prLPPage;
   Top := prRect1.Top;
   Left := prRect1.Left;
   Height := prRect1.Height;
   Width := prRect1.Width;
   FillColor := prRect1.FillColor;
   end;

prlTitle := TPRLabel.Create(prLPPage);
with prlTitle do
   begin
   Parent := prLPPage;
   Top := prlTitle1.Top;
   Left := prlTitle1.Left;
   Width := prlTitle1.Width;
   FontName := prlTitle1.FontName;
   FontSize := prlTitle1.FontSize;
   FontBold := prlTitle1.FontBold;
   FontItalic := prlTitle1.FontItalic;
   Alignment := prlTitle1.Alignment;
   Caption := prlTitle1.Caption;
   end;

prlBeamP := TPRLabel.Create(prLPPage);
with prlBeamP do
   begin
   Parent := prLPPage;
   Top := 70;
   Left := prlBeamP1.Left;
   Width := prlBeamP1.Width;
   FontName := prlBeamP1.FontName;
   FontSize := prlBeamP1.FontSize;
   FontBold := prlBeamP1.FontBold;
   FontItalic := prlBeamP1.FontItalic;
   Alignment := prlBeamP1.Alignment;
   Caption := prlBeamP1.Caption;
   end;

prlXProf := TPRLabel.Create(prLPPage);
with prlXProf do
   begin
   Parent := prLPPage;
   Top := 70;
   Left := prlXProf1.Left;
   Width := prlXProf1.Width;
   FontName := prlXProf1.FontName;
   FontSize := prlXProf1.FontSize;
   FontBold := prlXProf1.FontBold;
   FontItalic := prlXProf1.FontItalic;
   Alignment := prlXProf1.Alignment;
   Caption := prlXProf1.Caption;
   end;

prlYProf := TPRLabel.Create(prLPPage);
with prlYProf do
   begin
   Parent := prLPPage;
   Top := 70;
   Left := prlYProf1.Left;
   Width := prlYProf1.Width;
   FontName := prlYProf1.FontName;
   FontSize := prlYProf1.FontSize;
   FontBold := prlYProf1.FontBold;
   FontItalic := prlYProf1.FontItalic;
   Alignment := prlYProf1.Alignment;
   Caption := prlYProf1.Caption;
   end;

{print footer}
prlDate := TPRlabel.Create(prLPPage);
with prlDate do
   begin
   Parent := prLPPage;
   Top := prlDate1.Top;
   Left := prlDate1.Left;
   Width := prlDate1.Width;
   FontName := prlDate1.FontName;
   FontSize := prlDate1.FontSize;
   FontBold := prlDate1.FontBold;
   FontItalic := prlDate1.FontItalic;
   Alignment := prlDate1.Alignment;
   Caption := prlDate1.Caption;
   end;

prlCopyR := TPRlabel.Create(prLPPage);
with prlCopyR do
   begin
   Parent := prLPPage;
   Top := prlCopyR1.Top;
   Left := prlCopyR1.Left;
   Width := prlCopyR1.Width;
   FontName := prlCopyR1.FontName;
   FontSize := prlCopyR1.FontSize;
   FontBold := prlCopyR1.FontBold;
   FontItalic := prlCopyR1.FontItalic;
   Alignment := prlCopyR1.Alignment;
   Caption := prlCopyR1.Caption;
   end;

prlPageNo := TPRlabel.Create(prLPPage);
with prlPageNo do
   begin
   Parent := prLPPage;
   Top := prlPageNo1.Top;
   Left := prlPageNo1.Left;
   Width := prlPageNo1.Width;
   FontName := prlPageNo1.FontName;
   FontSize := prlPageNo1.FontSize;
   FontBold := prlPageNo1.FontBold;
   FontItalic := prlPageNo1.FontItalic;
   Alignment := prlPageNo1.Alignment;
   Caption := 'Page ' + IntToStr(pcPage.IndexOf(TabSheet) + 1);
   end;
end;


procedure TResForm.FormCreate(Sender: TObject);
var I,
    LineNo,
    LineWidth,                 {height of line in points}
    LineOffset :integer;       {vertical offset to print on layout panel}
    B          :TBitMap;
    R          :TRect;
    prLPPage   :TPRLayoutPanel;
    prlResult  :TPRLabel;

begin
prlSource.Caption := BSForm.OpenDialog.FileName;
prlDate1.Caption := FormatDateTime('dddddd',Now);

{X Profile}
B := TBitMap.Create;
R := priXProf.ReadBounds;
B.Width := R.Right - R.Left;
B.Height := R.Bottom - R.Top;
B := BSForm.cXProfile.SaveToImage(TBitMap) as TBitMap;
priXProf.Picture.Bitmap := B;
prlXOffset.Caption := 'Offset: ' + IntToStr(BSForm.seXOffset.Value);
prlXWidth.Caption := 'Width: ' + IntToStr(BSForm.seXWidth.Value);
prlXAngle.Caption := 'Angle: ' + IntToStr(BSForm.seXAngle.Value);


{Y Profile}
B := TBitMap.Create;
R := priYProf.ReadBounds;
B.Width := R.Right - R.Left;
B.Height := R.Bottom - R.Top;
B := BSForm.cYProfile.SaveToImage(TBitMap) as TBitMap;
priYProf.Picture.Bitmap := B;
prlYOffset.Caption := 'Offset: ' + IntToStr(BSForm.seYOffset.Value);
prlYWidth.Caption := 'Width: ' + IntToStr(BSForm.seYWidth.Value);
prlYAngle.Caption := 'Angle: ' + IntToStr(BSForm.seYAngle.Value);

{Results}
prLPPage := prLPPage1;
LineOffset := 372;
LineNo := 1;
LineWidth := 18;
for I:= 1 to BSForm.sgResults.RowCount-1 do
   begin
   if (I = 20) or ((I-20) mod 35 = 0) then
      begin
      PaginatePDF(prLPPage);
      LineNo := 1;
      LineOffset := 90;
      end;

   {write label}
   prlResult := TPRLabel.Create(prLPPage);
   prlResult.Parent := prLPPage;
   prlResult.Left := 5;
   prlResult.Top := LineNo*LineWidth + LineOffset;
   prlResult.Caption := BSForm.sgResults.Cells[0,I];
   prlResult.Visible := true;

   {write X profile results}
   prlResult := TPRLabel.Create(prLPPage);
   prlResult.Parent := prLPPage;
   prlResult.Left := 161;
   prlResult.Width := 100;
   prlResult.Alignment := taRightJustify;
   prlResult.Top := LineNo*LineWidth + LineOffset;
   prlResult.Caption := BSForm.sgResults.Cells[2,I];
   prlResult.Visible := true;

   {write Y profile results}
   prlResult := TPRLabel.Create(prLPPage);
   prlResult.Parent := prLPPage;
   prlResult.Left := 431;
   prlResult.Width := 100;
   prlResult.Alignment := taRightJustify;
   prlResult.Top := LineNo*LineWidth + LineOffset;
   prlResult.Caption := BSForm.sgResults.Cells[3,I];
   prlResult.Visible := true;

   Inc(Lineno);
   end;

end;



initialization
   {$I resunit.lrs}

end.

