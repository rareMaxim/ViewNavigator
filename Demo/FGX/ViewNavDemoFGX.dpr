program ViewNavDemoFGX;

uses
  FGX.Application,
  FGX.Forms,
  Main in 'Main.pas' {Form5: TfgForm},
  One in 'One.pas' {View1: TfgForm},
  two in 'two.pas' {View2: TfgForm},
  Demo.Bootstrap in '..\Demo.Bootstrap.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TviewMain, viewMain);
  Application.Run;
end.
