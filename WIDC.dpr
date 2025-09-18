program WIDC;

uses
  Vcl.Forms,
  Winapi.Windows,
  uMain in 'uMain.pas' {frmMain},
  uExt in 'uExt.pas';

var
  uMutex: THandle;

{$O+} {$SetPEFlags IMAGE_FILE_RELOCS_STRIPPED}
{$R *.res}

begin
  uMutex := CreateMutex(nil, True, 'WIDC!');
  if (uMutex <> 0 ) and (GetLastError = 0) then begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
  if uMutex <> 0 then
    CloseHandle(uMutex);
  end;
end.