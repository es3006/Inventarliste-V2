unit uEdelmetallsammelverkauf;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls,
  Vcl.ComCtrls, AdvListV, System.Generics.Collections, FireDAC.Stan.Param, FireDAC.Phys.SQLite,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Stan.Intf, FireDAC.DApt;

type
  TfEdelmetallsammelverkauf = class(TForm)
    edRechnungsNr: TLabeledEdit;
    btnSammelVerkauf: TButton;
    edVerkaufswert: TLabeledEdit;
    dtpVerkaufsdatum: TDateTimePicker;
    Label3: TLabel;
    edSummeEinkaufswert: TLabeledEdit;
    Panel1: TPanel;
    lvEdelmetallEinkaeufe: TAdvListView;
    Panel2: TPanel;
    Panel3: TPanel;
    Label1: TLabel;
    edBesteuernderBetrag: TLabeledEdit;
    Label4: TLabel;
    procedure btnSammelVerkaufClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edVerkaufswertKeyPress(Sender: TObject; var Key: Char);
    procedure edVerkaufswertExit(Sender: TObject);
  private
    FAnkaufIDs: TList<Integer>;
    EinkaufswertGesamt: Int64;
    procedure LoadEinkaeufeToListView;
  public
    procedure SetAnkaufIDs(const AIDs: TList<Integer>);
  end;

var
  fEdelmetallsammelverkauf: TfEdelmetallsammelverkauf;

implementation

{$R *.dfm}

uses
  uMoneyHelper, uSQLiteDateHelper, uMain;






procedure TfEdelmetallsammelverkauf.LoadEinkaeufeToListView;
var
  Q: TFDQuery;
  Item: TListItem;
  i: Integer;
  IDList: string;
begin
  lvEdelmetallEinkaeufe.Items.BeginUpdate;
  try
    lvEdelmetallEinkaeufe.Items.Clear;

    // Eingabefelder initialisieren
    edSummeEinkaufswert.Text := '0,00';

    if (FAnkaufIDs = nil) or (FAnkaufIDs.Count = 0) then
      Exit;

    // ID-Liste für IN-Klausel erzeugen
    IDList := '';
    for i := 0 to FAnkaufIDs.Count - 1 do
    begin
      if i > 0 then
        IDList := IDList + ',';
      IDList := IDList + FAnkaufIDs[i].ToString;
    end;

    Q := TFDQuery.Create(nil);
    try
      Q.Connection := fMain.FDConnection1;
      Q.SQL.Text :=
        'SELECT id, SKU, Ankaufsdatum, Ankaufswert, Artikelname, AnkaufBemerkung, Einheit, ' +
        'Karat, Gewicht, Zahlungsart, Versand, Gesamtpreis, Nachname || '', '' || Vorname AS Kundenname, ' +
        '(SELECT SUM(Gesamtpreis) FROM ankaufEdelmetall WHERE id IN (' + IDList + ')) AS SummeGesamt ' +
        'FROM ankaufEdelmetall ' +
        'WHERE id IN (' + IDList + ') ' +
        'ORDER BY Ankaufsdatum DESC';

      Q.Open;

      if not Q.IsEmpty then
      begin
        EinkaufswertGesamt := Q.FieldByName('SummeGesamt').AsLargeInt;
        edSummeEinkaufswert.Text := Int100ToDecimalString(Q.FieldByName('SummeGesamt').AsLargeInt);
      end;


      while not Q.Eof do
      begin
        Item := lvEdelmetallEinkaeufe.Items.Add;
        Item.Caption := Q.FieldByName('id').AsString;
        Item.SubItems.Add(Q.FieldByName('SKU').AsString);
        Item.SubItems.Add(Q.FieldByName('Kundenname').AsString);
        Item.SubItems.Add(SQLiteDateToDisplay(Q.FieldByName('Ankaufsdatum').AsString));
        Item.SubItems.Add(Q.FieldByName('Artikelname').AsString);
        Item.SubItems.Add(Int100ToDecimalString(Q.FieldByName('Ankaufswert').AsLargeInt));
        Item.SubItems.Add(Int100ToDecimalString(Q.FieldByName('Versand').AsLargeInt));
        Item.SubItems.Add(Int100ToDecimalString(Q.FieldByName('Gesamtpreis').AsLargeInt));
        Item.SubItems.Add(Q.FieldByName('Zahlungsart').AsString);
        Item.SubItems.Add(Q.FieldByName('Einheit').AsString);
        Item.SubItems.Add(Q.FieldByName('Karat').AsString);

        if Q.FieldByName('Gewicht').IsNull then
          Item.SubItems.Add('')
        else
          Item.SubItems.Add(
            Int100ToDecimalString(Q.FieldByName('Gewicht').AsLargeInt)
          );

        Q.Next;
      end;

    finally
      Q.Free;
    end;

  finally
    lvEdelmetallEinkaeufe.Items.EndUpdate;
  end;
end;







procedure TfEdelmetallsammelverkauf.edVerkaufswertExit(Sender: TObject);
var
  Edit: TLabeledEdit;
  VerkaufsCent, EinkaufsCent, DiffCent: Int64;
begin
  if not (Sender is TLabeledEdit) then
    Exit;

  Edit := TLabeledEdit(Sender);

  if Trim(Edit.Text) = '' then
    Exit;

  // ===== Validierung mit Helper-Funktion =====
  if not IsValidDecimalString(Edit.Text) then
  begin
    ShowMessage('Bitte geben Sie einen gültigen Wert ein.');
    Edit.SetFocus;
    Edit.SelectAll;
    Exit;
  end;

  // ===== Formatierung mit Helper-Funktion =====
  // Konvertiere zu Int64 und zurück zu String für einheitliche Formatierung
  Edit.Text := Int100ToDecimalString(DecimalStringToInt100(Edit.Text));

  // ===== Berechnung des besteuernden Betrags =====
  if Trim(edVerkaufswert.Text) = '' then Exit;
  if Trim(edSummeEinkaufswert.Text) = '' then Exit;

  VerkaufsCent := DecimalStringToInt100(edVerkaufswert.Text);
  EinkaufsCent := DecimalStringToInt100(edSummeEinkaufswert.Text);

  // IMMER rechnen – negatives Ergebnis ist erlaubt
  DiffCent := VerkaufsCent - EinkaufsCent;

  edBesteuernderBetrag.Text := Int100ToDecimalString(DiffCent);
end;



procedure TfEdelmetallsammelverkauf.edVerkaufswertKeyPress(Sender: TObject; var Key: Char);
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

procedure TfEdelmetallsammelverkauf.FormShow(Sender: TObject);
begin
  LoadEinkaeufeToListView;

  edRechnungsNr.Clear;
  dtpVerkaufsdatum.Date := Date;
  dtpVerkaufsdatum.Checked := false;
  edVerkaufswert.Clear;
  edBesteuernderBetrag.Clear;
end;







procedure TfEdelmetallSammelverkauf.SetAnkaufIDs(const AIDs: TList<Integer>);
begin
  FAnkaufIDs := TList<Integer>.Create;
  FAnkaufIDs.AddRange(AIDs);
end;





procedure TfEdelmetallsammelverkauf.btnSammelVerkaufClick(Sender: TObject);
var
  Q: TFDQuery;
  i: Integer;
  VerkaufswertGesamt, SteuerbetragGesamt: Int64;
  Einkaufssumme: Int64;
  VerkaufID: Int64;
begin
  if(trim(edRechnungsNr.Text) = '') then
  begin
    ShowMessage('Bitte geben Sie eine RechnungsNummer ein!');
    edRechnungsNr.SetFocus;
    Exit;
  end;

  if not dtpVerkaufsdatum.Checked then
  begin
    ShowMessage('Bitte wählen Sie das Verkaufsdatum aus!');
    dtpVerkaufsdatum.SetFocus;
    Exit;
  end;

  if not IsValidDecimalString(edVerkaufswert.Text) then
  begin
    ShowMessage('Ungültiger Verkaufswert.');
    edVerkaufswert.SetFocus;
    edVerkaufswert.SelectAll;
    Exit;
  end;

  VerkaufswertGesamt := DecimalStringToInt100(edVerkaufswert.Text);
  SteuerbetragGesamt := DecimalStringToInt100(edBesteuernderBetrag.Text);

  fMain.FDConnection1.StartTransaction;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := fMain.FDConnection1;

    {-------------------------------------
      1️Einkaufssumme berechnen
    -------------------------------------}
    Einkaufssumme := 0;
    Q.SQL.Text := 'SELECT Ankaufswert FROM ankaufEdelmetall WHERE id = :ID';
    for i := 0 to FAnkaufIDs.Count - 1 do
    begin
      Q.ParamByName('ID').AsInteger := FAnkaufIDs[i];
      Q.Open;
      Einkaufssumme := Einkaufssumme + Q.FieldByName('Ankaufswert').AsLargeInt;
      Q.Close;
    end;

    {-------------------------------------
      2️Sammelverkauf erzeugen
    -------------------------------------}
    Q.SQL.Text :=
      'INSERT INTO verkaufEdelmetall ' +
      '(RechnungsNr, Verkaufsdatum, Verkaufswert, Steuerbetrag) ' +
      'VALUES (:Rechnung, :Datum, :Verkaufswert, :Steuerbetrag)';

    Q.ParamByName('Rechnung').AsString := edRechnungsNr.Text;
    Q.ParamByName('Datum').AsString := DateTimeToSQLiteDate(dtpVerkaufsdatum.Date);
    Q.ParamByName('Verkaufswert').AsLargeInt := VerkaufswertGesamt;
    Q.ParamByName('Steuerbetrag').AsLargeInt := SteuerbetragGesamt;

    Q.ExecSQL;

    {-------------------------------------
      3️Neue VerkaufID holen (SQLite-sicher)
    -------------------------------------}
    VerkaufID := Q.Connection.ExecSQLScalar('SELECT last_insert_rowid()');

    {-------------------------------------
      4️Alle Ankäufe diesem Verkauf zuordnen
    -------------------------------------}
    Q.SQL.Text := 'UPDATE ankaufEdelmetall SET verkaufID = :VerkaufID WHERE id = :ID';
    for i := 0 to FAnkaufIDs.Count - 1 do
    begin
      Q.ParamByName('VerkaufID').AsLargeInt := VerkaufID;
      Q.ParamByName('ID').AsInteger := FAnkaufIDs[i];
      Q.ExecSQL;
    end;

    fMain.FDConnection1.Commit;

    fMain.cbCheckUncheckAll.Checked := false;


    ModalResult := mrOk;

  except
    fMain.FDConnection1.Rollback;
    raise;
  end;

  Q.Free;
end;






end.
