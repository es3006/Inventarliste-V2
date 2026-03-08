unit uEinkauf;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Mask,
  Vcl.ExtCtrls, Vcl.Buttons, FireDAC.Stan.Param, FireDAC.Phys.SQLite, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.Stan.Intf, FireDAC.DApt, Vcl.Imaging.pngimage, DateUtils;

type
  TfEinkauf = class(TForm)
    Label1: TLabel;
    Label3: TLabel;
    edSKU: TLabeledEdit;
    edEinkaufswert: TLabeledEdit;
    edEinkaufBemerkung: TLabeledEdit;
    dtpEinkaufsdatum: TDateTimePicker;
    cbEinheiten: TComboBox;
    edMenge: TLabeledEdit;
    btnSave: TButton;
    Label2: TLabel;
    Label4: TLabel;
    btnAbort: TButton;
    Bevel1: TBevel;
    Label6: TLabel;
    edNeueEinheit: TLabeledEdit;
    Panel1: TPanel;
    Label7: TLabel;
    imgTaschenrechner: TImage;
    procedure FormShow(Sender: TObject);
    procedure btnAbortClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure edEinkaufswertKeyPress(Sender: TObject; var Key: Char);
    procedure imgTaschenrechnerClick(Sender: TObject);
    procedure imgTaschenrechnerMouseEnter(Sender: TObject);
    procedure imgTaschenrechnerMouseLeave(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private

  public
    { Public-Deklarationen }
  end;

var
  fEinkauf: TfEinkauf;

implementation

{$R *.dfm}

uses
  uFunctions, uDBFunctions, uMain;

procedure TfEinkauf.btnAbortClick(Sender: TObject);
begin
  close;
end;





procedure TfEinkauf.btnSaveClick(Sender: TObject);
var
  sku, einkaufBemerkung, einheit, neueEinheit: string;
  einkaufswertCent: Int64;
  menge, a, i: Integer;
  FDQuery: TFDQuery;

  DTEinkauf: TDateTime;
  TSEinkauf: Int64;
begin
  // ===== Validierungen =====
  if Trim(edMenge.Text) = '' then
  begin
    ShowMessage('Bitte geben Sie die Menge an!');
    Exit;
  end;

  if not TryStrToInt(edMenge.Text, menge) or (menge <= 0) then
  begin
    ShowMessage('Die Menge muss eine Zahl größer 0 sein!');
    Exit;
  end;




  // ===== Werte für Datenbank übernehmen =====

  //SKU
  sku := Trim(edSKU.Text);

  //Einkaufsdatum als Integer in Datenbank speichern
  DTEinkauf := dtpEinkaufsdatum.Date;
  TSEinkauf := DateTimeToUnix(DTEinkauf);

  //Einkaufswert
  einkaufswertCent := EditToCentSafe(edEinkaufswert);

  //Einkauf Bemerkung
  einkaufBemerkung := Trim(edEinkaufBemerkung.Text);

  //Einheit oder neu eingegebene Einheit
  einheit := Trim(cbEinheiten.Text);
  neueEinheit := Trim(edNeueEinheit.Text);


  //Validierungen
  if sku = '' then
  begin
    ShowMessage('Bitte geben Sie die SKU-Nummer ein!');
    Exit;
  end;

  if einkaufswertCent <= 0 then
  begin
    ShowMessage('Bitte geben Sie einen gültigen Einkaufswert ein!');
    Exit;
  end;


  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;

    FDQuery.SQL.Text :=
      'INSERT INTO inventar (' +
      '  Einkaufsdatum, ' +
      '  SKU, ' +
      '  Einkaufswert, ' +
      '  EinkaufBemerkung, ' +
      '  Einheit ' +
      ') VALUES (' +
      '  :EINKAUFSDATUM, ' +
      '  :SKU, ' +
      '  :EINKAUFSWERT, ' +
      '  :EINKAUFBEMERKUNG, ' +
      '  :EINHEIT ' +
      ')';

    fMain.FDConnection1.StartTransaction;
    try
      for i := 1 to menge do
      begin
        FDQuery.ParamByName('EINKAUFSDATUM').AsLargeInt := TSEinkauf;
        FDQuery.ParamByName('SKU').AsString             := sku;
        FDQuery.ParamByName('EINKAUFSWERT').AsLargeInt  := einkaufswertCent;
        FDQuery.ParamByName('EINKAUFBEMERKUNG').AsString:= einkaufBemerkung;

        if(neueEinheit <> '') then
        begin
          AddEinheitIfNotExists(fMain.FDConnection1, edNeueEinheit.Text);
          LoadEinheitenFromDB(fMain.FDConnection1, cbEinheiten);

          FDQuery.ParamByName('EINHEIT').AsString := neueEinheit
        end
        else
          FDQuery.ParamByName('EINHEIT').AsString := einheit;

        FDQuery.ExecSQL;
      end;

      fMain.FDConnection1.Commit;
    except
      on E: Exception do
      begin
        fMain.FDConnection1.Rollback;
        raise;
      end;
    end;
  finally
    FDQuery.Free;
  end;

  // ===== UI aktualisieren =====
  a := fMain.lvInventar.ItemIndex;

  fMain.LoadInventarToListView;

  fMain.lvInventar.ItemIndex := a;
  ScrollToRechnungsNr(fMain.lvInventar, a);


  uMain.ListViewDirty := True;

  Close;
end;









procedure TfEinkauf.edEinkaufswertKeyPress(Sender: TObject; var Key: Char);
begin
// Ziffern erlauben
  if CharInSet(Key, ['0'..'9']) then
    Exit;

  // Komma erlauben (nur einmal)
  if (Key = ',') and (Pos(',', (Sender as TLabeledEdit).Text) = 0) then
    Exit;

  // Backspace erlauben
  if Key = #8 then
    Exit;

  // Enter erlauben
  if Key = #13 then
    Exit;

  if Key = '.' then
  begin
    Key := ',';
    if Pos(',', (Sender as TLabeledEdit).Text) > 0 then
      Key := #0;
    Exit;
  end;

  if (Key = '-') and ((Sender as TLabeledEdit).SelStart = 0)
   and (Pos('-', (Sender as TLabeledEdit).Text) = 0) then
  Exit;

  // Alles andere blockieren
  Key := #0;
end;

procedure TfEinkauf.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    Close;
  end;
end;

procedure TfEinkauf.FormShow(Sender: TObject);
begin
  LoadEinheitenFromDB(fMain.FDConnection1, cbEinheiten);

  edMenge.Text := '1';
  edSKU.Text := GetNextSKU(fMain.FDConnection1, false);
  dtpEinkaufsdatum.Date := now;
  edEinkaufswert.Clear;
  edEinkaufBemerkung.Clear;
  edNeueEinheit.Clear;
  cbEinheiten.ItemIndex := -1;

  edMenge.SetFocus;
end;

procedure TfEinkauf.imgTaschenrechnerClick(Sender: TObject);
begin
  OpenCalculator
end;

procedure TfEinkauf.imgTaschenrechnerMouseEnter(Sender: TObject);
begin
  imgTaschenrechner.Left := imgTaschenrechner.Left + 2;
  imgTaschenrechner.Top := imgTaschenrechner.Top + 2;
end;

procedure TfEinkauf.imgTaschenrechnerMouseLeave(Sender: TObject);
begin
  imgTaschenrechner.Left := imgTaschenrechner.Left - 2;
  imgTaschenrechner.Top := imgTaschenrechner.Top - 2;
end;







end.
