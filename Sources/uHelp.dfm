object fHelp: TfHelp
  Left = 0
  Top = 0
  Caption = 'Programmhilfe'
  ClientHeight = 441
  ClientWidth = 624
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
  OnResize = FormResize
  TextHeight = 15
  object pnlTitel: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 41
    Align = alTop
    Caption = 'Hilfe'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Segoe UI Semibold'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    ExplicitLeft = 232
    ExplicitTop = 224
    ExplicitWidth = 185
  end
  object RichEdit1: TRichEdit
    AlignWithMargins = True
    Left = 3
    Top = 44
    Width = 618
    Height = 394
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
    ExplicitTop = 3
    ExplicitWidth = 610
    ExplicitHeight = 405
  end
end
