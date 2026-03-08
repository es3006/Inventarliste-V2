object fSettings: TfSettings
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'fSettings'
  ClientHeight = 341
  ClientWidth = 443
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poMainFormCenter
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 15
  object AdvPageControl1: TAdvPageControl
    Left = 8
    Top = 8
    Width = 425
    Height = 321
    ActivePage = AdvTabSheet1
    ActiveFont.Charset = DEFAULT_CHARSET
    ActiveFont.Color = clWindowText
    ActiveFont.Height = -11
    ActiveFont.Name = 'Segoe UI'
    ActiveFont.Style = []
    DoubleBuffered = True
    TabBackGroundColor = clBtnFace
    TabMargin.RightMargin = 0
    TabOverlap = 0
    Version = '2.0.5.0'
    PersistPagesState.Location = plRegistry
    PersistPagesState.Enabled = False
    TabOrder = 0
    object AdvTabSheet1: TAdvTabSheet
      Caption = 'Firmendaten'
      Color = clBtnFace
      ColorTo = clNone
      TabColor = clBtnFace
      TabColorTo = clNone
      object Label2: TLabel
        AlignWithMargins = True
        Left = 10
        Top = 3
        Width = 397
        Height = 65
        Margins.Left = 10
        Margins.Right = 10
        Align = alTop
        AutoSize = False
        Caption = 
          'Die hier gemachten Angaben, werden unter anderem im Ankaufsformu' +
          'lar angezeigt.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 417
      end
      object edFirmenname: TLabeledEdit
        Left = 24
        Top = 88
        Width = 177
        Height = 23
        EditLabel.Width = 67
        EditLabel.Height = 15
        EditLabel.Caption = 'Firmenname'
        TabOrder = 0
        Text = ''
      end
      object edFirmeninhaber: TLabeledEdit
        Left = 216
        Top = 88
        Width = 177
        Height = 23
        EditLabel.Width = 40
        EditLabel.Height = 15
        EditLabel.Caption = 'Inhaber'
        TabOrder = 1
        Text = ''
      end
      object edFirmaStrasse: TLabeledEdit
        Left = 24
        Top = 136
        Width = 146
        Height = 23
        EditLabel.Width = 36
        EditLabel.Height = 15
        EditLabel.Caption = 'Strasse'
        TabOrder = 2
        Text = ''
      end
      object edFirmaPLZ: TLabeledEdit
        Left = 176
        Top = 136
        Width = 57
        Height = 23
        EditLabel.Width = 20
        EditLabel.Height = 15
        EditLabel.Caption = 'PLZ'
        TabOrder = 3
        Text = ''
      end
      object edFirmaOrt: TLabeledEdit
        Left = 239
        Top = 136
        Width = 154
        Height = 23
        EditLabel.Width = 17
        EditLabel.Height = 15
        EditLabel.Caption = 'Ort'
        TabOrder = 4
        Text = ''
      end
      object edFirmaUmsatzsteuerID: TLabeledEdit
        Left = 24
        Top = 185
        Width = 121
        Height = 23
        EditLabel.Width = 82
        EditLabel.Height = 15
        EditLabel.Caption = 'UmsatzsteuerID'
        TabOrder = 5
        Text = ''
      end
      object edFirmaIBAN: TLabeledEdit
        Left = 176
        Top = 185
        Width = 217
        Height = 23
        EditLabel.Width = 27
        EditLabel.Height = 15
        EditLabel.Caption = 'IBAN'
        TabOrder = 6
        Text = ''
      end
      object btnSaveFirmendaten: TButton
        Left = 288
        Top = 256
        Width = 105
        Height = 25
        Caption = 'Speichern'
        TabOrder = 7
        OnClick = btnSaveFirmendatenClick
      end
    end
    object AdvTabSheet2: TAdvTabSheet
      Caption = 'Ansicht'
      Color = clBtnFace
      ColorTo = clNone
      TabColor = clBtnFace
      TabColorTo = clNone
      DesignSize = (
        417
        291)
      object Label1: TLabel
        Left = 16
        Top = 35
        Width = 134
        Height = 15
        Caption = 'Standard Sortierung nach'
      end
      object cbSortierungSpalte: TComboBox
        Left = 16
        Top = 56
        Width = 145
        Height = 23
        Style = csDropDownList
        TabOrder = 0
        OnSelect = cbSortierungSpalteSelect
        Items.Strings = (
          ''
          'Einkaufsdatum'
          'SKU'
          'Einheit'
          'Einkaufswert'
          'Einkauf Bemerkung'
          'Verkaufsdatum'
          'Verkaufswert'
          'Verkauf Bemerkung'
          'zu besteuern'
          'RechnungsNr')
      end
      object cbSortDirection: TCheckBox
        Left = 16
        Top = 96
        Width = 289
        Height = 17
        Caption = 'Absteigend (H'#246'chster Wert zu kleinstem Wert)'
        TabOrder = 1
      end
      object btnSave: TButton
        Left = 288
        Top = 256
        Width = 105
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'Speichern'
        TabOrder = 2
        OnClick = btnSaveClick
      end
      object cbShowHinweisFenster: TCheckBox
        Left = 16
        Top = 168
        Width = 249
        Height = 17
        Caption = 'Hinweisfenster unten anzeigen'
        TabOrder = 3
      end
    end
  end
end
