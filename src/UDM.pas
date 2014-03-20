unit UDM;

interface

uses
  SysUtils, Classes, Dialogs, Menus, ExtDlgs;

type
  TDM = class(TDataModule)
    OD1: TOpenDialog;
    MainMenu1: TMainMenu;
    NFile: TMenuItem;
    NExit: TMenuItem;
    NSettings: TMenuItem;
    NSaveImages: TMenuItem;
    NLoadImages: TMenuItem;
    N6: TMenuItem;
    NSaveTree: TMenuItem;
    NLoadTree: TMenuItem;
    N9: TMenuItem;
    SD1: TSaveDialog;
    NRunScript: TMenuItem;
    NRecognize: TMenuItem;
    OpenPictureDialog1: TOpenPictureDialog;
    procedure NExitClick(Sender: TObject);
    procedure NSettingsClick(Sender: TObject);
    procedure NSaveImagesClick(Sender: TObject);
    procedure NLoadImagesClick(Sender: TObject);
    procedure NSaveTreeClick(Sender: TObject);
    procedure NLoadTreeClick(Sender: TObject);
    procedure NRecognizeClick(Sender: TObject);
    procedure NRunScriptClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{$R *.dfm}
uses
  Forms, UFSettings, UFMain, UImages, UTree, UGlobal, UFRecognition, UScript;

procedure TDM.NRecognizeClick(Sender: TObject);
begin
  UFRecognition.FRecognition.ShowModal;
end;

procedure TDM.NRunScriptClick(Sender: TObject);
begin
  UDM.DM.OD1.Filter:='Скрипт|*.txt';
  if OD1.Execute then
    UScript.ProcessScript(OD1.FileName);
  UDM.DM.OD1.Filter:='';
end;

procedure TDM.NExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TDM.NSettingsClick(Sender: TObject);
begin
  UFSettings.FSettings.Show;
end;

procedure TDM.NSaveImagesClick(Sender: TObject);
begin
  UDM.DM.SD1.Filter:='Массив образов|*.img';
  if SD1.Execute then
  begin
    if pos('.img',SD1.FileName)=0 then
      SD1.FileName:=SD1.FileName+'.img';
    UImages.SaveImagesToFile(SD1.FileName);
  end;
  UDM.DM.OD1.Filter:='';
end;

procedure TDM.NLoadImagesClick(Sender: TObject);
begin
  UDM.DM.OD1.Filter:='Массив образов|*.img';
  if OD1.Execute then
  begin
    UImages.LoadImagesFromFile(OD1.FileName);
    UGlobal.UpDateMode(true,false);
  end;
  UDM.DM.OD1.Filter:='';
end;

procedure TDM.NSaveTreeClick(Sender: TObject);
begin
  UDM.DM.SD1.Filter:='Дерево|*.tree';
  if SD1.Execute then
  begin
    if pos('.tree',SD1.FileName)=0 then
      SD1.FileName:=SD1.FileName+'.tree';
    UTree.SaveTreeToFile(SD1.FileName);
  end;
  UDM.DM.SD1.Filter:='';
end;

procedure TDM.NLoadTreeClick(Sender: TObject);
begin
  UDM.DM.OD1.Filter:='Дерево|*.tree';
  if OD1.Execute then
  begin
    UTree.LoadTreeFromFile(OD1.FileName);
    UGlobal.UpDateMode(true,true);
  end;
  UDM.DM.OD1.Filter:='';
end;

end.
