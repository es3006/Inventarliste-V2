object fLizenzDialog: TfLizenzDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Lizenz aktivieren'
  ClientHeight = 281
  ClientWidth = 324
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object lblStatus: TLabel
    Left = 24
    Top = 192
    Width = 30
    Height = 15
    Caption = '          '
  end
  object Label1: TLabel
    Left = 24
    Top = 24
    Width = 119
    Height = 21
    Caption = 'Lizenz aktivieren'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI Semibold'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object edEmail: TLabeledEdit
    Left = 24
    Top = 88
    Width = 273
    Height = 23
    EditLabel.Width = 29
    EditLabel.Height = 15
    EditLabel.Caption = 'Email'
    TabOrder = 0
    Text = ''
  end
  object edLizenzcode: TLabeledEdit
    Left = 24
    Top = 152
    Width = 273
    Height = 23
    EditLabel.Width = 58
    EditLabel.Height = 15
    EditLabel.Caption = 'Lizenzcode'
    TabOrder = 1
    Text = ''
  end
  object btnAbbrechen: TButton
    Left = 24
    Top = 232
    Width = 75
    Height = 25
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 2
    OnClick = btnAbbrechenClick
  end
  object btnOK: TButton
    Left = 142
    Top = 232
    Width = 155
    Height = 25
    Caption = 'Lizenz aktivieren'
    TabOrder = 3
    OnClick = btnOKClick
  end
end
