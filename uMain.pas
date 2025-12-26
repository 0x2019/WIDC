unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, sSkinProvider, sSkinManager,
  Vcl.StdCtrls, sLabel, Vcl.ExtCtrls, uExt, Clipbrd, sPanel, Vcl.Buttons,
  sBitBtn, System.ImageList, Vcl.ImgList, acAlphaImageList, Vcl.Menus;

const
  mbMessage = WM_USER + 1024;
  APP_NAME    = 'WIDC';
  APP_VERSION = 'v1.0.0.2';
  APP_RELEASE = 'December 26, 2025';
  APP_URL     = 'https://github.com/0x2019/WIDC';

type
  TfrmMain = class(TForm)
    sSkinManager: TsSkinManager;
    sSkinProvider: TsSkinProvider;
    tmrRefresh: TTimer;
    pnlInfo: TsPanel;
    lblIDR: TsLabel;
    lblIDRW: TsLabel;
    lblSUW: TsLabel;
    lblSUR: TsLabel;
    btnAbout: TsBitBtn;
    btnExit: TsBitBtn;
    sCharImageList: TsCharImageList;
    pMWC: TPopupMenu;
    pMWCCopy: TMenuItem;
    procedure tmrRefreshTimer(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure pMWCCopyClick(Sender: TObject);
  private
    procedure ChangeMessageBoxPosition(var Msg: TMessage); message mbMessage;
    procedure WMNCHitTest(var Msg: TWMNCHitTest); message WM_NCHITTEST;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
  xInstallDate: TDateTime;
  xSystemUptime: TDateTime;
  xMsgCaption: PWideChar;

implementation

{$R *.dfm}

procedure TfrmMain.ChangeMessageBoxPosition(var Msg: TMessage);
var
  mbHWND: LongWord;
  mbRect: TRect;
  x, y, w, h: Integer;
begin
  mbHWND := FindWindow(MAKEINTRESOURCE(WC_DIALOG), xMsgCaption);
  if (mbHWND <> 0) then begin
    GetWindowRect(mbHWND, mbRect);
  with mbRect do begin
    w := Right - Left;
    h := Bottom - Top;
  end;
  x := frmMain.Left + ((frmMain.Width - w) div 2);
  if x < 0 then
    x := 0
    else if x + w > Screen.Width then x := Screen.Width - w;
      y := frmMain.Top + ((frmMain.Height - h) div 2);
  if y < 0 then y := 0
    else if y + h > Screen.Height then y := Screen.Height - h;
    SetWindowPos(mbHWND, 0, x, y, 0, 0, SWP_NOACTIVATE or SWP_NOSIZE or SWP_NOZORDER);
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);

  xInstallDate := GetInstallDate;
  xSystemUptime := GetSystemUptimeLocal;

  Constraints.MinWidth := Width;
  Constraints.MinHeight := Height;

  tmrRefresh.Enabled := True;
  tmrRefreshTimer(tmrRefresh);
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

procedure TfrmMain.pMWCCopyClick(Sender: TObject);
var
  pm: TPopupMenu;
  src: TComponent;
  s: string;
begin
  s := '';
  pm := (Sender as TMenuItem).GetParentMenu as TPopupMenu;
  if pm = nil then Exit;

  src := pm.PopupComponent;
  if src = nil then Exit;

  if src is TsLabel then
    s := TsLabel(src).Caption;

  if s <> '' then
    Clipboard.AsText := s;
end;

procedure TfrmMain.WMNCHitTest(var Msg: TWMNCHitTest);
begin
  inherited;
  if Msg.Result = htClient then Msg.Result := htCaption;
end;

procedure TfrmMain.btnAboutClick(Sender: TObject);
begin
  PostMessage(Handle, mbMessage, 0, 0);
  xMsgCaption := '';

  Application.MessageBox(
  APP_NAME + ' ' + APP_VERSION + sLineBreak +
  'c0ded by 龍, written in Delphi.' + sLineBreak + sLineBreak +
  'Release Date: ' + APP_RELEASE + sLineBreak +
  'URL: ' + APP_URL, xMsgCaption, MB_ICONQUESTION);
end;

procedure TfrmMain.btnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.tmrRefreshTimer(Sender: TObject);
begin
  lblIDRW.Caption := GetInstallDateR(xInstallDate);
  lblSUW.Caption := DateTimeToStr(xSystemUptime) + GetSystemUptimeR;
end;

end.
