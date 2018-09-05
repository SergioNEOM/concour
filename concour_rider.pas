unit concour_rider;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons;

type

  { TRiderFrm }

  TRiderFrm = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    FirstnameEdit: TLabeledEdit;
    BirthdayEdit: TLabeledEdit;
    RegnumEdit: TLabeledEdit;
    CategoryEdit: TLabeledEdit;
    TrainerEdit: TLabeledEdit;
    RegionEdit: TLabeledEdit;
    LastnameEdit: TLabeledEdit;
    Panel1: TPanel;
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

