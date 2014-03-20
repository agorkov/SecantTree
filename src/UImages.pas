unit UImages;

interface

uses
  UGlobal;

procedure GetArray;
procedure SaveImagesToFile(FileName: string);
procedure LoadImagesFromFile(FileName: string);
procedure GetInfoAboutArray;

implementation

uses
  SysUtils, UFMain, Forms, MathPars;

procedure GetArray;
  procedure GetRandomAlphabet;
    function CheckArray(p: LongWord): boolean;
    var
      i, j: LongWord;
      fl: boolean;
    begin
      fl := true;
      i := 0;
      while (fl) and (i < p - 1) do
      begin
        inc(i);
        if i <> p then
        begin
          fl := false;
          j := 0;
          while (not fl) and (j < AIS.m) do
          begin
            inc(j);
            if AImages[i][j] <> AImages[p][j] then
              fl := true;
          end;
        end;
      end;
      Result := fl;
    end;

  var
    i, j: LongWord;
    tmp: real;
    MP: TMathParser;
    p: array of real;
    minP, maxP, A, B: real;
  begin
    SetLength(p, AIS.m + 1);
    if pos('x', Rnd) = 0 then
    begin
      for j := 1 to AIS.m do
        p[j] := strtofloat(Rnd);
    end
    else
    begin
      MP := TMathParser.Create(nil);
      for j := 1 to AIS.m do
      begin
        MP.Expression := Rnd;
        MP.Variables.Clear;
        MP.Variables.Add('x=' + inttostr(j));
        p[j] := MP.Execute;
      end;
      MP.Free;
      maxP := p[1];
      minP := p[1];
      for j := 1 to AIS.m do
      begin
        if maxP < p[j] then
          maxP := p[j];
        if minP > p[j] then
          minP := p[j];
      end;
      A := (Beta - Alpha) / (maxP - minP);
      B := Alpha - A * minP;
      for j := 1 to AIS.m do
        p[j] := A * p[j] + B;
    end;

    InitArrays;
    for i := 1 to AIS.n do
      repeat
        for j := 1 to AIS.m do
        begin
          tmp := random;
          AImages[i][j] := tmp <= p[j];
        end;
        UFMain.Info('Генерация алфавита', i, AIS.n);
      until CheckArray(i);
    p := nil;
    UImages.GetInfoAboutArray;
    UFMain.RemoveInfo;
  end;
  procedure GetRandomSystem;
  var
    i, j: LongWord;
    tmp: real;
    MP: TMathParser;
    p: array of real;
    minP, maxP, A, B: real;
  begin
    SetLength(p, AIS.m + 1);
    if pos('x', Rnd) = 0 then
    begin
      for j := 1 to AIS.m do
        p[j] := strtofloat(Rnd);
    end
    else
    begin
      MP := TMathParser.Create(nil);
      for j := 1 to AIS.m do
      begin
        MP.Expression := Rnd;
        MP.Variables.Clear;
        MP.Variables.Add('x=' + inttostr(j));
        p[j] := MP.Execute;
      end;
      MP.Free;
      maxP := p[1];
      minP := p[1];
      for j := 1 to AIS.m do
      begin
        if maxP < p[j] then
          maxP := p[j];
        if minP > p[j] then
          minP := p[j];
      end;
      A := (Beta - Alpha) / (maxP - minP);
      B := Alpha - A * minP;
      for j := 1 to AIS.m do
        p[j] := A * p[j] + B;
    end;

    InitArrays;
    for i := 1 to AIS.n do
    begin
      for j := 1 to AIS.m do
      begin
        tmp := random;
        AImages[i][j] := tmp <= p[j];
      end;
      UFMain.Info('Генерация системы', i, AIS.n);
    end;
    p := nil;
    UImages.GetInfoAboutArray;
    UFMain.RemoveInfo;
  end;
  procedure GetSymmetricArray;
    function Cnk(n, k: LongWord): LongWord;
      function NOD(A, B: Longint): Longint;
      begin
        while (A <> 0) and (B <> 0) do
          if (A > B) then
            A := A mod B
          else
            B := B mod A;
        if (A = 0) then
          Result := B
        else
          Result := A;
      end;

    var
      i, u, d, tmp: LongWord;
    begin
      u := 1;
      d := 1;
      for i := 1 to k do
      begin
        u := u * (n - i + 1);
        d := d * i;
        tmp := NOD(u, d);
        if tmp > 1 then
        begin
          u := u div tmp;
          d := d div tmp;
        end;
      end;
      Result := u;
    end;

  var
    BC, PBSP, PBIC, DigitNum, p: LongWord;
    str: string;
    i, j: LongWord;
    Img: TImg;
  begin
    AIS.n := Cnk(AIS.m, AIS.k);
    InitArrays;
    p := 0;

    str := '';
    for i := 1 to AIS.k do
      str := str + '1';
    for i := AIS.k + 1 to AIS.m do
      str := str + '0';

    p := p + 1;
    Img := StrToImage(str);
    AImages[p] := copy(Img, 0, AIS.m + 1);

    str := '';
    for i := 1 to AIS.m do
      str := str + '0';
    Img := StrToImage(str);
    AImages[0] := copy(Img, 0, AIS.m + 1);

    BC := 1;
    PBSP := 1;
    PBIC := 1;

    while BC < AIS.k + 1 do
    begin
      DigitNum := AIS.k + 1 - BC;
      for i := 1 to PBIC do
      begin
        for j := DigitNum + 1 to AIS.m do
        begin
          str := ImageToStr(AImages[PBSP + i - 1]);
          if str[j] = '1' then
            break
          else
          begin
            str[DigitNum] := '0';
            str[j] := '1';
            p := p + 1;
            Img := StrToImage(str);
            AImages[p] := copy(Img, 0, AIS.m + 1);
            UFMain.Info('Генерация симметрического алфавита', p, AIS.n);
          end;
        end;
      end;
      PBIC := p - (PBSP + PBIC) + 1;
      PBSP := p - PBIC + 1;
      BC := BC + 1;
    end;
    UImages.GetInfoAboutArray;
    UFMain.RemoveInfo;
  end;

begin
  case AIS.ImgMode of
  1: GetRandomAlphabet;
  2: GetRandomSystem;
  3: GetSymmetricArray;
  end; { case }
end;

procedure SaveImagesToFile(FileName: string);
var
  i, j: LongWord;
  f: TextFile;
  c: char;
begin
  AssignFile(f, FileName);
  rewrite(f);
  // writeln(f,AIS.ImgMode);
  // writeln(f,AIS.n);
  writeln(f, AIS.m);
  // if AIS.ImgMode=3 then
  // writeln(f,AIS.k);
  for i := 1 to AIS.n do
  begin
    for j := 1 to AIS.m do
    begin
      c := inttostr(byte(AImages[i, j]))[1];
      write(f, c);
    end;
    writeln(f, ' 1');
    UFMain.Info('Запись в файл', i, AIS.n);
  end;
  CloseFile(f);
  UFMain.RemoveInfo;
end;

procedure LoadImagesFromFile(FileName: string);
var
  i, j: LongWord;
  f: TextFile;
  c: char;
  str: string;
begin
  AssignFile(f, FileName);
  reset(f);
  readln(f, str);
  AIS.ImgMode := strtoint(str);
  readln(f, str);
  AIS.n := strtoint(str);
  readln(f, str);
  AIS.m := strtoint(str);
  if AIS.ImgMode = 3 then
  begin
    readln(f, str);
    AIS.k := strtoint(str);
  end;
  InitArrays;
  for i := 1 to AIS.n do
  begin
    for j := 1 to AIS.m do
    begin
      read(f, c);
      if c = '1' then
        AImages[i][j] := true
      else
        AImages[i][j] := false;
    end;
    readln(f);
    UFMain.Info('Загрузка из файла', i, AIS.n);
  end;
  CloseFile(f);
  UImages.GetInfoAboutArray;
  UFMain.RemoveInfo;
end;

///
/// Вычисляем минимальное, максимальное и среднее
/// процентное отношение единиц в столбце
///
procedure GetInfoAboutArray;
///
/// Вычисляем процент единиц в столбце
///
  function Get1Percent(tnum: LongWord): real;
  var
    i, count: LongWord;
    percent: real;
  begin
    count := 0;
    for i := 1 to AIS.n do
      if AImages[i, tnum] then
        count := count + 1;
    percent := count / AIS.n;
    Result := percent;
  end;

var
  j: LongWord;
  tmp: real;
begin
  Statistic.min1 := Get1Percent(1);
  Statistic.max1 := Statistic.min1;
  Statistic.avg1 := Statistic.max1;
  for j := 2 to AIS.m do
  begin
    tmp := Get1Percent(j);
    Statistic.avg1 := Statistic.avg1 + tmp;
    if tmp > Statistic.max1 then
      Statistic.max1 := tmp;
    if tmp < Statistic.min1 then
      Statistic.min1 := tmp;
  end;
  Statistic.avg1 := Statistic.avg1 / AIS.m;
end;

end.
