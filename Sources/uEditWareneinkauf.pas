unit uEditWareneinkauf;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls,
  Vcl.ComCtrls, System.Math, System.StrUtils,
  FireDAC.Stan.Param, FireDAC.Phys.SQLite, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Stan.Intf, FireDAC.DApt, Vcl.Imaging.pngimage, DateUtils;

type
  TfEditWareneinkauf = class(TForm)
    Panel1: TPanel;
    Label7: TLabel;
    imgTaschenrechner: TImage;
    pnlVerkauft: TPanel;
    lbVerkauft: TLabel;
    Panel2: TPanel;
    edSKU: TLabeledEdit;
    dtpEinkaufsdatum: TDateTimePicker;
    Label1: TLabel;
    edEinkaufswert: TLabeledEdit;
    edEinkaufBemerkung: TLabeledEdit;
    Label3: TLabel;
    cbEinheiten: TComboBox;
    Label6: TLabel;
    edNeueEinheit: TLabeledEdit;
    edGewicht: TLabeledEdit;
    edKarat: TLabeledEdit;
    Panel3: TPanel;
    btnAbort: TButton;
    btnSave: TButton;
    edArtikelname: TLabeledEdit;
    procedure FormShow(Sender: TObject);
    procedure btnAbortClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure imgTaschenrechnerClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edEinkaufswertExit(Sender: TObject);
    procedure edGewichtExit(Sender: TObject);
  private
    procedure ShowInventarEntryFromDB(const AConnection: TFDConnection);
  public
    ENTRYID: integer;
    { Public-Deklarationen }
  end;

var
  fEditWareneinkauf: TfEditWareneinkauf;
  Verkauft: boolean;
  Verkaufswert, Steuerbetrag: Int64;

implementation

{$R *.dfm}

uses
  uDBFunctions, uFunctions, uMain, uMoneyHelper, uSQLiteDateHelper;



procedure TfEditWareneinkauf.btnAbortClick(Sender: TObject);
begin
  close;
end;





procedure TfEditWareneinkauf.btnSaveClick(Sender: TObject);
var
  FDQuery: TFDQuery;
  sku, einkaufBemerkung, Artikelname, einheit: string;
  einkaufswertCent: Int64;
  karat, gewicht: Integer;
  verkaufswertCent, SteuerbetragCent: Int64;
begin
  // ===== Validierungen =====
  sku := Trim(edSKU.Text);
  if sku = '' then
  begin
    ShowMessage('Bitte geben Sie die SKU-Nummer ein!');
    Exit;
  end;

  einkaufswertCent := DecimalStringToInt100(edEinkaufswert.Text);
  if einkaufswertCent <= 0 then
  begin
    ShowMessage('Bitte geben Sie einen gültigen Einkaufswert ein!');
    Exit;
  end;

  // ===== UI-Werte =====
  einkaufBemerkung := Trim(edEinkaufBemerkung.Text);
  einheit          := Trim(cbEinheiten.Text);
  Artikelname      := Trim(edArtikelname.Text);

  if Trim(edNeueEinheit.Text) <> '' then
    einheit := Trim(edNeueEinheit.Text);

  gewicht := DecimalStringToInt100(edGewicht.Text);

  if Trim(edKarat.Text) = '' then
    karat := 0
  else if not TryStrToInt(Trim(edKarat.Text), karat) then
  begin
    ShowMessage('Ungültiger Karat-Wert!');
    Exit;
  end;

  // ===== Steuer =====
  if Verkauft then
  begin
    verkaufswertCent := Verkaufswert;
    SteuerbetragCent := verkaufswertCent - einkaufswertCent;
  end;

  // Neue Einheit ggf. einmalig anlegen
  if Trim(edNeueEinheit.Text) <> '' then
  begin
    AddEinheitIfNotExists(fMain.FDConnection1, einheit);
    LoadEinheitenFromDB(fMain.FDConnection1, cbEinheiten);
  end;

  // ===== Datenbank =====
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;

    FDQuery.SQL.Text :=
      'UPDATE inventar SET ' +
      'Einkaufsdatum = :EINKAUFSDATUM, ' +
      'SKU = :SKU, ' +
      'Einkaufswert = :EINKAUFSWERT, ' +
      'Artikelname = :ARTIKELNAME, ' +
      'EinkaufBemerkung = :EINKAUFBEMERKUNG, ' +
      'Einheit = :EINHEIT, ' +
      'Gewicht = :GEWICHT, ' +
      'Karat = :KARAT ' +
      IfThen(Verkauft, ', Steuerbetrag = :STEUERBETRAG ', '') +
      'WHERE id = :ID';

    fMain.FDConnection1.StartTransaction;
    try
      FDQuery.ParamByName('ID').AsInteger := ENTRYID;

      SetSQLiteDateParam(FDQuery.ParamByName('EINKAUFSDATUM'), dtpEinkaufsdatum);

      FDQuery.ParamByName('SKU').AsString := sku;
      FDQuery.ParamByName('EINKAUFSWERT').AsLargeInt := einkaufswertCent;
      FDQuery.ParamByName('ARTIKELNAME').AsString := Artikelname;
      FDQuery.ParamByName('EINKAUFBEMERKUNG').AsString := einkaufBemerkung;
      FDQuery.ParamByName('EINHEIT').AsString := einheit;
      FDQuery.ParamByName('GEWICHT').AsInteger := gewicht;
      FDQuery.ParamByName('KARAT').AsInteger := karat;

      if Verkauft then
        FDQuery.ParamByName('STEUERBETRAG').AsLargeInt := SteuerbetragCent;

      FDQuery.ExecSQL;
      fMain.FDConnection1.Commit;
    except
      fMain.FDConnection1.Rollback;
      raise;
    end;
  finally
    FDQuery.Free;
  end;

  // ===== UI =====
  fMain.LoadInventarToListView;
  uMain.ListViewDirty := True;
  Close;
end;










procedure TfEditWareneinkauf.edEinkaufswertExit(Sender: TObject);
var
  Edit: TLabeledEdit;
  WertCent: Int64;
begin
  if not (Sender is TLabeledEdit) then
    Exit;

  Edit := TLabeledEdit(Sender);

  if Trim(Edit.Text) = '' then
    Exit;

  // === Eingabe validieren und in Cent umwandeln ===
  WertCent := DecimalStringToInt100(Edit.Text);

  if WertCent < 0 then
  begin
    ShowMessage('Bitte geben Sie einen gültigen Wert ein.');
    Edit.SetFocus;
    Edit.SelectAll;
    Exit;
  end;

  // === Formatieren für Anzeige ===
  Edit.Text := Int100ToDecimalString(WertCent);
end;





procedure TfEditWareneinkauf.edGewichtExit(Sender: TObject);
var
  Edit: TLabeledEdit;
  WertCent: Int64;
begin
  if not (Sender is TLabeledEdit) then
    Exit;

  Edit := TLabeledEdit(Sender);

  if Trim(Edit.Text) = '' then
    Exit;

  // === Eingabe validieren und in Hundertstel umrechnen ===
  WertCent := DecimalStringToInt100(Edit.Text);

  if WertCent < 0 then
  begin
    ShowMessage('Bitte geben Sie einen gültigen Wert ein.');
    Edit.SetFocus;
    Edit.SelectAll;
    Exit;
  end;

  // === Formatieren auf "0.00" für Anzeige ===
  Edit.Text := Int100ToDecimalString(WertCent);
end;




procedure TfEditWareneinkauf.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    Close;
  end;
end;




procedure TfEditWareneinkauf.FormShow(Sender: TObject);
begin
  LoadEinheitenFromDB(fMain.FDConnection1, cbEinheiten);

  ShowInventarEntryFromDB(fMain.FDConnection1);
end;




procedure TfEditWareneinkauf.imgTaschenrechnerClick(Sender: TObject);
begin
  OpenCalculator
end;




procedure TfEditWareneinkauf.ShowInventarEntryFromDB(const AConnection: TFDConnection);
var
  Q: TFDQuery;
  FVerkaufswert,
  FSteuerbetrag,
  FEinkaufswert,
  FGewicht: TField;
begin
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := AConnection;
    Q.SQL.Text :=
      'SELECT Einkaufsdatum, SKU, Einkaufswert, Artikelname, EinkaufBemerkung, ' +
      'Verkaufsdatum, Verkaufswert, VerkaufBemerkung, Steuerbetrag, ' +
      'RechnungsNr, Einheit, Gewicht, Karat ' +
      'FROM inventar WHERE id = :ID';

    Q.ParamByName('ID').AsInteger := ENTRYID;
    Q.Prepare;
    Q.Open;

    if Q.IsEmpty then
      Exit;

    // Feldreferenzen
    FVerkaufswert := Q.FieldByName('Verkaufswert');
    FSteuerbetrag := Q.FieldByName('Steuerbetrag');
    FEinkaufswert := Q.FieldByName('Einkaufswert');
    FGewicht      := Q.FieldByName('Gewicht');

    // ===== Verkaufsstatus =====
    Verkauft := (not FVerkaufswert.IsNull) and (FVerkaufswert.AsLargeInt > 0);

    if Verkauft then
    begin
      Verkaufswert := FVerkaufswert.AsLargeInt;
      Steuerbetrag := FSteuerbetrag.AsLargeInt;
      pnlVerkauft.Visible := True;
      lbVerkauft.Caption := 'Artikel wurde verkauft, RechnungsNr: ' + Q.FieldByName('RechnungsNr').AsString;
    end
    else
    begin
      Verkaufswert := 0;
      Steuerbetrag := 0;
      pnlVerkauft.Visible := False;
    end;

    // ===== Basisdaten =====
    edSKU.Text := Q.FieldByName('SKU').AsString;
    LoadSQLiteDateToDTP(Q.FieldByName('Einkaufsdatum').AsString, dtpEinkaufsdatum);
    edEinkaufswert.Text := Int100ToDecimalString(FEinkaufswert.AsLargeInt);
    edArtikelname.Text := Q.FieldByName('Artikelname').AsString;
    edEinkaufBemerkung.Text := Q.FieldByName('EinkaufBemerkung').AsString;
    SelectComboBoxItemByText(cbEinheiten, Q.FieldByName('Einheit').AsString);

    // ===== Gewicht =====
    if not FGewicht.IsNull then
      edGewicht.Text := Int100ToDecimalString(FGewicht.AsLargeInt)
    else
      edGewicht.Clear;

    // ===== Karat =====
    edKarat.Text := Q.FieldByName('Karat').AsString;

  finally
    Q.Free;
  end;
end;








end.
