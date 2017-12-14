unit resunit;

{$mode objfpc}{$H+}

interface

uses
   Classes, SysUtils, FileUtil, PReport, PrintersDlgs, LResources, Forms,
			Controls, Graphics, Dialogs, Menus, ExtCtrls, ComCtrls;

type

			{ TResForm }

   TResForm = class(TForm)
						PReport: TPReport;
						priYProf: TPRImage;
						priXProf: TPRImage;
						PrintDialog: TPrintDialog;
						PRLabel1: TPRLabel;
						PRLabel10: TPRLabel;
						PRLabel11: TPRLabel;
						PRLabel12: TPRLabel;
						PRLabel13: TPRLabel;
						PRLabel14: TPRLabel;
						PRLabel15: TPRLabel;
						PRLabel16: TPRLabel;
						PRLabel17: TPRLabel;
						PRLabel18: TPRLabel;
						PRLabel19: TPRLabel;
						PRLabel2: TPRLabel;
						PRLabel20: TPRLabel;
						prlXWidth: TPRLabel;
						prlXAngle: TPRLabel;
						prlYOffset: TPRLabel;
						prlYWidth: TPRLabel;
						prlYAngle: TPRLabel;
						prlXOffset: TPRLabel;
						prlDate: TPRLabel;
						prlSource: TPRLabel;
						prlYArea: TPRLabel;
						prlYCentre: TPRLabel;
						prlYEdge: TPRLabel;
						prlYFlatP: TPRLabel;
						prlYFlatR: TPRLabel;
						prlYMAX: TPRLabel;
						prlYPen50: TPRLabel;
						prlYPen80: TPRLabel;
						prlYPen90: TPRLabel;
						prlXSize: TPRLabel;
						prlXCentre: TPRLabel;
						prlXEdge: TPRLabel;
						PRLabel3: TPRLabel;
						PRLabel4: TPRLabel;
						PRLabel5: TPRLabel;
						PRLabel6: TPRLabel;
						PRLabel7: TPRLabel;
						PRLabel8: TPRLabel;
						PRLabel9: TPRLabel;
						PRLayoutPanel1: TPRLayoutPanel;
						prlXPen90: TPRLabel;
						prlXPen80: TPRLabel;
						prlXPen50: TPRLabel;
						prlXArea: TPRLabel;
						prlXFlatR: TPRLabel;
						prlXMAX: TPRLabel;
						prlYSize: TPRLabel;
						prlYSymP: TPRLabel;
						prlXSymR: TPRLabel;
						prlXSymP: TPRLabel;
						prlXFlatP: TPRLabel;
						prlYSymR: TPRLabel;
						PRPage: TPRPage;
						PRRect1: TPRRect;
						rfImageList: TImageList;
						MainMenu1: TMainMenu;
						miExit: TMenuItem;
						miPrint: TMenuItem;
						miPDF: TMenuItem;
						rfSaveDialog: TSaveDialog;
						ScrollBox1: TScrollBox;
						ToolBar1: TToolBar;
						tbPDF: TToolButton;
						ToolButton1: TToolButton;
						tbPrint: TToolButton;
						ToolButton2: TToolButton;
						tbExit: TToolButton;
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
var FName      :string;

begin
FName := BSForm.OpenDialog.FileName;
FName := ChangeFileExt(FName,'.pdf');
rfSaveDialog.FileName := FName;
if rfSaveDialog.Execute then with PReport do
   begin
   Filename := rfSaveDialog.FileName;
   BeginDoc;
   Print(PRPage);
   EndDoc;
   end;
end;


procedure TResForm.tbPrintClick(Sender: TObject);
var X1,X2,X3,
    Y1,Y2,Y3,
    XDI,
    YDI,
    I,J        :integer;
    XS,                        {x scale}
    YS         :single;        {y scale}
    iRect      :TRect;

begin
if PrintDialog.Execute then with Printer do
   begin
   BeginDoc;
   Canvas.Font.Name := 'Arial';
   XDI := Printer.XDPI;
   YDI := Printer.YDPI;
   XS := XDI/72.0;
   YS := YDI/72.0;

   for I:=0 to PRPage.ControlCount - 1 do
      begin
      if (PRPage.Controls[I] is TPRLayoutPanel) then
         with (PRPage.Controls[I] as TPRLayoutPanel) do
            begin
            X1 := Round(Left*XS);
            X2 := X1;
            Y1 := Round(Top*YS);
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
                     Printer.Canvas.Font.Size := Round(FontSize);
                     if Caption <> '' then
                        begin
                        if Alignment = taCenter then
                           X2 := X2 + Round((Width*XS -
                           Printer.Canvas.TextWidth(Caption))/2);
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

   EndDoc;
   end;
end;


procedure TResForm.FormCreate(Sender: TObject);
var B          :TBitMap;
    R          :TRect;

begin
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

{X Results}
prlXEdge.Caption := BSForm.lvResults.Items[1].SubItems[0] + ' cm';
prlXCentre.Caption := BSForm.lvResults.Items[2].SubItems[0] + ' cm';
prlXSize.Caption := BSForm.lvResults.Items[3].SubItems[0] + ' cm';
prlXPen90.Caption := BSForm.lvResults.Items[5].SubItems[0] + ' cm';
prlXPen80.Caption := BSForm.lvResults.Items[6].SubItems[0] + ' cm';
prlXPen50.Caption := BSForm.lvResults.Items[7].SubItems[0] + ' cm';
prlXArea.Caption := BSForm.lvResults.Items[9].SubItems[0];
prlXSymR.Caption := BSForm.lvResults.Items[10].SubItems[0];
prlXSymP.Caption := BSForm.lvResults.Items[11].SubItems[0];
prlXFlatP.Caption := BSForm.lvResults.Items[13].SubItems[0];
prlXFlatR.Caption := BSForm.lvResults.Items[14].SubItems[0];
prlXMAX.Caption := BSForm.lvResults.Items[15].SubItems[0];

{Y Results}
prlYEdge.Caption := BSForm.lvResults.Items[1].SubItems[1] + ' cm';
prlYCentre.Caption := BSForm.lvResults.Items[2].SubItems[1] + ' cm';
prlYSize.Caption := BSForm.lvResults.Items[3].SubItems[1] + ' cm';
prlYPen90.Caption := BSForm.lvResults.Items[5].SubItems[1] + ' cm';
prlYPen80.Caption := BSForm.lvResults.Items[6].SubItems[1] + ' cm';
prlYPen50.Caption := BSForm.lvResults.Items[7].SubItems[1] + ' cm';
prlYArea.Caption := BSForm.lvResults.Items[9].SubItems[1];
prlYSymR.Caption := BSForm.lvResults.Items[10].SubItems[1];
prlYSymP.Caption := BSForm.lvResults.Items[11].SubItems[1];
prlYFlatP.Caption := BSForm.lvResults.Items[13].SubItems[1];
prlYFlatR.Caption := BSForm.lvResults.Items[14].SubItems[1];
prlYMAX.Caption := BSForm.lvResults.Items[15].SubItems[1];

prlSource.Caption := BSForm.OpenDialog.FileName;
prlDate.Caption := FormatDateTime('dddddd',Now);
end;



initialization
   {$I resunit.lrs}

end.

