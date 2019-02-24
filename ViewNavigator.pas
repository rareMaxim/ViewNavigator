unit ViewNavigator;

interface

{$SCOPEDENUMS ON}
{$DEFINE ModeFMX}

uses
  VN.History,
  System.Generics.Collections;

type

  IvnCore = interface
    ['{2326FC08-E0CC-46C9-833B-E7A5700EE7BE}']

  end;

  IvnViewInfo = interface
    ['{EC33A966-2F9A-4CEC-B66B-1FD5F488C8DD}']
    function GetName: string;

  end;

  TViewNavigator = class(TInterfacedObject, IvnCore)
  private
    class var FViews: TDictionary<string, IvnViewInfo>;
  protected
  public
    class constructor Create;
    class destructor Destroy;
    class procedure AddView(AInfo: IvnViewInfo);
  published
  end;

implementation

uses
  System.SysUtils;

{ TViewNavigator }

class procedure TViewNavigator.AddView(AInfo: IvnViewInfo);
begin
  FViews.AddOrSetValue(AInfo.GetName, AInfo);
end;

class constructor TViewNavigator.Create;
begin
  FViews := TDictionary<string, IvnViewInfo>.Create();
end;

class destructor TViewNavigator.Destroy;
begin
  FreeAndNil(FViews);
end;

end.
