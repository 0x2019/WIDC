unit uAppController;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Forms, uMain;

procedure AppController_Init(AForm: TfrmMain);
procedure AppController_Refresh(AForm: TfrmMain);

procedure AppController_About(AForm: TfrmMain);
procedure AppController_Exit(AForm: TfrmMain);

implementation

uses
  uForms, uMessageBox,
  uAppStrings, uInstallDate;

procedure AppController_Init(AForm: TfrmMain);
begin
  if AForm = nil then Exit;

  UI_SetAlwaysOnTop(AForm, True);
  UI_SetMinConstraints(AForm);

  AForm.FInstallDate := GetInstallDate;
  AForm.FSystemUptime := GetSystemUptimeLocal;

  AForm.tmrRefresh.Enabled := True;
  AppController_Refresh(AForm);
end;

procedure AppController_Refresh(AForm: TfrmMain);
begin
  if AForm = nil then Exit;

  AForm.lblIDRW.Caption := GetInstallDateR(AForm.FInstallDate);
  AForm.lblSUW.Caption := DateTimeToStr(AForm.FSystemUptime) + GetSystemUptimeR;
end;

procedure AppController_About(AForm: TfrmMain);
begin
  if AForm = nil then Exit;
  UI_MessageBox(AForm, Format(SAboutMsg, [APP_NAME, APP_VERSION, APP_RELEASE, APP_URL]), MB_ICONQUESTION or MB_OK);
end;

procedure AppController_Exit(AForm: TfrmMain);
begin
  if AForm = nil then Exit;
  AForm.Close;
end;

end.
