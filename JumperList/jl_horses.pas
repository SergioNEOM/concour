unit JL_Horses;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons;

type

  { THorsesFrm }

  THorsesFrm = class(TForm)
    BirthdateEdit: TLabeledEdit;
    BirthplaceEdit: TLabeledEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BreedEdit: TLabeledEdit;
    ColorEdit: TLabeledEdit;
    NicknameEdit: TLabeledEdit;
    OwnerEdit: TLabeledEdit;
    Panel1: TPanel;
    ParentEdit: TLabeledEdit;
    RegisterEdit: TLabeledEdit;
    SexEdit: TLabeledEdit;
  private

  public
    CurrHorse : Integer;
    constructor Create(AOwner: TComponent; CurrentID: Integer);overload;
  end;

var
  HorsesFrm: THorsesFrm;

implementation

{$R *.lfm}

constructor THorsesFrm.Create(AOwner: TComponent; CurrentID: Integer);overload;
begin
  Inherited Create(AOwner);
  CurrHorse:= CurrentID;
end;

end.

