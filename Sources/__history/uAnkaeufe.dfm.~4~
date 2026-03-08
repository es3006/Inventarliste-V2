object fAnkaeufe: TfAnkaeufe
  Left = 0
  Top = 0
  Caption = 'Ank'#228'ufe'
  ClientHeight = 441
  ClientWidth = 814
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  Position = poMainFormCenter
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 814
    Height = 57
    Align = alTop
    Color = 16773593
    ParentBackground = False
    ShowCaption = False
    TabOrder = 0
    object Label7: TLabel
      Left = 8
      Top = 14
      Width = 148
      Height = 28
      Caption = 'Kundenank'#228'ufe'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object lvAnkaeufe: TAdvListView
    Left = 0
    Top = 57
    Width = 814
    Height = 215
    Align = alClient
    Columns = <
      item
        Caption = 'ID'
        Width = 0
      end
      item
        Caption = 'SKU'
      end
      item
        Caption = 'KundenNr'
        Width = 100
      end
      item
        Caption = 'Nachname'
        MaxWidth = 1
        Width = 0
      end
      item
        Caption = 'Vorname'
        MaxWidth = 1
        Width = 0
      end
      item
        Caption = 'Ankauf'
        Width = 100
      end
      item
        AutoSize = True
        Caption = 'Bezeichnung'
      end
      item
        Caption = 'Kaufpreis'
        Width = 100
      end
      item
        Caption = 'Versand'
        Width = 100
      end
      item
        Caption = 'Ref'
        Width = 200
      end
      item
        Caption = 'Box'
        MaxWidth = 1
        Width = 0
      end
      item
        Caption = 'Papiere'
        MaxWidth = 1
        Width = 0
      end
      item
        Caption = 'SavedInInventar'
        MaxWidth = 1
        Width = 0
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
        Caption = 'Ort'
        MaxWidth = 1
        Width = 0
      end>
    GridLines = True
    HideSelection = False
    OwnerDraw = True
    ReadOnly = True
    RowSelect = True
    PopupMenu = PopupMenu1
    TabOrder = 1
    ViewStyle = vsReport
    OnClick = lvAnkaeufeClick
    OnSelectItem = lvAnkaeufeSelectItem
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
    ItemHeight = 30
    DetailView.Font.Charset = DEFAULT_CHARSET
    DetailView.Font.Color = clBlue
    DetailView.Font.Height = -12
    DetailView.Font.Name = 'Segoe UI'
    DetailView.Font.Style = []
    Version = '1.9.1.1'
  end
  object pnlAnkaeufe: TPanel
    Left = 0
    Top = 272
    Width = 814
    Height = 169
    Align = alBottom
    ShowCaption = False
    TabOrder = 2
    object Label1: TLabel
      Left = 8
      Top = 14
      Width = 78
      Height = 15
      Caption = 'Ankaufsdatum'
    end
    object Label4: TLabel
      Left = 8
      Top = 64
      Width = 43
      Height = 15
      Caption = 'Zustand'
    end
    object Label5: TLabel
      Left = 90
      Top = 115
      Width = 63
      Height = 15
      Caption = 'Zahlungsart'
    end
    object edBezeichnung: TLabeledEdit
      Left = 323
      Top = 32
      Width = 343
      Height = 23
      EditLabel.Width = 68
      EditLabel.Height = 15
      EditLabel.Caption = 'Bezeichnung'
      MaxLength = 50
      TabOrder = 0
      Text = ''
    end
    object edKaufpreis: TLabeledEdit
      Left = 241
      Top = 132
      Width = 100
      Height = 23
      EditLabel.Width = 49
      EditLabel.Height = 15
      EditLabel.Caption = 'Kaufpreis'
      TabOrder = 1
      Text = ''
      OnChange = edKaufpreisChange
    end
    object edRef: TLabeledEdit
      Left = 218
      Top = 32
      Width = 99
      Height = 23
      EditLabel.Width = 45
      EditLabel.Height = 15
      EditLabel.Caption = 'Referenz'
      TabOrder = 2
      Text = ''
    end
    object dtpAnkaufsdatum: TDateTimePicker
      Left = 8
      Top = 32
      Width = 99
      Height = 23
      Date = 46034.000000000000000000
      Time = 0.921267615740362100
      ShowCheckbox = True
      Checked = False
      TabOrder = 3
    end
    object btnSave: TButton
      Left = 679
      Top = 130
      Width = 107
      Height = 25
      Caption = 'Speichern'
      TabOrder = 4
      OnClick = btnSaveClick
    end
    object edVersand: TLabeledEdit
      Left = 347
      Top = 132
      Width = 100
      Height = 23
      EditLabel.Width = 76
      EditLabel.Height = 15
      EditLabel.Caption = 'Versandkosten'
      TabOrder = 5
      Text = ''
      OnChange = edKaufpreisChange
    end
    object edGesamtpreis: TLabeledEdit
      Left = 453
      Top = 132
      Width = 100
      Height = 23
      EditLabel.Width = 65
      EditLabel.Height = 15
      EditLabel.Caption = 'Gesamtpreis'
      TabOrder = 6
      Text = ''
    end
    object cbBox: TCheckBox
      Left = 545
      Top = 85
      Width = 57
      Height = 17
      Caption = 'Box'
      TabOrder = 7
    end
    object cbPapiere: TCheckBox
      Left = 600
      Top = 85
      Width = 73
      Height = 17
      Caption = 'Papiere'
      TabOrder = 8
    end
    object edSKU: TLabeledEdit
      Left = 113
      Top = 32
      Width = 99
      Height = 23
      EditLabel.Width = 21
      EditLabel.Height = 15
      EditLabel.Caption = 'SKU'
      TabOrder = 9
      Text = ''
    end
    object edJahr: TLabeledEdit
      Left = 159
      Top = 82
      Width = 76
      Height = 23
      EditLabel.Width = 21
      EditLabel.Height = 15
      EditLabel.Caption = 'Jahr'
      EditLabel.Font.Charset = DEFAULT_CHARSET
      EditLabel.Font.Color = clWindowText
      EditLabel.Font.Height = -12
      EditLabel.Font.Name = 'Segoe UI'
      EditLabel.Font.Style = []
      EditLabel.ParentFont = False
      MaxLength = 4
      NumbersOnly = True
      TabOrder = 10
      Text = ''
    end
    object cbZustand: TComboBox
      Left = 8
      Top = 82
      Width = 145
      Height = 23
      Style = csDropDownList
      TabOrder = 11
    end
    object cbZahlungsarten: TComboBox
      Left = 90
      Top = 132
      Width = 145
      Height = 23
      Style = csDropDownList
      TabOrder = 12
    end
    object edGewicht: TLabeledEdit
      Left = 8
      Top = 132
      Width = 76
      Height = 23
      EditLabel.Width = 43
      EditLabel.Height = 15
      EditLabel.Caption = 'Gewicht'
      EditLabel.Font.Charset = DEFAULT_CHARSET
      EditLabel.Font.Color = clWindowText
      EditLabel.Font.Height = -12
      EditLabel.Font.Name = 'Segoe UI'
      EditLabel.Font.Style = []
      EditLabel.ParentFont = False
      TabOrder = 13
      Text = ''
    end
    object edMarke: TLabeledEdit
      Left = 241
      Top = 82
      Width = 130
      Height = 23
      EditLabel.Width = 33
      EditLabel.Height = 15
      EditLabel.Caption = 'Marke'
      TabOrder = 14
      Text = ''
    end
    object edModel: TLabeledEdit
      Left = 375
      Top = 82
      Width = 130
      Height = 23
      EditLabel.Width = 34
      EditLabel.Height = 15
      EditLabel.Caption = 'Model'
      TabOrder = 15
      Text = ''
    end
    object cbSavedInInventar: TCheckBox
      Left = 559
      Top = 136
      Width = 114
      Height = 17
      Caption = 'In Inventarliste'
      TabOrder = 16
    end
  end
  object ActionList1: TActionList
    Left = 600
    Top = 88
    object acDeleteEntry: TAction
      Caption = 'Eintrag l'#246'schen'
      ShortCut = 16430
      OnExecute = acDeleteEntryExecute
      OnUpdate = acDeleteEntryUpdate
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 528
    Top = 88
    object Eintraglschen1: TMenuItem
      Action = acDeleteEntry
    end
  end
end
