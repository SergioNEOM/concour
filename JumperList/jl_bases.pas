unit JL_bases;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, DBGrids,
  ExtCtrls, Buttons, StdCtrls, LCLType;

type

  { TBasesFrm }

  TBasesFrm = class(TForm)
    AddBitBtn: TBitBtn;
    BasesDBGrid: TDBGrid;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    DelBitBtn: TBitBtn;
    EditBitBtn: TBitBtn;
    Panel1: TPanel;
    Panel2: TPanel;
    SeekLabel: TLabel;
    procedure AddBitBtnClick(Sender: TObject);
    procedure BasesDBGridDblClick(Sender: TObject);
    procedure BasesDBGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BasesDBGridKeyPress(Sender: TObject; var Key: char);
    procedure BasesDBGridUTF8KeyPress(Sender: TObject; var UTF8Key: TUTF8Char);
    procedure BitBtn2Click(Sender: TObject);
    procedure DelBitBtnClick(Sender: TObject);
    procedure EditBitBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public
    SeekField,
    Tablename : string;
    //todo:  need Seek field name in params ...
    constructor Create(AOwner: TComponent; Base: String);overload;
    function EditBase(RecId:Integer=-1): Boolean;
    procedure DoIt;
  end;

var
  CurrID : Integer;
  BasesFrm: TBasesFrm;

implementation

{$R *.lfm}

uses  LazUTF8, db, JL_DM, JL_Rider, JL_Horses, JL_Tournament;

constructor TBasesFrm.Create(AOwner: TComponent; Base: String);overload;
begin
inherited Create(AOwner);
CurrID := -1;
Tablename:=Base;
SeekField:='';
end;


procedure TBasesFrm.FormCreate(Sender: TObject);
begin
  case LowerCase(Tablename) of
    'riders':
       begin
         Caption:='Выбор всадника';
         SeekField:='lastname';
         DM.OpenRiders(CurrID);
       end;
    'horses':
       begin
         Caption:='Выбор лошади';
         SeekField:='nickname';
         DM.OpenHorses(CurrID);
       end;
    'tournaments':
       begin
         Caption:='Выбор соревнования';
         SeekField:='';
         DM.OpenTournaments(CurrID)
       end;
  end;
  if BasesDBGrid.DataSource.DataSet.Active and (CurrID<1)
    then BasesDBGrid.DataSource.DataSet.First;  //Перестраховка на случай BOF или EOF
  BasesDBGrid.Refresh;
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

procedure TBasesFrm.BasesDBGridDblClick(Sender: TObject);
begin
  DoIt;
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

procedure TBasesFrm.BitBtn2Click(Sender: TObject);
begin
  DoIt;
end;

function TBasesFrm.EditBase(RecId:Integer=-1): Boolean;
begin
Result := False;
case LowerCase(Tablename) of
  'riders':
     begin
       with TRiderFrm.Create(self,RecId) do
       try
         if RecId>0 then
           if DM.SQLQuery1.Locate('id',RecId,[]) then
           begin
             LastnameEdit.Text:=DM.SQLQuery1.FieldByName('lastname').AsString;
             FirstnameEdit.Text:=DM.SQLQuery1.FieldByName('firstname').AsString;
             BirthdayEdit.Text:=DM.SQLQuery1.FieldByName('birthdate').AsString;
             RegnumEdit.Text:=DM.SQLQuery1.FieldByName('regnum').AsString;
             CategoryEdit.Text:=DM.SQLQuery1.FieldByName('category').AsString;
             TrainerEdit.Text:=DM.SQLQuery1.FieldByName('trainer').AsString;
             RegionEdit.Text:=DM.SQLQuery1.FieldByName('region').AsString;
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
           if DM.SQLQuery1.Locate('id',RecId,[]) then
           begin
             NicknameEdit.Text  := DM.SQLQuery1.FieldByName('nickname').AsString;
             BirthdateEdit.Text := DM.SQLQuery1.FieldByName('birthdate').AsString;
             ColorEdit.Text     := DM.SQLQuery1.FieldByName('color').AsString;
             SexEdit.Text       := DM.SQLQuery1.FieldByName('sex').AsString;
             BreedEdit.Text     := DM.SQLQuery1.FieldByName('breed').AsString;
             ParentEdit.Text    := DM.SQLQuery1.FieldByName('parent').AsString;
             BirthplaceEdit.Text:= DM.SQLQuery1.FieldByName('birthplace').AsString;
             RegisterEdit.Text  := DM.SQLQuery1.FieldByName('register').AsString;
             OwnerEdit.Text     := DM.SQLQuery1.FieldByName('owner').AsString;
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
  'tournaments':
     begin
       with TTournamentFrm.Create(self,-1) do
       try
         if RecId>0 then
           if DM.SQLQuery1.Locate('id',RecId,[]) then
           begin
             TourDate.Date := StrToDate(DM.SQLQuery1.FieldByName('Дата соревнования').AsString,'-');
             TourDate2.Date := StrToDate(DM.SQLQuery1.FieldByName('Дата2').AsString,'-');
             TourNameEdit.Text:= DM.SQLQuery1.FieldByName('tourname').AsString;
             TourPlaceEdit.Text:= DM.SQLQuery1.FieldByName('tourplace').AsString;
             RefereeEdit.Text:= DM.SQLQuery1.FieldByName('referee').AsString;
             AssistantEdit.Text:= DM.SQLQuery1.FieldByName('assistant').AsString;
           end;
         //
         if ShowModal=mrOk then
         begin
           if RecId>0 then
           begin
             CurrID:=RecId;
             DM.EditTournament(CurrID,FormatDateTime('yyyy-mm-dd',TourDate.Date),
                 FormatDateTime('yyyy-mm-dd',TourDate2.Date),TourNameEdit.Text,
                 TourPlaceEdit.Text, RefereeEdit.Text, AssistantEdit.Text);
             //todo: обработать результат ?
           end
           else
             CurrID:=DM.AddTournament(FormatDateTime('yyyy-mm-dd',TourDate.Date),
                 FormatDateTime('yyyy-mm-dd',TourDate2.Date),TourNameEdit.Text,
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
  'tournaments':  res := DM.DelTournament(CommonId);
end;
if not res then
  Application.MessageBox(PAnsiChar('Невозможно удалить выбранную запись('+IntToStr(CommonId)+').'+#13#10+
   'Возможно, она используется в основной таблице'),'Ошибка удаления',MB_OK+MB_ICONHAND);
end;

procedure TBasesFrm.DoIt;
begin
  ModalResult:=mrOk;
end;

end.


