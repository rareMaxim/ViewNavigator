unit two;

interface

uses
  VN.Types.Attributes,
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Objects;

type
  [vnViewAttribute('view2')]
  Tview2 = class(TFrame)
    txt1: TText;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

initialization

//Tview2.ClassName;

end.
