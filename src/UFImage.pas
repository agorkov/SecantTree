unit UFImage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, UGlobal;

type
  TFImage = class(TForm)
    Image1: TImage;
    procedure FormActivate(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer;
      var Resize: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FImage: TFImage;
  Img: TImg;

implementation

{$R *.dfm}

procedure TFImage.FormActivate(Sender: TObject);
var
i,k,Row,Col: LongWord;
l: LongWord;
fl: boolean;
begin
  Image1.Canvas.Pen.Color:=clWhite;
  Image1.Canvas.Brush.Color:=clWhite;
  k:=1;
  while k*k<AIS.m do
    k:=k+1;
  l:=round(Image1.Height/k);
  for i:=1 to k*k do // Отображаем образы
  begin
    Row:=0; Col:=0;
    while i>Row*k do
      Row:=Row+1;
    Col:=k+i-Row*k;
    if i<=AIS.m then
      fl:=not Img[i]
    else
      fl:=false;
    if fl then
    begin
      Image1.Canvas.Pen.Color:=clWhite;
      Image1.Canvas.Brush.Color:=clWhite;
    end
    else
    begin
      Image1.Canvas.Pen.Color:=clBlack;
      Image1.Canvas.Brush.Color:=clBlack;
    end;
    Image1.Canvas.Rectangle((Col-1)*l,(Row-1)*l,Col*l,Row*l);
  end;
end;

procedure TFImage.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  Resize:=false;
end;

end.
