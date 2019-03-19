unit ViewNavigator;

// Я был бухой когда писал этот код... и вообще это не мое - мне подкинули.

interface

{$SCOPEDENUMS ON}

uses
  VN.History,
  VN.Types,
  System.Generics.Collections,
  System.SysUtils;

type
  TvnCreateDestroyTime = VN.Types.TvnCreateDestroyTime;

  TViewsStore = class
  private
    class var
      FViews: TObjectList<TvnViewInfo>;
  public
    class constructor Create;
    class destructor Destroy;
    class procedure AddView(const AName: string; ANavClass: TvnControlClass;
      ACreateDestroyTime: TvnCreateDestroyTime = TvnCreateDestroyTime.OnShowHide);
    class function FindView(const AName: string; out Return: TvnViewInfo): Boolean;
  end;

  TViewNavigator = class(TvnHistory)
  private
    FParent: TvnControl;
    function GetParent: TvnControl;
    procedure SetParent(const Value: TvnControl);
  protected
    function Show(const AName: string): Boolean;
    procedure Hide;
  public
    procedure Navigate(const APageName: string); override;
    function Back: string; override;
    function forward: string; override;
  published
    property Parent: TvnControl read GetParent write SetParent;
  end;

implementation


{ TViewNavigator }

function TViewNavigator.Back: string;
begin
  Result := inherited Back;
  Show(Result);
end;

function TViewNavigator.forward: string;
begin
  Result := inherited Back;
  Show(Result);
end;

function TViewNavigator.GetParent: TvnControl;
begin
  Result := FParent;
end;

procedure TViewNavigator.Hide;
var
  AView: TvnViewInfo;
begin
  if TViewsStore.FindView(Current, AView) then
    AView.Hide();
end;

procedure TViewNavigator.Navigate(const APageName: string);
begin
  if APageName = inherited Current then
    Exit;
  Hide();
  inherited Navigate(APageName);
  Show(APageName);
end;

procedure TViewNavigator.SetParent(const Value: TvnControl);
begin
  FParent := Value;
end;

function TViewNavigator.Show(const AName: string): Boolean;
var
  AView: TvnViewInfo;
begin
  Result := TViewsStore.FindView(AName, AView);
  if Result then
    AView.Show(Parent);
end;

{ TViewsStore }

class procedure TViewsStore.AddView(const AName: string; ANavClass:
  TvnControlClass; ACreateDestroyTime: TvnCreateDestroyTime);
var
  AInfo: TvnViewInfo;
begin
  { TODO -oOwner -cGeneral : При совпадении имени вьюшки - нужно разрушить существующую
  и зарегистрировать новую }
  AInfo := TvnViewInfo.Create(AName, ANavClass, ACreateDestroyTime);
  FViews.Add(AInfo);
end;

class constructor TViewsStore.Create;
begin
  FViews := TObjectList<TvnViewInfo>.Create();
end;

class destructor TViewsStore.Destroy;
begin
  FreeAndNil(FViews);
end;

class function TViewsStore.FindView(const AName: string; out Return: TvnViewInfo): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to FViews.Count - 1 do
    if FViews[I].Name.ToLower.Equals(AName.ToLower) then
    begin
      Return := FViews[I];
      Result := True;
      Break;
    end;
end;

end.

