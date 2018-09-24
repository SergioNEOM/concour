unit concour_params;

{$mode objfpc}{$H+}

interface

uses Classes, IniFiles;

type
  TParams = class(TObject)
    private
      IniFileName : String;
    public
      AppPath, RepPath,
      DataBaseFileName,
      XLSTempFileName : String;
      constructor Create;
      procedure SetFile(FileName:String);
      procedure GetDefaults;
      procedure LoadGeneralParams;
      function ParamByName(SectionName,ParamName: String; DefaultValue: String=''):String;
//      destructor Destroy;
  end;

var
   cfg : TParams;
{   DataBaseFileName : String;
   XLSTempFileName  : String;
   procedure InitDefaults;
   function LoadGeneralParams(ConfigFileName : String):Boolean;
   function LoadSectionParams(SectionName : String; var ParamList: TStrings):Boolean;
}
implementation

uses SysUtils;
{
*
*
*  Вместо юнита сделать форму с возможностью изменения параметров?
*
*
}


{procedure InitDefaults;
begin
  DataBaseFileName:=ChangeFileExt(ParamStr(0),'.db');
  XLSTempFileName:=ExtractFilePath(ParamStr(0))+'templates'+PathDelim+'temp.xlsx';
end;

function LoadGeneralParams(ConfigFileName : String):Boolean;
var
   cf : TIniFile;
begin
  Result := False;
  if not FileExists(ConfigFileName) then Exit;
  cf := TIniFile.Create(ConfigFileName);
  try
    DataBaseFileName:=cf.ReadString('General','DBName','');
    XLSTempFileName:=cf.ReadString('General','XLSTemp','');
    Result := True;
  finally
    cf.Free;
  end;
end;

function LoadSectionParams(SectionName : String; var ParamList: TStrings):Boolean;
var
   cf : TIniFile;
begin
  Result := False;
  if not FileExists(ConfigFileName) then Exit;
  cf := TIniFile.Create(ConfigFileName);
  try
    DataBaseFileName:=cf.ReadString('General','DBName','');
    XLSTempFileName:=cf.ReadString('General','XLSTemp','');
    Result := True;
  finally
    cf.Free;
  end;
end;
}

constructor TParams.Create;
begin
  IniFileName:='';
  AppPath:=ExtractFilePath(ParamStr(0));
end;

procedure TParams.SetFile(FileName:String);
begin
  if not FileExists(FileName) then IniFileName:=''
  else
    IniFileName:=FileName;
end;

procedure TParams.GetDefaults;
begin
  DataBaseFileName:=ChangeFileExt(ParamStr(0),'.db');
  //было    XLSTempFileName:=AppPath+'templates'+PathDelim+'temp.xlsx';
  XLSTempFileName:=ChangeFileExt(ParamStr(0),'.temp');
end;

procedure TParams.LoadGeneralParams;
begin
  DataBaseFileName:= ExpandUNCFileName(ParamByName('General','DBName',''));
  XLSTempFileName:=ExpandUNCFileName(ParamByName('General','XLSTemp',''));
  RepPath:=ExpandFileName(ParamByName('General','ReportsDir',''));
  if RightStr(RepPath,1)<>PathDelim then RepPath:=RepPath+PathDelim;
end;

function TParams.ParamByName(SectionName,ParamName: String; DefaultValue: String=''):String;
var
   cf : TIniFile;
begin
  if IniFileName='' then Exit;;
  if not FileExists(IniFileName) then Exit;
  cf := TIniFile.Create(IniFileName);
  try
    Result:=cf.ReadString(SectionName,ParamName,'');
    // если в ini-файле строки в апострофах, уберём их
    if LeftStr(Result,1)=chr(39) then Result:=AnsiDequotedStr(Result,chr(39));
    // если в ini-файле строки в кавычках, уберём их
    if LeftStr(Result,1)=chr(34) then Result:=AnsiDequotedStr(Result,'"');
    if Result='' then Result := DefaultValue;
  finally
    cf.Free;
  end;
end;

end.

