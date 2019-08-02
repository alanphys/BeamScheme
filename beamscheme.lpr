program beamscheme;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms
  { you can add units after this }, bsunit, TAChartLazarusPkg, tachartprint,
  Printer4Lazarus, dicom, define_types, dtrackbar, pack_powerpdf, lnetvisual,
  resunit, aboutunit, Parser10;

{$R *.res}

begin
   Application.Title:='BeamScheme';
  Application.Initialize;
  Application.CreateForm(TBSForm, BSForm);
  Application.Run;
end.

