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
  private

  public

  end;

var
  AboutForm: TAboutForm;

implementation

initialization
  {$I aboutunit.lrs}

end.

