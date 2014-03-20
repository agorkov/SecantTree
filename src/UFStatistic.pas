unit UFStatistic;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls;

type
  TFStatistic = class(TForm)
    Memo1: TMemo;
    Panel2: TPanel;
    procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure AddReport;

var
  FStatistic: TFStatistic;

implementation

{$R *.dfm}

uses
  UGlobal, Math, UImages, UTree, ComObj;

procedure AddReport;
  procedure AddLine(Msg, Value: string);
  var
    MsgStr, ValueStr: string;
    Ml, Mr, Vl, Vr: byte;
    i: byte;
  begin
    MsgStr := '';
    ValueStr := '';
    Ml := 0;
    Mr := 0;
    Vl := 0;
    Vr := 0;
    if Msg = '' then
      FStatistic.Memo1.Lines.Add('---------------------------------------------------')
    else
    begin
      if length(Value) < 10 then
      begin
        Vl := (10 - length(Value)) div 2;
        Vr := (10 - length(Value)) div 2;
        if Vl + Vr + length(Value) <> 10 then
          Vl := Vl + 1;
      end;
      for i := 1 to Vl do
        ValueStr := ValueStr + ' ';
      ValueStr := ValueStr + Value;
      for i := 1 to Vr do
        ValueStr := ValueStr + ' ';

      if length(Msg) < 38 then
      begin
        Ml := (38 - length(Msg)) div 2;
        Mr := (38 - length(Msg)) div 2;
        if Ml + Mr + length(Msg) <> 38 then
          Ml := Ml + 1;
      end;
      for i := 1 to Ml do
        MsgStr := MsgStr + ' ';
      MsgStr := MsgStr + Msg;
      for i := 1 to Mr do
        MsgStr := MsgStr + ' ';

      FStatistic.Memo1.Lines.Add('|' + MsgStr + '|' + ValueStr + '|');
    end;
  end;

begin
  AddLine('', '');
  AddLine('Статистка собрана в ', TimeToStr(Now));
  AddLine('', '');
  case AIS.ImgMode of
  1: // Алфавит
    begin
      AddLine('Тип массива', 'Алфавит');
      AddLine('', '');
      AddLine('Строк', inttostr(AIS.n));
      AddLine('', '');
      AddLine('Столбцов', inttostr(AIS.m));
      AddLine('', '');
      AddLine('Заданная вероятность единицы', Rnd);
      AddLine('', '');
      AddLine('Минимальная доля единиц в столбце', floattostrf(Statistic.Min1, ffFixed, 6, 5));
      AddLine('', '');
      AddLine('Максимальная доля единиц в столбце', floattostrf(Statistic.Max1, ffFixed, 6, 5));
      AddLine('', '');
      AddLine('Средняя доля единиц в столбце', floattostrf(Statistic.AVG1, ffFixed, 6, 5));
      AddLine('', '');
    end;
  2: // Система
    begin
      AddLine('Тип массива', 'Система');
      AddLine('', '');
      AddLine('Строк', inttostr(AIS.n));
      AddLine('', '');
      AddLine('Столбцов', inttostr(AIS.m));
      AddLine('', '');
      AddLine('Групп', inttostr(Statistic.DImgCount));
      AddLine('', '');
      AddLine('Заданная вероятность единицы', Rnd);
      AddLine('', '');
      AddLine('Минимальная доля единиц в столбце', floattostrf(Statistic.Min1, ffFixed, 6, 5));
      AddLine('', '');
      AddLine('Максимальная доля единиц в столбце', floattostrf(Statistic.Max1, ffFixed, 6, 5));
      AddLine('', '');
      AddLine('Средняя доля единиц в столбце', floattostrf(Statistic.AVG1, ffFixed, 6, 5));
      AddLine('', '');
    end;
  3: // Симметрический массив
    begin
      AddLine('Тип массива', 'Симметр');
      AddLine('', '');
      AddLine('Строк', inttostr(AIS.n));
      AddLine('', '');
      AddLine('Столбцов', inttostr(AIS.m));
      AddLine('', '');
      AddLine('k', inttostr(AIS.k));
      AddLine('', '');
      AddLine('Средняя доля единиц в столбце', floattostrf(Statistic.AVG1, ffFixed, 6, 5));
      AddLine('', '');
    end;
  end; { case }
  AddLine('Допустимое отклонение', floattostrf(E, ffFixed, 6, 5));
  AddLine('', '');
  AddLine('Максимальная высота дерева', inttostr(Statistic.MaxTreeHeigth));
  AddLine('', '');
  AddLine('Минимальная высота дерева', inttostr(Statistic.MinTreeHeigth));
  AddLine('', '');
  AddLine('Средняя высота дерева', floattostrf(Statistic.AVGTreeHeigth, ffFixed, 6, 5));
  AddLine('', '');
  if AIS.ImgMode = 2 then
  begin
    AddLine('Средняя высота дерева', floattostrf(Statistic.AVGTreeHeigth_H, ffFixed, 6, 5));
    AddLine(' (с учётом частоты образов)', '');
    AddLine('', '');
  end;

  AddLine('Средняя сумма', '');
  AddLine('разрядностей секущих', floattostrf(Statistic.AVGCheckCount, ffFixed, 6, 5));
  AddLine('по траекториям', '');
  AddLine('', '');

  AddLine('Среднее реальное количество', floattostrf(Statistic.AVGCheckCountR, ffFixed, 6, 5));
  AddLine('сравнений по траекториям', '');
  AddLine('', '');
  if AIS.ImgMode = 2 then
  begin
    AddLine('Среднее реальное количество сравнений', '');
    AddLine('по траекториям', floattostrf(Statistic.AVGCheckCountR_H, ffFixed, 6, 5));
    AddLine('(с учётом частоты образов)', '');
    AddLine('', '');
  end;
  AddLine('Время построения', TimeToStr(UGlobal.Statistic.te - UGlobal.Statistic.ts));
  AddLine('', '');
  AddLine('Избыточность', floattostrf(Statistic.Redundancy, ffFixed, 6, 5));
  AddLine('', '');
  AddLine('Распознаваний в секунду', inttostr(Statistic.Q));
  AddLine('', '');
  if AIS.ImgMode = 2 then
  begin
    AddLine('Распознаваний в секунду', inttostr(Statistic.Q_H));
    AddLine('(с учётом частоты образов)', '');
    AddLine('', '');
  end;
  FStatistic.Memo1.Lines.Add('');
end;

procedure TFStatistic.FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
begin
  Resize := false;
end;

end.
