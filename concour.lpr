program concour;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, datetimectrls, SysUtils, concour_main, concour_bases, concour_DM,
  concour_params, concour_stage, concour_rep, concour_rider,
  concour_horses, concour_export;

{$R *.res}

begin
  Application.Scaled:=True;
  RequireDerivedFormResource:=True;
  Application.Initialize;
  cfg := TParams.Create;
  if Application.ParamCount>0 then
  begin
    cfg.SetFile(Application.Params[1]);
    cfg.LoadGeneralParams;
  end
  else
    cfg.GetDefaults;      //concour_params.InitDefaults;
    Application.CreateForm(TMainFrm, MainFrm);
    Application.CreateForm(TDM, DM);
{  if not DM.SQLConn.Connected then
  begin
    Application.MessageBox(PChar('Не удалось открыть базу ('+concour_params.DataBaseFileName+')'),'Ошибка',0);
    ExitCode := 100;
    Exit;
  end;
}
//  concour_params.XLSTempFileName:=ExtractFilePath(Application.ExeName)+'templates'+PathDelim+'temp.xlsx';
  Application.Run;
end.

