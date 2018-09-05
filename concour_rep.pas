unit concour_rep;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

const
  REP_HEADER = './templates/header.tmp';
  REP_FOOTER = './templates/footer.tmp';
  S_B        = '<strong>';
  S_N        = '</strong>';
  G          = '>';
  RS2        = ' rowspan="2">';
  RS3        = ' rowspan="3">';
  CS2        = ' colspan="2">';
  CS4        = ' colspan="4">';
  BORDER     = '1px solid #808080; ';
  TH_STYLE   = '<th style="border-top:'+BORDER+'border-bottom:'+BORDER+
                    'border-left:'+BORDER+'border-right:'+BORDER+
                    '" valign="middle" align="center"';
  TH_STYLE3  = TH_STYLE+RS3;
  TD_STYLED  = '<td style="border-top:'+BORDER+
                    'border-bottom:'+BORDER+
                    'border-left:'+BORDER+
                    'border-right:'+BORDER+
                    '" valign="middle" align="center">';

{ REPORT (HTML)
    1. Common header (<!doctype html ...
    2. case reptype of
        NumCols = ...
        RepWrite...
    3. for each rep:
    4.   rep header
    5.   rep data
             for each records: <tr> <td>...</td></tr>
    6.   rep footer
    7. Common footer
}

type
  TRep = object
    RepTitle: String;
    RepFileName : String;
    public
      //constructor Create(Title : String);
      //destructor Destroy;
  end;

var
  RepFileName : String;
  RepFile     : TextFile;
  MainRep    : TStringList;
  //
  function RepInitialize: Boolean;
  function RepWriteHeader:Boolean;
  function RepWriteData: Boolean;
  function RepDeploy:Boolean;
  procedure RepView;
  procedure RepWriteBody(StartRep:Integer=0);
  //
  procedure MakeStartList(ShowPenalties:Boolean=False);
  procedure MakeRep_0;   // классика
  procedure MakeRep_1;   // с перепрыжкой

implementation

uses  LazUTF8, LCLIntf, RegExpr, Dialogs, db, concour_main, concour_DM, concour_params;

function RepInitialize: Boolean;
begin
  Result := True;
  MainRep:=TStringList.Create;
  if Trim(RepFileName)='' then
    RepFileName:= cfg.ParamByName('General','RepNamePrefix','concour_report_')+
                  FormatDateTime('dd-mm-yyyy',now);
end;

function RepWriteHeader: Boolean;
var
  re : TRegExpr;
  s : String;
  i : Integer;
begin
  Result := False;
  if FileExists(REP_HEADER) then
  begin
    MainRep.LoadFromFile(REP_HEADER);
    //todo: если надо, подставляем данные из параметров отчета (название, маршрут, зачёт)
    re := TRegExpr.Create; //'<!--{{name}}-->'
    try
      re.Expression := '<!--\{\{\S+\}\}-->';
      if re.Exec(MainRep.Text) then
      begin
        if re.MatchLen[0]>11 then      // на всякий случай ;-)
        begin
          {s := Copy(MainRep,re.;
           s := Replace(s, '', False);}
          s := copy(re.Match[0],7,Length(re.Match[0])-11);
          //ShowMessage('|'+re.Match[0]+'|'+s);
          //i:=RepParams.IndexOfName(s);
          //if i>=0 then
          try
            MainRep.Text := re.Replace(MainRep.Text,DM.RepParams.Values[s],False);
          except
          end;
        end;
      end;
    finally
      re.Free;
    end;
    Result := True;
  end;
end;

function RepWriteData: Boolean;     // не применяется...
var
  re, sre : TRegExpr;
  f : TField;
  s,ss,w : String;
  i1,i2 : Integer;
{  function ParseRec(ins:String): String;
  begin
    Result := ins;
    f := nil;
    sre := TRegExpr.Create;  // для поиска подстановок в цикле  '<!--{:name:}-->'
    sre.ModifierG := False;
    try
      sre.Expression:='<!--\{\:\S+\:\}-->';
      if sre.Exec(Result) then
      try
          w := LowerCase(copy(sre.Match[0],7,sre.MatchLen[0]-11));
          f := DM.Work.FindField(w);
          if Assigned(f) then
          begin
            Result := sre.Replace(Result,DM.Work.FieldByName(w).AsString,False);
          end;
          //else Result := sre.Replace(Result,'*'+w+'*',False);
        finally
          f := nil;
        end;
    finally
      sre.Free;
    end;
  end;
}
function ParseRec(ins: String):String;
var i:Integer;
begin
  Result := ins;
  sre := TRegExpr.Create;  // для поиска подстановок в цикле  '<!--{:field_name:}-->'
  sre.ModifierG := False;
  try
    for i:=0 to DM.Work.FieldCount-1 do
    begin
      sre.Expression:='<!--\{\:'+DM.Work.Fields[i].FieldName+'\:\}-->';
      Result :=sre.Replace(Result,DM.Work.Fields[i].AsString,False);
    end;
  finally
    sre.Free;
  end;
end;

begin
  Result := False;
  re := TRegExpr.Create;   //ищем '<!--{#REPEAT#}-->' (длина - 17)
  re.ModifierG:=False;
  try
    re.Expression := '<!--\{#REPEAT#\}-->';
    if re.Exec(MainRep.Text) then
    begin
      i1 := re.MatchPos[0];
      if re.ExecNext then i2 := re.MatchPos[0] else i2 := Length(MainRep.Text);
      s := copy(MainRep.Text,i1+17,i2-i1-17);
      DM.Work.Close;
      DM.Work.Params.Clear;
      DM.Work.SQL.Text:='SELECT * FROM "v_git";';
      DM.Work.Open;
      if DM.Work.IsEmpty then Exit;
      DM.Work.First;
      ss := '';
      while not DM.Work.EOF do
      begin
        ss := ss + ParseRec(s);
        DM.Work.Next;
      end;
      MainRep.Text := LeftStr(MainRep.Text,i1-1)+ss+copy(MainRep.Text,i2+17,999); //re.Replace(MainRep.Text,ss,False);
      //MainRep.Text:=re.Replace(MainRep.Text,'***',False);
    end;
  finally
    re.Free;
  end;
  Result := True;
end;


function RepDeploy: Boolean;
begin
  Result := False;
  try
    MainRep.Add('</body></html>');
    RepFileName := RepFileName + '.html';
    MainRep.SaveToFile(RepFileName);
    Result := True;
  except
  end;
  MainRep.Free;
end;

procedure RepView;
begin
  OpenDocument(RepFileName);
end;


procedure RepWriteBody(StartRep:Integer=0);
var
  colnum, z  : Integer;
  s : String;
begin
  //if not FileExists(REP_HEADER) then Exit;
  //MainRep.LoadFromFile(REP_HEADER);
  MainRep.Add('<!DOCTYPE HTML><html><head><meta http-equiv="content-type" content="text/html; charset=utf-8"/>');
  MainRep.Add('<title></title><meta name="generator" content="SVS"/><meta name="author" content="SVS"/>');
  MainRep.Add('<meta name="created" content="2018-07-01"/><style type="text/css">');
  MainRep.Add('html {font-family:"Arial",sans-serif; font-size:12px;}');
  MainRep.Add('th {background-color:#FFFFCC;font-size:1em;font-weight:bold;border:1px solid #808080;}');
  MainRep.Add('td.nob {font-size:1.2em;border:none;}');
  MainRep.Add('td {font-size:1.2em;border:1px solid #808080;}</style></head><body>');
  MainRep.Add('<img src="./templates/ФКСРФ.jpg" width=206 height=57 hspace=15 vspace=1>');
  MainRep.Add('<table cellspacing="0" border="0"><thead>');
  MainRep.Add('<tr><td class="nob" colspan="12">&nbsp;</td></tr>');
  MainRep.Add('<tr><td class="nob" colspan="12" align="center"><h1>'+DM.RepParams.Values['REP_TITLE']+'</h1></td></tr>');
  MainRep.Add('<tr><td class="nob" colspan="12">&nbsp;</td></tr>');
  MainRep.Add('<tr><td class="nob" colspan="12" align="center"><h2>'+DM.RepParams.Values['REP_SUBTITLE']+'</h2></td></tr>');
  MainRep.Add('<tr><td class="nob" colspan="12">&nbsp;</td></tr>');
  MainRep.Add('<tr><td class="nob" colspan="3">'+DM.RepParams.Values['REP_PLACE']+'</td>');
   MainRep.Add('<td class="nob" colspan="6">&nbsp;</td>');
   MainRep.Add('<td class="nob" colspan="3">'+DM.RepParams.Values['REP_DATE']+'</td></tr>');
  MainRep.Add('<colgroup width="40"></colgroup>');
  MainRep.Add('<colgroup width="40"></colgroup>');
  MainRep.Add('<colgroup width="180"></colgroup>');
  MainRep.Add('<colgroup width="80"></colgroup>');
  MainRep.Add('<colgroup width="60"></colgroup>');
  MainRep.Add('<colgroup width="240"></colgroup>');
  MainRep.Add('<colgroup width="60"></colgroup>');
  MainRep.Add('<colgroup width="120"></colgroup>');
  MainRep.Add('<colgroup width="160"></colgroup>');
  if StartRep>0 then
    MakeStartList(StartRep>1)
  else
    case (1 shl DM.CurrRouteType) of
      ROUTE_CLASSIC:  MakeRep_0;  // Классика
      ROUTE_OVERLAP:  MakeRep_1;  // перепрыжка
    end;
  //--
  MainRep.Add('<tr><td class="nob" colspan="12">&nbsp;</td></tr><tr><td class="nob" colspan="2">&nbsp;</td><td class="nob" colspan="3">Главный судья</td><td class="nob" colspan="3">'+DM.RepParams.Values['REP_REFEREE']+'</td></tr>');
  MainRep.Add('<tr><td class="nob" colspan="12">&nbsp;</td></tr><tr><td class="nob" colspan="2">&nbsp;</td><td class="nob" colspan="3">Главный секретарь</td><td class="nob" colspan="3">'+DM.RepParams.Values['REP_ASSISTANT']+'</td></tr>');
  MainRep.Add('</table>');
  //MainRep.SaveToFile(RepFileName);
  //OpenDocument(RepFileName);
end;

//
//
//

procedure MakeStartList(ShowPenalties:Boolean=False);
var
  i: Integer;
begin
  if ShowPenalties then RepFileName := RepFileName+'_Судейский протокол'
  else RepFileName := RepFileName+'_Стартовый протокол';

{ всё это есть в RepWriteBody()
  // header
  MainRep.Add('<!DOCTYPE HTML><html><head><meta http-equiv="content-type" content="text/html; charset=utf-8"/>');
  MainRep.Add('<title></title><meta name="generator" content="SVS"/><meta name="author" content="SVS"/>');
  MainRep.Add('<meta name="created" content="2018-07-01"/><style type="text/css">');
  MainRep.Add('html {font-family:"Arial",sans-serif; font-size:14px;}');
  MainRep.Add('th {background-color:#FFFFCC;font-size:1em;font-weight:bold;border:1px solid #808080;}');
  MainRep.Add('td {font-size:1.2em;border:1px solid #808080;}</style></head><body>');
  MainRep.Add('<img src="./templates/ФКСРФ.jpg" width=206 height=57 hspace=15 vspace=1>');
  MainRep.Add('<h1>'+RepParams.Values['REP_TITLE']+'</h1>');
  MainRep.Add('<h2>'+RepParams.Values['REP_SUBTITLE']+'</h2>');
  MainRep.Add('<h3>Стартовый протокол</h3>');
  MainRep.Add('<p>'+RepParams.Values['REP_PLACE']+'</p>');
  MainRep.Add('<table cellspacing="0" border="0"><thead>');
//
  MainRep.Add('<colgroup width="40"></colgroup>');
  MainRep.Add('<colgroup width="180"></colgroup>');
  MainRep.Add('<colgroup width="180"></colgroup>');
  MainRep.Add('<colgroup width="80"></colgroup>');
  MainRep.Add('<colgroup width="60"></colgroup>');
  MainRep.Add('<colgroup width="240"></colgroup>');
  MainRep.Add('<colgroup width="60"></colgroup>');
  MainRep.Add('<colgroup width="120"></colgroup>');
  MainRep.Add('<colgroup width="160"></colgroup>');
}

  if ShowPenalties then
  for i:=1 to 16 do
    MainRep.Add('<colgroup width="64"></colgroup>');
  //
  MainRep.Add('<tr><th valign="middle" align="center">№ п/п</th><th align="center">Зачёт</th>');
  MainRep.Add('<th align="center">Всадник</th><th align="center">Рег.№</th>');
  MainRep.Add('<th align="center">Звание,<br>разряд</th><th align="center">Кличка лошади, г.р., масть, пол,<br> порода, отец, место рождения</th>');
  MainRep.Add('<th align="center">Рег.№</th><th align="center">Владелец</th>');
  MainRep.Add('<th align="center">Команда,<br>регион</th>');
  if ShowPenalties then
  begin
    for i:=1 to MainFrm.Barriers1SpinEdit.MaxValue do
      MainRep.Add('<th align="center">'+Inttostr(i)+'</th>');
    MainRep.Add('<th align="center">Время</th>');
  end;
  MainRep.Add('</tr></thead><tbody>');
  //
  DM.Work.Close;
  DM.Work.Params.Clear;
  if MainFrm.OverlapCB.Checked and (MainFrm.OverList <> '') then
    //перепрыжка
    DM.Work.SQL.Text:='select * from v_git where tournament=:par1 and route=:par2 '+
    ' and id in ('+MainFrm.OverList+') order by "group",place,queue;'
  else
    DM.Work.SQL.Text:='select * from v_git where tournament=:par1 and route=:par2 order by queue;'; //group by "group"
  DM.Work.ParamByName('par1').AsInteger:=DM.CurrentTournament;
  DM.Work.ParamByName('par2').AsInteger:=DM.CurrentRoute;
  try
    DM.Work.Open;
    if DM.Work.IsEmpty then Exit;
    DM.Work.First;
    while not DM.Work.EOF do
    begin
      MainRep.Add(Format('<tr><td>%s</td><td>%s</td><td><strong>%s</strong><br>%s,%s</td><td>%s</td><td>%s</td><td><strong>%s,%s</strong>,%s,<br>%s,%s,<br>%s,%s</td><td>%s</td><td>%s</td><td>%s</td>',
         [{1} DM.Work.FieldByName('queue').AsString,
          {2} DM.Work.FieldByName('groupname').AsString,
          {3} DM.Work.FieldByName('lastname').AsString,
               DM.Work.FieldByName('firstname').AsString,
               DM.Work.FieldByName('r_year').AsString,
          {4} DM.Work.FieldByName('regnum').AsString,
          {5} DM.Work.FieldByName('category').AsString,
          {6} DM.Work.FieldByName('nickname').AsString,
               DM.Work.FieldByName('h_year').AsString,
               DM.Work.FieldByName('color').AsString,
               DM.Work.FieldByName('sex').AsString,
               DM.Work.FieldByName('breed').AsString,
               DM.Work.FieldByName('parent').AsString,
               DM.Work.FieldByName('birthplace').AsString,
          {7} DM.Work.FieldByName('register').AsString,
          {8} DM.Work.FieldByName('owner').AsString,
          {9} DM.Work.FieldByName('region').AsString
          ]));
      //
      if ShowPenalties then
      begin
        if DM.Work.FieldByName('place').AsInteger >= FIRED_RIDER then
          MainRep.Add('<td colspan="'+IntToStr(MainFrm.Barriers1SpinEdit.MaxValue + 1)+
            '" align="center">СНЯТ</td>')
        else
          for i:=1 to MainFrm.Barriers1SpinEdit.MaxValue + 1 {+время} do
            MainRep.Add('<td></td>');
      end;
      MainRep.Add('</tr>');
      //
      DM.Work.Next;
    end;
  finally
    DM.Work.Close;
  end;
end;

//
//
//

procedure MakeRep_0;
var
  colnum, z  : Integer;
  s : String;
begin
  // Классика
  RepFileName:=RepFileName+'_КЛАССИКА';
  colnum:= 12; //(12 колонок)
  //  отличия от основного заголовка
  MainRep.Add('<colgroup span="2" width="60"></colgroup>');
  MainRep.Add('<colgroup width="40"></colgroup>');
  //
  MainRep.Add('<tr><th valign="middle" align="center" rowspan="3">Место</th><th valign="middle" align="center" rowspan="3">№ лошади</th>');
  MainRep.Add('<th align="center" rowspan="3">Всадник</th><th align="center" rowspan="3">Рег.№</th>');
  MainRep.Add('<th align="center" rowspan="3">Звание,<br>разряд</th><th align="center" rowspan="3">Кличка лошади, г.р., масть, пол,<br> порода, отец, место рождения</th>');
  MainRep.Add('<th align="center" rowspan="3">Рег.№</th><th align="center" rowspan="3">Владелец</th>');
  MainRep.Add('<th align="center" rowspan="3">Команда,<br>регион</th><th align="center" colspan="2">Результат</th>');
  MainRep.Add('<th align="center" rowspan="3">Вып.<br>норм.</th></tr><th align="center" colspan="2">Маршрут</th><tr>');
  MainRep.Add('<th align="center">Ш.о.</th><th align="center">Время</th></tr></thead><tbody>');
  //
  DM.Work.Close;
  DM.Work.Params.Clear;
  DM.Work.SQL.Text:='select * from v_git where tournament=:par1 and route=:par2 order by "group",place,queue;'; //group by "group"
  DM.Work.ParamByName('par1').AsInteger:=DM.CurrentTournament;
  DM.Work.ParamByName('par2').AsInteger:=DM.CurrentRoute;
  try
    DM.Work.Open;
    if DM.Work.IsEmpty then Exit;
    DM.Work.First;
    z := -1;
    while not DM.Work.EOF do
    begin
      if z<>DM.Work.FieldByName('group').AsInteger then
      begin
        // new group
        z := DM.Work.FieldByName('group').AsInteger;
        MainRep.Add(Format('<tr><td colspan="'+trim(inttostr(colnum))+'">%s</td></tr>',[DM.Work.FieldByName('groupname').AsString]));
      end;
      if DM.Work.FieldByName('place').AsInteger >= FIRED_RIDER then  s := ''
      else s:= DM.Work.FieldByName('place').AsString;
      MainRep.Add(Format('<tr><td>%s</td><td>%s</td><td><strong>%s</strong><br>%s,%s</td><td>%s</td><td>%s</td><td><strong>%s,%s</strong>,%s,<br>%s,%s,<br>%s,%s</td><td>%s</td><td>%s</td><td>%s</td>',
         [{1} s,
          {2} DM.Work.FieldByName('queue').AsString,
          {3} DM.Work.FieldByName('lastname').AsString,
               DM.Work.FieldByName('firstname').AsString,
               DM.Work.FieldByName('r_year').AsString,
          {4} DM.Work.FieldByName('regnum').AsString,
          {5} DM.Work.FieldByName('category').AsString,
          {6} DM.Work.FieldByName('nickname').AsString,
               DM.Work.FieldByName('h_year').AsString,
               DM.Work.FieldByName('color').AsString,
               DM.Work.FieldByName('sex').AsString,
               DM.Work.FieldByName('breed').AsString,
               DM.Work.FieldByName('parent').AsString,
               DM.Work.FieldByName('birthplace').AsString,
          {7} DM.Work.FieldByName('register').AsString,
          {8} DM.Work.FieldByName('owner').AsString,
          {9} DM.Work.FieldByName('region').AsString]));
      if s='' then
        MainRep.Add('<td colspan="2" align="center">СНЯТ</td><td></td></tr>')
      else
        MainRep.Add(Format('<td>%s</td><td>%s</td><td></td></tr>',[
          {10}DM.Work.FieldByName('sumfouls1').AsString,
          {11}DM.Work.FieldByName('gittime1').AsString
          ]));
      //
      DM.Work.Next;
    end;
  finally
    DM.Work.Close;
  end;
end;

procedure MakeRep_1;
var
  colnum, z  : Integer;
  s : String;
begin
  // с перепрыжкой
  RepFileName:=RepFileName+'_КЛАССИКА С ПЕРЕПРЫЖКОЙ';
  colnum:= 14; //(14 колонок)
  //  отличия от основного заголовка
  MainRep.Add('<colgroup span="2" width="60"></colgroup>');
  MainRep.Add('<colgroup span="2" width="60"></colgroup>');
  MainRep.Add('<colgroup width="40"></colgroup>');
  //
  MainRep.Add('<tr><th valign="middle" align="center" rowspan="3">Место</th><th valign="middle" align="center" rowspan="3">№ лошади</th>');
  MainRep.Add('<th align="center" rowspan="3">Всадник</th><th align="center" rowspan="3">Рег.№</th>');
  MainRep.Add('<th align="center" rowspan="3">Звание,<br>разряд</th><th align="center" rowspan="3">Кличка лошади, г.р., масть, пол,<br> порода, отец, место рождения</th>');
  MainRep.Add('<th align="center" rowspan="3">Рег.№</th><th align="center" rowspan="3">Владелец</th>');
  MainRep.Add('<th align="center" rowspan="3">Команда,<br>регион</th><th align="center" colspan="4">Результат</th>');
  MainRep.Add('<th align="center" rowspan="3">Вып.<br>норм.</th></tr><th align="center" colspan="2">Маршрут</th>');
  MainRep.Add('<th align="center" colspan="2">Перепрыжка</th></tr><th align="center">Ш.о.</th><th align="center">Время</th>');
  MainRep.Add('<th align="center">Ш.о.</th><th align="center">Время</th></tr></thead><tbody>');
  //
  DM.Work.Close;
  DM.Work.Params.Clear;
  DM.Work.SQL.Text:='select * from v_git where tournament=:par1 and route=:par2 order by "group",place,place2,queue;';
  //
  DM.Work.ParamByName('par1').AsInteger:=DM.CurrentTournament;
  DM.Work.ParamByName('par2').AsInteger:=DM.CurrentRoute;
  try
    DM.Work.Open;
    if DM.Work.IsEmpty then Exit;
    DM.Work.First;
    z := -1;
    while not DM.Work.EOF do
    begin
      if z<>DM.Work.FieldByName('group').AsInteger then
      begin
        // new group
        z := DM.Work.FieldByName('group').AsInteger;
        MainRep.Add(Format('<tr><td colspan="'+trim(inttostr(colnum))+'">%s</td></tr>',[DM.Work.FieldByName('groupname').AsString]));
      end;
      if DM.Work.FieldByName('place').AsInteger >= FIRED_RIDER then  s := ''
      else s:= DM.Work.FieldByName('place').AsString;
      MainRep.Add(Format('<tr><td>%s</td><td>%s</td><td><strong>%s</strong><br>%s,%s</td><td>%s</td><td>%s</td><td><strong>%s,%s</strong>,%s,<br>%s,%s,<br>%s,%s</td><td>%s</td><td>%s</td><td>%s</td>',
         [{1} s,
          {2} DM.Work.FieldByName('queue').AsString,
          {3} DM.Work.FieldByName('lastname').AsString,
               DM.Work.FieldByName('firstname').AsString,
               DM.Work.FieldByName('r_year').AsString,
          {4} DM.Work.FieldByName('regnum').AsString,
          {5} DM.Work.FieldByName('category').AsString,
          {6} DM.Work.FieldByName('nickname').AsString,
               DM.Work.FieldByName('h_year').AsString,
               DM.Work.FieldByName('color').AsString,
               DM.Work.FieldByName('sex').AsString,
               DM.Work.FieldByName('breed').AsString,
               DM.Work.FieldByName('parent').AsString,
               DM.Work.FieldByName('birthplace').AsString,
          {7} DM.Work.FieldByName('register').AsString,
          {8} DM.Work.FieldByName('owner').AsString,
          {9} DM.Work.FieldByName('region').AsString]));
      if s='' then
        MainRep.Add('<td colspan="4" align="center">СНЯТ</td><td></td></tr>')
      else
        MainRep.Add(Format('<td>%s</td><td>%s</td><td>%s</td><td>%s</td><td></td></tr>',[
          {10}DM.Work.FieldByName('sumfouls1').AsString,
          {11}DM.Work.FieldByName('gittime1').AsString,
          {12}DM.Work.FieldByName('sumfouls2').AsString,
          {13}DM.Work.FieldByName('gittime2').AsString
          ]));
      //
      DM.Work.Next;
    end;
  finally
    DM.Work.Close;
  end;
end;

{function RepWriteData: Boolean;
begin
  Result := False;
  MainRep.Add('<table cellspacing="0" border="0">');
  //todo: дату отчета - вводить
  MainRep.Add('<thead><tr>');
  MainRep.Add(TH_STYLE3+'Место</th>');
  MainRep.Add(TH_STYLE3+'Всадник</th>');
  MainRep.Add(TH_STYLE3+'Рег.№</th>');
  MainRep.Add(TH_STYLE3+'Категория</th>');
  MainRep.Add(TH_STYLE3+'Кличка лошади, г.р., масть, пол,<br> порода, отец, место рождения</th>');
  MainRep.Add(TH_STYLE3+'Рег.№</th>');
  MainRep.Add(TH_STYLE3+'Владелец</th>');
  MainRep.Add(TH_STYLE3+'Команда,<br>регион</th>');
  MainRep.Add(TH_STYLE+CS4+'Результат</th></tr>');
  MainRep.Add(TH_STYLE+CS2+'Маршрут</th>');
  MainRep.Add(TH_STYLE+CS2+'Перепрыжка</th></tr>');
  MainRep.Add(TH_STYLE+G+'Ш.о.</th>');
  MainRep.Add(TH_STYLE+G+'Время</th>');
  MainRep.Add(TH_STYLE+G+'Ш.о.</th>');
  MainRep.Add(TH_STYLE+G+'Время</th>');
  MainRep.Add('</tr></thead>');
  MainRep.Add('<tbody>');
  DM.Work.Close;
  DM.Work.Params.Clear;
  DM.Work.SQL.Text:='SELECT * FROM "v_git";';
  DM.Work.Open;
  if DM.Work.IsEmpty then Exit;
  DM.Work.First;
  while not DM.Work.EOF do
  begin
    MainRep.Add('<tr>');
    MainRep.Add(TD_STYLED+DM.Work.FieldByName('id').AsString+'</td>');
    MainRep.Add(TD_STYLED+S_B+uppercase(DM.Work.FieldByName('lastname').AsString)+S_N+
     '<br>'+DM.Work.FieldByName('firstname').AsString+','+DM.Work.FieldByName('r_year').AsString+'</td>');
    MainRep.Add(TD_STYLED+DM.Work.FieldByName('regnum').AsString+'</td>');
    MainRep.Add(TD_STYLED+DM.Work.FieldByName('category').AsString+'</td>');
    MainRep.Add(TD_STYLED+S_B+uppercase(DM.Work.FieldByName('nickname').AsString)+S_N+
      '<br>'+DM.Work.FieldByName('h_year').AsString+','+
      DM.Work.FieldByName('color').AsString+','+DM.Work.FieldByName('sex').AsString+','+
      '<br>'+DM.Work.FieldByName('breed').AsString+','+DM.Work.FieldByName('parent').AsString+','+
      '</td>');
    MainRep.Add(TD_STYLED+DM.Work.FieldByName('register').AsString+'</td>');
    MainRep.Add(TD_STYLED+DM.Work.FieldByName('owner').AsString+'</td>');
    MainRep.Add(TD_STYLED+DM.Work.FieldByName('region').AsString+'</td>');
    MainRep.Add(TD_STYLED+DM.Work.FieldByName('sumfouls1').AsString+'</td>');
    MainRep.Add(TD_STYLED+DM.Work.FieldByName('foul1_time').AsString+'</td>');
    MainRep.Add(TD_STYLED+DM.Work.FieldByName('sumfouls2').AsString+'</td>');
    MainRep.Add(TD_STYLED+DM.Work.FieldByName('foul2_time').AsString+'</td>');
    MainRep.Add('</tr>');
    DM.Work.Next;
  end;
  MainRep.Add('</tbody></table>');
  Result := True;
end;
}



end.

