program PMain;

uses
  Forms,
  UFMain in 'UFMain.pas' {FMain},
  UImages in 'UImages.pas' {UImages},
  UFStatistic in 'UFStatistic.pas' {FStatistic},
  UDM in 'UDM.pas' {DM: TDataModule},
  UFSettings in 'UFSettings.pas' {FSettings},
  UGlobal in 'UGlobal.pas',
  UTree in 'UTree.pas',
  UHardware in 'UHardware.pas',
  UFImage in 'UFImage.pas' {FImage},
  UFRecognition in 'UFRecognition.pas' {FRecognition},
  UScript in 'UScript.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TFStatistic, FStatistic);
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TFSettings, FSettings);
  Application.CreateForm(TFImage, FImage);
  Application.CreateForm(TFRecognition, FRecognition);
  Application.Run;
end.
