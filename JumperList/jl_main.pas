unit JL_main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics,
  Dialogs, StdCtrls, Buttons, LCLType, JL_DM;

type

  { TMainFrm }

  TMainFrm = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Label1: TLabel;
    FileNameLabel: TLabel;
    OpenDialog1: TOpenDialog;
    SpeedButton1: TSpeedButton;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private

  public
    procedure ShowBasesDialog(BaseName: string);
  end;

var
  MainFrm: TMainFrm;

implementation

{$R *.lfm}
uses JL_Bases;

{ TMainFrm }

procedure TMainFrm.SpeedButton1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    if DM.SQLite3Connection1.Connected  and
       (Application.MessageBox(PAnsiChar('Текущая БД будет закрыта.'+#13#10+'Вы уверены?'),
         'Запрос подтверждения',MB_ICONQUESTION+MB_YESNO)<>idYes)
    then Exit;
    //
    DM.SQLite3Connection1.Connected:=False ;
    DM.SQLite3Connection1.DatabaseName:=OpenDialog1.FileName;
    try
      DM.SQLite3Connection1.Connected:=True;
      DM.SQLTransaction1.StartTransaction;
    except
      Application.MessageBox(PAnsiChar('Не удалось подключиться к указанной БД!'+
          #13#10+'Возможно, файл БД занят другим приложением (concour).'),
          'Ошибка',MB_ICONERROR+MB_OK);
    end;
    FileNameLabel.Caption:=OpenDialog1.FileName;
  end;
end;

procedure TMainFrm.BitBtn1Click(Sender: TObject);
begin
  ShowBasesDialog('riders');
end;

procedure TMainFrm.BitBtn2Click(Sender: TObject);
begin
  ShowBasesDialog('horses');
end;

procedure TMainFrm.BitBtn3Click(Sender: TObject);
begin
  ShowBasesDialog('tournaments');
end;

procedure TMainFrm.ShowBasesDialog(BaseName: string);
begin
  with TBasesFrm.Create(self,BaseName) do
  begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
end;


end.

