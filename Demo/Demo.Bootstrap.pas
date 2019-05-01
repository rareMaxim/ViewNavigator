unit Demo.Bootstrap;

interface

uses
  ViewNavigator;

type
  TBootstrap = class
  private
    class var
      FNavigator: TViewNavigator;
  public
    class function Navigator: TViewNavigator;
    class function NavStore: TViewsStore;
    class constructor Create;
    class destructor Destroy;
  end;

implementation

{ TBootstrap }

class constructor TBootstrap.Create;
begin
  FNavigator := TViewNavigator.Create;
end;

class destructor TBootstrap.Destroy;
begin
  FNavigator.Free;
end;

class function TBootstrap.Navigator: TViewNavigator;
begin
  Result := FNavigator;
end;

class function TBootstrap.NavStore: TViewsStore;
begin
  Result := FNavigator.Store;
end;

end.

