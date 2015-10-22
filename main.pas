unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Menus, Buttons, StdCtrls, UTools, UFigures, LCLType;

type

  { TFormPaint }

  TFormPaint = class(TForm)
    BtnClear: TButton;
    MainMenu1: TMainMenu;
    ButtonClear: TButton;
    Size: TLabel;
    Sizechange: TComboBox;
    MenuAbout: TMenuItem;
    MenuExit: TMenuItem;
    PaintBox: TPaintBox;
    Panel: TPanel;
    Settings: TPanel;
    procedure BClick(Sender: TObject);
    procedure BtnClearClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MenuAboutClick(Sender: TObject);
    procedure SizechangeSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuExitClick(Sender: TObject);
    procedure PaintBoxPaint(Sender: TObject);
  private
    Buttons:array of TBitBtn;
  public
    { public declarations }
  end;

var
  FormPaint:TFormPaint;
implementation
{$R *.lfm}

{ TFormPaint }
procedure TFormPaint.MenuExitClick(Sender: TObject);
begin
  FormPaint.Close;
end;

procedure TFormPaint.BClick(Sender: TObject);
var
  Btn:TBitBtn;
begin
  Btn:=(Sender as TBitBtn);
  PaintBox.OnMouseDown:=@Tools[Btn.Tag].MouseDown;
  PaintBox.OnMouseUp:=@Tools[Btn.Tag].MouseUp;
  PaintBox.OnMouseMove:=@Tools[Btn.Tag].MouseMove;
end;

procedure TFormPaint.BtnClearClick(Sender: TObject);
  begin
    if FlagMouse then begin
      FlagMouse:=not FlagMouse;
      PaintBox.OnMouseUp(Nil,TMouseButton.mbRight,[],0,0);
  end;
  setlength(Figures,0);
  PaintBox.Invalidate;
end;

procedure TFormPaint.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (key=VK_Z) and (length(Figures)>0) then
  begin
    if FlagMouse then
      begin
        FlagMouse:=not FlagMouse;
        PaintBox.OnMouseUp(Nil,TMouseButton.mbRight,[],0,0);
      end;
    setlength(Figures,length(Figures)-1);
    PaintBox.Invalidate;
  end;
  if (key=VK_SHIFT) then
    FlagShift:=true;
end;

procedure TFormPaint.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (key=VK_SHIFT) then
    FlagShift:=false;
end;

procedure TFormPaint.MenuAboutClick(Sender: TObject);
begin
  showmessage('Графический редактор. Бездетко Герман Б8103а-1. 2015 год.');
end;
procedure TFormPaint.SizechangeSelect(Sender: TObject);
begin
  SizePen:=Strtoint(Sizechange.Text);
end;

procedure TFormPaint.FormCreate(Sender: TObject);
var
  i:integer;
begin
  Sizechange.OnSelect(Sizechange);
  setlength(Buttons,length(tools));
  for i:=0 to high(tools) do begin
    Buttons[i]:=tools[i].CreateBtn(i,self);
    Buttons[i].Parent:=Panel;
    Buttons[i].OnClick:=@BClick;
  end;
  Buttons[0].Click;
end;

procedure TFormPaint.PaintBoxPaint(Sender: TObject);
var
  i:integer;
begin
  PaintBox.Canvas.Brush.Color:=clWhite;
  PaintBox.Canvas.Brush.Style:=bsSolid;
  PaintBox.Canvas.FillRect(0,0,FormPaint.Width,FormPaint.Height);
  PaintBox.Canvas.Brush.Style:=bsClear;
  for i:=0 to High(Figures) do
    Figures[i].Draw(PaintBox.Canvas);
end;
end.

