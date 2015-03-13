object FMain: TFMain
  Left = 0
  Top = 0
  Caption = #1055#1086#1089#1090#1088#1086#1077#1085#1080#1077' '#1076#1077#1088#1077#1074#1072' '#1089#1077#1082#1091#1097#1080#1093' '#1092#1091#1085#1082#1094#1080#1081
  ClientHeight = 593
  ClientWidth = 404
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF009999
    9999999999999999999999999999999999999999999999999999999999999900
    0000000000000000000000000099990000009999999999999999000000999900
    0000999999999999999900000099990000009999999999999999000000999900
    0000999999999999999900000099990000009999900000009999000000999900
    0000999990000000999900000099990000009999900000009999000000999900
    0000999990000000999900000099990000009999900099999999000000999900
    0000999990009999999900000099990000009999900099999999000000999900
    0000999990009999999900000099990000009999900099999999000000999900
    0000999990000000000000000099990000009999900000000000000000999900
    0000999990000000000000000099990000009999900000000000000000999900
    0000999990000000000000000099990000009999900000009999000000999900
    0000999990000000999900000099990000009999900000009999000000999900
    0000999990000000999900000099990000009999999999999999000000999900
    0000999999999999999900000099990000009999999999999999000000999900
    0000999999999999999900000099990000000000000000000000000000999999
    9999999999999999999999999999999999999999999999999999999999990000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  Menu = DM.MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 161
    Top = 361
    Height = 195
    ExplicitLeft = 24
    ExplicitTop = 184
    ExplicitHeight = 100
  end
  object PStatus: TPanel
    Left = 0
    Top = 556
    Width = 404
    Height = 37
    Align = alBottom
    TabOrder = 0
    object StatusBar1: TStatusBar
      Left = 1
      Top = 18
      Width = 402
      Height = 18
      Align = alClient
      DoubleBuffered = False
      Panels = <
        item
          Width = 500
        end
        item
          Width = 50
        end
        item
          Width = 50
        end>
      ParentDoubleBuffered = False
    end
    object ProgressBar1: TProgressBar
      Left = 1
      Top = 1
      Width = 402
      Height = 17
      Align = alTop
      TabOrder = 1
    end
  end
  object PImages: TPanel
    Left = 164
    Top = 361
    Width = 240
    Height = 195
    Align = alClient
    TabOrder = 1
    object PArray: TPanel
      Left = 1
      Top = 1
      Width = 238
      Height = 139
      Align = alClient
      TabOrder = 0
      object SG: TStringGrid
        Left = 1
        Top = 1
        Width = 236
        Height = 137
        Align = alClient
        ColCount = 1
        DefaultColWidth = 20
        DefaultRowHeight = 20
        FixedCols = 0
        RowCount = 1
        FixedRows = 0
        TabOrder = 0
        OnDrawCell = SGDrawCell
        OnSelectCell = SGSelectCell
      end
    end
    object PArrayInfo: TPanel
      Left = 1
      Top = 140
      Width = 238
      Height = 54
      Align = alBottom
      TabOrder = 1
      object Label2: TLabel
        Left = 5
        Top = 20
        Width = 170
        Height = 13
        Caption = #1052#1072#1082#1089#1080#1084#1072#1083#1100#1085#1099#1081' '#1087#1088#1086#1094#1077#1085#1090' '#1077#1076#1080#1085#1080#1094' - '
      end
      object Label1: TLabel
        Left = 5
        Top = 4
        Width = 165
        Height = 13
        Caption = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1099#1081' '#1087#1088#1086#1094#1077#1085#1090' '#1077#1076#1080#1085#1080#1094' - '
      end
      object Label3: TLabel
        Left = 5
        Top = 36
        Width = 139
        Height = 13
        Caption = #1057#1088#1077#1076#1085#1080#1081' '#1087#1088#1086#1094#1077#1085#1090' '#1077#1076#1080#1085#1080#1094' - '
      end
    end
  end
  object PControl: TPanel
    Left = 0
    Top = 0
    Width = 404
    Height = 361
    Align = alTop
    TabOrder = 2
    object BBuiltTree: TButton
      Left = 13
      Top = 270
      Width = 375
      Height = 25
      Caption = #1055#1086#1089#1090#1088#1086#1080#1090#1100' '#1076#1077#1088#1077#1074#1086
      Enabled = False
      TabOrder = 0
      OnClick = BBuiltTreeClick
    end
    object BShowStatistic: TButton
      Left = 13
      Top = 332
      Width = 375
      Height = 25
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1091
      TabOrder = 1
      OnClick = BShowStatisticClick
    end
    object GBGetImages: TGroupBox
      Left = 13
      Top = 10
      Width = 375
      Height = 79
      Caption = #1055#1086#1083#1091#1095#1077#1085#1080#1077' '#1086#1073#1088#1072#1079#1086#1074
      TabOrder = 2
      object BGenerateImages: TButton
        Left = 3
        Top = 16
        Width = 369
        Height = 25
        Caption = #1043#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1084#1072#1089#1089#1080#1074
        TabOrder = 0
        OnClick = BGenerateImagesClick
      end
      object BLoadImages: TButton
        Left = 3
        Top = 47
        Width = 369
        Height = 25
        Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1092#1072#1081#1083#1072
        TabOrder = 1
        OnClick = BLoadImagesClick
      end
    end
    object GBSec: TGroupBox
      Left = 13
      Top = 88
      Width = 375
      Height = 176
      Caption = #1057#1077#1082#1091#1097#1080#1077
      TabOrder = 3
      object LOwnValue: TLabel
        Left = 3
        Top = 80
        Width = 167
        Height = 13
        Caption = #1057#1086#1073#1089#1090#1074#1077#1085#1085#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1089#1077#1082#1091#1097#1077#1081':'
      end
      object LImageCount: TLabel
        Left = 3
        Top = 61
        Width = 82
        Height = 13
        Caption = #1054#1073#1088#1072#1079#1086#1074' '#1074' '#1091#1079#1083#1077':'
      end
      object LDigitSec: TLabel
        Left = 3
        Top = 99
        Width = 112
        Height = 13
        Caption = #1056#1072#1079#1088#1103#1076#1085#1086#1089#1090#1100' '#1089#1077#1082#1091#1097#1077#1081
      end
      object LStopType: TLabel
        Left = 3
        Top = 118
        Width = 72
        Height = 13
        Caption = #1058#1080#1087' '#1086#1089#1090#1072#1085#1086#1074#1072':'
      end
      object LTrajectiry: TLabel
        Left = 3
        Top = 137
        Width = 64
        Height = 13
        Caption = #1058#1088#1072#1077#1082#1090#1086#1088#1080#1103':'
      end
      object LOpt1Digit: TLabel
        Left = 3
        Top = 156
        Width = 251
        Height = 13
        Caption = #1057#1086#1073#1089#1090#1074'. '#1079#1085#1072#1095#1077#1085#1080#1077' '#1086#1087#1090'. '#1086#1076#1085#1086#1088#1072#1079#1088#1103#1076#1085#1086#1081' '#1089#1077#1082#1091#1097#1077#1081': '
      end
      object LE_Bm: TLabeledEdit
        Left = 128
        Top = 34
        Width = 119
        Height = 21
        EditLabel.Width = 65
        EditLabel.Height = 13
        EditLabel.Caption = 'Bm (d-'#1074#1077#1090#1074#1080')'
        ReadOnly = True
        TabOrder = 0
      end
      object LE_Bp: TLabeledEdit
        Left = 3
        Top = 34
        Width = 119
        Height = 21
        EditLabel.Width = 63
        EditLabel.Height = 13
        EditLabel.Caption = 'Bp (u-'#1074#1077#1090#1074#1080')'
        ReadOnly = True
        TabOrder = 1
      end
      object LE_D: TLabeledEdit
        Left = 253
        Top = 34
        Width = 119
        Height = 21
        EditLabel.Width = 97
        EditLabel.Height = 13
        EditLabel.Caption = 'D ('#1089#1077#1082#1091#1097#1072#1103' '#1074' '#1091#1079#1083#1077')'
        ReadOnly = True
        TabOrder = 2
      end
    end
    object BHW: TButton
      Left = 13
      Top = 301
      Width = 375
      Height = 25
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1072#1087#1087#1072#1088#1072#1090#1085#1091#1102' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1102
      Enabled = False
      TabOrder = 4
      OnClick = BHWClick
    end
  end
  object PTree: TPanel
    Left = 0
    Top = 361
    Width = 161
    Height = 195
    Align = alLeft
    TabOrder = 3
    object FTree: TTreeView
      Left = 1
      Top = 1
      Width = 159
      Height = 193
      Align = alClient
      Indent = 19
      TabOrder = 0
      OnClick = FTreeClick
    end
  end
end
