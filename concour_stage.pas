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
    JokerLabel: TLabel;
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
    procedure SetVisibility;
  end;

var
  StageFrm: TStageFrm;

implementation

{$R *.lfm}
uses LCLType,concour_main, concour_DM;
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
  //--
  if (RouteID>0) and DM.Routes.Locate('id',RouteID,[]) then
  begin
    // 2019-01-16 типы маршрутов, а не их индексы
    //было RouteTypeCB.ItemIndex:=DM.Routes.FieldByName('route_type').AsInteger;
    RouteTypeCB.ItemIndex:= MainFrm.GetRouteTypeNum(DM.Routes.FieldByName('route_type').AsInteger);
    //--
    RouteNameEdit.Text:=DM.Routes.FieldByName('routename').AsString;
    BarriersEdit1.Text:=DM.Routes.FieldByName('barriers1').AsString;
    DistEdit1.Text:=DM.Routes.FieldByName('distance1').AsString;
    VelocityCB1.ItemIndex:=DM.Routes.FieldByName('velocity1').AsInteger;
    BarriersEdit2.Text:=DM.Routes.FieldByName('barriers2').AsString;
    DistEdit2.Text:=DM.Routes.FieldByName('distance2').AsString;
    VelocityCB2.ItemIndex:=DM.Routes.FieldByName('velocity2').AsInteger;
    //--
  end
  else
    RouteTypeCB.ItemIndex:=0;
  //--
  SetVisibility;
end;

procedure TStageFrm.FormActivate(Sender: TObject);
{var
  i: Integer;}
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
  //
  if (StrToInt(BarriersEdit1.Text)<1) or
     (StrToInt(BarriersEdit1.Text)>15) or
     (StrToInt(BarriersEdit2.Text)<1) or
     (StrToInt(BarriersEdit2.Text)>15) or
     //2019-01-28
     {$IFDEF WIN64 }
     ( (Int64(RouteTypeCB.Items.Objects[RouteTypeCB.ItemIndex])=concour_main.ROUTE_GROW) and
     {$ELSE}
     ( (Integer(RouteTypeCB.Items.Objects[RouteTypeCB.ItemIndex])=concour_main.ROUTE_GROW) and
     {$ENDIF}
       (StrToInt(BarriersEdit1.Text)<2)
     )
  then
  begin
    Application.MessageBox('Ошибка в количестве прыжков!','Ошибка', MB_OK+MB_ICONERROR);
    Exit;
  end;
  ModalResult:=mrOK;
end;

procedure TStageFrm.RouteTypeCBChange(Sender: TObject);
begin
  SetVisibility;
end;

procedure TStageFrm.SetVisibility;
begin
  //для перепрыжки
  // 2019-01-28
 {$IFDEF WIN64 )
  GroupBox1.Visible:= (Int64(RouteTypeCB.Items.Objects[RouteTypeCB.ItemIndex])=concour_main.ROUTE_OVERLAP);
  //для маршрута по возр.сложности
  JokerLabel.Visible:= (Int64(RouteTypeCB.Items.Objects[RouteTypeCB.ItemIndex])=concour_main.ROUTE_GROW);
 ($ELSE}
  GroupBox1.Visible:= (Integer(RouteTypeCB.Items.Objects[RouteTypeCB.ItemIndex])=concour_main.ROUTE_OVERLAP);
  //для маршрута по возр.сложности
  JokerLabel.Visible:= (Integer(RouteTypeCB.Items.Objects[RouteTypeCB.ItemIndex])=concour_main.ROUTE_GROW);
 {$ENDIF}
end;

end.

