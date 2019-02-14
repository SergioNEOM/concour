unit concour_main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Menus, ActnList, ComCtrls, ExtCtrls, DBGrids, Buttons, Grids,
  EditBtn, Spin, DbCtrls, Types;

const
  // типы маршрутов   (смотрим .Tag каждого столбца и показываем при совпадающей маске)
  ROUTE_CLASSIC  =   1;          // КЛАССИКА (в combobox-списке - 0)
  ROUTE_OVERLAP  =   2;          // КЛАССИКА С ПЕРЕПРЫЖКОЙ
  ROUTE_2PHASES  =   4;          // 2 ФАЗЫ
  ROUTE_GROW     =   8;          // ПО ВОЗРАСТАЮЩЕЙ СЛОЖНОСТИ
  ROUTE_TABLE_C  =  16;          // ПО ТАБЛИЦЕ С
  ROUTE_MAXBALLS =  32;          // НА МАКСИМУМ БАЛЛОВ
  ROUTE_2GIT     =  64;          // 2 ГИТА
  // ...
  ROUTE_ALL      = 255;          // 32767;
  //----------------
  OVER_CALC      = 1;            // расчетная перепрыжка  (в поле overlap)
  OVER_FAST      = 2;            // "Быстрая" перепрыжка
  //----------------
  FIRED_RIDER    = 9000;         // снятым участникам добавляется константа к полю place
type

  { TMainFrm }

  TMainFrm = class(TForm)
    GitFastOverAction: TAction;
    GitResultsAction: TAction;
    GitShuffleAction: TAction;
    FilePrintAction: TAction;
    Barriers1SpinEdit: TSpinEdit;
    Barriers2SpinEdit: TSpinEdit;
    AddBitBtn: TBitBtn;
    ClearBitBtn: TBitBtn;
    DelBitBtn: TBitBtn;
    CalcOverlapBitBtn: TBitBtn;
    CalcPlacesBitBtn: TBitBtn;
    DistanceEdit1: TEdit;
    DistanceEdit2: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    LeaderLabel: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    MaxTime2Edit: TEdit;
    MaxTimeEdit: TEdit;
    MenuItem10: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem9: TMenuItem;
    OverlapCB: TCheckBox;
    JokerCB: TCheckBox;
    PageControl1: TPageControl;
    Panel1: TPanel;
    GitClearResAction: TAction;
    GitDelAction: TAction;
    GitFireAction: TAction;
    RepSpeedButton1: TSpeedButton;
    RouteNameLabel: TLabel;
    RouteSelectSBut: TSpeedButton;
    ShuffleBitBtn: TBitBtn;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    FileBaseHorsesAction: TAction;
    GitDBGrid: TDBGrid;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem20: TMenuItem;
    Panel3: TPanel;
    Panel5: TPanel;
    PopupMenu1: TPopupMenu;
    StatusBar1: TStatusBar;
    RouteAddAction: TAction;
    RouteSelectAction: TAction;
    FileBaseRidersAction: TAction;
    FileExitAction: TAction;
    ActionList1: TActionList;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    Time2PenaltyCB: TComboBox;
    TimePenaltyCB: TComboBox;
    VelocityCB1: TComboBox;
    VelocityCB2: TComboBox;
    procedure Barriers1SpinEditEditingDone(Sender: TObject);
    procedure Barriers2SpinEditEditingDone(Sender: TObject);
    procedure AddBitBtnClick(Sender: TObject);
    procedure DistanceEdit1EditingDone(Sender: TObject);
    procedure DistanceEdit2EditingDone(Sender: TObject);
    procedure FilePrintActionExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CalcOverlapBitBtnClick(Sender: TObject);
    procedure CalcPlacesBitBtnClick(Sender: TObject);
    procedure GitDBGridTitleClick(Column: TColumn);
    procedure GitFastOverActionExecute(Sender: TObject);
    procedure GitResultsActionExecute(Sender: TObject);
    procedure GitShuffleActionExecute(Sender: TObject);
    procedure JokerCBChange(Sender: TObject);
    procedure MenuItem14Click(Sender: TObject);
    procedure OverlapCBChange(Sender: TObject);
    procedure RepSpeedButton1Click(Sender: TObject);
    procedure ShuffleBitBtnClick(Sender: TObject);
    procedure DistanceEdit2Change(Sender: TObject);
    procedure DistanceEdit1Change(Sender: TObject);
    procedure DistanceEdit1Exit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GitDBGridDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure GitDBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure GitDBGridEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure GitFireActionExecute(Sender: TObject);
    procedure GitDBGridContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure GitDBGridEditButtonClick(Sender: TObject);
    procedure GitDBGridEditingDone(Sender: TObject);
    procedure GitDBGridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FileBaseHorsesActionExecute(Sender: TObject);
    procedure FileBaseRidersActionExecute(Sender: TObject);
    procedure FileExitActionExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure GitClearResActionExecute(Sender: TObject);
    procedure GitDelActionExecute(Sender: TObject);
    procedure MaxTime2EditExit(Sender: TObject);
    procedure MaxTimeEditExit(Sender: TObject);
    procedure Barriers1SpinEditChange(Sender: TObject);
    procedure Barriers2SpinEditChange(Sender: TObject);
    procedure RouteAddActionExecute(Sender: TObject);
    procedure RouteSelectActionExecute(Sender: TObject);
    procedure TimePenaltyCBEditingDone(Sender: TObject);
    procedure VelocityCB1EditingDone(Sender: TObject);
    procedure VelocityCB2Change(Sender: TObject);
    procedure VelocityCB1Change(Sender: TObject);
    procedure VelocityCB2EditingDone(Sender: TObject);
  private

  public
    SumPenalty: Currency;
    RouteTypeSL: TStringList;
    function GetRouteTypeNum(RType:Integer):Integer;
    procedure GitGridRefreshVisibility;
    function ShowBasesDialog(BaseName: string; CurrentID: Integer): Integer;
    procedure CalcMaxTime;
    procedure CalcMaxTimeOver;
    procedure CalcPenalties;
    procedure CalcPlaces;
    procedure CalcPlacesOver;
    procedure SetColNames;
    procedure SetJokerVisibility;
  end;

var
  MainFrm: TMainFrm;

implementation

{$R *.lfm}
uses LCLType, db, math,  concour_DM,  concour_bases,
  concour_export;

{ TMainFrm }

procedure TMainFrm.FormCreate(Sender: TObject);
var
i: Integer;
c: TColumn;
begin
  RouteTypeSL := TStringList.Create;
  // 2019-01-16 константы типов маршрутов, а не их индексы
  RouteTypeSL.AddObject('КЛАССИКА',TObject(ROUTE_CLASSIC));                // ItemIndex = 0
  RouteTypeSL.AddObject('КЛАССИКА С ПЕРЕПРЫЖКОЙ',TObject(ROUTE_OVERLAP));  // 1
  RouteTypeSL.AddObject('2 ФАЗЫ',TObject(ROUTE_2PHASES));                  // 2
  RouteTypeSL.AddObject('ПО ВОЗРАСТАЮЩЕЙ СЛОЖНОСТИ',TObject(ROUTE_GROW));  // 3
  RouteTypeSL.AddObject('ПО ТАБЛИЦЕ С',TObject(ROUTE_TABLE_C));            // 4
  RouteTypeSL.AddObject('НА МАКСИМУМ БАЛЛОВ',TObject(ROUTE_MAXBALLS));     // 5
  RouteTypeSL.AddObject('2 ГИТА',TObject(ROUTE_2GIT));                     // 6
  //
  // препятствия перепрыжки
  //todo: учесть другие типы маршрутов!
  GitDBGrid.BeginUpdate;
  for i:=1 to Barriers2SpinEdit.MaxValue do
  try
    c := TColumn(GitDBGrid.Columns.Insert(GitDBGrid.Columns.Count-7));
    c.FieldName:='foul2_b'+Trim(IntToStr(i));
    c.DisplayFormat:='###';
    c.Tag:=ROUTE_OVERLAP;
    c.Title.Alignment:=taCenter;
    c.Title.MultiLine:=True;
    //todo: заголовки брать из БД?
    c.Title.Caption := 'П'+#10#13+IntToStr(i);
    c.Width:=40;
    c.Visible := false;
  finally
    c := nil;
  end;
  GitDBGrid.EndUpdate(true);
  //----
end;

function TMainFrm.GetRouteTypeNum(RType:Integer):Integer;
var
  i: Integer;
begin
  Result := -1;
  RouteTypeSL.BeginUpdate;
  for i:=0 to RouteTypeSL.Count-1 do
{$IFDEF WIN64}
    if Int64(RouteTypeSL.Objects[i])=RType then
{$ELSE}
    if Integer(RouteTypeSL.Objects[i])=RType then
{$ENDIF}
    begin
      Result := i;
      Break;
    end;
  RouteTypeSL.EndUpdate;
end;

procedure TMainFrm.GitDBGridDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept:=Source is TDBGrid;
end;


procedure TMainFrm.FormActivate(Sender: TObject);
begin
  DistanceEdit1.Text:='300';
  DistanceEdit2.Text:='300';
  if DM.CurrentTournament<0 then DM.CurrentTournament:=ShowBasesDialog('tournaments',-1);
  //если не выбран турнир или маршрут, то выйти...
  //
  if (DM.CurrentTournament<0) then
  begin
    Application.MessageBox('Вы не выбрали соревнование из списка!'+#13#10+
                 'Для правильного функционирования перезапустите программу.',
                               'Ошибка выбора',MB_OK+MB_ICONASTERISK);
    halt(1000);
  end;
  //
  if DM.CurrentRoute<0 then  RouteSelectActionExecute(self); //DM.CurrentRoute:=ShowBasesDialog('routes',-1);
  //
  if (DM.CurrentRoute<0) then
  begin
    Application.MessageBox('Вы не выбрали маршрут из списка!'+#13#10+
                 'Без этого программа не сможет правильно функционировать.',
                               'Ошибка выбора',MB_OK+MB_ICONASTERISK);
    Exit;
  end;
  //
  PageControl1.ActivePageIndex:=0;
  //---
  GitGridRefreshVisibility;
  //
  DM.OpenGit(-1);
  GitDBGrid.Enabled:=not DM.Git.IsEmpty;
end;


procedure TMainFrm.GitGridRefreshVisibility;
var
  v: Boolean;
  i: Integer;
begin
  // 2019-02-08 Joker ComboBox (not Grid ;) )
  if Assigned(concour_DM.DM) then
  begin
    JokerCB.Visible:= (DM.CurrRouteType=ROUTE_GROW);
    JokerCB.Enabled:= JokerCB.Visible;
  end;
  //--
  //
  //обновить к-во видимых колонок таблицы (в т.ч. пересчитать штрафы)
  GitDBGrid.BeginUpdate;
  for i:=0 to GitDBGrid.Columns.Count-1 do
  begin
    //---
    if lowercase(LeftStr(GitDBGrid.Columns.Items[i].FieldName,7))='foul1_b' then
    begin
       v := StrToInt(copy(GitDBGrid.Columns.Items[i].FieldName,8,2))<=Barriers1SpinEdit.Value;
       // в режиме перепрыжки - не показывать
       v := not OverlapCB.Checked and v;
    end
    else  // штрафы в перепрыжке
      if (lowercase(LeftStr(GitDBGrid.Columns.Items[i].FieldName,7))='foul2_b') then
        v := OverlapCB.Checked and (StrToInt(copy(GitDBGrid.Columns.Items[i].FieldName,8,2))<=Barriers2SpinEdit.Value)
      else
        // показать "Место 2" только в перепрыжке
        if lowercase(LeftStr(GitDBGrid.Columns.Items[i].FieldName,6))='place2' then
           v := OverlapCB.Visible and OverlapCB.Checked
        else
          // все остальные поля
          v:= True;
    // наложим маску по виду маршрута
    //2019-01-17
//    GitDBGrid.Columns[i].Visible:= v and ((GitDBGrid.Columns[i].Tag and (1 shl DM.CurrRouteType) )>0);
    GitDBGrid.Columns[i].Visible:= v and ((GitDBGrid.Columns[i].Tag and DM.CurrRouteType)>0);
  end;
  //--
  // 2019-02-14 Joker ComboBox
  SetJokerVisibility;
  //--
  CalcPenalties;
  //--
  GitDBGrid.EndUpdate(true);
end;


procedure TMainFrm.AddBitBtnClick(Sender: TObject);
begin
  if (DM.CurrentTournament<=0) or  (DM.CurrentRoute<=0) then Exit;
  DM.AppendGit;
  GitDBGrid.Enabled:=not DM.Git.IsEmpty;
end;

procedure TMainFrm.DistanceEdit1EditingDone(Sender: TObject);
begin
  //редактирование закончено? Запишем в БД
  if not DM.RouteSetField(-1,StrToInt(TEdit(Sender).Text),'distance1') then
    Application.MessageBox('Значение не удалось записать в БД!','Ошибка',MB_OK);
  //
end;

procedure TMainFrm.DistanceEdit2EditingDone(Sender: TObject);
begin
  //редактирование закончено? Запишем в БД
  if not DM.RouteSetField(-1,StrToInt(TEdit(Sender).Text),'distance2') then
    Application.MessageBox('Значение не удалось записать в БД!','Ошибка',MB_OK);
  //
end;


procedure TMainFrm.FilePrintActionExecute(Sender: TObject);
begin
  with TExpFrm.Create(self) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

procedure TMainFrm.FormDestroy(Sender: TObject);
begin
  if Assigned(RouteTypeSL) then RouteTypeSL.Free;
end;


procedure TMainFrm.CalcOverlapBitBtnClick(Sender: TObject);
begin
  // 2019-01-11 проверка на пустые значения gittime1
  if not DM.GitCheckTime(True) then
  begin
    Application.MessageBox('Необходимо заполнить время гита для всех участников!',
         'Ошибка',MB_OK+MB_ICONERROR);
    Exit;
  end;
  CalcPlacesOver;
  DM.OpenGit(-1,concour_DM.GIT_ORDER_R,True);
end;

procedure TMainFrm.CalcPlacesBitBtnClick(Sender: TObject);
begin
  GitResultsActionExecute(Sender);
end;

procedure TMainFrm.GitDBGridTitleClick(Column: TColumn);
var
  s : String;
begin
  if (LowerCase(LeftStr(Column.FieldName,7)) = 'foul1_b') or
     (LowerCase(LeftStr(Column.FieldName,7)) = 'foul2_b') then
  begin
    s:=InputBox('Заголовок','Вводите наименование',Column.Title.Caption);
    if s<>'' then
    begin
      Column.Title.Caption:=s;
      DM.SetColName(Column.FieldName,s);
      if not DM.UpdateColNames then ShowMessage('Изменение не записалось в БД!');
    end;
  end;
end;

procedure TMainFrm.GitFastOverActionExecute(Sender: TObject);
var
  val: Integer;
begin
  // Переключение участника в "Быструю" перепрыжку
  //
  if OverlapCB.Checked then
  begin
    if GitDBGrid.DataSource.DataSet.FieldByName('overlap').AsInteger<>OVER_FAST then
    begin
      //todo: если не "быстрая" перепрыжка, то перезаписывать или нет ???????
      // 2019-01-08 пока - нет
      Application.MessageBox('Это не "быстрая" перепрыжка.','Ошибка',MB_OK+MB_ICONERROR);
      Exit;
    end;
    val := 0          //перепрыжка? значит, убрать из списка (overlap=0)
  end
  else
  begin
    if GitDBGrid.DataSource.DataSet.FieldByName('overlap').AsInteger<>0 then
    begin
      //todo: участник уже в перепрыжке: перезаписывать или нет ???????
      // 2019-01-08   пока - нет
      Application.MessageBox('Уже в перепрыжке!','Информация',MB_OK+MB_ICONINFORMATION);
      Exit;
    end;
    val := OVER_FAST; //нет? значит, добавить в перепрыжку
  end;
  if DM.GitSetField(GitDBGrid.DataSource.DataSet.FieldByName('id').AsInteger,val,'overlap') then
     Application.MessageBox(PAnsiChar('Выполнено.'+#13#10+#13#10+'ВНИМАНИЕ! Список изменился, выполните пересчет итогов.'),
                 'Информация',MB_OK+MB_ICONINFORMATION);
  // обновить датасет на тех же условиях
  DM.OpenGit(GitDBGrid.DataSource.DataSet.FieldByName('id').AsInteger,0 {порядок не менять},OverlapCB.Checked);
end;

procedure TMainFrm.GitResultsActionExecute(Sender: TObject);
begin
  // 2019-01-11 проверка на пустые значения gittime1
  if not DM.GitCheckTime() then
  begin
    Application.MessageBox('Необходимо заполнить время гита для всех участников!',
         'Ошибка',MB_OK+MB_ICONERROR);
    Exit;
  end;
  CalcPlaces;
  DM.OpenGit(-1,concour_DM.GIT_ORDER_R);
end;

procedure TMainFrm.GitShuffleActionExecute(Sender: TObject);
var
  n, i: Integer;
  sl : TStringList;
begin
  // жеребьёвка
  if (not DM.Git.Active) or DM.Git.IsEmpty then Exit;
  n := DM.Git.RecordCount;
  Randomize;
  try
    sl := TStringList.Create;
    GitDBGrid.BeginUpdate;
    DM.Git.First;
    While not DM.Git.EOF do
    begin
      repeat
        i := Random(n)+1;
        if sl.IndexOfName(trim(IntToStr(i)))<0 then Break;
      until false;
      sl.Add(trim(IntToStr(i))+'='+DM.Git.FieldByName('rider').AsString);             //+'='+DM.Git.FieldByName('id').AsString);
      DM.Git.Edit;
      DM.Git.FieldByName('queue').AsInteger:=i;
      DM.Git.Post;
      DM.Git.Next;
    end;
    sl.Sort;
    DM.OpenGit(-1);
    //GitDBGrid.Enabled:=not DM.Git.IsEmpty;
  finally
    GitDBGrid.EndUpdate;
    sl.Free;
  end;
end;

procedure TMainFrm.JokerCBChange(Sender: TObject);
begin
  GitGridRefreshVisibility;
end;

procedure TMainFrm.MenuItem14Click(Sender: TObject);
begin

end;

procedure TMainFrm.Barriers2SpinEditEditingDone(Sender: TObject);
begin
  //todo: обнулять значения невидимых ячеек или пересчитывать сумму штрафов?
  //редактирование закончено? Запишем в БД
  if not DM.RouteSetField(-1,TSpinEdit(Sender).Value,'barriers2') then
    Application.MessageBox('Значение не удалось записать в БД!','Ошибка',MB_OK);
  //
  GitGridRefreshVisibility;
end;

procedure TMainFrm.Barriers1SpinEditEditingDone(Sender: TObject);
begin
  //редактирование закончено?
  //2019-02-14 Сначала проверить, что не "заедем" на Джокера:
  if (DM.CurrRouteType=ROUTE_GROW) and (TSpinEdit(Sender).Value>=15) then
    TSpinEdit(Sender).Value := 14; //т.к. 15-й - Джокер
  //todo: показать сообщение, что обычно д.б. 8 или 10 прыжков !!
  //-
  //Запишем в БД
  if not DM.RouteSetField(-1,TSpinEdit(Sender).Value,'barriers1') then
    Application.MessageBox('Значение не удалось записать в БД!','Ошибка',MB_OK);
  //
  GitGridRefreshVisibility;
end;

procedure TMainFrm.OverlapCBChange(Sender: TObject);
begin
  if OverlapCB.Checked then PageControl1.ActivePageIndex:=1 //панель перепрыжки
  else PageControl1.ActivePageIndex:=0; // основной маршрут
  DM.OpenGit(-1,0{порядок не менять},OverlapCB.Checked);
  GitGridRefreshVisibility;
end;

procedure TMainFrm.RepSpeedButton1Click(Sender: TObject);
begin
  FilePrintActionExecute(self);
end;


procedure TMainFrm.ShuffleBitBtnClick(Sender: TObject);
begin
  GitShuffleActionExecute(Sender);
end;


procedure TMainFrm.DistanceEdit2Change(Sender: TObject);
begin
  CalcMaxTimeOver;
end;

procedure TMainFrm.DistanceEdit1Change(Sender: TObject);
begin
  CalcMaxTime;
end;

procedure TMainFrm.DistanceEdit1Exit(Sender: TObject);
begin
  //todo: когда покидаем поле с пустым значением, надо присвоить значение из БД
end;


procedure TMainFrm.GitDBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  Col: TColor;
  fname : String;
begin
  Col := GitDBGrid.Canvas.Brush.Color;
  // стиль активного поля не меняем
  if not (gdSelected in State) then
  begin
    // быстрые перепрыжчики - жёлтые
    if TDBGrid(Sender).DataSource.DataSet.FieldByName('overlap').AsInteger=OVER_FAST then
      TDBGrid(Sender).Canvas.Brush.Color :=  RGBToColor(255,255,210);
    // выделение полей со штрафными очками розовым цветом
    if (LeftStr(LowerCase(Column.FieldName),4)='foul')  then
      if (DM.CurrRouteType<>ROUTE_GROW) and
         (TDBGrid(Sender).DataSource.DataSet.FieldByName(Column.FieldName).AsCurrency>0.0)
      then   TDBGrid(Sender).Canvas.Brush.Color :=  RGBToColor(250,150,150)
      else   TDBGrid(Sender).Canvas.Brush.Color := Col;
     {if gdSelected in State then
         begin
            TDBGrid(Sender).Canvas.Brush.Color := clMenuHighlight;
            TDBGrid(Sender).Canvas.Font.Color := clWhite;
         end;}
     //
    // выделение итоговых штрафных полей жирным стилем
    if (LeftStr(LowerCase(Column.FieldName),10)='totalfouls')  then
      TDBGrid(Sender).Canvas.Font.Style :=  [fsBold]
    else
      TDBGrid(Sender).Canvas.Font.Style :=  [];
    //
    // выделение снятых участников
    if OverlapCB.Checked then fname:='place2'
    else fname:='place';
    if TDBGrid(Sender).DataSource.DataSet.FieldByName(fname).AsInteger>FIRED_RIDER then
           TDBGrid(Sender).Canvas.Brush.Color :=  RGBToColor(50,150,150);

    //почему-то без ручной закраски не хочет менять цвет фона...
    TDBGrid(Sender).Canvas.FillRect(Rect);
    //
  end;
  TDBGrid(Sender).DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;

procedure TMainFrm.GitDBGridEndDrag(Sender, Target: TObject; X, Y: Integer);
var
  c: TColumn;
  row1,row2, q1,q2,  i, off : Integer;
begin
  if Assigned(Target) then
  begin
    row1 := TDBGrid(Target).DataSource.DataSet.FieldByName('id').AsInteger; //текущая строка
    q1 := TDBGrid(Target).DataSource.DataSet.FieldByName('queue').AsInteger;
    TDBGrid(Target).MouseToRecordOffset(X,Y,c,off);
    if off=0 then  Exit;     // do nothing
    // skip records from current with offset
    for i:=1 to abs(off) do
    begin
      if off>0 then
      begin
        if not TDBGrid(Target).DataSource.DataSet.EOF then TDBGrid(Target).DataSource.DataSet.Next;
      end
      else
        if not TDBGrid(Target).DataSource.DataSet.BOF then TDBGrid(Target).DataSource.DataSet.Prior;
    end;
    row2 := TDBGrid(Target).DataSource.DataSet.FieldByName('id').AsInteger;
    q2 := TDBGrid(Target).DataSource.DataSet.FieldByName('queue').AsInteger;
    if q1=q2 then
    begin
      Application.MessageBox('Не удалось изменить порядок!'+#13#10+'Возможно не проведена жеребьёвка','Предупреждение',MB_OK+MB_ICONHAND);
      Exit;
    end;
    // 2019-01-08 заменил на вызов ф-ции
    {DM.Work.Close;
    DM.Work.Params.Clear;
    DM.Work.SQL.Clear;
    DM.Work.SQL.Add('UPDATE git SET "queue"=:par1 where _rowid_=:par2;');
    DM.Work.ParamByName('par1').AsInteger:=q2 ;
    DM.Work.ParamByName('par2').AsInteger:=row1;
    DM.Work.ExecSQL;
    }
    if not DM.GitSetField(row1,q2,'queue') then
      raise Exception.Create('Ошибка жеребьёвки (1)');
    //
    // 2019-01-08 заменил на вызов ф-ции
    {DM.Work.ParamByName('par1').AsInteger:=q1;
    DM.Work.ParamByName('par2').AsInteger:=row2;
    DM.Work.ExecSQL;
    }
    if not DM.GitSetField(row2,q1,'queue') then
      raise Exception.Create('Ошибка жеребьёвки (2)');
    //
    DM.OpenGit(row2);
  end;
end;

procedure TMainFrm.GitFireActionExecute(Sender: TObject);
var
  fi : String;
  val : Integer;
begin
  // снятие с гита (или возврат, если ошибочно)
  //
  if OverlapCB.Checked  then fi := 'place2'  else fi := 'place';
  GitDBGrid.DataSource.DataSet.Edit;
  if GitDBGrid.DataSource.DataSet.FieldByName(fi).AsInteger > FIRED_RIDER then
    val := GitDBGrid.DataSource.DataSet.FieldByName(fi).AsInteger - FIRED_RIDER
  else
    val :=  FIRED_RIDER +
       GitDBGrid.DataSource.DataSet.FieldByName('queue').AsInteger; //чтобы отличались
  GitDBGrid.DataSource.DataSet.FieldByName(fi).AsInteger := val;
  GitDBGrid.DataSource.DataSet.Post;
  // Надо записать в БД, иначе в перепрыжке пропадает после пересчета мест!!!
  DM.GitSetField(GitDBGrid.DataSource.DataSet.FieldByName('id').AsInteger,val,fi);
end;


procedure TMainFrm.GitDBGridContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
  //if Button = mbRight then
  // эмуляция левой кнопки мыши - выделить текущую ячейку (а если её нет?)
  //mouse_event(MOUSEEVENTF_LEFTDOWN Or MOUSEEVENTF_LEFTUP, 0, 0, 0, 0); - это для windows

  // !!!!! срабатывает только один раз !!! потом меню не появляется!!!
  // сделать вызов меню по MouseButtonUp()
end;

procedure TMainFrm.GitDBGridEditButtonClick(Sender: TObject);
var
  i, id :Integer;
  TName, ChField : String;
begin
  i:=-1;
  ChField:='';
  TName := '';
  if (TDBGrid(Sender).SelectedColumn.FieldName='groupname') then
  begin
    ChField := 'group';
    TName := 'Groups';
  end;
  if (TDBGrid(Sender).SelectedColumn.FieldName='lastname') then
  begin
    ChField := 'rider';
    TName := 'Riders';
  end;
  if (TDBGrid(Sender).SelectedColumn.FieldName='nickname') then
  begin
    ChField := 'horse';
    TName := 'Horses';
  end;
  id := TDBGrid(Sender).DataSource.DataSet.FieldByName('id').AsInteger;
  i  := TDBGrid(Sender).DataSource.DataSet.FieldByName(ChField).AsInteger;
  i  := ShowBasesDialog(TName,i);
  if i>0 then
  begin
    //if TDBGrid(Sender).DataSource.DataSet.State in [dsInsert] then
      // TDBGrid(Sender).DataSource.DataSet.Post;
    TDBGrid(Sender).DataSource.DataSet.Edit;
    TDBGrid(Sender).DataSource.DataSet.FieldByName(ChField).Value := i;
    TDBGrid(Sender).DataSource.DataSet.Post;
    DM.OpenGit(id);
  end;
end;

procedure TMainFrm.GitDBGridEditingDone(Sender: TObject);
begin
  // проверить, что введено положительное число (кроме маршр.по возр.сложности)...
  // время всегда положительное
  if (LowerCase(TDBGrid(Sender).SelectedColumn.FieldName)='gittime1') or
     (LowerCase(TDBGrid(Sender).SelectedColumn.FieldName)='gittime2') then
    if TDBGrid(Sender).SelectedColumn.Field.AsCurrency<=0 then
    begin
      Application.MessageBox('Ошибочное значение времени', 'Ошибка',MB_OK+MB_ICONERROR);
      // Обнулить, иначе значение останется в поле
      GitDBGrid.DataSource.DataSet.Edit;
      TDBGrid(Sender).SelectedColumn.Field.Value:=0;
      GitDBGrid.DataSource.DataSet.Post;
      Exit;
    end;
  // прыжки - положительные ш.о. (кроме баллов в возраст. сложности)
  if (LowerCase(LeftStr(TDBGrid(Sender).SelectedColumn.FieldName,7))='foul1_b') or
     (LowerCase(LeftStr(TDBGrid(Sender).SelectedColumn.FieldName,7))='foul2_b') then
    if DM.CurrRouteType <> ROUTE_GROW {когда можно минусы} then
      if TDBGrid(Sender).SelectedColumn.Field.AsInteger<0 then
      begin
        Application.MessageBox('Ошибочное значение', 'Ошибка',MB_OK+MB_ICONERROR);
        // Обнулить, иначе значение останется в поле
        GitDBGrid.DataSource.DataSet.Edit;
        TDBGrid(Sender).SelectedColumn.Field.Value:=0;
        GitDBGrid.DataSource.DataSet.Post;
        Exit;
      end;
  // если ОК - пересчёт
  CalcPenalties;
end;



procedure TMainFrm.GitDBGridMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  c: TColumn;
  i,off : Integer;
begin
  if Button = mbRight then
  begin
    // переместиться на запись, где кликнули мышкой (не работает при клике на пустой обл)
    TDBGrid(Sender).MouseToRecordOffset(X,Y,c,off);
    if off<>0 then
    begin
      // skip records from current with offset
      for i:=1 to abs(off) do
      begin
        if off>0 then
        begin
          if not TDBGrid(Sender).DataSource.DataSet.EOF then TDBGrid(Sender).DataSource.DataSet.Next;
        end
        else
          if not TDBGrid(Sender).DataSource.DataSet.BOF then TDBGrid(Sender).DataSource.DataSet.Prior;
      end;
    end;
    // теперь вызываем выпадающее меню
    PopupMenu1.PopUp;
  end;
end;


procedure TMainFrm.FileBaseHorsesActionExecute(Sender: TObject);
begin
  ShowBasesDialog('Horses',-1);
end;

function TMainFrm.ShowBasesDialog(BaseName: string; CurrentID: Integer): Integer;
begin
  Result := -1;
  with TBasesFrm.Create(self,BaseName, CurrentID) do
  begin
    try
      if ShowModal=mrOK then
      begin
        // GitDBGrid.DataSource.DataSet.Edit ?
        //Application.MessageBox(PAnsiChar(BasesDBGrid.DataSource.DataSet.FieldByName('id').AsString),'ROWID',MB_OK);
        if not BasesDBGrid.DataSource.DataSet.IsEmpty  then
          Result := BasesDBGrid.DataSource.DataSet.FieldByName('id').AsInteger;
      end;
    finally
      Free;
    end;
  end;
end;

procedure TMainFrm.FileBaseRidersActionExecute(Sender: TObject);
begin
  ShowBasesDialog('Riders',-1);
end;

procedure TMainFrm.FileExitActionExecute(Sender: TObject);
begin
  Close;
end;


procedure TMainFrm.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose:=False;
  if Application.MessageBox('Уже уходите?','Подтверждение',MB_YESNO+MB_DEFBUTTON2+MB_ICONQUESTION)=idYes then
  begin
    CanClose:=True;
  end;
end;

procedure TMainFrm.GitClearResActionExecute(Sender: TObject);
begin
  if Application.MessageBox(PAnsiChar('Вы действительно хотите очистить результаты гита выбранного участника? '+
     #13#10+'id='+GitDBGrid.DataSource.DataSet.FieldByName('id').AsString+' Всадник: '+
     GitDBGrid.DataSource.DataSet.FieldByName('lastname').AsString),
     'Подтверждение удаления',MB_YESNO+MB_ICONQUESTION+MB_DEFBUTTON2)=IDYES then
    if DM.ClearResults then
      GitGridRefreshVisibility;
end;

procedure TMainFrm.GitDelActionExecute(Sender: TObject);
begin
  // перестраховка
  if (DM.CurrentTournament<=0) or (DM.CurrentRoute<=0) then Exit;
  if not Assigned(GitDBGrid.SelectedColumn) then Exit;
  if DM.Git.IsEmpty then Exit;
  //
  if Application.MessageBox(PAnsiChar('Вы действительно хотите удалить выбранную строку? '+
     #13#10+'id='+GitDBGrid.DataSource.DataSet.FieldByName('id').AsString+' Всадник: '+
     GitDBGrid.DataSource.DataSet.FieldByName('lastname').AsString),
     'Подтверждение удаления',MB_YESNO+MB_ICONQUESTION+MB_DEFBUTTON2)=IDYES then
  begin
    DM.DelGit(GitDBGrid.DataSource.DataSet.FieldByName('id').AsInteger);
    GitDBGrid.Enabled:=not DM.Git.IsEmpty;
  end;
end;

procedure TMainFrm.MaxTime2EditExit(Sender: TObject);
begin
  CalcMaxTimeOver;
end;

procedure TMainFrm.MaxTimeEditExit(Sender: TObject);
begin
  CalcMaxTime;
end;


procedure TMainFrm.Barriers1SpinEditChange(Sender: TObject);
begin
  GitGridRefreshVisibility;
end;

procedure TMainFrm.Barriers2SpinEditChange(Sender: TObject);
begin
  GitGridRefreshVisibility;
end;


procedure TMainFrm.RouteAddActionExecute(Sender: TObject);
begin
end;


procedure TMainFrm.RouteSelectActionExecute(Sender: TObject);
var
  TempRoute : integer;
  x,y: Integer;
begin
  TempRoute:=ShowBasesDialog('Routes',DM.CurrentRoute);
  if (TempRoute>0) {and (DM.CurrentRoute<>TempRoute)} then
  begin
    // маршрут выбран - заполним поля

    { в OpenRoutes всё это делаем
    DM.CurrentRoute:=TempRoute;
    DM.CurrRouteType:=DM.Routes.FieldByName('route_type').AsInteger;
    DM.CurrRouteName:=DM.Routes.FieldByName('routename').AsString;
    }
    SetColNames;
    //
    OverlapCB.Visible:=(DM.CurrRouteType=ROUTE_OVERLAP);
    //
    // обновить содержимое контролов, связанных с маршрутом
    RouteNameLabel.Caption := DM.CurrRouteName; // заполнить строкой названия
    // название маршрута в статусной строке
    //2019-01-16 работать с константами, а не с индексами
    {было    if (DM.CurrRouteType>=0) and (DM.CurrRouteType<RouteTypeSL.Count-1) then
                       StatusBar1.Panels[1].Text:= RouteTypeSL[DM.CurrRouteType];
    }
//2019-01-28
{$IFDEF WIN64}
    x := RouteTypeSL.IndexOfObject(TObject(Int64(DM.CurrRouteType)));
{$ELSE}
    x := RouteTypeSL.IndexOfObject(TObject(Integer(DM.CurrRouteType)));
{$ENDIF}
    if x>0 then StatusBar1.Panels[1].Text:= RouteTypeSL[x];
    //-
    // в диалоге выбора уже открыли: DM.OpenRoutes(DM.CurrentRoute);
    VelocityCB1.ItemIndex := DM.Routes.FieldByName('velocity1').AsInteger;
    VelocityCB2.ItemIndex := DM.Routes.FieldByName('velocity2').AsInteger;
    DistanceEdit1.Text := DM.Routes.FieldByName('distance1').AsString;
    DistanceEdit2.Text := DM.Routes.FieldByName('distance2').AsString;
    TimePenaltyCB.ItemIndex := DM.Routes.FieldByName('result_type').AsInteger;
    //todo: DbaseError - Routes: barriers2 field not found !!! ?????
    // пришлось поставить костыль:
    x:= DM.Routes.FieldByName('barriers1').AsInteger;
    y:= DM.Routes.FieldByName('barriers2').AsInteger;
    Barriers1SpinEdit.Value:= x; //DM.Routes.FieldByName('barriers1').AsInteger;
    Barriers2SpinEdit.Value:= y; //DM.Routes.FieldByName('barriers2').AsInteger;
    //
    DM.OpenGit(-1);
    GitDBGrid.Enabled:=not DM.Git.IsEmpty;
    OverlapCB.Checked:=False; //если были на перепрыжке, то вернуть основной вид
    DM.CurrGitOrder:=concour_DM.GIT_ORDER_Q;
    //
    GitGridRefreshVisibility;
  end;
end;


procedure TMainFrm.TimePenaltyCBEditingDone(Sender: TObject);
begin
  // 2019-01-21 используем поле result_type
  //редактирование закончено? Запишем в БД
  if not DM.RouteSetField(-1,(TComboBox(Sender).ItemIndex),'result_type') then
    Application.MessageBox('Значение не удалось записать в БД!','Ошибка',MB_OK);
  //
  GitGridRefreshVisibility;
end;

procedure TMainFrm.VelocityCB1EditingDone(Sender: TObject);
begin
  //редактирование закончено? Запишем в БД
  if not DM.RouteSetField(-1,TComboBox(Sender).ItemIndex,'velocity1') then
    Application.MessageBox('Значение не удалось записать в БД!','Ошибка',MB_OK);
  //
end;

procedure TMainFrm.VelocityCB2Change(Sender: TObject);
begin
  CalcMaxTimeOver;
end;

procedure TMainFrm.VelocityCB1Change(Sender: TObject);
begin
  CalcMaxTime;
end;

procedure TMainFrm.VelocityCB2EditingDone(Sender: TObject);
begin
  //редактирование закончено? Запишем в БД
  if not DM.RouteSetField(-1,TComboBox(Sender).ItemIndex,'velocity2') then
    Application.MessageBox('Значение не удалось записать в БД!','Ошибка',MB_OK);
  //
end;

procedure TMainFrm.CalcPenalties;
var
  i : Integer;
  ii, jj, it1, it2, c : Currency;
begin
  //todo: считать только видимые ячейки ?
  ii:=0; jj:=0;
  if not GitDBGrid.DataSource.DataSet.Active then Exit;
  if GitDBGrid.DataSource.DataSet.IsEmpty then Exit;
  if not Assigned(GitDBGrid.SelectedColumn) then Exit;
  // пересчёт суммы штрафов после изменения ячейки со штрафом
  if lowercase(LeftStr(GitDBGrid.SelectedColumn.FieldName,7))='gittime' then
  begin
    it1:=0; it2:=0;
    // подсчет штрафов за превышение времени
    //
    // основное прохождение
    case TimePenaltyCB.ItemIndex of
      0: begin
           // 1 очко за каждые 4 (даже неполные) секунды превышения
           // т.е. превышение округляем в большую сторону и делим на 4
           c:= 0.0;
           if GitDBGrid.DataSource.DataSet.FieldByName('gittime1').AsString<>'' then
           begin;
             c := GitDBGrid.DataSource.DataSet.FieldByName('gittime1').AsCurrency -
                 StrToCurr(MaxTimeEdit.Text);
             if c>0 then
             begin
               it1 := (ceil(c) div 4);
               if (ceil(c) Mod 4)<>0 then it1:=it1+1;
             end;
          end;
         end;
      1: begin
           // за каждую (даже неполную) секунду превышения начисляется 0.25 штрафных очков
           c:= 0.0;
           if GitDBGrid.DataSource.DataSet.FieldByName('gittime1').AsString<>'' then
           begin;
             c := GitDBGrid.DataSource.DataSet.FieldByName('gittime1').AsCurrency -
                 StrToCurr(MaxTimeEdit.Text);
             if c>0 then it1 := ceil(c)*0.25;
           end;
         end;
    end;
    // перепрыжка
    if OverlapCB.Checked then
    begin
      case Time2PenaltyCB.ItemIndex of
        0: begin
             // 1 очко за каждые 4 (даже неполные) секунды превышения
             // т.е. превышение округляем в большую сторону и делим на 4
             // !!! обычно в перепрыжке не бывает, но...
             c:= 0.0;
             if GitDBGrid.DataSource.DataSet.FieldByName('gittime2').AsString<>'' then
             begin;
               c := GitDBGrid.DataSource.DataSet.FieldByName('gittime2').AsCurrency -
                   StrToCurr(MaxTime2Edit.Text);
               if c>0 then
               begin
                 it2 := (ceil(c) div 4);
                 if (ceil(c) Mod 4)<>0 then it2:=it2+1 else it2:=it2-1;
               end;
             end;
           end;
        1: begin  // 1=1
             // одно очко за каждую начатую секунду превышения (?)
             c:= 0.0;
             if GitDBGrid.DataSource.DataSet.FieldByName('gittime2').AsString<>'' then
             begin;
               c := GitDBGrid.DataSource.DataSet.FieldByName('gittime2').AsCurrency -
                  StrToCurr(MaxTime2Edit.Text);
               if c>0 then it2 := ceil(c) ;
             end;
           end;
        2: begin
             // за каждую (даже неполную) секунду превышения начисляется 0.25 штрафных очков
             // !!! обычно в перепрыжке не бывает, но...
             c:= 0.0;
             if GitDBGrid.DataSource.DataSet.FieldByName('gittime2').AsString<>'' then
             begin;
               c := GitDBGrid.DataSource.DataSet.FieldByName('gittime2').AsCurrency -
                   StrToCurr(MaxTime2Edit.Text);
               if c>0 then it2 := ceil(c)*0.25;
             end;
           end;
      end;
    end; // if Overlap
  end
  else
  begin
    // не менялись - просто возьмём старые значения
    it1 := GitDBGrid.DataSource.DataSet.FieldByName('foul1_time').AsCurrency;
    it2 := GitDBGrid.DataSource.DataSet.FieldByName('foul2_time').AsCurrency;
  end;
  //---
  //if lowercase(LeftStr(GitDBGrid.SelectedColumn.FieldName,4))='foul' then
  // всегда пересчитывать ?
  begin
    ii := 0;
    jj := 0;
    i:=1;
    while i<=Barriers1SpinEdit.Value do
    begin
      if GitDBGrid.DataSource.DataSet.FieldByName('foul1_b'+Trim(IntToStr(i))).AsString<>'' then
         ii := ii + GitDBGrid.DataSource.DataSet.FieldByName('foul1_b'+Trim(IntToStr(i))).AsCurrency;
      Inc(i);
    end;
    if OverlapCB.Checked then
    begin
      i:=1;
      while i<=Barriers2SpinEdit.Value do
      begin
        if (GitDBGrid.DataSource.DataSet.FieldByName('foul2_b'+Trim(IntToStr(i))).AsString<>'') then
          jj := jj + GitDBGrid.DataSource.DataSet.FieldByName('foul2_b'+Trim(IntToStr(i))).AsCurrency;
        Inc(i);
      end;
    end;
  end;
//------
  // 2019-02-14 учесть Joker
  //todo: как-то проверить, что Barriers1SpinEdit.Value < 15 ?
  if (DM.CurrRouteType = ROUTE_GROW) and (JokerCB.Checked) then
  begin
    ii := ii + GitDBGrid.DataSource.DataSet.FieldByName('foul1_b15').AsCurrency;
  end;
//------
  // пишем в таблицу
  GitDBGrid.DataSource.DataSet.Edit;
  GitDBGrid.DataSource.DataSet.FieldByName('foul1_time').AsCurrency:= it1;
  GitDBGrid.DataSource.DataSet.FieldByName('foul2_time').AsCurrency:= it2;
  GitDBGrid.DataSource.DataSet.FieldByName('sumfouls1').AsCurrency:= ii;
  GitDBGrid.DataSource.DataSet.FieldByName('sumfouls2').AsCurrency:= jj;
  //2019-01-21 для маршр. по возраст. штраф за время - вычитается из суммы баллов
  if DM.CurrRouteType = ROUTE_GROW then
  begin
    GitDBGrid.DataSource.DataSet.FieldByName('totalfouls1').AsCurrency:= ii-it1;
    GitDBGrid.DataSource.DataSet.FieldByName('totalfouls2').AsCurrency:= jj-it2;
  end
  else
  begin
    GitDBGrid.DataSource.DataSet.FieldByName('totalfouls1').AsCurrency:= ii+it1;
    GitDBGrid.DataSource.DataSet.FieldByName('totalfouls2').AsCurrency:= jj+it2;
  end;
  GitDBGrid.DataSource.DataSet.FieldByName('sumfouls').AsCurrency:=ii+jj+it1+it2;
  GitDBGrid.DataSource.DataSet.Post;
    //--
  LeaderLabel.Caption := DM.GetLeader(OverlapCB.Checked);
end;


procedure TMainFrm.CalcMaxTime;
begin
  //todo: если меняется контрольное время ПОСЛЕ внесения данных по времени прохождения участников,
  // то штрафы за превышение времени не пересчитываются!!!!
  // Это потому, что в CalcPenalties стоит условие работы только на столбцах таблицы
  // В этом случае надо на всех участниках (на столбце времени) войти/выйти в/из реж.редактирования
  if Trim(DistanceEdit1.Text)='' then Exit;
  MaxTimeEdit.Text:=IntToStr(Ceil(StrToFloat(DistanceEdit1.Text)*60 / StrToInt(VelocityCB1.Text)));
end;

procedure TMainFrm.CalcMaxTimeOver;
begin
  if Trim(DistanceEdit2.Text)='' then Exit;
  MaxTime2Edit.Text:=IntToStr(Ceil(StrToFloat(DistanceEdit2.Text)*60 / StrToInt(VelocityCB2.Text)));
end;

procedure TMainFrm.CalcPlaces;
var
  i,g, ocounter, prevId : Integer;
  s : Currency;
  WasOver : Boolean;
begin
  OverlapCB.Checked:=False;
  GitDBGrid.BeginUpdate;
  case DM.CurrRouteType of
    ROUTE_CLASSIC:
       // classic - по каждому зачёту: ранжируются по итоговым штрафным очкам(totalfouls1),
       //  а при совпадении - по времени прохождения
       //!!! если совпало и то, и другое, то на № места повлияет порядковый номер выступления !!!
       //старая версия - ниже в комментах... пока других указаний не поступало...
       begin
         DM.Work2.Close;
         DM.Work2.Params.Clear;
         DM.Work2.SQL.Text := 'select id,"group",totalfouls1,gittime1,place from v_git '+
           'where tournament=:par1 and route=:par2 order by "group",totalfouls1,gittime1,queue;';
         DM.Work2.ParamByName('par1').AsInteger:=DM.CurrentTournament;
         DM.Work2.ParamByName('par2').AsInteger:=DM.CurrentRoute;
         //----
         DM.Work.Close;
         DM.Work.Params.Clear;
         DM.Work.SQL.Text := 'update git set place=:par1 where _rowid_=:par2;';
         //--
         try
           try
             DM.Work2.Open;
             if not DM.Work2.IsEmpty then
             begin
               DM.Work2.First;
               i := 0;
               g := DM.Work2.FieldByName('group').AsInteger;
               while not DM.Work2.EOF do
               begin
                 if DM.Work2.FieldByName('place').AsInteger < FIRED_RIDER then
                 begin
                   Inc(i);
                   DM.Work.ParamByName('par1').AsInteger:=i;
                   DM.Work.ParamByName('par2').AsInteger:=DM.Work2.FieldByName('id').AsInteger;
                   DM.Work.ExecSQL;
                 end;
                 //***
                 DM.Work2.Next;
                 if g <> DM.Work2.FieldByName('group').AsInteger then
                 begin
                   // начало нового зачёта
                   g := DM.Work2.FieldByName('group').AsInteger;
                   i := 0;
                 end;
               end;
             end;
           except
             Application.MessageBox('Не удалось нормально завершить процедуру','Ошибка',MB_OK+MB_ICONERROR);
           end;
         finally
         end;
       end; //end case ROUTE_CLASSIC
    ROUTE_OVERLAP:
       // классика с перепрыжкой:
       // для каждого зачета
       // на первом этапе ранжируются по сумме ш.о. и штрафов за превышение времени (totalfouls1)
       // результат пишется в place.
       // Если на первых местах одинаковые ш.о., то перепрыжка (этап 2)
       // на втором этапе места присваивать как в классике (case 0), + доп.результат в place2
       //
       // 2018-12-19 добавил условие отбора в перепрыжку: (время 1 гита >0)
       begin
         WasOver:=False;
         DM.Work2.Close;
         DM.Work2.Params.Clear;
         DM.Work2.SQL.Text := 'select id,"group",totalfouls1,place,overlap from v_git where '+
                       'tournament=:par1 and route=:par2 and gittime1>0 order by "group",totalfouls1,queue;';
         DM.Work2.ParamByName('par1').AsInteger:=DM.CurrentTournament;
         DM.Work2.ParamByName('par2').AsInteger:=DM.CurrentRoute;
         //----
         //!!! затираются данные о снятии с гита в перепрыжке!!! (place2=0)
         //DM.Work.SQL.Text := 'update git set place=:par1, place2=0 where _rowid_=:par2;';
         // 2018-09-13 перенес обнуление place2 с учётом FIRE_RIDER в проц. CalcPlacesOver
         //
         //2019-01-08 очистить расчетный список перепрыжчиков - так он будет обновляться
         DM.Work.SQL.Text := 'update or rollback git set overlap=0 where tournament=:par1 and route=:par2 '+
                             ' and overlap=1;'; //только =1 !!!
         DM.Work.ParamByName('par1').AsInteger := DM.CurrentTournament;
         DM.Work.ParamByName('par2').AsInteger := DM.CurrentRoute;
         DM.Work.ExecSQL;
         //
         // Work... вынесено до цикла, а work.ExexSQL- внутри
         DM.Work.Close;
         DM.Work.Params.Clear;
         DM.Work.SQL.Text := 'update git set place=:par1 where _rowid_=:par2;';
         //--
         try
           DM.Work2.Open;
           if not DM.Work2.IsEmpty then
           begin
             DM.Work2.First;
             i := 0;       // нумерация мест (для каждого зачёта - своя)
             s := -1;      // сумма ш.о. предыдущего участника
             g := -1;      // № текущего зачёта
             prevId:=-1;
             ocounter:=0; // счетчик участников перепрыжки для каждого зачёта
                          // чтобы НЕ первые места сдвигались ниже перепрыжчиков
             //todo: 2018-12-26 в версии с полем overlap вместо ocounter можно
             //считать select count(*)... where overlap=1 (в DM сделать функцию)
             // но с переменной - быстрее (нет обращений к БД)
             while not DM.Work2.EOF do
             begin
               if g <> DM.Work2.FieldByName('group').AsInteger then // начало нового зачёта
               begin
                 //если к началу нового зачёта predID не -1, значит не было повода
                 // поставить признак перепрыжки (например, один участник в зачёте)
                 // можно смело присваивать номер первой записи след.зачёта
                 prevId:=DM.Work2.FieldByName('id').AsInteger;
                 //--- теперь запоминаем параметры нового зачёта ---
                 g := DM.Work2.FieldByName('group').AsInteger;
                 s := DM.Work2.FieldByName('totalfouls1').AsCurrency;
                 i := 0;
                 ocounter:=0;
               end;//endif -- смена зачёта
               //--- проигнорировать снятых с гита,
               // и "быстрых" перепрыжчиков (2019-01-08)
               // остальных обработать
               if (DM.Work2.FieldByName('place').AsInteger < FIRED_RIDER) then
               begin
                 // -- перепрыжка для первых мест при совпадении общих ш.о. (totalfouls1)
                 if (i = 1) and
                    (s = DM.Work2.FieldByName('totalfouls1').AsCurrency) then
                 begin // будут участвовать в перепрыжке
                   //2019-01-08 быстрых перепрыжчиков не берём, но считаем!
                   if DM.Work2.FieldByName('overlap').AsInteger < OVER_FAST then
                   begin
                     // 2018-12-26
                     WasOver:=True;
                     DM.GitSetField(DM.Work2.FieldByName('id').AsInteger,OVER_CALC,'overlap');
                     if prevId>0 then
                     begin
                       //не забыть изменить первую запись в зачёте, но только один раз!
                       DM.GitSetField(prevId,OVER_CALC,'overlap');
                       prevId:=-1; //исключить повторную запись (хоть и не существенно)
                       //todo: а не надо ли увеличить ocounter ?
                     end;
                   end; //<over_fast
                   Inc(ocounter);
                   // i - не меняется, остаётся =1
                 end
                 else
                 begin
                   // совпадения закончились, или место не первое - дальше номера мест увеличим
                   if ocounter>0 then
                   begin
                     i:=i+ocounter;
                     ocounter:=0;
                   end;
                   Inc(i);
                 end;
                 s:= DM.Work2.FieldByName('totalfouls1').AsCurrency;
                 //записать место
                 DM.GitSetField(DM.Work2.FieldByName('id').AsInteger,i,'place');
                 //***
               end;   //endif отбор без снятых с гита
               DM.Work2.Next;
             end;   // end while
           end; //endif (not Work2.Empty)
         except
           Application.MessageBox('Не удалось нормально завершить процедуру','Ошибка',MB_OK+MB_ICONERROR);
         end;
         if WasOver then
           Application.MessageBox('Расчетная ПЕРЕПРЫЖКА!','Информация',MB_OK+MB_ICONINFORMATION);
       end; //end case ROUTE_OVERLAP;
    ROUTE_GROW:
       // маршрут по возрастающей сложности - по каждому зачёту:
       //  ранжируются по итоговым суммам баллов(totalfouls1), мах Сумма - 1 место
       //  а при совпадении сумм, ранжируем по времени прохождения (меньшее время - лучше)
       //!!! если совпало и то, и другое, то на № места повлияет порядковый номер выступления !!!
       //--
       //--- алгоритм отличается от classic только порядком сортировки, но пока вынесен отдельно... ---
       begin
         DM.Work2.Close;
         DM.Work2.Params.Clear;
         DM.Work2.SQL.Text := 'select id,"group",totalfouls1,gittime1,place from v_git '+
           ' where tournament=:par1 and route=:par2 '+
           ' order by "group", totalfouls1 DESC, gittime1, queue;';
         DM.Work2.ParamByName('par1').AsInteger:=DM.CurrentTournament;
         DM.Work2.ParamByName('par2').AsInteger:=DM.CurrentRoute;
         //----
         DM.Work.Close;
         DM.Work.Params.Clear;
         DM.Work.SQL.Text := 'update git set place=:par1 where _rowid_=:par2;';
         //--
         try
           try
             DM.Work2.Open;
             if not DM.Work2.IsEmpty then
             begin
               DM.Work2.First;
               i := 0;
               g := DM.Work2.FieldByName('group').AsInteger;
               while not DM.Work2.EOF do
               begin
                 if DM.Work2.FieldByName('place').AsInteger < FIRED_RIDER then
                 begin
                   Inc(i);
                   DM.Work.ParamByName('par1').AsInteger:=i;
                   DM.Work.ParamByName('par2').AsInteger:=DM.Work2.FieldByName('id').AsInteger;
                   DM.Work.ExecSQL;
                 end;
                 //***
                 DM.Work2.Next;
                 if g <> DM.Work2.FieldByName('group').AsInteger then
                 begin
                   // начало нового зачёта
                   g := DM.Work2.FieldByName('group').AsInteger;
                   i := 0;
                 end;
               end;
             end;
           except
             Application.MessageBox('Не удалось нормально завершить процедуру','Ошибка',MB_OK+MB_ICONERROR);
           end;
         finally
         end;
       end; //end case ROUTE_GROW;
  end;
  DM.CurrGitOrder:=concour_DM.GIT_ORDER_R;
  GitDBGrid.EndUpdate;
end;

procedure TMainFrm.CalcPlacesOver;
var
  i,g : Integer;
begin
  //todo: нужно ли предусмотреть?
  // при изменении к-ва перепрыжчиков места должны пересчитыватья (и place, и place2)
  //а в "быструю перепрыжку" могут попасть не 1-е места основного гита...
  //
  try
    // в списке только участники перепрыжки
    GitDBGrid.BeginUpdate;
    //
    // перед началом подведения итогов надо обнулить предыдущие результаты
    // т.к. непустое значение поля place2 будет мешать правильной расстановке мест
    // (кроме снятых с гита)
    DM.Work.Close;
    DM.Work.Params.Clear;
    // 2018-12-26 условие отбора в перепрыжку: overlap>0
    DM.Work.SQL.Text := 'update or rollback git set place2=0 where tournament=:par1 and route=:par2 '+
                        ' and place2<:par3 and overlap>0;';
    DM.Work.ParamByName('par1').AsInteger := DM.CurrentTournament;
    DM.Work.ParamByName('par2').AsInteger := DM.CurrentRoute;
    DM.Work.ParamByName('par3').AsInteger := FIRED_RIDER;
    DM.Work.ExecSQL;
    //
    DM.Work2.Close;
    DM.Work2.Params.Clear;
    // 2018-12-26 условие отбора в перепрыжку: overlap>0
    // упорядочен по place2, чтобы после пересчета мест был сразу ранжирован...
    DM.Work2.SQL.Text := 'select id,"group",place,place2,totalfouls2,gittime2 from v_git '+
      ' where tournament=:par1 and route=:par2 and overlap>0 order by "group",place2,totalfouls2,gittime2,queue;';
    DM.Work2.ParamByName('par1').AsInteger := DM.CurrentTournament;
    DM.Work2.ParamByName('par2').AsInteger := DM.CurrentRoute;
    //----
    DM.Work.Close;
    DM.Work.Params.Clear;
    DM.Work.SQL.Text := 'update git set place=:par1,place2=:par2 where _rowid_=:par3;';
    //--
    try
      DM.Work2.Open;
      if not DM.Work2.IsEmpty then
      begin
        DM.Work2.First;
        i := 1;
        g := DM.Work2.FieldByName('group').AsInteger;
        while not DM.Work2.EOF do
        begin
          //в place кладём № места перепрыжки
          // и в place2 - место, если не был снят с гита
          DM.Work.ParamByName('par1').AsInteger:=i;
          //не забываем снятых с гита - пишем в place их значения
          if  DM.Work2.FieldByName('place2').AsInteger<FIRED_RIDER then
            DM.Work.ParamByName('par2').AsInteger:=i
          else
            DM.Work.ParamByName('par2').AsInteger:=DM.Work2.FieldByName('place2').AsInteger;
          DM.Work.ParamByName('par3').AsInteger:=DM.Work2.FieldByName('id').AsInteger;
          DM.Work.ExecSQL;
          //***
          Inc(i);
          DM.Work2.Next;
          if g<> DM.Work2.FieldByName('group').AsInteger then
          begin
            g := DM.Work2.FieldByName('group').AsInteger;
            i:=1;
          end;
        end;
      end;
    except
     Application.MessageBox('Не удалось нормально завершить процедуру','Ошибка',MB_OK+MB_ICONERROR);
    end;
  finally
    GitDBGrid.EndUpdate(false); //false, т.к. потом НД будет переоткрыт
    DM.Work.Close;
    DM.Work2.Close;
  end;
end;

procedure TMainFrm.SetColNames;
var
  i,k1,k2: Integer;
  s : String;
begin
  // заполнить заголовки столбцов из DM.ColNames
  k1 := 1;
  k2 := 1;
  for i:=0 to GitDBGrid.Columns.Count-1 do
  begin
    if (LowerCase(LeftStr(GitDBGrid.Columns[i].FieldName,7)) = 'foul1_b') then
    begin
      s := DM.ColNames.Values[GitDBGrid.Columns[i].FieldName];
      if s<>'' then GitDBGrid.Columns[i].Title.Caption:=s
      else GitDBGrid.Columns[i].Title.Caption:=Trim(IntToStr(k1));
      Inc(k1);
    end;
  //todo: пока продублировал для перепрыжки отдельно... но потом оптимизировать
  // чтобы перепрыжечные препятствия нумеровались с 1
    if (LowerCase(LeftStr(GitDBGrid.Columns[i].FieldName,7)) = 'foul2_b') then
    begin
      s := DM.ColNames.Values[GitDBGrid.Columns[i].FieldName];
      if s<>'' then GitDBGrid.Columns[i].Title.Caption:=s
      else GitDBGrid.Columns[i].Title.Caption:=Trim(IntToStr(k2));
      Inc(k2);
    end;
  end;
end;

procedure TMainFrm.SetJokerVisibility;
var
  i: Integer;
begin
  // на всякий случай ;)
  if DM.CurrRouteType <> ROUTE_GROW then Exit;
  //
  for i:=0 to GitDBGrid.Columns.Count-1 do
    if (LowerCase(GitDBGrid.Columns[i].FieldName) = 'foul1_b15') then
    begin
      GitDBGrid.Columns[i].Visible:=JokerCB.Checked;
      //todo: надо ли обнулять данные? пока не будем...
      // может потребоваться, чтобы не хранить в БД состояние JokerCB
      //--
      // переспросить, а потом у всех очистить Джокеров
{      if not JokerCB.Checked then
        if Application.MessageBox(PAnsiChar('ВНИМАНИЕ!'+#13#10+
            'У ВСЕХ участников очки в колонке Joker будут обнулены!'),
            'Подтверждение',MB_YESNO+MB_ICONASTERISK)=IDYES  then
        begin
          DM.GitClearJoker;
          DM.OpenGit(-1);
        end;
}
    end;
end;



end.

