unit ViewNavigator;

// Я был бухой когда писал этот код... и вообще это не мое - мне подкинули.

interface

{$SCOPEDENUMS ON}
{$DEFINE ModeFMX}

uses
  FMX.Types,
  VN.History,
{$IF Defined(ModeFMX)}
  VN.Framwork.FMX,
{$ENDIF}
  System.Generics.Collections,
  System.SysUtils;

type
  TvnControlClass = class of TvnControl;

  TvnCreationTime = (OnRegister, OnShow);

  TvnDestroyTime = (OnViewNavDestroy, OnHide);

  TvnViewInfoBase = class(TInterfacedObject)
  private
    FName: string;
    FCreationTime: TvnCreationTime;
    FDestroyTime: TvnDestroyTime;
    FNavigationClass: TvnControlClass;
    FControl: TvnControl;
    FIsCreated: Boolean;
    FIsHaveParent: Boolean;
    FParent: TvnControl;
  protected
    procedure NotifySelfCreate;
    procedure NotifySelfShow;
    procedure NotifySelfHide;
    procedure NotifySelfDestroy;
    function IsCreated: Boolean;
    function IsHaveParent: Boolean;
    procedure ViewCreate;
    procedure ViewDestroy;
  public
    procedure Show(AParent: TvnControl);
    procedure Hide();
    constructor Create(const AName: string; ANavClass: TvnControlClass;
      ACreateAt: TvnCreationTime = TvnCreationTime.OnRegister; ADestroyAt:
      TvnDestroyTime = TvnDestroyTime.OnViewNavDestroy);
    destructor Destroy; override;
    property Name: string read FName write FName;
    property NavigationClass: TvnControlClass read FNavigationClass write FNavigationClass;
    property CreationTime: TvnCreationTime read FCreationTime write FCreationTime;
    property DestroyTime: TvnDestroyTime read FDestroyTime write FDestroyTime;
  public
  end;

  TViewNavigator = class(TvnHistory)
  private
    class var
      FViews: TList<TvnViewInfoBase>;
  private
    FParent: TvnControl;
    function GetParent: TvnControl;
    procedure SetParent(const Value: TvnControl);
    function FindView(const AName: string; out Return: TvnViewInfoBase): Boolean;
  protected
  public
    class constructor Create;
    class destructor Destroy;
    class procedure AddView(const AName: string; ANavClass: TvnControlClass;
      ACreateAt: TvnCreationTime = TvnCreationTime.OnRegister; ADestroyAt:
      TvnDestroyTime = TvnDestroyTime.OnViewNavDestroy);
  public
    procedure Navigate(const APageName: string); override;
  published
    property Parent: TvnControl read GetParent write SetParent;
  end;

implementation

{ TvnViewInfoFMX }

constructor TvnViewInfoBase.Create(const AName: string; ANavClass:
  TvnControlClass; ACreateAt: TvnCreationTime = TvnCreationTime.OnRegister;
  ADestroyAt: TvnDestroyTime = TvnDestroyTime.OnViewNavDestroy);
begin
  FName := AName;
  FNavigationClass := ANavClass;
  FCreationTime := ACreateAt;
  FDestroyTime := ADestroyAt;
  NotifySelfCreate;
end;

destructor TvnViewInfoBase.Destroy;
begin
  NotifySelfDestroy;
  inherited;
end;

procedure TvnViewInfoBase.Hide;
begin
  NotifySelfHide;
end;

procedure TvnViewInfoBase.ViewCreate;
begin
  FControl := TvnControl(FNavigationClass.Create(nil));
  FIsCreated := True;
end;

procedure TvnViewInfoBase.ViewDestroy;
begin
  FControl.Parent := nil;
  FreeAndNil(FControl);
  FIsCreated := False;
end;

function TvnViewInfoBase.IsCreated: Boolean;
begin
  Result := FIsCreated and Assigned(FControl);
end;

function TvnViewInfoBase.IsHaveParent: Boolean;
begin
  Result := FIsHaveParent;
end;

procedure TvnViewInfoBase.NotifySelfCreate;
begin
  if (FCreationTime = TvnCreationTime.OnRegister) and (not IsCreated) then
    ViewCreate;
end;

procedure TvnViewInfoBase.NotifySelfDestroy;
begin
  if IsCreated and (not IsHaveParent) and (FDestroyTime = TvnDestroyTime.OnViewNavDestroy) then
    ViewDestroy;
end;

procedure TvnViewInfoBase.NotifySelfHide;
begin

end;

procedure TvnViewInfoBase.NotifySelfShow;
begin
  if (FCreationTime = TvnCreationTime.OnShow) and (not IsCreated) then
    ViewCreate;
end;

procedure TvnViewInfoBase.Show(AParent: TvnControl);
begin
  FParent := AParent;
  NotifySelfShow;
  FControl.Parent := FParent;
  FIsHaveParent := True;
end;

{ TViewNavigator }

class procedure TViewNavigator.AddView(const AName: string; ANavClass:
  TvnControlClass; ACreateAt: TvnCreationTime = TvnCreationTime.OnRegister;
  ADestroyAt: TvnDestroyTime = TvnDestroyTime.OnViewNavDestroy);
var
  AInfo: TvnViewInfoBase;
begin
  { TODO -oOwner -cGeneral : При совпадении имени вьюшки - нужно разрушить существующую
  и зарегистрировать новую }
  AInfo := TvnViewInfoBase.Create(AName, ANavClass, ACreateAt, ADestroyAt);
  FViews.Add(AInfo);
end;

class constructor TViewNavigator.Create;
begin
  FViews := TList<TvnViewInfoBase>.Create();
end;

class destructor TViewNavigator.Destroy;
var
  I: Integer;
begin
  for I := 0 to FViews.Count - 1 do
    FViews[I].Free;
  FreeAndNil(FViews);
end;

function TViewNavigator.FindView(const AName: string; out Return: TvnViewInfoBase): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to FViews.Count - 1 do
    if FViews[I].Name.Equals(AName) then
    begin
      Return := FViews[I];
      Result := True;
      Break;
    end;
end;

function TViewNavigator.GetParent: TvnControl;
begin
  Result := FParent;
end;

procedure TViewNavigator.Navigate(const APageName: string);
var
  AView: TvnViewInfoBase;
begin
  inherited Navigate(APageName);
  if FindView(APageName, AView) then
    AView.Show(Parent);
end;

procedure TViewNavigator.SetParent(const Value: TvnControl);
begin
  FParent := Value;
end;

end.

