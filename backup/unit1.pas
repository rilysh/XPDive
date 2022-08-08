unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, Registry, LCLType, Windows;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CheckBox10Change(Sender: TObject);
    procedure CheckBox11Change(Sender: TObject);
    procedure CheckBox12Change(Sender: TObject);
    procedure CheckBox13Change(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
    procedure CheckBox4Change(Sender: TObject);
    procedure CheckBox5Change(Sender: TObject);
    procedure CheckBox6Change(Sender: TObject);
    procedure CheckBox7Change(Sender: TObject);
    procedure CheckBox8Change(Sender: TObject);
    procedure CheckBox9Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton2Change(Sender: TObject);
    procedure RadioButton3Change(Sender: TObject);
    procedure RadioButton4Change(Sender: TObject);
    procedure StaticText4Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  Reg : TRegistry;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Image1Click(Sender: TObject);
begin
  Application.MessageBox('XPDive....You clicked...', 'XPDive', MB_ICONINFORMATION + MB_OK);
end;

procedure TForm1.RadioButton1Change(Sender: TObject);
begin
  Button1.Enabled := true;
  Button2.Enabled := true;
end;

procedure TForm1.RadioButton2Change(Sender: TObject);
begin
  Button1.Enabled := true;
  Button2.Enabled := true;
end;

procedure TForm1.RadioButton3Change(Sender: TObject);
begin
  Button1.Enabled := true;
  Button2.Enabled := true;
end;

procedure TForm1.RadioButton4Change(Sender: TObject);
begin
  Button1.Enabled := true;
  Button2.Enabled := true;
end;

procedure TForm1.StaticText4Click(Sender: TObject);
begin
  ShellExecute(nil, nil, 'https://youtu.be/xvFZjo5PgG0', nil, nil, SW_HIDE);
end;

{ Original Author: GetMem, Function: "ByeWindows" (Original: "WindowsExit"), taken from: https://forum.lazarus.freepascal.org/index.php/topic,7136.msg193908.html#msg193908 }
procedure ByeWindows(RebootParam: Longword);
var
  TTokenHd: THandle;
  TTokenPvg: TTokenPrivileges;
  cbtpPrevious: DWORD;
  rTTokenPvg: TTokenPrivileges;
  pcbtpPreviousRequired: DWORD;
  tpResult: Boolean;
const
  SE_SHUTDOWN_NAME = 'SeShutdownPrivilege';
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    tpResult := OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, TTokenHd);
    if tpResult then
    begin
      tpResult := LookupPrivilegeValue(nil, SE_SHUTDOWN_NAME, TTokenPvg.Privileges[0].Luid);
      TTokenPvg.PrivilegeCount := 1;
      TTokenPvg.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      cbtpPrevious := SizeOf(rTTokenPvg) ;
      pcbtpPreviousRequired := 0;
      if tpResult then
        Windows.AdjustTokenPrivileges(TTokenHd, False, TTokenPvg, cbtpPrevious, rTTokenPvg, pcbtpPreviousRequired);
     end;
   end;
  ExitWindowsEx(RebootParam, 0);
end;


procedure AddToImageFile(app: string; ischecked: boolean);
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  if Reg.OpenKey('SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\' + app, true) = false then
  begin
    Reg.CreateKey(app);
  end;
  if ischecked = true then
  begin
    Reg.WriteString('Debugger', '/');
  end
  else
  begin
    Reg.WriteString('Debugger', '');
  end;
end;

procedure ChangeService(name: string; ischecked: boolean);
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  try
     Reg.OpenKey('SYSTEM\CurrentControlSet\Services\' + name, true);
  except
     Application.MessageBox('Failed to open registry', 'Error', MB_ICONERROR + MB_OK);
  end;
  if ischecked = true then
  begin
    Reg.WriteInteger('Start', 4);
    Reg.CloseKey;
  end;
  if ischecked = false then
  begin
    Reg.WriteInteger('Start', 3);
  end
end;

procedure WriteConfig(fn: string; isenabled: boolean);
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_CURRENT_USER;
  try
     if Reg.OpenKey('Software\XPDive', true) = false then
     begin
       Reg.CreateKey('XPDive');
     end;
     if isenabled = true then
     begin
       Reg.WriteInteger(fn, 1);
     end
     else
     begin
       Reg.WriteInteger(fn, 0);
     end;
  finally
  end;
end;

procedure TForm1.CheckBox4Change(Sender: TObject);
begin
  if CheckBox4.Checked = true then
  begin
    AddToImageFile('wscript.exe', true);
    WriteConfig('CheckBox4', true);
  end
  else
  begin
    AddToImageFile('wscript.exe', false);
    WriteConfig('CheckBox4', false);
  end
end;

procedure TForm1.CheckBox5Change(Sender: TObject);
begin
  if CheckBox4.Checked = true then
  begin
    AddToImageFile('bcdedit.exe', true);
    WriteConfig('CheckBox5', true);
  end
  else
  begin
    AddToImageFile('bcdedit.exe', false);
    WriteConfig('CheckBox5', false);
  end
end;

procedure TForm1.CheckBox6Change(Sender: TObject);
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_CURRENT_USER;
  try
     if Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Policies\System', true) = false then
     begin
       Reg.CreateKey('System');
     end;
  except
     Application.MessageBox('Failed to open registry', 'Error', MB_ICONERROR + MB_OK);
  end;
  if CheckBox6.Checked = true then
  begin
    Reg.WriteInteger('DisableTaskMgr', 1);
    WriteConfig('CheckBox6', true);
  end
  else
  begin
    Reg.WriteInteger('DisableTaskMgr', 0);
    WriteConfig('CheckBox6', false);
  end
end;

procedure TForm1.CheckBox2Change(Sender: TObject);
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_CURRENT_USER;
  try
     if Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Policies\System', true) = false then
     begin
       Reg.CreateKey('System');
     end;
  except
     Application.MessageBox('Failed to open registry', 'Error', MB_ICONERROR + MB_OK);
  end;
  begin
    if CheckBox2.Checked = true then
    begin
      Reg.WriteInteger('DisableRegistryTools', 1);
      WriteConfig('CheckBox2', true);
    end
    else
    begin
      Reg.WriteInteger('DisableRegistryTools', 0);
      WriteConfig('CheckBox2', false);
    end
  end
end;

procedure TForm1.CheckBox3Change(Sender: TObject);
begin
  if CheckBox3.Checked = true then
  begin
    AddToImageFile('diskpart.exe', true);
    WriteConfig('CheckBox3', true);
  end
  else
  begin
    AddToImageFile('diskpart.exe', false);
    WriteConfig('CheckBox3', false);
  end;
end;

procedure TForm1.CheckBox1Change(Sender: TObject);
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_CURRENT_USER;
  try
     if Reg.OpenKey('Software\Policies\Microsoft\Windows\System', true) = false then
     begin
       Reg.CreateKey('Windows\System');
     end;
  except
     Application.MessageBox('Failed to open registry', 'Error', MB_ICONERROR + MB_OK);
  end;
  begin
    if CheckBox1.Checked = true then
    begin
      Reg.WriteInteger('DisableCMD', 1);
      WriteConfig('CheckBox1', true);
    end
    else
    begin
      Reg.WriteInteger('DisableCMD', 0);
      WriteConfig('CheckBox1', false);
    end
  end
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if RadioButton1.Checked = true then
  begin
    ByeWindows(EWX_REBOOT or EWX_FORCE);
  end
  else if RadioButton2.Checked = true then
  begin
    ByeWindows(EWX_SHUTDOWN or EWX_FORCE);
  end
  else if RadioButton3.Checked = true then
  begin
    ByeWindows(EWX_POWEROFF or EWX_FORCE);
  end
  else if RadioButton4.Checked = true then
  begin
    Application.MessageBox('Under construction, check back later!', 'Under Construction', MB_ICONINFORMATION + MB_OK);
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  RadioButton1.Checked := false;
  RadioButton2.Checked := false;
  RadioButton3.Checked := false;
  RadioButton4.Checked := false;
  Button1.Enabled := false;
  Button2.Enabled := false;
end;

procedure TForm1.CheckBox10Change(Sender: TObject);
begin
   if CheckBox10.Checked = true then
  begin
    ChangeService('RemoteRegistry', true);
    WriteConfig('CheckBox10', true);
  end
  else
  begin
    ChangeService('RemoteRegistry', false);
    WriteConfig('CheckBox10', false);
  end;
end;

procedure TForm1.CheckBox11Change(Sender: TObject);
begin
  if CheckBox11.Checked = true then
  begin
    ChangeService('RemoteAccess', true);
    WriteConfig('CheckBox11', true);
  end
  else
  begin
    ChangeService('RemoteAccess', false);
    WriteConfig('CheckBox11', false);
  end;
end;

procedure TForm1.CheckBox12Change(Sender: TObject);
begin
  if CheckBox12.Checked = true then
  begin
    ChangeService('W32Time', true);
    WriteConfig('CheckBox12', true);
  end
  else
  begin
    ChangeService('W32Time', false);
    WriteConfig('CheckBox12', false);
  end;
end;

procedure TForm1.CheckBox13Change(Sender: TObject);
begin
  if CheckBox13.Checked = true then
  begin
    ChangeService('wuauserv', true);
    WriteConfig('CheckBox13', true);
  end
  else
  begin
    ChangeService('wuauserv', false);
    WriteConfig('CheckBox13', false);
  end;
end;

procedure TForm1.CheckBox7Change(Sender: TObject);
begin
  if CheckBox7.Checked = true then
  begin
    AddToImageFile('mountvol.exe', true);
    WriteConfig('CheckBox7', true);
  end
  else
  begin
    AddToImageFile('mountvol.exe', false);
    WriteConfig('CheckBox7', false);
  end
end;

procedure TForm1.CheckBox8Change(Sender: TObject);
begin
   if CheckBox4.Checked = true then
  begin
    AddToImageFile('cscript.exe', true);
    WriteConfig('CheckBox8', true);
  end
  else
  begin
    AddToImageFile('cscript.exe', false);
    WriteConfig('CheckBox8', false);
  end
end;

procedure TForm1.CheckBox9Change(Sender: TObject);
begin
  if CheckBox4.Checked = true then
  begin
    AddToImageFile('gpedit.msc', true);
    WriteConfig('CheckBox9', true);
  end
  else
  begin
    AddToImageFile('gpedit.msc', false);
    WriteConfig('CheckBox9', false);
  end
end;

procedure CheckRegValue(name: string; component: TCheckBox);
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_CURRENT_USER;
  if Reg.OpenKey('Software\XPDive', true) = true then
  begin
    try
     if Reg.ReadInteger(name) = 1 then
     begin
       component.Checked := true;
     end;
     if Reg.ReadInteger(name) = 0 then
     begin
       component.Checked := false;
     end;
    except
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Button1.Enabled := false;
  Button2.Enabled := false;
  CheckRegValue('CheckBox1', CheckBox1);
  CheckRegValue('CheckBox2', CheckBox2);
  CheckRegValue('CheckBox3', CheckBox3);
  CheckRegValue('CheckBox4', CheckBox4);
  CheckRegValue('CheckBox5', CheckBox5);
  CheckRegValue('CheckBox6', CheckBox6);
  CheckRegValue('CheckBox7', CheckBox7);
  CheckRegValue('CheckBox8', CheckBox8);
  CheckRegValue('CheckBox9', CheckBox9);
  CheckRegValue('CheckBox10', CheckBox10);
  CheckRegValue('CheckBox11', CheckBox11);
  CheckRegValue('CheckBox12', CheckBox12);
  CheckRegValue('CheckBox13', CheckBox13);
end;


end.

