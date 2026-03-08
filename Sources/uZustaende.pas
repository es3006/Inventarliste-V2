unit uZustaende;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls,
  Vcl.ComCtrls, AdvListV, System.UITypes,
  FireDAC.Stan.Param, FireDAC.Phys.SQLite, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Stan.Intf, FireDAC.DApt;


type
  TfZustaende = class(TForm)
    lvZustaende: TAdvListView;
    edZustand: TLabeledEdit;
    btnSave: TButton;
    btnNewEntry: TButton;
    btnDelete: TButton;
    edPosition: TLabeledEdit;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure edZustandChange(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnNewEntryClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure lvZustaendeClick(Sender: TObject);
    procedure lvZustaendeKeyPress(Sender: TObject; var Key: Char);
  private
    procedure LoadZustaendeFromDB(lv: TAdvListView);
    function GetSelectedZustandID: Integer;
    procedure SelectZustandByID(const AID: Integer);
    procedure InsertNewZustand;
    procedure UpdateZustand;
    procedure DeleteZustand;
  public
    { Public-Deklarationen }
  end;

var
  fZustaende: TfZustaende;

implementation

{$R *.dfm}

uses
  uMain;




procedure TfZustaende.SelectZustandByID(const AID: Integer);
var
  i: Integer;
  Item: TListItem;
begin
  if AID < 0 then Exit;

  for i := 0 to lvZustaende.Items.Count - 1 do
  begin
    Item := lvZustaende.Items[i];
    if StrToInt(Item.Caption) = AID then
    begin
      Item.Selected := True;
      Item.Focused  := True;
      Item.MakeVisible(False);
      Break;
    end;
  end;
end;





procedure TfZustaende.btnDeleteClick(Sender: TObject);
begin
  if MessageDlg(
     'Wollen Sie diesen Eintrag wirklich löschen?',
     mtConfirmation,
     [mbYes, mbNo],
     0
   ) = mrYes then
  begin
    DeleteZustand;
  end;
end;




procedure TfZustaende.btnNewEntryClick(Sender: TObject);
begin
  lvZustaende.ItemIndex := -1;
  edPosition.Clear;
  edZustand.Clear;
  btnSave.Enabled := false;
  btnSave.Caption := 'Hinzufügen';
  btnDelete.Visible := false;

  edZustand.SetFocus;
end;






procedure TfZustaende.DeleteZustand;
var
  ID: string;
  i: integer;
  FDQuery: TFDQuery;
begin
  i := lvZustaende.ItemIndex;
  if(i = -1) then
  begin
    showmessage('Bitte wählen Sie den zu löschenden Eintrag');
    exit;
  end;

  ID := lvZustaende.Items[i].Caption;

  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;

    FDQuery.SQL.Text := 'DELETE FROM zustaende WHERE id = :ID';

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
  LoadZustaendeFromDB(lvZustaende);
  btnSave.Enabled := false;
  btnDelete.Enabled := false;
  lvZustaende.ItemIndex := -1;
  edZustand.Clear;
  btnSave.Caption := 'Hinzufügen';
end;






procedure TfZustaende.btnSaveClick(Sender: TObject);
var
  i: integer;
begin
  i := lvZustaende.ItemIndex;

  if(i<>-1) then
  begin
    UpdateZustand;
    btnDelete.Visible := false;
    btnDelete.Enabled := false;
  end
  else
  begin
    InsertNewZustand;
    btnDelete.Visible := true;
    btnDelete.Enabled := true;
    btnSave.Caption := 'Speichern';
  end;
end;






procedure TfZustaende.InsertNewZustand;
var
  zustand: string;
  i, position: integer;
  FDQuery: TFDQuery;
  Item: TListItem;
begin
  // ===== Validierungen =====
  if Trim(edPosition.Text) = '' then
  begin
    ShowMessage('Bitte geben Sie die Position für die Sortierung an!');
    Exit;
  end;

  if Trim(edZustand.Text) = '' then
  begin
    ShowMessage('Bitte geben Sie den Zustand ein!');
    Exit;
  end;

  i := lvZustaende.Items.Count-1;

  // ===== Werte übernehmen =====
  position := StrToInt(Trim(edPosition.Text));
  zustand  := Trim(edZustand.Text);

  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;

    FDQuery.SQL.Text := 'INSERT INTO zustaende (position, Zustand) VALUES (:POSITION, :ZUSTAND)';

    fMain.FDConnection1.StartTransaction;
    try
      FDQuery.ParamByName('POSITION').AsInteger := position;
      FDQuery.ParamByName('ZUSTAND').AsString  := zustand;
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
  LoadZustaendeFromDB(lvZustaende);


  // ===== zum neu eingefügten Eintrag springem ======
  Item := lvZustaende.Items[lvZustaende.Items.Count - 1];
  lvZustaende.Selected := Item;
  Item.Focused := True;
  Item.MakeVisible(false);


  lvZustaende.SetFocus;
end;




procedure TfZustaende.UpdateZustand;
var
  ID, zustand: string;
  i, position: integer;
  FDQuery: TFDQuery;
begin
  i := lvZustaende.ItemIndex;
  if(i = -1) then
  begin
    showmessage('Bitte wählen Sie den zu ändernden Eintrag');
    exit;
  end;

  ID := lvZustaende.Items[i].Caption;


  // ===== Validierungen =====
  if Trim(edZustand.Text) = '' then
  begin
    ShowMessage('Bitte geben Sie den Zustand ein!');
    Exit;
  end;

  // ===== Werte übernehmen =====
  position := StrToInt(trim(edPosition.Text));
  zustand  := Trim(edZustand.Text);

  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;

    FDQuery.SQL.Text := 'UPDATE zustaende set position = :POSITION, Zustand = :ZUSTAND WHERE id = :ID';

    fMain.FDConnection1.StartTransaction;
    try
      FDQuery.ParamByName('ID').AsInteger := StrToInt(ID);
      FDQuery.ParamByName('POSITION').AsInteger  := position;
      FDQuery.ParamByName('ZUSTAND').AsString  := zustand;
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
  LoadZustaendeFromDB(lvZustaende);
  btnSave.Enabled := false;


  btnNewEntryClick(nil);
end;





procedure TfZustaende.edZustandChange(Sender: TObject);
var
  s: string;
begin
  s := trim(edZustand.Text);

  if(s<>'') then
  begin
    btnSave.Enabled := true;
  end
  else
  begin
    btnSave.Enabled := false;
  end;
end;




procedure TfZustaende.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    Close;
  end;
end;

procedure TfZustaende.FormShow(Sender: TObject);
begin
  LoadZustaendeFromDB(lvZustaende);
end;



procedure TfZustaende.LoadZustaendeFromDB(lv: TAdvListView);
var
  Q: TFDQuery;
  Item: TListItem;
begin
  lvZustaende.Items.BeginUpdate;
  try
    lvZustaende.Items.Clear;

    Q := TFDQuery.Create(nil);
    try
      Q.Connection := fMain.FDConnection1;
      Q.SQL.Text := 'SELECT id, position, Zustand FROM zustaende ORDER BY Position ASC';
      Q.Open;

      while not Q.Eof do
      begin
        Item := lvZustaende.Items.Add;

        Item.Caption := Q.FieldByName('id').AsString;
        Item.SubItems.Add(Q.FieldByName('position').AsString);
        Item.SubItems.Add(Q.FieldByName('Zustand').AsString);

        Q.Next;
      end;
    finally
      Q.Free;
    end;

  finally
    lvZustaende.Items.EndUpdate;
  end;
end;



procedure TfZustaende.lvZustaendeClick(Sender: TObject);
var
  i: integer;
begin
  i := lvZustaende.ItemIndex;

  if(i<>-1) then
  begin
    edPosition.Text := lvZustaende.Items[i].SubItems[0];
    edZustand.Text := lvZustaende.Items[i].SubItems[1];
    btnSave.Caption := 'Speichern';
    btnDelete.Enabled := true;
    btnDelete.Visible := true;
  end
  else
  begin
    edPosition.Clear;
    edZustand.Clear;
    btnSave.Caption := 'Hinzufügen';
    btnDelete.Enabled := false;
    btnDelete.Visible := false;
  end;
end;





procedure TfZustaende.lvZustaendeKeyPress(Sender: TObject; var Key: Char);
var
  SelectedID: Integer;
begin
  if lvZustaende.Selected = nil then Exit;

  SelectedID := GetSelectedZustandID;

  // Nach Neuladen wieder selektieren
  SelectZustandByID(SelectedID);
end;










function TfZustaende.GetSelectedZustandID: Integer;
begin
  Result := -1;
  if lvZustaende.Selected <> nil then
    Result := StrToInt(lvZustaende.Selected.Caption);
end;





end.
