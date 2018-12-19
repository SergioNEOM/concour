unit JL_DM;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, sqlite3conn, sqldb, FileUtil;

type

  { TDM }

  TDM = class(TDataModule)
    DataSource1: TDataSource;
    Work_DS: TDataSource;
    SQLite3Connection1: TSQLite3Connection;
    SQLQuery1: TSQLQuery;
    Work: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
  private

  public
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
    // Tournaments
    procedure OpenTournaments(CurrentID: Integer);
    function AddTournament(TournamentDate, TournamentDate2, TournamentName, TournamentPlace,
         TournamentReferee, TournamentAssistant: String):Integer;
    function EditTournament(TournamentId: Integer; TournamentDate, TournamentDate2,
         TournamentName, TournamentPlace, TournamentReferee, TournamentAssistant: String):Boolean;
    function DelTournament(TournamentId: Integer):Boolean;
  end;

var
  DM: TDM;

implementation

{$R *.lfm}


procedure TDM.OpenRiders(CurrentID: Integer);
begin
  SQLQuery1.Close;
  SQLQuery1.SQL.Text:='SELECT * FROM v_riders;';
  //!! из вьюхи, где выборка CAST("поле" as char(nn))
  //т.к. иначе в DBGrid поля как МЕМО показывает
  try
    SQLQuery1.Open;
    if (not SQLQuery1.IsEmpty) and (CurrentID>0) then SQLQuery1.Locate('id',CurrentID,[]);
  except
    Exception.Create('ОШИБКА: не удалось открыть справочник всадников');
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
  SQLQuery1.Close;
  SQLQuery1.SQL.Text:='SELECT * FROM v_horses;';
    //!! из вьюхи, где выборка CAST("поле" as char(nn))
    //т.к. иначе в DBGrid поля как МЕМО показывает
  try
    SQLQuery1.Open;
    if (not SQLQuery1.IsEmpty) and (CurrentID>0) then SQLQuery1.Locate('id',CurrentID,[]);
  except
    Exception.Create('ОШИБКА: не удалось открыть справочник лошадей');
  end;
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
procedure TDM.OpenTournaments(CurrentID: Integer);
begin
  SQLQuery1.Close;
  SQLQuery1.SQL.Text:='SELECT * FROM v_tournaments;';
  try
    SQLQuery1.Open;
    if (not SQLQuery1.IsEmpty) and (CurrentID>0) then SQLQuery1.Locate('id',CurrentID,[]);
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


end.

