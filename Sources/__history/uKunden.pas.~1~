unit uKunden;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls,
  Vcl.ComCtrls, AdvListV, System.UITypes,
  FireDAC.Stan.Param, FireDAC.Phys.SQLite, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Stan.Intf, FireDAC.DApt, DateUtils, System.Actions, Vcl.ActnList,
  Vcl.Menus;

type
  TfKunden = class(TForm)
    Panel1: TPanel;
    Label7: TLabel;
    lvKunden: TAdvListView;
    pnlKundendaten: TPanel;
    edKundenNr: TLabeledEdit;
    edNachname: TLabeledEdit;
    edVorname: TLabeledEdit;
    edStrasseHausNr: TLabeledEdit;
    edPLZ: TLabeledEdit;
    edWohnort: TLabeledEdit;
    edTelefon: TLabeledEdit;
    edHandy: TLabeledEdit;
    edEmail: TLabeledEdit;
    edAusweisNr: TLabeledEdit;
    dtpGeburtsdatum: TDateTimePicker;
    Label1: TLabel;
    btnSave: TButton;
    PopupMenu1: TPopupMenu;
    Eintraglschen1: TMenuItem;
    ActionList1: TActionList;
    acDeleteEntry: TAction;
    procedure FormShow(Sender: TObject);
    procedure lvKundenClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure acDeleteEntryUpdate(Sender: TObject);
    procedure acDeleteEntryExecute(Sender: TObject);
    procedure lvKundenSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    procedure LoadKundenToListView(const AConnection: TFDConnection);
  public
    { Public-Deklarationen }
  end;

var
  fKunden: TfKunden;
  SELECTEDKUNDENID: integer;

implementation

{$R *.dfm}

uses
  uMain, uDBFunctions;



procedure TfKunden.acDeleteEntryExecute(Sender: TObject);
var
  Idx: Integer;
  ENTRYID: Integer;
begin
  Idx := lvKunden.ItemIndex;
  if Idx = -1 then
    Exit;

  ENTRYID := StrToIntDef(lvKunden.Items[Idx].Caption, 0);
  if ENTRYID = 0 then
    Exit;

  if MessageDlg('Wollen Sie diesen Eintrag wirklich löschen?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  // 1 Aus der Datenbanktabelle Kundenankaeufe löschen
  DeleteEntryFromKunden(fMain.FDConnection1, ENTRYID);

  // 2 Eintrag aus der ListView entfernen
  lvKunden.Items[Idx].Delete;

  // 3 Nächsten Eintrag automatisch selektieren
  if lvKunden.Items.Count > 0 then
  begin
    if Idx < lvKunden.Items.Count then
      lvKunden.Items[Idx].Selected := True
    else
      lvKunden.Items[lvKunden.Items.Count - 1].Selected := True;
  end;
end;






procedure TfKunden.acDeleteEntryUpdate(Sender: TObject);
var
  i: integer;
begin
  i := lvKunden.ItemIndex;
  if(i<>-1) then
  begin
    acDeleteEntry.Enabled := true;
  end
  else
  begin
    acDeleteEntry.Enabled := false;
  end;
end;





procedure TfKunden.btnSaveClick(Sender: TObject);
var
  i: integer;
  kundennr, nachname, vorname, strasse: string;
  plz, ort, tel, handy, email, ausweisnr: string;
  TSGeburtsdatum: Int64;
  FDQuery: TFDQuery;
begin
  // ===== Validierungen =====
  i := lvKunden.ItemIndex;
  if i = -1 then
  begin
    showmessage('Bitte wählen Sie einen Kunden aus der Liste aus!');
    exit;
  end;

  if Trim(edKundenNr.Text) = '' then
  begin
    ShowMessage('Bitte geben Sie eine KundenNr ein!');
    Exit;
  end;

  if Trim(edNachname.Text) = '' then
  begin
    ShowMessage('Bitte geben Sie einen Nachnamen ein!');
    Exit;
  end;

  if Trim(edVorname.Text) = '' then
  begin
    ShowMessage('Bitte geben Sie einen Vornamen ein!');
    Exit;
  end;




  // ===== Werte übernehmen =====
  kundennr          := Trim(edKundenNr.Text);
  nachname := Trim(edNachname.Text);
  vorname := Trim(edVorname.Text);
  strasse := Trim(edStrasseHausNr.Text);
  plz := Trim(edPLZ.Text);
  ort := Trim(edWohnort.Text);
  tel := Trim(edTelefon.Text);
  handy := Trim(edHandy.Text);
  email := Trim(edEmail.Text);
  ausweisnr := Trim(edAusweisNr.Text);

  if dtpGeburtsdatum.Checked then
    TSGeburtsdatum := DateTimeToUnix(dtpGeburtsdatum.Date)
  else
    TSGeburtsdatum := 0;

  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;

    FDQuery.SQL.Text :=
      'UPDATE kundendaten ' +
      'SET kundenNr = :KUNDENNR, ' +
      'Nachname = :NACHNAME, ' +
      'Vorname = :VORNAME, ' +
      'StrasseHausNr = :STRASSE, ' +
      'PLZ = :PLZ, ' +
      'Ort = :ORT, ' +
      'Telefon = :TELEFON, ' +
      'Handy = :HANDY, ' +
      'Email = :EMAIL, ' +
      'AusweisNr = :AUSWEISNR, ' +
      'Geburtsdatum = :GEBURTSDATUM ' +
      'WHERE id = :ID';

    fMain.FDConnection1.StartTransaction;
    try
      FDQuery.ParamByName('ID').AsInteger := SELECTEDKUNDENID;
      FDQuery.ParamByName('KUNDENNR').AsString := kundennr;
      FDQuery.ParamByName('NACHNAME').AsString := nachname;
      FDQuery.ParamByName('VORNAME').AsString := vorname;
      FDQuery.ParamByName('STRASSE').AsString := strasse;
      FDQuery.ParamByName('PLZ').AsString := plz;
      FDQuery.ParamByName('ORT').AsString := ort;
      FDQuery.ParamByName('TELEFON').AsString := tel;
      FDQuery.ParamByName('HANDY').AsString := handy;
      FDQuery.ParamByName('EMAIL').AsString := email;
      FDQuery.ParamByName('AUSWEISNR').AsString := ausweisnr;
      FDQuery.ParamByName('GEBURTSDATUM').AsLargeInt := TSGeburtsdatum;

      FDQuery.ExecSQL;
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
  lvKunden.Items[i].SubItems[0] := kundennr;
  lvKunden.Items[i].SubItems[1] := nachname;
  lvKunden.Items[i].SubItems[2] := vorname;
  lvKunden.Items[i].SubItems[3] := strasse;
  lvKunden.Items[i].SubItems[4] := plz;
  lvKunden.Items[i].SubItems[5] := ort;
  lvKunden.Items[i].SubItems[6] := tel;
  lvKunden.Items[i].SubItems[7] := handy;
  lvKunden.Items[i].SubItems[8] := email;
  lvKunden.Items[i].SubItems[9] := ausweisnr;

  if(dtpGeburtsdatum.Checked) then
    lvKunden.Items[i].SubItems[10] := DateToStr(dtpGeburtsdatum.Date)
  else
    lvKunden.Items[i].SubItems[10] := '';
end;




procedure TfKunden.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    Close;
  end;
end;

procedure TfKunden.FormShow(Sender: TObject);
begin
  LoadKundenToListView(fMain.FDConnection1);
  pnlKundendaten.Visible := false;
  SELECTEDKUNDENID := 0;
end;




procedure TfKunden.LoadKundenToListView(const AConnection: TFDConnection);
var
  Q: TFDQuery;
  Item: TListItem;
  DT: TDateTime;
begin
  lvKunden.Items.BeginUpdate;
  try
    lvKunden.Items.Clear;

    Q := TFDQuery.Create(nil);
    try
      Q.Connection := AConnection;
      Q.SQL.Text :=
        'SELECT id, KundenNr, Nachname, Vorname, StrasseHausNr, ' +
               'PLZ, Ort, Telefon, Handy, ' +
               'Email, AusweisNr, Geburtsdatum ' +
               'FROM kundendaten ORDER BY Nachname ASC';
      Q.Open;

      while not Q.Eof do
      begin
        Item := lvKunden.Items.Add;
        Item.Caption := Q.FieldByName('id').AsString;
        Item.SubItems.Add(Q.FieldByName('KundenNr').AsString);
        Item.SubItems.Add(Q.FieldByName('Nachname').AsString);
        Item.SubItems.Add(Q.FieldByName('Vorname').AsString);
        Item.SubItems.Add(Q.FieldByName('StrasseHausNr').AsString);
        Item.SubItems.Add(Q.FieldByName('PLZ').AsString);
        Item.SubItems.Add(Q.FieldByName('Ort').AsString);
        Item.SubItems.Add(Q.FieldByName('Telefon').AsString);
        Item.SubItems.Add(Q.FieldByName('Handy').AsString);
        Item.SubItems.Add(Q.FieldByName('Email').AsString);
        Item.SubItems.Add(Q.FieldByName('Ausweisnr').AsString);

        // === Geburtsdatum ===
        if(Q.FieldByName('Geburtsdatum').AsLargeInt > 0) then
        begin
          DT := UnixToDateTime(Q.FieldByName('Geburtsdatum').AsLargeInt);
          Item.SubItems.Add(FormatDateTime('dd.mm.yyyy', DT));
        end
        else
        begin
          Item.SubItems.Add('');
        end;
        Q.Next;
      end;
    finally
      Q.Free;
    end;
  finally
    lvKunden.Items.EndUpdate;
  end;
end;





procedure TfKunden.lvKundenClick(Sender: TObject);
var
  i: integer;
begin
  i := lvKunden.ItemIndex;

  if(i <> -1) then
  begin
    pnlKundendaten.Visible := true;
    SELECTEDKUNDENID := StrToInt(lvKunden.Items[i].Caption);

    edKundenNr.Text := lvKunden.Items[i].SubItems[0];
    edNachname.Text := lvKunden.Items[i].SubItems[1];
    edVorname.Text := lvKunden.Items[i].SubItems[2];
    edStrasseHausNr.Text := lvKunden.Items[i].SubItems[3];
    edPLZ.Text := lvKunden.Items[i].SubItems[4];
    edWohnort.Text := lvKunden.Items[i].SubItems[5];
    edTelefon.Text := lvKunden.Items[i].SubItems[6];
    edHandy.Text := lvKunden.Items[i].SubItems[7];
    edEmail.Text := lvKunden.Items[i].SubItems[8];
    edAusweisNr.Text := lvKunden.Items[i].SubItems[9];

    if lvKunden.Items[i].SubItems[10] <> '' then
    begin
      dtpGeburtsdatum.Date := StrToDate(lvKunden.Items[i].SubItems[10]);
      dtpGeburtsdatum.Checked := True;
    end
    else
      dtpGeburtsdatum.Checked := False;

  end
  else
  begin
    pnlKundendaten.Visible := false;
    SELECTEDKUNDENID := 0;
  end;
end;

procedure TfKunden.lvKundenSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
var
  i: integer;
begin
  i := lvKunden.ItemIndex;
  if(i <> -1) then
  begin
    lvKundenClick(nil);
  end;
end;





end.
