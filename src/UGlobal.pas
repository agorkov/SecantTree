unit UGlobal;

interface

uses
  Windows;

const
  Version='f(11.12.2010)';

type

  TImg = array of boolean;// Один образ
  TAImages = array of TImg;// Массив образов

  TSec = array of byte;// Секущая

  TRSecDigit = record// Один разряд секущей
    digit: LongWord;
    value: boolean;
  end;
  TExSec = record//
    DigitCount: LongWord;
    Sec: array of TRSecDigit;
  end;
  TRNode = record// Один узел дерева
    DSec: TExSec;
    Opt1DigitPercent: real;
    ActiveImages: TAImages;
    ActiveCount: LongWord;
    num,prev,next: LongWord;// Номера текущего и предыдущего узлов
    Completed: boolean;
    trajectory: string;
    StopType: byte;
  end;
  TTree = array of TRNode;// Дерево

  TRStatistic = record
    ///
    ///  Информация о массиве
    ///
    Min1,Max1,AVG1: real;
    DImgCount: LongWord;
    ///
    ///  Информация о высоте дерева
    ///
    MinTreeHeigth, MaxTreeHeigth: LongWord;
    AVGTreeHeigth, AVGTreeHeigth_H: real;
    ///
    ///  Средняя сумма разрядностей секущих по траекториям
    ///  Среднее реальное количество сравнений по траекториям
    ///
    AVGCheckCount, AVGCheckCountR, AVGCheckCountR_H: real;
    ///
    ///  Количество распознаваний в секунду
    ///
    Q, Q_H: LongWord; // Количеств распознаваний в секунду
    ///
    ///  Избыточность
    ///
    Redundancy: real;
    ///
    ///  Время начала и окончания построения дерева
    ///
    ts,te: TDateTime;// Время начала и окончания построения дерева
  end;

  TREvents = record
    ImagesCompleted: boolean;
    TreeCompleted: boolean;
  end;

  TRAImagesSetting = record
    n,m,k: LongWord;
    ImgMode: byte;///  1 - алфавит
                  ///  2 - система
                  ///  3- симметрический массив
  end;

var

  AIS: TRAImagesSetting;

  AImages: TAImages;// Массив образов

  Tree: TTree;// Дерево

  LengthTree: LongWord;// Длина построенного дерева

  Rnd: string;// Вероятность появления единицы при случайном заполнении массива образов
  Alpha, Beta: real;

  E: real;// Допустимое отклонение от оптимального деления

  Statistic: TRStatistic;

  Events: TREvents;

  MaxSecDigit: LongWord;

  function StrToSec(str: string): TSec;
  function SecToStr(Sec: TSec): string;

  function StrToImage(str: string): TImg;
  function ImageToStr(Image: TImg): string;

  function SecExToStr(Sec: TExSec): string;
  function StrToSecEx(str: string): TExSec;

  procedure InitArrays();
  procedure UpDateMode(ImagesCmpltd,TreeCmpltd: boolean);

implementation
uses
  SysUtils,
  UFMain, UDM;

procedure UpDateMode(ImagesCmpltd,TreeCmpltd: boolean);
var
Repaint: boolean;
begin
  Repaint:=true;
  if (Events.ImagesCompleted<>ImagesCmpltd) or (Events.TreeCompleted<>TreeCmpltd) then
    Repaint:=true;

  Events.ImagesCompleted:=ImagesCmpltd;
  Events.TreeCompleted:=TreeCmpltd;

  UFMain.FMain.BGenerateImages.Enabled:=true;
  UFMain.FMain.BLoadImages.Enabled:=true;
  UDM.DM.NLoadImages.Enabled:=true;
  UDM.DM.NLoadTree.Enabled:=true;

  if ImagesCmpltd then
    UDM.DM.NSaveImages.Enabled:=true
  else
    UDM.DM.NSaveImages.Enabled:=false;
  if TreeCmpltd then
    UDM.DM.NSaveTree.Enabled:=true
  else
    UDM.DM.NSaveTree.Enabled:=false;
  if TreeCmpltd and ImagesCmpltd then
    UDM.DM.NRecognize.Enabled:=true;
  if (ImagesCmpltd) and (not TreeCmpltd) then
    UFMain.FMain.BBuiltTree.Enabled:=true
  else
    UFMain.FMain.BBuiltTree.Enabled:=false;
  if TreeCmpltd then
    UFMain.FMain.BHW.Enabled:=true
  else
    UFMain.FMain.BHW.Enabled:=false;

  UDM.DM.NRecognize.Enabled:=TreeCmpltd;

  if Repaint then
  begin
    UFMain.ShowImages;
  end;
end;

function StrToSec(str: string): TSec;
var
j: LongWord;
SecPart,d,v: string;
R: TSec;
begin
  SetLength(R,AIS.m+1);
  for j:=1 to AIS.m do
    R[j]:=3;
  while pos(';',str)<>0 do
  begin
    SecPart:=copy(str,1,pos(';',str)-1);
    delete(str,1,pos(';',str));
    if str[1]='|' then
      delete(str,1,1);
    if length(SecPart)>0 then
    begin
      d:=copy(SecPart,1,pos('=',SecPart)-1);
      v:=copy(SecPart,pos('=',SecPart)+1,1);
      R[strtoint(d)]:=strtoint(v);
    end;
    end;
  Result:=R;
end;

function StrToSecEx(str: string): TExSec;
var
SecPart,d,v: string;
R: TExSec;
begin
  R.DigitCount:=0; R.Sec:=nil;
  while pos(';',str)<>0 do
  begin
    SecPart:=copy(str,1,pos(';',str)-1);
    delete(str,1,pos(';',str));
    if str[1]='|' then
      delete(str,1,1);
    if length(SecPart)>0 then
    begin
      d:=copy(SecPart,1,pos('=',SecPart)-1);
      v:=copy(SecPart,pos('=',SecPart)+1,1);
      R.DigitCount:=R.DigitCount+1;
      SetLength(R.Sec,R.DigitCount+1);
      R.Sec[R.DigitCount].digit:=strtoint(d);
      R.Sec[R.DigitCount].value:=boolean(strtoint(v));
    end;
  end;
  Result:=R;
end;

function SecToStr(Sec: TSec): string;
var
j: LongWord;
R: string;
begin
  R:='';
  for j:=1 to AIS.m do
    if Sec[j]<>3 then
      R:=R+inttostr(j)+'='+inttostr(Sec[j])+';';
  if length(R)=0 then
    R:=R+';';
  Result:=R+'|';
end;

function SecExToStr(Sec: TExSec): string;
var
j: LongWord;
R: string;
begin
  R:='';
  for j:=1 to Sec.DigitCount do
    R:=R+inttostr(Sec.Sec[j].digit)+'='+inttostr(integer(Sec.Sec[j].value))+';';
  if length(R)=0 then
    R:=R+';';
  Result:=R+'|';
end;

function StrToImage(str: string): TImg;
var
j: LongWord;
R: TImg;
begin
  SetLength(R,AIS.m+1);
  for j:=1 to AIS.m do
    if str[j]='1' then
      R[j]:=true
    else
      R[j]:=false;
  Result:=R;
end;

function ImageToStr(Image: TImg): string;
var
j: LongWord;
R: string;
begin
  R:='';
  for j:=1 to AIS.m do
    if Image[j] then
      R:=R+'1'
    else
      R:=R+'0';
  Result:=R;
end;

procedure InitArrays();
var
i: LongWord;
begin
  if AImages<>nil then
    AImages:=nil;

  SetLength(AImages,AIS.n+1);
  for i:=0 to AIS.n do
  begin
    SetLength(AImages[i],AIS.m+1);
    if (AIS.n>1000) and (i mod 1000 =0) then
      UFMain.Info('Выделение памяти',i,AIS.n);
  end;

  Tree:=nil;
  SetLength(Tree,2*AIS.n);
end;

initialization
begin
  Rnd:='0,5';
  E:=0;
  AIS.k:=2;
  AIS.n:=7;
  AIS.m:=4;
  AIS.ImgMode:=1;
  InitArrays;
  Events.ImagesCompleted:=false;
  Events.TreeCompleted:=false;
  Alpha:=0.001; Beta:=0.999;
  MaxSecDigit:=0;
end;

end.
