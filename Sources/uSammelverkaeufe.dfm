object fSammelverkaeufe: TfSammelverkaeufe
  Left = 0
  Top = 0
  Caption = 'Sammelverk'#228'ufe'
  ClientHeight = 441
  ClientWidth = 861
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poMainFormCenter
  OnShow = FormShow
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 861
    Height = 41
    Align = alTop
    Caption = 'Edelmetall Sammelverkauf'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    ExplicitLeft = -273
    ExplicitWidth = 897
  end
  object Panel2: TPanel
    Left = 0
    Top = 117
    Width = 861
    Height = 41
    Align = alTop
    ShowCaption = False
    TabOrder = 1
    ExplicitLeft = -273
    ExplicitTop = 41
    ExplicitWidth = 897
    object Label4: TLabel
      Left = 8
      Top = 12
      Width = 242
      Height = 17
      Caption = 'Im Sammelverkauf enthaltene Eink'#228'ufe'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object lvEdelmetallEinkaeufe: TAdvListView
    Left = 0
    Top = 158
    Width = 861
    Height = 283
    Align = alClient
    Columns = <
      item
        Caption = 'ID'
        MaxWidth = 1
        Tag = 1
        Width = 0
      end
      item
        Alignment = taCenter
        Caption = 'KundenNr'
        Width = 70
      end
      item
        Caption = 'Nachname'
        MinWidth = 100
        Width = 100
      end
      item
        Caption = 'Vorname'
        MinWidth = 100
        Width = 100
      end
      item
        Alignment = taCenter
        Caption = 'Ankaufsdatum'
        MaxWidth = 100
        MinWidth = 100
        Tag = 3
        Width = 100
      end
      item
        Alignment = taRightJustify
        Caption = 'Gesamtpreis'
        Width = 100
      end
      item
        AutoSize = True
        Caption = 'Artikelname'
        MinWidth = 100
        Tag = 2
      end
      item
        Alignment = taRightJustify
        Caption = 'Einheit'
        MinWidth = 80
        Width = 80
      end
      item
        Alignment = taRightJustify
        Caption = 'Karat'
        MinWidth = 80
        Width = 80
      end
      item
        Alignment = taRightJustify
        Caption = 'Gewicht'
        MinWidth = 80
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
    TabOrder = 2
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
    ExplicitWidth = 624
  end
  object Panel3: TPanel
    Left = 0
    Top = 41
    Width = 861
    Height = 76
    Align = alTop
    ShowCaption = False
    TabOrder = 3
    ExplicitWidth = 624
    object Label1: TLabel
      Left = 24
      Top = 16
      Width = 72
      Height = 15
      Caption = 'RechnungsNr'
    end
    object Label2: TLabel
      Left = 144
      Top = 16
      Width = 79
      Height = 15
      Caption = 'Verkaufsdatum'
    end
    object Label3: TLabel
      Left = 277
      Top = 16
      Width = 67
      Height = 15
      Caption = 'Verkaufswert'
    end
    object Label5: TLabel
      Left = 400
      Top = 16
      Width = 67
      Height = 15
      Caption = 'Steuerbetrag'
    end
    object lbSteuerbetrag: TLabel
      Left = 400
      Top = 37
      Width = 28
      Height = 21
      Caption = '.......'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbVerkaufswert: TLabel
      Left = 277
      Top = 37
      Width = 28
      Height = 21
      Caption = '.......'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbVerkaufsdatum: TLabel
      Left = 144
      Top = 37
      Width = 28
      Height = 21
      Caption = '.......'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbRechnungsNr: TLabel
      Left = 24
      Top = 37
      Width = 28
      Height = 21
      Caption = '.......'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
end
