unit concour_export;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, ComCtrls, EditBtn;

const
  // Office enum (from VBA help)
  xlPortrait   = 1;
  xlLandscape  = 2;
  xlContinuous = 1;
  xlEdgeLeft   = 7;
  xlEdgeTop    = 8;
  xlEdgeBottom = 9;
  xlEdgeRight  =10;
  rty_RefReJump=-3;   // судейский протокол с перепрыжкой
  rty_Referee  =-2;   // судейский протокол (обычный)
  rty_Start    =-1;   // стартовый протокол
  rty_Single   = 0;   // одиночный итоговый протокол
  rty_Total    =99;  // все маршруты в одном файле (итоговые протоколы)

type
  { TExpFrm }

  TExpFrm = class(TForm)
    BitBtn1: TBitBtn;
    DirectoryEdit1: TDirectoryEdit;
    Label1: TLabel;
    ProgressBar1: TProgressBar;
    StartSpeedButton: TSpeedButton;
    RefereeSpeedButton: TSpeedButton;
    FinalSpeedButton: TSpeedButton;
    TotalSpeedButton: TSpeedButton;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StartSpeedButtonClick(Sender: TObject);
    procedure RefereeSpeedButtonClick(Sender: TObject);
    procedure FinalSpeedButtonClick(Sender: TObject);
    procedure TotalSpeedButtonClick(Sender: TObject);
  private

  public
    xlApp: Variant;
    w : WideString;
    CurrSheet,srow,scol, l,g : Integer;
    s,rcol, Section : String;
    {$IFDEF WINDOWS}
    function U2V(InStr:String): Variant; // UTF8 string to Variant
    procedure GetStartPos; // fill srow & scol values from ini
    procedure SelectRep(Route, RouteType: Integer);
    procedure MakeXLS(RepType: Integer; DirectPrint:Boolean=False);
    function FindSheet(SheetName:String):Integer ;
    function CopySheet(Num:Integer;NewName:String):Integer;
    function MakeCell(crow,ccol: Integer; CValue: Variant): Boolean;
    function MakeBorder(crow,ccol: Integer):Boolean;
    function MakeBold(crow,ccol,beginchar,len:Integer):Boolean;
    procedure MakeRepHeader;
    procedure MakeStartXLS(RepType: Integer);
    procedure MakeXLS_0(Route: Integer);
    procedure MakeXLS_1(Route: Integer);
    {$ENDIF}
  end;

var
  ExpFrm: TExpFrm;

implementation

{$R *.lfm}
uses LazUTF8, LCLType, db, concour_main, concour_DM, lclintf,
     concour_params {$IFDEF WINDOWS},Windows, ComObj{$ENDIF};

{ TExpFrm }

procedure TExpFrm.StartSpeedButtonClick(Sender: TObject);
begin
  {$IFDEF WINDOWS}
  MakeXLS(rty_Start,True);
  {$ENDIF};
end;

procedure TExpFrm.FormActivate(Sender: TObject);
begin
  if MainFrm.OverlapCB.Checked and (MainFrm.OverList <> '') then    //перепрыжка
  begin
    FinalSpeedButton.Enabled:=False;
    TotalSpeedButton.Enabled:=False;
  end;
end;

procedure TExpFrm.FormCreate(Sender: TObject);
begin
  DirectoryEdit1.Directory:=cfg.RepPath;
end;

procedure TExpFrm.RefereeSpeedButtonClick(Sender: TObject);
begin
  {$IFDEF WINDOWS}
  if DM.CurrRouteType=1 // с перепрыжкой
  then  MakeXLS(rty_RefReJump,True)
  else  MakeXLS(rty_Referee,True);
  {$ENDIF};
end;

procedure TExpFrm.FinalSpeedButtonClick(Sender: TObject);
begin
  {$IFDEF WINDOWS}
  MakeXLS(rty_Single,True);
  {$ENDIF};
end;

procedure TExpFrm.TotalSpeedButtonClick(Sender: TObject);
begin
  {$IFDEF WINDOWS}
  MakeXLS(rty_Total);
  {$ENDIF};
end;

//*--------------
{$IFDEF WINDOWS}

function TExpFrm.U2V(InStr:String): Variant; // UTF8 string to Variant
var
  ws : WideString;
begin
  ws := UTF8Decode(InStr);
  Result := Variant(ws);
end;

procedure TExpFrm.GetStartPos; // fill srow & scol values from ini
begin
  // стартовая строка вывода данных
    s := cfg.ParamByName(Section,'DataStartRow','12');
    srow := StrToInt(s);
    // стартовая колонка вывода данных
    s := cfg.ParamByName(Section,'DataStartCol','1');
    scol := StrToInt(s);
    // стартовая колонка вывода данных
    rcol := cfg.ParamByName(Section,'DataLastCol','I');
end;

procedure TExpFrm.SelectRep(Route, RouteType: Integer);
begin
  DM.RepParams.Add('REP_SUBTITLE='+DM.GetRouteName(Route));
  case RouteType of
    0: // КЛАССИКА
         MakeXLS_0(Route);
    1: // КЛАССИКА С ПЕРЕПРЫЖКОЙ
         MakeXLS_1(Route);
    // других пока нет :)
  end;
end;

procedure TExpFrm.MakeXLS(RepType: Integer; DirectPrint:Boolean=False);
var
  RepName : String;
begin
  if Assigned(InitProc) then TProcedure(InitProc); // рекомендация wiki FPC
  if Trim(DirectoryEdit1.Directory)='' then DirectoryEdit1.Directory:= cfg.RepPath;
  if RightStr(DirectoryEdit1.Directory,1)<>PathDelim then
    DirectoryEdit1.Directory:=DirectoryEdit1.Directory + PathDelim;
  ForceDirectories(DirectoryEdit1.Directory); //на случай, если нет такого каталога
  //
  DM.FillRepParams;   // Получить параметры отчетов из ini в TStringList
  //
  // сформировать полный абсолютный путь к файлу шаблонов
  if ((ExtractFileDrive(cfg.XLSTempFileName)='') and
     (LeftStr(ExtractFilePath(cfg.XLSTempFileName),1)<>PathDelim)) then
    cfg.XLSTempFileName:= ExtractFilePath(Application.ExeName) + cfg.XLSTempFileName;
  //
  try
    try
      xlApp := CreateOleObject('Excel.Application');
    except
      ShowMessage('Не удалось запустить MS Excel');
      Exit;
    end;
    try
      xlApp.Workbooks.Open(U2V(cfg.XLSTempFileName));  //открыть шаблон   //'c:\Develop\concour\templates\temp.xls');
    except
      ShowMessage('Не удалось открыть файл шаблона отчетов: '+cfg.XLSTempFileName);
      Exit;
    end;
    xlApp.Workbooks.Add;      //создать рабочий отчет
    //
    xlApp.Workbooks(1).Activate;
    xlApp.Visible := False;
    //xlApp.Visible := True;
    xlApp.DisplayAlerts := False;
    //**---------------------
    if RepType<0 then //стартовый и судейский - только для текущего маршрута
    begin
      MakeStartXLS(RepType);
    end
    else
    begin
      if RepType=rty_Total then
      begin
        //перебираем все маршруты текущих соревнований, и для каждого - SelectRep;
        DM.Work2.Close;
        DM.Work2.Params.Clear;
        DM.Work2.SQL.Text := 'select DISTINCT g.route,r.route_type,r.routename '+
             ' from v_git g, routes r where g.route=r."_rowid_" and g.tournament=:par1 '+
             ' order by g.route;';
        try
          DM.Work2.ParamByName('par1').AsInteger:=DM.CurrentTournament;
          DM.Work2.Open;
          if DM.Work2.IsEmpty then Exit;
          DM.Work2.First;
          while not DM.Work2.EOF do
          begin
            DM.FillRepParams;
            SelectRep(DM.Work2.FieldByName('route').AsInteger,
                      DM.Work2.FieldByName('route_type').AsInteger);
            DM.Work2.Next;
          end;
        finally
          DM.Work2.Close;
        end;
      end
      else  SelectRep(DM.CurrentRoute, DM.CurrRouteType); //одиночный отчет
    end;
    //**---------------------
    RepName := DirectoryEdit1.Directory + 'concour_report_' + DM.RepParams.Values['REP_DATE'] +
                 '_' + FormatDateTime('yymmddhhnnss',now)+ '.xlsx';
    if FileExists(RepName) then
      if not SysUtils.DeleteFile(RepName) then
      begin
        ShowMessage('Ошибка сохранения отчета!');
        Exit;
      end;
    if DirectPrint then
      try
        xlApp.Sheets(1).PrintOut;
        if Application.MessageBox('Отчет отправлен на печать. Сохранить его в файле?',
             'Сохранение',MB_YESNO)<>IDYES then Exit;
      except
        // ?
      end;
    //    else
    xlApp.ActiveWorkbook.SaveAs(U2V(RepName)); //'c:\Develop\rep.xlsx');   // если без пути, то пишет в Мои документы
    xlApp.ActiveWorkbook.Close;
    Application.MessageBox(PAnsiChar('Отчет сохранен в '+RepName),
         'Сохранение',MB_OK);
  finally
    //todo: закрывать - по требованию?
    xlApp.Quit;
  end;
end;

//*******************
function TExpFrm.FindSheet(SheetName:String):Integer ;
var ii: Integer;
begin
  // искать только в WorkBooks(1) - в файле шаблонов    !!!
  Result := -1;
  for ii:=1 to xlApp.Workbooks(1).Sheets.Count do
    if UpperCase(Trim(xlApp.Workbooks(1).Sheets(ii).Name))=UpperCase(UTF8Decode(SheetName)) then
    begin
      Result := ii;
      Break;
    end;
end;
//*******************
function TExpFrm.CopySheet(Num:Integer;NewName:String):Integer;
begin
  if NewName='' then NewName:='--Concour-report--';
  // копируем указанный лист из книги шаблонов(1) - в новую книгу(2)
  if Num>0 then xlApp.Workbooks(1).Sheets(Num).Copy(xlApp.Workbooks(2).Sheets(1))
  else xlApp.Workbooks(2).Sheets.Add(xlApp.Workbooks(2).Sheets(1));
  //у Copy  д.б. 2 параметра: лист до и после, но разрешает только "ДО"
  // поэтому создаём копию перед первым листом
  // у Add - четыре параметра, но используем "ДО"
  xlApp.Workbooks(2).Activate; // переходим в новую книгу и работаем с ней
  try
    // !!! имя не более 31 знака, но для верности ограничим 25-ю
    xlApp.Sheets(1).Name := U2V(UTF8LeftStr(NewName,25));
  except
    raise Exception.Create('Ошибка в имени листа отчета! ('+NewName+') Проверьте параметр в конфигурационном файле.');
  end;
  Result := 1;
end;
//*******************
function TExpFrm.MakeCell(crow,ccol: Integer; CValue: Variant): Boolean;
begin
  xlApp.Cells[crow,ccol].Value := CValue;
  Result := True;
end;
//*******************
function TExpFrm.MakeBorder(crow,ccol: Integer):Boolean;
begin
  //
  xlApp.Cells[crow,ccol].Borders(xlEdgeLeft).LineStyle := xlContinuous;
  xlApp.Cells[crow,ccol].Borders(xlEdgeTop).LineStyle := xlContinuous;
  xlApp.Cells[crow,ccol].Borders(xlEdgeRight).LineStyle := xlContinuous;
  xlApp.Cells[crow,ccol].Borders(xlEdgeBottom).LineStyle := xlContinuous;
  Result := True;
end;
//*******************
function TExpFrm.MakeBold(crow,ccol,beginchar,len:Integer):Boolean;
begin
  xlApp.Cells[crow,ccol].Characters(beginchar, len).Font.Bold := True;
  Result := True;
end;

//*******************

procedure TExpFrm.MakeRepHeader;
var ss: String;
begin
  // Section уже определена для каждого отчета
  s := UpperCase(cfg.ParamByName(Section,'HeaderCell',''));
  if s<>'' then //номер ячейки с заголовком отчета
  begin
    xlApp.Range[U2V(s)].Value := U2V(DM.RepParams.Values['REP_TITLE']);
  end;
  //
  s := UpperCase(cfg.ParamByName(Section,'SubHeaderCell',''));
  if s<>'' then //номер ячейки с подзаголовком отчета
  begin
    xlApp.Range[U2V(s)].Value := U2V(DM.RepParams.Values['REP_SUBTITLE']);
  end;
  //
  s := UpperCase(cfg.ParamByName(Section,'PlaceCell',''));
  if s<>'' then //номер ячейки с местом проведения
  begin
    xlApp.Range[U2V(s)].Value := U2V(DM.RepParams.Values['REP_PLACE']);
  end;
  //
  s := UpperCase(cfg.ParamByName(Section,'DateCell',''));
  if s<>'' then //номер ячейки с датой проведения
  begin
    ss := DM.RepParams.Values['REP_DATE'];
    if ss <> DM.RepParams.Values['REP_DATE2'] then
          ss := ss+#10+DM.RepParams.Values['REP_DATE2'];
    xlApp.Range[U2V(s)].Value := U2V(ss);
  end;
end;

//*******************
//**
//**
procedure TExpFrm.MakeStartXLS(RepType:Integer);
var
  i : Integer;
begin
  Section:='XLSRepStart';  // секция ini-файла
  //
  //если есть шаблон листа(имя берем в ini),
  // то копируем его в новый, иначе - создаём пустой
  CurrSheet:=CopySheet(FindSheet(cfg.ParamByName(Section,'TempSheet','СТАРТ')),
                 cfg.ParamByName(Section,'TargetSheet',Trim(IntToStr(DM.CurrentRoute))+'_СТАРТ'));
  //с этого момента xlApp.Workbooks(2).Activate;
  GetStartPos;
  //
  if RepType=rty_Start
  then DM.RepParams.Values['REP_SUBTITLE']:='Стартовый протокол'
  else DM.RepParams.Values['REP_SUBTITLE']:='Судейский протокол';
  MakeRepHeader;
  //
  DM.Work.Close;
  DM.Work.Params.Clear;
  //todo: 2018-12-26 другое условие отбора в перепрыжку
  if MainFrm.OverlapCB.Checked and (MainFrm.OverList <> '') then
    //перепрыжка
    //todo: 2018-12-26 другое условие отбора в перепрыжку
    DM.Work.SQL.Text:='select * from v_git where tournament=:par1 and route=:par2 '+
    ' and id in ('+MainFrm.OverList+') order by "group",place,queue;'
  else
    DM.Work.SQL.Text:='select * from v_git where tournament=:par1 and route=:par2 order by queue;';
  DM.Work.ParamByName('par1').AsInteger:=DM.CurrentTournament;
  DM.Work.ParamByName('par2').AsInteger:=DM.CurrentRoute;
  try
    DM.Work.Open;
    if DM.Work.IsEmpty then Exit;
    ProgressBar1.Max:=DM.Work.RecordCount;
    ProgressBar1.Position:=0;
    DM.Work.First;
    while not DM.Work.EOF do
    begin
      {1}
      if DM.Work.FieldByName('place').AsInteger < FIRED_RIDER then
        MakeCell(srow,scol,DM.Work.FieldByName('queue').AsInteger)
      else
        MakeCell(srow,scol,'СНЯТ');
      MakeBorder(srow,scol);
      {2}
      MakeCell(srow,scol+1,U2V(DM.Work.FieldByName('groupname').AsString));
      MakeBorder(srow,scol+1);
      {3}
      // не забыть преобразовать строки
      w := Utf8Decode(UpperCase(DM.Work.FieldByName('lastname').AsString));
      l := Length(w);
      w := w +' '+ Utf8Decode(DM.Work.FieldByName('firstname').AsString)+
              ', '+ Utf8Decode(DM.Work.FieldByName('r_year').AsString);
      MakeCell(srow,scol+2,Variant(w));
      MakeBold(srow,scol+2,1,l);
      MakeBorder(srow,scol+2);
      {4}
      MakeCell(srow,scol+3,U2V(DM.Work.FieldByName('regnum').AsString));
      MakeBorder(srow,scol+3);
      {5}
      MakeCell(srow,scol+4,U2V(DM.Work.FieldByName('category').AsString));
      MakeBorder(srow,scol+4);
      {6}
      w := Utf8Decode(UpperCase(DM.Work.FieldByName('nickname').AsString));
      l := Length(w);
      w := w +', '+ Utf8Decode(DM.Work.FieldByName('h_year').AsString) +
              ', '+ Utf8Decode(DM.Work.FieldByName('color').AsString) +
              ', '+ Utf8Decode(DM.Work.FieldByName('sex').AsString) +
              ', '+ Utf8Decode(DM.Work.FieldByName('breed').AsString) +
              ', '+ Utf8Decode(DM.Work.FieldByName('parent').AsString) +
              ', '+ Utf8Decode(DM.Work.FieldByName('birthplace').AsString);
      MakeCell(srow,scol+5,w);
      MakeBold(srow,scol+5,1,l);
      MakeBorder(srow,scol+5);
      {7}
      MakeCell(srow,scol+6,U2V(DM.Work.FieldByName('register').AsString));
      MakeBorder(srow,scol+6);
      {8}
      MakeCell(srow,scol+7,U2V(DM.Work.FieldByName('owner').AsString));
      MakeBorder(srow,scol+7);
      {9}
      MakeCell(srow,scol+8,U2V(DM.Work.FieldByName('region').AsString));
      MakeBorder(srow,scol+8);
      //--
      if ((RepType=rty_Referee) or (RepType=rty_RefReJump))  then
      //судейский - с колонками для штрафов
        for i:=1 to 16 do
          MakeBorder(srow,scol+8+i);
      //
      //-- подогнать высоту строки:
      // Rows("15:15").EntireRow.AutoFit
      xlApp.Rows(U2V(Trim(IntToStr(srow))+':'+Trim(IntToStr(srow)))).EntireRow.AutoFit;
      //*** следующая строка
      Inc(srow);
      if RepType=rty_RefReJump then
      begin
        //судейский протокол для маршрута с перепрыжкой - доп.строка;
        //MakeCell(srow,scol+8,U2V('Ш.о. '+#10+'перепрыжки'));
        MakeCell(srow,scol+8,U2V('||  '+#10+'=>'));
        for i:=1 to 16 do
          MakeBorder(srow,scol+8+i);
        Inc(srow);
      end;
      DM.Work.Next;
      ProgressBar1.Position := ProgressBar1.Position + 1;
    end;
  finally
    DM.Work.Close;
  end;
  Inc(srow);
  MakeCell(srow,scol+2,'Глвный судья');
  MakeCell(srow,scol+5,U2V(DM.RepParams.Values['REP_REFEREE']));
  // ???
  srow:=srow+2;
  MakeCell(srow,scol+2,'Главный секретарь');
  MakeCell(srow,scol+5,U2V(DM.RepParams.Values['REP_ASSISTANT']));
  //
  //поколдовать с параметрами области печати (поля и т.п.)
  //ActiveSheet.PageSetup.PrintArea = "$A$1:$M$18"
  // стартовый $A$1:$I$<srow>
  // судейский $A$1:$Y$<srow>
  srow:=srow+2;
  s := '$A$1:$';
  if ((RepType=rty_Referee) or (RepType=rty_RefReJump))  then
  begin
    s := s + 'Y$';
    i := xlLandscape;
  end
  else
  begin
    s := s + 'I$';
    i:= xlPortrait;
  end;
  xlApp.Workbooks(2).Worksheets(1).PageSetup.PrintArea := U2V(s+Trim(IntToStr(srow)));
  xlApp.Workbooks(2).Worksheets(1).PageSetup.Orientation := i;
end;

//*******************

procedure TExpFrm.MakeXLS_0(Route: Integer);
begin
  Section:='XLSRep_0';  // секция в ini-файле
  s := cfg.ParamByName(Section,'TempSheet','КЛАССИКА');
  CurrSheet:=CopySheet(FindSheet(s),
                 cfg.ParamByName(Section,'TargetSheet',Trim(IntToStr(Route))+'_'+s));
  //с этого момента xlApp.Workbooks(2).Activate;
  GetStartPos;
  //
  MakeRepHeader;
  //
  DM.Work.Close;
  DM.Work.Params.Clear;
  DM.Work.SQL.Text:='select * from v_git where tournament=:par1 and route=:par2 order by "group",place,queue;';
  DM.Work.ParamByName('par1').AsInteger:=DM.CurrentTournament;
  DM.Work.ParamByName('par2').AsInteger:=Route;
  try
    g := -1; //начальное значение № зачёта
    DM.Work.Open;
    if DM.Work.IsEmpty then Exit;
    DM.Work.First;
    ProgressBar1.Max:=DM.Work.RecordCount;
    ProgressBar1.Position:=0;
    while not DM.Work.EOF do
    begin
      if g<>DM.Work.FieldByName('group').AsInteger then
      begin
        g := DM.Work.FieldByName('group').AsInteger;
        //начало нового зачёта - вставить его название;
        MakeCell(srow,scol,U2V(DM.Work.FieldByName('groupname').AsString));
        s := Trim(IntToStr(srow));
        xlApp.Range[U2V('A'+s+':'+rcol+s)].MergeCells := True;
        Inc(srow);
      end;
      {1}
      if DM.Work.FieldByName('place').AsInteger < FIRED_RIDER then
        MakeCell(srow,scol,DM.Work.FieldByName('place').AsInteger);
      MakeBorder(srow,scol);
      {2}
      //MakeCell(srow,scol,DM.Work.FieldByName('queue').AsInteger);  ?
      MakeBorder(srow,scol+1);
      {3}
      // не забыть преобразовать строки
      w := Utf8Decode(UpperCase(DM.Work.FieldByName('lastname').AsString));
      l := Length(w);
      w := w +' '+ Utf8Decode(DM.Work.FieldByName('firstname').AsString)+
              ', '+ Utf8Decode(DM.Work.FieldByName('r_year').AsString);
      MakeCell(srow,scol+2,w);
      MakeBold(srow,scol+2,1,l);
      MakeBorder(srow,scol+2);
      {4}
      MakeCell(srow,scol+3,U2V(DM.Work.FieldByName('regnum').AsString));
      MakeBorder(srow,scol+3);
      {5}
      MakeCell(srow,scol+4,U2V(DM.Work.FieldByName('category').AsString));
      MakeBorder(srow,scol+4);
      {6}
      w := Utf8Decode(UpperCase(DM.Work.FieldByName('nickname').AsString));
      l := Length(w);
      w := w +', '+ Utf8Decode(DM.Work.FieldByName('h_year').AsString) +
              ', '+ Utf8Decode(DM.Work.FieldByName('color').AsString) +
              ', '+ Utf8Decode(DM.Work.FieldByName('sex').AsString) +
              ', '+ Utf8Decode(DM.Work.FieldByName('breed').AsString) +
              ', '+ Utf8Decode(DM.Work.FieldByName('parent').AsString) +
              ', '+ Utf8Decode(DM.Work.FieldByName('birthplace').AsString);
      MakeCell(srow,scol+5,w);
      MakeBold(srow,scol+5,1,l);
      MakeBorder(srow,scol+5);
      {7}
      MakeCell(srow,scol+6,U2V(DM.Work.FieldByName('register').AsString));
      MakeBorder(srow,scol+6);
      {8}
      MakeCell(srow,scol+7,U2V(DM.Work.FieldByName('owner').AsString));
      MakeBorder(srow,scol+7);
      {9}
      MakeCell(srow,scol+8,U2V(DM.Work.FieldByName('region').AsString));
      MakeBorder(srow,scol+8);
      {10}
      if DM.Work.FieldByName('place').AsInteger < FIRED_RIDER then
        MakeCell(srow,scol+9,U2V(DM.Work.FieldByName('totalfouls1').AsString))
      else
        MakeCell(srow,scol+9,U2V('СНЯТ'));
      MakeBorder(srow,scol+9);
      {11}
      if DM.Work.FieldByName('place').AsInteger < FIRED_RIDER then
        MakeCell(srow,scol+10,U2V(DM.Work.FieldByName('gittime1').AsString));
      // else - MakeCell(srow,scol+10,U2V('СНЯТ'))
      MakeBorder(srow,scol+10);
      //
      MakeBorder(srow,scol+11); //вып. норм.
      //-- подогнать высоту строки:
      // Rows("15:15").EntireRow.AutoFit
      xlApp.Rows(U2V(Trim(IntToStr(srow))+':'+Trim(IntToStr(srow)))).EntireRow.AutoFit;
      //*** следующая строка
      Inc(srow);
      DM.Work.Next;
      ProgressBar1.Position:=ProgressBar1.Position + 1;
    end;
  finally
    DM.Work.Close;
  end;
  Inc(srow);
  MakeCell(srow,scol+2,U2V('Глвный судья'));
  MakeCell(srow,scol+5,U2V(DM.RepParams.Values['REP_REFEREE']));
  // ???
  srow:=srow+2;
  MakeCell(srow,scol+2,U2V('Главный секретарь'));
  MakeCell(srow,scol+5,U2V(DM.RepParams.Values['REP_ASSISTANT']));
  //
  //поколдовать с параметрами области печати (поля и т.п.)
  srow:=srow+2;
  s := '$A$1:$'+cfg.ParamByName(Section,'DataLastCol','L')+'$'+Trim(IntToStr(srow));
  xlApp.Workbooks(2).Worksheets(1).PageSetup.PrintArea := U2V(s);
  xlApp.Workbooks(2).Worksheets(1).PageSetup.Orientation := xlPortrait;
end;
//*******************

procedure TExpFrm.MakeXLS_1(Route: Integer);
begin
  // КЛАССИКА С ПЕЕПРЫЖКОЙ
  Section:='XLSRep_1';  // секция в ini-файле
  //
  s := cfg.ParamByName(Section,'TempSheet','КЛАССИКА С ПЕРЕПРЫЖКОЙ');
  CurrSheet:=CopySheet(FindSheet(s),
                 cfg.ParamByName(Section,'TargetSheet',Trim(IntToStr(Route))+'_'+s));
  //с этого момента xlApp.Workbooks(2).Activate;
  GetStartPos;
  //
  MakeRepHeader;
  //
  DM.Work.Close;
  DM.Work.Params.Clear;
  DM.Work.SQL.Text:='select * from v_git where tournament=:par1 and route=:par2 order by "group",place,place2,queue;';
  DM.Work.ParamByName('par1').AsInteger:=DM.CurrentTournament;
  DM.Work.ParamByName('par2').AsInteger:=Route;
  try
    g := -1;
    DM.Work.Open;
    if DM.Work.IsEmpty then Exit;
    DM.Work.First;
    ProgressBar1.Max:=DM.Work.RecordCount;
    ProgressBar1.Position:=0;
    while not DM.Work.EOF do
    begin
      if g<>DM.Work.FieldByName('group').AsInteger then
      begin
        g := DM.Work.FieldByName('group').AsInteger;
        //начало нового зачёта - вставить его название;
        MakeCell(srow,scol,U2V(DM.Work.FieldByName('groupname').AsString));
        s := Trim(IntToStr(srow));
        xlApp.Range[U2V('A'+s+':'+rcol+s)].MergeCells := True;
        Inc(srow);
      end;
      {1}
      if DM.Work.FieldByName('place').AsInteger < FIRED_RIDER then
        MakeCell(srow,scol,DM.Work.FieldByName('place').AsInteger);
      MakeBorder(srow,scol);
      {2}
      //MakeCell(srow,scol,DM.Work.FieldByName('queue').AsInteger);  ?
      MakeBorder(srow,scol+1);
      {3}
      // не забыть преобразовать строки
      w := Utf8Decode(UpperCase(DM.Work.FieldByName('lastname').AsString));
      l := Length(w);
      w := w +' '+ Utf8Decode(DM.Work.FieldByName('firstname').AsString)+
              ', '+ Utf8Decode(DM.Work.FieldByName('r_year').AsString);
      MakeCell(srow,scol+2,w);
      MakeBold(srow,scol+2,1,l);
      MakeBorder(srow,scol+2);
      {4}
      MakeCell(srow,scol+3,U2V(DM.Work.FieldByName('regnum').AsString));
      MakeBorder(srow,scol+3);
      {5}
      MakeCell(srow,scol+4,U2V(DM.Work.FieldByName('category').AsString));
      MakeBorder(srow,scol+4);
      {6}
      w := Utf8Decode(UpperCase(DM.Work.FieldByName('nickname').AsString));
      l := Length(w);
      w := w +', '+ Utf8Decode(DM.Work.FieldByName('h_year').AsString) +
              ', '+ Utf8Decode(DM.Work.FieldByName('color').AsString) +
              ', '+ Utf8Decode(DM.Work.FieldByName('sex').AsString) +
              ', '+ Utf8Decode(DM.Work.FieldByName('breed').AsString) +
              ', '+ Utf8Decode(DM.Work.FieldByName('parent').AsString) +
              ', '+ Utf8Decode(DM.Work.FieldByName('birthplace').AsString);
      MakeCell(srow,scol+5,w);
      MakeBold(srow,scol+5,1,l);
      MakeBorder(srow,scol+5);
      {7}
      MakeCell(srow,scol+6,U2V(DM.Work.FieldByName('register').AsString));
      MakeBorder(srow,scol+6);
      {8}
      MakeCell(srow,scol+7,U2V(DM.Work.FieldByName('owner').AsString));
      MakeBorder(srow,scol+7);
      {9}
      MakeCell(srow,scol+8,U2V(DM.Work.FieldByName('region').AsString));
      MakeBorder(srow,scol+8);
      {10}
      if DM.Work.FieldByName('place').AsInteger < FIRED_RIDER then
        MakeCell(srow,scol+9,U2V(DM.Work.FieldByName('totalfouls1').AsString))
      else
        MakeCell(srow,scol+9,U2V('СНЯТ'));
      MakeBorder(srow,scol+9);
      {11}
      if DM.Work.FieldByName('place').AsInteger < FIRED_RIDER then
        MakeCell(srow,scol+10,U2V(DM.Work.FieldByName('gittime1').AsString));
      //else -  MakeCell(srow,scol+10,U2V('СНЯТ'));
      MakeBorder(srow,scol+10);
      {12}
      {13}
      // поля итогов перепрыжки. Если оба значения нулевые, то выводятся пробелы
      //(не участвовал в перепрыжке)
      if DM.Work.FieldByName('place2').AsInteger >= FIRED_RIDER then
        MakeCell(srow,scol+11,U2V('СНЯТ'))
      else
        if (DM.Work.FieldByName('totalfouls2').AsCurrency>0.0) or
           (DM.Work.FieldByName('gittime2').AsCurrency>0.0)    then
        begin
          MakeCell(srow,scol+11,U2V(DM.Work.FieldByName('totalfouls2').AsString));
          MakeCell(srow,scol+12,U2V(DM.Work.FieldByName('gittime2').AsString));
        end;
      //
      MakeBorder(srow,scol+11);
      MakeBorder(srow,scol+12);
      {14 -  вып.норм.}
      MakeBorder(srow,scol+13);
      //-- подогнать высоту строки:
      // Rows("15:15").EntireRow.AutoFit
      xlApp.Rows(U2V(Trim(IntToStr(srow))+':'+Trim(IntToStr(srow)))).EntireRow.AutoFit;
      //*** следующая строка
      Inc(srow);
      DM.Work.Next;
      ProgressBar1.Position:=ProgressBar1.Position+1;
    end;
  finally
    DM.Work.Close;
  end;
  Inc(srow);
  MakeCell(srow,scol+2,U2V('Глвный судья'));
  MakeCell(srow,scol+5,U2V(DM.RepParams.Values['REP_REFEREE']));
  //
  srow:=srow+2;
  MakeCell(srow,scol+2,U2V('Главный секретарь'));
  MakeCell(srow,scol+5,U2V(DM.RepParams.Values['REP_ASSISTANT']));
  //
  //поколдовать с параметрами области печати (поля и т.п.)
  srow:=srow+2;
  s := '$A$1:$'+cfg.ParamByName(Section,'DataLastCol','N')+'$'+Trim(IntToStr(srow));
  xlApp.Workbooks(2).Worksheets(1).PageSetup.PrintArea := U2V(s);
  xlApp.Workbooks(2).Worksheets(1).PageSetup.Orientation := xlPortrait;
end;

//*******************
//*******************


{$ENDIF}


end.

