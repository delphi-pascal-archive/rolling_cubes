program CubeEngine;

uses
  Forms,
  UnitMain in 'UnitMain.pas' {Form1},
  UnitCube in 'UnitCube.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
