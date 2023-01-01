﻿unit UI.Page.CreateOnShow;

interface

uses
  ViewNavigator,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects;

type

  [ViewInfoAttribute(TpmLifeStyle.ShowHide)]
  TCreateOnShow = class(TFrame)
    Rectangle1: TRectangle;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

initialization

//TFrame1.ClassName;

end.
