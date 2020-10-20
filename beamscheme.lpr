program beamscheme;
{.DEFINE DEBUG}

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms
  {$IFDEF DEBUG}
  , SysUtils              //delete SysUtils if not using heaptrc
  {$ENDIF}
  { you can add units after this }, bsunit, TAChartLazarusPkg, tachartprint,
  dicom, define_types, dtrackbar, lnetvisual,
  aboutunit;

{$R *.res}

begin
  {Set up -gh output for the Leakview package}
  {$IFDEF DEBUG}
  if FileExists('heap.trc') then
     DeleteFile('heap.trc');
  SetHeapTraceOutput('heap.trc');
  {$ENDIF}
  Application.Title:='BeamScheme';
  Application.Initialize;
  Application.CreateForm(TBSForm, BSForm);
  Application.Run;
end.

