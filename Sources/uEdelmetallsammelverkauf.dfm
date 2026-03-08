object fEdelmetallsammelverkauf: TfEdelmetallsammelverkauf
  Left = 0
  Top = 0
  Caption = 'Edelmetall Sammelverkauf'
  ClientHeight = 402
  ClientWidth = 897
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnShow = FormShow
  TextHeight = 15
  object Label3: TLabel
    Left = 144
    Top = 337
    Width = 85
    Height = 15
    Caption = 'Verkaufsdatum'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object edRechnungsNr: TLabeledEdit
    Left = 8
    Top = 358
    Width = 121
    Height = 23
    EditLabel.Width = 75
    EditLabel.Height = 15
    EditLabel.Caption = 'RechnungsNr'
    EditLabel.Font.Charset = ANSI_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -12
    EditLabel.Font.Name = 'Segoe UI'
    EditLabel.Font.Style = [fsBold]
    EditLabel.ParentFont = False
    NumbersOnly = True
    TabOrder = 0
    Text = ''
  end
  object btnSammelVerkauf: TButton
    Left = 655
    Top = 356
    Width = 75
    Height = 25
    Caption = 'Verkaufen'
    TabOrder = 3
    OnClick = btnSammelVerkaufClick
  end
  object edVerkaufswert: TLabeledEdit
    Left = 408
    Top = 358
    Width = 121
    Height = 23
    EditLabel.Width = 94
    EditLabel.Height = 15
    EditLabel.Caption = 'Verkaufswert ('#8364')'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -12
    EditLabel.Font.Name = 'Segoe UI'
    EditLabel.Font.Style = [fsBold]
    EditLabel.ParentFont = False
    TabOrder = 2
    Text = ''
    OnExit = edVerkaufswertExit
    OnKeyPress = edVerkaufswertKeyPress
  end
  object dtpVerkaufsdatum: TDateTimePicker
    Left = 144
    Top = 358
    Width = 113
    Height = 23
    Date = 46025.000000000000000000
    Time = 0.918865486113645600
    ShowCheckbox = True
    Checked = False
    TabOrder = 1
  end
  object edSummeEinkaufswert: TLabeledEdit
    Left = 272
    Top = 358
    Width = 121
    Height = 23
    EditLabel.Width = 105
    EditLabel.Height = 15
    EditLabel.Caption = 'Summe Ankaufwert'
    ReadOnly = True
    TabOrder = 4
    Text = ''
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 897
    Height = 41
    Align = alTop
    Caption = 'Edelmetall Sammelverkauf'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    ExplicitTop = -6
    ExplicitWidth = 864
  end
  object lvEdelmetallEinkaeufe: TAdvListView
    Left = 0
    Top = 82
    Width = 897
    Height = 199
    Align = alTop
    Columns = <
      item
        Caption = 'ID'
        MaxWidth = 1
        Tag = 1
        Width = 0
      end
      item
        Alignment = taCenter
        Caption = 'SKU'
        Width = 70
      end
      item
        Caption = 'Ref'
      end
      item
        Caption = 'Angekauft von'
        Width = 150
      end
      item
        Alignment = taCenter
        Caption = 'Kaufdatum'
        MaxWidth = 100
        MinWidth = 80
        Tag = 3
        Width = 80
      end
      item
        Caption = 'Artikelname'
        Width = 150
      end
      item
        Alignment = taRightJustify
        Caption = 'Einkauf ('#8364')'
        Tag = 2
        Width = 80
      end
      item
        Alignment = taRightJustify
        Caption = 'Versand ('#8364')'
        Width = 80
      end
      item
        Alignment = taRightJustify
        Caption = 'Gesamt ('#8364')'
        Width = 80
      end
      item
        Caption = 'Zahlungsart'
        Width = 0
      end
      item
        Caption = 'Einheit'
        Width = 0
      end
      item
        Alignment = taCenter
        Caption = 'Karat'
      end
      item
        Alignment = taRightJustify
        Caption = 'Gewicht (g)'
        Width = 80
      end>
    DoubleBuffered = True
    GridLines = True
    HideSelection = False
    OwnerDraw = True
    ReadOnly = True
    RowSelect = True
    ParentDoubleBuffered = False
    ParentShowHint = False
    ShowHint = False
    TabOrder = 6
    ViewStyle = vsReport
    AutoHint = True
    FilterTimeOut = 0
    PrintSettings.DateFormat = 'dd/mm/yyyy'
    PrintSettings.Font.Charset = DEFAULT_CHARSET
    PrintSettings.Font.Color = clWindowText
    PrintSettings.Font.Height = -12
    PrintSettings.Font.Name = 'Segoe UI'
    PrintSettings.Font.Style = []
    PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
    PrintSettings.HeaderFont.Color = clWindowText
    PrintSettings.HeaderFont.Height = -12
    PrintSettings.HeaderFont.Name = 'Segoe UI'
    PrintSettings.HeaderFont.Style = []
    PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
    PrintSettings.FooterFont.Color = clWindowText
    PrintSettings.FooterFont.Height = -12
    PrintSettings.FooterFont.Name = 'Segoe UI'
    PrintSettings.FooterFont.Style = []
    PrintSettings.PageNumSep = '/'
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -11
    HeaderFont.Name = 'Segoe UI'
    HeaderFont.Style = []
    ProgressSettings.ValueFormat = '%d%%'
    SubItemSelect = True
    ItemHeight = 30
    DetailView.Font.Charset = DEFAULT_CHARSET
    DetailView.Font.Color = clBlue
    DetailView.Font.Height = -12
    DetailView.Font.Name = 'Segoe UI'
    DetailView.Font.Style = []
    Version = '1.9.1.1'
    ExplicitWidth = 864
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 897
    Height = 41
    Align = alTop
    ShowCaption = False
    TabOrder = 7
    ExplicitLeft = 8
    ExplicitTop = 8
    ExplicitWidth = 864
    object Label4: TLabel
      Left = 8
      Top = 12
      Width = 303
      Height = 17
      Caption = 'Zu verkaufende, gesammelte Edelmetall Ank'#228'ufe'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 281
    Width = 897
    Height = 41
    Align = alTop
    ShowCaption = False
    TabOrder = 8
    ExplicitLeft = 80
    ExplicitTop = 287
    ExplicitWidth = 185
    object Label1: TLabel
      Left = 8
      Top = 12
      Width = 173
      Height = 17
      Caption = 'Edelmetall - Sammelverkauf'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object edBesteuernderBetrag: TLabeledEdit
    Left = 544
    Top = 357
    Width = 89
    Height = 23
    Color = 14548957
    EditLabel.Width = 89
    EditLabel.Height = 15
    EditLabel.Caption = 'Zu versteuern ('#8364')'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    ReadOnly = True
    TabOrder = 9
    Text = ''
  end
end
