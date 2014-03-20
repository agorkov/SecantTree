object FSettings: TFSettings
  Left = 0
  Top = 0
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 531
  ClientWidth = 187
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
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnCanResize = FormCanResize
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 8
    Width = 146
    Height = 14
    Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1075#1077#1085#1077#1088#1072#1094#1080#1080':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 24
    Top = 311
    Width = 139
    Height = 14
    Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1073#1091#1095#1077#1085#1080#1103':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 24
    Top = 418
    Width = 90
    Height = 14
    Caption = #1042#1080#1079#1091#1072#1083#1080#1079#1072#1094#1080#1103':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LEE: TLabeledEdit
    Left = 24
    Top = 350
    Width = 137
    Height = 21
    EditLabel.Width = 121
    EditLabel.Height = 13
    EditLabel.Caption = #1044#1086#1089#1090#1072#1090#1086#1095#1085#1072#1103' '#1090#1086#1095#1085#1086#1089#1090#1100':'
    TabOrder = 8
  end
  object LERnd: TLabeledEdit
    Left = 24
    Top = 123
    Width = 137
    Height = 21
    EditLabel.Width = 116
    EditLabel.Height = 13
    EditLabel.Caption = #1060#1086#1088#1084#1091#1083#1072' '#1074#1077#1088#1086#1103#1090#1085#1086#1089#1090#1080':'
    TabOrder = 2
  end
  object BSave: TButton
    Left = 24
    Top = 494
    Width = 137
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 11
    OnClick = BSaveClick
  end
  object LEn: TLabeledEdit
    Left = 24
    Top = 38
    Width = 137
    Height = 21
    EditLabel.Width = 6
    EditLabel.Height = 13
    EditLabel.Caption = 'n'
    TabOrder = 0
  end
  object LEm: TLabeledEdit
    Left = 24
    Top = 81
    Width = 137
    Height = 21
    EditLabel.Width = 8
    EditLabel.Height = 13
    EditLabel.Caption = 'm'
    TabOrder = 1
    OnChange = LEmChange
  end
  object CBShow: TCheckBox
    Left = 24
    Top = 448
    Width = 137
    Height = 17
    Hint = 
      #1055#1088#1080' '#1073#1086#1083#1100#1096#1080#1093' '#1088#1072#1079#1084#1077#1088#1085#1086#1089#1090#1103#1093' '#1084#1072#1089#1089#1080#1074#1072' '#1086#1090#1086#1073#1088#1072#1078#1077#1085#1080#1077' '#1086#1073#1088#1072#1079#1086#1074' '#1084#1086#1078#1077#1090' '#1087#1088#1080#1074#1077 +
      #1089#1090#1080' '#1082' '#1085#1077#1088#1072#1073#1086#1090#1086#1089#1087#1086#1089#1086#1073#1085#1086#1089#1090#1080' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
    Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1086#1073#1088#1072#1079#1099
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
  end
  object CBShowProgress: TCheckBox
    Left = 24
    Top = 471
    Width = 137
    Height = 17
    Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1087#1088#1086#1075#1088#1077#1089#1089
    Checked = True
    State = cbChecked
    TabOrder = 10
  end
  object CBAllowRepeats: TCheckBox
    Left = 24
    Top = 206
    Width = 137
    Height = 17
    Caption = #1056#1072#1079#1088#1077#1096#1072#1090#1100' '#1087#1086#1074#1090#1086#1088#1099
    TabOrder = 5
    OnClick = CBAllowRepeatsClick
  end
  object LEk: TLabeledEdit
    Left = 24
    Top = 284
    Width = 137
    Height = 21
    EditLabel.Width = 5
    EditLabel.Height = 13
    EditLabel.Caption = 'k'
    TabOrder = 7
    OnChange = LEkChange
  end
  object CBSymmetricArray: TCheckBox
    Left = 24
    Top = 229
    Width = 137
    Height = 37
    Caption = #1043#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1089#1080#1084#1084#1077#1090#1088#1080#1095#1077#1089#1082#1080#1077' '#1084#1072#1089#1089#1080#1074#1099
    TabOrder = 6
    WordWrap = True
    OnClick = CBSymmetricArrayClick
  end
  object LEAlpha: TLabeledEdit
    Left = 24
    Top = 166
    Width = 49
    Height = 21
    EditLabel.Width = 37
    EditLabel.Height = 13
    EditLabel.Caption = #1040#1083#1100#1092#1072':'
    TabOrder = 3
  end
  object LEBeta: TLabeledEdit
    Left = 112
    Top = 166
    Width = 49
    Height = 21
    EditLabel.Width = 28
    EditLabel.Height = 13
    EditLabel.Caption = #1041#1077#1090#1072':'
    TabOrder = 4
  end
  object LEMaxSecDigit: TLabeledEdit
    Left = 24
    Top = 391
    Width = 137
    Height = 21
    EditLabel.Width = 145
    EditLabel.Height = 13
    EditLabel.Caption = #1052#1072#1082#1089#1080#1084#1072#1083#1100#1085#1072#1103' '#1088#1072#1079#1088#1103#1076#1085#1086#1089#1090#1100':'
    TabOrder = 12
  end
end
