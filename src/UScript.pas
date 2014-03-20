unit UScript;

interface

procedure ProcessScript(ScriptFileName: string);

implementation

uses
  UGlobal, SysUtils, UImages, UTree, Forms;

{ procedure XLS(Folder: string; SheetNum, StrNum: byte);
  var
  ExcelApp: Variant;
  ExcelDoc: Variant;
  ExcelSht: Variant;
  begin
  try
  DecimalSeparator:='.';
  ExcelApp:=CreateOleObject('Excel.Application');
  ExcelApp.Visible:=true;
  ExcelApp.DisplayAlerts:=False;
  ExcelDoc:=ExcelApp.Workbooks.Open(ExtractFilePath(Application.ExeName)+'\stat.xlsx');
  ExcelSht:=ExcelDoc.Worksheets[SheetNum].Select;
  ExcelApp.Cells[4+StrNum,3]:=inttostr(Statistic.MaxTreeHeigth);
  ExcelApp.Cells[4+StrNum,4]:=inttostr(Statistic.MinTreeHeigth);
  ExcelApp.Cells[4+StrNum,5]:=floattostr(Statistic.AVGTreeHeigth);
  ExcelApp.Cells[4+StrNum,6]:=floattostrf(Statistic.AVGCheckCount,ffFixed,6,5);
  ExcelApp.Cells[4+StrNum,7]:=floattostrf(Statistic.AVGCheckCountR,ffFixed,6,5);
  ExcelApp.Cells[4+StrNum,8]:=floattostrf(Statistic.Redundancy,ffFixed,6,5);
  ExcelApp.Cells[4+StrNum,9]:=inttostr(Statistic.Q);
  ExcelDoc.Save;
  ExcelDoc.Close;
  ExcelApp.Quit;
  finally

  end;
  end; }

procedure ProcessScript(ScriptFileName: string);
var
  f: TextFile;
  str: string;
begin
  AssignFile(f, ScriptFileName);
  reset(f);
  while not EOF(f) do
  begin

    readln(f, str);

    if str = 'N=' then
    begin
      readln(f, str);
      AIS.n := strtoint(str);
    end;
    if str = 'M=' then
    begin
      readln(f, str);
      AIS.m := strtoint(str);
    end;
    if str = 'K=' then
    begin
      readln(f, str);
      AIS.k := strtoint(str);
    end;
    if str = 'IMGMODE=' then
    begin
      readln(f, str);
      AIS.ImgMode := strtoint(str);
    end;
    if str = 'RND=' then
    begin
      readln(f, str);
      RND := str;
    end;
    if str = 'ALPHA=' then
    begin
      readln(f, str);
      Alpha := strtofloat(str);
    end;
    if str = 'BETA=' then
    begin
      readln(f, str);
      Beta := strtofloat(str);
    end;
    if str = 'LOADIMG' then
    begin
      readln(f, str);
      UImages.LoadImagesFromFile(str);
    end;
    if str = 'GENERATE' then
    begin
      UImages.GetArray;
    end;
    if str = 'E=' then
    begin
      readln(f, str);
      E := strtofloat(str);
    end;
    if str = 'LOADTREE' then
    begin
      readln(f, str);
      UTree.LoadTreeFromFile(str);
    end;
    if str = 'RUN' then
    begin
      UTree.BuildTree;
    end;
    if str = 'SAVESTATISTIC' then
    begin
      readln(f, str);
      SaveStatisticToFile(ExtractFilePath(Application.ExeName) + str);
    end;
    if str = 'MAXSECDIGIT=' then
    begin
      readln(f, str);
      UGlobal.MaxSecDigit := strtoint(str);
    end;
    if str = 'SAVEIMG' then
    begin
      readln(f, str);
      SaveImagesToFile(str);
    end;
    if str = 'SAVETREE' then
    begin
      readln(f, str);
      SaveTreeToFile(ExtractFilePath(Application.ExeName) + str);
    end;
    if str = 'EXIT' then
    begin
      Halt(0);
    end;
  end;
  CloseFile(f);
end;

end.
