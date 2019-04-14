program ViewNavDemoFMX;

uses

  System.StartUpCopy,
  FMX.Forms,
  Main in 'Main.pas' {Form4},
  One in 'One.pas' {view1: TFrame},
  two in 'two.pas' {view2: TFrame},
  Three in 'Three.pas' {view3: TFrame};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.

