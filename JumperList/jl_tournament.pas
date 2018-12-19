unit JL_Tournament;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, Buttons, StdCtrls;

type

  { TTournamentFrm }

  TTournamentFrm = class(TForm)
    AssistantEdit: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Panel1: TPanel;
    RefereeEdit: TEdit;
    TourDate: TDateTimePicker;
    TourDate2: TDateTimePicker;
    TourNameEdit: TEdit;
    TourPlaceEdit: TEdit;
  private

  public
    CurrTour : Integer;
    constructor Create(AOwner: TComponent; CurrentID: Integer);overload;
  end;

var
  TournamentFrm: TTournamentFrm;

implementation

{$R *.lfm}

constructor TTournamentFrm.Create(AOwner: TComponent; CurrentID: Integer);overload;
begin
  Inherited Create(AOwner);
  CurrTour:= CurrentID;
  TourDate.Date:= Now;
  TourDate2.Date:= Now;
  TourNameEdit.Text:='';
  TourPlaceEdit.Text:= '';
  RefereeEdit.Text:= '';
  AssistantEdit.Text:= '';
end;

end.

