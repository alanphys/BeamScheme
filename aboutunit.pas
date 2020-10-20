unit aboutunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ComCtrls, StdCtrls;

type

  { TAboutForm }

  TAboutForm = class(TForm)
    mAbout: TMemo;
    mLicence: TMemo;
    mCredits: TMemo;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;


var
  AboutForm: TAboutForm;

implementation

{ TAboutForm }

procedure TAboutForm.FormCreate(Sender: TObject);
begin
try
   {$IF Defined(LINUX)}
   mAbout.Font.Name := 'Monospace';
   {$ELSEIF Defined(WINDOWS)}
   mAbout.Font.Name := 'Courier New';
   {$ELSE}
   mAbout.Font.Name := 'Courier';
   {$ENDIF}
   mAbout.Lines.LoadFromFile('readme.txt');
   except
   on E:Exception do
      mAbout.Lines.Text := 'Sorry readme not available';
   end;

try
   {$IF Defined(LINUX)}
   mLicence.Font.Name := 'Monospace';
   {$ELSEIF Defined(WINDOWS)}
   mLicence.Font.Name := 'Courier New';
   {$ELSE}
   mLicence.Font.Name := 'Courier';
   {$ENDIF}
   mLicence.Lines.LoadFromFile('licence.txt');
   except
   on E:Exception do
      mLicence.Lines.Text := 'Sorry licence not available';
   end;

try
   {$IF Defined(LINUX)}
   mCredits.Font.Name := 'Monospace';
   {$ELSEIF Defined(WINDOWS)}
   mCredits.Font.Name := 'Courier New';
   {$ELSE}
   mCredits.Font.Name := 'Courier';
   {$ENDIF}
   mCredits.Lines.LoadFromFile('credits.txt');
   except
   on E:Exception do
      mCredits.Lines.Text := 'Sorry credits not available';
   end;
end;

initialization
  {$I aboutunit.lrs}

end.

