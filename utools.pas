unit UTools;
{$mode objfpc}{$H+}
interface

uses
  Classes, Forms, Controls, SysUtils, Dialogs, UFigures, ExtCtrls, Graphics, Buttons, Math;

type
  TTool = Class
    function CreateBtn(i:integer;Sender:TObject):TBitBtn;
    procedure MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual; abstract;
    procedure MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual; abstract;
    procedure MouseMove(Sender: TObject;Shift: TShiftState; X, Y: Integer); virtual; abstract;
  end;
  TToolClass = class of TTool;
  TToolPen = Class(TTool)
    procedure MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Sender: TObject;Shift: TShiftState; X, Y: Integer); override;
  end;
  TToolLine = Class(TTool)
    procedure MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Sender: TObject;Shift: TShiftState; X, Y: Integer); override;
  end;
  TToolPolyLine = Class(TTool)
    procedure MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Sender: TObject;Shift: TShiftState; X, Y: Integer); override;
  end;
  TToolRect = Class(TTool)
    procedure MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Sender: TObject;Shift: TShiftState; X, Y: Integer); override;
  end;
  TToolEllipse = Class(TTool)
    procedure MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Sender: TObject;Shift: TShiftState; X, Y: Integer); override;
  end;
  TToolRoundRect = Class(TTool)
    procedure MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Sender: TObject;Shift: TShiftState; X, Y: Integer); override;
  end;

var
  Tools:array of TTool;
  FlagMouse:Boolean;
  FlagShift:Boolean;
  SizePen:Integer;
implementation

procedure RegisterBtn(ABtn:TToolClass);
begin
  SetLength(Tools,Length(Tools)+1);
  Tools[high(Tools)]:=ABtn.Create;
end;

function TTool.CreateBtn(i:integer;Sender:TObject):TBitBtn;
begin
  Result:=TBitBtn.Create(Sender as TComponent);
  with (Result) do
  begin
    Left:=8+70*(i div 3);
    Top:=20+70*(i mod 3);
    Width:=50;
    Height:=50;
    Tag:=i;
    Glyph.LoadFromFile(inttostr(i)+'.bmp');
  end;
end;

Procedure TToolPen.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=true;
  SetLength(Figures,Length(Figures)+1);
  Figures[High(Figures)]:=UFigures.TPen.Create;
  Figures[High(Figures)].SizePen:=SizePen;
end;

Procedure TToolPen.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=false;
end;

Procedure TToolPen.MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer);
begin
  if FlagMouse then begin
    SetLength(Figures[High(Figures)].Points,Length(Figures[High(Figures)].Points)+1);
    Figures[High(Figures)].Points[High(Figures[High(Figures)].Points)].x:=X;
    Figures[High(Figures)].Points[High(Figures[High(Figures)].Points)].y:=Y;
    (Sender as TPaintBox).Invalidate;
  end;
end;

Procedure TToolLine.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=true;
  SetLength(Figures,Length(Figures)+1);
  Figures[High(Figures)]:=TLine.Create;
  SetLength(Figures[High(Figures)].Points,1);
  Figures[High(Figures)].Points[0].x:=X;
  Figures[High(Figures)].Points[0].y:=Y;
  Figures[High(Figures)].SizePen:=SizePen;
end;

Procedure TToolLine.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=false;
  if Length(Figures[High(Figures)].Points)<2 then SetLength(Figures,Length(Figures)-1);
end;

Procedure TToolLine.MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer);
begin
  if FlagMouse then begin
    SetLength(Figures[High(Figures)].Points,2);
    Figures[High(Figures)].Points[1].x:=X;
    Figures[High(Figures)].Points[1].y:=Y;
    (Sender as TPaintBox).Invalidate;
  end;
end;

Procedure TToolPolyLine.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i:integer;
begin
  if not FlagMouse then begin
    FlagMouse:=true;
    SetLength(Figures,Length(Figures)+1);
    Figures[High(Figures)]:=TPolyLine.Create;
    Figures[High(Figures)].SizePen:=SizePen;
    SetLength(Figures[High(Figures)].Points,Length(Figures[High(Figures)].Points)+1);
  end;
  Figures[High(Figures)].Points[High(Figures[High(Figures)].Points)].x:=X;
  Figures[High(Figures)].Points[High(Figures[High(Figures)].Points)].y:=Y;
  SetLength(Figures[High(Figures)].Points,Length(Figures[High(Figures)].Points)+1);
  Figures[High(Figures)].Points[High(Figures[High(Figures)].Points)].x:=X;
  Figures[High(Figures)].Points[High(Figures[High(Figures)].Points)].y:=Y;
end;

Procedure TToolPolyLine.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if button=TMouseButton.mbRight then begin
    FlagMouse:=false;
    exit;
  end;
end;

Procedure TToolPolyLine.MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer);
var
  i:integer;
begin
  if FlagMouse then begin
    Figures[High(Figures)].Points[High(Figures[High(Figures)].Points)].x:=X;
    Figures[High(Figures)].Points[High(Figures[High(Figures)].Points)].y:=Y;
    (Sender as TPaintBox).Invalidate;
  end;
end;

Procedure TToolRoundRect.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=true;
  SetLength(Figures,Length(Figures)+1);
  Figures[High(Figures)]:=TRoundRect.Create;
  SetLength(Figures[High(Figures)].Points,1);
  Figures[High(Figures)].Points[0].x:=X;
  Figures[High(Figures)].Points[0].y:=Y;
  Figures[High(Figures)].SizePen:=SizePen;
end;

Procedure TToolRoundRect.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=false;
  if Length(Figures[High(Figures)].Points)<2 then SetLength(Figures,Length(Figures)-1);
end;

Procedure TToolRoundRect.MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer);
begin
  if FlagMouse then begin
    SetLength(Figures[High(Figures)].Points,2);
    Figures[High(Figures)].Points[1].x:=X;
    Figures[High(Figures)].Points[1].y:=Y;
    with Figures[High(Figures)] do
    if FlagShift then
      Points[1].y:=Points[0].y+sign((Points[0].y-Y)*(Points[0].x-X))*(X-Points[0].x);
    (Sender as TPaintBox).Invalidate;
  end;
end;

Procedure TToolRect.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=true;
  SetLength(Figures,Length(Figures)+1);
  Figures[High(Figures)]:=TRect.Create;
  SetLength(Figures[High(Figures)].Points,1);
  Figures[High(Figures)].Points[0].x:=X;
  Figures[High(Figures)].Points[0].y:=Y;
  Figures[High(Figures)].SizePen:=SizePen;
end;

Procedure TToolRect.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=false;
  if Length(Figures[High(Figures)].Points)<2 then SetLength(Figures,Length(Figures)-1);
end;

Procedure TToolRect.MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer);
begin
  if FlagMouse then begin
    SetLength(Figures[High(Figures)].Points,2);
    Figures[High(Figures)].Points[1].x:=X;
    Figures[High(Figures)].Points[1].y:=Y;
    with Figures[High(Figures)] do
    if FlagShift then
      Points[1].y:=Points[0].y+sign((Points[0].y-Y)*(Points[0].x-X))*(X-Points[0].x);
    (Sender as TPaintBox).Invalidate;
  end;
end;

Procedure TToolEllipse.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=true;
  SetLength(Figures,Length(Figures)+1);
  Figures[High(Figures)]:=TEllipse.Create;
  SetLength(Figures[High(Figures)].Points,1);
  Figures[High(Figures)].Points[0].x:=X;
  Figures[High(Figures)].Points[0].y:=Y;
  Figures[High(Figures)].SizePen:=SizePen;
end;

Procedure TToolEllipse.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FlagMouse:=false;
  if Length(Figures[High(Figures)].Points)<2 then SetLength(Figures,Length(Figures)-1);
end;

Procedure TToolEllipse.MouseMove(Sender: TObject;Shift: TShiftState;
  X, Y: Integer);
begin
  if FlagMouse then begin
    SetLength(Figures[High(Figures)].Points,2);
    Figures[High(Figures)].Points[1].x:=X;
    Figures[High(Figures)].Points[1].y:=Y;
    with Figures[High(Figures)] do
    if FlagShift then
      Points[1].y:=Points[0].y+sign((Points[0].y-Y)*(Points[0].x-X))*(X-Points[0].x);
    (Sender as TPaintBox).Invalidate;
  end;
end;
initialization
  RegisterBtn(TToolPen);
  RegisterBtn(TToolLine);
  RegisterBtn(TToolPolyline);
  RegisterBtn(TToolRoundRect);
  RegisterBtn(TToolRect);
  RegisterBtn(TToolEllipse);
end.
