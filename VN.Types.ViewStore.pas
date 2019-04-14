unit VN.Types.ViewStore;

interface

uses
  VN.Types,
  VN.Types.ViewNavigatorInfo,
  System.Generics.Collections;

type
  TViewsStore = class
  private
    class var
      FViews: TObjectDictionary<string, TvnViewInfo>;
  public
    class procedure ViewsInitialize;
    class constructor Create;
    class destructor Destroy;
    class procedure AddView(const AName: string; ANavClass: TvnControlClass; ACreateDestroyTime: TvnCreateDestroyTime = TvnCreateDestroyTime.OnShowHide);
    class function FindView(const AName: string; out Return: TvnViewInfo): Boolean;
  end;

implementation

uses
  System.SysUtils;

{ TViewsStore }

class procedure TViewsStore.AddView(const AName: string; ANavClass: TvnControlClass; ACreateDestroyTime: TvnCreateDestroyTime);
var
  AInfo: TvnViewInfo;
begin
  { TODO -oOwner -cGeneral : При совпадении имени вьюшки - нужно разрушить существующую
    и зарегистрировать новую }
  AInfo := TvnViewInfo.Create(AName.ToLower, ANavClass, ACreateDestroyTime);
  FViews.Add(AInfo.Name, AInfo);
end;

class constructor TViewsStore.Create;
begin
  FViews := TObjectDictionary<string, TvnViewInfo>.Create();
end;

class destructor TViewsStore.Destroy;
begin
  FreeAndNil(FViews);
end;

class function TViewsStore.FindView(const AName: string; out Return: TvnViewInfo): Boolean;
var
  LLoweredName: string;
begin
  LLoweredName := AName.ToLower;
  Result := FViews.ContainsKey(LLoweredName);
  if Result then
    Return := FViews[LLoweredName];
end;

class procedure TViewsStore.ViewsInitialize;
var
  LViewInfo: TvnViewInfo;
begin
  for LViewInfo in FViews.Values do
    LViewInfo.NotifySelfCreate();
end;

end.

