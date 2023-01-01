program Demo;

uses
  System.StartUpCopy,
  FMX.Forms,
  UI.Main in 'UI.Main.pas' {Form6},
  UI.Page.CreateOnShow in 'UI.Page.CreateOnShow.pas' {CreateOnShow: TFrame},
  UI.Page.CreateOnCreate in 'UI.Page.CreateOnCreate.pas' {CreateOnCreate: TFrame},
  UI.Page.SendData in 'UI.Page.SendData.pas' {SendData: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm6, Form6);
  Application.Run;
end.
