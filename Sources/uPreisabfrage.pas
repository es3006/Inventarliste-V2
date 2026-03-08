unit uPreisabfrage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  FireDAC.Stan.Param, FireDAC.Phys.SQLite, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, System.Generics.Defaults, System.Math,
  FireDAC.Stan.Intf, FireDAC.DApt, Vcl.ComCtrls, Vcl.Mask;


type
  TfPreisabfrage = class(TForm)
    pnlVerkauf: TPanel;
    Label3: TLabel;
    Label2: TLabel;
    Label6: TLabel;
    Bevel1: TBevel;
    edRechnungsNr: TLabeledEdit;
    dtpVerkaufsdatum: TDateTimePicker;
    edVerkaufBemerkung: TLabeledEdit;
    btnVerkaufen: TButton;
    edVerkaufspreis10: TEdit;
    edBesteuernderBetrag10: TEdit;
    edBesteuernderBetrag9: TEdit;
    edBesteuernderBetrag8: TEdit;
    edBesteuernderBetrag7: TEdit;
    edBesteuernderBetrag6: TEdit;
    edBesteuernderBetrag5: TEdit;
    edBesteuernderBetrag4: TEdit;
    edBesteuernderBetrag3: TEdit;
    edBesteuernderBetrag2: TEdit;
    edBesteuernderBetrag1: TEdit;
    edVerkaufspreis1: TEdit;
    edVerkaufspreis2: TEdit;
    edVerkaufspreis3: TEdit;
    edVerkaufspreis4: TEdit;
    edVerkaufspreis5: TEdit;
    edVerkaufspreis6: TEdit;
    edVerkaufspreis7: TEdit;
    edVerkaufspreis8: TEdit;
    edVerkaufspreis9: TEdit;
    pnlEinheitAbfrage: TPanel;
    lbEinkaufspreis: TLabel;
    Label1: TLabel;
    edEKPreis1: TEdit;
    edEKPreis2: TEdit;
    edEKPreis3: TEdit;
    edEKPreis4: TEdit;
    edEKPreis5: TEdit;
    edEKPreis6: TEdit;
    edEKPreis7: TEdit;
    edEKPreis8: TEdit;
    edEKPreis9: TEdit;
    edEKPreis10: TEdit;
    cbEinheit1: TComboBox;
    cbEinheit2: TComboBox;
    cbEinheit3: TComboBox;
    cbEinheit4: TComboBox;
    cbEinheit5: TComboBox;
    cbEinheit6: TComboBox;
    cbEinheit7: TComboBox;
    cbEinheit8: TComboBox;
    cbEinheit9: TComboBox;
    cbEinheit10: TComboBox;
    cbVerkauf: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure cbEinheit1Select(Sender: TObject);
    procedure edEKPreis1Change(Sender: TObject);
    procedure cbVerkaufClick(Sender: TObject);
    procedure edVerkaufspreis1Exit(Sender: TObject);
    procedure edVerkaufspreis1KeyPress(Sender: TObject; var Key: Char);
    procedure btnVerkaufenClick(Sender: TObject);
    procedure FormAfterMonitorDpiChanged(Sender: TObject; OldDPI, NewDPI: Integer);
    procedure FormCreate(Sender: TObject);
  private
    procedure UpdateSize;
    function LoadHighestPurchasePrice(const AConnection: TFDConnection; Einheit: String): string;
    procedure LoadEinheitenFromInventar(const AConnection: TFDConnection; cb: TComboBox);
  public
    { Public-Deklarationen }
  end;





var
  fPreisabfrage: TfPreisabfrage;




implementation

{$R *.dfm}

uses
  uMain, uFunctions, uDBFunctions, uMoneyHelper, uSQLiteDateHelper;





procedure TfPreisabfrage.btnVerkaufenClick(Sender: TObject);
var
  i: Integer;
  Combo: TComboBox;
  edVK, edSteuer: TEdit;
  ID: Integer;
  Q: TFDQuery;
  MissingVK: string;
  AnySelected: Boolean;
begin
  // ==== Prüfen, ob mindestens eine ComboBox ausgewählt wurde ====
  AnySelected := False;
  for i := 1 to 10 do
  begin
    Combo := FindComponent('cbEinheit' + IntToStr(i)) as TComboBox;
    if Assigned(Combo) and (Combo.ItemIndex > 0) then
    begin
      AnySelected := True;
      Break;
    end;
  end;

  if not AnySelected then
  begin
    ShowMessage('Bitte wählen Sie mindestens eine Einheit aus!');
    Exit;
  end;

  // ==== Prüfen, ob zu jeder gewählten Einheit ein Verkaufswert eingegeben wurde ====
  MissingVK := '';
  for i := 1 to 10 do
  begin
    Combo := FindComponent('cbEinheit' + IntToStr(i)) as TComboBox;
    edVK  := FindComponent('edVerkaufspreis' + IntToStr(i)) as TEdit;

    if Assigned(Combo) and (Combo.ItemIndex > 0) then
    begin
      if (edVK = nil) or (Trim(edVK.Text) = '') then
      begin
        if MissingVK <> '' then
          MissingVK := MissingVK + sLineBreak;
        MissingVK := MissingVK + Format('Einheit %d: "%s"', [i, Combo.Text]);
      end;
    end;
  end;

  if MissingVK <> '' then
  begin
    ShowMessage('Bitte geben Sie Verkaufswerte für folgende Einheiten ein:' + sLineBreak + MissingVK);

    // Fokus auf das erste fehlende Feld setzen
    for i := 1 to 10 do
    begin
      Combo := FindComponent('cbEinheit' + IntToStr(i)) as TComboBox;
      edVK  := FindComponent('edVerkaufspreis' + IntToStr(i)) as TEdit;
      if Assigned(Combo) and Assigned(edVK) and (Combo.ItemIndex > 0) and (Trim(edVK.Text) = '') then
      begin
        edVK.SetFocus;
        Break;
      end;
    end;

    Exit; // DB-Update abbrechen
  end;

  // Rechnungsnr prüfen
  if Trim(edRechnungsNr.Text) = '' then
  begin
    ShowMessage('Bitte geben Sie eine Rechnungsnr ein!');
    edRechnungsNr.SetFocus;
    Exit;
  end;

  // Verkaufsdatum prüfen
  if not dtpVerkaufsdatum.Checked then
  begin
    ShowMessage('Bitte wählen Sie ein Verkaufsdatum aus!');
    dtpVerkaufsdatum.SetFocus;
    Exit;
  end;



  // ==== Alles geprüft, nun Datenbank aktualisieren ====
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := fMain.FDConnection1;

    for i := 1 to 10 do
    begin
      Combo    := FindComponent('cbEinheit' + IntToStr(i)) as TComboBox;
      edVK     := FindComponent('edVerkaufspreis' + IntToStr(i)) as TEdit;
      edSteuer := FindComponent('edBesteuernderBetrag' + IntToStr(i)) as TEdit;

      if Assigned(Combo) and (Combo.ItemIndex > 0) then
      begin
        ID := NativeInt(Combo.Items.Objects[Combo.ItemIndex]);

        if ID > 0 then
        begin
          Q.SQL.Text :=
            'UPDATE inventar SET ' +
            'Verkaufsdatum = :vd, ' +
            'Verkaufswert = :vw, ' +
            'VerkaufBemerkung = :vb, ' +
            'Steuerbetrag = :sb, ' +
            'RechnungsNr = :rn ' +
            'WHERE id = :id';

          Q.ParamByName('vd').AsString   := DateTimeToSQLiteDate(dtpVerkaufsdatum.Date);
          Q.ParamByName('vw').AsLargeInt := DecimalStringToInt100(edVK.Text);
          Q.ParamByName('vb').AsString   := edVerkaufBemerkung.Text;
          Q.ParamByName('sb').AsLargeInt := DecimalStringToInt100(edSteuer.Text);
          Q.ParamByName('rn').AsString   := edRechnungsNr.Text;
          Q.ParamByName('id').AsInteger  := ID;

          Q.ExecSQL;
        end;
      end;
    end;

    ShowMessage('Datensätze erfolgreich aktualisiert.');
  finally
    Q.Free;
    close;
  end;
end;





procedure TfPreisabfrage.cbEinheit1Select(Sender: TObject);
var
  Combo: TComboBox;
  Nummer: string;
  Edit: TEdit;
  ID: Integer;
  Q: TFDQuery;
begin
  Combo := Sender as TComboBox;

  // Nummer aus "cbEinheitX" ermitteln
  Nummer := Copy(Combo.Name, Length('cbEinheit') + 1, MaxInt);

  // Zugehöriges Edit suchen
  Edit := FindComponent('edEKPreis' + Nummer) as TEdit;

  if not Assigned(Edit) then
    Exit;

  // Leeres Item gewählt
  if Combo.ItemIndex <= 0 then
  begin
    Edit.Clear;
    Exit;
  end;

  // ID direkt aus der ComboBox holen
  ID := NativeInt(Combo.Items.Objects[Combo.ItemIndex]);

  if ID <= 0 then
  begin
    Edit.Clear;
    Exit;
  end;

  // Einkaufswert über ID laden
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := fMain.FDConnection1;
    Q.SQL.Text := 'SELECT Einkaufswert FROM inventar WHERE id = :id';
    Q.ParamByName('id').AsInteger := ID;
    Q.Open;

    if not Q.IsEmpty then
      Edit.Text := Int100ToDecimalString(Q.FieldByName('Einkaufswert').AsLargeInt)
    else
      Edit.Clear;

  finally
    Q.Free;
  end;
end;





procedure TfPreisabfrage.cbVerkaufClick(Sender: TObject);
begin
  pnlVerkauf.Visible := cbVerkauf.Checked;
  UpdateSize;
end;





procedure TfPreisabfrage.UpdateSize;
var
  W, H: Integer;
begin
  DisableAlign;
  try
    W := pnlEinheitAbfrage.Width;

    if pnlVerkauf.Visible then
      W := W + pnlVerkauf.Width;

    H := pnlEinheitAbfrage.Height;

    if pnlVerkauf.Visible and (pnlVerkauf.Height > H) then
      H := pnlVerkauf.Height;

    ClientWidth  := W;
    ClientHeight := H;
  finally
    EnableAlign;
  end;
end;





procedure TfPreisabfrage.edEKPreis1Change(Sender: TObject);
begin
  if(TEdit(Sender).Text = 'Nicht vorhanden') then
  begin
    TEdit(Sender).Color := clBtnFace;
    TEdit(Sender).Font.Color := clRed;
  end
  else
  begin
    TEdit(Sender).Color := clWindow;
    TEdit(Sender).Font.Color := clBlack;
  end;
end;





procedure TfPreisabfrage.edVerkaufspreis1Exit(Sender: TObject);
var
  Edit: TEdit;
  Nummer: string;
  EinkaufsEdit, DiffEdit: TEdit;
  VerkaufsCent, EinkaufsCent, DiffCent: Int64;
begin
  if not (Sender is TEdit) then Exit;
  Edit := TEdit(Sender);

  if Trim(Edit.Text) = '' then Exit;

  // ===== Validierung =====
  if not IsValidDecimalString(Edit.Text) then
  begin
    ShowMessage('Bitte geben Sie einen gültigen Wert ein.');
    Edit.SetFocus;
    Edit.SelectAll;
    Exit;
  end;

  // ===== Formatierung =====
  Edit.Text := Int100ToDecimalString(DecimalStringToInt100(Edit.Text));

  // ===== Nummer der Zeile ermitteln =====
  Nummer := Copy(Edit.Name, Length('edVerkaufspreis') + 1, MaxInt);

  // ===== Einkaufswert-Edit ermitteln =====
  EinkaufsEdit := FindEditByName(Self, 'edEKPreis' + Nummer);
  if not Assigned(EinkaufsEdit) then Exit;
  if (Trim(EinkaufsEdit.Text) = '') or (Trim(EinkaufsEdit.Text).ToLower = 'nicht vorhanden') then Exit;

  // ===== Diff-Edit ermitteln =====
  DiffEdit := FindEditByName(Self, 'edBesteuernderBetrag' + Nummer);
  if not Assigned(DiffEdit) then Exit;

  // ===== Berechnung =====
  VerkaufsCent := DecimalStringToInt100(Edit.Text);
  EinkaufsCent := DecimalStringToInt100(EinkaufsEdit.Text);
  DiffCent := VerkaufsCent - EinkaufsCent;

  // ===== Ergebnis ins zugehörige Feld =====
  DiffEdit.Text := Int100ToDecimalString(DiffCent);
end;





procedure TfPreisabfrage.edVerkaufspreis1KeyPress(Sender: TObject; var Key: Char);
begin
// Ziffern erlauben
  if CharInSet(Key, ['0'..'9']) then
    Exit;

  // Komma erlauben (nur einmal)
  if (Key = ',') and (Pos(',', (Sender as TEdit).Text) = 0) then
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
    if Pos(',', (Sender as TEdit).Text) > 0 then
      Key := #0;
    Exit;
  end;

  if (Key = '-') and ((Sender as TEdit).SelStart = 0)
   and (Pos('-', (Sender as TEdit).Text) = 0) then
  Exit;

  // Alles andere blockieren
  Key := #0;
end;





procedure TfPreisabfrage.LoadEinheitenFromInventar(const AConnection: TFDConnection; cb: TComboBox);
var
  Q: TFDQuery;
begin
  cb.Items.Clear;

  // Leerer Eintrag (ID = 0)
  cb.Items.AddObject('', TObject(NativeInt(0)));

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := AConnection;

    Q.SQL.Text :=
      'SELECT id, einheit FROM ( ' +
      '  SELECT id, einheit, ' +
      '         ROW_NUMBER() OVER ( ' +
      '           PARTITION BY einheit ' +
      '           ORDER BY Einkaufswert DESC, id DESC ' +
      '         ) AS rn ' +
      '  FROM inventar ' +
      '  WHERE Verkaufsdatum IS NULL ' +
      '    AND (Verkaufswert IS NULL OR Verkaufswert = 0) ' +
      '    AND einheit <> '''' ' +
      ') ' +
      'WHERE rn = 1 ' +
      'ORDER BY einheit';

    Q.Open;

    while not Q.Eof do
    begin
      cb.Items.AddObject(
        Q.FieldByName('einheit').AsString,
        TObject(NativeInt(Q.FieldByName('id').AsInteger))
      );
      Q.Next;
    end;

  finally
    Q.Free;
  end;
end;





procedure TfPreisabfrage.FormAfterMonitorDpiChanged(Sender: TObject; OldDPI, NewDPI: Integer);
begin
  UpdateSize;
end;





procedure TfPreisabfrage.FormCreate(Sender: TObject);
begin
  UpdateSize;
end;





procedure TfPreisabfrage.FormShow(Sender: TObject);
var
  i: Integer;
  ComboArray: array[2..10] of TComboBox;
begin
  ClearLabeledEdits(pnlEinheitAbfrage);
  ClearLabeledEdits(pnlVerkauf);

  cbVerkauf.Checked := false;
  dtpVerkaufsdatum.Date := now;
  dtpVerkaufsdatum.Checked := false;

  //Die jeweils hochpreisigste Einheit die noch nicht verkauft wurde, in ComboBox 1 laden
  LoadEinheitenFromInventar(fMain.FDConnection1, cbEinheit1);

  //Alle weiteren Comboboxen in Array schreiben
  ComboArray[2] := cbEinheit2;
  ComboArray[3] := cbEinheit3;
  ComboArray[4] := cbEinheit4;
  ComboArray[5] := cbEinheit5;
  ComboArray[6] := cbEinheit6;
  ComboArray[7] := cbEinheit7;
  ComboArray[8] := cbEinheit8;
  ComboArray[9] := cbEinheit9;
  ComboArray[10] := cbEinheit10;

  //Alle anderen Comboboxen mit den Werten asu der ersten ComboBox füllen
  for i := 2 to 10 do
    ComboArray[i].Items.Assign(cbEinheit1.Items);
end;





function TfPreisabfrage.LoadHighestPurchasePrice(const AConnection: TFDConnection; Einheit: String): string;
var
  Q: TFDQuery;
  MaxEK: Int64;
begin
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := AConnection;

    // 1️Höchsten Einkaufswert ermitteln
    Q.SQL.Text :=
      'SELECT MAX(Einkaufswert) AS MaxEK ' +
      'FROM inventar ' +
      'WHERE Verkaufsdatum IS NULL ' +
      'AND (Verkaufswert = 0 OR Verkaufswert IS NULL) ' +
      'AND Einheit = :EINHEIT';

    Q.ParamByName('EINHEIT').AsString := Einheit;
    Q.Open;

    if Q.IsEmpty or Q.FieldByName('MaxEK').IsNull then
      Exit('Nicht vorhanden');

    MaxEK := Q.FieldByName('MaxEK').AsLargeInt;
    Q.Close;

    // 2️ID des Datensatzes mit diesem höchsten EK auslesen
    Q.SQL.Text :=
      'SELECT id, Einkaufswert ' +
      'FROM inventar ' +
      'WHERE Verkaufsdatum IS NULL ' +
      'AND (Verkaufswert = 0 OR Verkaufswert IS NULL) ' +
      'AND Einheit = :EINHEIT ' +
      'AND Einkaufswert = :MaxEK ' +
      'ROWS 1';

    Q.ParamByName('EINHEIT').AsString := Einheit;
    Q.ParamByName('MaxEK').AsLargeInt := MaxEK;
    Q.Open;

    if not Q.IsEmpty then
      Result := 'ID: ' + Q.FieldByName('id').AsString +
                ' | EK: ' + Int100ToDecimalString(Q.FieldByName('Einkaufswert').AsLargeInt)
    else
      Result := 'Nicht gefunden';

  finally
    Q.Free;
  end;
end;





end.
