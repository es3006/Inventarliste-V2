unit uEinheiten;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls,
  Vcl.ComCtrls, AdvListV, System.UITypes,
  FireDAC.Stan.Param, FireDAC.Phys.SQLite, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Stan.Intf, FireDAC.DApt;

type
  TfEinheiten = class(TForm)
    lvEinheiten: TAdvListView;
    edEinheit: TLabeledEdit;
    btnSave: TButton;
    btnNewEntry: TButton;
    btnDelete: TButton;
    edPosition: TLabeledEdit;
    procedure FormShow(Sender: TObject);
    procedure lvEinheitenKeyPress(Sender: TObject; var Key: Char);
    procedure btnNewEntryClick(Sender: TObject);
    procedure lvEinheitenClick(Sender: TObject);
    procedure edEinheitChange(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    procedure LoadEinheitenFromDB(lv: TAdvListView);
    function GetSelectedEinheitenID: Integer;
    procedure SelectEinheitByID(const AID: Integer);
    procedure InsertNewEinheit;
    procedure UpdateEinheit;
    procedure DeleteEinheit;
  public
    { Public-Deklarationen }
  end;

var
  fEinheiten: TfEinheiten;

implementation

{$R *.dfm}


uses
  uMain;



procedure TfEinheiten.btnDeleteClick(Sender: TObject);
begin
  if MessageDlg(
     'Wollen Sie diesen Eintrag wirklich löschen?',
     mtConfirmation,
     [mbYes, mbNo],
     0
   ) = mrYes then
  begin
    DeleteEinheit;
  end;
end;

procedure TfEinheiten.btnNewEntryClick(Sender: TObject);
begin
  lvEinheiten.ItemIndex := -1;
  edPosition.Clear;
  edEinheit.Clear;
  btnSave.Enabled := false;
  btnSave.Caption := 'Hinzufügen';
  btnDelete.Visible := false;

  edEinheit.SetFocus;
end;





procedure TfEinheiten.btnSaveClick(Sender: TObject);
var
  i: integer;
begin
  i := lvEinheiten.ItemIndex;

  if(i<>-1) then
  begin
    UpdateEinheit;
    btnDelete.Visible := false;
    btnDelete.Enabled := false;
  end
  else
  begin
    InsertNewEinheit;
    btnDelete.Visible := true;
    btnDelete.Enabled := true;
    btnSave.Caption := 'Speichern';
  end;
end;





procedure TfEinheiten.InsertNewEinheit;
var
  einheit: string;
  i, position: integer;
  FDQuery: TFDQuery;
  Item: TListItem;
begin
  // ===== Validierungen =====
  if Trim(edPosition.Text) = '' then
  begin
    ShowMessage('Bitte geben Sie die Position für die Sortierung ein');
    Exit;
  end;

  if Trim(edEinheit.Text) = '' then
  begin
    ShowMessage('Bitte geben Sie die Einheit ein!');
    Exit;
  end;

  i := lvEinheiten.Items.Count-1;

  // ===== Werte übernehmen =====
  einheit  := Trim(edEinheit.Text);
  position := StrToInt(Trim(edPosition.Text));

  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;

    FDQuery.SQL.Text := 'INSERT INTO einheiten (position, einheit) VALUES (:POSITION, :EINHEIT)';

    fMain.FDConnection1.StartTransaction;
    try
      FDQuery.ParamByName('POSITION').AsInteger := position;
      FDQuery.ParamByName('EINHEIT').AsString  := einheit;
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
  LoadEinheitenFromDB(lvEinheiten);


  // ===== zum neu eingefügten Eintrag springem ======
  Item := lvEinheiten.Items[lvEinheiten.Items.Count - 1];
  lvEinheiten.Selected := Item;
  Item.Focused := True;
  Item.MakeVisible(false);


  lvEinheiten.SetFocus;
end;






procedure TfEinheiten.UpdateEinheit;
var
  ID, einheit: string;
  i, position: integer;
  FDQuery: TFDQuery;
begin
  i := lvEinheiten.ItemIndex;
  if(i = -1) then
  begin
    showmessage('Bitte wählen Sie den zu ändernden Eintrag');
    exit;
  end;

  ID := lvEinheiten.Items[i].Caption;


  // ===== Validierungen =====
   if Trim(edPosition.Text) = '' then
  begin
    ShowMessage('Bitte geben Sie die Position für die Sortierung ein!');
    Exit;
  end;

  if Trim(edEinheit.Text) = '' then
  begin
    ShowMessage('Bitte geben Sie die Einheit ein!');
    Exit;
  end;

  // ===== Werte übernehmen =====
  position  := StrToInt(Trim(edPosition.Text));
  einheit  := Trim(edEinheit.Text);

  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;

    FDQuery.SQL.Text := 'UPDATE einheiten set position = :POSITION, einheit = :EINHEIT WHERE id = :ID';

    fMain.FDConnection1.StartTransaction;
    try
      FDQuery.ParamByName('ID').AsInteger := StrToInt(ID);
      FDQuery.ParamByName('POSITION').AsInteger  := position;
      FDQuery.ParamByName('EINHEIT').AsString  := einheit;
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
  LoadEinheitenFromDB(lvEinheiten);
  btnSave.Enabled := false;
  btnNewEntryClick(nil);
end;




procedure TfEinheiten.DeleteEinheit;
var
  ID: string;
  i: integer;
  FDQuery: TFDQuery;
begin
  i := lvEinheiten.ItemIndex;
  if(i = -1) then
  begin
    showmessage('Bitte wählen Sie den zu löschenden Eintrag');
    exit;
  end;

  ID := lvEinheiten.Items[i].Caption;

  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;

    FDQuery.SQL.Text := 'DELETE FROM einheiten WHERE id = :ID';

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
  LoadEinheitenFromDB(lvEinheiten);
  btnSave.Enabled := false;
  btnDelete.Enabled := false;
  lvEinheiten.ItemIndex := -1;
  edPosition.Clear;
  edEinheit.Clear;
  btnSave.Caption := 'Hinzufügen';
end;



procedure TfEinheiten.edEinheitChange(Sender: TObject);
var
  s: string;
begin
  s := trim(edEinheit.Text);

  if(s<>'') then
  begin
    btnSave.Enabled := true;
  end
  else
  begin
    btnSave.Enabled := false;
  end;
end;




procedure TfEinheiten.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    Close;
  end;
end;

procedure TfEinheiten.FormShow(Sender: TObject);
begin
  LoadEinheitenFromDB(lvEinheiten);
end;





procedure TfEinheiten.LoadEinheitenFromDB(lv: TAdvListView);
var
  Q: TFDQuery;
  Item: TListItem;
begin
  lvEinheiten.Items.BeginUpdate;
  try
    lvEinheiten.Items.Clear;

    Q := TFDQuery.Create(nil);
    try
      Q.Connection := fMain.FDConnection1;
      Q.SQL.Text := 'SELECT id, position, Einheit FROM einheiten ORDER BY position ASC';
      Q.Open;

      while not Q.Eof do
      begin
        Item := lvEinheiten.Items.Add;

        Item.Caption := Q.FieldByName('id').AsString;
        Item.SubItems.Add(Q.FieldByName('position').AsString);
        Item.SubItems.Add(Q.FieldByName('Einheit').AsString);

        Q.Next;
      end;
    finally
      Q.Free;
    end;

  finally
    lvEinheiten.Items.EndUpdate;
  end;
end;






procedure TfEinheiten.lvEinheitenClick(Sender: TObject);
var
  i: integer;
begin
  i := lvEinheiten.ItemIndex;

  if(i<>-1) then
  begin
    edPosition.Text := lvEinheiten.Items[i].SubItems[0];
    edEinheit.Text := lvEinheiten.Items[i].SubItems[1];
    btnSave.Caption := 'Speichern';
    btnDelete.Enabled := true;
    btnDelete.Visible := true;
  end
  else
  begin
    edPosition.Clear;
    edEinheit.Clear;
    btnSave.Caption := 'Hinzufügen';
    btnDelete.Enabled := false;
    btnDelete.Visible := false;
  end;
end;






procedure TfEinheiten.lvEinheitenKeyPress(Sender: TObject; var Key: Char);
var
  SelectedID: Integer;
begin
  if lvEinheiten.Selected = nil then Exit;

  SelectedID := GetSelectedEinheitenID;

  // Nach Neuladen wieder selektieren
  SelectEinheitByID(SelectedID);
end;








function TfEinheiten.GetSelectedEinheitenID: Integer;
begin
  Result := -1;
  if lvEinheiten.Selected <> nil then
    Result := StrToInt(lvEinheiten.Selected.Caption);
end;


procedure TfEinheiten.SelectEinheitByID(const AID: Integer);
var
  i: Integer;
  Item: TListItem;
begin
  if AID < 0 then Exit;

  for i := 0 to lvEinheiten.Items.Count - 1 do
  begin
    Item := lvEinheiten.Items[i];
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
