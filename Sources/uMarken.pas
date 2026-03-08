unit uMarken;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls,
  Vcl.ComCtrls, AdvListV, System.UITypes,
  FireDAC.Stan.Param, FireDAC.Phys.SQLite, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Stan.Intf, FireDAC.DApt;

type
  TfMarken = class(TForm)
    lvMarken: TAdvListView;
    edMarke: TLabeledEdit;
    btnSave: TButton;
    btnNewEntry: TButton;
    btnDelete: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnNewEntryClick(Sender: TObject);
    procedure edMarkeChange(Sender: TObject);
    procedure lvMarkenClick(Sender: TObject);
    procedure lvMarkenKeyPress(Sender: TObject; var Key: Char);
    procedure btnSaveClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
  private
    procedure LoadMarkenFromDB(lv: TAdvListView);
    procedure InsertNewMarke;
    procedure UpdateMarke;
    procedure DeleteMarke;
    function GetSelectedMarkeID: Integer;
    procedure SelectMarkeByID(const AID: Integer);
  public
    { Public-Deklarationen }
  end;

var
  fMarken: TfMarken;

implementation

{$R *.dfm}


uses
  uMain;

procedure TfMarken.LoadMarkenFromDB(lv: TAdvListView);
var
  Q: TFDQuery;
  Item: TListItem;
begin
  lvMarken.Items.BeginUpdate;
  try
    lvMarken.Items.Clear;

    Q := TFDQuery.Create(nil);
    try
      Q.Connection := fMain.FDConnection1;
      Q.SQL.Text := 'SELECT id, Marke FROM marken ORDER BY Marke ASC';
      Q.Open;

      while not Q.Eof do
      begin
        Item := lvMarken.Items.Add;

        Item.Caption := Q.FieldByName('id').AsString;
        Item.SubItems.Add(Q.FieldByName('Marke').AsString);

        Q.Next;
      end;
    finally
      Q.Free;
    end;

  finally
    lvMarken.Items.EndUpdate;
  end;
end;


procedure TfMarken.btnDeleteClick(Sender: TObject);
begin
  if MessageDlg('Wollen Sie diesen Eintrag wirklich löschen?', mtConfirmation, [mbYes, mbNo], 0 ) = mrYes then
  begin
    DeleteMarke;
  end;
end;

procedure TfMarken.btnNewEntryClick(Sender: TObject);
begin
  lvMarken.ItemIndex := -1;
  edMarke.Clear;
  btnSave.Enabled := false;
  btnSave.Caption := 'Hinzufügen';
  btnDelete.Visible := false;

  edMarke.SetFocus;
end;

procedure TfMarken.edMarkeChange(Sender: TObject);
var
  s: string;
begin
  s := trim(edMarke.Text);

  if(s<>'') then
  begin
    btnSave.Enabled := true;
  end
  else
  begin
    btnSave.Enabled := false;
  end;
end;




procedure TfMarken.FormShow(Sender: TObject);
begin
  LoadMarkenFromDB(lvMarken);
end;

procedure TfMarken.lvMarkenClick(Sender: TObject);
var
  i: integer;
begin
  i := lvMarken.ItemIndex;

  if(i<>-1) then
  begin
    edMarke.Text := lvMarken.Items[i].SubItems[0];
    btnSave.Caption := 'Speichern';
    btnDelete.Enabled := true;
    btnDelete.Visible := true;
  end
  else
  begin
    edMarke.Clear;
    btnSave.Caption := 'Hinzufügen';
    btnDelete.Enabled := false;
    btnDelete.Visible := false;
  end;
end;




procedure TfMarken.lvMarkenKeyPress(Sender: TObject; var Key: Char);
var
  SelectedID: Integer;
begin
  if lvMarken.Selected = nil then Exit;

  SelectedID := GetSelectedMarkeID;

  // Nach Neuladen wieder selektieren
  SelectMarkeByID(SelectedID);
end;






procedure TfMarken.InsertNewMarke;
var
  marke: string;
  i: integer;
  FDQuery: TFDQuery;
  Item: TListItem;
begin
  // ===== Validierungen =====
  if Trim(edMarke.Text) = '' then
  begin
    ShowMessage('Bitte geben Sie den Markennamen ein!');
    Exit;
  end;

  i := lvMarken.Items.Count-1;

  // ===== Werte übernehmen =====
  marke  := Trim(edMarke.Text);

  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;

    FDQuery.SQL.Text := 'INSERT INTO marken (Marke) VALUES (:MARKE)';

    fMain.FDConnection1.StartTransaction;
    try
      FDQuery.ParamByName('MARKE').AsString  := marke;
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
  LoadMarkenFromDB(lvMarken);


  // ===== zum neu eingefügten Eintrag springem ======
  Item := lvMarken.Items[lvMarken.Items.Count - 1];
  lvMarken.Selected := Item;
  Item.Focused := True;
  Item.MakeVisible(false);


  lvMarken.SetFocus;
end;




procedure TfMarken.UpdateMarke;
var
  ID, marke: string;
  i: integer;
  FDQuery: TFDQuery;
begin
  i := lvMarken.ItemIndex;
  if(i = -1) then
  begin
    showmessage('Bitte wählen Sie den zu ändernden Eintrag');
    exit;
  end;

  ID := lvMarken.Items[i].Caption;


  // ===== Validierungen =====
  if Trim(edMarke.Text) = '' then
  begin
    ShowMessage('Bitte geben Sie einen Markennaen ein!');
    Exit;
  end;

  // ===== Werte übernehmen =====
  marke  := Trim(edMarke.Text);

  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;

    FDQuery.SQL.Text := 'UPDATE marken set Marke = :MARKE WHERE id = :ID';

    fMain.FDConnection1.StartTransaction;
    try
      FDQuery.ParamByName('ID').AsInteger := StrToInt(ID);
      FDQuery.ParamByName('MARKE').AsString  := marke;
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
  LoadMarkenFromDB(lvMarken);
  btnSave.Enabled := false;

  btnNewEntryClick(self);
end;











procedure TfMarken.btnSaveClick(Sender: TObject);
var
  i: integer;
begin
  i := lvMarken.ItemIndex;

  if(i<>-1) then
  begin
    UpdateMarke;
    btnDelete.Visible := false;
    btnDelete.Enabled := false;
  end
  else
  begin
    InsertNewMarke;
    btnDelete.Visible := true;
    btnDelete.Enabled := true;
    btnSave.Caption := 'Speichern';
  end;
end;





procedure TfMarken.DeleteMarke;
var
  ID: string;
  i: integer;
  FDQuery: TFDQuery;
begin
  i := lvMarken.ItemIndex;
  if(i = -1) then
  begin
    showmessage('Bitte wählen Sie den zu löschenden Eintrag');
    exit;
  end;

  ID := lvMarken.Items[i].Caption;

  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;

    FDQuery.SQL.Text := 'DELETE FROM marken WHERE id = :ID';

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
  LoadMarkenFromDB(lvMarken);
  btnSave.Enabled := false;
  btnDelete.Enabled := false;
  lvMarken.ItemIndex := -1;
  edMarke.Clear;
  btnSave.Caption := 'Hinzufügen';
end;




function TfMarken.GetSelectedMarkeID: Integer;
begin
  Result := -1;
  if lvMarken.Selected <> nil then
    Result := StrToInt(lvMarken.Selected.Caption);
end;




procedure TfMarken.SelectMarkeByID(const AID: Integer);
var
  i: Integer;
  Item: TListItem;
begin
  if AID < 0 then Exit;

  for i := 0 to lvMarken.Items.Count - 1 do
  begin
    Item := lvMarken.Items[i];
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
