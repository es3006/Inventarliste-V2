unit uSammelverkaeufe;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, AdvListV, Vcl.StdCtrls,
  Vcl.ExtCtrls, FireDAC.Stan.Param, FireDAC.Phys.SQLite,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Stan.Intf, FireDAC.DApt;

type
  TfSammelverkaeufe = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label4: TLabel;
    lvEdelmetallEinkaeufe: TAdvListView;
    Panel3: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    lbSteuerbetrag: TLabel;
    lbVerkaufswert: TLabel;
    lbVerkaufsdatum: TLabel;
    lbRechnungsNr: TLabel;
    procedure FormShow(Sender: TObject);
  private
    procedure LoadSammelVerkauf(const VerkaufID: integer = 0);
    procedure LoadEinkaeufeToListView(const VerkaufID: integer = 0);
  public
    VERKAUFID: integer;
  end;

var
  fSammelverkaeufe: TfSammelverkaeufe;


implementation

{$R *.dfm}

uses uMain, uMoneyHelper, uSQLiteDateHelper;



procedure TfSammelverkaeufe.FormShow(Sender: TObject);
begin
  LoadSammelVerkauf(VERKAUFID);
  LoadEinkaeufeToListView(VERKAUFID);
end;




procedure TfSammelverkaeufe.LoadSammelVerkauf(const VerkaufID: integer = 0);
var
  Q: TFDQuery;
begin
  if(VerkaufID = 0) then
  begin
    showmessage('Es wurde keine VerkaufsID übergeben!');
    exit;
  end;

  lbRechnungsNr.Caption := '';
  lbVerkaufsdatum.Caption := '';
  lbVerkaufswert.Caption := '';
  lbSteuerbetrag.Caption := '';

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := fMain.FDConnection1;
    Q.SQL.Text := 'SELECT id, RechnungsNr, Verkaufsdatum, Verkaufswert, ' +
                  'Steuerbetrag FROM VerkaufEdelmetall WHERE id = :VERKAUFID';

    Q.ParamByName('VERKAUFID').AsInteger := VerkaufID;
    Q.Open;

    if not Q.IsEmpty then
    begin
      lbRechnungsNr.Caption   := Q.FieldByName('RechnungsNr').AsString;
      lbVerkaufsdatum.Caption := SQLiteDateToDisplay(Q.FieldByName('Verkaufsdatum').AsString);
      lbVerkaufswert.Caption  := Int100ToDecimalString(Q.FieldByName('Verkaufswert').AsLargeInt) + '€';
      lbSteuerbetrag.Caption  := Int100ToDecimalString(Q.FieldByName('Steuerbetrag').AsLargeInt) + '€';
    end;
  finally
    Q.Free;
  end;
end;





procedure TfSammelverkaeufe.LoadEinkaeufeToListView(const VerkaufID: integer = 0);
var
  Q: TFDQuery;
  Item: TListItem;
begin
  if(VerkaufID = 0) then
  begin
    showmessage('Es wurde keine VerkaufID übergeben!');
    exit;
  end;

  lvEdelmetallEinkaeufe.Items.BeginUpdate;
  try
    lvEdelmetallEinkaeufe.Items.Clear;

    Q := TFDQuery.Create(nil);
    try
      Q.Connection := fMain.FDConnection1;
      Q.SQL.Text :=
        'SELECT  K.KundenNr, K.Nachname, K.Vorname, ' +
		    'A.id AS AnkaufID, A.Ankaufsdatum, A.Gesamtpreis, A.Artikelname, ' +
		    'A.Einheit, A.Karat, A.Gewicht ' +
	      'FROM AnkaufEdelmetall AS A ' +
	      'LEFT JOIN kundendaten AS K ON K.id = A.kundenID ' +
	      'WHERE A.verkaufID = :VERKAUFID';

      Q.ParamByName('VERKAUFID').AsInteger := VerkaufID;
      Q.Open;

      while not Q.Eof do
      begin
        Item := lvEdelmetallEinkaeufe.Items.Add;
        Item.Caption := Q.FieldByName('AnkaufID').AsString;
        Item.SubItems.Add(Q.FieldByName('KundenNr').AsString);
        Item.SubItems.Add(Q.FieldByName('Nachname').AsString);
        Item.SubItems.Add(Q.FieldByName('Vorname').AsString);
        Item.SubItems.Add(SQLiteDateToDisplay(Q.FieldByName('Ankaufsdatum').AsString));
        Item.SubItems.Add(Int100ToDecimalString(Q.FieldByName('Gesamtpreis').AsLargeInt) + '€');
        Item.SubItems.Add(Q.FieldByName('Artikelname').AsString);
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




end.
