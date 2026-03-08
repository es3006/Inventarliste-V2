object fAnkaufformular: TfAnkaufformular
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Ankaufsformular'
  ClientHeight = 473
  ClientWidth = 742
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  Position = poMainFormCenter
  ShowInTaskBar = True
  OnActivate = FormActivate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 15
  object Panel4: TPanel
    Left = 0
    Top = 0
    Width = 357
    Height = 473
    Align = alLeft
    Color = 14548957
    ParentBackground = False
    ShowCaption = False
    TabOrder = 0
    ExplicitHeight = 528
    object Label8: TLabel
      Left = 196
      Top = 411
      Width = 76
      Height = 15
      Caption = 'Geburtsdatum'
    end
    object sbNextKdNr: TSpeedButton
      Left = 106
      Top = 102
      Width = 31
      Height = 22
      Cursor = crHandPoint
      Caption = 'Akt'
      Visible = False
      OnClick = sbNextKdNrClick
    end
    object edKundenNr: TLabeledEdit
      Left = 18
      Top = 101
      Width = 92
      Height = 23
      EditLabel.Width = 57
      EditLabel.Height = 15
      EditLabel.Caption = 'KundenNr'
      EditLabel.Font.Charset = DEFAULT_CHARSET
      EditLabel.Font.Color = clWindowText
      EditLabel.Font.Height = -12
      EditLabel.Font.Name = 'Segoe UI'
      EditLabel.Font.Style = [fsBold]
      EditLabel.ParentFont = False
      Enabled = False
      ReadOnly = True
      TabOrder = 1
      Text = ''
    end
    object edVorname: TLabeledEdit
      Left = 180
      Top = 166
      Width = 150
      Height = 23
      EditLabel.Width = 47
      EditLabel.Height = 15
      EditLabel.Caption = 'Vorname'
      EditLabel.Font.Charset = DEFAULT_CHARSET
      EditLabel.Font.Color = clWindowText
      EditLabel.Font.Height = -12
      EditLabel.Font.Name = 'Segoe UI'
      EditLabel.Font.Style = []
      EditLabel.ParentFont = False
      TabOrder = 3
      Text = ''
      OnKeyUp = edNachnameKeyUp
    end
    object edNachname: TLabeledEdit
      Left = 18
      Top = 166
      Width = 150
      Height = 23
      EditLabel.Width = 58
      EditLabel.Height = 15
      EditLabel.Caption = 'Nachname'
      EditLabel.Font.Charset = ANSI_CHARSET
      EditLabel.Font.Color = clWindowText
      EditLabel.Font.Height = -12
      EditLabel.Font.Name = 'Segoe UI'
      EditLabel.Font.Style = []
      EditLabel.ParentFont = False
      TabOrder = 2
      Text = ''
      OnKeyUp = edNachnameKeyUp
    end
    object edStrasseHausNr: TLabeledEdit
      Left = 18
      Top = 232
      Width = 150
      Height = 23
      EditLabel.Width = 82
      EditLabel.Height = 15
      EditLabel.Caption = 'Strasse, HausNr'
      TabOrder = 4
      Text = ''
      OnKeyUp = edNachnameKeyUp
    end
    object edPLZ: TLabeledEdit
      Left = 18
      Top = 282
      Width = 57
      Height = 23
      EditLabel.Width = 20
      EditLabel.Height = 15
      EditLabel.Caption = 'PLZ'
      MaxLength = 6
      TabOrder = 5
      Text = ''
      OnKeyPress = edPLZKeyPress
      OnKeyUp = edNachnameKeyUp
    end
    object edWohnort: TLabeledEdit
      Left = 87
      Top = 282
      Width = 243
      Height = 23
      EditLabel.Width = 47
      EditLabel.Height = 15
      EditLabel.Caption = 'Wohnort'
      TabOrder = 6
      Text = ''
      OnKeyUp = edNachnameKeyUp
    end
    object edTelefon: TLabeledEdit
      Left = 18
      Top = 332
      Width = 150
      Height = 23
      EditLabel.Width = 38
      EditLabel.Height = 15
      EditLabel.Caption = 'Telefon'
      TabOrder = 7
      Text = ''
      OnKeyPress = edTelefonKeyPress
      OnKeyUp = edNachnameKeyUp
    end
    object edHandy: TLabeledEdit
      Left = 180
      Top = 332
      Width = 150
      Height = 23
      EditLabel.Width = 35
      EditLabel.Height = 15
      EditLabel.Caption = 'Handy'
      TabOrder = 8
      Text = ''
      OnKeyPress = edTelefonKeyPress
      OnKeyUp = edNachnameKeyUp
    end
    object edEmail: TLabeledEdit
      Left = 18
      Top = 382
      Width = 177
      Height = 23
      EditLabel.Width = 29
      EditLabel.Height = 15
      EditLabel.Caption = 'Email'
      TabOrder = 9
      Text = ''
      OnKeyUp = edNachnameKeyUp
    end
    object edAusweisnr: TLabeledEdit
      Left = 18
      Top = 432
      Width = 177
      Height = 23
      EditLabel.Width = 54
      EditLabel.Height = 15
      EditLabel.Caption = 'Ausweisnr'
      TabOrder = 10
      Text = ''
      OnKeyUp = edNachnameKeyUp
    end
    object dtpGeburtsdatum: TDateTimePicker
      Left = 212
      Top = 432
      Width = 118
      Height = 23
      Date = 46025.000000000000000000
      Time = 0.918865486113645600
      ShowCheckbox = True
      TabOrder = 11
      OnKeyUp = edNachnameKeyUp
    end
    object Panel1: TPanel
      Left = 1
      Top = 1
      Width = 355
      Height = 60
      Align = alTop
      Color = 16773593
      ParentBackground = False
      ShowCaption = False
      TabOrder = 0
      object edKundensuche: TLabeledEdit
        Left = 18
        Top = 26
        Width = 225
        Height = 23
        EditLabel.Width = 263
        EditLabel.Height = 15
        EditLabel.Caption = 'Kundensuche (KundenNr, Nachname, AusweisNr)'
        ParentShowHint = False
        ShowHint = False
        TabOrder = 0
        Text = ''
        OnKeyPress = edKundensucheKeyPress
      end
      object btnKundensuche: TButton
        Left = 254
        Top = 24
        Width = 75
        Height = 25
        Caption = 'Suchen'
        TabOrder = 1
        OnClick = btnKundensucheClick
      end
    end
  end
  object AdvPageControl2: TAdvPageControl
    Left = 357
    Top = 0
    Width = 385
    Height = 473
    ActivePage = AdvTabSheet2
    ActiveFont.Charset = DEFAULT_CHARSET
    ActiveFont.Color = clWindowText
    ActiveFont.Height = -11
    ActiveFont.Name = 'Segoe UI'
    ActiveFont.Style = []
    Align = alClient
    DoubleBuffered = True
    TabBackGroundColor = clBtnFace
    TabMargin.RightMargin = 0
    TabOverlap = 0
    Version = '2.0.5.0'
    PersistPagesState.Location = plRegistry
    PersistPagesState.Enabled = False
    TabOrder = 1
    object AdvTabSheet2: TAdvTabSheet
      Caption = 'Anzukaufende Artikel'
      Color = clBtnFace
      ColorTo = clNone
      TabColor = clBtnFace
      TabColorTo = clNone
      ExplicitLeft = 24
      ExplicitTop = 0
      ExplicitWidth = 100
      ExplicitHeight = 100
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 377
        Height = 443
        Align = alClient
        AutoSize = True
        BevelOuter = bvNone
        ShowCaption = False
        TabOrder = 0
        ExplicitLeft = -8
        ExplicitTop = -33
        ExplicitWidth = 620
        ExplicitHeight = 511
        object pnlUhr: TPanel
          Left = 0
          Top = 57
          Width = 377
          Height = 100
          Align = alTop
          BevelOuter = bvNone
          Color = 14869218
          ParentBackground = False
          TabOrder = 1
          Visible = False
          ExplicitWidth = 383
          object Label9: TLabel
            Left = 18
            Top = 49
            Width = 43
            Height = 15
            Caption = 'Zustand'
          end
          object Bevel1: TBevel
            Left = 0
            Top = 90
            Width = 377
            Height = 10
            Align = alBottom
            Shape = bsBottomLine
            ExplicitTop = 112
            ExplicitWidth = 400
          end
          object edMarke: TLabeledEdit
            Left = 18
            Top = 22
            Width = 129
            Height = 23
            EditLabel.Width = 33
            EditLabel.Height = 15
            EditLabel.Caption = 'Marke'
            TabOrder = 0
            Text = ''
          end
          object edModel: TLabeledEdit
            Left = 155
            Top = 22
            Width = 128
            Height = 23
            EditLabel.Width = 34
            EditLabel.Height = 15
            EditLabel.Caption = 'Model'
            TabOrder = 1
            Text = ''
          end
          object edJahr: TLabeledEdit
            Left = 289
            Top = 22
            Width = 56
            Height = 23
            EditLabel.Width = 21
            EditLabel.Height = 15
            EditLabel.Caption = 'Jahr'
            MaxLength = 4
            NumbersOnly = True
            TabOrder = 2
            Text = ''
          end
          object cbBox: TCheckBox
            Left = 155
            Top = 72
            Width = 48
            Height = 17
            Caption = 'Box'
            TabOrder = 4
          end
          object cbPapiere: TCheckBox
            Left = 207
            Top = 72
            Width = 65
            Height = 17
            Caption = 'Papiere'
            TabOrder = 5
          end
          object cbZustand: TComboBox
            Left = 18
            Top = 69
            Width = 129
            Height = 23
            Style = csDropDownList
            TabOrder = 3
            OnSelect = cbZustandSelect
          end
        end
        object pnlVerkaufsdaten: TPanel
          Left = 0
          Top = 157
          Width = 377
          Height = 200
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 2
          ExplicitTop = 229
          ExplicitWidth = 624
          object Label3: TLabel
            Left = 18
            Top = 109
            Width = 36
            Height = 15
            Caption = 'Einheit'
          end
          object edGewicht: TLabeledEdit
            Left = 135
            Top = 126
            Width = 82
            Height = 23
            EditLabel.Width = 61
            EditLabel.Height = 15
            EditLabel.Caption = 'Gewicht (g)'
            TabOrder = 3
            Text = ''
            OnExit = edGewichtExit
            OnKeyPress = edAnkaufspreisKeyPress
          end
          object edKarat: TLabeledEdit
            Left = 223
            Top = 126
            Width = 82
            Height = 23
            Color = 14680053
            EditLabel.Width = 27
            EditLabel.Height = 15
            EditLabel.Caption = 'Karat'
            NumbersOnly = True
            TabOrder = 4
            Text = ''
          end
          object edArtikelname: TLabeledEdit
            Left = 18
            Top = 26
            Width = 327
            Height = 23
            EditLabel.Width = 158
            EditLabel.Height = 15
            EditLabel.Caption = 'Artikelname (max 50 Zeichen)'
            MaxLength = 50
            TabOrder = 0
            Text = ''
          end
          object edAnkaufspreis: TLabeledEdit
            Left = 18
            Top = 177
            Width = 111
            Height = 23
            EditLabel.Width = 106
            EditLabel.Height = 15
            EditLabel.Caption = 'Ankaufspreis (EUR)'
            EditLabel.Font.Charset = DEFAULT_CHARSET
            EditLabel.Font.Color = clWindowText
            EditLabel.Font.Height = -12
            EditLabel.Font.Name = 'Segoe UI'
            EditLabel.Font.Style = [fsBold]
            EditLabel.ParentFont = False
            MaxLength = 10
            TabOrder = 5
            Text = ''
            OnChange = edAnkaufspreisChange
            OnExit = edGewichtExit
            OnKeyPress = edAnkaufspreisKeyPress
          end
          object edEinkaufBemerkung: TLabeledEdit
            Left = 18
            Top = 76
            Width = 327
            Height = 23
            EditLabel.Width = 103
            EditLabel.Height = 15
            EditLabel.Caption = 'Einkauf Bemerkung'
            TabOrder = 1
            Text = ''
          end
          object cbEinheiten: TComboBox
            Left = 18
            Top = 126
            Width = 111
            Height = 23
            Style = csDropDownList
            TabOrder = 2
          end
        end
        object pnlVerkaufDefault: TPanel
          Left = 0
          Top = 0
          Width = 377
          Height = 57
          Align = alTop
          BevelOuter = bvNone
          ShowCaption = False
          TabOrder = 0
          ExplicitWidth = 383
          object Bevel3: TBevel
            Left = 0
            Top = 47
            Width = 377
            Height = 10
            Align = alBottom
            Shape = bsBottomLine
            ExplicitLeft = -4
            ExplicitTop = 129
            ExplicitWidth = 375
          end
          object Label4: TLabel
            Left = 18
            Top = 9
            Width = 100
            Height = 15
            Caption = 'Was kaufen Sie an?'
          end
          object rbUhr: TRadioButton
            Left = 18
            Top = 30
            Width = 63
            Height = 17
            Caption = 'Uhr'
            TabOrder = 0
            OnClick = rbUhrClick
          end
          object rbSchmuck: TRadioButton
            Left = 72
            Top = 30
            Width = 113
            Height = 17
            Caption = 'Schmuck'
            Checked = True
            TabOrder = 1
            TabStop = True
            OnClick = rbSchmuckClick
          end
        end
        object btnAddNewItem: TButton
          Left = 18
          Top = 406
          Width = 167
          Height = 25
          Caption = 'Weiteren Artikel ankaufen'
          TabOrder = 3
        end
        object btnKaufBeenden: TButton
          Left = 216
          Top = 406
          Width = 129
          Height = 25
          Caption = 'Kauf beenden'
          TabOrder = 4
          OnClick = btnKaufBeendenClick
        end
      end
    end
    object AdvTabSheet3: TAdvTabSheet
      Caption = 'Ankauf abschlie'#223'en'
      Color = clBtnFace
      ColorTo = clNone
      TabColor = clBtnFace
      TabColorTo = clNone
      ExplicitLeft = 5
      ExplicitTop = 27
      ExplicitWidth = 383
      ExplicitHeight = 497
      object Label10: TLabel
        Left = 19
        Top = 287
        Width = 63
        Height = 15
        Caption = 'Zahlungsart'
      end
      object sbNextSKU: TSpeedButton
        Left = 206
        Top = 256
        Width = 28
        Height = 22
        Cursor = crHandPoint
        Caption = 'Akt'
        Visible = False
        OnClick = sbNextSKUClick
      end
      object Label1: TLabel
        Left = 248
        Top = 239
        Width = 81
        Height = 15
        Caption = 'Ankaufsdatum'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
      end
      object Label2: TLabel
        Left = 16
        Top = 16
        Width = 113
        Height = 15
        Caption = 'Anzukaufende Artikel'
      end
      object cbZahlungsarten: TComboBox
        Left = 15
        Top = 306
        Width = 111
        Height = 23
        Style = csDropDownList
        TabOrder = 0
        OnSelect = cbZahlungsartenSelect
      end
      object edVersand: TLabeledEdit
        Left = 132
        Top = 306
        Width = 93
        Height = 23
        EditLabel.Width = 73
        EditLabel.Height = 15
        EditLabel.Caption = 'Versand (EUR)'
        TabOrder = 1
        Text = ''
        OnChange = edAnkaufspreisChange
        OnExit = edGewichtExit
        OnKeyPress = edAnkaufspreisKeyPress
      end
      object edGesamtbetrag: TLabeledEdit
        Left = 231
        Top = 306
        Width = 130
        Height = 23
        EditLabel.Width = 106
        EditLabel.Height = 15
        EditLabel.Caption = 'Gesamtbetrag (EUR)'
        MaxLength = 10
        TabOrder = 2
        Text = ''
        OnExit = edGewichtExit
        OnKeyPress = edAnkaufspreisKeyPress
      end
      object rbAddToInventarliste: TRadioButton
        Left = 15
        Top = 339
        Width = 199
        Height = 17
        Caption = 'In Inventarliste aufnehmen'
        TabOrder = 3
      end
      object rbEdelmetallSammelverkauf: TRadioButton
        Left = 15
        Top = 362
        Width = 246
        Height = 17
        Caption = 'F'#252'r Edelmetall-Sammelverkauf markieren'
        TabOrder = 4
      end
      object AdvListView1: TAdvListView
        Left = 15
        Top = 35
        Width = 346
        Height = 194
        Columns = <>
        TabOrder = 5
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
        DetailView.Font.Charset = DEFAULT_CHARSET
        DetailView.Font.Color = clBlue
        DetailView.Font.Height = -12
        DetailView.Font.Name = 'Segoe UI'
        DetailView.Font.Style = []
        Version = '1.9.1.1'
      end
      object btnSaveAnkauf: TButton
        Left = 15
        Top = 405
        Width = 346
        Height = 25
        Caption = 'Kauf abschlie'#223'en'
        TabOrder = 6
        OnClick = btnSaveAnkaufClick
      end
      object edReferenz: TLabeledEdit
        Left = 15
        Top = 256
        Width = 88
        Height = 23
        EditLabel.Width = 45
        EditLabel.Height = 15
        EditLabel.Caption = 'Referenz'
        MaxLength = 10
        TabOrder = 7
        Text = ''
      end
      object edSKU: TLabeledEdit
        Left = 121
        Top = 256
        Width = 87
        Height = 23
        CharCase = ecUpperCase
        EditLabel.Width = 24
        EditLabel.Height = 15
        EditLabel.Caption = 'SKU'
        EditLabel.Font.Charset = DEFAULT_CHARSET
        EditLabel.Font.Color = clWindowText
        EditLabel.Font.Height = -12
        EditLabel.Font.Name = 'Segoe UI'
        EditLabel.Font.Style = [fsBold]
        EditLabel.ParentFont = False
        TabOrder = 8
        Text = ''
        TextHint = 'AK'
        Visible = False
      end
      object dtpAnkaufsdatum: TDateTimePicker
        Left = 248
        Top = 256
        Width = 96
        Height = 23
        Date = 46025.000000000000000000
        Time = 0.918865486113645600
        ShowCheckbox = True
        TabOrder = 9
        Visible = False
      end
    end
  end
end
