unit uHelp;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AdvPageControl,
  Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TfHelp = class(TForm)
    pnlTitel: TPanel;
    RichEdit1: TRichEdit;
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  fHelp: TfHelp;

implementation

{$R *.dfm}

procedure TfHelp.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    Close;
  end;
end;

procedure TfHelp.FormResize(Sender: TObject);
begin
  //Caption := 'Width: ' + IntToStr(Width)+' Height: ' + IntToStr(Height);
end;

end.
