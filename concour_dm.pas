unit concour_DM;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqlite3conn, sqldb, db, FileUtil;

const
  CRE_RIDERS = 'CREATE TABLE IF NOT EXISTS "horses" ('+
                    '"id" Integer NOT NULL PRIMARY KEY AUTOINCREMENT,'+
                    '"nickname" VARCHAR(25) NOT NULL,'+
                    '"birthdate" int,'+
                    '"color" VARCHAR(25),'+
                    '"sex" VARCHAR(25),'+
                    '"breed" VARCHAR(25),'+
                    '"parent" VARCHAR(25),'+
                    '"birthplace" VARCHAR(25),'+
                    '"register" VARCHAR(25),'+
                    '"owner"  VARCHAR(25));';
  CHECK_TABLE = 'SELECT count(*) as res FROM sqlite_master WHERE type='+chr(39)+'table'+chr(39)+' AND name=';

 //---
 GIT_ORDER_Q = 1;
 GIT_ORDER_R = 2;
 //---

 SEL_GIT =
 //поле с названием зачёта и left join ?
    'SELECT git._rowid_ as id, git.tournament, git.route, '+
         'git."queue" as queue, git."rider" as rider, git.place, '+
         'git.place2, git."group", groups.groupname, git.overlap, '+
         'cast(riders."lastname" as char(30))||" "||cast(riders."firstname" as char(25)) as lastname, cast(riders."regnum" as char(10)) as regnum, '+
         'cast(riders."category" as char(10)) as category, git.horse as horse, '+
         'cast(horses."nickname" as CHAR(25)) as nickname, cast(horses."register" as CHAR(25)) as register, '+
         'cast(horses."owner" as CHAR(25)) as owner, cast(riders."region" as char(50)) as region,'+
         'git."foul1_b1" as foul1_b1, git."foul1_b2" as foul1_b2, git."foul1_b3" as foul1_b3, '+
         'git."foul1_b4" as foul1_b4, git."foul1_b5" as foul1_b5, git."foul1_b6" as foul1_b6, '+
         'git."foul1_b7" as foul1_b7, git."foul1_b8" as foul1_b8, git."foul1_b9" as foul1_b9, '+
         'git."foul1_b10" as foul1_b10, git."foul1_b11" as foul1_b11, git."foul1_b12" as foul1_b12, '+
         'git."foul1_b13" as foul1_b13, git."foul1_b14" as foul1_b14, git."foul1_b15" as foul1_b15, '+
         'git."gittime1" as gittime1, git."foul1_time" as foul1_time, '+
         'git."foul2_b1" as foul2_b1, git."foul2_b2" as foul2_b2, git."foul2_b3" as foul2_b3, '+
         'git."foul2_b4" as foul2_b4, git."foul2_b5" as foul2_b5, git."foul2_b6" as foul2_b6, '+
         'git."foul2_b7" as foul2_b7, git."foul2_b8" as foul2_b8, git."foul2_b9" as foul2_b9, '+
         'git."foul2_b10" as foul2_b10, git."foul2_b11" as foul2_b11, git."foul2_b12" as foul2_b12, '+
         'git."foul2_b13" as foul2_b13, git."foul2_b14" as foul2_b14, git."foul2_b15" as foul2_b15, '+
         'git."gittime2" as gittime2, git."foul2_time" as foul2_time, '+
         'git."sumfouls1" as sumfouls1, git."sumfouls2" as sumfouls2, '+
         'git.totalfouls1, git.totalfouls2, git."sumfouls" as sumfouls '+
         'FROM "git" left join "riders" on git."rider"=riders._rowid_ '+
                   ' left join "horses" on git."horse"=horses._rowid_ '+
                   ' left join "groups" on git."group"=groups._rowid_ '+
         ' WHERE git.tournament=:partour and git.route=:parroute';
GIT_OVERLAP = ' and git.overlap>0 ';
GIT_ORD_QUE = ' ORDER BY git.queue, git._rowid_;';
GIT_ORD_RANK = ' ORDER BY git."group", git.place, git.place2, git.queue;';
 //
 UPD_GIT = 'UPDATE "git" SET "tournament"=:tournament, "route"=:route, "group"=:group, '+
         '"queue"=:queue, "rider"=:rider, "horse"=:horse, place=:place, '+
         '"foul1_b1"=:foul1_b1, "foul1_b2"=:foul1_b2, "foul1_b3"=:foul1_b3, "foul1_b4"=:foul1_b4, '+
         '"foul1_b5"=:foul1_b5, "foul1_b6"=:foul1_b6, "foul1_b7"=:foul1_b7, "foul1_b8"=:foul1_b8, '+
         '"foul1_b9"=:foul1_b9, "foul1_b10"=:foul1_b10, "foul1_b11"=:foul1_b11, "foul1_b12"=:foul1_b12, '+
         '"foul1_b13"=:foul1_b13, "foul1_b14"=:foul1_b14, "foul1_b15"=:foul1_b15, '+
         '"gittime1"=:gittime1, "foul1_time"=:foul1_time, "sumfouls1"=:sumfouls1, '+
         '"foul2_b1"=:foul2_b1, "foul2_b2"=:foul2_b2, "foul2_b3"=:foul2_b3, "foul2_b4"=:foul2_b4, '+
         '"foul2_b5"=:foul2_b5, "foul2_b6"=:foul2_b6, "foul2_b7"=:foul2_b7, "foul2_b8"=:foul2_b8, '+
         '"foul2_b9"=:foul2_b9, "foul2_b10"=:foul2_b10, "foul2_b11"=:foul2_b11, "foul2_b12"=:foul2_b12, '+
         '"foul2_b13"=:foul2_b13, "foul2_b14"=:foul2_b14, "foul2_b15"=:foul2_b15, '+
         '"gittime2"=:gittime2, "foul2_time"=:foul2_time, "sumfouls2"=:sumfouls2, '+
         'totalfouls1=:totalfouls1, totalfouls2=:totalfouls2, "sumfouls"=:sumfouls '+
         'WHERE "git"._rowid_=:id;' ;


type

  { TDM }

  TDM = class(TDataModule)
    DS_Groups: TDataSource;
    DS_Routes: TDataSource;
    DS_Tournaments: TDataSource;
    DS_Horses: TDataSource;
    DS_Work: TDataSource;
    DS_Git: TDataSource;
    DS_Riders: TDataSource;
    DS2_Work: TDataSource;
    Routes: TSQLQuery;
    Tournaments: TSQLQuery;
    Horses: TSQLQuery;
    Work: TSQLQuery;
    Git: TSQLQuery;
    SQLConn: TSQLite3Connection;
    Riders: TSQLQuery;
    Groups: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    Work2: TSQLQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure GitAfterInsert(DataSet: TDataSet);
  private

  public
    CurrentTournament,
     CurrentRoute,
     CurrRouteType,
     CurrGitOrder  : Integer;
    CurrRouteName  : String;
    RepParams,
     ColNames: TStringList;
    //--
    function TableExists(TableName: string): Boolean;
    function CreateTable: Boolean;
    procedure FillRepParams;
    procedure SetColName(FieldName,FieldTitle: String);
    // Riders
    procedure OpenRiders(CurrentID: Integer);
    function AddRider(Birthdate:Integer; Lastname,Firstname,RegNum,Category,Trainer,Region:String):Integer;
    function EditRider(RiderId, Birthdate: Integer; Lastname,Firstname,RegNum,Category,Trainer,Region:String):Boolean;
    function DelRider(RiderId: Integer):Boolean;
    // Horses
    procedure OpenHorses(CurrentID: Integer);
    function AddHorse(Birthdate:Integer; Nickname,HColor,Sex,Breed,HParent,Birthplace,HReg,HOwner:String):Integer;
    function EditHorse(HorseId,Birthdate:Integer; Nickname,HColor,Sex,Breed,HParent,Birthplace,HReg,HOwner:String):Boolean;
    function DelHorse(HorseId: Integer):Boolean;
    // Groups
    procedure OpenGroups(CurrentID: Integer);
    function EditGroup(GroupName: string; GroupId:Integer=-1):Boolean;
    function DelGroup(GroupId: Integer): Boolean;
    // Routes
    procedure OpenRoutes(CurrentID: Integer);
    function AddRoute(RouteType, Distance1, Velocity1, Barriers1, Distance2,
             Velocity2, Barriers2: Integer; RouteName: string):Integer;
    function EditRoute(RouteID, RouteType, Distance1, Velocity1, Barriers1,
         Distance2, Velocity2, Barriers2: Integer; RouteName: string):Boolean;
    function RouteSetField(RouteID,FieldValue:Integer;FieldName: String):Boolean;
    function DelRoute(RouteId: Integer):Boolean;
    function GetRouteName(RouteId: Integer):String;
    procedure SetCurrRoute;
    function UpdateColNames:Boolean;
    // Tournaments
    procedure OpenTournaments(CurrentID: Integer);
    function AddTournament(TournamentDate, TournamentDate2, TournamentName, TournamentPlace,
         TournamentReferee, TournamentAssistant: String):Integer;
    function EditTournament(TournamentId: Integer; TournamentDate, TournamentDate2,
         TournamentName, TournamentPlace, TournamentReferee, TournamentAssistant: String):Boolean;
    function DelTournament(TournamentId: Integer):Boolean;
    procedure SetCurrTournament;
    // Git
    procedure OpenGit(CurrID:Integer; Ordered:Integer=0; Overlap:Boolean=False);
    procedure DelGit(DelID: Integer);
    function AppendGit : Integer;
    function ClearResults: Boolean;
    function GitSetField(GitId,FValue: Integer; FName:String):Boolean;
  end;

var
  DM: TDM;


implementation

{$R *.lfm}
uses concour_main, concour_params;
{ TDM }

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  //{$IFDEF UNIX}
  //  ОШИБКА исполнения (отсутствует библиотека libsqlite3.so
  // чтобы не ругалась среда исполнения, поставил пакет разработчика apt install libsqlite3-dev
  // т.к. sqlite3 уже установлена.
  //{$ENDIF}
  //{$IFDEF WINDOWS}
  // Чтобы не ругалась на библиотеку sqlite3.dll, скачал её с оф.сайта //sqlite.org
  // с учётом разрядности системы
  //{$ENDIF}
  // Получается, итоговый исполняемый файл будет в 3-х вариантах:
  // 32- и 64-разрядные комплекты
  //  concour.exe + sqlite3.dll
  // и для Ubuntu - исполняемый файл  concour (при условии, что sqlite3 уже установлен)

  CurrentTournament:=-1;
  CurrentRoute:=-1;
  CurrRouteType:= 0;
  CurrRouteName:='';
  CurrGitOrder:=GIT_ORDER_Q;
  RepParams := TStringList.Create;
  ColNames := TStringList.Create;
  SQLConn.DatabaseName := cfg.DataBaseFileName;
  try
    SQLConn.Connected:=True;
    OpenTournaments(CurrentTournament);
  except
    SQLConn.Connected:=False;
    raise Exception.Create('Не удалось открыть БД: '+SQLConn.DatabaseName);
    Halt(1000);
  end;
end;

procedure TDM.DataModuleDestroy(Sender: TObject);
begin
  try
    if Git.Active then Git.ApplyUpdates;
  except
  end;
  if Assigned(RepParams) then RepParams.Free;
  if Assigned(ColNames) then ColNames.Free;
  Git.Close;
  Groups.Close;
  Horses.Close;
  Riders.Close;
  Tournaments.Close;
end;

//**
procedure TDM.FillRepParams;
begin
  RepParams.Clear;
  if not DM.Tournaments.Active then  // м.б.закрыт к этому моменту
    DM.OpenTournaments(DM.CurrentTournament);
  if not DM.Tournaments.IsEmpty then
  begin
    RepParams.Add('REP_TITLE='+DM.Tournaments.FieldByName('tourname').AsString);
    RepParams.Add('REP_PLACE='+DM.Tournaments.FieldByName('tourplace').AsString);
    RepParams.Add('REP_DATE='+DM.Tournaments.FieldByName('Дата соревнования').AsString);
    RepParams.Add('REP_DATE2='+DM.Tournaments.FieldByName('Дата2').AsString);
    RepParams.Add('REP_REFEREE='+DM.Tournaments.FieldByName('referee').AsString);
    RepParams.Add('REP_ASSISTANT='+DM.Tournaments.FieldByName('assistant').AsString);
  end
  else
  begin
    RepParams.Add('REP_TITLE=Кубок');
    RepParams.Add('REP_PLACE=г.Тамбов');
    RepParams.Add('REP_DATE='+FormatDateTime('dd-mm-yyyy',now));
    RepParams.Add('REP_DATE2='+FormatDateTime('dd-mm-yyyy',now));
  end;
end;
//**

procedure TDM.SetColName(FieldName,FieldTitle: String);
begin
  ColNames.Values[FieldName]:=FieldTitle;
end;

//**

procedure TDM.GitAfterInsert(DataSet: TDataSet);
begin
  //вычислить след.номер очереди и записать его
  if DataSet.State in [dsInsert, dsEdit] then
  begin
    DataSet.Post;
    DataSet.Edit;
  end;
end;


function TDM.TableExists(TableName: string): Boolean;
begin
  Result := False;
  TableName := LowerCase(Trim(TableName));
  if TableName='' then exit;
  Riders.Close;
  try
    Riders.SQL.Text:=CHECK_TABLE+chr(39)+TableName+chr(39)+';';
    Riders.Open;
    if Riders.FieldByName('res').AsInteger>0 then Result := True;
  finally
    Riders.Close;
  end;
end;

function TDM.CreateTable: Boolean;
begin
  Result := False;
  if SQLConn.Connected then
  begin
    try
//    if SQLTransaction1.Active then SQLTransaction1.Commit;
      SQLTransaction1.Active:=True;
      SQLConn.ExecuteDirect(CRE_RIDERS);
      SQLTransaction1.Commit;
      Result := True;
    except
      SQLTransaction1.Rollback;
    end;
  end;
end;

procedure TDM.OpenRiders(CurrentID: Integer);
begin
  Riders.Close;
  Riders.SQL.Text:='SELECT * FROM v_riders;';  //!! из вьюхи, где выборка CAST("поле" as char(nn))
                           //т.к. иначе в DBGrid поля как МЕМО показывает
  try
    Riders.Open;
    if (not Riders.IsEmpty) and (CurrentID>0) then Riders.Locate('id',CurrentID,[]);
  except
  end;
end;

//
function TDM.AddRider(Birthdate:Integer; Lastname,Firstname,RegNum,Category,Trainer,Region:String):Integer;
begin
  Result := -1;
  Work.Close;
  Work.Params.Clear;
  Work.SQL.Text:='INSERT INTO "riders"("lastname","firstname","birthdate","regnum","category","trainer","region") '+
          ' VALUES(:p1,:p2,:p3,:p4,:p5,:p6,:p7);';
  Work.ParamByName('p1').Value:=Lastname;
  Work.ParamByName('p2').Value:=Firstname;
  Work.ParamByName('p3').Value:=Birthdate;
  Work.ParamByName('p4').Value:=RegNum;
  Work.ParamByName('p5').Value:=Category;
  Work.ParamByName('p6').Value:=Trainer;
  Work.ParamByName('p7').Value:=Region;
  try
    try
      if SQLTransaction1.Active
       then SQLTransaction1.CommitRetaining
       else SQLTransaction1.StartTransaction;
      Work.ExecSQL;
      SQLTransaction1.CommitRetaining;
      Work.Close;
      Work.Params.Clear;
      Work.SQL.Text:='SELECT last_insert_rowid() as lrid FROM "riders";';
      Work.Open;
      if not Work.IsEmpty then
      begin
        Work.First;
        Result := Work.Fields[0].AsInteger;
      end;
      OpenRiders(Result);
    except
      SQLTransaction1.Rollback;
    end;
  finally
    Work.Close;
  end;
end;

function TDM.EditRider(RiderId, Birthdate: Integer; Lastname,Firstname,RegNum,Category,Trainer,Region:String):Boolean;
begin
  Result := False;
  Work.Close;
  Work.Params.Clear;
  Work.SQL.Text:='UPDATE "riders" SET "lastname"=:par1,"firstname"=:par2,"birthdate"=:par3, '+
       ' "regnum"=:par4,"category"=:par5,"trainer"=:par6,"region"=:par7 '+
       ' WHERE _rowid_=:par8;';
  Work.ParamByName('par1').Value:=Lastname;
  Work.ParamByName('par2').Value:=Firstname;
  Work.ParamByName('par3').Value:=Birthdate;
  Work.ParamByName('par4').Value:=RegNum;
  Work.ParamByName('par5').Value:=Category;
  Work.ParamByName('par6').Value:=Trainer;
  Work.ParamByName('par7').Value:=Region;
  Work.ParamByName('par8').Value:=RiderId;
  try
    try
      if SQLTransaction1.Active
       then SQLTransaction1.CommitRetaining
       else SQLTransaction1.StartTransaction;
      Work.ExecSQL;
      SQLTransaction1.CommitRetaining;
      Result := True;
      OpenRiders(RiderId);
    except
      SQLTransaction1.Rollback;
    end;
  finally
    Work.Close;
  end;
end;

function TDM.DelRider(RiderId: Integer):Boolean;
begin
  Result := False;
  if RiderId>0 then
  try
    Work.Close;
    Work.Params.Clear;
    Work.SQL.Text:='SELECT COUNT(*) FROM git WHERE "rider"=:par1;';
    Work.ParamByName('par1').Value:=RiderId;
    Work.Open;
    if Work.IsEmpty or (Work.Fields[0].AsInteger>0) then Exit; //ошибка или есть связанные записи - удалять нельзя
    // можно удалять
    Work.Close;
    Work.Params.Clear;
    Work.SQL.Text:='DELETE FROM riders WHERE _rowid_=:par1;';
    Work.ParamByName('par1').Value:=RiderId;
    Work.ExecSQL;
    Result:=True;
  finally
    Work.Close;
  end;
  if Result then OpenRiders(-1);
end;

//***



procedure TDM.OpenHorses(CurrentID: Integer);
begin
  Horses.Close;
  Horses.SQL.Text:='SELECT * FROM v_horses;';  //!! из вьюхи, где выборка CAST("поле" as char(nn))
                           //т.к. иначе в DBGrid поля как МЕМО показывает
  try
    Horses.Open;
    if (not Horses.IsEmpty) and (CurrentID>0) then Horses.Locate('id',CurrentID,[]);
  except
  end;  ;
end;

function TDM.AddHorse(Birthdate:Integer; Nickname,HColor,Sex,Breed,HParent,Birthplace,HReg,HOwner:String):Integer;
begin
  Result := -1;
  Work.Close;
  Work.Params.Clear;
  Work.SQL.Text:='INSERT INTO "horses"("nickname","birthdate","color","sex",'+
        ' "breed","parent","birthplace","register","owner") '+
        ' VALUES(:p1,:p2,:p3,:p4,:p5,:p6,:p7,:p8,:p9);';
  Work.ParamByName('p1').Value:=Nickname;
  Work.ParamByName('p2').Value:=Birthdate;
  Work.ParamByName('p3').Value:=HColor;
  Work.ParamByName('p4').Value:=Sex;
  Work.ParamByName('p5').Value:=Breed;
  Work.ParamByName('p6').Value:=HParent;
  Work.ParamByName('p7').Value:=Birthplace;
  Work.ParamByName('p8').Value:=HReg;
  Work.ParamByName('p9').Value:=HOwner;
  try
    try
      if SQLTransaction1.Active
       then SQLTransaction1.CommitRetaining
       else SQLTransaction1.StartTransaction;
      Work.ExecSQL;
      SQLTransaction1.CommitRetaining;
      Work.Close;
      Work.Params.Clear;
      Work.SQL.Text:='SELECT last_insert_rowid() as lrid FROM "horses";';
      Work.Open;
      if not Work.IsEmpty then
      begin
        Work.First;
        Result := Work.Fields[0].AsInteger;
      end;
      OpenRiders(Result);
    except
      SQLTransaction1.Rollback;
    end;
  finally
    Work.Close;
  end;
end;

function TDM.EditHorse(HorseId,Birthdate:Integer; Nickname,HColor,Sex,Breed,HParent,Birthplace,HReg,HOwner:String):Boolean;
begin
  Result := False;
  Work.Close;
  Work.Params.Clear;
  Work.SQL.Text:='UPDATE "horses" SET "nickname"=:par1,"birthdate"=:par2,"color"=:par3,"sex"=:par4, '+
       '"breed"=:par5,"parent"=:par6,"birthplace"=:par7,"register"=:par8,"owner"=:par9 '+
       ' WHERE _rowid_=:par10;';
  Work.ParamByName('par1').Value:=Nickname;
  Work.ParamByName('par2').Value:=Birthdate;
  Work.ParamByName('par3').Value:=HColor;
  Work.ParamByName('par4').Value:=Sex;
  Work.ParamByName('par5').Value:=Breed;
  Work.ParamByName('par6').Value:=HParent;
  Work.ParamByName('par7').Value:=Birthplace;
  Work.ParamByName('par8').Value:=HReg;
  Work.ParamByName('par9').Value:=HOwner;
  Work.ParamByName('par10').Value:=HorseId;
  try
    try
      if SQLTransaction1.Active
       then SQLTransaction1.CommitRetaining
       else SQLTransaction1.StartTransaction;
      Work.ExecSQL;
      SQLTransaction1.CommitRetaining;
      Result := True;
      OpenHorses(HorseId);
    except
      SQLTransaction1.Rollback;
    end;
  finally
    Work.Close;
  end;
end;

function TDM.DelHorse(HorseId: Integer):Boolean;
begin
  Result := False;
  if HorseId>0 then
  try
    Work.Close;
    Work.Params.Clear;
    Work.SQL.Text:='SELECT COUNT(*) FROM git WHERE "horse"=:par1;';
    Work.ParamByName('par1').Value:=HorseId;
    Work.Open;
    if Work.IsEmpty or (Work.Fields[0].AsInteger>0) then Exit; //ошибка или есть связанные записи - удалять нельзя
    // можно удалять
    Work.Close;
    Work.Params.Clear;
    Work.SQL.Text:='DELETE FROM horses WHERE _rowid_=:par1;';
    Work.ParamByName('par1').Value:=HorseId;
    Work.ExecSQL;
    Result:=True;
  finally
    Work.Close;
  end;
  if Result then OpenHorses(-1);
end;


//***************

procedure TDM.OpenRoutes(CurrentID:Integer);
var
  b: boolean;
begin
  Routes.Close;
  Routes.SQL.Text:='SELECT * FROM v_routes where tournament=:p1;';
  Routes.ParamByName('p1').AsInteger:=CurrentTournament;
  //'SELECT id, routename, route_type, barriers1, barriers2, result_type FROM v_routes;';
  try
    Routes.Open;
    if (not Routes.IsEmpty) and (CurrentID>0)
    then b:=Routes.Locate('id',CurrentID,[]);
    //SetCurrRoute; устанавливать только когда требуется
  except
    raise Exception.Create('Ошибка открытия списка маршрутов');
  end;
end;


function TDM.AddRoute(RouteType, Distance1, Velocity1, Barriers1, Distance2,
     Velocity2, Barriers2: Integer; RouteName: string):Integer;
begin
  Result := -1;
  Work.Close;
  Work.Params.Clear;
  Work.SQL.Text:='INSERT INTO "routes"("routename","route_type",barriers1,distance1,velocity1,barriers2,distance2,velocity2,tournament) '+
          ' VALUES(:p1,:p2,:p3,:p4,:p5,:p6,:p7,:p8,:p9);';
  Work.ParamByName('p1').Value:=RouteName;
  Work.ParamByName('p2').Value:=RouteType;
  Work.ParamByName('p3').Value:=Barriers1;
  Work.ParamByName('p4').Value:=Distance1;
  Work.ParamByName('p5').Value:=Velocity1;
  Work.ParamByName('p6').Value:=Barriers2;
  Work.ParamByName('p7').Value:=Distance2;
  Work.ParamByName('p8').Value:=Velocity2;
  Work.ParamByName('p9').AsInteger:=CurrentTournament;
  try
    try
      if SQLTransaction1.Active
       then SQLTransaction1.CommitRetaining
       else SQLTransaction1.StartTransaction;
      Work.ExecSQL;
      SQLTransaction1.CommitRetaining;
      Work.Close;
      Work.Params.Clear;
      Work.SQL.Text:='SELECT last_insert_rowid() as lrid FROM "routes";';
      Work.Open;
      if not Work.IsEmpty then
      begin
        Work.First;
        Result := Work.Fields[0].AsInteger;
      end;
      OpenRoutes(Result);
    except
      SQLTransaction1.Rollback;
    end;
  finally
    Work.Close;
  end;
end;

function TDM.EditRoute(RouteID, RouteType, Distance1, Velocity1, Barriers1,
         Distance2, Velocity2, Barriers2: Integer;RouteName: string):Boolean;
begin
  Result := False;
  Work.Close;
  Work.Params.Clear;
  Work.SQL.Text:='UPDATE "routes" SET "routename"=:par1,"route_type"=:par2,'+
       'barriers1=:par3,distance1=:par4,velocity1=:par5,barriers2=:par6,'+
       'distance2=:par7,velocity2=:par8 '+
          ' WHERE _rowid_=:par9;';
  Work.ParamByName('par1').Value:=RouteName;
  Work.ParamByName('par2').Value:=RouteType;
  Work.ParamByName('par3').Value:=Barriers1;
  Work.ParamByName('par4').Value:=Distance1;
  Work.ParamByName('par5').Value:=Velocity1;
  Work.ParamByName('par6').Value:=Barriers2;
  Work.ParamByName('par7').Value:=Distance2;
  Work.ParamByName('par8').Value:=Velocity2;
  Work.ParamByName('par9').Value:=RouteID;
  try
    try
      if SQLTransaction1.Active
       then SQLTransaction1.CommitRetaining
       else SQLTransaction1.StartTransaction;
      Work.ExecSQL;
      SQLTransaction1.CommitRetaining;
      Result := True;
      OpenRoutes(RouteID);
    except
      SQLTransaction1.Rollback;
    end;
  finally
    Work.Close;
  end;
end;

function TDM.RouteSetField(RouteID,FieldValue:Integer;FieldName: String):Boolean;
begin
  Result := False;
  if Trim(FieldName)='' then Exit;
  if RouteID<0 then RouteID:=CurrentRoute;
  Work.Close;
  Work.Params.Clear;
  Work.SQL.Text:='UPDATE "routes" SET '+FieldName+'=:par1 WHERE _rowid_=:par2;';
  Work.ParamByName('par1').Value:=FieldValue;
  Work.ParamByName('par2').Value:=RouteID;
  try
    try
      if SQLTransaction1.Active
        then SQLTransaction1.CommitRetaining
        else SQLTransaction1.StartTransaction;
      Work.ExecSQL;
      SQLTransaction1.CommitRetaining;
      Result := True;
      //OpenRoutes(RouteID);
    except
      SQLTransaction1.Rollback;
    end;
  finally
    Work.Close;
  end;
end;

function TDM.DelRoute(RouteID: Integer):Boolean;
begin
  Result := False;
  if RouteID>0 then
  try
    Work.Close;
    Work.Params.Clear;
    Work.SQL.Text:='SELECT COUNT(*) FROM git WHERE "route"=:par1;';
    Work.ParamByName('par1').Value:=RouteID;
    Work.Open;
    if Work.IsEmpty or (Work.Fields[0].AsInteger>0) then Exit; //ошибка или есть связанные записи - удалять нельзя
    // можно удалять
    Work.Close;
    Work.Params.Clear;
    Work.SQL.Text:='DELETE FROM routes WHERE _rowid_=:par1;';
    Work.ParamByName('par1').Value:=RouteID;
    Work.ExecSQL;
    Result:=True;
  finally
    Work.Close;
  end;
  if Result then OpenRoutes(-1);
end;

function TDM.GetRouteName(RouteId: Integer):String;
var
  r : Integer;
begin
  Result := '';
  if RouteId<=0 then Exit;
  r := CurrentRoute;
  if not Routes.Active then OpenRoutes(RouteId);
  if Routes.IsEmpty then Exit;
  if Routes.Locate('id',RouteId,[]) then Result := Routes.FieldByName('routename').AsString;
  // вернуть на исходную запись...
  if r<>RouteId then Routes.Locate('id',r,[]);
end;

procedure TDM.SetCurrRoute;
begin
  if not Routes.Active then Exit; // открывать не надо, чтобы не зациклить
  ColNames.Clear;
  if Routes.IsEmpty then
  begin
    CurrentRoute:=-1;
    CurrRouteName:='<не выбран>';
    CurrRouteType:=-1;
    Exit;
  end
  else
  begin
    CurrentRoute :=Routes.FieldByName('id').AsInteger;
    CurrRouteType:=Routes.FieldByName('route_type').AsInteger;
    CurrRouteName:=Routes.FieldByName('routename').AsString;
    ColNames.DelimitedText:=Routes.FieldByName('colnames').AsString;
  end;
end;

function TDM.UpdateColNames:Boolean;
begin
  Result := False;
  Work.Close;
  Work.Params.Clear;
  Work.SQL.Text:='UPDATE "routes" SET colnames=:par1 WHERE _rowid_=:par2;';
  Work.ParamByName('par1').Value:=ColNames.DelimitedText;
  Work.ParamByName('par2').Value:=CurrentRoute;
  try
    try
      if SQLTransaction1.Active
       then SQLTransaction1.CommitRetaining
       else SQLTransaction1.StartTransaction;
      Work.ExecSQL;
      SQLTransaction1.CommitRetaining;
      Result := True;
      OpenRoutes(CurrentRoute);
    except
      SQLTransaction1.Rollback;
    end;
  finally
    Work.Close;
  end;
end;


//*******

procedure TDM.OpenGroups(CurrentID: Integer);
begin
  Groups.Close;
  Groups.SQL.Text:='SELECT * FROM v_groups;';
  try
    Groups.Open;
    if (not Groups.IsEmpty) and (CurrentID>0) then Groups.Locate('id',CurrentID,[]);
  except
  end;
end;


function TDM.EditGroup(GroupName: string; GroupId:Integer=-1):Boolean;
begin
  Result := False;
  Work.Close;
  Work.Params.Clear;
  if GroupId>0 then       //edit mode
  begin
    Work.SQL.Text:='UPDATE "groups" SET "groupname"=:par1 WHERE _rowid_=:par2;';
    Work.ParamByName('par1').Value:=GroupName;
    Work.ParamByName('par2').Value:=GroupId;
  end
  else                    // append mode
  begin
    Work.SQL.Text:='INSERT INTO "groups"("groupname") VALUES(:par1);';
    Work.ParamByName('par1').Value:=GroupName;
  end;
  try
    try
      if SQLTransaction1.Active
       then SQLTransaction1.CommitRetaining
       else SQLTransaction1.StartTransaction;
      Work.ExecSQL;
      SQLTransaction1.CommitRetaining;
      if GroupId<0 then  //добавление - узнаем новый _rowid_
      begin
        Work.Close;
        Work.Params.Clear;
        Work.SQL.Text:='SELECT last_insert_rowid() as lrid FROM "routes";';
        Work.Open;
        if not Work.IsEmpty then
        begin
          Work.First;
          GroupId := Work.Fields[0].AsInteger;
        end;
      end;
      OpenGroups(GroupId);
      Result := True;
    except
      SQLTransaction1.Rollback;
    end;
  finally
    Work.Close;
  end;
end;

function TDM.DelGroup(GroupId:Integer):Boolean;
begin
  Result := False;
  if GroupId>0 then
  try
    Work.Close;
    Work.Params.Clear;
    Work.SQL.Text:='SELECT COUNT(*) FROM git WHERE "group"=:par1;';
    Work.ParamByName('par1').Value:=GroupId;
    Work.Open;
    if Work.IsEmpty or (Work.Fields[0].AsInteger>0) then Exit;//ошибка или есть связанные записи - удалять нельзя
    // можно удалять
    Work.Close;
    Work.Params.Clear;
    Work.SQL.Text:='DELETE FROM "groups" WHERE _rowid_=:par1;';
    Work.ParamByName('par1').Value:=GroupId;
    Work.ExecSQL;
    Result:=True;
  finally
    Work.Close;
  end;
  if Result then OpenGroups(-1);
end;

{function TDM.GetGroupItems(FieldName: String): TStrings;
var
  ss : TStringList;
begin
  Result := nil;
  ss := TStringList.Create;
  if Groups.Active and not Groups.IsEmpty then
  begin
    Groups.First;
    while not Groups.EOF do
    begin
      ss.Add(Groups.FieldByName(FieldName).AsString);
      Groups.Next;
    end;
    Result := TStrings(ss);
  end;
end;}

//******

procedure TDM.OpenGit(CurrID:Integer; Ordered:Integer=0; Overlap:Boolean=False);
begin
  Git.Close;
  Git.Params.Clear;
  Git.SQL.Text:= SEL_GIT;
  //c 2018-12-26 новое условие отбора (overlap>0) в перепрыжку
  if Overlap then
    Git.SQL.Text := Git.SQL.Text + GIT_OVERLAP;//было ' AND git."_rowid_" in ('+MainFrm.OverList+') ';
  // установить или оставить порядок сортировки Git
  if Ordered<>0 then CurrGitOrder:=Ordered;
  //
  case CurrGitOrder of
    GIT_ORDER_Q:  //по протокольной очереди
         Git.SQL.Text := Git.SQL.Text + GIT_ORD_QUE;
    GIT_ORDER_R:  // по местам
         Git.SQL.Text := Git.SQL.Text + GIT_ORD_RANK ;
  end;
  //
  Git.ParamByName('partour').AsInteger:=CurrentTournament;
  Git.ParamByName('parroute').AsInteger:=CurrentRoute;
  //
  Git.UpdateSQL.Text:= UPD_GIT;
  //
  Git.Open;
  //if Git.IsEmpty then CurrID := AppendGit;
  if not Git.IsEmpty then
    if CurrID>0 then Git.Locate('id',CurrID,[]);
end;


procedure TDM.DelGit(DelID: Integer);
begin
  if DelID>0 then
  try
    Work.Close;
    Work.Params.Clear;
    Work.SQL.Text:='DELETE FROM "git" WHERE "_rowid_"=:par1;';
    Work.ParamByName('par1').AsInteger:=DelID;
    Work.ExecSQL;
    OpenGit(-1);
  finally
    Work.Close;
  end;
end;


function TDM.AppendGit:Integer;
begin
  Result := -1;
  try
    Work.Close;
    Work.Params.Clear;
    Work.SQL.Text:='INSERT INTO "git" ("tournament","route","queue","sumfouls1","sumfouls2","sumfouls") '+
                           ' VALUES ('+IntToStr(CurrentTournament)+','+IntToStr(CurrentRoute)+',0,0,0,0);';
    Work.ExecSQL;
    Work.SQL.Text:='SELECT last_insert_rowid() FROM "git";';
    Work.Open;
    if not Work.IsEmpty then
    begin
      Work.First;
      Result:= Work.Fields[0].AsInteger;
    end;
    Work.Close;
    Work.Params.Clear;
    Work.SQL.Text := 'UPDATE "git" SET "queue"=:par1 WHERE "_rowid_"=:par2;';
    Work.ParamByName('par1').AsInteger:=Result;
    Work.ParamByName('par2').AsInteger:=Result;
    Work.ExecSQL; //Чтобы новая строка показывалась в конце сортированного списка,
    //в queue пишется №записи, а при жеребьёвке пересчитается  (или можно записать max(queue)+1 ? )
    OpenGit(Result);
  finally
    Work.Close;
  end;
end;

function TDM.GitSetField(GitId,FValue: Integer; FName:String):Boolean;
begin
  try
    if SQLTransaction1.Active then SQLTransaction1.CommitRetaining;
    SQLConn.ExecuteDirect('UPDATE git SET '+FName+'='+Trim(IntToStr(FValue))+
         ' WHERE "_rowid_"='+Trim(IntToStr(GitId))+';');
    Result := True;
  except
    if SQLTransaction1.Active then SQLTransaction1.RollbackRetaining;
    Result := False;
  end;
end;


//****

function TDM.ClearResults: Boolean;
var
  i: Integer;
begin
  Result := False;
  if not Git.Active or Git.IsEmpty then Exit;
  //Очистка проводится на текущей записи
  Git.Edit;
  for i:=0 to Git.FieldCount-1 do
  begin
    if (lowercase(LeftStr(Git.Fields[i].FieldName,4))='foul') or
       (lowercase(LeftStr(Git.Fields[i].FieldName,7))='gittime') then
      Git.Fields[i].Value:=0;
  end;
  Git.Post;
  Result := True;
end;

//******

procedure TDM.OpenTournaments(CurrentID: Integer);
begin
  Tournaments.Close;
  Tournaments.SQL.Text:='SELECT * FROM v_tournaments;';
  try
    Tournaments.Open;
    if (not Tournaments.IsEmpty) and (CurrentID>0) then Tournaments.Locate('id',CurrentID,[]);
  except
    raise Exception.Create('TOURNAMENTS: Ошибка открытия');
  end;
end;

function TDM.AddTournament(TournamentDate, TournamentDate2, TournamentName, TournamentPlace,
         TournamentReferee, TournamentAssistant: String):Integer;
begin
  Result := -1;
  Work.Close;
  Work.Params.Clear;
  Work.SQL.Text:='INSERT INTO tournaments(tourdate,tourdate2,tourname,tourplace,referee,assistant) '+
          ' VALUES(:p1,:p2,:p3,:p4,:p5,:p6);';
  Work.ParamByName('p1').Value:=TournamentDate;
  Work.ParamByName('p2').Value:=TournamentDate2;
  Work.ParamByName('p3').Value:=TournamentName;
  Work.ParamByName('p4').Value:=TournamentPlace;
  Work.ParamByName('p5').Value:=TournamentReferee;
  Work.ParamByName('p6').Value:=TournamentAssistant;
  try
    try
      if SQLTransaction1.Active
       then SQLTransaction1.CommitRetaining
       else SQLTransaction1.StartTransaction;
      Work.ExecSQL;
      SQLTransaction1.CommitRetaining;
      Work.Close;
      Work.Params.Clear;
      Work.SQL.Text:='SELECT last_insert_rowid() as lrid FROM tournaments;';
      Work.Open;
      if not Work.IsEmpty then
      begin
        Work.First;
        Result := Work.Fields[0].AsInteger;
      end;
      OpenTournaments(Result);
    except
      SQLTransaction1.Rollback;
    end;
  finally
    Work.Close;
  end;
end;

function TDM.EditTournament(TournamentId: Integer; TournamentDate,TournamentDate2,
         TournamentName,TournamentPlace,TournamentReferee,TournamentAssistant: String):Boolean;
begin
  Result := False;
  Work.Close;
  Work.Params.Clear;
  Work.SQL.Text:='UPDATE tournaments SET tourdate=:par1,tourdate2=:par2,'+
       ' tourname=:par3,tourplace=:par4,referee=:par5,assistant=:par6 '+
       ' WHERE _rowid_=:par7;';
  Work.ParamByName('par1').Value:=TournamentDate;
  Work.ParamByName('par2').Value:=TournamentDate2;
  Work.ParamByName('par3').Value:=TournamentName;
  Work.ParamByName('par4').Value:=TournamentPlace;
  Work.ParamByName('par5').Value:=TournamentReferee;
  Work.ParamByName('par6').Value:=TournamentAssistant;
  Work.ParamByName('par7').Value:=TournamentId;
  try
    try
      if SQLTransaction1.Active
       then SQLTransaction1.CommitRetaining
       else SQLTransaction1.StartTransaction;
      Work.ExecSQL;
      SQLTransaction1.CommitRetaining;
      Result := True;
      OpenTournaments(TournamentId);
    except
      SQLTransaction1.Rollback;
    end;
  finally
    Work.Close;
  end;
end;

function TDM.DelTournament(TournamentId: Integer):Boolean;
begin
  Result := False;
  if TournamentId>0 then
  try
    Work.Close;
    Work.Params.Clear;
    Work.SQL.Text:='SELECT COUNT(*) FROM git WHERE "tournament"=:par1;';
    Work.ParamByName('par1').Value:=TournamentId;
    Work.Open;
    if Work.IsEmpty or (Work.Fields[0].AsInteger>0) then Exit;//ошибка или есть связанные записи - удалять нельзя
    // можно удалять
    Work.Close;
    Work.Params.Clear;
    Work.SQL.Text:='DELETE FROM "tournaments" WHERE _rowid_=:par1;';
    Work.ParamByName('par1').Value:=TournamentId;
    Work.ExecSQL;
    Result:=True;
  finally
    Work.Close;
  end;
  if Result then OpenTournaments(-1);
end;

procedure TDM.SetCurrTournament;
begin
  if not Tournaments.Active then Exit; // открывать не надо, чтобы не зациклить
  if Tournaments.IsEmpty then CurrentTournament:=-1
  else    CurrentTournament := Tournaments.FieldByName('id').AsInteger;
end;


end.

