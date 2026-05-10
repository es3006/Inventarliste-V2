object fAnkaufformular: TfAnkaufformular
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Ankaufsformular'
  ClientHeight = 501
  ClientWidth = 753
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
    Height = 501
    Align = alLeft
    Color = 14548957
    ParentBackground = False
    ShowCaption = False
    TabOrder = 0
    object Label5: TLabel
      Left = 10
      Top = 26
      Width = 82
      Height = 17
      Caption = 'Kundendaten'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edVorname: TLabeledEdit
      Left = 172
      Top = 96
      Width = 150
      Height = 23
      EditLabel.Width = 50
      EditLabel.Height = 15
      EditLabel.Caption = 'Vorname'
      EditLabel.Font.Charset = DEFAULT_CHARSET
      EditLabel.Font.Color = clWindowText
      EditLabel.Font.Height = -12
      EditLabel.Font.Name = 'Segoe UI'
      EditLabel.Font.Style = [fsBold]
      EditLabel.ParentFont = False
      TabOrder = 1
      Text = ''
      OnKeyUp = edNachnameKeyUp
    end
    object edNachname: TLabeledEdit
      Left = 10
      Top = 96
      Width = 150
      Height = 23
      EditLabel.Width = 59
      EditLabel.Height = 15
      EditLabel.Caption = 'Nachname'
      EditLabel.Font.Charset = ANSI_CHARSET
      EditLabel.Font.Color = clWindowText
      EditLabel.Font.Height = -12
      EditLabel.Font.Name = 'Segoe UI'
      EditLabel.Font.Style = [fsBold]
      EditLabel.ParentFont = False
      TabOrder = 0
      Text = ''
      OnKeyUp = edNachnameKeyUp
    end
    object edStrasseHausNr: TLabeledEdit
      Left = 10
      Top = 162
      Width = 150
      Height = 23
      EditLabel.Width = 82
      EditLabel.Height = 15
      EditLabel.Caption = 'Strasse, HausNr'
      TabOrder = 2
      Text = ''
      OnKeyUp = edNachnameKeyUp
    end
    object edPLZ: TLabeledEdit
      Left = 10
      Top = 212
      Width = 57
      Height = 23
      EditLabel.Width = 20
      EditLabel.Height = 15
      EditLabel.Caption = 'PLZ'
      MaxLength = 6
      TabOrder = 3
      Text = ''
      OnKeyPress = edPLZKeyPress
      OnKeyUp = edNachnameKeyUp
    end
    object edWohnort: TLabeledEdit
      Left = 79
      Top = 212
      Width = 243
      Height = 23
      EditLabel.Width = 47
      EditLabel.Height = 15
      EditLabel.Caption = 'Wohnort'
      TabOrder = 4
      Text = ''
      OnKeyUp = edNachnameKeyUp
    end
    object edTelefon: TLabeledEdit
      Left = 10
      Top = 262
      Width = 150
      Height = 23
      EditLabel.Width = 38
      EditLabel.Height = 15
      EditLabel.Caption = 'Telefon'
      TabOrder = 5
      Text = ''
      OnKeyPress = edTelefonKeyPress
      OnKeyUp = edNachnameKeyUp
    end
    object edEmail: TLabeledEdit
      Left = 10
      Top = 312
      Width = 312
      Height = 23
      EditLabel.Width = 29
      EditLabel.Height = 15
      EditLabel.Caption = 'Email'
      TabOrder = 6
      Text = ''
      OnKeyUp = edNachnameKeyUp
    end
  end
  object PageControlArtikel: TAdvPageControl
    Left = 357
    Top = 0
    Width = 396
    Height = 501
    ActivePage = AdvTabSheet3
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
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 388
        Height = 471
        Align = alClient
        AutoSize = True
        BevelOuter = bvNone
        ShowCaption = False
        TabOrder = 0
        object pnlUhr: TPanel
          Left = 0
          Top = 57
          Width = 388
          Height = 100
          Align = alTop
          BevelOuter = bvNone
          Color = 14869218
          ParentBackground = False
          TabOrder = 1
          Visible = False
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
            Width = 388
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
            Width = 158
            Height = 23
            EditLabel.Width = 34
            EditLabel.Height = 15
            EditLabel.Caption = 'Model'
            TabOrder = 1
            Text = ''
          end
          object edJahr: TLabeledEdit
            Left = 319
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
            Left = 247
            Top = 72
            Width = 48
            Height = 17
            Caption = 'Box'
            TabOrder = 5
          end
          object cbPapiere: TCheckBox
            Left = 299
            Top = 72
            Width = 65
            Height = 17
            Caption = 'Papiere'
            TabOrder = 6
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
          object edReferenz: TLabeledEdit
            Left = 153
            Top = 69
            Width = 88
            Height = 23
            EditLabel.Width = 45
            EditLabel.Height = 15
            EditLabel.Caption = 'Referenz'
            MaxLength = 10
            TabOrder = 4
            Text = ''
          end
        end
        object pnlVerkaufsdaten: TPanel
          Left = 0
          Top = 157
          Width = 388
          Height = 208
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 2
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
            EditLabel.Width = 168
            EditLabel.Height = 15
            EditLabel.Caption = 'Artikelname (max 50 Zeichen)'
            EditLabel.Font.Charset = DEFAULT_CHARSET
            EditLabel.Font.Color = clWindowText
            EditLabel.Font.Height = -12
            EditLabel.Font.Name = 'Segoe UI'
            EditLabel.Font.Style = [fsBold]
            EditLabel.ParentFont = False
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
          Width = 388
          Height = 57
          Align = alTop
          BevelOuter = bvNone
          ShowCaption = False
          TabOrder = 0
          object Bevel3: TBevel
            Left = 0
            Top = 47
            Width = 388
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
          Top = 430
          Width = 167
          Height = 25
          Caption = 'Weiteren Artikel ankaufen'
          TabOrder = 3
          OnClick = btnAddNewItemClick
        end
        object btnKaufBeenden: TButton
          Left = 240
          Top = 430
          Width = 129
          Height = 25
          Caption = 'Kauf beenden'
          TabOrder = 4
          OnClick = btnKaufBeendenClick
        end
        object rbEdelmetallSammelverkauf: TRadioButton
          Left = 18
          Top = 394
          Width = 246
          Height = 17
          Caption = 'F'#252'r Edelmetall-Sammelverkauf markieren'
          TabOrder = 5
        end
        object rbAddToInventarliste: TRadioButton
          Left = 18
          Top = 371
          Width = 199
          Height = 17
          Caption = 'In Inventarliste aufnehmen'
          TabOrder = 6
          OnClick = rbAddToInventarlisteClick
        end
      end
    end
    object AdvTabSheet3: TAdvTabSheet
      Caption = 'Ankauf abschlie'#223'en'
      Color = clBtnFace
      ColorTo = clNone
      TabColor = clBtnFace
      TabColorTo = clNone
      object Label10: TLabel
        Left = 19
        Top = 287
        Width = 65
        Height = 15
        Caption = 'Zahlungsart'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
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
        OnExit = edGewichtExit
        OnKeyPress = edAnkaufspreisKeyPress
      end
      object edGesamtbetrag: TLabeledEdit
        Left = 231
        Top = 306
        Width = 146
        Height = 23
        EditLabel.Width = 114
        EditLabel.Height = 15
        EditLabel.Caption = 'Gesamtbetrag (EUR)'
        EditLabel.Font.Charset = DEFAULT_CHARSET
        EditLabel.Font.Color = clWindowText
        EditLabel.Font.Height = -12
        EditLabel.Font.Name = 'Segoe UI'
        EditLabel.Font.Style = [fsBold]
        EditLabel.ParentFont = False
        MaxLength = 10
        TabOrder = 2
        Text = ''
        OnExit = edGewichtExit
        OnKeyPress = edAnkaufspreisKeyPress
      end
      object lvAnkaufartikel: TAdvListView
        Left = 15
        Top = 35
        Width = 362
        Height = 246
        Columns = <
          item
            Caption = 'Art'
          end
          item
            Caption = 'SKU'
          end
          item
            Caption = 'Artikelname'
          end
          item
            Caption = 'EinkaufBemerkung'
          end
          item
            Caption = 'Einheit'
          end
          item
            Caption = 'Gewicht'
          end
          item
            Caption = 'Karat'
          end
          item
            Caption = 'Ankaufpreis'
          end
          item
            Caption = 'UhrMarke'
          end
          item
            Caption = 'UhrModel'
          end
          item
            Caption = 'UhrJahr'
          end
          item
            Caption = 'UhrZustand'
          end
          item
            Caption = 'UhrReferenz'
          end
          item
            Caption = 'UhrBox'
          end
          item
            Caption = 'UhrPapiere'
          end>
        ReadOnly = True
        RowSelect = True
        TabOrder = 3
        ViewStyle = vsReport
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
        TabOrder = 4
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
        TabOrder = 5
        Visible = False
      end
      object btnAnkaufBeenden: TButton
        Left = 15
        Top = 405
        Width = 362
        Height = 25
        Caption = 'Kauf abschlie'#223'en'
        TabOrder = 6
        OnClick = btnAnkaufBeendenClick
      end
    end
  end
end
