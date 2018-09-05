unit concour_horses;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons;

type

  { THorsesFrm }

  THorsesFrm = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    NicknameEdit: TLabeledEdit;
    BirthdateEdit: TLabeledEdit;
    ColorEdit: TLabeledEdit;
    SexEdit: TLabeledEdit;
    BreedEdit: TLabeledEdit;
    ParentEdit: TLabeledEdit;
    BirthplaceEdit: TLabeledEdit;
    RegisterEdit: TLabeledEdit;
    OwnerEdit: TLabeledEdit;
    Panel1: TPanel;
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

