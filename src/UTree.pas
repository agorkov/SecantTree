unit UTree;

interface
uses
  UGlobal;

procedure BuildTree;
function SelectImages(NodeNum: LongWord): LongWord;
function CMPImage(p: TImg; Sec: TSec): boolean;
procedure SaveTreeToFile(FileName: string);
procedure SaveStatisticToFile(FileName: string);
function Recognition(Img: TImg;var Q: LongWord): LongWord;
procedure GetBpBm(var Bp,Bm: string; NodeNum: LongWord);
procedure LoadTreeFromFile(FileName: string);

implementation
uses
  SysUtils, IniFiles, UFMain, UFSettings, Math, UImages, UFStatistic;

function DigitCount(Sec: TSec): LongWord;
var
j: LongWord;
count: LongWord;
begin
  count:=0;
  for j:=1 to AIS.m do
    if Sec[j]<>3 then
      inc(count);
  Result:=count;
end;

procedure AddDigitToExSec(var Sec: TExSec; d: LongWord; v: boolean);
begin
  Sec.DigitCount:=Sec.DigitCount+1;
  SetLength(Sec.Sec,Sec.DigitCount+1);
  Sec.Sec[Sec.DigitCount].digit:=d;
  Sec.Sec[Sec.DigitCount].value:=v;
end;

procedure InitNode(num,prev: LongWord; direction: boolean);
begin
  Tree[num].num:=num;
  Tree[num].DSec.Sec:=nil; Tree[Num].DSec.DigitCount:=0;
  Tree[num].prev:=prev;
  Tree[num].ActiveCount:=0;
  Tree[num].Completed:=false;
  if direction then
    Tree[num].trajectory:=Tree[Tree[Num].prev].trajectory+'1'
  else
    Tree[num].trajectory:=Tree[Tree[Num].prev].trajectory+'0';
end;

function CMPImage(p: TImg; Sec: TSec): boolean;
var
j: LongWord;
fl: boolean;
begin
  j:=0; fl:=true;
  while fl and (j<AIS.m) do
  begin
    inc(j);
    if Sec[j]<>3 then
      if boolean(Sec[j])<>p[j] then
        fl:=false;
  end;
  Result:=fl;
end;

procedure GetBpBm(var Bp,Bm: string; NodeNum: LongWord);
var
j,tmpNodeNum: LongWord;
begin
  Bp:=''; Bm:='';
  tmpNodeNum:=1;
  for j:=1 to length(Tree[NodeNum].trajectory) do
  begin
    if Tree[NodeNum].trajectory[j]='1' then
    begin
      Bp:=Bp+SecExToStr(Tree[tmpNodeNum].DSec);
      tmpNodeNum:=Tree[tmpNodeNum].next;
    end
    else
    begin
      Bm:=Bm+SecExToStr(Tree[tmpNodeNum].DSec);
      tmpNodeNum:=Tree[tmpNodeNum].next+1;
    end;
  end;
  if Bp='' then
    Bp:=';|';
  if Bm='' then
    Bm:=';|';
end;

function SelectImages(NodeNum: LongWord): LongWord;
var
Bp,Bm: string;
Sec: TSec;
i: LongWord;
str: string;
c: LongWord;
begin
  GetBpBm(Bp,Bm,NodeNum);
  c:=0;
  SetLength(Sec,AIS.m+1);
  ///
  ///  Отмечаем образы, удовлетворяющие
  ///  секущей Bp
  ///
  str:=copy(Bp,1,pos('|',Bp));
  delete(Bp,1,pos('|',Bp));
  Sec:=StrToSec(str);
  for i:=1 to AIS.n do
    AImages[i,0]:=CMPImage(AImages[i],Sec);
  while length(Bp)>0 do
  begin
    str:=copy(Bp,1,pos('|',Bp));
    delete(Bp,1,pos('|',Bp));
    Sec:=StrToSec(str);
    for i:=1 to AIS.n do
      if AImages[i,0] then
        AImages[i,0]:=CMPImage(AImages[i],Sec);
  end;
  ///
  ///  Отмечаем образы, неудовлетворяющие
  ///  секущей Bm
  ///
  repeat
    str:=copy(Bm,1,pos('|',Bm));
    delete(Bm,1,pos('|',Bm));
    Sec:=StrToSec(str);
    if DigitCount(Sec)>0 then
      for i:=1 to AIS.n do
        if AImages[i,0] then
          AImages[i,0]:=not CMPImage(AImages[i],Sec);
  until length(Bm)=0;
  for i:=1 to AIS.n do
    if AImages[i,0] then
      c:=c+1;
  Result:=c;
end;

function Recognition(Img: TImg; var Q: LongWord): LongWord;
var
NodeNum: LongWord;
j: LongWord;
fl: boolean;
begin
  Q:=0; NodeNum:=1;
  while Tree[NodeNum].DSec.DigitCount>=1 do
  begin
    j:=0; fl:=true;
    while fl and (j<Tree[NodeNum].DSec.DigitCount) do
    begin
      inc(j);
      fl:=Tree[NodeNum].DSec.Sec[j].value=Img[Tree[NodeNum].DSec.Sec[j].digit];
    end;
    Q:=Q+j;
    if fl then
      NodeNum:=Tree[NodeNum].next
    else
      NodeNum:=Tree[NodeNum].next+1;
  end;
  Result:=NodeNum;
end;

procedure GetStatistic;
var
Leaves: array of LongWord;
i: LongWord;
LengthCode: LongWord;
CheckCount: LongWord;
t: TDateTime;
NodeNum,z: LongWord;
  function h: real;
  var
  i: LongWord;
  tmp: real;
  begin
    tmp:=0;
    for i:=1 to Statistic.DImgCount do
      tmp:=tmp+(Tree[Leaves[i]].ActiveCount/AIS.n)*LogN(2,(Tree[Leaves[i]].ActiveCount/AIS.n));
    Result:=-tmp;
  end;
begin

  ///
  ///  Подсчёт количества различных образов
  ///
  Statistic.DImgCount:=0;
  for i:=1 to LengthTree-1 do
  begin
    UFMain.Info('Подсчёт количества различных образов',i,LengthTree-1);
    if Tree[i].DSec.DigitCount=0 then
    begin
      Statistic.DImgCount:=Statistic.DImgCount+1;
      SetLength(Leaves,Statistic.DImgCount+1);
      Leaves[Statistic.DImgCount]:=i;
    end;
  end;

  ///
  ///  Вычисление высоты дерева
  ///
  Statistic.MinTreeHeigth:=length(Tree[Leaves[1]].trajectory);
  Statistic.MaxTreeHeigth:=0;
  Statistic.AVGTreeHeigth:=0;
  Statistic.AVGTreeHeigth_H:=0;
  for i:=1 to Statistic.DImgCount do
  begin
    UFMain.Info('Вычисление высоты дерева',i,Statistic.DImgCount);
    LengthCode:=length(Tree[Leaves[i]].trajectory);
    if LengthCode>Statistic.MaxTreeHeigth then
      Statistic.MaxTreeHeigth:=LengthCode;
    if LengthCode<Statistic.MinTreeHeigth then
      Statistic.MinTreeHeigth:=LengthCode;
    Statistic.AVGTreeHeigth:=Statistic.AVGTreeHeigth+LengthCode;
    Statistic.AVGTreeHeigth_H:=Statistic.AVGTreeHeigth_H+LengthCode*Tree[Leaves[i]].ActiveCount;
  end;
  Statistic.AVGTreeHeigth:=Statistic.AVGTreeHeigth/Statistic.DImgCount;
  Statistic.AVGTreeHeigth_H:=Statistic.AVGTreeHeigth_H/AIS.n;

  ///
  ///  Средняя сумма разрядностей секущих по траекториям
  ///
  UGlobal.Statistic.AVGCheckCount:=0;
  for i:=1 to Statistic.DImgCount do
  begin
    UFMain.Info('Вычисление средней суммы разрядностей секущих по траекториям',i,Statistic.DImgCount);
    CheckCount:=0;
    NodeNum:=Leaves[i];
    while NodeNum<>0 do
    begin
      CheckCount:=CheckCount+Tree[NodeNum].DSec.DigitCount;
      NodeNum:=Tree[NodeNum].prev;
    end;
    UGlobal.Statistic.AVGCheckCount:=UGlobal.Statistic.AVGCheckCount+CheckCount;
  end;
  UGlobal.Statistic.AVGCheckCount:=UGlobal.Statistic.AVGCheckCount/Statistic.DImgCount;

  ///
  ///Среднее реальное количество сравнений по траекториям
  ///
  UGlobal.Statistic.AVGCheckCountR:=0;
  UGlobal.Statistic.AVGCheckCountR_H:=0;
  for i:=1 to Statistic.DImgCount do
  begin
    UFMain.Info('Вычисление среднего реального количества сравнений по траекториям',i,AIS.n);
    UTree.Recognition(Tree[Leaves[i]].ActiveImages[1],CheckCount);
    UGlobal.Statistic.AVGCheckCountR:=UGlobal.Statistic.AVGCheckCountR+CheckCount;
    UGlobal.Statistic.AVGCheckCountR_H:=UGlobal.Statistic.AVGCheckCountR_H+CheckCount*Tree[Leaves[i]].ActiveCount;
  end;
  UGlobal.Statistic.AVGCheckCountR:=UGlobal.Statistic.AVGCheckCountR/Statistic.DImgCount;
  UGlobal.Statistic.AVGCheckCountR_H:=UGlobal.Statistic.AVGCheckCountR_H/AIS.n;
  UFMain.RemoveInfo;

  ///
  ///  Вычисляем количество распознаваний в секунду
  ///
  UFMain.Info('Вычисление количества распознаваний',0,0);
  Statistic.Q:=0;
  t:=Now+1/(24*60*60);
  i:=1;
  while Now<t do
  begin
    Recognition(Tree[Leaves[i]].ActiveImages[1],z);
    Statistic.Q:=Statistic.Q+1;
    i:=i+1;
    if i>Statistic.DImgCount then
      i:=1;
  end;
  UFMain.RemoveInfo;
  UFMain.Info('Вычисление количества распознаваний (с учётом частоты)',0,0);
  Statistic.Q_H:=0;
  t:=Now+1/(24*60*60);
  i:=1;
  while Now<t do
  begin
    Recognition(AImages[i],z);
    Statistic.Q_H:=Statistic.Q_H+1;
    i:=i+1;
    if i>AIS.n then
      i:=1;
  end;
  UFMain.RemoveInfo;

  UFMain.Info('Вычисление избыточности',0,0);
  Statistic.Redundancy:=Statistic.AVGTreeHeigth_H/h;
  UFMain.RemoveInfo;

  UFStatistic.AddReport;
end;

procedure BuildTree;
  function GetSec(NodeNum: LongWord): TSec;
  var
  PrimaryValues, OptUpSec, OptDownSec: TSec;
  UpPercent, DownPercent, PrevPercent: real;
  UpDigit, DownDigit: LongWord;
  PercentArr: array of boolean;
    procedure ApplyDigit(dn: longWord; dv: byte);
    var
    i: LongWord;
    begin
      for i:=1 to Tree[NodeNum].ActiveCount do
        if PercentArr[i] then
          if not (Tree[NodeNum].ActiveImages[i][dn]=boolean(dv)) then
            PercentArr[i]:=false;
    end;
    procedure GetPrimaryValues;
    var
    OptDigit: LongWord;
      function GetColValue(col: LongWord): byte;
      var
      i,c1: LongWord;
      R: byte;
      percent: real;
      begin
        c1:=0;
        for i:=1 to Tree[NodeNum].ActiveCount do
          if Tree[NodeNum].ActiveImages[i,col] then
            inc(c1);
        if c1>Tree[NodeNum].ActiveCount-c1 then
          r:=1
        else
          r:=0;
        if (c1=0) or (Tree[NodeNum].ActiveCount-c1=0) then
          r:=3
        else
        begin
          if c1>Tree[NodeNum].ActiveCount-c1 then
            Percent:=c1/Tree[NodeNum].ActiveCount
          else
            Percent:=(Tree[NodeNum].ActiveCount-c1)/Tree[NodeNum].ActiveCount;
          if Percent<UpPercent then
          begin
            UpPercent:=Percent;
            OptDigit:=col;
          end;
        end;
        Result:=r;
      end;
    var
    j: LongWord;
    begin
      OptDigit:=0;
      for j:=AIS.m downto 1 do
        PrimaryValues[j]:=GetColValue(j);
      OptUpSec[OptDigit]:=PrimaryValues[OptDigit];
      ApplyDigit(OptDigit,PrimaryValues[OptDigit]);
      PrimaryValues[OptDigit]:=3;
    end;
    {function GetPercent(Sec: TSec): real;
    var
    i: LongWord;
    count: LongWord;
    begin
      count:=0;
      for i:=1 to Tree[NodeNum].ActiveCount do
        if CMPImage(Tree[NodeNum].ActiveImages[i],Sec) then
          inc(count);
      Result:=count/Tree[NodeNum].ActiveCount;
    end;}
    function GetPercentEx(dn: longWord; dv: byte): real;
    var
    i: LongWord;
    count: LongWord;
    begin
      count:=0;
      for i:=1 to Tree[NodeNum].ActiveCount do
        if PercentArr[i] then
          if Tree[NodeNum].ActiveImages[i][dn]=boolean(dv) then
            count:=count+1;
      Result:=count/Tree[NodeNum].ActiveCount;
    end;
    procedure AddDigitToSec;
    var
    Sec: TSec;
    j: LongWord;
    percent: real;
    DownValue, UpValue: byte;
    begin
      Sec:=copy(OptUpSec,0,AIS.m+1);
      percent:=1;
      UpDigit:=0; DownDigit:=0;
      UpValue:=3; DownValue:=3;
      for j:=AIS.m downto 1 do
      begin
        if (Sec[j]=3) and (PrimaryValues[j]<>3) then
        begin
          Sec[j]:=PrimaryValues[j];
          Percent:=GetPercentEx(j,PrimaryValues[j]);
          if Percent>0.5+E then
          begin
            if Percent<UpPercent then
            begin
              UpDigit:=j;
              UpPercent:=Percent;
              UpValue:=PrimaryValues[j];
            end
            else
              if Percent=PrevPercent then
                PrimaryValues[j]:=3;
          end
          else
            if Percent>=0.5-E then
            begin
              UpDigit:=j;
              UpPercent:=Percent;
              UpValue:=PrimaryValues[j];
            end
            else
            begin
              if Percent>DownPercent then
              begin
                DownDigit:=j;
                DownPercent:=Percent;
                DownValue:=PrimaryValues[j];
              end;
              PrimaryValues[j]:=3;
            end;
            Sec[j]:=3;
        end;
        if (0.5-E<=percent) and (percent<=0.5+E) then
          break;
      end;
      OptUpSec[UpDigit]:=UpValue;
      ApplyDigit(UpDigit,UpValue);
      PrimaryValues[UpDigit]:=3;
      if DownDigit>0 then
      begin
        OptDownSec:=copy(OptUpSec,0,AIS.m+1);
        OptDownSec[DownDigit]:=DownValue;
        PrimaryValues[DownDigit]:=3;
      end;
    end;
    function InvertSec(var Sec: TSec): TSec;
    var
    j: LongWord;
    R: TSec;
    begin
      SetLength(R,AIS.m+1);
      for j:=1 to AIS.m do
      begin
        if Sec[j]<>3 then
          R[j]:=byte(not boolean(Sec[j]))
        else
          R[j]:=3;
      end;
      Result:=R;
    end;
  var
  R: TSec;
  i,j: LongWord;
  fl: boolean;

  begin
    Tree[NodeNum].Completed:=true;
    SetLength(PrimaryValues,AIS.m+1);
    SetLength(OptUpSec,AIS.m+1);
    SetLength(OptDownSec,AIS.m+1);
    SetLength(R,AIS.m+1);
    SetLength(PercentArr,Tree[NodeNum].ActiveCount+1);
    for i:=1 to Tree[NodeNum].ActiveCount do
      PercentArr[i]:=true;


    for j:=0 to AIS.m do
    begin
      OptUpSec[j]:=3;
      OptDownSec[j]:=3;
    end;
    DownPercent:=0; UpPercent:=1;
    UpDigit:=0; DownDigit:=0;
    PrevPercent:=1;

    ///
    ///  Если узел является листом,
    ///  то мы его не обрабатываем
    ///
    {if Tree[NodeNum].ActiveCount=1 then
    begin
      R:=copy(OptUpSec,0,m+1);
      Result:=R;
      Exit;
    end;}

    ///
    ///  2. Находим оптимальную
    ///  одноразрядную секущую
    ///  с собственным значением <0.5
    ///
    GetPrimaryValues;
    OptDownSec:=InvertSec(OptUpSec);
    DownPercent:=1-UpPercent;
    PrevPercent:=UpPercent;
    Tree[NodeNum].Opt1DigitPercent:=UpPercent;

    ///
    ///  3. Строим многоразрядную секущую
    ///  Если TeachType=true - производим
    ///  полное обучение. В противном случае
    ///  ограничиваемся одноразрядными секущими
    ///
    fl:=(DigitCount(PrimaryValues)=0) or (UpPercent-0.5<=E) or (0.5-DownPercent<=E);
    if UGLobal.MaxSecDigit=1 then
      fl:=true;
    while not fl do
    begin
      AddDigitToSec;
      fl:=fl or (DigitCount(PrimaryValues)=0);// Закончились все разряды
      fl:=fl or (UpPercent-0.5<=E) or (0.5-DownPercent<=E);// Попали в диапазон
      fl:=fl or ((UpDigit=0) and (DownDigit=0)); // Никак не улучшили результат
      if (UGLobal.MaxSecDigit>0) and (DigitCount(OptUpSec)>=UGLobal.MaxSecDigit) then //Превысили максимальную разрядность
        fl:=true;
      PrevPercent:=UpPercent;
    end;
    if (UpPercent-0.5<=E) or (0.5-DownPercent<=E) then
      Tree[NodeNum].StopType:=0;
    if (DigitCount(PrimaryValues)=0) then
      Tree[NodeNum].StopType:=1;
    if (UpDigit=0) and (DownDigit=0) then
      Tree[NodeNum].StopType:=2;
    if (UGLobal.MaxSecDigit>0) and (DigitCount(OptUpSec)>=UGLobal.MaxSecDigit) then
      Tree[NodeNum].StopType:=3;

    ///
    ///  4. Возвращаем результат
    ///
    if UpPercent-0.5<=0.5-DownPercent then
      R:=copy(OptUpSec,0,AIS.m+1)
    else
      R:=copy(OptDownSec,0,AIS.m+1);
    Result:=R;

    ///
    ///  Добавляем новые узлы
    ///
    for j:=1 to AIS.m do
      if R[j]<>3 then
        AddDigitToExSec(Tree[NodeNum].DSec,j,boolean(R[j]));
    if Tree[NodeNum].DSec.DigitCount>0 then
    begin
      Tree[NodeNum].next:=LengthTree;
      LengthTree:=LengthTree+2;
      InitNode(LengthTree-2,NodeNum,true);
      InitNode(LengthTree-1,NodeNum,false);

      for j:=1 to Tree[NodeNum].ActiveCount do
      begin
        if CMPImage(Tree[NodeNum].ActiveImages[j],R) then
        begin
          Tree[LengthTree-2].ActiveCount:=Tree[LengthTree-2].ActiveCount+1;
          SetLength(Tree[LengthTree-2].ActiveImages,Tree[LengthTree-2].ActiveCount+1);
          Tree[LengthTree-2].ActiveImages[Tree[LengthTree-2].ActiveCount]:=Tree[NodeNum].ActiveImages[j];
        end
        else
        begin
          Tree[LengthTree-1].ActiveCount:=Tree[LengthTree-1].ActiveCount+1;
          SetLength(Tree[LengthTree-1].ActiveImages,Tree[LengthTree-1].ActiveCount+1);
          Tree[LengthTree-1].ActiveImages[Tree[LengthTree-1].ActiveCount]:=Tree[NodeNum].ActiveImages[j];
        end
      end;
    end;
    if Tree[NodeNum].DSec.DigitCount>0 then
      Tree[NodeNum].ActiveImages:=nil;
    PercentArr:=nil;
  end;
  function FindEmptyD: LongWord;
  var
  i: LongWord;
  R: LongWord;
  begin
    i:=LengthTree; R:=0;
    while (i>0) and (R=0) do
    begin
      dec(i);
      if not Tree[i].Completed then
        R:=i;
    end;
    Result:=R;
  end;
var
tmp: LongWord;
Bp,Bm: string;
begin
  Statistic.ts:=Now;
  Bp:=';|'; Bm:=';|';
  LengthTree:=2;
  InitNode(0,0,true);
  InitNode(1,0,true);
  Tree[0].trajectory:='';
  Tree[1].trajectory:='';
  SetLength(Tree[1].ActiveImages,AIS.n+1);
  for tmp:=0 to AIS.n do
    Tree[1].ActiveImages[tmp]:=AImages[tmp];
  Tree[0].ActiveCount:=AIS.n;
  Tree[1].ActiveCount:=AIS.n;
  tmp:=1;
  UFMain.Info('Обучение дерева ',LengthTree,AIS.n*2);
  while tmp<>0 do
  begin
    GetSec(tmp);
    UFMain.Info('Обучение дерева ',LengthTree,AIS.n*2);
    tmp:=FindEmptyD;
  end;
  SetLength(Tree,LengthTree);//Освобождаем память для неиспользованных узлов
  Statistic.te:=Now;
  RemoveInfo;
  GetStatistic;
  UFMain.RemoveInfo;
end;

procedure SaveTreeToFile(FileName: string);
var
f: TextFile;
i: LongWord;
begin
  AssignFile(f,FileName);
  rewrite(f);
  writeln(f,inttostr(AIS.n));
  writeln(f,inttostr(AIS.m));
  writeln(f,inttostr(AIS.k));
  writeln(f,inttostr(AIS.ImgMode));
  writeln(f,inttostr(LengthTree));

  for i:=0 to LengthTree-1 do
  begin
    writeln(f,inttostr(Tree[i].num));
    writeln(f,inttostr(Tree[i].prev));
    writeln(f,inttostr(Tree[i].next));
    writeln(f,Tree[i].trajectory);
    writeln(f,SecExToStr(Tree[i].DSec));
    writeln(f,inttostr(Tree[i].ActiveCount));
    writeln(f,inttostr(Tree[i].StopType));
    writeln(f,floattostrf(Tree[i].Opt1DigitPercent,ffFixed,6,5));
    if (Tree[i].DSec.DigitCount=0) and (i<>0) then
      writeln(f,ImageToStr(Tree[i].ActiveImages[1]));
    Info('Сохранение дерева',i,LengthTree);
  end;
  RemoveInfo;
  CloseFile(f);
end;

procedure LoadTreeFromFile(FileName: string);
var
f: TextFile;
i,j,ImgNum: LongWord;
str: string;
begin
  AssignFile(f,FileName);
  reset(f);
  readln(f,str);
  AIS.n:=strtoint(str);
  readln(f,str);
  AIS.m:=strtoint(str);
  readln(f,str);
  AIS.k:=strtoint(str);
  readln(f,str);
  AIS.ImgMode:=strtoint(str);
  readln(f,str);
  LengthTree:=strtoint(str);
  InitArrays;
  ImgNum:=1;

  for i:=0 to LengthTree-1 do
  begin
    readln(f,str);
    Tree[i].num:=strtoint(str);
    readln(f,str);
    Tree[i].prev:=strtoint(str);
    readln(f,str);
    Tree[i].next:=strtoint(str);
    readln(f,str);
    Tree[i].trajectory:=str;
    readln(f,str);
    Tree[i].DSec:=StrToSecEx(str);
    readln(f,str);
    Tree[i].ActiveCount:=strtoint(str);
    readln(f,str);
    Tree[i].StopType:=strtoint(str);
    readln(f,str);
    Tree[i].Opt1DigitPercent:=strtofloat(str);
    if (Tree[i].DSec.DigitCount=0) and (i<>0) then
    begin
      SetLength(Tree[i].ActiveImages,Tree[i].ActiveCount+1);
      for j:=1 to Tree[i].ActiveCount do
      begin
        readln(f,str);
        Tree[i].ActiveImages[j]:=StrToImage(str);
        AImages[ImgNum]:=Tree[i].ActiveImages[1];
        ImgNum:=ImgNum+1;
      end;
    end;
    Info('Загрузка дерева',i,LengthTree);
  end;
  RemoveInfo;
  UImages.GetInfoAboutArray;
  GetStatistic;
  RemoveInfo;
  CloseFile(f);
end;

procedure SaveStatisticToFile(FileName: string);
  procedure AddLine(Msg,Value: string);
  var
  MsgStr,ValueStr: string;
  Ml,Mr,Vl,Vr: byte;
  i: byte;
  f: TextFile;
  begin
    AssignFile(f,FileName);
    if not FileExists(FileName) then
    begin
      rewrite(f);
      CloseFile(f);
    end;
    append(f);
    MsgStr:=''; ValueStr:='';
    Ml:=0; Mr:=0; Vl:=0; Vr:=0;
    if Msg='EMPTY' then
      writeln(f,'')
    else
      if Msg='' then
        writeln(f,'---------------------------------------------------')
      else
      begin
        if length(Value)<10 then
        begin
          Vl:=(10-length(Value)) div 2;
          Vr:=(10-length(Value)) div 2;
          if Vl+Vr+length(Value)<>10 then
            Vl:=Vl+1;
        end;
        for i:=1 to Vl do
          ValueStr:=ValueStr+' ';
        ValueStr:=ValueStr+Value;
        for i:=1 to Vr do
          ValueStr:=ValueStr+' ';


        if length(Msg)<38 then
        begin
          Ml:=(38-length(Msg)) div 2;
          Mr:=(38-length(Msg)) div 2;
          if Ml+Mr+length(Msg)<>38 then
            Ml:=Ml+1;
        end;
        for i:=1 to Ml do
          MsgStr:=MsgStr+' ';
        MsgStr:=MsgStr+Msg;
        for i:=1 to Mr do
          MsgStr:=MsgStr+' ';

        writeln(f,'|'+MsgStr+'|'+ValueStr+'|');
      end;
    CloseFile(f);
  end;
begin
  AddLine('','');
  AddLine('Статистка собрана в ',TimeToStr(Now));
  AddLine('','');
    case AIS.ImgMode of
  1:// Алфавит
    begin
      AddLine('Тип массива','Алфавит');
      AddLine('','');
      AddLine('Строк',inttostr(AIS.n));
      AddLine('','');
      AddLine('Столбцов',inttostr(AIS.m));
      AddLine('','');
      AddLine('Заданная вероятность единицы',Rnd);
      AddLine('','');
      AddLine('Минимальная доля единиц в столбце',floattostrf(Statistic.Min1,ffFixed,6,5));
      AddLine('','');
      AddLine('Максимальная доля единиц в столбце',floattostrf(Statistic.Max1,ffFixed,6,5));
      AddLine('','');
      AddLine('Средняя доля единиц в столбце',floattostrf(Statistic.AVG1,ffFixed,6,5));
      AddLine('','');
    end;
  2:// Система
    begin
      AddLine('Тип массива','Система');
      AddLine('','');
      AddLine('Строк',inttostr(AIS.n));
      AddLine('','');
      AddLine('Столбцов',inttostr(AIS.m));
      AddLine('','');
      AddLine('Групп',inttostr(Statistic.DImgCount));
      AddLine('','');
      AddLine('Заданная вероятность единицы',Rnd);
      AddLine('','');
      AddLine('Минимальная доля единиц в столбце',floattostrf(Statistic.Min1,ffFixed,6,5));
      AddLine('','');
      AddLine('Максимальная доля единиц в столбце',floattostrf(Statistic.Max1,ffFixed,6,5));
      AddLine('','');
      AddLine('Средняя доля единиц в столбце',floattostrf(Statistic.AVG1,ffFixed,6,5));
      AddLine('','');
    end;
  3:// Симметрический массив
    begin
      AddLine('Тип массива','Симметр');
      AddLine('','');
      AddLine('Строк',inttostr(AIS.n));
      AddLine('','');
      AddLine('Столбцов',inttostr(AIS.m));
      AddLine('','');
      AddLine('k',inttostr(AIS.k));
      AddLine('','');
      AddLine('Средняя доля единиц в столбце',floattostrf(Statistic.AVG1,ffFixed,6,5));
      AddLine('','');
    end;
  end;{case}
  AddLine('Допустимое отклонение',floattostrf(E,ffFixed,6,5));
  AddLine('','');
  AddLine('Максимальная высота дерева',inttostr(Statistic.MaxTreeHeigth));
  AddLine('','');
  AddLine('Минимальная высота дерева',inttostr(Statistic.MinTreeHeigth));
  AddLine('','');
  AddLine('Средняя высота дерева',floattostrf(Statistic.AVGTreeHeigth,ffFixed,6,5));
  AddLine('','');
  if AIS.ImgMode=2 then
  begin
    AddLine('Средняя высота дерева',floattostrf(Statistic.AVGTreeHeigth_H,ffFixed,6,5));
    AddLine(' (с учётом частоты образов)','');
    AddLine('','');
  end;

  AddLine('Средняя сумма','');
  AddLine('разрядностей секущих',floattostrf(Statistic.AVGCheckCount,ffFixed,6,5));
  AddLine('по траекториям','');
  AddLine('','');

  AddLine('Среднее реальное количество',floattostrf(Statistic.AVGCheckCountR,ffFixed,6,5));
  AddLine('сравнений по траекториям','');
  AddLine('','');
  if AIS.ImgMode=2 then
  begin
    AddLine('Среднее реальное количество сравнений','');
    AddLine('по траекториям',floattostrf(Statistic.AVGCheckCountR_H,ffFixed,6,5));
    AddLine('(с учётом частоты образов)','');
    AddLine('','');
  end;
  AddLine('Время построения',TimeToStr(UGlobal.Statistic.te-UGlobal.Statistic.ts));
  AddLine('','');
  AddLine('Избыточность',floattostrf(Statistic.Redundancy,ffFixed,6,5));
  AddLine('','');
  AddLine('Распознаваний в секунду',inttostr(Statistic.Q));
  AddLine('','');
  if AIS.ImgMode=2 then
  begin
    AddLine('Распознаваний в секунду',inttostr(Statistic.Q_H));
    AddLine('(с учётом частоты образов)','');
    AddLine('','');
  end;
  AddLine('EMPTY','');
end;

end.
