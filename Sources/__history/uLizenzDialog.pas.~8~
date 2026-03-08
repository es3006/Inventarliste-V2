unit uLizenzDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls, System.DateUtils;

type
  TfLizenzDialog = class(TForm)
    edEmail: TLabeledEdit;
    edLizenzcode: TLabeledEdit;
    lblStatus: TLabel;
    btnAbbrechen: TButton;
    btnOK: TButton;
    Label1: TLabel;
    procedure btnAbbrechenClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    FEmail: string;
    FLizenzcode: string;
  public
    property Email: string read FEmail;
    property Lizenzcode: string read FLizenzcode;
  end;

var
  fLizenzDialog: TfLizenzDialog;

implementation

{$R *.dfm}

uses
  uLizenztools, uMain, uFunctions;




procedure TfLizenzDialog.btnAbbrechenClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;




// uLizenzDialog.pas - btnOKClick Methode
// KORRIGIERTE VERSION

procedure TfLizenzDialog.btnOKClick(Sender: TObject);
var
  Antwort, Status, Grund, Programmname: string;
  AblaufDatum: TDateTime;
begin
  lblStatus.Caption := '';
  Programmname := ChangeFileExt(ExtractFileName(Application.ExeName), '');
  FEmail       := Trim(edEmail.Text);
  FLizenzcode  := Trim(edLizenzcode.Text);

  if FEmail = '' then
  begin
    lblStatus.Caption := 'Bitte E-Mail-Adresse eingeben.';
    Exit;
  end;

  if FLizenzcode = '' then
  begin
    lblStatus.Caption := 'Bitte Lizenzcode eingeben.';
    Exit;
  end;

  // Lizenz online prüfen
  Antwort := PruefeLizenzOnline(FLizenzcode, FEmail, GetHWID, Programmname);

  // Status + optionales Datum aus der Antwort extrahieren
  if Pos('|', Antwort) > 0 then
  begin
    Status := Copy(Antwort, 1, Pos('|', Antwort) - 1);
    Grund  := Copy(Antwort, Pos('|', Antwort) + 1, MaxInt);

    AblaufDatum := 0;
    if (Grund <> '') and TryISO8601ToDate(Grund, AblaufDatum) then
    begin
      // WICHTIG: Ablaufdatum speichern!
      SetLizenzGueltigBis(AblaufDatum);
    end;
  end
  else
  begin
    Status := Antwort;
    Grund := '';
  end;

  // -------------------------
  // Ergebnis auswerten
  // -------------------------
  if Status = 'OK' then
  begin
    // WICHTIG: In dieser Reihenfolge!
    SaveLizenzInSettingsINI(FEmail, FLizenzcode);  // Email + Code speichern
    SetLetzterOnlineCheck;                          // LastOnlineCheck speichern
    // SetLizenzGueltigBis wurde bereits oben aufgerufen!

    if Assigned(fMain) and Assigned(fMain.StatusBar1) then
      fMain.StatusBar1.Panels[0].Text := 'Gültige Lizenz gefunden';

    ModalResult := mrOk; // Dialog schließen
    Exit;
  end;

  // Alle Fehlercodes behandeln
  if Status = 'INACTIVE' then
    lblStatus.Caption := 'Lizenz deaktiviert: ' + Grund
  else if Status = 'EXPIRED' then
    lblStatus.Caption := 'Lizenz abgelaufen.'
  else if Status = 'NOT_YET_VALID' then
    lblStatus.Caption := 'Lizenz noch nicht gültig.'
  else if Status = 'INVALID' then
    lblStatus.Caption := 'E-Mail oder Lizenzcode ungültig.'
  else if Status = 'UNKNOWN_USER' then
    lblStatus.Caption := 'Unbekannte E-Mail-Adresse.'
  else if Status = 'UNKNOWN_HWID' then
    lblStatus.Caption := 'Lizenz nicht für dieses Gerät.'
  else if Status = 'NO_SLOT' then
    lblStatus.Caption := 'Maximale Anzahl Geräte erreicht.'
  else if Status = 'ERROR' then
    lblStatus.Caption := 'Lizenzserver nicht erreichbar.'
  else
    lblStatus.Caption := 'Unbekannte Antwort: ' + Antwort;

  lblStatus.Font.Color := clRed;
  edLizenzcode.SetFocus;
end;





end.
