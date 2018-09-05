unit concour_bases;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  DBGrids, ExtCtrls, Buttons, ComCtrls, DbCtrls, ActnList, LCLType;

type

  { TBasesFrm }

  TBasesFrm = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BasesDBGrid: TDBGrid;
    AddBitBtn: TBitBtn;
    EditBitBtn: TBitBtn;
    DelBitBtn: TBitBtn;
    SeekLabel: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure BasesDBGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BasesDBGridKeyPress(Sender: TObject; var Key: char);
    procedure AddBitBtnClick(Sender: TObject);
    procedure BasesDBGridUTF8KeyPress(Sender: TObject; var UTF8Key: TUTF8Char);
    procedure EditBitBtnClick(Sender: TObject);
    procedure DelBitBtnClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public
    CurrID : Integer;
    SeekField,
    Tablename : string;

    //todo:  need Seek field name in params ...
    constructor Create(AOwner: TComponent; Base: String; CurrentID: Integer);overload;
    function EditBase(RecId:Integer=-1): Boolean;
  end;

var
  BasesFrm: TBasesFrm;

implementation

{$R *.lfm}
uses  LazUTF8, db, concour_DM, concour_params, concour_stage, concour_tournament, concour_rider,
  concour_horses;

constructor TBasesFrm.Create(AOwner: TComponent; Base: String; CurrentID: Integer);overload;
begin
  inherited Create(AOwner);
  Tablename:=Base;
  CurrID:=CurrentID;
  SeekField:='';
end;


procedure TBasesFrm.FormCreate(Sender: TObject);
begin
  case LowerCase(Tablename) of
    'riders':
       begin
         Caption:='Выбор всадника';
         SeekField:='lastname';
         BasesDBGrid.DataSource := nil;
         DM.OpenRiders(CurrID);
         BasesDBGrid.DataSource := DM.DS_Riders;
       end;
    'horses':
       begin
         Caption:='Выбор лошади';
         SeekField:='nickname';
         BasesDBGrid.DataSource := nil;
         DM.OpenHorses(CurrID);
         BasesDBGrid.DataSource := DM.DS_Horses;
       end;
    'groups':
       begin
         Caption:='Выбор зачёта';
         SeekField:='groupname';
         BasesDBGrid.DataSource := nil;
         DM.OpenGroups(CurrID);
         BasesDBGrid.DataSource := DM.DS_Groups;
       end;
    'routes':
       begin
         Caption:='Выбор маршрута';
         SeekField:='routename';
         BasesDBGrid.DataSource := nil;
         DM.OpenRoutes(CurrID);
         BasesDBGrid.DataSource := DM.DS_Routes;
       end;
    'tournaments':
       begin
         Caption:='Выбор соревнования';
         SeekField:='';
         BasesDBGrid.DataSource := nil;
         DM.OpenTournaments(CurrID);
         BasesDBGrid.DataSource := DM.DS_Tournaments;
       end;
  end;
  BasesDBGrid.Refresh;
end;



procedure TBasesFrm.Button1Click(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TBasesFrm.BasesDBGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key in [VK_PRIOR, VK_NEXT, VK_TAB, VK_HOME, VK_END, VK_LEFT, VK_RIGHT,
                VK_UP, VK_DOWN] then SeekLabel.Caption := '';
  if Key = VK_BACK {BackSpace} then
  begin
    if Length(SeekLabel.Caption)>0 then //удалить последний символ
            SeekLabel.Caption := UTF8Copy(SeekLabel.Caption,1,UTF8Length(SeekLabel.Caption)-1)
    {else MessageBeep(Word(-1))};
    Key := 0;
  end;
  if (Key = VK_RETURN) then
     if (TDBGrid(Sender).DataSource.DataSet.State in [dsInsert,dsEdit])
     then TDBGrid(Sender).DataSource.DataSet.Post
     else TDBGrid(Sender).DataSource.DataSet.Edit;
end;


procedure TBasesFrm.BasesDBGridKeyPress(Sender: TObject; var Key: char);
begin
 { if Key >= ' ' then
  begin
    SeekLabel.Caption := SeekLabel.Caption + AnsiUpperCase(Key);
  end;

  if (Length(SeekLabel.Caption)>0) and (SeekField<>'') then
    TDBGrid(Sender).DataSource.DataSet.Locate(SeekField,SeekLabel.Caption,[loCaseInsensitive,loPartialKey]);
    }
end;


procedure TBasesFrm.AddBitBtnClick(Sender: TObject);
begin
  EditBase(-1);
end;

procedure TBasesFrm.BasesDBGridUTF8KeyPress(Sender: TObject;
  var UTF8Key: TUTF8Char);
begin
//    if UTF8Key >= ' ' then
//  begin
    SeekLabel.Caption := SeekLabel.Caption + AnsiUpperCase(Utf8ToAnsi(UTF8Key));
//  end;

  if (Length(SeekLabel.Caption)>0) and (SeekField<>'') then
    TDBGrid(Sender).DataSource.DataSet.Locate(SeekField,SeekLabel.Caption,[loCaseInsensitive,loPartialKey]);
end;

function TBasesFrm.EditBase(RecId:Integer=-1): Boolean;
var
  s: String;
begin
  Result := False;
  case LowerCase(Tablename) of
    'riders':
       begin
         with TRiderFrm.Create(self,RecId) do
         try
           if RecId>0 then
             if DM.Riders.Locate('id',RecId,[]) then
             begin
               LastnameEdit.Text:=DM.Riders.FieldByName('lastname').AsString;
               FirstnameEdit.Text:=DM.Riders.FieldByName('firstname').AsString;
               BirthdayEdit.Text:=DM.Riders.FieldByName('birthdate').AsString;
               RegnumEdit.Text:=DM.Riders.FieldByName('regnum').AsString;
               CategoryEdit.Text:=DM.Riders.FieldByName('category').AsString;
               TrainerEdit.Text:=DM.Riders.FieldByName('trainer').AsString;
               RegionEdit.Text:=DM.Riders.FieldByName('region').AsString;
             end;
           if ShowModal=mrOK then
           begin
             if RecId>0 then
             begin
               CurrID:=RecId;
               DM.EditRider(CurrID,StrToInt(BirthdayEdit.Text),LastnameEdit.Text,
                   FirstnameEdit.Text,RegnumEdit.Text,CategoryEdit.Text,TrainerEdit.Text,
                   RegionEdit.Text)
             end
             else
               CurrID:=DM.AddRider(StrToInt(BirthdayEdit.Text),LastnameEdit.Text,
                   FirstnameEdit.Text,RegnumEdit.Text,CategoryEdit.Text,TrainerEdit.Text,
                   RegionEdit.Text);
             DM.OpenRiders(CurrID);
           end;
         finally
           Free;
         end;
       end;
    'horses':
       begin
         with ThorsesFrm.Create(self,RecId) do
         try
           if RecId>0 then
             if DM.Horses.Locate('id',RecId,[]) then
             begin
               NicknameEdit.Text  := DM.Horses.FieldByName('nickname').AsString;
               BirthdateEdit.Text := DM.Horses.FieldByName('birthdate').AsString;
               ColorEdit.Text     := DM.Horses.FieldByName('color').AsString;
               SexEdit.Text       := DM.Horses.FieldByName('sex').AsString;
               BreedEdit.Text     := DM.Horses.FieldByName('breed').AsString;
               ParentEdit.Text    := DM.Horses.FieldByName('parent').AsString;
               BirthplaceEdit.Text:= DM.Horses.FieldByName('birthplace').AsString;
               RegisterEdit.Text  := DM.Horses.FieldByName('register').AsString;
               OwnerEdit.Text     := DM.Horses.FieldByName('owner').AsString;
             end;
           if ShowModal=mrOK then
           begin
             if RecId>0 then
             begin
               CurrID:=RecId;
               DM.EditHorse(CurrID,StrToInt(BirthdateEdit.Text),NicknameEdit.Text,
                  ColorEdit.Text,SexEdit.Text,BreedEdit.Text,ParentEdit.Text,
                  BirthplaceEdit.Text,RegisterEdit.Text,OwnerEdit.Text);
             end
             else
               CurrID:=DM.AddHorse(StrToInt(BirthdateEdit.Text),NicknameEdit.Text,
                  ColorEdit.Text,SexEdit.Text,BreedEdit.Text,ParentEdit.Text,
                  BirthplaceEdit.Text,RegisterEdit.Text,OwnerEdit.Text);
             DM.OpenHorses(CurrID);
           end;
         finally
           Free;
         end;
       end;
    'groups':
       begin
         s := '';
         if RecId>0 then
         begin
           if DM.Groups.Locate('id',RecId,[]) then
             s := DM.Groups.FieldByName('groupname').AsString;
           if InputQuery('?','Введите название зачёта',s) then
             s := Trim(s);
         end
         else  s := Trim(InputBox('?','Введите название зачёта',''));
         if s<>'' then Result := DM.EditGroup(s,RecId);
       end;
    'routes':
       begin
         if not DM.Routes.Active then DM.OpenRoutes(RecId);
         with TStageFrm.Create(self,RecId) do
         try
           if RecId>0 then
             if DM.Routes.Locate('id',RecId,[]) then
             begin
               RouteTypeCB.ItemIndex:=DM.Routes.FieldByName('route_type').AsInteger;
               RouteNameEdit.Text:=DM.Routes.FieldByName('routename').AsString;
               BarriersEdit1.Text:=DM.Routes.FieldByName('barriers1').AsString;
               DistEdit1.Text:=DM.Routes.FieldByName('distance1').AsString;
               VelocityCB1.ItemIndex:=DM.Routes.FieldByName('velocity1').AsInteger;
               BarriersEdit2.Text:=DM.Routes.FieldByName('barriers2').AsString;
               DistEdit2.Text:=DM.Routes.FieldByName('distance2').AsString;
               VelocityCB2.ItemIndex:=DM.Routes.FieldByName('velocity2').AsInteger;
               TypeCB.ItemIndex:=DM.Routes.FieldByName('result_type').AsInteger;
               GroupBox1.Visible := RouteTypeCB.ItemIndex=1;
             end;
           if ShowModal=mrOK then
           begin
             if RecId>0 then
             begin
               CurrID:=RecId;
               DM.EditRoute(CurrID,RouteTypeCB.ItemIndex,StrToInt(DistEdit1.Text),
                   VelocityCB1.ItemIndex,StrToInt(BarriersEdit1.Text),
                   StrToInt(DistEdit2.Text),VelocityCB2.ItemIndex,
                   StrToInt(BarriersEdit2.Text),TypeCB.ItemIndex,RouteNameEdit.Text)
             end
             else
               CurrID:=DM.AddRoute(RouteTypeCB.ItemIndex,StrToInt(DistEdit1.Text),
                   VelocityCB1.ItemIndex,StrToInt(BarriersEdit1.Text),
                   StrToInt(DistEdit1.Text),VelocityCB2.ItemIndex,
                   StrToInt(BarriersEdit2.Text),TypeCB.ItemIndex,RouteNameEdit.Text);
             DM.OpenRoutes(CurrID);
           end;
         finally
           Free;
         end;
       end;
    'tournaments':
       begin
         with TTournamentFrm.Create(self,-1) do
         try
           if RecId>0 then
             if DM.Tournaments.Locate('id',RecId,[]) then
             begin
               TourDate.Date := StrToDate(DM.Tournaments.FieldByName('Дата соревнования').AsString,'-');
               TourNameEdit.Text:= DM.Tournaments.FieldByName('tourname').AsString;
               TourPlaceEdit.Text:= DM.Tournaments.FieldByName('tourplace').AsString;
               RefereeEdit.Text:= DM.Tournaments.FieldByName('referee').AsString;
               AssistantEdit.Text:= DM.Tournaments.FieldByName('assistant').AsString;
             end;
           //
           if ShowModal=mrOk then
           begin
             if RecId>0 then
             begin
               CurrID:=RecId;
               DM.EditTournament(CurrID,FormatDateTime('yyyy-mm-dd',TourDate.Date),TourNameEdit.Text,
                   TourPlaceEdit.Text, RefereeEdit.Text, AssistantEdit.Text);
               //todo: обработать результат ?
             end
             else
               CurrID:=DM.AddTournament(FormatDateTime('yyyy-mm-dd',TourDate.Date),TourNameEdit.Text,
                   TourPlaceEdit.Text, RefereeEdit.Text, AssistantEdit.Text);
             DM.OpenTournaments(CurrID);
           end;
         finally
           Free;
         end;
       end;
  end;
  BasesDBGrid.Refresh;
end;

procedure TBasesFrm.EditBitBtnClick(Sender: TObject);
begin
  if BasesDBGrid.DataSource.DataSet.Active and
    not BasesDBGrid.DataSource.DataSet.IsEmpty then
       EditBase(BasesDBGrid.DataSource.DataSet.FieldByName('id').AsInteger);
end;

procedure TBasesFrm.DelBitBtnClick(Sender: TObject);
var
  res : Boolean;
  CommonId : Integer;
begin
  res := True;
  CommonId := BasesDBGrid.DataSource.DataSet.FieldByName('id').AsInteger;
  if Application.MessageBox('Вы действительно хотите удалить выбранную запись?',
     'Запрос подтверждения удаления',MB_YESNO+MB_ICONQUESTION+MB_DEFBUTTON2)<>IDYES then Exit;
  case LowerCase(Tablename) of
    'riders':       res := DM.DelRider(CommonId);
    'horses':       res := DM.DelHorse(CommonId);
    'groups':       res := DM.DelGroup(CommonId);
    'routes':       res := DM.DelRoute(CommonId);
    'tournaments':  res := DM.DelTournament(CommonId);
  end;
  if not res then
    Application.MessageBox(PAnsiChar('Невозможно удалить выбранную запись('+IntToStr(CommonId)+').'+#13#10+
     'Возможно, она используется в основной таблице'),'Ошибка удаления',MB_OK+MB_ICONHAND);
end;

end.

