unit uZahlungsarten;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls,
  Vcl.ComCtrls, AdvListV, System.UITypes,
  FireDAC.Stan.Param, FireDAC.Phys.SQLite, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Stan.Intf, FireDAC.DApt;

type
  TfZahlungsarten = class(TForm)
    lvZahlungsarten: TAdvListView;
    edZahlungsart: TLabeledEdit;
    btnSave: TButton;
    btnNewEntry: TButton;
    btnDelete: TButton;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure btnNewEntryClick(Sender: TObject);
    procedure lvZahlungsartenClick(Sender: TObject);
    procedure lvZahlungsartenKeyPress(Sender: TObject; var Key: Char);
    procedure edZahlungsartChange(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    procedure LoadZahlungsartenFromDB(lv: TAdvListView);
    procedure InsertNewZahlungsart;
    procedure UpdateZahlungsart;
    procedure DeleteZahlungsart;
    function GetSelectedZahlungsartID: Integer;
    procedure SelectZahlungsartByID(const AID: Integer);
  public
    { Public-Deklarationen }
  end;

var
  fZahlungsarten: TfZahlungsarten;

implementation

{$R *.dfm}

uses
  uMain;


procedure TfZahlungsarten.btnDeleteClick(Sender: TObject);
begin
    if MessageDlg(
     'Wollen Sie diesen Eintrag wirklich löschen?',
     mtConfirmation,
     [mbYes, mbNo],
     0
   ) = mrYes then
  begin
    DeleteZahlungsart;
  end;
end;





procedure TfZahlungsarten.btnNewEntryClick(Sender: TObject);
begin
  lvZahlungsarten.ItemIndex := -1;
  edZahlungsart.Clear;
  btnSave.Enabled := false;
  btnSave.Caption := 'Hinzufügen';
  btnDelete.Visible := false;

  edZahlungsart.SetFocus;
end;





procedure TfZahlungsarten.btnSaveClick(Sender: TObject);
var
  i: integer;
begin
  i := lvZahlungsarten.ItemIndex;

  if(i<>-1) then
  begin
    UpdateZahlungsart;
    btnDelete.Visible := false;
    btnDelete.Enabled := false;
  end
  else
  begin
    InsertNewZahlungsart;
    btnDelete.Visible := true;
    btnDelete.Enabled := true;
    btnSave.Caption := 'Speichern';
  end;
end;





procedure TfZahlungsarten.edZahlungsartChange(Sender: TObject);
var
  s: string;
begin
  s := trim(edZahlungsart.Text);

  if(s<>'') then
  begin
    btnSave.Enabled := true;
  end
  else
  begin
    btnSave.Enabled := false;
  end;
end;




procedure TfZahlungsarten.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    Close;
  end;
end;




procedure TfZahlungsarten.FormShow(Sender: TObject);
begin
  LoadZahlungsartenFromDB(lvZahlungsarten);
end;



procedure TfZahlungsarten.LoadZahlungsartenFromDB(lv: TAdvListView);
var
  Q: TFDQuery;
  Item: TListItem;
begin
  lvZahlungsarten.Items.BeginUpdate;
  try
    lvZahlungsarten.Items.Clear;

    Q := TFDQuery.Create(nil);
    try
      Q.Connection := fMain.FDConnection1;
      Q.SQL.Text := 'SELECT id, Zahlungsart FROM zahlungsarten ORDER BY Zahlungsart ASC';
      Q.Open;

      while not Q.Eof do
      begin
        Item := lvZahlungsarten.Items.Add;

        Item.Caption := Q.FieldByName('id').AsString;
        Item.SubItems.Add(Q.FieldByName('Zahlungsart').AsString);

        Q.Next;
      end;
    finally
      Q.Free;
    end;

  finally
    lvZahlungsarten.Items.EndUpdate;
  end;
end;

procedure TfZahlungsarten.lvZahlungsartenClick(Sender: TObject);
var
  i: integer;
begin
  i := lvZahlungsarten.ItemIndex;

  if(i<>-1) then
  begin
    edZahlungsart.Text := lvZahlungsarten.Items[i].SubItems[0];
    btnSave.Caption := 'Speichern';
    btnDelete.Enabled := true;
    btnDelete.Visible := true;
  end
  else
  begin
    edZahlungsart.Clear;
    btnSave.Caption := 'Hinzufügen';
    btnDelete.Enabled := false;
    btnDelete.Visible := false;
  end;
end;




procedure TfZahlungsarten.lvZahlungsartenKeyPress(Sender: TObject; var Key: Char);
var
  SelectedID: Integer;
begin
  if lvZahlungsarten.Selected = nil then Exit;

  SelectedID := GetSelectedZahlungsartID;

  // Nach Neuladen wieder selektieren
  SelectZahlungsartByID(SelectedID);
end;






procedure TfZahlungsarten.InsertNewZahlungsart;
var
  zahlungsart: string;
  i: integer;
  FDQuery: TFDQuery;
  Item: TListItem;
begin
  // ===== Validierungen =====
  if Trim(edZahlungsart.Text) = '' then
  begin
    ShowMessage('Bitte geben Sie die Zahlungsart ein!');
    Exit;
  end;

  i := lvZahlungsarten.Items.Count-1;

  // ===== Werte übernehmen =====
  zahlungsart  := Trim(edZahlungsart.Text);

  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;

    FDQuery.SQL.Text := 'INSERT INTO zahlungsarten (Zahlungsart) VALUES (:ZAHLUNGSART)';

    fMain.FDConnection1.StartTransaction;
    try
      FDQuery.ParamByName('ZAHLUNGSART').AsString  := zahlungsart;
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
  LoadZahlungsartenFromDB(lvZahlungsarten);


  // ===== zum neu eingefügten Eintrag springem ======
  Item := lvZahlungsarten.Items[lvZahlungsarten.Items.Count - 1];
  lvZahlungsarten.Selected := Item;
  Item.Focused := True;
  Item.MakeVisible(false);


  lvZahlungsarten.SetFocus;
end;




procedure TfZahlungsarten.UpdateZahlungsart;
var
  ID, zahlungsart: string;
  i: integer;
  FDQuery: TFDQuery;
begin
  i := lvZahlungsarten.ItemIndex;
  if(i = -1) then
  begin
    showmessage('Bitte wählen Sie den zu ändernden Eintrag');
    exit;
  end;

  ID := lvZahlungsarten.Items[i].Caption;


  // ===== Validierungen =====
  if Trim(edZahlungsart.Text) = '' then
  begin
    ShowMessage('Bitte geben Sie die Zahlungsart ein!');
    Exit;
  end;

  // ===== Werte übernehmen =====
  zahlungsart  := Trim(edZahlungsart.Text);

  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;

    FDQuery.SQL.Text := 'UPDATE zahlungsarten set Zahlungsart = :ZAHLUNGSART WHERE id = :ID';

    fMain.FDConnection1.StartTransaction;
    try
      FDQuery.ParamByName('ID').AsInteger := StrToInt(ID);
      FDQuery.ParamByName('ZAHLUNGSART').AsString  := zahlungsart;
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
  LoadZahlungsartenFromDB(lvZahlungsarten);
  btnSave.Enabled := false;

  btnNewEntryClick(nil);
end;











procedure TfZahlungsarten.DeleteZahlungsart;
var
  ID: string;
  i: integer;
  FDQuery: TFDQuery;
begin
  i := lvZahlungsarten.ItemIndex;
  if(i = -1) then
  begin
    showmessage('Bitte wählen Sie den zu löschenden Eintrag');
    exit;
  end;

  ID := lvZahlungsarten.Items[i].Caption;

  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;

    FDQuery.SQL.Text := 'DELETE FROM zahlungsarten WHERE id = :ID';

    fMain.FDConnection1.StartTransaction;
    try
      FDQuery.ParamByName('ID').AsInteger := StrToInt(ID);
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
  LoadZahlungsartenFromDB(lvZahlungsarten);
  btnSave.Enabled := false;
  btnDelete.Enabled := false;
  lvZahlungsarten.ItemIndex := -1;
  edZahlungsart.Clear;
  btnSave.Caption := 'Hinzufügen';
end;




function TfZahlungsarten.GetSelectedZahlungsartID: Integer;
begin
  Result := -1;
  if lvZahlungsarten.Selected <> nil then
    Result := StrToInt(lvZahlungsarten.Selected.Caption);
end;




procedure TfZahlungsarten.SelectZahlungsartByID(const AID: Integer);
var
  i: Integer;
  Item: TListItem;
begin
  if AID < 0 then Exit;

  for i := 0 to lvZahlungsarten.Items.Count - 1 do
  begin
    Item := lvZahlungsarten.Items[i];
    if StrToInt(Item.Caption) = AID then
    begin
      Item.Selected := True;
      Item.Focused  := True;
      Item.MakeVisible(False);
      Break;
    end;
  end;
end;



end.
