unit uSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, inifiles, Vcl.Mask,
  Vcl.ExtCtrls, AdvPageControl, Vcl.ComCtrls;

type
  TfSettings = class(TForm)
    AdvPageControl1: TAdvPageControl;
    AdvTabSheet1: TAdvTabSheet;
    AdvTabSheet2: TAdvTabSheet;
    edFirmenname: TLabeledEdit;
    edFirmeninhaber: TLabeledEdit;
    edFirmaStrasse: TLabeledEdit;
    edFirmaPLZ: TLabeledEdit;
    edFirmaOrt: TLabeledEdit;
    edFirmaUmsatzsteuerID: TLabeledEdit;
    edFirmaIBAN: TLabeledEdit;
    btnSaveFirmendaten: TButton;
    Label1: TLabel;
    cbSortierungSpalte: TComboBox;
    cbSortDirection: TCheckBox;
    btnSave: TButton;
    cbShowHinweisFenster: TCheckBox;
    Label2: TLabel;
    procedure btnSaveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbSortierungSpalteSelect(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnSaveFirmendatenClick(Sender: TObject);
  private
    procedure ReadSettings;
  public
    { Public-Deklarationen }
  end;

var
  fSettings: TfSettings;

implementation

{$R *.dfm}

uses
  uMain;

procedure TfSettings.btnSaveClick(Sender: TObject);
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(PATH + 'settings.ini');
  try
    if(cbSortierungSpalte.ItemIndex > 0) then
    begin
      ini.WriteInteger('SORTIERUNG','Spalte',cbSortierungSpalte.ItemIndex);
      ini.WriteBool('SORTIERUNG','SortDirection',cbSortDirection.Checked);  //checked = absteigend = 1
      ini.WriteBool('ANSICHT','ShowDownHintWindow',cbShowHinweisFenster.Checked);

      SHOWHINWEISFENSTER := cbShowHinweisFenster.Checked;

      ColumnToSort := cbSortierungSpalte.ItemIndex;  // Spalte
      if(cbSortDirection.Checked) then SortDir := 1 else SortDir := 0;

      LastSorted := 1;

      fMain.lvInventar.AlphaSort;
    end
    else
    begin
      showmessage('Bitte geben Sie an nach welcher Zeile die Liste sortiert werden soll!');
      exit;
    end;
  finally
    ini.Free;
  end;
  LastSorted := 1;     // damit der erste Klick korrekt toggelt
  fMain.lvInventar.AlphaSort;
  fMain.lvInventar.Sort;
  Application.ProcessMessages;

  close;
end;




procedure TfSettings.btnSaveFirmendatenClick(Sender: TObject);
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(PATH + 'settings.ini');
  try
    ini.WriteString('FIRME','Firmenname', trim(edFirmenname.Text));
    ini.WriteString('FIRMA','Firmeninhaber', trim(edFirmenInhaber.Text));
    ini.WriteString('FIRMA','FirmaStrasse', trim(edFirmaStrasse.Text));
    ini.WriteString('FIRMA','FirmaPLZ', trim(edFirmaPLZ.Text));
    ini.WriteString('FIRMA','FirmaOrt', trim(edFirmaOrt.Text));
    ini.WriteString('FIRMA','FirmaUStID', trim(edFirmaUmsatzsteuerID.Text));
    ini.WriteString('FIRMA','FirmaIBAN', trim(edFirmaIBAN.Text));

    FIRMENNAME := trim(edFirmenname.Text);
    FIRMENINHABER := trim(edFirmenInhaber.Text);
    FIRMASTRASSE := trim(edFirmaStrasse.Text);
    FIRMAPLZ := trim(edFirmaPLZ.Text);
    FIRMAORT := trim(edFirmaOrt.Text);
    FIRMAUMSATZSTEUERID := trim(edFirmaUmsatzsteuerID.Text);
    FIRMAIBAN := trim(edFirmaIBAN.Text);
  finally
    ini.Free;
  end;
  close;
end;





procedure TfSettings.cbSortierungSpalteSelect(Sender: TObject);
begin
  if(cbSortierungSpalte.ItemIndex > 0) then
    cbSortDirection.Enabled := true
  else
    cbSortDirection.Enabled := false;
end;



procedure TfSettings.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    Close;
  end;
end;




procedure TfSettings.FormShow(Sender: TObject);
begin
  caption := 'Programmeinstellungen';
  ReadSettings;
end;





procedure TfSettings.ReadSettings;
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(PATH + 'settings.ini');
  try
    edFirmenname.Text := ini.ReadString('FIRME','Firmenname', 'Uhren & Schmuck Togge');
    edFirmenInhaber.Text := ini.ReadString('FIRMA','Firmeninhaber', 'Alexander Keller');
    edFirmaStrasse.Text := ini.ReadString('FIRMA','FirmaStrasse', 'Siemens Straﬂe 12');
    edFirmaPLZ.Text := ini.ReadString('FIRMA','FirmaPLZ', '86899');
    edFirmaOrt.Text := ini.ReadString('FIRMA','FirmaOrt', 'Landsberg am Lech');
    edFirmaUmsatzsteuerID.Text := ini.ReadString('FIRMA','FirmaUStID', 'DE353427576');
    edFirmaIBAN.Text := ini.ReadString('FIRMA','FirmaIBAN', 'DE72 2060 0022 8620 49');

    cbSortierungSpalte.ItemIndex := ini.ReadInteger('SORTIERUNG','Spalte', 1);
    cbSortDirection.Checked := ini.ReadBool('SORTIERUNG', 'SortDirection', true);

    cbShowHinweisFenster.Checked := ini.ReadBool('ANSICHT','ShowDownHintWindow', true);
  finally
    ini.Free;
  end;
end;


end.
