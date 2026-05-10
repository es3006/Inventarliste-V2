unit uAnkaufformular;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Mask, AdvPageControl, StrUtils, System.IOUtils,
  FireDAC.Stan.Param, FireDAC.Phys.SQLite, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  System.Generics.Defaults, FireDAC.Stan.Intf, FireDAC.DApt, DateUtils, Vcl.Buttons, ShellApi,
  AdvListV;

type
  TfAnkaufformular = class(TForm)
    Panel4: TPanel;
    edVorname: TLabeledEdit;
    edNachname: TLabeledEdit;
    edStrasseHausNr: TLabeledEdit;
    edPLZ: TLabeledEdit;
    edWohnort: TLabeledEdit;
    edTelefon: TLabeledEdit;
    edEmail: TLabeledEdit;
    PageControlArtikel: TAdvPageControl;
    AdvTabSheet2: TAdvTabSheet;
    AdvTabSheet3: TAdvTabSheet;
    Panel3: TPanel;
    pnlUhr: TPanel;
    Label9: TLabel;
    Bevel1: TBevel;
    edMarke: TLabeledEdit;
    edModel: TLabeledEdit;
    edJahr: TLabeledEdit;
    cbBox: TCheckBox;
    cbPapiere: TCheckBox;
    cbZustand: TComboBox;
    pnlVerkaufsdaten: TPanel;
    Label3: TLabel;
    edGewicht: TLabeledEdit;
    edKarat: TLabeledEdit;
    edArtikelname: TLabeledEdit;
    edAnkaufspreis: TLabeledEdit;
    edEinkaufBemerkung: TLabeledEdit;
    cbEinheiten: TComboBox;
    pnlVerkaufDefault: TPanel;
    Bevel3: TBevel;
    Label4: TLabel;
    rbUhr: TRadioButton;
    rbSchmuck: TRadioButton;
    cbZahlungsarten: TComboBox;
    edVersand: TLabeledEdit;
    Label10: TLabel;
    edGesamtbetrag: TLabeledEdit;
    btnAddNewItem: TButton;
    lvAnkaufartikel: TAdvListView;
    btnKaufBeenden: TButton;
    edSKU: TLabeledEdit;
    sbNextSKU: TSpeedButton;
    dtpAnkaufsdatum: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    edReferenz: TLabeledEdit;
    rbEdelmetallSammelverkauf: TRadioButton;
    rbAddToInventarliste: TRadioButton;
    btnAnkaufBeenden: TButton;
    Label5: TLabel;
    procedure FormShow(Sender: TObject);
    procedure cbZustandSelect(Sender: TObject);
    procedure cbZahlungsartenSelect(Sender: TObject);
    procedure edNachnameKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edAnkaufspreisKeyPress(Sender: TObject; var Key: Char);
    procedure edPLZKeyPress(Sender: TObject; var Key: Char);
    procedure edTelefonKeyPress(Sender: TObject; var Key: Char);
    procedure sbNextSKUClick(Sender: TObject);
    procedure AdvPageControl1CanChange(Sender: TObject; FromPage, ToPage: Integer; var AllowChange: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure rbUhrClick(Sender: TObject);
    procedure rbSchmuckClick(Sender: TObject);
    procedure edGewichtExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnKaufBeendenClick(Sender: TObject);
    procedure btnAddNewItemClick(Sender: TObject);
    procedure rbAddToInventarlisteClick(Sender: TObject);
    procedure btnAnkaufBeendenClick(Sender: TObject);
  private
    function GetNextSKUFromListView(lv: TListView; art: string): string;
    procedure CreateAnkaufsformularAsPDF;
    procedure CreateAnkaufsformularEdelmetalleAsPDF(const Pfad: string);
    procedure CreateAnkaufsformularInventarAsPDF(const Pfad: string);
    procedure InsertDataInInventar(Item: TListItem; VersandAnteil: Int64);
    procedure InsertDataInAnkaufEdelmetall(Item: TListItem; VersandAnteil: Int64);
    procedure RecalcGesamtbetrag;
    procedure edVersandExit(Sender: TObject);
  public
    { Public-Deklarationen }
  end;

var
  fAnkaufformular: TfAnkaufformular;
  KUNDENID: int64;
  SELZUSTAND, SELZAHLUNGSART: integer;
  KUNDENNR: string;
  NEUERKUNDE, KUNDENDATENEDITED: boolean;
  Ankaufformular_LastID: integer;



implementation

{$R *.dfm}

uses
  uMain, uFunctions, uDBFunctions, uMoneyHelper, uSQLiteDateHelper;



function TfAnkaufformular.GetNextSKUFromListView(lv: TListView; art: string): string;
var
  i, num: Integer;
  prefix, value: string;
begin
  Result := '';

  if art = 'inventar' then
    prefix := 'AK'
  else
    prefix := 'EM';

  for i := lv.Items.Count - 1 downto 0 do
  begin
    if lv.Items[i].SubItems.Count > 0 then
    begin
      value := lv.Items[i].SubItems[0];

      if value.StartsWith(prefix) then
      begin
        num := StrToIntDef(Copy(value, 3, MaxInt), 0);
        Inc(num);
        Result := prefix + Format('%.6d', [num]);
        Exit;
      end;
    end;
  end;
end;





procedure TfAnkaufformular.AdvPageControl1CanChange(Sender: TObject; FromPage, ToPage: Integer; var AllowChange: Boolean);
begin
 if(KUNDENID <= 0) then
 begin
   showmessage('Bitte geben Sie zuerst die Kundendaten ein' + sLineBreak + 'und klicken Sie anschließend auf den Buttonn "Speichern und Weiter"');
   AllowChange := false;
 end;
end;




procedure TfAnkaufformular.btnAddNewItemClick(Sender: TObject);
var
  Item: TListItem;
  sku, art, prefix: string;
begin
  if(Trim(edNachname.Text) = '') AND (Trim(edVorname.Text) = '') then
  begin
    if MessageDlg('Sie haben keinen Kundennammen eingegeben. Dieser sollte eingegeben werden damit das Ankaufsformular anständig erzeugt werden kann.' + sLineBreak + sLineBreak + 'Wollen Sie den Namen des Kunden jetzt eingeben?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      edNachname.SetFocus;
      exit;
    end
    else
    begin
      exit;
    end;
  end;

  if TrimEdit(edArtikelname) = '' then
  begin
    ShowMessage('Bitte geben Sie einen Artikelnamen ein!');
    edArtikelname.SetFocus;
    Exit;
  end;

  if TrimEdit(edAnkaufspreis) = '' then
  begin
    ShowMessage('Bitte den Ankaufspreis eingeben!');
    edAnkaufspreis.SetFocus;
    Exit;
  end;

  if not (rbEdelmetallSammelverkauf.Checked) AND not (rbAddToInventarliste.Checked) then
  begin
    ShowMessage('Bitte geben Sie an, ob Sie den Artikel in die Inventarliste aufnehmen oder für den Edelmetall Sammelverkauf markieren wollen!');
    Exit;
  end;


  if(rbEdelmetallSammelverkauf.Checked) then
  begin
    if(trim(edArtikelname.Text) = '') then
    begin
      edArtikelname.Text := 'Edelmetall';
    end;

    if(trim(edGewicht.Text) = '') then
    begin
      showmessage('Bitte geben Sie das Gewicht ein!');
      edGewicht.SetFocus;
      exit;
    end;

    if(Trim(edKarat.Text) = '') then
    begin
      showmessage('Bitte geben Sie die Karat-Zahl an!');
      edKarat.SetFocus;
      exit;
    end;
  end;

  //nächste SKU ermitteln
 if rbAddToInventarliste.Checked then
  begin
    art := 'inventar';
    prefix := 'AK';
  end
  else
  begin
    art := 'edelmetall';
    prefix := 'EM';
  end;

  // zuerst versuchen aus der ListView zu ermitteln
  sku := GetNextSKUFromListView(lvAnkaufartikel, art);

  // wenn nichts gefunden wurde -> Datenbank
  if Trim(sku) = '' then
  begin
    if art = 'inventar' then
      sku := GetNextSKUFromTable(fMain.FDConnection1, 'inventar', prefix, 6)
    else
      sku := GetNextSKUFromTable(fMain.FDConnection1, 'ankaufEdelmetall', prefix, 6);
  end;

  if Trim(sku) = '' then
    edSKU.Text := STARTSKU_ANKAUF
  else
    edSKU.Text := Trim(sku);

  //Artikel in ListView einfügen
  lvAnkaufArtikel.Items.BeginUpdate;
  try
    Item := lvAnkaufArtikel.Items.Add;

    Item.Caption := art;
    Item.SubItems.Add(sku);
    Item.SubItems.Add(trim(edArtikelname.Text));
    Item.SubItems.Add(trim(edEinkaufBemerkung.Text));
    Item.SubItems.Add(trim(cbEinheiten.Text));
    Item.SubItems.Add(trim(edGewicht.Text));
    Item.SubItems.Add(trim(edKarat.Text));
    Item.SubItems.Add(trim(edAnkaufspreis.Text));
    Item.SubItems.Add(trim(edMarke.Text));
    Item.SubItems.Add(trim(edModel.Text));
    Item.SubItems.Add(trim(edJahr.Text));
    Item.SubItems.Add(trim(cbZustand.Text));
    Item.SubItems.Add(trim(edReferenz.Text));
    Item.SubItems.Add(IntToStr(ord(cbBox.checked)));
    Item.SubItems.Add(IntToStr(ord(cbPapiere.checked)));
  finally
    lvAnkaufArtikel.Items.EndUpdate;
  end;

  // Gesamtbetrag nach Hinzufügen neu berechnen
  RecalcGesamtbetrag;

  //Aufräumen
  rbSchmuck.Checked := true;

  ClearLabeledEdits(pnlUhr);
  ClearLabeledEdits(pnlVerkaufsdaten);

  cbZustand.ItemIndex := -1;
  cbBox.Checked := false;
  cbPapiere.Checked := false;
  cbZustand.ItemIndex := -1;
  cbEinheiten.ItemIndex := -1;

  rbAddToInventarliste.Checked := false;
  rbEdelmetallSammelverkauf.Checked := false;
end;





procedure TfAnkaufformular.btnAnkaufBeendenClick(Sender: TObject);
var
  i: integer;
  item: TListItem;
  TotalVersand, Versand, AktuellerPreis, TeuersterPreis: Int64;
  TeuersterIdx: Integer;
  HatInventar: Boolean;
begin
  if TrimEdit(edNachname) = '' then
  begin
    ShowMessage('Bitte geben Sie den Nachnamen des Verkäufers ein!');
    edNachname.SetFocus;
    Exit;
  end;

  if TrimEdit(edNachname) = '' then
  begin
    ShowMessage('Bitte geben Sie den Vornamen des Verkäufers ein!');
    edNachname.SetFocus;
    Exit;
  end;

  if(lvAnkaufartikel.Items.Count <= 0) then
  begin
    showmessage('Sie haben keine anzukaufenden Artikel eingegeben!');
    PageControlArtikel.ActivePageIndex := 0;
    exit;
  end;

{=======================
  ZAHLUNGSART
=======================}
  if(cbZahlungsarten.ItemIndex < 0) then
  begin
    showmessage('Bitte wählen Sie eine Zahlungsart aus');
    cbZahlungsarten.SetFocus;
    exit;
  end;

{======================
  Gesamtbetrag
======================}
  if (Trim(edGesamtbetrag.Text) <> '') and not IsValidDecimalString(edGesamtbetrag.Text) then
  begin
    ShowMessage('Ungültiger Gesamtbetrag! Bitte verwenden Sie das Format: 12,50');
    edGesamtbetrag.SetFocus;
    Exit;
  end;


{======================
  ARTIKEL SPEICHERN
======================}
  TotalVersand := DecimalStringToInt100(edVersand.Text);

  // Versandkosten dem hochpreisigsten Artikel zuweisen.
  // Priorität: teuerster inventar-Artikel; gibt es keinen → teuerster edelmetall-Artikel.
  HatInventar := false;

  //Prüfen ob der Eintrag im Inventar erscheinen soll
  for i := 0 to lvAnkaufartikel.Items.Count - 1 do
  begin
    if lvAnkaufartikel.Items[i].Caption = 'inventar' then
    begin
      HatInventar := true;
      Break;
    end;
  end;

  TeuersterIdx   := -1;
  TeuersterPreis := -1;

  //Alle Artikel in der Liste durchgehen
  for i := 0 to lvAnkaufartikel.Items.Count - 1 do
  begin
    item := lvAnkaufartikel.Items[i];

    if HatInventar and (item.Caption <> 'inventar') then
      Continue;

    if (not HatInventar) and (item.Caption <> 'edelmetall') then
      Continue;

    AktuellerPreis := DecimalStringToInt100(item.SubItems[6]);

    if AktuellerPreis > TeuersterPreis then
    begin
      TeuersterPreis := AktuellerPreis;
      TeuersterIdx   := i;
    end;
  end;

  for i := 0 to lvAnkaufartikel.Items.Count - 1 do
  begin
    if i = TeuersterIdx then
      Versand := TotalVersand
    else
      Versand := 0;

    item := lvAnkaufartikel.Items[i];

    if item.Caption = 'inventar' then
    begin
      InsertDataInInventar(item, Versand)
    end
    else if item.Caption = 'edelmetall' then
    begin
      InsertDataInAnkaufEdelmetall(item, Versand);
    end;
  end;

  ShowMessage('Ankauf wurde erfolgreich gespeichert!');

  // PDF-Formulare erzeugen
  for i := 0 to lvAnkaufartikel.Items.Count - 1 do
  begin
    if lvAnkaufartikel.Items[i].Caption = 'edelmetall' then
    begin
      CreateAnkaufsformularEdelmetalleAsPDF(PATHANKAUFSFORMULARE);
      Break;
    end;
  end;

  for i := 0 to lvAnkaufartikel.Items.Count - 1 do
  begin
    if lvAnkaufartikel.Items[i].Caption = 'inventar' then
    begin
      CreateAnkaufsformularInventarAsPDF(PATHANKAUFSFORMULARE);
      Break;
    end;
  end;

  Close;
end;




procedure TfAnkaufformular.btnKaufBeendenClick(Sender: TObject);
begin
  PageControlArtikel.ActivePageIndex := 1;
end;






procedure TfAnkaufformular.InsertDataInInventar(Item: TListItem; VersandAnteil: Int64);
var
  Q: TFDQuery;
  Ankaufspreis, Versandpreis: Int64;
  Jahr, Box, Papiere, Karat: Integer;
  SKU, Artikelname, Ref, Einheit, Marke, Model, Bemerkung, Zustand, Zahlungsart: string;
  GewichtInt: Integer;
begin
  // ===== Werte aus ListView-Eintrag lesen =====
  SKU          := Item.SubItems[0];
  Artikelname  := Item.SubItems[1];
  Bemerkung    := Item.SubItems[2];
  Einheit      := Item.SubItems[3];
  GewichtInt   := DecimalStringToInt100(Item.SubItems[4]);
  Karat        := StrToIntDef(Item.SubItems[5], 0);
  Ankaufspreis := DecimalStringToInt100(Item.SubItems[6]);
  Marke        := Item.SubItems[7];
  Model        := Item.SubItems[8];
  Jahr         := StrToIntDef(Item.SubItems[9], 0);
  Zustand      := Item.SubItems[10];
  Ref          := Item.SubItems[11];
  Box          := StrToIntDef(Item.SubItems[12], 0);
  Papiere      := StrToIntDef(Item.SubItems[13], 0);

  // ===== Formular-Werte (gelten für alle Artikel der Sitzung) =====
  Versandpreis := VersandAnteil;
  Zahlungsart  := cbZahlungsarten.Text;

  if(Versandpreis <> 0) then
  begin
    Ankaufspreis := Ankaufspreis + Versandpreis;
    if(Trim(Bemerkung) <> '') then
    begin
      Bemerkung := Bemerkung + ' enthält ' + Int100ToDecimalString(Versandpreis) + ' Euro Versandkosten';
    end
    else
    begin
      Bemerkung := 'enthält ' + Int100ToDecimalString(Versandpreis) + ' Euro Versandkosten';
    end;
  end;

  // ===== Datenbank =====
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := fMain.FDConnection1;

    Q.SQL.Text :=
      'INSERT INTO inventar ' +
      '(Einkaufsdatum, Artikelname, SKU, Einkaufswert, EinkaufBemerkung, Einheit, Gewicht, ' +
      'Karat, kundenID, Ref, Box, Papiere, Marke, Model, Jahr, Zustand, ' +
      'Versand, Zahlungsart, Nachname, Vorname, StrasseHausNr, PLZ, Ort, Telefon, Email) ' +
      'VALUES (:DAT, :ARTN, :SKU, :KP, :EKBEM, :EINH, :GEW, :KAR, :KD, :REF, :BOX, ' +
      ':PAP, :MAR, :MOD, :JAHR, :ZUST, :VERS, :ZAHL, :NACH, :VOR, :STR, :PLZ, :ORT, :TEL, :MAIL)';

    fMain.FDConnection1.StartTransaction;
    try
      // Datum nur noch über Helper
      SetSQLiteDateParam(Q.ParamByName('DAT'), dtpAnkaufsdatum);

      Q.ParamByName('SKU').AsString    := SKU;
      Q.ParamByName('ARTN').AsString   := Artikelname;
      Q.ParamByName('KP').AsLargeInt   := Ankaufspreis;
      Q.ParamByName('EKBEM').AsString  := Bemerkung;
      Q.ParamByName('EINH').AsString   := Einheit;
      Q.ParamByName('GEW').AsInteger   := GewichtInt;
      Q.ParamByName('KAR').AsInteger   := Karat;
      Q.ParamByName('KD').AsInteger    := KUNDENID;
      Q.ParamByName('REF').AsString    := Ref;
      Q.ParamByName('BOX').AsInteger   := Box;
      Q.ParamByName('PAP').AsInteger   := Papiere;
      Q.ParamByName('MAR').AsString    := Marke;
      Q.ParamByName('MOD').AsString    := Model;
      Q.ParamByName('JAHR').AsInteger  := Jahr;
      Q.ParamByName('ZUST').AsString   := Zustand;
      Q.ParamByName('VERS').AsLargeInt := Versandpreis;
      Q.ParamByName('ZAHL').AsString   := Zahlungsart;

      Q.ParamByName('NACH').AsString := TrimEdit(edNachname);
      Q.ParamByName('VOR').AsString  := TrimEdit(edVorname);
      Q.ParamByName('STR').AsString  := TrimEdit(edStrasseHausNr);
      Q.ParamByName('PLZ').AsString  := TrimEdit(edPLZ);
      Q.ParamByName('ORT').AsString  := TrimEdit(edWohnort);
      Q.ParamByName('TEL').AsString  := TrimEdit(edTelefon);
      Q.ParamByName('MAIL').AsString := TrimEdit(edEmail);


      Q.ExecSQL;

      // Last Insert ID ermitteln
      Q.SQL.Text := 'SELECT last_insert_rowid()';
      Q.Open;
      Ankaufformular_LastID := Q.Fields[0].AsInteger;
      Q.Close;

      fMain.FDConnection1.Commit;
    except
      fMain.FDConnection1.Rollback;
      raise;
    end;
  finally
    Q.Free;
  end;
end;







procedure TfAnkaufformular.InsertDataInAnkaufEdelmetall(Item: TListItem; VersandAnteil: Int64);
var
  Q: TFDQuery;
  Ankaufspreis, Versandpreis, Gesamtpreis: Int64;
  Karat, Gewicht: Integer;
  SKU, Ref, Artikelname, Bemerkung, Zahlungsart, Einheit: string;
begin
  // ===== Werte aus ListView-Eintrag lesen =====
  SKU          := Item.SubItems[0];
  Artikelname  := Item.SubItems[1];
  Bemerkung    := Item.SubItems[2];
  Einheit      := Item.SubItems[3];
  Gewicht      := DecimalStringToInt100(Item.SubItems[4]);
  Karat        := StrToIntDef(Item.SubItems[5], 0);
  Ankaufspreis := DecimalStringToInt100(Item.SubItems[6]);
  Ref          := Item.SubItems[11];

  // ===== Formular-Werte (gelten für alle Artikel der Sitzung) =====
  Versandpreis := VersandAnteil;
  Zahlungsart  := cbZahlungsarten.Text;
  // Gesamtpreis = Artikelpreis + anteiliger Versand dieses Eintrags
  Gesamtpreis  := Ankaufspreis + VersandAnteil;


  if(Versandpreis <> 0) then
  begin
    Ankaufspreis := Ankaufspreis + Versandpreis;
    if(Trim(Bemerkung) <> '') then
    begin
      Bemerkung := Bemerkung + ' enthält ' + Int100ToDecimalString(Versandpreis) + ' Euro Versandkosten';
    end
    else
    begin
      Bemerkung := 'enthält ' + Int100ToDecimalString(Versandpreis) + ' Euro Versandkosten';
    end;
  end;

  // ===== Datenbank =====
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := fMain.FDConnection1;

    Q.SQL.Text :=
      'INSERT INTO ankaufEdelmetall ' +
      '(SKU, Ref, Ankaufsdatum, Ankaufswert, Artikelname, AnkaufBemerkung, Einheit, ' +
      'Karat, Gewicht, Zahlungsart, Versand, Gesamtpreis, Nachname, Vorname, StrasseHausNr, PLZ, Ort, Telefon, Email) ' +
      'VALUES (:SKU, :REF, :DAT, :KP, :ARTN, :BEM, :EINH, :KAR, :GEW, :ZAHL, :VERS, :GES, :NACH, :VOR, :STR, :PLZ, :ORT, :TEL, :MAIL)';

    fMain.FDConnection1.StartTransaction;
    try
      Q.ParamByName('SKU').AsString    := SKU;
      Q.ParamByName('REF').AsString    := Ref;

      // Datum sauber über Helper
      SetSQLiteDateParam(Q.ParamByName('DAT'), dtpAnkaufsdatum);

      Q.ParamByName('KP').AsLargeInt   := Ankaufspreis;
      Q.ParamByName('ARTN').AsString   := Artikelname;
      Q.ParamByName('BEM').AsString    := Bemerkung;
      Q.ParamByName('EINH').AsString   := Einheit;
      Q.ParamByName('KAR').AsInteger   := Karat;
      Q.ParamByName('GEW').AsInteger   := Gewicht;
      Q.ParamByName('ZAHL').AsString   := Zahlungsart;
      Q.ParamByName('VERS').AsLargeInt := Versandpreis;
      Q.ParamByName('GES').AsLargeInt  := Gesamtpreis;

      Q.ParamByName('NACH').AsString := TrimEdit(edNachname);
      Q.ParamByName('VOR').AsString  := TrimEdit(edVorname);
      Q.ParamByName('STR').AsString  := TrimEdit(edStrasseHausNr);
      Q.ParamByName('PLZ').AsString  := TrimEdit(edPLZ);
      Q.ParamByName('ORT').AsString  := TrimEdit(edWohnort);
      Q.ParamByName('TEL').AsString  := TrimEdit(edTelefon);
      Q.ParamByName('MAIL').AsString := TrimEdit(edEmail);

      Q.ExecSQL;

      // Letzte ID holen
      Q.SQL.Text := 'SELECT last_insert_rowid()';
      Q.Open;
      Ankaufformular_LastID := Q.Fields[0].AsInteger;
      Q.Close;

      fMain.FDConnection1.Commit;
    except
      fMain.FDConnection1.Rollback;
      raise;
    end;
  finally
    Q.Free;
  end;
end;







procedure TfAnkaufformular.CreateAnkaufsformularAsPDF;
var
  stltemp: TStringList;
  i: integer;
  filename, filenameTemp: string;
  stlHtmlHeader, stlHtmlFooter, stlContent: TStringList;
  resHtmlHeader, resHtmlFooter, resContent: TResourceStream;

  nachname, vorname, strassehausnr, plz, ort: string;
  ankaufsnr, ankaufdatum: string;

  ref, box, papiere, marke, model, jahr, kaufbetrag: string;
  s: string;
  zustand, bezeichnung, einheit, gewicht, gesamtbetrag, zahlungsart, sku: string;
  versandbetrag, artikelname, bemerkung: string;
begin
  //kundennr := trim(edKundenNr.Text);
  nachname := trim(edNachname.Text);
  vorname := trim(edVorname.Text);
  strassehausnr := trim(edStrasseHausNr.Text);
  plz := trim(edPLZ.Text);
  ort := trim(edWohnort.Text);
  ankaufsnr := IntToStr(Ankaufformular_LastID);
  ankaufdatum := trim(DateToStr(dtpAnkaufsdatum.Date));

  zustand := trim(cbZustand.Text);
  bemerkung := trim(edEinkaufBemerkung.Text);
  gewicht := trim(edGewicht.Text);
  artikelname := trim(edArtikelname.Text);
  versandbetrag := trim(edVersand.Text);
  gesamtbetrag := trim(edGesamtbetrag.Text);
  zahlungsart := trim(cbZahlungsarten.Text);
  sku := trim(edSKU.Text);

  ref := trim(edReferenz.Text);
  if(cbBox.Checked) then box := 'X' else box := '-';
  if(cbPapiere.Checked) then papiere := 'X' else papiere := '-';
  marke := edMarke.Text;
  model := edModel.Text;

  jahr := edJahr.Text;
  kaufbetrag := edAnkaufspreis.Text;


//Hier nur das was einmal für alle Seiten geladen werden muss (HtmlHeader, HtmlFooter)
  stlTemp := nil;
  try
    stlTemp := TStringList.Create;

//HEADER START
    resHtmlHeader := TResourceStream.Create(HInstance, 'ANKAUFSFORMULAR_HEADER_UHR', 'TXT');
    stlHtmlHeader := TStringList.Create;
    try
      stlHtmlHeader.LoadFromStream(resHtmlHeader);

      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#KUNDEVORNAME', vorname, [rfReplaceAll]);
      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#KUNDENACHNAME', nachname, [rfReplaceAll]);
      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#KUNDESTRASSEHAUSNR', strassehausnr, [rfReplaceAll]);
      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#KUNDEPLZ', plz, [rfReplaceAll]);
      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#KUNDENORT', ort, [rfReplaceAll]);

      s := FIRMENNAME + ' - ' + FIRMASTRASSE + ', ' + FIRMAORT;

      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#BRIEFFENSTERFIRMENDATEN', s, [rfReplaceAll]);

      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#INHABERNAME', FIRMENINHABER, [rfReplaceAll]);
      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#FIRMENNAME', FIRMENNAME, [rfReplaceAll]);
      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#FIRMASTRASSEHAUSNR', FIRMASTRASSE, [rfReplaceAll]);
      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#FIRMAPLZ', FIRMAPLZ, [rfReplaceAll]);
      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#FIRMAORT', FIRMAORT, [rfReplaceAll]);

      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#ANKAUFSNUMMER', IntToStr(ExtractNumber(sku)), [rfReplaceAll]);
      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#ANKAUFDATUM', ankaufdatum, [rfReplaceAll]);

      stltemp.Add(stlHtmlHeader.Text);
    finally
      stlHtmlHeader.Free;
      resHtmlHeader.Free;
    end;
//HEADER ENDE


//CONTENT START
    resContent := TResourceStream.Create(HInstance, 'ANKAUFSFORMULAR_CONTENT_UHR', 'TXT');
    stlContent := TStringList.Create;
    try
      if(Trim(marke)<>'') then
        if(Trim(model)<>'') then
          s := marke + ' / ' + model
        else
          s := marke
      else
        s := 'unbekannt';

      stlContent.LoadFromStream(resContent);
      stlContent.Text := StringReplace(stlContent.Text, '#REF', ref, [rfReplaceAll]);
      stlContent.Text := StringReplace(stlContent.Text, '#BOX', box, [rfReplaceAll]);
      stlContent.Text := StringReplace(stlContent.Text, '#PAPIERE', papiere, [rfReplaceAll]);
      stlContent.Text := StringReplace(stlContent.Text, '#MARKEMODEL', s, [rfReplaceAll]);
      stlContent.Text := StringReplace(stlContent.Text, '#JAHR', jahr, [rfReplaceAll]);
      stlContent.Text := StringReplace(stlContent.Text, '#KAUFPREIS', kaufbetrag, [rfReplaceAll]);
      stltemp.Add(stlContent.Text);
    finally
      resContent.Free;
      stlContent.Free;
    end;
//CONTENT ENDE


//FOOTER START
    resHtmlFooter := TResourceStream.Create(HInstance, 'ANKAUFSFORMULAR_FOOTER_UHR', 'TXT');
    stlHtmlFooter := TStringList.Create;
    try
      stlHtmlFooter.LoadFromStream(resHtmlFooter);

      stlHtmlFooter.Text := StringReplace(stlHtmlFooter.Text, '#ZUSTAND', zustand, [rfReplaceAll]);
      stlHtmlFooter.Text := StringReplace(stlHtmlFooter.Text, '#ARTIKELNAME', Artikelname, [rfReplaceAll]);
      stlHtmlFooter.Text := StringReplace(stlHtmlFooter.Text, '#EINHET', Einheit, [rfReplaceAll]);
      stlHtmlFooter.Text := StringReplace(stlHtmlFooter.Text, '#GEWICHT', Gewicht, [rfReplaceAll]);
      stlHtmlFooter.Text := StringReplace(stlHtmlFooter.Text, '#VERSANDBETRAG', versandbetrag, [rfReplaceAll]);
      stlHtmlFooter.Text := StringReplace(stlHtmlFooter.Text, '#GESAMTBETRAG', gesamtbetrag, [rfReplaceAll]);
      stlHtmlFooter.Text := StringReplace(stlHtmlFooter.Text, '#ZAHLUNGSART', zahlungsart, [rfReplaceAll]);
      stlHtmlFooter.Text := StringReplace(stlHtmlFooter.Text, '#SKU', sku, [rfReplaceAll]);
      stlHtmlFooter.Text := StringReplace(stlHtmlFooter.Text, '#INHABERNAME', FIRMENINHABER, [rfReplaceAll]);
      stlHtmlFooter.Text := StringReplace(stlHtmlFooter.Text, '#FIRMAUSTID',FIRMAUMSATZSTEUERID, [rfReplaceAll]);
      stlHtmlFooter.Text := StringReplace(stlHtmlFooter.Text, '#FIRMAIBAN', FIRMAIBAN, [rfReplaceAll]);

      stltemp.Add(stlHtmlFooter.Text);
    finally
      stlHtmlFooter.Free;
      resHtmlFooter.Free;
    end;
//FOOTER ENDE


  //Alle Umlaute in der StringList ersetzen durch html code
    for i := 0 to stlTemp.Count - 1 do
    begin
      stlTemp[i] := ReplaceUmlauteWithHtmlEntities(stlTemp[i]);
    end;


    filenameTemp := 'Ankaufsformular';

    if(Ankaufformular_LastID > 0) then
      filenameTemp := filenameTemp + '_' + IntToStr(ExtractNumber(sku)); //IntToStr(Ankaufformular_LastID);

    //Dateiname für zu speichernde Datei erzeugen
    if(trim(edNachname.Text) <> '') then
      if(Trim(edVorname.Text) <> '') then
        filenameTemp := filenameTemp + '_' + trim(edNachname.Text) + '_' + trim(edVorname.Text)
      else
        filenameTemp := filenameTemp + '_' + trim(edNachname.Text);


   filename := filenameTemp;

   // filename := 'Ankaufsformular_' + IntToStr(Ankaufformular_LastID) + ' _ ' + edNachname.Text + '_' + edVorname.Text;

    //Aus Resource-Datei temporäre Html-Datei und daraus eine PDF-Datei im TEMP Verzeichnis erzeugen

    //Erzeugte Datei speichern
    CreateHtmlAndPdfFileFromResource(TPath.Combine(PATHANKAUFSFORMULARE, filename), stlTemp);


    //PDF Datei aus Temp Verzeichnis im Zielverzeichnis speichern
    //SpeicherePDFDatei(filename, PATH);
  finally
    stlTemp.Free;
  end;
end;






procedure TfAnkaufformular.CreateAnkaufsformularEdelmetalleAsPDF(const Pfad: string);
var
  stltemp: TStringList;
  i: integer;
  filename, filenameTemp: string;
  stlHtmlHeader, stlHtmlFooter, stlContent: TStringList;
  resHtmlHeader, resHtmlFooter, resContent: TResourceStream;

  nachname, vorname, strassehausnr, plz, ort: string;
  ankaufsnr, ankaufdatum: string;

  s, kaufbetrag, versandbetrag, gesamtbetrag, artikel: string;
  artikelname, bemerkung, gewicht, karat, zahlungsart, sku, kurzbezeichnung: string;
begin
  nachname        := trim(edNachname.Text);
  vorname         := trim(edVorname.Text);
  strassehausnr   := trim(edStrasseHausNr.Text);
  plz             := trim(edPLZ.Text);
  ort             := trim(edWohnort.Text);
  ankaufsnr       := IntToStr(Ankaufformular_LastID);
  ankaufdatum     := trim(DateToStr(dtpAnkaufsdatum.Date));
  gesamtbetrag    := trim(edGesamtbetrag.Text);
  kurzbezeichnung := 'Kurzbezeichnung';
  zahlungsart     := trim(cbZahlungsarten.Text);
  versandbetrag   := trim(edVersand.Text);
  if(versandbetrag = '') then versandbetrag := '0,00';

  // Erste SKU aus den Edelmetall-Einträgen der ListView ermitteln
  sku := '';
  for i := 0 to lvAnkaufartikel.Items.Count - 1 do
  begin
    if (lvAnkaufartikel.Items[i].Caption = 'edelmetall') and
       (lvAnkaufartikel.Items[i].SubItems.Count > 0) then
    begin
      sku := lvAnkaufartikel.Items[i].SubItems[0];
      Break;
    end;
  end;


//Hier nur das was einmal für alle Seiten geladen werden muss (HtmlHeader, HtmlFooter)
  stlTemp := nil;
  try
    stlTemp := TStringList.Create;

//HEADER START
    resHtmlHeader := TResourceStream.Create(HInstance, 'ANKAUFSFORMULAR_HEADER', 'TXT');
    stlHtmlHeader := TStringList.Create;
    try
      stlHtmlHeader.LoadFromStream(resHtmlHeader);

      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#KUNDEVORNAME', vorname, [rfReplaceAll]);
      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#KUNDENACHNAME', nachname, [rfReplaceAll]);
      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#KUNDESTRASSEHAUSNR', strassehausnr, [rfReplaceAll]);
      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#KUNDEPLZ', plz, [rfReplaceAll]);
      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#KUNDENORT', ort, [rfReplaceAll]);

      s := FIRMENNAME + ' - ' + FIRMASTRASSE + ', ' + FIRMAORT;

      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#BRIEFFENSTERFIRMENDATEN', s, [rfReplaceAll]);

      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#INHABERNAME', FIRMENINHABER, [rfReplaceAll]);
      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#FIRMENNAME', FIRMENNAME, [rfReplaceAll]);
      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#FIRMASTRASSEHAUSNR', FIRMASTRASSE, [rfReplaceAll]);
      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#FIRMAPLZ', FIRMAPLZ, [rfReplaceAll]);
      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#FIRMAORT', FIRMAORT, [rfReplaceAll]);

      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#ANKAUFSNUMMER', IntToStr(ExtractNumber(sku)), [rfReplaceAll]);
      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#ANKAUFDATUM', ankaufdatum, [rfReplaceAll]);

      stltemp.Add(stlHtmlHeader.Text);
    finally
      stlHtmlHeader.Free;
      resHtmlHeader.Free;
    end;
//HEADER ENDE


//CONTENT START - Einmal für jeden Edelmetall-Artikel ausführen
    for i := 0 to lvAnkaufartikel.Items.Count - 1 do
    begin
      if lvAnkaufartikel.Items[i].Caption <> 'edelmetall' then Continue;

      artikel    := lvAnkaufartikel.Items[i].SubItems[1];
      gewicht    := lvAnkaufartikel.Items[i].SubItems[4];
      karat      := lvAnkaufartikel.Items[i].SubItems[5];
      kaufbetrag := lvAnkaufartikel.Items[i].SubItems[6];

      resContent := TResourceStream.Create(HInstance, 'ANKAUFSFORMULAR_CONTENT', 'TXT');
      stlContent := TStringList.Create;
      try
        stlContent.LoadFromStream(resContent);
        stlContent.Text := StringReplace(stlContent.Text, '#ARTIKEL', artikel, [rfReplaceAll]);
        stlContent.Text := StringReplace(stlContent.Text, '#GEWICHT', gewicht, [rfReplaceAll]);
        stlContent.Text := StringReplace(stlContent.Text, '#KARAT', karat, [rfReplaceAll]);
        stlContent.Text := StringReplace(stlContent.Text, '#KAUFPREIS', kaufbetrag, [rfReplaceAll]);
        stltemp.Add(stlContent.Text);
      finally
        resContent.Free;
        stlContent.Free;
      end;
    end;
//CONTENT ENDE


//FOOTER START
    resHtmlFooter := TResourceStream.Create(HInstance, 'ANKAUFSFORMULAR_FOOTER', 'TXT');
    stlHtmlFooter := TStringList.Create;
    try
      stlHtmlFooter.LoadFromStream(resHtmlFooter);

      stlHtmlFooter.Text := StringReplace(stlHtmlFooter.Text, '#VERSANDBETRAG', versandbetrag, [rfReplaceAll]);
      stlHtmlFooter.Text := StringReplace(stlHtmlFooter.Text, '#GESAMTBETRAG', gesamtbetrag, [rfReplaceAll]);
      stlHtmlFooter.Text := StringReplace(stlHtmlFooter.Text, '#ZAHLUNGSART', zahlungsart, [rfReplaceAll]);
      stlHtmlFooter.Text := StringReplace(stlHtmlFooter.Text, '#SKU', sku, [rfReplaceAll]);
      stlHtmlFooter.Text := StringReplace(stlHtmlFooter.Text, '#INHABERNAME', FIRMENINHABER, [rfReplaceAll]);
      stlHtmlFooter.Text := StringReplace(stlHtmlFooter.Text, '#FIRMAUSTID',FIRMAUMSATZSTEUERID, [rfReplaceAll]);
      stlHtmlFooter.Text := StringReplace(stlHtmlFooter.Text, '#FIRMAIBAN', FIRMAIBAN, [rfReplaceAll]);

      stltemp.Add(stlHtmlFooter.Text);
    finally
      stlHtmlFooter.Free;
      resHtmlFooter.Free;
    end;
//FOOTER ENDE


  //Alle Umlaute in der StringList ersetzen durch html code
    for i := 0 to stlTemp.Count - 1 do
    begin
      stlTemp[i] := ReplaceUmlauteWithHtmlEntities(stlTemp[i]);
    end;


    filenameTemp := 'Ankaufsformular';

    if(Ankaufformular_LastID > 0) then
      filenameTemp := filenameTemp + '_' + IntToStr(ExtractNumber(sku)); //IntToStr(Ankaufformular_LastID);

    //Dateiname für zu speichernde Datei erzeugen
    if(trim(edNachname.Text) <> '') then
      if(Trim(edVorname.Text) <> '') then
        filenameTemp := filenameTemp + '_' + trim(edNachname.Text) + '_' + trim(edVorname.Text)
      else
        filenameTemp := filenameTemp + '_' + trim(edNachname.Text);


   filename := filenameTemp;

   // filename := 'Ankaufsformular_' + IntToStr(Ankaufformular_LastID) + ' _ ' + edNachname.Text + '_' + edVorname.Text;

    //Aus Resource-Datei temporäre Html-Datei und daraus eine PDF-Datei im TEMP Verzeichnis erzeugen

    //Erzeugte Datei speichern
    CreateHtmlAndPdfFileFromResource(TPath.Combine(Pfad, filename), stlTemp);


    //PDF Datei aus Temp Verzeichnis im Zielverzeichnis speichern
    //SpeicherePDFDatei(filename, PATH);
  finally
    stlTemp.Free;
  end;
end;















procedure TfAnkaufformular.CreateAnkaufsformularInventarAsPDF(const Pfad: string);
var
  stltemp: TStringList;
  i: integer;
  filename, filenameTemp: string;
  stlHtmlHeader, stlHtmlFooter, stlContent: TStringList;
  resHtmlHeader, resHtmlFooter, resContent: TResourceStream;

  nachname, vorname, strassehausnr, plz, ort: string;
  ankaufsnr, ankaufdatum: string;

  s, kaufbetrag, versandbetrag, gesamtbetrag, artikel: string;
  bemerkung, gewicht, karat, zahlungsart, sku, kurzbezeichnung: string;
  marke, model, jahr, zustand, ref, einheit, box, papiere: string;
begin
  nachname        := trim(edNachname.Text);
  vorname         := trim(edVorname.Text);
  strassehausnr   := trim(edStrasseHausNr.Text);
  plz             := trim(edPLZ.Text);
  ort             := trim(edWohnort.Text);
  ankaufsnr       := IntToStr(Ankaufformular_LastID);
  ankaufdatum     := trim(DateToStr(dtpAnkaufsdatum.Date));
  gesamtbetrag    := trim(edGesamtbetrag.Text);
  kurzbezeichnung := 'Kurzbezeichnung';
  zahlungsart     := trim(cbZahlungsarten.Text);
  versandbetrag   := trim(edVersand.Text);
  if(versandbetrag = '') then versandbetrag := '0,00';

  // Erste SKU aus den Inventar-Einträgen der ListView ermitteln
  sku := '';
  for i := 0 to lvAnkaufartikel.Items.Count - 1 do
  begin
    if (lvAnkaufartikel.Items[i].Caption = 'inventar') and
       (lvAnkaufartikel.Items[i].SubItems.Count > 0) then
    begin
      sku := lvAnkaufartikel.Items[i].SubItems[0];
      Break;
    end;
  end;


//Hier nur das was einmal für alle Seiten geladen werden muss (HtmlHeader, HtmlFooter)
  stlTemp := nil;
  try
    stlTemp := TStringList.Create;

//HEADER START
    resHtmlHeader := TResourceStream.Create(HInstance, 'ANKAUFSFORMULAR_HEADER_INVENTAR', 'TXT');
    stlHtmlHeader := TStringList.Create;
    try
      stlHtmlHeader.LoadFromStream(resHtmlHeader);

      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#KUNDEVORNAME', vorname, [rfReplaceAll]);
      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#KUNDENACHNAME', nachname, [rfReplaceAll]);
      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#KUNDESTRASSEHAUSNR', strassehausnr, [rfReplaceAll]);
      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#KUNDEPLZ', plz, [rfReplaceAll]);
      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#KUNDENORT', ort, [rfReplaceAll]);

      s := FIRMENNAME + ' - ' + FIRMASTRASSE + ', ' + FIRMAORT;

      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#BRIEFFENSTERFIRMENDATEN', s, [rfReplaceAll]);

      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#INHABERNAME', FIRMENINHABER, [rfReplaceAll]);
      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#FIRMENNAME', FIRMENNAME, [rfReplaceAll]);
      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#FIRMASTRASSEHAUSNR', FIRMASTRASSE, [rfReplaceAll]);
      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#FIRMAPLZ', FIRMAPLZ, [rfReplaceAll]);
      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#FIRMAORT', FIRMAORT, [rfReplaceAll]);

      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#ANKAUFSNUMMER', IntToStr(ExtractNumber(sku)), [rfReplaceAll]);
      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#ANKAUFDATUM', ankaufdatum, [rfReplaceAll]);

      stltemp.Add(stlHtmlHeader.Text);
    finally
      stlHtmlHeader.Free;
      resHtmlHeader.Free;
    end;
//HEADER ENDE


//CONTENT START - Einmal für jeden Inventar-Artikel ausführen
    for i := 0 to lvAnkaufartikel.Items.Count - 1 do
    begin
      if lvAnkaufartikel.Items[i].Caption <> 'inventar' then Continue;

      // SubItems: [0]=SKU [1]=Artikelname [2]=Bemerkung [3]=Einheit [4]=Gewicht
      //           [5]=Karat [6]=Ankaufpreis [7]=Marke [8]=Model [9]=Jahr
      //           [10]=Zustand [11]=Ref [12]=Box [13]=Papiere
      artikel    := lvAnkaufartikel.Items[i].SubItems[1];
      bemerkung  := lvAnkaufartikel.Items[i].SubItems[2];
      einheit    := lvAnkaufartikel.Items[i].SubItems[3];
      gewicht    := lvAnkaufartikel.Items[i].SubItems[4];
      karat      := lvAnkaufartikel.Items[i].SubItems[5];
      kaufbetrag := lvAnkaufartikel.Items[i].SubItems[6];
      marke      := lvAnkaufartikel.Items[i].SubItems[7];
      model      := lvAnkaufartikel.Items[i].SubItems[8];
      jahr       := lvAnkaufartikel.Items[i].SubItems[9];
      zustand    := lvAnkaufartikel.Items[i].SubItems[10];
      ref        := lvAnkaufartikel.Items[i].SubItems[11];
      if lvAnkaufartikel.Items[i].SubItems[12] = '1' then box := 'X' else box := '-';
      if lvAnkaufartikel.Items[i].SubItems[13] = '1' then papiere := 'X' else papiere := '-';

      if(Trim(marke) <> '') then
        if(Trim(model) <> '') then
          s := marke + ' / ' + model
        else
          s := marke
      else
        s := '';

      resContent := TResourceStream.Create(HInstance, 'ANKAUFSFORMULAR_CONTENT_INVENTAR', 'TXT');
      stlContent := TStringList.Create;
      try
        stlContent.LoadFromStream(resContent);
        stlContent.Text := StringReplace(stlContent.Text, '#ARTIKEL', artikel, [rfReplaceAll]);
        stlContent.Text := StringReplace(stlContent.Text, '#GEWICHT', gewicht, [rfReplaceAll]);
        stlContent.Text := StringReplace(stlContent.Text, '#KARAT', karat, [rfReplaceAll]);
        stlContent.Text := StringReplace(stlContent.Text, '#KAUFPREIS', kaufbetrag, [rfReplaceAll]);
        stlContent.Text := StringReplace(stlContent.Text, '#MARKEMODEL', s, [rfReplaceAll]);
        stlContent.Text := StringReplace(stlContent.Text, '#ZUSTAND', zustand, [rfReplaceAll]);
        stlContent.Text := StringReplace(stlContent.Text, '#BOX', box, [rfReplaceAll]);
        stlContent.Text := StringReplace(stlContent.Text, '#PAPIERE', papiere, [rfReplaceAll]);
        stlContent.Text := StringReplace(stlContent.Text, '#REF', ref, [rfReplaceAll]);
        stlContent.Text := StringReplace(stlContent.Text, '#EINHEIT', einheit, [rfReplaceAll]);
        stltemp.Add(stlContent.Text);
      finally
        resContent.Free;
        stlContent.Free;
      end;
    end;
//CONTENT ENDE


//FOOTER START
    resHtmlFooter := TResourceStream.Create(HInstance, 'ANKAUFSFORMULAR_FOOTER_INVENTAR', 'TXT');
    stlHtmlFooter := TStringList.Create;
    try
      stlHtmlFooter.LoadFromStream(resHtmlFooter);

      stlHtmlFooter.Text := StringReplace(stlHtmlFooter.Text, '#VERSANDBETRAG', versandbetrag, [rfReplaceAll]);
      stlHtmlFooter.Text := StringReplace(stlHtmlFooter.Text, '#GESAMTBETRAG', gesamtbetrag, [rfReplaceAll]);
      stlHtmlFooter.Text := StringReplace(stlHtmlFooter.Text, '#ZAHLUNGSART', zahlungsart, [rfReplaceAll]);
      stlHtmlFooter.Text := StringReplace(stlHtmlFooter.Text, '#SKU', sku, [rfReplaceAll]);
      stlHtmlFooter.Text := StringReplace(stlHtmlFooter.Text, '#INHABERNAME', FIRMENINHABER, [rfReplaceAll]);
      stlHtmlFooter.Text := StringReplace(stlHtmlFooter.Text, '#FIRMAUSTID', FIRMAUMSATZSTEUERID, [rfReplaceAll]);
      stlHtmlFooter.Text := StringReplace(stlHtmlFooter.Text, '#FIRMAIBAN', FIRMAIBAN, [rfReplaceAll]);

      stltemp.Add(stlHtmlFooter.Text);
    finally
      stlHtmlFooter.Free;
      resHtmlFooter.Free;
    end;
//FOOTER ENDE


  //Alle Umlaute in der StringList ersetzen durch html code
    for i := 0 to stlTemp.Count - 1 do
    begin
      stlTemp[i] := ReplaceUmlauteWithHtmlEntities(stlTemp[i]);
    end;


    filenameTemp := 'Ankaufsformular_Inventar';

    if(Ankaufformular_LastID > 0) then
      filenameTemp := filenameTemp + '_' + IntToStr(ExtractNumber(sku));

    //Dateiname für zu speichernde Datei erzeugen
    if(trim(edNachname.Text) <> '') then
      if(Trim(edVorname.Text) <> '') then
        filenameTemp := filenameTemp + '_' + trim(edNachname.Text) + '_' + trim(edVorname.Text)
      else
        filenameTemp := filenameTemp + '_' + trim(edNachname.Text);

    filename := filenameTemp;

    //Erzeugte Datei speichern
    CreateHtmlAndPdfFileFromResource(TPath.Combine(Pfad, filename), stlTemp);

  finally
    stlTemp.Free;
  end;
end;




procedure TfAnkaufformular.cbZahlungsartenSelect(Sender: TObject);
var
  i: integer;
begin
  i := cbZahlungsarten.ItemIndex;
  if i <> -1 then
  begin
    SELZAHLUNGSART := Integer(cbZahlungsarten.Items.Objects[i]);
  end;
end;




procedure TfAnkaufformular.cbZustandSelect(Sender: TObject);
var
  i: integer;
begin
  i := cbZustand.ItemIndex;
  if i <> -1 then
  begin
    SELZUSTAND := Integer(cbZustand.Items.Objects[i]);
  end;
end;




procedure TfAnkaufformular.edAnkaufspreisKeyPress(Sender: TObject; var Key: Char);
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





procedure TfAnkaufformular.edGewichtExit(Sender: TObject);
var
  d: Double;
  FS: TFormatSettings;
  Edit: TLabeledEdit;
begin
  if not (Sender is TLabeledEdit) then
    Exit;

  Edit := TLabeledEdit(Sender);

  if Trim(Edit.Text) = '' then
    Exit;

  FS := TFormatSettings.Create;
  FS.DecimalSeparator := ',';

  if TryStrToFloat(Trim(Edit.Text), d, FS) then
    Edit.Text := FormatFloat('0.00', d, FS)
  else
  begin
    ShowMessage('Bitte geben Sie einen gültigen Wert ein.');
    Edit.SetFocus;
    Edit.SelectAll;
  end;
end;


procedure TfAnkaufformular.edNachnameKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  KUNDENDATENEDITED := true;
end;



procedure TfAnkaufformular.edPLZKeyPress(Sender: TObject; var Key: Char);
begin
// Ziffern erlauben
  if CharInSet(Key, ['0'..'9']) then
    Exit;

  // Backspace erlauben
  if Key = #8 then
    Exit;

  // Enter erlauben
  if Key = #13 then
    Exit;

  // Alles andere blockieren
  Key := #0;
end;

procedure TfAnkaufformular.edTelefonKeyPress(Sender: TObject; var Key: Char);
begin
// Ziffern erlauben
  if CharInSet(Key, ['0'..'9']) then
    Exit;

  // - erlauben (nur einmal)
  if (Key = '-') and (Pos('-', (Sender as TLabeledEdit).Text) = 0) then
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

  // Alles andere blockieren
  Key := #0;
end;

procedure TfAnkaufformular.FormActivate(Sender: TObject);
begin
  rbSchmuck.SetFocus;
end;

procedure TfAnkaufformular.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    Close;
  end;
end;






procedure TfAnkaufformular.FormShow(Sender: TObject);
begin
  Ankaufformular_LastID := 0;

  PageControlArtikel.ActivePageIndex := 0;

  lvAnkaufArtikel.Items.Clear;

  LoadZustaendeFromDB(fMain.FDConnection1, cbZustand);
  LoadZahlungsartenFromDB(fMain.FDConnection1, cbZahlungsarten);
  LoadEinheitenFromDB(fMain.FDConnection1, cbEinheiten);

  //Kundenformular
  ClearLabeledEdits(Panel4);


  //Ankaufsformular
  ClearLabeledEdits(Panel3);

  cbBox.Checked := false;
  cbPapiere.Checked := false;
  rbSchmuck.Checked := true;


  cbZustand.ItemIndex := -1;
  cbZahlungsarten.ItemIndex := -1;
  rbAddToInventarliste.Checked := false;
  rbEdelmetallSammelVerkauf.Checked := false;
  dtpAnkaufsdatum.Date := now;
  dtpAnkaufsdatum.Checked := true;

  // edVersand.OnExit per Code zuweisen (keine DFM-Änderung nötig)
  edVersand.OnExit := edVersandExit;

  edArtikelname.SetFocus;
end;





procedure TfAnkaufformular.rbAddToInventarlisteClick(Sender: TObject);
begin
  edArtikelname.SetFocus;
end;

procedure TfAnkaufformular.rbSchmuckClick(Sender: TObject);
begin
  if(rbSchmuck.Checked) then
  begin
    pnlUhr.Visible := false;
    rbAddToInventarliste.Checked := false;
    edArtikelname.SetFocus;
  end
  else
  begin
    pnlUhr.Visible := true;
    edMarke.SetFocus;
  end;
end;

procedure TfAnkaufformular.rbUhrClick(Sender: TObject);
begin
  if(rbUhr.Checked) then
  begin
    pnlUhr.Visible := true;
    rbAddToInventarliste.Checked := true;
    edMarke.SetFocus;
  end
  else
  begin
    pnlUhr.Visible := false;
    edArtikelname.SetFocus;
  end;
end;

procedure TfAnkaufformular.sbNextSKUClick(Sender: TObject);
var
  s: string;
begin
{  s := GetNextSKU(fMain.FDConnection1, true);
  if(trim(s) = '') then
    edSKU.Text := STARTSKU_ANKAUF
  else
    edSKU.Text := trim(s);
}end;




// Summe aller Ankaufspreise aus der ListView + Versand -> edGesamtbetrag
procedure TfAnkaufformular.RecalcGesamtbetrag;
var
  i: Integer;
  TotalAnkauf, Versand, Gesamt: Int64;
begin
  TotalAnkauf := 0;
  for i := 0 to lvAnkaufartikel.Items.Count - 1 do
  begin
    if lvAnkaufartikel.Items[i].SubItems.Count > 6 then
      TotalAnkauf := TotalAnkauf + DecimalStringToInt100(lvAnkaufartikel.Items[i].SubItems[6]);
  end;

  if IsValidDecimalString(edVersand.Text) then
    Versand := DecimalStringToInt100(edVersand.Text)
  else
    Versand := 0;

  Gesamt := TotalAnkauf + Versand;
  edGesamtbetrag.Text := Int100ToDecimalString(Gesamt);
end;




procedure TfAnkaufformular.edVersandExit(Sender: TObject);
begin
  RecalcGesamtbetrag;
end;




end.
