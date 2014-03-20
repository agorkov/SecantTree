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
  AddLine('��������� ������� � ', TimeToStr(Now));
  AddLine('', '');
  case AIS.ImgMode of
  1: // �������
    begin
      AddLine('��� �������', '�������');
      AddLine('', '');
      AddLine('�����', inttostr(AIS.n));
      AddLine('', '');
      AddLine('��������', inttostr(AIS.m));
      AddLine('', '');
      AddLine('�������� ����������� �������', Rnd);
      AddLine('', '');
      AddLine('����������� ���� ������ � �������', floattostrf(Statistic.Min1, ffFixed, 6, 5));
      AddLine('', '');
      AddLine('������������ ���� ������ � �������', floattostrf(Statistic.Max1, ffFixed, 6, 5));
      AddLine('', '');
      AddLine('������� ���� ������ � �������', floattostrf(Statistic.AVG1, ffFixed, 6, 5));
      AddLine('', '');
    end;
  2: // �������
    begin
      AddLine('��� �������', '�������');
      AddLine('', '');
      AddLine('�����', inttostr(AIS.n));
      AddLine('', '');
      AddLine('��������', inttostr(AIS.m));
      AddLine('', '');
      AddLine('�����', inttostr(Statistic.DImgCount));
      AddLine('', '');
      AddLine('�������� ����������� �������', Rnd);
      AddLine('', '');
      AddLine('����������� ���� ������ � �������', floattostrf(Statistic.Min1, ffFixed, 6, 5));
      AddLine('', '');
      AddLine('������������ ���� ������ � �������', floattostrf(Statistic.Max1, ffFixed, 6, 5));
      AddLine('', '');
      AddLine('������� ���� ������ � �������', floattostrf(Statistic.AVG1, ffFixed, 6, 5));
      AddLine('', '');
    end;
  3: // �������������� ������
    begin
      AddLine('��� �������', '�������');
      AddLine('', '');
      AddLine('�����', inttostr(AIS.n));
      AddLine('', '');
      AddLine('��������', inttostr(AIS.m));
      AddLine('', '');
      AddLine('k', inttostr(AIS.k));
      AddLine('', '');
      AddLine('������� ���� ������ � �������', floattostrf(Statistic.AVG1, ffFixed, 6, 5));
      AddLine('', '');
    end;
  end; { case }
  AddLine('���������� ����������', floattostrf(E, ffFixed, 6, 5));
  AddLine('', '');
  AddLine('������������ ������ ������', inttostr(Statistic.MaxTreeHeigth));
  AddLine('', '');
  AddLine('����������� ������ ������', inttostr(Statistic.MinTreeHeigth));
  AddLine('', '');
  AddLine('������� ������ ������', floattostrf(Statistic.AVGTreeHeigth, ffFixed, 6, 5));
  AddLine('', '');
  if AIS.ImgMode = 2 then
  begin
    AddLine('������� ������ ������', floattostrf(Statistic.AVGTreeHeigth_H, ffFixed, 6, 5));
    AddLine(' (� ������ ������� �������)', '');
    AddLine('', '');
  end;

  AddLine('������� �����', '');
  AddLine('������������ �������', floattostrf(Statistic.AVGCheckCount, ffFixed, 6, 5));
  AddLine('�� �����������', '');
  AddLine('', '');

  AddLine('������� �������� ����������', floattostrf(Statistic.AVGCheckCountR, ffFixed, 6, 5));
  AddLine('��������� �� �����������', '');
  AddLine('', '');
  if AIS.ImgMode = 2 then
  begin
    AddLine('������� �������� ���������� ���������', '');
    AddLine('�� �����������', floattostrf(Statistic.AVGCheckCountR_H, ffFixed, 6, 5));
    AddLine('(� ������ ������� �������)', '');
    AddLine('', '');
  end;
  AddLine('����� ����������', TimeToStr(UGlobal.Statistic.te - UGlobal.Statistic.ts));
  AddLine('', '');
  AddLine('������������', floattostrf(Statistic.Redundancy, ffFixed, 6, 5));
  AddLine('', '');
  AddLine('������������� � �������', inttostr(Statistic.Q));
  AddLine('', '');
  if AIS.ImgMode = 2 then
  begin
    AddLine('������������� � �������', inttostr(Statistic.Q_H));
    AddLine('(� ������ ������� �������)', '');
    AddLine('', '');
  end;
  FStatistic.Memo1.Lines.Add('');
end;

procedure TFStatistic.FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
begin
  Resize := false;
end;

end.
