unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, sSkinProvider, sSkinManager,
  Vcl.StdCtrls, sLabel, Vcl.ExtCtrls, Clipbrd, sPanel, Vcl.Buttons,
  sBitBtn, System.ImageList, Vcl.ImgList, acAlphaImageList, Vcl.Menus,

  uForms, uMenu.Popup, uMessageBox;

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
    pmCopy: TPopupMenu;
    pmiCopy: TMenuItem;
    procedure tmrRefreshTimer(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure pmiCopyClick(Sender: TObject);
    procedure pmCopyPopup(Sender: TObject);
  private
    { Private declarations }
  public
    FInstallDate: TDateTime;
    FSystemUptime: TDateTime;
    procedure ChangeMessageBoxPosition(var Msg: TMessage); message mbMessage;
    procedure DragForm(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  uAppController, uInstallDate;

procedure TfrmMain.ChangeMessageBoxPosition(var Msg: TMessage);
begin
  UI_ChangeMessageBoxPosition(Self);
end;

procedure TfrmMain.DragForm(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  UI_DragForm(Self, Button);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Self.OnMouseDown := DragForm;

  AppController_Init(Self);
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    AppController_Exit(Self);
end;

procedure TfrmMain.pmCopyPopup(Sender: TObject);
var
  Items: TPopupItems;
begin
  Items := Default(TPopupItems);
  Items.Copy := pmiCopy;
  UI_Menu_Popup_Update(Sender, Items);
end;

procedure TfrmMain.pmiCopyClick(Sender: TObject);
begin
  UI_Menu_Popup_Copy(Sender);
end;

procedure TfrmMain.btnAboutClick(Sender: TObject);
begin
  AppController_About(Self);
end;

procedure TfrmMain.btnExitClick(Sender: TObject);
begin
  AppController_Exit(Self);
end;

procedure TfrmMain.tmrRefreshTimer(Sender: TObject);
begin
  AppController_Refresh(Self);
end;

end.
