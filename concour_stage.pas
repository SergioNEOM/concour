unit concour_stage;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics,
  Dialogs, StdCtrls, MaskEdit, ExtCtrls, Buttons, DbCtrls;

type

  { TStageFrm }

  TStageFrm = class(TForm)
    BarriersEdit2: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    DistEdit1: TEdit;
    DistEdit2: TEdit;
    GroupBox1: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    RouteNameEdit: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    RouteTypeCB: TComboBox;
    BarriersEdit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    VelocityCB1: TComboBox;
    VelocityCB2: TComboBox;
    procedure BitBtn2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RouteTypeCBChange(Sender: TObject);
  private

  public
    RouteID : Integer;
    constructor Create(AOwner: TComponent; CurrentID: Integer);overload;
  end;

var
  StageFrm: TStageFrm;

implementation

{$R *.lfm}
uses concour_main, concour_DM;
{ TStageFrm }


constructor TStageFrm.Create(AOwner: TComponent; CurrentID: Integer);overload;
begin
  inherited Create(AOwner);
  RouteID:=CurrentID;
end;

procedure TStageFrm.FormCreate(Sender: TObject);
begin
  // 2019-01-16
  //было  RouteTypeCB.Items.AddStrings(MainFrm.RouteTypeSL,True);
  RouteTypeCB.Items.Assign(MainFrm.RouteTypeSL);
  RouteTypeCB.ItemIndex:=0; //todo: текущий тип ????
end;


procedure TStageFrm.FormActivate(Sender: TObject);
var
  i: Integer;
begin
{  TypeCB.ItemIndex:=0;
  if not DM.Routes.Active then DM.OpenRoutes(-1);
  if DM.Routes.IsEmpty then RouteID:=-1;
  if RouteID>0 then
    if DM.Routes.Locate('id',RouteID,[]) then
    begin
      RouteNameEdit.Text:=DM.Routes.FieldByName('routename').AsString;
      BarriersEdit1.Text:=DM.Routes.FieldByName('barriers1').AsString;
      BarriersEdit2.Text:=DM.Routes.FieldByName('barriers2').AsString;
    end
    else RouteID:=-1;}
end;


procedure TStageFrm.BitBtn2Click(Sender: TObject);
begin
  ModalResult:=mrOK;
end;

procedure TStageFrm.RouteTypeCBChange(Sender: TObject);
begin
  GroupBox1.Visible:= (Integer(RouteTypeCB.Items.Objects[RouteTypeCB.ItemIndex])=concour_main.ROUTE_OVERLAP);
end;

end.

