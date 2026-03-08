object fZahlungsarten: TfZahlungsarten
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Zahlungsarten'
  ClientHeight = 388
  ClientWidth = 310
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
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  DesignSize = (
    310
    388)
  TextHeight = 15
  object lvZahlungsarten: TAdvListView
    Left = 8
    Top = 39
    Width = 294
    Height = 282
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = 'ID'
        MaxWidth = 1
        Width = 0
      end
      item
        AutoSize = True
        Caption = 'Zahlungsarten'
      end>
    GridLines = True
    HideSelection = False
    OwnerDraw = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnClick = lvZahlungsartenClick
    OnKeyPress = lvZahlungsartenKeyPress
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
  end
  object edZahlungsart: TLabeledEdit
    Left = 8
    Top = 351
    Width = 109
    Height = 23
    Anchors = [akLeft, akRight, akBottom]
    EditLabel.Width = 63
    EditLabel.Height = 15
    EditLabel.Caption = 'Zahlungsart'
    TabOrder = 1
    Text = ''
    OnChange = edZahlungsartChange
  end
  object btnSave: TButton
    Left = 199
    Top = 350
    Width = 103
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Hinzuf'#252'gen'
    Enabled = False
    TabOrder = 2
    OnClick = btnSaveClick
  end
  object btnNewEntry: TButton
    Left = 8
    Top = 8
    Width = 113
    Height = 25
    Caption = 'Neuer Eintrag'
    TabOrder = 3
    OnClick = btnNewEntryClick
  end
  object btnDelete: TButton
    Left = 123
    Top = 350
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'L'#246'schen'
    Enabled = False
    TabOrder = 4
    Visible = False
    OnClick = btnDeleteClick
  end
end
