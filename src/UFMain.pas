unit UFMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, ComCtrls;

type
  TFMain = class(TForm)
    BGenerateImages: TButton;
    SG: TStringGrid;
    FTree: TTreeView;
    LE_Bp: TLabeledEdit;
    LE_Bm: TLabeledEdit;
    LE_D: TLabeledEdit;
    BBuiltTree: TButton;
    PTree: TPanel;
    PImages: TPanel;
    PControl: TPanel;
    PStatus: TPanel;
    StatusBar1: TStatusBar;
    Splitter1: TSplitter;
    BShowStatistic: TButton;
    GBGetImages: TGroupBox;
    BLoadImages: TButton;
    GBSec: TGroupBox;
    BHW: TButton;
    ProgressBar1: TProgressBar;
    PArrayInfo: TPanel;
    PArray: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LOwnValue: TLabel;
    LImageCount: TLabel;
    LDigitSec: TLabel;
    LStopType: TLabel;
    LTrajectiry: TLabel;
    LOpt1Digit: TLabel;
    procedure BGenerateImagesClick(Sender: TObject);
    procedure SGDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure FTreeClick(Sender: TObject);
    procedure BBuiltTreeClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure BShowStatisticClick(Sender: TObject);
    procedure BLoadImagesClick(Sender: TObject);
    procedure BHWClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SGSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  procedure Info(StatusMsg: string; Progress, Max: LongWord);
  procedure RemoveInfo;
  procedure ShowImages;

var
  FMain: TFMain;

implementation

{$R *.dfm}
uses
  UHardware, UImages, UFStatistic, UDM, UGlobal, UTree, ShellAPI, UFSettings, UFImage, UScript, ComObj;

procedure Info(StatusMsg: string; Progress, Max: LongWord);
begin
  if UFSettings.FSettings.CBShowProgress.Checked then
  begin
    UFMain.FMain.ProgressBar1.Max:=Max;
    UFMain.FMain.StatusBar1.Panels[0].Text:=StatusMsg;
    UFMain.FMain.StatusBar1.Panels[1].Text:=inttostr(Progress);
    UFMain.FMain.StatusBar1.Panels[2].Text:=inttostr(Max);
    UFMain.FMain.ProgressBar1.Position:=Progress;
    Application.ProcessMessages;
  end;
end;

procedure RemoveInfo;
begin
  UFMain.FMain.ProgressBar1.Position:=0;
  UFMain.FMain.StatusBar1.Panels[0].Text:='��������...';
end;

///
///  ������� ��� ������ � StringGrid
///
procedure ShowImages;
var
i,j: LongWord;
begin
  ///
  ///  ���� �����-�� ������
  ///  ���������, ������� ���
  ///
  if FMain.FTree.Items.Count>0 then
  begin
    FMain.FTree.Items[0].DeleteChildren;
    FMain.FTree.Items[0].Delete;
    FMain.FTree.Tag:=0;
  end;
  FMain.LOwnValue.Caption:='����������� �������� �������: ';
  FMain.LImageCount.Caption:='������� � ����: ';
  FMain.LDigitSec.Caption:='���������� �������: ';
  FMain.LTrajectiry.Caption:='����������: ';
  FMain.LStopType.Caption:='��� ��������: ';
  FMain.LOpt1Digit.Caption:='������. �������� ���. ������������� �������: ';
  FMain.LE_Bp.Text:='';
  FMain.LE_Bm.Text:='';
  FMain.LE_D.Text:='';
  ///
  ///  ���������� ������
  ///
  if UFSettings.FSettings.CBShow.Checked then
  begin
    FMain.SG.ColCount:=UGlobal.AIS.m+1; FMain.SG.FixedCols:=1;
    FMain.SG.RowCount:=UGlobal.AIS.n+1; FMain.SG.FixedRows:=1;
    for i:=1 to AIS.n do
      FMain.SG.Cells[0,i]:=inttostr(i);
    for j:=1 to AIS.m do
      FMain.SG.Cells[j,0]:=inttostr(j);

    for i:=1 to AIS.n do
    begin
      for j:=1 to AIS.m do
      begin
        if UGlobal.AImages[i,j] then
          FMain.SG.Cells[j,i]:='1'
        else
          FMain.SG.Cells[j,i]:='0';
      end;
      Info('����������� ������� �������',i,AIS.n);
    end;
    RemoveInfo;
  end;
  FMain.Label1.Caption:='����������� ������� ������ - '+floattostrf(Statistic.min1,ffFixed,3,5);
  FMain.Label2.Caption:='������������ ������� ������ - '+floattostrf(Statistic.max1,ffFixed,3,5);
  FMain.Label3.Caption:='������� ������� ������ - '+floattostrf(Statistic.avg1,ffFixed,3,5);
  if Events.TreeCompleted then
  begin
    FMain.FTree.Tag:=1;
    FMain.FTree.Items.Add(NIL,inttostr(Tree[1].ActiveCount)+' (1)');
    FMain.FTree.FullExpand;
  end;
end;

///
///  ��������� � StringGrid
///  ���� ������� �������� � �������,
///
///
procedure TFMain.SGDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
  State: TGridDrawState);
begin
  if (ARow>0) then
  begin
    if ACol>0 then
      if AImages[ARow,0] then
      begin
        if CMPImage(AImages[ARow],StrToSec(LE_D.Text)) then
          SG.Canvas.Brush.Color:=clGreen
        else
          SG.Canvas.Brush.Color:=clRed;
      end
  end;
  SG.Canvas.Rectangle(Rect);
  SG.Canvas.TextOut(Rect.Left+3,Rect.Top+3,SG.Cells[ACol,ARow]);
end;

procedure TFMain.SGSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  UFImage.Img:=AImages[ARow];
  UFImage.FImage.Show;
end;

procedure TFMain.BGenerateImagesClick(Sender: TObject);
begin
  UImages.GetArray;
  UGlobal.UpDateMode(true,false);
end;

procedure TFMain.BShowStatisticClick(Sender: TObject);
begin
  UFStatistic.FStatistic.Show;
end;

procedure TFMain.BBuiltTreeClick(Sender: TObject);
begin
  UTree.BuildTree;
  UGlobal.UpDateMode(Events.ImagesCompleted,true);
end;

procedure TFMain.BHWClick(Sender: TObject);
begin
  UHardware.HW;
  BHW.Enabled:=false;
  ShellExecute(Handle,'open','HW\Tree.qpf',nil,nil,SW_SHOWNORMAL);
end;

procedure TFMain.BLoadImagesClick(Sender: TObject);
begin
  UDM.DM.OD1.Filter:='������ �������|*.img';
  if UDM.DM.OD1.Execute then
  begin
    UImages.LoadImagesFromFile(UDM.DM.OD1.FileName);
    UGlobal.UpDateMode(true,false);
  end;
  UDM.DM.OD1.Filter:='';
end;

procedure TFMain.FormActivate(Sender: TObject);
begin
  if ParamCount>0 then
    UScript.ProcessScript(ParamStr(1));
end;

procedure TFMain.FormCreate(Sender: TObject);
begin
  FMain.Caption:=FMain.Caption+' V='+UGlobal.Version;
  UFMain.RemoveInfo;
end;

procedure TFMain.FormResize(Sender: TObject);
begin
  GBGetImages.Left:=(PControl.Width-GBGetImages.Width) div 2;
  GBSec.Left:=(PControl.Width-GBSec.Width) div 2;
  BBuiltTree.Left:=(PControl.Width-BShowStatistic.Width) div 2;
  BShowStatistic.Left:=(PControl.Width-BShowStatistic.Width) div 2;
  BHW.Left:=(PControl.Width-BHW.Width) div 2;
  StatusBar1.Panels[1].Width:=70;
  StatusBar1.Panels[2].Width:=70;
  StatusBar1.Panels[0].Width:=StatusBar1.Width-(StatusBar1.Panels[1].Width+StatusBar1.Panels[2].Width);
end;

procedure TFMain.FTreeClick(Sender: TObject);
var
r,rn: LongWord;
str: string;
Bp,Bm: string;
begin
  if FTree.Tag<>0 then
  begin
    str:=copy(FTree.Selected.Text,pos('(',FTree.Selected.Text)+1,pos(')',FTree.Selected.Text)-pos('(',FTree.Selected.Text)-1);
    r:=strtoint(str);
    GetBpBm(Bp,Bm,r);
    SelectImages(r);
    rn:=Tree[r].next;
    if rn<>0 then
      LOwnValue.Caption:='����������� �������� �������: '+floattostrf(Tree[rn].ActiveCount/Tree[r].ActiveCount,ffFixed,6,5)
    else
      LOwnValue.Caption:='����������� �������� �������: ---';
    LImageCount.Caption:='������� � ����: '+inttostr(Tree[r].ActiveCount);
    LDigitSec.Caption:='���������� �������: '+inttostr(Tree[r].DSec.DigitCount);
    LTrajectiry.Caption:='����������: '+Tree[r].trajectory;
    if Tree[r].StopType=0 then
      LStopType.Caption:='��� ��������: '+'��������� � ��������';
    if Tree[r].StopType=1 then
      LStopType.Caption:='��� ��������: '+'���������� ��� �������';
    if Tree[r].StopType=2 then
      LStopType.Caption:='��� ��������: '+'�� ������� �������� ����������';
    if Tree[r].StopType=3 then
      LStopType.Caption:='��� ��������: '+'����������� ����������� �������';
    LOpt1Digit.Caption:='������. �������� ���. ������������� �������: '+floattostrf(Tree[r].Opt1DigitPercent,ffFixed,6,5);
    LE_Bp.Text:=Bp;
    LE_Bm.Text:=Bm;
    LE_D.Text:=SecExToStr(Tree[r].DSec);
    if FTree.Selected.Count=0 then
    begin
      if (FTree.Selected.Count=0) and (Tree[r].DSec.DigitCount>0) then
      begin
        FTree.Items.AddChild(FMain.FTree.Selected,inttostr(Tree[rn].ActiveCount)+' ('+inttostr(rn)+')');
        FTree.Items.AddChild(FMain.FTree.Selected,inttostr(Tree[rn+1].ActiveCount)+' ('+inttostr(rn+1)+')');
      end;
    end;
    SG.Repaint;
  end;
end;

end.
