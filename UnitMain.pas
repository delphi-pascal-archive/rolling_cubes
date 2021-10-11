unit UnitMain;
                                                                                {
                             PAR CARIBENSILA
                              février 2007                                      }

interface

uses
  Windows, SysUtils, Classes, ExtCtrls, ComCtrls, Forms, Controls, StdCtrls,
  jpeg, UnitCube;

type
  TForm1 = class(TForm)
    Panel3: TPanel;
    Label9: TLabel;
    Label12: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Edt_Taille: TEdit;
    UpDown2: TUpDown;
    Shp_Creer: TShape;
    Label13: TLabel;
    GroupBox1: TGroupBox;
    Rbt_Virtuel: TRadioButton;
    Rbt_Reel: TRadioButton;
    Tkb_Vitesse: TTrackBar;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Shp_CreerMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

  var
    UnCube   : TCube;



procedure TForm1.FormCreate(Sender: TObject);
  begin
  DoubleBuffered := true;
end;



procedure TForm1.FormDestroy(Sender: TObject);
  var
      i : Integer;
  begin
  for i := Form1.ComponentCount-1 downto 0 do begin
    if (Form1.Components[i] is TCube) then Form1.Components[i].Free;
  end;
end;



procedure TForm1.Shp_CreerMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  var
      Index      : Integer;
      UnJpeg     : TJPEGImage;
      NomFichier : String;
  begin
  UnCube := TCube.Create(self);
  if Rbt_Reel.Checked then UnCube.Virtuel := false;
  if Rbt_Virtuel.Checked then UnCube.Virtuel := true;
  UnCube.Parent  := Form1;
  UnCube.Taille  := StrToInt(Edt_Taille.Text);
  UnCube.Vitesse := 50 - Tkb_Vitesse.Position;
  UnCube.Top     := 30;
  UnCube.Left    := 270;
  UnJpeg := TJPEGImage.Create;
  try
    for Index := 0 to 5 do begin
      NomFichier := '_Images\Ima' + IntToStr(Index) + '.jpg';
      if FileExists(ChangeFileExt(Application.ExeName,NomFichier))then begin
        UnJpeg.LoadFromFile(ChangeFileExt(Application.ExeName,NomFichier));
        UnCube.ChargerJpg(Index,UnJpeg);
      end;
    end;
  finally UnJpeg.Free; end;
end;

END.





