unit concour_tournament;

interface

uses
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls, DateTimePicker;

type

  { TTournamentFrm }

  TTournamentFrm = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label6: TLabel;
    TourDate: TDateTimePicker;
    TourDate2: TDateTimePicker;
    TourNameEdit: TEdit;
    TourPlaceEdit: TEdit;
    RefereeEdit: TEdit;
    AssistantEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel1: TPanel;
  private
    { Private declarations }
  public
    CurrTour : Integer;
    constructor Create(AOwner: TComponent; CurrentID: Integer);overload;
  end;

var
  TournamentFrm: TTournamentFrm;

implementation

{$R *.dfm}

uses concour_main, concour_DM;

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
