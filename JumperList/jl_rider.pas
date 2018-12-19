unit JL_Rider;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons;

type

  { TRiderFrm }

  TRiderFrm = class(TForm)
    BirthdayEdit: TLabeledEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    CategoryEdit: TLabeledEdit;
    FirstnameEdit: TLabeledEdit;
    LastnameEdit: TLabeledEdit;
    Panel1: TPanel;
    RegionEdit: TLabeledEdit;
    RegnumEdit: TLabeledEdit;
    TrainerEdit: TLabeledEdit;
  private

  public
    CurrRider : Integer;
    constructor Create(AOwner: TComponent; CurrentID: Integer);overload;
  end;

var
  RiderFrm: TRiderFrm;

implementation

{$R *.lfm}

constructor TRiderFrm.Create(AOwner: TComponent; CurrentID: Integer);overload;
begin
  Inherited Create(AOwner);
  CurrRider:= CurrentID;
end;


end.

