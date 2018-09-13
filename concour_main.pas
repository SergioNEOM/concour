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
  FIRED_RIDER    = 9000;         // снятым участникам добавляется константа к полю place
type

  { TMainFrm }

  TMainFrm = class(TForm)
    GitResultsAction: TAction;
    GitShuffleAction: TAction;
    FilePrintAction: TAction;
    Barriers1SpinEdit: TSpinEdit;
    Barriers2SpinEdit: TSpinEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    CalcOverlapBitBtn: TBitBtn;
    CalcPlacesBitBtn: TBitBtn;
    DistanceEdit1: TEdit;
    DistanceEdit2: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
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
    MenuItemTotal: TMenuItem;
    MenuItem9: TMenuItem;
    OverlapCB: TCheckBox;
    PageControl1: TPageControl;
    Panel1: TPanel;
    GitClearResAction: TAction;
    GitDelAction: TAction;
    GitFireAction: TAction;
    ReportsPopup: TPopupMenu;
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
    RouteDelAction: TAction;
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
    procedure BitBtn1Click(Sender: TObject);
    procedure FilePrintActionExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CalcOverlapBitBtnClick(Sender: TObject);
    procedure CalcPlacesBitBtnClick(Sender: TObject);
    procedure GitResultsActionExecute(Sender: TObject);
    procedure GitShuffleActionExecute(Sender: TObject);
    procedure MenuItem14Click(Sender: TObject);
    procedure MenuItem21Click(Sender: TObject);
    procedure MenuItem22Click(Sender: TObject);
    procedure MenuItemTotalClick(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure OverlapCBChange(Sender: TObject);
    procedure RepSpeedButton1Click(Sender: TObject);
    procedure RepSpeedButtonClick(Sender: TObject);
    procedure ShuffleBitBtnClick(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
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
    procedure RouteDelActionExecute(Sender: TObject);
    procedure RouteSelectActionExecute(Sender: TObject);
    procedure VelocityCB2Change(Sender: TObject);
    procedure VelocityCB1Change(Sender: TObject);
  private

  public
    RangedView : Boolean;
    SumPenalty: Currency;
    OverList:   String;
    RouteTypeSL: TStringList;
    procedure GitGridRefreshVisibility;
    function ShowBasesDialog(BaseName: string; CurrentID: Integer): Integer;
    procedure CalcMaxTime;
    procedure CalcMaxTimeOver;
    procedure CalcPenalties;
    procedure CalcPlaces;
    procedure CalcPlacesOver;
  end;

var
  MainFrm: TMainFrm;

implementation

{$R *.lfm}
uses LCLType, db, math,  concour_DM,  concour_bases,  concour_rep,
  concour_export;

{ TMainFrm }

procedure TMainFrm.FormCreate(Sender: TObject);
var
i: Integer;
c: TColumn;
begin
  RouteTypeSL := TStringList.Create;
  RouteTypeSL.Add('КЛАССИКА');                 // 0
  RouteTypeSL.Add('КЛАССИКА С ПЕРЕПРЫЖКОЙ');   // 1
  RouteTypeSL.Add('2 ФАЗЫ');                   // 2
  RouteTypeSL.Add('ПО ВОЗРАСТАЮЩЕЙ СЛОЖНОСТИ');// 3
  RouteTypeSL.Add('ПО ТАБЛИЦЕ С');             // 4
  RouteTypeSL.Add('НА МАКСИМУМ БАЛЛОВ');       // 5
  RouteTypeSL.Add('2 ГИТА');                   // 6
  //
  // препятствия перепрыжки
  GitDBGrid.BeginUpdate;
  for i:=1 to Barriers2SpinEdit.MaxValue do
  try
    c := TColumn(GitDBGrid.Columns.Insert(GitDBGrid.Columns.Count-7));
    c.FieldName:='foul2_b'+Trim(IntToStr(i));
    c.DisplayFormat:='###';
    c.Tag:=ROUTE_OVERLAP;
    c.Title.Alignment:=taCenter;
    c.Title.MultiLine:=True;
    c.Title.Caption := 'П'+#10#13+IntToStr(i);
    c.Width:=40;
    c.Visible := false;
  finally
    c := nil;
  end;
  GitDBGrid.EndUpdate(true);
  //----
  OverList:='';
  RangedView:=False;
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
  DM.OpenGit(-1,DM.CurrentTournament,DM.CurrentRoute);
  GitDBGrid.Enabled:=not DM.Git.IsEmpty;
end;


procedure TMainFrm.GitGridRefreshVisibility;
var
  v: Boolean;
  i: Integer;
begin
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
    GitDBGrid.Columns[i].Visible:= v and ((GitDBGrid.Columns[i].Tag and (1 shl DM.CurrRouteType) )>0);
  end;
  //--
  CalcPenalties;
  //--
  GitDBGrid.EndUpdate(true);
end;


procedure TMainFrm.BitBtn1Click(Sender: TObject);
begin
  if (DM.CurrentTournament<=0) or  (DM.CurrentRoute<=0) then Exit;
  DM.AppendGit;
  GitDBGrid.Enabled:=not DM.Git.IsEmpty;
end;

procedure TMainFrm.FilePrintActionExecute(Sender: TObject);
begin
    {$IFDEF WINDOWS}
    with TExpFrm.Create(self) do
    begin
      try
        if ShowModal=mrOK then
        begin
        end;
      finally
        Free;
      end;
    end;
    {$ENDIF}
    //****
    {$IFDEF UNIX}
    ReportsPopup.PopUp;
    {$ENDIF}
end;

procedure TMainFrm.FormDestroy(Sender: TObject);
begin
  RouteTypeSL.Free;
end;


procedure TMainFrm.CalcOverlapBitBtnClick(Sender: TObject);
begin
  CalcPlacesOver;
  DM.OpenGit(-1,DM.CurrentTournament,DM.CurrentRoute,True,True);
end;

procedure TMainFrm.CalcPlacesBitBtnClick(Sender: TObject);
begin
  GitResultsActionExecute(Sender);
end;

procedure TMainFrm.GitResultsActionExecute(Sender: TObject);
begin
  CalcPlaces;
  DM.OpenGit(-1,DM.CurrentTournament,DM.CurrentRoute,True);
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
    DM.OpenGit(-1,DM.CurrentTournament,DM.CurrentRoute);
    //GitDBGrid.Enabled:=not DM.Git.IsEmpty;
  finally
    GitDBGrid.EndUpdate;
    sl.Free;
  end;
end;

procedure TMainFrm.MenuItem14Click(Sender: TObject);
begin

end;


procedure TMainFrm.MenuItem21Click(Sender: TObject);
begin
  // стартовый протокол
  RepInitialize;
  RepWriteBody(1);
  RepDeploy;
  RepView;
end;

procedure TMainFrm.MenuItem22Click(Sender: TObject);
begin
  // судейский протокол (колонки для ш.о.)
  RepInitialize;
  RepWriteBody(2);
  RepDeploy;
  RepView;
end;

procedure TMainFrm.MenuItemTotalClick(Sender: TObject);
begin
  // Итоговый отчет
  // если в режиме перепрыжки - уходим (печатаем из основного реж)
  if OverlapCB.Checked then
  begin
    ShowMessage('Для печати иогового протокола выйдите из режима перепрыжки');
    Exit;
  end;
  RepInitialize;
  //RepWriteHeader;
  RepWriteBody(0);
  //RepWriteData;
  RepDeploy;
  RepView;
end;

procedure TMainFrm.MenuItem7Click(Sender: TObject);
begin

end;


procedure TMainFrm.Barriers2SpinEditEditingDone(Sender: TObject);
begin
  GitGridRefreshVisibility;
end;

procedure TMainFrm.Barriers1SpinEditEditingDone(Sender: TObject);
begin
  GitGridRefreshVisibility;
end;

procedure TMainFrm.OverlapCBChange(Sender: TObject);
begin
  if OverlapCB.Checked then PageControl1.ActivePageIndex:=1 //панель перепрыжки
  else PageControl1.ActivePageIndex:=0; // основной маршрут
  DM.OpenGit(-1,DM.CurrentTournament,DM.CurrentRoute,RangedView,OverlapCB.Checked and (OverList<>''));
  GitGridRefreshVisibility;
end;

procedure TMainFrm.RepSpeedButton1Click(Sender: TObject);
begin
  FilePrintActionExecute(self);
end;


procedure TMainFrm.RepSpeedButtonClick(Sender: TObject);
begin
  ReportsPopup.PopUp;
end;


procedure TMainFrm.ShuffleBitBtnClick(Sender: TObject);
begin
  GitShuffleActionExecute(Sender);
end;


procedure TMainFrm.BitBtn5Click(Sender: TObject);
begin
  CalcPlaces;
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
    // выделение полей со штрафными очками розовым цветом
    if (LeftStr(LowerCase(Column.FieldName),4)='foul')  then
      if TDBGrid(Sender).DataSource.DataSet.FieldByName(Column.FieldName).AsInteger>0 then
           TDBGrid(Sender).Canvas.Brush.Color :=  RGBToColor(250,150,150)
      else
           TDBGrid(Sender).Canvas.Brush.Color := Col;

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
    DM.Work.Close;
    DM.Work.Params.Clear;
    DM.Work.SQL.Clear;
    DM.Work.SQL.Add('UPDATE git SET "queue"=:par1 where _rowid_=:par2;');
    DM.Work.ParamByName('par1').AsInteger:=q2 ;
    DM.Work.ParamByName('par2').AsInteger:=row1;
    DM.Work.ExecSQL;
    DM.Work.ParamByName('par1').AsInteger:=q1;
    DM.Work.ParamByName('par2').AsInteger:=row2;
    DM.Work.ExecSQL;
    DM.OpenGit(row2,DM.CurrentTournament,DM.CurrentRoute);
    //ShowMessage('row1='+inttostr(row1)+', row2='+inttostr(row2));
    //TDBGrid(Sender).SelectedField.AsString);
    //TDBGrid(Target).DataSource.DataSet. SelectedIndex := TDBGrid(Target).SelectedIndex + off;
  end;
end;

procedure TMainFrm.GitFireActionExecute(Sender: TObject);
var
  fi : String;
  val : Integer;
begin
  // снятие с гита
  //todo: !!!!! Меняется в НД, но не записывется в БД!!!
  //Надо писать, иначе в перепрыжке пропадает после пересчета мест!!!
  //
  if OverlapCB.Checked then fi := 'place2'
  else fi := 'place';
  GitDBGrid.DataSource.DataSet.Edit;
  if GitDBGrid.DataSource.DataSet.FieldByName(fi).AsInteger > FIRED_RIDER then
    val := GitDBGrid.DataSource.DataSet.FieldByName(fi).AsInteger - FIRED_RIDER
  else
    val :=  FIRED_RIDER +
       GitDBGrid.DataSource.DataSet.FieldByName('queue').AsInteger; //чтобы отличались
  GitDBGrid.DataSource.DataSet.FieldByName(fi).AsInteger := val;
  GitDBGrid.DataSource.DataSet.Post;
  // DM.SetFire(id,value,fieldname);
  DM.SetFire(GitDBGrid.DataSource.DataSet.FieldByName('id').AsInteger,val,fi);
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
    DM.OpenGit(id, DM.CurrentTournament, DM.CurrentRoute);
  end;
end;

procedure TMainFrm.GitDBGridEditingDone(Sender: TObject);
begin
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
  //todo: обнулять значения невидимых ячеек или пересчитывать сумму штрафов?
  GitGridRefreshVisibility;
end;


procedure TMainFrm.RouteAddActionExecute(Sender: TObject);
begin
end;

procedure TMainFrm.RouteDelActionExecute(Sender: TObject);
begin
  //todo: проверить, если есть дочерние записи об участниках, то предупредить
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
    //
    OverlapCB.Visible:=(DM.CurrRouteType=1) and (OverList<>'');
    //
    // обновить содержимое контролов, связанных с маршрутом
    RouteNameLabel.Caption := DM.CurrRouteName; // заполнить строкой названия
    if (DM.CurrRouteType>=0) and (DM.CurrRouteType<RouteTypeSL.Count-1) then
                       StatusBar1.Panels[1].Text:= RouteTypeSL[DM.CurrRouteType];
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
    DM.OpenGit(-1,DM.CurrentTournament,DM.CurrentRoute);
    GitDBGrid.Enabled:=not DM.Git.IsEmpty;
    RangedView:=False;
    GitGridRefreshVisibility;
  end;
end;

procedure TMainFrm.VelocityCB2Change(Sender: TObject);
begin
  CalcMaxTimeOver;
end;

procedure TMainFrm.VelocityCB1Change(Sender: TObject);
begin
  CalcMaxTime;
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
  // пишем в таблицу
  GitDBGrid.DataSource.DataSet.Edit;
  GitDBGrid.DataSource.DataSet.FieldByName('foul1_time').AsCurrency:= it1;
  GitDBGrid.DataSource.DataSet.FieldByName('foul2_time').AsCurrency:= it2;
  GitDBGrid.DataSource.DataSet.FieldByName('sumfouls1').AsCurrency:= ii;
  GitDBGrid.DataSource.DataSet.FieldByName('sumfouls2').AsCurrency:= jj;
  GitDBGrid.DataSource.DataSet.FieldByName('totalfouls1').AsCurrency:= ii+it1;
  GitDBGrid.DataSource.DataSet.FieldByName('totalfouls2').AsCurrency:= jj+it2;
  GitDBGrid.DataSource.DataSet.FieldByName('sumfouls').AsCurrency:=ii+jj+it1+it2;
  GitDBGrid.DataSource.DataSet.Post;
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
  i,g, ocounter : Integer;
  s : Currency;
  over : TStringList;
begin
  OverlapCB.Checked:=False;
  OverList:='';
  OverlapCB.Visible:=False;
  GitDBGrid.BeginUpdate;
  case DM.CurrRouteType of
    0: // classic - по каждому зачёту: ранжируются по итоговым штрафным очкам(totalfouls1),
       //  а при совпадении - по времени прохождения
       //!!! если совпало и то, и другое, то на № места повлияет порядковый номер выступления !!!
       //старая версия - ниже в комментах... пока других указаний не поступало...
       begin
         DM.Work2.Close;
         DM.Work2.Params.Clear;
         DM.Work2.SQL.Text := 'select id,"group",totalfouls1,gittime1,place from v_git where tournament=:par1 and route=:par2 order by "group",totalfouls1,gittime1,queue;';
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
       end;
    1: // классика с перепрыжкой:
       // для каждого зачета
       // на первом этапе ранжируются по сумме ш.о. и штрафов за превышение времени (totalfouls1)
       // результат пишется в place.
       // Если на первых местах одинаковые ш.о., то перепрыжка (этап 2)
       // на втором этапе места присваивать как в классике (case 0), + доп.результат в place2
       begin
         DM.Work2.Close;
         DM.Work2.Params.Clear;
         DM.Work2.SQL.Text := 'select id,"group",totalfouls1,place from v_git where tournament=:par1 and route=:par2 order by "group",totalfouls1,queue;';
         DM.Work2.ParamByName('par1').AsInteger:=DM.CurrentTournament;
         DM.Work2.ParamByName('par2').AsInteger:=DM.CurrentRoute;
         //----
         //!!! затираются данные о снятии с гита в перепрыжке!!! (place2=0)
         //DM.Work.SQL.Text := 'update git set place=:par1, place2=0 where _rowid_=:par2;';
         // 2018-09-13 перенес обнуление place2 с учётом FIRE_RIDER в проц. CalcPlacesOver
         DM.Work.Close;
         DM.Work.Params.Clear;
         DM.Work.SQL.Text := 'update git set place=:par1 where _rowid_=:par2;';
         //--
         try
           over := TStringList.Create;   //список претендентов на перепрыжку
           try
             DM.Work2.Open;
             if not DM.Work2.IsEmpty then
             begin
               DM.Work2.First;
               i := 0;
               s := -1;
               g := -1;
               ocounter:=0; // счетчик участников перепрыжки для каждого зачёта
               // чтобы НЕ первые места смещались после перепрыжчиков
               //
               while not DM.Work2.EOF do
               begin
                 if g <> DM.Work2.FieldByName('group').AsInteger then
                 begin
                   // начало нового зачёта
                   // если список предыд.зачёта не пуст - будет перепрыжка, зафиксировать
                    if over.Count>1 then
                      if OverList<>'' then OverList:=OverList+','+over.CommaText
                      else OverList:=over.CommaText;
                   //--- теперь запоминаем параметры нового зачёта ---
                   i := 0;
                   ocounter:=0;
                   g := DM.Work2.FieldByName('group').AsInteger;
                   s := DM.Work2.FieldByName('totalfouls1').AsCurrency;
                   over.Clear;
                   // начальное значение... Без этого - первая строка не попадает
                   over.add(IntToStr(DM.Work2.FieldByName('id').AsInteger));
                 end;
                 //--- проигнорировать снятых с гита, остальных обработать
                 if DM.Work2.FieldByName('place').AsInteger < FIRED_RIDER then
                 begin
                  // -- перепрыжка для первых мест при совпадении общих ш.о. (totalfouls1)
                   if (i = 1) and
                      (s = DM.Work2.FieldByName('totalfouls1').AsCurrency) then
                   begin // будут участвовать в перепрыжке
                     over.add(IntToStr(DM.Work2.FieldByName('id').AsInteger));
                     Inc(ocounter);
                     // i - остаётся =1
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
                   DM.Work.ParamByName('par1').AsInteger:=i;
                   DM.Work.ParamByName('par2').AsInteger:=DM.Work2.FieldByName('id').AsInteger;
                   DM.Work.ExecSQL;
                   //***
                 end;
                 DM.Work2.Next;
               end;
               // список остался не пустой - будет перепрыжка, зафиксировать
               if over.Count>1 then
               begin
                 if OverList<>'' then OverList:=OverList+','+over.CommaText
                 else OverList:=over.CommaText;
               end;
             end;
           except
             Application.MessageBox('Не удалось нормально завершить процедуру','Ошибка',MB_OK+MB_ICONERROR);
           end;
         finally
           over.Free;
         end;
       end;
  end;
  RangedView:=True;
  GitDBGrid.EndUpdate;
  if OverList<>'' then
  begin
    OverlapCB.Visible:=True;
    Application.MessageBox('ПЕРЕПРЫЖКА !!!!','Информация',MB_OK+MB_ICONINFORMATION);
  end
  else  OverlapCB.Visible:=False;
end;

procedure TMainFrm.CalcPlacesOver;
var
  i,g : Integer;
begin
  if OverList='' then Exit;
  try
    // список уже д.б. ранжирован по place и выбраны только участники перепрыжки
    GitDBGrid.BeginUpdate;
    //
    // перед началом подведеня итогов надо обнулить предыдущие результаты
    // т.к. непустое значение поля place2 будет мешать правильной расстановке мест
    // (кроме снятых с гита)
    DM.Work.Close;
    DM.Work.Params.Clear;
    DM.Work.SQL.Text := 'update git set place2=0 where place2<:par1 and "_rowid_" in ('+OverList+');';
    DM.Work.ParamByName('par1').AsInteger := FIRED_RIDER;
    DM.Work.ExecSQL;
    //
    DM.Work2.Close;
    DM.Work2.Params.Clear;
    DM.Work2.SQL.Text := 'select id,"group",place,place2,totalfouls2,gittime2 from v_git '+
      ' where id in ('+OverList+') order by "group",place2,totalfouls2,gittime2,queue;';
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
          // а в place2 - место, если не был снят с гита
          DM.Work.ParamByName('par1').AsInteger:=i;
          if  DM.Work2.FieldByName('place2').ASInteger<FIRED_RIDER then
            DM.Work.ParamByName('par2').AsInteger:=i
          else
            DM.Work.ParamByName('par2').AsInteger:=DM.Work2.FieldByName('place2').ASInteger;
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


//*****************************************************************************8
//
//
{  proc CalcPlaces  case 0:  (классика)
       begin
         DM.Work2.Close;
         DM.Work2.Params.Clear;
         DM.Work2.SQL.Text := 'select id,"group",sumfouls1,gittime1,place from v_git where tournament=:par1 and route=:par2 order by "group",sumfouls1,gittime1,queue;';
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
               i := 1;
               s := -1;
               t := -1;
               g := DM.Work2.FieldByName('group').AsInteger;
               while not DM.Work2.EOF do
               begin
                 DM.Work.ParamByName('par1').AsInteger:=i;
                 DM.Work.ParamByName('par2').AsInteger:=DM.Work2.FieldByName('id').AsInteger;
                 DM.Work.ExecSQL;
                 //***
                 if DM.Work2.FieldByName('place').AsInteger < FIRED_RIDER then
                 begin
                   if (s <> DM.Work2.FieldByName('sumfouls1').AsCurrency) or
                      (t <> DM.Work2.FieldByName('gittime1').AsCurrency) then
                   begin
                     // если штрафы и время одинаковы, то № места тот же останется, иначе - увеличится
                     s := DM.Work2.FieldByName('sumfouls1').AsCurrency;
                     t := DM.Work2.FieldByName('gittime1').AsCurrency;
                     Inc(i);
                   end;
                 end;
                 DM.Work2.Next;
                 if g <> DM.Work2.FieldByName('group').AsInteger then
                 begin
                   // начало нового зачёта
                   g := DM.Work2.FieldByName('group').AsInteger;
                   i := 1;
                 end;
               end;
             end;
           except
             Application.MessageBox('Не удалось нормально завершить процедуру','Ошибка',MB_OK+MB_ICONERROR);
           end;
         finally
         end;
       end;
}
//*******************************************
{ КЛАССИКА С ПРЕПРЫЖКОЙ (ЭТАП 1)
CalcPlaces case 1:

begin
         DM.Work2.Close;
         DM.Work2.Params.Clear;
         DM.Work2.SQL.Text := 'select id,"group",gittime1,totalfouls1,place from v_git where tournament=:par1 and route=:par2 order by "group",totalfouls1,gittime1,queue;';
         DM.Work2.ParamByName('par1').AsInteger:=DM.CurrentTournament;
         DM.Work2.ParamByName('par2').AsInteger:=DM.CurrentRoute;
         //----
         DM.Work.Close;
         DM.Work.Params.Clear;
         DM.Work.SQL.Text := 'update git set place=:par1, place2=0 where _rowid_=:par2;';
         //--
         try
           over := TStringList.Create;   //список претендентов на перепрыжку
           try
             DM.Work2.Open;
             if not DM.Work2.IsEmpty then
             begin
               DM.Work2.First;
               i := 0;
               s := -1;
               g := -1;
               //
               while not DM.Work2.EOF do
               begin
                 if g <> DM.Work2.FieldByName('group').AsInteger then
                 begin
                   // начало нового зачёта
                   // если список предыд.зачёта не пуст - будет перепрыжка, зафиксировать
                    if over.Count>1 then
                      if OverList<>'' then OverList:=OverList+','+over.CommaText
                      else OverList:=over.CommaText;
                   //--- теперь запоминаем параметры нового зачёта ---
                   i := 0;
                   g := DM.Work2.FieldByName('group').AsInteger;
                   s := DM.Work2.FieldByName('totalfouls1').AsCurrency;
                   t := DM.Work2.FieldByName('gittime1').AsCurrency;
                   over.Clear;
                   // начальное значение... Без этого - первая строка не попадает
                   over.add(IntToStr(DM.Work2.FieldByName('id').AsInteger));
                 end;
                 //--- проигнорировать снятых с гита, остальных обработать
                 if DM.Work2.FieldByName('place').AsInteger < FIRED_RIDER then
                 begin
                  // -- перепрыжка для первых мест при совпадении общих ш.о. (totalfouls1)
                   if (i = 1) and
                      (s = DM.Work2.FieldByName('totalfouls1').AsCurrency) and
                      (t = DM.Work2.FieldByName('gittime1').AsCurrency) then
                   begin // будут участвовать в перепрыжке
                     over.add(IntToStr(DM.Work2.FieldByName('id').AsInteger));
                     // i - остаётся =1
                   end
                   else
                     // совпадения закончились, или место не первое - дальше номера мест увеличим
                     Inc(i);
                   s:= DM.Work2.FieldByName('totalfouls1').AsCurrency;
                   t := DM.Work2.FieldByName('gittime1').AsCurrency;
                   DM.Work.ParamByName('par1').AsInteger:=i;
                   DM.Work.ParamByName('par2').AsInteger:=DM.Work2.FieldByName('id').AsInteger;
                   DM.Work.ExecSQL;
                   //***
                 end;
                 DM.Work2.Next;
               end;
               // список остался не пустой - будет перепрыжка, зафиксировать
               if over.Count>1 then
               begin
                 if OverList<>'' then OverList:=OverList+','+over.CommaText
                 else OverList:=over.CommaText;
               end;
             end;
           except
             Application.MessageBox('Не удалось нормально завершить процедуру','Ошибка',MB_OK+MB_ICONERROR);
           end;
         finally
           over.Free;
         end;
       end;
}

end.

