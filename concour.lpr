program concour;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, datetimectrls, SysUtils, concour_main, concour_bases,
  concour_DM, concour_params, concour_stage, concour_rep, concour_rider,
  concour_horses, concour_export;

{$R *.res}

var
  x : String;

begin
  Application.Scaled:=True;
  RequireDerivedFormResource:=True;
  if ParamCount>0 then x := ParamStr(1)
  else x := ChangeFileExt(ParamStr(0),'.ini');
  if not FileExists(x) then
  begin
      WriteLn(StdErr,'Fatal error: connfiguration file not found (*.ini)!');
      Halt(2000);
  end;
  //
  Application.Initialize;
  cfg := TParams.Create;
  cfg.SetFile(x);  //ini должен быть (проверили уже), берём его
  cfg.LoadGeneralParams;
  //
  Application.CreateForm(TMainFrm, MainFrm);
  Application.CreateForm(TDM, DM);
  Application.Run;
end.

