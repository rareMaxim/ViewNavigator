program ViewNavDemoFGX;

uses
  FGX.Application,
  FGX.Forms,
  Main in 'Main.pas' {Form5: TForm5},
  One in 'One.pas' {View1: TView1},
  two in 'two.pas' {View2: TView2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm5, Form5);
  Application.Run;
end.
