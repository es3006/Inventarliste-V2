object fKunden: TfKunden
  Left = 0
  Top = 0
  Caption = 'Kunden'
  ClientHeight = 441
  ClientWidth = 818
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poMainFormCenter
  ShowInTaskBar = True
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 818
    Height = 57
    Align = alTop
    Color = 16773593
    ParentBackground = False
    ShowCaption = False
    TabOrder = 0
    object Label7: TLabel
      Left = 8
      Top = 14
      Width = 126
      Height = 28
      Caption = 'Kundendaten'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object lvKunden: TAdvListView
    Left = 0
    Top = 57
    Width = 818
    Height = 215
    Align = alClient
    Columns = <
      item
        Caption = 'ID'
        MaxWidth = 1
        Width = 0
      end
      item
        Caption = 'KundenNr'
        Width = 80
      end
      item
        Caption = 'Nachname'
        Width = 100
      end
      item
        Caption = 'Vorname'
        Width = 100
      end
      item
        Caption = 'Strasse'
        MaxWidth = 1
        Width = 0
      end
      item
        Caption = 'PLZ'
        MaxWidth = 1
        Width = 0
      end
      item
        Caption = 'Wohnort'
        MaxWidth = 1
        Width = 0
      end
      item
        Caption = 'Telefon'
        Width = 80
      end
      item
        Caption = 'Handy'
        Width = 80
      end
      item
        Caption = 'Email'
        Width = 100
      end
      item
        Caption = 'AusweisNr'
        Width = 80
      end
      item
        Caption = 'Geburtsdatum'
        Width = 193
      end>
    GridLines = True
    HideSelection = False
    OwnerDraw = True
    ReadOnly = True
    RowSelect = True
    PopupMenu = PopupMenu1
    TabOrder = 1
    ViewStyle = vsReport
    OnClick = lvKundenClick
    OnSelectItem = lvKundenSelectItem
    ColumnSize.Stretch = True
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
    StretchColumn = True
    ItemHeight = 30
    DetailView.Font.Charset = DEFAULT_CHARSET
    DetailView.Font.Color = clBlue
    DetailView.Font.Height = -12
    DetailView.Font.Name = 'Segoe UI'
    DetailView.Font.Style = []
    Version = '1.9.1.1'
    ExplicitHeight = 214
  end
  object pnlKundendaten: TPanel
    Left = 0
    Top = 272
    Width = 818
    Height = 169
    Align = alBottom
    ShowCaption = False
    TabOrder = 2
    object Label1: TLabel
      Left = 574
      Top = 112
      Width = 76
      Height = 15
      Caption = 'Geburtsdatum'
    end
    object edKundenNr: TLabeledEdit
      Left = 13
      Top = 32
      Width = 76
      Height = 23
      EditLabel.Width = 65
      EditLabel.Height = 15
      EditLabel.Caption = 'KundenNr *'
      EditLabel.Font.Charset = DEFAULT_CHARSET
      EditLabel.Font.Color = clWindowText
      EditLabel.Font.Height = -12
      EditLabel.Font.Name = 'Segoe UI'
      EditLabel.Font.Style = [fsBold]
      EditLabel.ParentFont = False
      ReadOnly = True
      TabOrder = 0
      Text = ''
    end
    object edNachname: TLabeledEdit
      Left = 95
      Top = 32
      Width = 170
      Height = 23
      EditLabel.Width = 67
      EditLabel.Height = 15
      EditLabel.Caption = 'Nachname *'
      EditLabel.Font.Charset = DEFAULT_CHARSET
      EditLabel.Font.Color = clWindowText
      EditLabel.Font.Height = -12
      EditLabel.Font.Name = 'Segoe UI'
      EditLabel.Font.Style = [fsBold]
      EditLabel.ParentFont = False
      TabOrder = 1
      Text = ''
    end
    object edVorname: TLabeledEdit
      Left = 271
      Top = 32
      Width = 170
      Height = 23
      EditLabel.Width = 58
      EditLabel.Height = 15
      EditLabel.Caption = 'Vorname *'
      EditLabel.Font.Charset = DEFAULT_CHARSET
      EditLabel.Font.Color = clWindowText
      EditLabel.Font.Height = -12
      EditLabel.Font.Name = 'Segoe UI'
      EditLabel.Font.Style = [fsBold]
      EditLabel.ParentFont = False
      TabOrder = 2
      Text = ''
    end
    object edStrasseHausNr: TLabeledEdit
      Left = 13
      Top = 80
      Width = 172
      Height = 23
      EditLabel.Width = 82
      EditLabel.Height = 15
      EditLabel.Caption = 'Strasse, HausNr'
      TabOrder = 3
      Text = ''
    end
    object edPLZ: TLabeledEdit
      Left = 191
      Top = 80
      Width = 50
      Height = 23
      EditLabel.Width = 20
      EditLabel.Height = 15
      EditLabel.Caption = 'PLZ'
      TabOrder = 4
      Text = ''
    end
    object edWohnort: TLabeledEdit
      Left = 247
      Top = 80
      Width = 194
      Height = 23
      EditLabel.Width = 47
      EditLabel.Height = 15
      EditLabel.Caption = 'Wohnort'
      TabOrder = 5
      Text = ''
    end
    object edTelefon: TLabeledEdit
      Left = 13
      Top = 128
      Width = 121
      Height = 23
      EditLabel.Width = 38
      EditLabel.Height = 15
      EditLabel.Caption = 'Telefon'
      TabOrder = 6
      Text = ''
    end
    object edHandy: TLabeledEdit
      Left = 140
      Top = 128
      Width = 121
      Height = 23
      EditLabel.Width = 35
      EditLabel.Height = 15
      EditLabel.Caption = 'Handy'
      TabOrder = 7
      Text = ''
    end
    object edEmail: TLabeledEdit
      Left = 267
      Top = 128
      Width = 174
      Height = 23
      EditLabel.Width = 29
      EditLabel.Height = 15
      EditLabel.Caption = 'eMail'
      TabOrder = 8
      Text = ''
    end
    object edAusweisNr: TLabeledEdit
      Left = 447
      Top = 128
      Width = 121
      Height = 23
      EditLabel.Width = 56
      EditLabel.Height = 15
      EditLabel.Caption = 'AusweisNr'
      TabOrder = 9
      Text = ''
    end
    object dtpGeburtsdatum: TDateTimePicker
      Left = 574
      Top = 128
      Width = 99
      Height = 23
      Date = 46034.000000000000000000
      Time = 0.921267615740362100
      ShowCheckbox = True
      Checked = False
      TabOrder = 10
    end
    object btnSave: TButton
      Left = 696
      Top = 128
      Width = 107
      Height = 25
      Caption = 'Speichern'
      TabOrder = 11
      OnClick = btnSaveClick
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 520
    Top = 184
    object Eintraglschen1: TMenuItem
      Action = acDeleteEntry
    end
  end
  object ActionList1: TActionList
    Left = 616
    Top = 160
    object acDeleteEntry: TAction
      Caption = 'Eintrag l'#246'schen'
      ShortCut = 16430
      OnExecute = acDeleteEntryExecute
      OnUpdate = acDeleteEntryUpdate
    end
  end
end
