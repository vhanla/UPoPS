{
UPoPS - UPlay Prince of Persia Sands of Time Settings Tool v 1.0
Author: vhanla

This is a tool specially crafted to be used with the
Ubisoft Prince of Persia The Sands of Time released as part
of its 30th anniversary. Yaay!

Since this old game doesn't support widescreen monitors and doesn't offer
changing language within its UI options itself either. I wrote this small
tool to make it easier to make some unofficial adjustments.

It requires patching POP.exe file to achieve a widescreen monitor support
and on tweak to Hardware.ini file.

Special thanks to Universal Widescreen Patcher and PCGamingWiki tips.

}
unit main;

interface

uses
  Windows, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls,
  ExtCtrls, verificador, StrUtils, Inifiles, ShellApi, md5;

type

  { TForm1 }

  TForm1 = class(TForm)
    Image1: TImage;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    edPath: TEdit;
    btnSearch: TButton;
    Label1: TLabel;
    OpenDialog1: TOpenDialog;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edWidth: TEdit;
    edHeight: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    btnRestore: TButton;
    btnPatch: TButton;
    Label8: TLabel;
    cbLangs: TComboBox;
    Label9: TLabel;
    btnLang: TButton;
    GroupBox4: TGroupBox;
    Label10: TLabel;
    ckSkip: TCheckBox;
    ckFixUI: TCheckBox;
    ckFogs: TCheckBox;
    btnSaveExtra: TButton;
    Label11: TLabel;
    btnLaunch: TButton;
    procedure btnSearchClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnPatchClick(Sender: TObject);
    procedure btnRestoreClick(Sender: TObject);
    procedure btnLangClick(Sender: TObject);
    procedure btnSaveExtraClick(Sender: TObject);
    procedure btnLaunchClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GroupBox2Click(Sender: TObject);
  private
    { Private declarations }
    pathoffset : Integer;
    procedure CheckFileSignate(filename: string);
    function FindSignature(const fn: string): Integer;
    function PatchFile(const fn: string): Boolean;
    procedure ListLanguages;
    function isVideosSkipped:Boolean;
    procedure SkipVideos(skip: boolean = true);
    procedure ReadIni;
    procedure OpenAll;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}



procedure TForm1.btnSearchClick(Sender: TObject);
begin
  OpenDialog1.Filter := 'Prince of Persia executable|pop.exe';
  if OpenDialog1.Execute then
  begin
    edPath.Text := OpenDialog1.FileName;

    OpenAll;
  end;
end;

procedure TForm1.btnRestoreClick(Sender: TObject);
begin
  edWidth.Text := '640';
  edHeight.Text := '480';
  btnPatchClick(Sender);
end;

procedure TForm1.btnPatchClick(Sender: TObject);
begin
  PatchFile(OpenDialog1.FileName);
  OpenAll;
end;

procedure TForm1.btnLangClick(Sender: TObject);
var
  dpath, spath: string;
begin
  Screen.Cursor:=crHourGlass;
  dpath := ExtractFilePath(OpenDialog1.FileName);
  spath := dpath + 'support\inst\data\' + cbLangs.Text + '\';
  if (cbLangs.Text <> '')
  and DirectoryExists(dpath)
  and DirectoryExists(spath) then
  begin

    CopyFile(PChar(spath+'soundlocal.fat'), PChar(dpath+'Sound\soundlocal.fat'), false);
    CopyFile(PChar(spath+'soundlocal.big'), PChar(dpath+'Sound\soundlocal.big'), false);
    CopyFile(PChar(spath+'Loading.int'), PChar(dpath+'Video\Loading.int'), false);
    CopyFile(PChar(spath+'Readme.txt'), PChar(dpath+'Readme.txt'), false);
    CopyFile(PChar(spath+'Manual.pdf'), PChar(dpath+'Manual.pdf'), false);
    CopyFile(PChar(spath+'Licence.txt'), PChar(dpath+'Licence.txt'), false);
    CopyFile(PChar(spath+'POPLauncherRes.DLL'), PChar(dpath+'POPLauncherRes.DLL'), false);
    CopyFile(PChar(spath+'POPData.BF'), PChar(dpath+'POPData.BF'), false);

    MessageDlg('New language applied',mtInformation,[mbOK],0);
  end;
  Screen.Cursor:=crDefault;
end;

procedure TForm1.btnSaveExtraClick(Sender: TObject);
  function FileSetReadOnly(const fn: string; readmode: boolean):boolean;
  var
//    attrs, newattrs: Word;
    hres: Integer;
  begin
    try
      if readmode then
        hres := FileSetAttr(fn, FileGetAttr(fn) or faReadOnly)
      else
        hres := FileSetAttr(fn, FileGetAttr(fn) and not faReadOnly);
      {attrs := FileGetAttr(fn);
      newattrs:=attrs;
      if readmode then
         newattrs := newattrs or faReadOnly
      else
         newattrs := newattrs and not faReadOnly;

      if newattrs <> attrs then
        hres := FileSetAttr(fn, attrs)
      else hres := 1; // just accept it as is, so as if it was applied}

      if hres = 0 then
         result := True
      else
         result := False;

    except
      on E: Exception do
         Result := False;
    end;
  end;

var
  ini: TIniFile;
  attr: Integer;
  hardini: String;
  errors: boolean;
begin
  errors:= False;
  SkipVideos(ckSkip.Checked);
  hardini := ExtractFilePath(OpenDialog1.FileName)+'Hardware.ini';
  //attr := FileGetAttr(hardini);

  //if attr and faReadOnly > 0 then
  if FileIsReadOnly(hardini) then
  begin
    //Sleep(100);
    if not FileSetReadOnly(hardini, false) then
    begin
      MessageDlg('Hardware.ini file is readonly, couldn''t save these options. Please try again!',
        mtError, [mbOK], 0);
      Exit; // something failed, we need to figure out later if this was due to unwriteable directory (CD, permission, etc).
    end;
  end;

  ini := TIniFile.Create(hardini);
  try
    ini.WriteBool('CAPS','CanStretchRect', ckFixUI.Checked);
    ini.WriteBool('CAPS','ForceVSFog', ckFogs.Checked);
    ini.WriteBool('CAPS','InvertFogRange', not ckFogs.Checked);

    if ckFixUI.Checked or ckFogs.Checked then
    begin
      if not FileSetReadOnly(hardini, true) then
      begin
        errors := True;
        MessageDlg('Hardware.ini couldn''t be changed to readonly. Please try again!',
                mtError, [mbOK], 0);
      end;
    end;
  finally
    ini.Free;
  end;
  if not errors then
  MessageDlg('Extra options applied correctly',mtInformation,[mbOK],0);
end;

procedure TForm1.btnLaunchClick(Sender: TObject);
var
  launchr: string;
begin
  launchr := ExtractFilePath(OpenDialog1.FileName) + 'PrinceOfPersia.EXE';

  if FileExists(launchr) then
  begin
    ShellExecute(0, 'OPEN', PChar(launchr), nil, nil, SW_SHOWNORMAL);
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  if btnLaunch.Enabled then
     btnLaunch.SetFocus;
end;

procedure TForm1.GroupBox2Click(Sender: TObject);
begin

end;

procedure TForm1.CheckFileSignate(filename: string);
var
  stream: TStringStream;
  ms: TMemoryStream;
  p1,p2: Pointer;
  x, size, gap: Integer;
  locations: string;
begin
  ms := TMemoryStream.Create;
  try
    ms.LoadFromFile(filename);
    p1 := ms.Memory;
    locations := '';
    size := ms.Size;
    repeat
      p2 := Pointer(SearchBuf(PChar(p1), size, 0, 0, #0, [soDown]));
      if p2 <> nil then
      begin
        gap := Integer(p2) - Integer(p1) + 1;
        dec(Size, Gap);
        p1 := Pointer(Integer(P2)+1);

        x := Integer(p2) - Integer(ms.Memory);
        locations := locations + IntToStr(x)+ ' ';
      end;
    until p2 = nil;
  finally
    ms.Free;
  end;
  ShowMessage(locations);
end;

// finds the signature and returns the position, otherwise it returns 0
function TForm1.FindSignature(const fn: string): Integer;
var
  Buffer: array[0..4095] of byte;
  SourceFile: File;
  BinaryBytesRead, TotalBytesRead, I: Integer;
  FoundOnce: Boolean;
  DecryptedValue: Word;
begin
  Result := 0;
  BinaryBytesRead := 0;
  TotalBytesRead := 0;
  I := 0;
  FoundOnce := False;
  Buffer[0] := 0;
  FillChar(Buffer, SizeOf(Buffer), 0); // Clear the buffer
  if FileExists(fn) then
  begin
    AssignFile(SourceFile, fn);
    Reset(SourceFile, 1);
    try
      repeat
        BlockRead(SourceFile, Buffer, SizeOf(Buffer), BinaryBytesRead);
        Inc(TotalBytesRead, BinaryBytesRead);
        Application.ProcessMessages;

        for I := 0 to BinaryBytesRead - 15 do
        begin
          if FoundOnce then Continue;

          if buffer[I+0] <> $3D then continue;
          //if buffer[I+1] <> $80 then continue; // this can be any thing if patched of course
          //if buffer[I+2] <> $02 then continue; // this can be any thing if patched of course
          if buffer[I+3] <> $00 then continue;
          if buffer[I+4] <> $00 then continue;
          if buffer[I+5] <> $75 then continue;
          if buffer[I+6] <> $0A then continue;
          if buffer[I+7] <> $81 then continue;
          if buffer[I+8] <> $7C then continue;
          if buffer[I+9] <> $24 then continue;
          if buffer[I+10] <> $1C then continue;
          //if buffer[I+11] <> $E0 then continue; // this can be any thing if patched of course
          //if buffer[I+12] <> $01 then continue; // this can be any thing if patched of course
          if buffer[I+13] <> $00 then continue;
          if buffer[I+14] <> $00 then continue;

          //ShowMessage('Found at Hex offset ' + IntToHex(TotalBytesRead - BinaryBytesRead + I, 8)
          //+ #13 + #10 + 'Found at Dec offset ' + inttostr (TotalBytesRead - BinaryBytesRead + I));
          Label8.Caption := 'Offset: 0x'+IntToHex(TotalBytesRead - BinaryBytesRead + I, 8);
          pathoffset := TotalBytesRead - BinaryBytesRead + I;
          WordRec(DecryptedValue).Lo :=  Buffer[I+1];
          WordRec(DecryptedValue).Hi :=  Buffer[I+2];
          edWidth.Text := IntToStr(DecryptedValue);
          WordRec(DecryptedValue).Lo :=  Buffer[I+11];
          WordRec(DecryptedValue).Hi :=  Buffer[I+12];
          edHeight.Text := IntToStr(DecryptedValue);
          if (Buffer[I+1] = $80)
          and (Buffer[I+2] = $02)
          and (Buffer[I+11] = $E0)
          and (Buffer[I+12] = $01)
          then
            btnRestore.Enabled := False
          else
            btnRestore.Enabled := True;

          FoundOnce := True;
        end;

      until (BinaryBytesRead < 15);
    finally
      CloseFile(SourceFile);
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Position := poScreenCenter;
  label3.Caption := 'Current main monitor resolution: '+IntToStr(Screen.Width)+'x'+IntToStr(Screen.Height);

  GroupBox2.Enabled := False;
  GroupBox3.Enabled := False;
  GroupBox4.Enabled := False;
  btnLaunch.Enabled := False;

  if FileExists(ExtractFilePath(ParamStr(0))+'POP.EXE') then
  begin
    OpenDialog1.FileName := ExtractFilePath(ParamStr(0))+'POP.EXE';
    edPath.Text := OpenDialog1.FileName;

    OpenAll;
  end;

end;

function TForm1.isVideosSkipped: Boolean;
var
  vpath: string;
begin
  Result := False;
  vpath := ExtractFilePath(OpenDialog1.FileName) + 'Video\';
  if FileExists(vpath + 'Bink.int_') or
  FileExists(vpath + 'Intro.int_') or
  FileExists(vpath + 'poplogo.int_') or
  FileExists(vpath + 'ubisoft.int_') then Result := True;
end;

procedure TForm1.ListLanguages;
var
  sr: TSearchRec;
  res: Integer;
  FileHash, tmpHash: String;
  I: Integer;
begin
  cbLangs.Items.Clear;
  cbLangs.Items.BeginUpdate;

  res := FindFirst(ExtractFilePath(OpenDialog1.FileName) + 'support\inst\data\*.*', faAnyFile, sr);
  if res = 0 then
  try
    while res = 0 do
    begin
      if (sr.Attr and faDirectory = faDirectory)
      and (sr.Name <> '.') and (sr.Name <> '..') then
        cbLangs.Items.Add(sr.Name);
      res := FindNext(sr);
    end;
  finally
    FindClose(sr);
  end;

  // let's check which one is active
  // checking the smalles file to copy/replace Licence.txt 8KB
  if FileExists(ExtractFilePath(OpenDialog1.FileName) + 'Licence.txt') then
  begin
    FileHash:=MD5Print(MD5File(ExtractFilePath(OpenDialog1.FileName) + 'Licence.txt'));

    for I := 0 to cbLangs.Items.Count - 1 do
    begin
      tmpHash:=MD5Print(MD5File(ExtractFilePath(OpenDialog1.FileName) + 'Support\inst\data\' + cbLangs.Items[i] + '\Licence.txt'));
      if tmpHash = FileHash then
      begin
        cbLangs.Text:=cbLangs.Items[i];
        Break;
      end;
    end;

  end;

  cbLangs.Items.EndUpdate;
end;

procedure TForm1.OpenAll;
var
  st: string;
begin
    st := 'different file or might be already patched';
    if iscodesigned(OpenDialog1.FileName) then
    begin
      st := ' Signed by '+GetCertCompanyName(OpenDialog1.FileName);
    end;

    Label2.Caption := 'POP.EXE status: ' + st;

    FindSignature(OpenDialog1.FileName);

    ListLanguages;
    ckSkip.Checked := isVideosSkipped;
    ReadIni;

    GroupBox2.Enabled := True;
    GroupBox3.Enabled := True;
    GroupBox4.Enabled := True;
    btnLaunch.Enabled := True;
end;

function TForm1.PatchFile(const fn: string): Boolean;
var
  f: File;
  l: LongInt;
  w,h: Word;
begin
  Result := False;
  AssignFile(f, fn);
  Reset(f, 1);
  Application.ProcessMessages;
  Seek(f, pathoffset+1);
  w := StrToInt(edWidth.Text);
  BlockWrite(f, w, SizeOf(w));
  h := StrToInt(edHeight.Text);
  Seek(f, pathoffset+11);
  BlockWrite(f, h, SizeOf(h));
  CloseFile(f);
  MessageDlg('Successfully Patched',mtInformation,[mbOK],0);
end;

procedure TForm1.ReadIni;
var
  ini: TIniFile;
  hardini: String;
begin
  hardini := ExtractFilePath(OpenDialog1.FileName)+'Hardware.ini';

  ini := TIniFile.Create(hardini);
  try
    ckFixUI.Checked := ini.ReadBool('CAPS','CanStretchRect',false);
    ckFogs.Checked := ini.ReadBool('CAPS','ForceVSFog',false)
                  and not ini.ReadBool('CAPS','InvertFogRange',false);
  finally
    ini.Free;
  end;

end;

procedure TForm1.SkipVideos(skip: boolean = true);
var
  vpath: string;
  appen: string;
  prepen: string;
begin
  vpath := ExtractFilePath(OpenDialog1.FileName) + 'Video\';

  if skip then
  begin
    appen := '_';
    prepen := '';
  end
  else
  begin
    appen := '';
    prepen := '_';
  end;

  RenameFile(vpath + 'Bink.int' + prepen, vpath + 'Bink.int' + appen);
  RenameFile(vpath + 'Intro.int' + prepen, vpath + 'Intro.int' + appen);
  RenameFile(vpath + 'poplogo.int' + prepen, vpath + 'poplogo.int' + appen);
  RenameFile(vpath + 'ubisoft.int' + prepen, vpath + 'ubisoft.int' + appen);

end;

end.
