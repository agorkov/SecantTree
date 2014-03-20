unit UFSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls;

type
  TFSettings = class(TForm)
    LEE: TLabeledEdit;
    LERnd: TLabeledEdit;
    BSave: TButton;
    LEn: TLabeledEdit;
    LEm: TLabeledEdit;
    CBShow: TCheckBox;
    CBShowProgress: TCheckBox;
    CBAllowRepeats: TCheckBox;
    LEk: TLabeledEdit;
    CBSymmetricArray: TCheckBox;
    LEAlpha: TLabeledEdit;
    LEBeta: TLabeledEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LEMaxSecDigit: TLabeledEdit;
    procedure FormActivate(Sender: TObject);
    procedure BSaveClick(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
    procedure CBSymmetricArrayClick(Sender: TObject);
    procedure LEkChange(Sender: TObject);
    procedure LEmChange(Sender: TObject);
    procedure CBAllowRepeatsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FSettings: TFSettings;

implementation

{$R *.dfm}

uses
  UGlobal;

procedure ShowSettings;
begin
  FSettings.CBAllowRepeats.OnClick := nil;
  FSettings.CBSymmetricArray.OnClick := nil;
  FSettings.LEk.OnChange := nil;
  FSettings.LEm.OnChange := nil;

  FSettings.LEn.Text := '---';
  FSettings.LEk.Text := '---';
  FSettings.LEm.Text := '---';
  FSettings.LEE.Text := '---';
  FSettings.LERnd.Text := '---';
  FSettings.LEAlpha.Text := '---';
  FSettings.LEBeta.Text := '---';
  /// Отображается всегда
  FSettings.LEn.Text := inttostr(UGlobal.AIS.n);
  FSettings.LEm.Text := inttostr(UGlobal.AIS.m);
  FSettings.LEE.Text := floattostr(UGlobal.E);
  FSettings.CBSymmetricArray.Checked := false;
  FSettings.CBAllowRepeats.Checked := false;
  FSettings.LEMaxSecDigit.Text := inttostr(UGlobal.MaxSecDigit);
  /// Отображается для случайных массивов
  if AIS.ImgMode in [1, 2] then
  begin
    FSettings.LEn.Enabled := true;
    FSettings.LEk.Enabled := false;
    FSettings.LERnd.Enabled := true;
    FSettings.CBAllowRepeats.Enabled := true;
    FSettings.LEAlpha.Enabled := true;
    FSettings.LEBeta.Enabled := true;
    ///
    FSettings.LERnd.Text := UGlobal.Rnd;
    FSettings.LEAlpha.Text := floattostr(UGlobal.Alpha);
    FSettings.LEBeta.Text := floattostr(UGlobal.Beta);
    FSettings.CBAllowRepeats.Checked := (AIS.ImgMode = 2);
  end;
  /// Отображается для симметрических массивов
  if AIS.ImgMode = 3 then
  begin
    FSettings.LEn.Enabled := false;
    FSettings.LEk.Enabled := true;
    FSettings.LERnd.Enabled := false;
    FSettings.CBAllowRepeats.Enabled := false;
    FSettings.LEAlpha.Enabled := false;
    FSettings.LEBeta.Enabled := false;
    ///
    FSettings.LEk.Text := inttostr(UGlobal.AIS.k);
    FSettings.CBSymmetricArray.Checked := (AIS.ImgMode = 3);
  end;

  FSettings.CBAllowRepeats.OnClick := FSettings.CBAllowRepeatsClick;
  FSettings.CBSymmetricArray.OnClick := FSettings.CBSymmetricArrayClick;
  FSettings.LEk.OnChange := FSettings.LEkChange;
  FSettings.LEm.OnChange := FSettings.LEmChange;
end;

procedure TFSettings.BSaveClick(Sender: TObject);
begin
  if AIS.ImgMode in [1, 2] then
  begin
    UGlobal.AIS.n := strtoint(LEn.Text);
    UGlobal.AIS.m := strtoint(LEm.Text);
    UGlobal.Rnd := LERnd.Text;
    UGlobal.Alpha := strtofloat(LEAlpha.Text);
    UGlobal.Beta := strtofloat(LEBeta.Text);
  end;
  if AIS.ImgMode = 3 then
  begin
    UGlobal.AIS.k := strtoint(LEk.Text);
    UGlobal.AIS.m := strtoint(LEm.Text);
    UGlobal.AIS.n := strtoint(LEn.Text);
  end;
  UGlobal.E := strtofloat(LEE.Text);
  UGlobal.MaxSecDigit := strtoint(LEMaxSecDigit.Text);
  FSettings.Close;
end;

procedure TFSettings.CBAllowRepeatsClick(Sender: TObject);
begin
  if CBAllowRepeats.Checked then
    AIS.ImgMode := 2
  else
    AIS.ImgMode := 1;
end;

procedure TFSettings.CBSymmetricArrayClick(Sender: TObject);
begin
  if CBSymmetricArray.Checked then
    AIS.ImgMode := 3
  else
    if CBAllowRepeats.Checked then
      AIS.ImgMode := 2
    else
      AIS.ImgMode := 1;
  ShowSettings;
end;

procedure TFSettings.FormActivate(Sender: TObject);
begin
  ShowSettings;
end;

procedure TFSettings.FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
begin
  Resize := false;
end;

procedure TFSettings.LEkChange(Sender: TObject);
  function Cnk(n, k: LongWord): LongWord;
    function NOD(a, b: Longint): Longint;
    begin
      while (a <> 0) and (b <> 0) do
        if (a > b) then
          a := a mod b
        else
          b := b mod a;
      if (a = 0) then
        result := b
      else
        result := a;
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
    result := u;
  end;

var
  m, k, n: LongWord;
begin
  try
    k := strtoint(LEk.Text);
    m := strtoint(LEm.Text);
    if k <= m / 2 then
      n := Cnk(m, k)
    else
    begin
      LEk.Text := inttostr(round(m / 2));
      k := strtoint(LEk.Text);
      n := Cnk(m, k)
    end;
    LEn.Text := inttostr(n);
  except
  end;
end;

procedure TFSettings.LEmChange(Sender: TObject);
begin
  if AIS.ImgMode = 3 then
    LEkChange(nil);
end;

end.
