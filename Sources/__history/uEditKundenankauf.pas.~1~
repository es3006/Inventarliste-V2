unit uEditKundenankauf;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Mask, AdvPageControl, StrUtils,
  FireDAC.Stan.Param, FireDAC.Phys.SQLite, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.Generics.Defaults,
  FireDAC.Stan.Intf, FireDAC.DApt, DateUtils, Vcl.Buttons, ShellApi;



type
  TfEditKundenankauf = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    edSKU: TLabeledEdit;
    dtpAnkaufsdatum: TDateTimePicker;
    edAnkaufspreis: TLabeledEdit;
    edBezeichnung: TLabeledEdit;
    btnAbort: TButton;
    btnSave: TButton;
    Panel1: TPanel;
    Label7: TLabel;
    imgTaschenrechner: TImage;
    edReferenz: TLabeledEdit;
    edMarke: TLabeledEdit;
    edModel: TLabeledEdit;
    edJahr: TLabeledEdit;
    cbBox: TCheckBox;
    cbPapiere: TCheckBox;
    edGewicht: TLabeledEdit;
    edVersand: TLabeledEdit;
    cbZustand: TComboBox;
    cbZahlungsarten: TComboBox;
    Label10: TLabel;
    Label9: TLabel;
    edGesamtbetrag: TLabeledEdit;
    Label6: TLabel;
    procedure btnAbortClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edAnkaufspreisChange(Sender: TObject);
    procedure edAnkaufspreisKeyPress(Sender: TObject; var Key: Char);
    procedure edVersandKeyPress(Sender: TObject; var Key: Char);
    procedure imgTaschenrechnerClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    procedure UpdateKundenankaufInDB(const AConnection: TFDConnection);
    procedure ShowKundenankaufEntryFromDB(const AConnection: TFDConnection);
   // procedure CreateAnkaufsformularAsPDF;
  public
    ENTRYID: integer;
  end;

var
  fEditKundenankauf: TfEditKundenankauf;
  ENTRYID: integer;


implementation

{$R *.dfm}

uses
  uMain, uFunctions, uDBFunctions;



procedure TfEditKundenankauf.btnAbortClick(Sender: TObject);
begin
  close;
end;

procedure TfEditKundenankauf.btnSaveClick(Sender: TObject);
begin
  UpdateKundenankaufInDB(fMain.FDConnection1);
end;





procedure TfEditKundenankauf.edAnkaufspreisChange(Sender: TObject);
var
  Kaufpreis, Versand, Gesamt: Double;
  sKaufpreis, sVersand: string;
begin
  // Werte aus den Edit-Feldern auslesen
  Kaufpreis := StrToFloatDef(Trim(edAnkaufspreis.Text), 0);
  Versand   := StrToFloatDef(Trim(edVersand.Text), 0);

  // Summe berechnen
  Gesamt := Kaufpreis + Versand;

  // Ergebnis anzeigen
  edGesamtbetrag.Text := FormatFloat('0.00', Gesamt);
end;






procedure TfEditKundenankauf.edAnkaufspreisKeyPress(Sender: TObject; var Key: Char);
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






procedure TfEditKundenankauf.edVersandKeyPress(Sender: TObject; var Key: Char);
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





procedure TfEditKundenankauf.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    Close;
  end;
end;

procedure TfEditKundenankauf.FormShow(Sender: TObject);
begin
  LoadZustaendeFromDB(fMain.FDConnection1, cbZustand);
  LoadZahlungsartenFromDB(fMain.FDConnection1, cbZahlungsarten);

  ShowKundenankaufEntryFromDB(fMain.FDConnection1);
end;





procedure TfEditKundenankauf.imgTaschenrechnerClick(Sender: TObject);
begin
  OpenCalculator;
end;





procedure TfEditKundenankauf.UpdateKundenankaufInDB(const AConnection: TFDConnection);
var
  FDQuery: TFDQuery;
  TSGeburtsdatum: Int64;

  TSAnkaufsdatum: Int64;

  ankaufspreis, versandpreis, gesamtpreis: Int64;

  sku, ref, marke, model, bezeichnung, gewicht, einheit: string;
  ankaufsdatum, box, papiere, jahr: integer;
  zustand, zahlungsart: string;
begin
  if(trim(edSKU.Text) = '') then
  begin
    showmessage('Bitte geben Sie eine SKU ein!');
    edSKU.SetFocus;
    exit;
  end;

  if(trim(edAnkaufspreis.Text) = '') then
  begin
    showmessage('Bitte geben Sie den Ankaufspreis ein!!');
    edAnkaufspreis.SetFocus;
    exit;
  end;


  //Datumsfelder
  if(Trim(edJahr.Text) <> '') then
    jahr := StrToInt(trim(edJahr.Text))
  else
  begin
    showmessage('Bitte geben Sie das Herstellungsjahr des Artikels ein!');
    edJahr.SetFocus;
    exit;
  end;

  if dtpAnkaufsdatum.Checked then
    TSAnkaufsdatum := DateTimeToUnix(dtpAnkaufsdatum.Date, false)
  else
    TSAnkaufsdatum := 0;

  //checkboxen
  if(cbBox.Checked) then box := 1 else box := 0;
  if(cbPapiere.Checked) then papiere := 1 else papiere := 0;

  //Text
  sku          := trim(edSKU.Text);
  ref          := trim(edReferenz.Text);
  marke        := trim(edMarke.Text);
  model        := trim(edModel.Text);
  bezeichnung  := trim(edBezeichnung.Text);
  gewicht      := trim(edGewicht.Text);
  zustand      := cbZustand.Text;
  zahlungsart  := cbZahlungsarten.Text;

  //Beträge
  ankaufspreis := EditToCentSafe(edAnkaufspreis);
  versandpreis := EditToCentSafe(edVersand);
  gesamtpreis  := EditToCentSafe(edGesamtbetrag);

  //Werte aus Ankaufsformular in Datenbank speichern
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := AConnection;

    AConnection.StartTransaction;
    try
      FDQuery.SQL.Text :=
        'UPDATE kundenankauf SET ' +
        'Ankaufsdatum = :ANKAUFDATUM, ' +
        'SKU = :SKU, ' +
        'Ref = :REF , ' +
        'Box = :BOX, ' +
        'Papiere = :PAPIERE, ' +
        'Marke = :MARKE, ' +
        'Model = :MODEL, ' +
        'Jahr = :JAHR, ' +
        'Kaufpreis = :KAUFPREIS, ' +
        'Zustand = :ZUSTAND, ' +
        'Bezeichnung = :BEZEICHNUNG, ' +
        'Gewicht = :GEWICHT, ' +
        'Versand = :VERSAND, ' +
        'Zahlungsart = :ZAHLUNGSART ' +
        'WHERE id = :ID';

      FDQuery.ParamByName('ID').AsInteger  := ENTRYID;
      FDQuery.ParamByName('ANKAUFDATUM').AsLargeInt := TSAnkaufsdatum;
      FDQuery.ParamByName('SKU').AsString  := sku;
      FDQuery.ParamByName('REF').AsString  := ref;
      FDQuery.ParamByName('BOX').AsInteger  := box;
      FDQuery.ParamByName('PAPIERE').AsInteger  := papiere;
      FDQuery.ParamByName('MARKE').AsString  := marke;
      FDQuery.ParamByName('MODEL').AsString := model;
      FDQuery.ParamByName('JAHR').AsInteger := jahr;
      FDQuery.ParamByName('KAUFPREIS').AsLargeInt := ankaufspreis;
      FDQuery.ParamByName('ZUSTAND').AsString := zustand;
      FDQuery.ParamByName('BEZEICHNUNG').AsString := bezeichnung;
      FDQuery.ParamByName('GEWICHT').AsString := gewicht;
      FDQuery.ParamByName('VERSAND').AsLargeInt := versandpreis;
      FDQuery.ParamByName('ZAHLUNGSART').AsString := zahlungsart;

      FDQuery.ExecSQL;

      AConnection.Commit;
    except
      AConnection.Rollback;
      raise;
    end;
  finally
    FDQuery.Free;
  end;


  fMain.LoadInventarToListView; //Einträge aus Datenbank in ListView ausgeben

  //CreateAnkaufsformularAsPDF;

  close;
end;





{
procedure TfEditKundenankauf.CreateAnkaufsformularAsPDF;
var
  stltemp: TStringList;
  i, a: integer;
  filename: string;
  stlHtmlHeader, stlHtmlFooter, stlContent: TStringList;
  resHtmlHeader, resHtmlFooter, resContent: TResourceStream;

  kundennr, nachname, vorname, strassehausnr, plz, ort: string;
  ankaufsnr, ankaufdatum: string;

  ref, box, papiere, marke, model, jahr, kaufdatum, kaufbetrag: string;
  s: string;
  zustand, bezeichnung, gewicht, versand, gesamtbetrag, zahlungsart, sku: string;
  versandbetrag, kurzbezeichnung: string;
begin
//Hier nur das was einmal für alle Seiten geladen werden muss (HtmlHeader, HtmlFooter)
  stlTemp := nil;
  try
    stlTemp := TStringList.Create;

//HEADER START
    //kundennr := trim(edKundenNr.Text);
    nachname := trim(edNachname.Text);
    vorname := trim(edVorname.Text);
    strassehausnr := trim(edStrasseHausNr.Text);
    plz := trim(edPLZ.Text);
    ort := trim(edWohnort.Text);
    ankaufsnr := IntToStr(Ankaufformular_LastID);
    ankaufdatum := trim(DateToStr(dtpAnkaufsdatum.Date));

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

      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#ANKAUFSNUMMER', ankaufsnr, [rfReplaceAll]);
      stlHtmlHeader.Text := StringReplace(stlHtmlHeader.Text, '#ANKAUFDATUM', ankaufdatum, [rfReplaceAll]);

      stltemp.Add(stlHtmlHeader.Text);
    finally
      stlHtmlHeader.Free;
      resHtmlHeader.Free;
    end;
//HEADER ENDE


//CONTENT START
    ref := trim(edReferenz.Text);
    if(cbBox.Checked) then box := 'X' else box := '-';
    if(cbPapiere.Checked) then papiere := 'X' else papiere := '-';
    marke := edMarke.Text;
    model := edModel.Text;

    if(Trim(marke)<>'') then
      if(Trim(model)<>'') then
        s := marke + ' / ' + model
      else
        s := marke
    else
      s := 'unbekannt';

    jahr := edJahr.Text;
    kaufbetrag := edAnkaufspreis.Text;


    resContent := TResourceStream.Create(HInstance, 'ANKAUFSFORMULAR_CONTENT', 'TXT');
    stlContent := TStringList.Create;
    try
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
    zustand := trim(cbZustand.Text);
    bezeichnung := trim(edBezeichnung.Text);
    gewicht := trim(edGewicht.Text);
    versandbetrag := trim(edVersand.Text);
    gesamtbetrag := trim(edGesamtbetrag.Text);
    kurzbezeichnung := 'Kurzbezeichnung';
    zahlungsart := trim(cbZahlungsarten.Text);
    sku := trim(edSKU.Text);


    resHtmlFooter := TResourceStream.Create(HInstance, 'ANKAUFSFORMULAR_FOOTER', 'TXT');
    stlHtmlFooter := TStringList.Create;
    try
      stlHtmlFooter.LoadFromStream(resHtmlFooter);

      stlHtmlFooter.Text := StringReplace(stlHtmlFooter.Text, '#ZUSTAND', zustand, [rfReplaceAll]);
      stlHtmlFooter.Text := StringReplace(stlHtmlFooter.Text, '#BEZEICHNUNG', bezeichnung, [rfReplaceAll]);
      stlHtmlFooter.Text := StringReplace(stlHtmlFooter.Text, '#GEWICHT', gewicht, [rfReplaceAll]);
      stlHtmlFooter.Text := StringReplace(stlHtmlFooter.Text, '#VERSANDBETRAG', versandbetrag, [rfReplaceAll]);
      stlHtmlFooter.Text := StringReplace(stlHtmlFooter.Text, '#GESAMTBETRAG', gesamtbetrag, [rfReplaceAll]);
      stlHtmlFooter.Text := StringReplace(stlHtmlFooter.Text, '#KURZBEZEICHNUNG', kurzbezeichnung, [rfReplaceAll]);
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


    //Dateiname für zu speichernde Datei erzeugen
    filename := 'Ankaufsformular_' + IntToStr(Ankaufformular_LastID) + ' _ ' + edNachname.Text + '_' + edVorname.Text;

    //Aus Resource-Datei temporäre Html-Datei und daraus eine PDF-Datei im TEMP Verzeichnis erzeugen
    CreateHtmlAndPdfFileFromResource(filename, stlTemp);



    //PDF Datei aus Temp Verzeichnis im Zielverzeichnis speichern
   // SpeicherePDFDatei(filename, PATH);
  finally
    stlTemp.Free;
  end;
end;
}





procedure TfEditKundenankauf.ShowKundenankaufEntryFromDB(const AConnection: TFDConnection);
var
  Q: TFDQuery;
  TSAnkauf: Int64;
  DTAnkauf: TDateTime;
begin
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := AConnection;
    Q.SQL.Text :=
      'SELECT Ankaufsdatum, SKU, Ref, Box, Papiere, Marke, Model, Jahr, Kaufpreis, ' +
      'Zustand, Bezeichnung, Gewicht, Versand, Zahlungsart ' +
      'FROM kundenankauf WHERE id = :ID';

    Q.ParamByName('ID').DataType := ftInteger;
    Q.ParamByName('ID').AsInteger := ENTRYID;
    Q.Open;

    if not Q.IsEmpty then
    begin
      if Q.FieldByName('Ankaufsdatum').IsNull then
        TSAnkauf := 0
      else
        TSAnkauf := Q.FieldByName('Ankaufsdatum').AsLargeInt;

      if TSAnkauf = 0 then
      begin
        dtpAnkaufsdatum.Date := Now;
        dtpAnkaufsdatum.Checked := False;
      end
      else
      begin
        DTAnkauf := UnixToDateTime(TSAnkauf);
        dtpAnkaufsdatum.Date := DTAnkauf;
        dtpAnkaufsdatum.Checked := True;
      end;

      edSKU.Text := Q.FieldByName('SKU').AsString;
      edReferenz.Text := Q.FieldByName('Ref').AsString;

      if(Q.FieldByName('Box').AsInteger = 1) then
        cbBox.Checked := true
      else
        cbBox.Checked := false;

      if(Q.FieldByName('Papiere').AsInteger = 1) then
        cbPapiere.Checked := true
      else
        cbPapiere.Checked := false;

      edMarke.Text := Q.FieldByName('Marke').AsString;
      edModel.Text := Q.FieldByName('Model').AsString;
      edJahr.Text := Q.FieldByName('Jahr').AsString;

      edAnkaufspreis.Text := CentToEuro(Q.FieldByName('Kaufpreis').AsLargeInt);

      SelectComboBoxItemByText(cbZustand, Q.FieldByName('Zustand').AsString);

      edBezeichnung.Text := Q.FieldByName('Bezeichnung').AsString;
      edGewicht.Text := Q.FieldByName('Gewicht').AsString;

      edVersand.Text := CentToEuro(Q.FieldByName('Versand').AsLargeInt);


      SelectComboBoxItemByText(cbZahlungsarten, Q.FieldByName('Zahlungsart').AsString);
    end;
  finally
    Q.Free;
  end;
end;



end.
