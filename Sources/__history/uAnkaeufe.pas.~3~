unit uAnkaeufe;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls,
  Vcl.ComCtrls, AdvListV, System.UITypes, System.Math,
  FireDAC.Stan.Param, FireDAC.Phys.SQLite, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Stan.Intf, FireDAC.DApt, DateUtils, Vcl.Menus, System.Actions,
  Vcl.ActnList;

type
  TfAnkaeufe = class(TForm)
    Panel1: TPanel;
    Label7: TLabel;
    lvAnkaeufe: TAdvListView;
    pnlAnkaeufe: TPanel;
    Label1: TLabel;
    edBezeichnung: TLabeledEdit;
    edKaufpreis: TLabeledEdit;
    edRef: TLabeledEdit;
    dtpAnkaufsdatum: TDateTimePicker;
    btnSave: TButton;
    edVersand: TLabeledEdit;
    edGesamtpreis: TLabeledEdit;
    cbBox: TCheckBox;
    cbPapiere: TCheckBox;
    ActionList1: TActionList;
    PopupMenu1: TPopupMenu;
    acDeleteEntry: TAction;
    Eintraglschen1: TMenuItem;
    edSKU: TLabeledEdit;
    edJahr: TLabeledEdit;
    Label4: TLabel;
    cbZustand: TComboBox;
    cbZahlungsarten: TComboBox;
    Label5: TLabel;
    edGewicht: TLabeledEdit;
    edMarke: TLabeledEdit;
    edModel: TLabeledEdit;
    cbSavedInInventar: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure lvAnkaeufeClick(Sender: TObject);
    procedure acDeleteEntryUpdate(Sender: TObject);
    procedure acDeleteEntryExecute(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure edKaufpreisChange(Sender: TObject);
    procedure lvAnkaeufeSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    procedure LoadAnkaeufeToListView(const AConnection: TFDConnection);
    procedure LoadAnkaeufeByID(const AConnection: TFDConnection);
    procedure UpdateKundenankaufInDB(const AConnection: TFDConnection);
    procedure CreateAnkaufsformularAsPDF;
  public
    { Public-Deklarationen }
  end;

var
  fAnkaeufe: TfAnkaeufe;
  SELECTEDENTRYID: integer;



implementation

{$R *.dfm}

uses
  uMain, uFunctions, uDBFunctions;



procedure TfAnkaeufe.acDeleteEntryExecute(Sender: TObject);
var
  Idx: Integer;
  ENTRYID: Integer;
begin
  Idx := lvAnkaeufe.ItemIndex;
  if Idx = -1 then
    Exit;

  ENTRYID := StrToIntDef(lvAnkaeufe.Items[Idx].Caption, 0);
  if ENTRYID = 0 then
    Exit;

  if MessageDlg('Wollen Sie diesen Eintrag wirklich löschen?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  // 1 Aus der Datenbanktabelle Kundenankaeufe löschen
  DeleteEntryFromAnkaeufe(fMain.FDConnection1, ENTRYID);

  // 2 Eintrag aus der ListView entfernen
  lvAnkaeufe.Items[Idx].Delete;

  // 3 Nächsten Eintrag automatisch selektieren
  if lvAnkaeufe.Items.Count > 0 then
  begin
    if Idx < lvAnkaeufe.Items.Count then
      lvAnkaeufe.Items[Idx].Selected := True
    else
      lvAnkaeufe.Items[lvAnkaeufe.Items.Count - 1].Selected := True;
  end;
end;







procedure TfAnkaeufe.acDeleteEntryUpdate(Sender: TObject);
var
  i: integer;
begin
  i := lvAnkaeufe.ItemIndex;
  if(i<>-1) then
  begin
    acDeleteEntry.Enabled := true;
  end
  else
  begin
    acDeleteEntry.Enabled := false;
  end;
end;





procedure TfAnkaeufe.btnSaveClick(Sender: TObject);
begin
  UpdateKundenankaufInDB(fMain.FDConnection1);
end;







procedure TfAnkaeufe.UpdateKundenankaufInDB(const AConnection: TFDConnection);
var
  FDQuery: TFDQuery;
  TSGeburtsdatum: Int64;

  TSAnkaufsdatum: Int64;

  ankaufspreis, versandpreis, gesamtpreis: Int64;

  sku, ref, marke, model, bezeichnung, gewicht, einheit: string;
  ankaufsdatum, box, papiere, jahr, savedInInventar: integer;
  zustand, zahlungsart: string;
begin
  if(trim(edSKU.Text) = '') then
  begin
    showmessage('Bitte geben Sie eine SKU ein!');
    edSKU.SetFocus;
    exit;
  end;

  if(trim(edKaufpreis.Text) = '') then
  begin
    showmessage('Bitte geben Sie den Kaufpreis ein!!');
    edKaufpreis.SetFocus;
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
  if(cbSavedInInventar.Checked) then SavedInInventar := 1 else SavedInInventar := 0;

  //Text
  sku          := trim(edSKU.Text);
  ref          := trim(edRef.Text);
  marke        := trim(edMarke.Text);
  model        := trim(edModel.Text);
  bezeichnung  := trim(edBezeichnung.Text);
  gewicht      := trim(edGewicht.Text);
  zustand      := cbZustand.Text;
  zahlungsart  := cbZahlungsarten.Text;

  //Beträge
  ankaufspreis := EditToCentSafe(edKaufpreis);
  versandpreis := EditToCentSafe(edVersand);
  gesamtpreis  := EditToCentSafe(edGesamtpreis);

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
        'Zahlungsart = :ZAHLUNGSART, ' +
        'SavedInInventar = :SAVEDININVENTAR ' +
        'WHERE id = :ID';

      FDQuery.ParamByName('ID').AsInteger  := SELECTEDENTRYID;
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
      FDQuery.ParamByName('SAVEDININVENTAR').AsInteger := SavedInInventar;

      FDQuery.ExecSQL;

      AConnection.Commit;
    except
      AConnection.Rollback;
      raise;
    end;
  finally
    FDQuery.Free;
  end;

  //Eintrag in ListView aktualisieren ohne Daten neun zu laden

  //fMain.LoadInventarToListView; //Einträge aus Datenbank in ListView ausgeben

  CreateAnkaufsformularAsPDF;

  close;
end;







procedure TfAnkaeufe.CreateAnkaufsformularAsPDF;
var
  stltemp: TStringList;
  a, i: integer;
  filename, filenameTemp: string;
  stlHtmlHeader, stlHtmlFooter, stlContent: TStringList;
  resHtmlHeader, resHtmlFooter, resContent: TResourceStream;

  nachname, vorname, strassehausnr, plz, ort: string;
  ankaufsnr, ankaufdatum: string;

  ref, box, papiere, marke, model, jahr, kaufbetrag: string;
  s: string;
  zustand, bezeichnung, gewicht, gesamtbetrag, zahlungsart, sku: string;
  versandbetrag, kurzbezeichnung: string;
begin
  a := lvAnkaeufe.ItemIndex;

  if(a <> -1) then
  begin


    //kundennr := trim(edKundenNr.Text);
    nachname := trim(lvAnkaeufe.Items[a].SubItems[2]);
    vorname := trim(lvAnkaeufe.Items[a].SubItems[3]);
    strassehausnr := trim(lvAnkaeufe.Items[a].SubItems[12]);
    plz := trim(lvAnkaeufe.Items[a].SubItems[13]);
    ort := trim(lvAnkaeufe.Items[a].SubItems[14]);
    ankaufsnr := trim(edSKU.Text);
    ankaufdatum := trim(DateToStr(dtpAnkaufsdatum.Date));

    zustand := trim(cbZustand.Text);
    bezeichnung := trim(edBezeichnung.Text);
    gewicht := trim(edGewicht.Text);
    versandbetrag := trim(edVersand.Text);
    gesamtbetrag := trim(edGesamtpreis.Text);
    kurzbezeichnung := 'Kurzbezeichnung';
    zahlungsart := trim(cbZahlungsarten.Text);
    sku := trim(edSKU.Text);

    ref := trim(edRef.Text);
    if(cbBox.Checked) then box := 'X' else box := '-';
    if(cbPapiere.Checked) then papiere := 'X' else papiere := '-';
    marke := edMarke.Text;
    model := edModel.Text;



    jahr := edJahr.Text;
    kaufbetrag := edKaufpreis.Text;


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


  //CONTENT START
      resContent := TResourceStream.Create(HInstance, 'ANKAUFSFORMULAR_CONTENT', 'TXT');
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


      filenameTemp := 'Ankaufsformular';

//      if(Ankaufformular_LastID > 0) then
        filenameTemp := filenameTemp + '_' + IntToStr(ExtractNumber(sku)); //IntToStr(Ankaufformular_LastID);

      //Dateiname für zu speichernde Datei erzeugen
      if(nachname <> '') then
        if(vorname <> '') then
          filenameTemp := filenameTemp + '_' + nachname + '_' + vorname
        else
          filenameTemp := filenameTemp + '_' + nachname;


     filename := filenameTemp + '_' + FormatDateTime('dd.mm.yyyy', now);

     // filename := 'Ankaufsformular_' + IntToStr(Ankaufformular_LastID) + ' _ ' + edNachname.Text + '_' + edVorname.Text;

      //Aus Resource-Datei temporäre Html-Datei und daraus eine PDF-Datei im TEMP Verzeichnis erzeugen

      CreateHtmlAndPdfFileFromResource(filename, stlTemp);



      //PDF Datei aus Temp Verzeichnis im Zielverzeichnis speichern
     // SpeicherePDFDatei(filename, PATH);
    finally
      stlTemp.Free;
    end;
  end;
end;






procedure TfAnkaeufe.edKaufpreisChange(Sender: TObject);
var
  Kaufpreis, Versand, Gesamt: Double;
  sKaufpreis, sVersand: string;
begin
  // Werte aus den Edit-Feldern auslesen
  Kaufpreis := StrToFloatDef(Trim(edKaufpreis.Text), 0);
  Versand   := StrToFloatDef(Trim(edVersand.Text), 0);

  // Summe berechnen
  Gesamt := Kaufpreis + Versand;

  // Ergebnis anzeigen
  edGesamtpreis.Text := FormatFloat('0.00', Gesamt);
end;







procedure TfAnkaeufe.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    Close;
  end;
end;

procedure TfAnkaeufe.FormShow(Sender: TObject);
begin
  LoadAnkaeufeToListView(fMain.FDConnection1);

  LoadZustaendeFromDB(fMain.FDConnection1, cbZustand);
  LoadZahlungsartenFromDB(fMain.FDConnection1, cbZahlungsarten);

  pnlAnkaeufe.Visible := false;
  SELECTEDENTRYID := 0;
end;




procedure TfAnkaeufe.LoadAnkaeufeToListView(const AConnection: TFDConnection);
var
  Q: TFDQuery;
  Item: TListItem;
  DT: TDateTime;
begin
  lvAnkaeufe.Items.BeginUpdate;
  try
    lvAnkaeufe.Items.Clear;

    Q := TFDQuery.Create(nil);
    try
      Q.Connection := AConnection;
      Q.SQL.Text := 'SELECT A.id, A.SKU, K.KundenNr, K.Nachname, K.Vorname, K.StrasseHausNr, K.PLZ, K.Ort, A.Ankaufsdatum, A.Bezeichnung, ' +
                    'A.Kaufpreis, A.Versand, A.Ref, A.Box, A.Papiere, A.SavedInInventar ' +
                    'FROM kundenankauf A ' +
                    'INNER JOIN kundendaten K ON A.kundenID = K.id ' +
                    'ORDER BY A.SKU DESC';
      Q.Open;

      while not Q.Eof do
      begin
        Item := lvAnkaeufe.Items.Add;
        Item.Caption := Q.FieldByName('id').AsString;
        Item.SubItems.Add(Q.FieldByName('SKU').AsString);
        Item.SubItems.Add(Q.FieldByName('KundenNr').AsString);
        Item.SubItems.Add(Q.FieldByName('Nachname').AsString);
        Item.SubItems.Add(Q.FieldByName('Vorname').AsString);

        // === Ankaufsdatum ===
        DT := UnixToDateTime(Q.FieldByName('Ankaufsdatum').AsLargeInt);
        Item.SubItems.Add(FormatDateTime('dd.mm.yyyy', DT));

        Item.SubItems.Add(Q.FieldByName('Bezeichnung').AsString);
        Item.SubItems.Add(CentToEuro(Q.FieldByName('Kaufpreis').AsLargeInt));
        Item.SubItems.Add(CentToEuro(Q.FieldByName('Versand').AsLargeInt));
        Item.SubItems.Add(Q.FieldByName('Ref').AsString);
        Item.SubItems.Add(Q.FieldByName('Box').AsString);
        Item.SubItems.Add(Q.FieldByName('Papiere').AsString);
        Item.SubItems.Add(Q.FieldByName('SavedInInventar').AsString);

        Item.SubItems.Add(Q.FieldByName('StrasseHausNr').AsString);
        Item.SubItems.Add(Q.FieldByName('PLZ').AsString);
        Item.SubItems.Add(Q.FieldByName('Ort').AsString);

        Q.Next;
      end;
    finally
      Q.Free;
    end;
  finally
    lvAnkaeufe.Items.EndUpdate;
  end;
end;




procedure TfAnkaeufe.LoadAnkaeufeByID(const AConnection: TFDConnection);
var
  Q: TFDQuery;
  i: integer;
  TS: Int64;
  DT: TDateTime;
begin
  i := lvAnkaeufe.ItemIndex;
  if(i<>-1) then
  begin
    pnlAnkaeufe.Visible := true;
    SELECTEDENTRYID := StrToInt(lvAnkaeufe.Items[i].Caption);

    Q := TFDQuery.Create(nil);
    try
      Q.Connection := AConnection;
      Q.SQL.Text := 'SELECT id, Ankaufsdatum, SKU, Ref, Box, Papiere, Marke, Model, ' +
                    'Bezeichnung, Jahr, Kaufpreis, Zustand, Bezeichnung, ' +
                    'Gewicht, Versand, Zahlungsart, SavedInInventar ' +
                    'FROM kundenankauf WHERE id = :ID';
      Q.ParamByName('ID').AsInteger := SELECTEDENTRYID;
      Q.Open;

      if not Q.IsEmpty then
      begin
        //Ankaufsdatum
        TS := Q.FieldByName('Ankaufsdatum').AsLargeInt;
        if TS = 0 then
        begin
          dtpAnkaufsdatum.Date := StrToDate('01.01.1970');
          dtpAnkaufsdatum.Checked := false;
        end
        else
        begin
          DT := UnixToDateTime(TS);
          dtpAnkaufsdatum.Date := DT;
          dtpAnkaufsdatum.Checked := True;
        end;

        //SKU
        edSKU.Text := Q.FieldByName('SKU').AsString;

        //Ref
        edRef.Text := Q.FieldByName('Ref').AsString;

        //Box
        if(Q.FieldByName('Box').AsInteger = 1) then
          cbBox.Checked := true
        else
          cbBox.Checked := false;

        //Papiere
        if(Q.FieldByName('Papiere').AsInteger = 1) then
          cbPapiere.Checked := true
        else
          cbPapiere.Checked := false;

        //Saved in Inventarliste
        if(Q.FieldByName('SavedInInventar').AsInteger = 1) then
          cbSavedInInventar.Checked := true
        else
          cbSavedInInventar.Checked := false;

        //Marke
        edMarke.Text := Q.FieldByName('Marke').AsString;

        //Model
        edModel.Text := Q.FieldByName('Model').AsString;

        //Jahr
        edJahr.Text := Q.FieldByName('Jahr').AsString;

        //Kaufpreis

        //Zustand
        SelectComboBoxItemByText(cbZustand, Q.FieldByName('Zustand').AsString);

        //Bezeichnung
        edBezeichnung.Text := Q.FieldByName('Bezeichnung').AsString;

        //Gwicht
        edGewicht.Text := Q.FieldByName('Gewicht').AsString;

        //Versand
        edVersand.Text := CentToEuro(Q.FieldByName('Versand').AsLargeInt);

        //Zahlungsart
        SelectComboBoxItemByText(cbZahlungsarten, Q.FieldByName('Zahlungsart').AsString);

        //Kaufpreis
        edKaufpreis.Text := CentToEuro(Q.FieldByName('Kaufpreis').AsLargeInt);
      end;
    finally
      Q.Free;
    end;
  end
  else
  begin
    pnlAnkaeufe.Visible := false;
    SELECTEDENTRYID := 0;
  end;
end;





procedure TfAnkaeufe.lvAnkaeufeClick(Sender: TObject);
begin
  LoadAnkaeufeByID(fMain.FDConnection1);
end;





procedure TfAnkaeufe.lvAnkaeufeSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
var
  i: integer;
begin
  i := lvAnkaeufe.ItemIndex;
  if(i <> -1) then
  begin
    lvAnkaeufeClick(nil);
  end;
end;

end.
