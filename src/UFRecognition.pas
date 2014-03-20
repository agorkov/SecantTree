unit UFRecognition;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls;

type
  TFRecognition = class(TForm)
    SGFind: TStringGrid;
    BGenerateRandom: TButton;
    BRecognize: TButton;
    Label1: TLabel;
    BGetRandom: TButton;
    LTrajectory: TLabel;
    CBShowImage: TCheckBox;
    LCmpCount: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure BGenerateRandomClick(Sender: TObject);
    procedure BRecognizeClick(Sender: TObject);
    procedure BGetRandomClick(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer;
      var Resize: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FRecognition: TFRecognition;

implementation

{$R *.dfm}
uses
  UGlobal, UTree, UFImage;

procedure ShowImage(Img: TImg);
var
j: LongWord;
begin
  for j:=1 to AIS.m do
    FRecognition.SGFind.Cells[j-1,1]:=inttostr(byte(Img[j]));
end;

procedure TFRecognition.BGenerateRandomClick(Sender: TObject);
var
j: LongWord;
Img: TImg;
begin
  SetLength(Img,AIS.m+1);
  for j:=1 to AIS.m do
    Img[j]:=boolean(round(random));
  ShowImage(Img);
end;

procedure TFRecognition.BGetRandomClick(Sender: TObject);
var
Img: TImg;
ImgNum: LongWord;
begin
  ImgNum:=random(AIS.n)+1;
  SetLength(Img,AIS.m+1);
  Img:=copy(AImages[ImgNum],0,AIS.m+1);
  ShowImage(Img);
end;

procedure TFRecognition.BRecognizeClick(Sender: TObject);
var
Img,R: TImg;
j,Q: LongWord;
fl: boolean;
begin
  ///
  ///  Подготовка входных данных
  ///
  SetLength(Img,AIS.m+1);
  SetLength(R,AIS.m+1);
  for j:=1 to AIS.m do
    Img[j]:=boolean(strtoint(FRecognition.SGFind.Cells[j-1,1]));
  ///
  ///  Поиск образа
  ///
  R:=copy(Tree[UTree.Recognition(Img,Q)].ActiveImages[1],0,AIS.m+1);
  LTrajectory.Caption:='Траектория: '+Tree[UTree.Recognition(Img,Q)].trajectory;
  LCmpCount.Caption:='Было выполнено '+inttostr(Q)+' сравнений';
  ///
  ///  Идентификация
  ///
  fl:=true; j:=1;
  while (fl) and (j<=AIS.m)  do
  begin
    fl:=Img[j]=R[j];
    j:=j+1;
  end;
  if fl then
  begin
    if CBShowImage.Checked then
    begin
      UFImage.Img:=R;
      UFImage.FImage.Show;
    end
  end
  else
    ShowMessage('Заданного образа в массиве нет');
  Img:=nil;
  R:=nil;
end;

procedure TFRecognition.FormActivate(Sender: TObject);
var
j: LongWord;
begin
  SGFind.ColCount:=AIS.m;
  for j:=1 to AIS.m do
    SGFind.Cells[j-1,0]:=inttostr(j);
  //BGenerateRandomClick(nil);
end;

procedure TFRecognition.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  Resize:=false;
end;

end.
