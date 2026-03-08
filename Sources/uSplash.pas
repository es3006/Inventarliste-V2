unit uSplash;

interface

uses
  System.SysUtils, System.Classes, Vcl.Forms, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.Controls, Vcl.ExtCtrls;

type
  TfSplash = class(TForm)
    Panel1: TPanel;
    lbStatus: TLabel;
    pbProgress: TProgressBar;
  public
    procedure SetStatus(const AText: string; AProgress: Integer = -1);
  end;

var
  fSplash: TfSplash;

implementation

{$R *.dfm}

procedure TfSplash.SetStatus(const AText: string; AProgress: Integer);
begin
  lbStatus.Caption := AText;
  if AProgress >= 0 then
    pbProgress.Position := AProgress;

  // Sofort sichtbar machen
  Application.ProcessMessages;
end;

end.

