object DM: TDM
  OldCreateOrder = False
  Height = 150
  Width = 215
  object OD1: TOpenDialog
    Filter = #1044#1077#1088#1077#1074#1086'|*.tree'
    Left = 16
    Top = 16
  end
  object MainMenu1: TMainMenu
    Left = 64
    Top = 16
    object NFile: TMenuItem
      Caption = #1060#1072#1081#1083
      object NSaveImages: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1086#1073#1088#1072#1079#1099
        Enabled = False
        OnClick = NSaveImagesClick
      end
      object NLoadImages: TMenuItem
        Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1086#1073#1088#1072#1079#1099
        OnClick = NLoadImagesClick
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object NSaveTree: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1076#1077#1088#1077#1074#1086
        Enabled = False
        OnClick = NSaveTreeClick
      end
      object NLoadTree: TMenuItem
        Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1077#1088#1077#1074#1086
        OnClick = NLoadTreeClick
      end
      object N9: TMenuItem
        Caption = '-'
      end
      object NExit: TMenuItem
        Caption = #1042#1099#1093#1086#1076
        OnClick = NExitClick
      end
    end
    object NSettings: TMenuItem
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      OnClick = NSettingsClick
    end
    object NRunScript: TMenuItem
      Caption = #1047#1072#1087#1091#1089#1090#1080#1090#1100' '#1089#1082#1088#1080#1087#1090
      OnClick = NRunScriptClick
    end
    object NRecognize: TMenuItem
      Caption = #1056#1072#1089#1087#1086#1079#1085#1072#1074#1072#1085#1080#1077
      Enabled = False
      OnClick = NRecognizeClick
    end
  end
  object SD1: TSaveDialog
    Left = 16
    Top = 64
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 136
    Top = 88
  end
end
