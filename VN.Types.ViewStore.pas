unit VN.Types.ViewStore;

interface

uses
  VN.Types,
  VN.Types.ViewNavigatorInfo,
  System.Generics.Collections;

type
  TViewsStore = class
  private
    FViews: TObjectDictionary<string, TvnViewInfo>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddView(const AName: string; ANavClass: TvnControlClass; ACreateDestroyTime: TvnCreateDestroyTime = TvnCreateDestroyTime.OnShowHide);
    function FindView(const AName: string; out Return: TvnViewInfo): Boolean;
  end;

implementation

uses
  System.SysUtils;

{ TViewsStore }

procedure TViewsStore.AddView(const AName: string; ANavClass: TvnControlClass; ACreateDestroyTime: TvnCreateDestroyTime);
var
  AInfo: TvnViewInfo;
begin
  { TODO -oOwner -cGeneral : При совпадении имени вьюшки - нужно разрушить существующую
    и зарегистрировать новую }
  AInfo := TvnViewInfo.Create(AName.ToLower, ANavClass, ACreateDestroyTime);
  FViews.Add(AInfo.Name, AInfo);
end;

constructor TViewsStore.Create;
begin
  FViews := TObjectDictionary<string, TvnViewInfo>.Create([doOwnsValues]);
end;

destructor TViewsStore.Destroy;
begin
  FreeAndNil(FViews);
end;

function TViewsStore.FindView(const AName: string; out Return: TvnViewInfo): Boolean;
var
  LLoweredName: string;
begin
  LLoweredName := AName.ToLower;
  Result := FViews.ContainsKey(LLoweredName);
  if Result then
    Return := FViews[LLoweredName];
end;

end.

