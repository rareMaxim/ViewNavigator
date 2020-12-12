unit VN.Types.ViewNavigatorInfo;

interface

uses
  VN.Types;

type
  TvnViewInfo = class(TInterfacedObject)
  private
    FName: string;
    fLifeCycle: TvnLifeCycle;
    FNavigationClass: TvnControlClass;
    FControl: TvnControl;
    FIsCreated: Boolean;
    FIsHaveParent: Boolean;
    FParent: TvnControl;
    procedure SetParent(const Value: TvnControl);
  private
    procedure NotifySelfCreate; // must be private
    procedure NotifySelfShow;
    procedure NotifySelfHide;
    procedure NotifySelfDestroy;
    function CanBeFree(ADestroyTime: TvnLifeCycle): Boolean;
    function CanBeCreate(ACreationTime: TvnLifeCycle): Boolean;
    function IsCreated: Boolean;
    function IsHaveParent: Boolean;
    procedure ViewCreate;
    procedure ViewDestroy;
  public
    procedure NotifyMainFormIsCreated;
    procedure ShowView(AParent: TvnControl);
    procedure HideView();
    constructor Create(ANavClass: TvnControlClass);
    destructor Destroy; override;
    property Name: string read FName write FName;
    property NavigationClass: TvnControlClass read FNavigationClass write FNavigationClass;
    property LifeCycle: TvnLifeCycle read fLifeCycle write fLifeCycle;
    property Control: TvnControl read FControl write FControl;
    property Parent: TvnControl read FParent write SetParent;
  end;

implementation

{ TvnViewInfo }

function TvnViewInfo.CanBeCreate(ACreationTime: TvnLifeCycle): Boolean;
begin
  Result := (fLifeCycle = ACreationTime) and (not IsCreated);
end;

function TvnViewInfo.CanBeFree(ADestroyTime: TvnLifeCycle): Boolean;
begin
  Result := IsCreated and (fLifeCycle = ADestroyTime) and (not IsHaveParent);
end;

constructor TvnViewInfo.Create(ANavClass: TvnControlClass);
begin
  FName := ANavClass.ClassName;
  FNavigationClass := ANavClass;
  fLifeCycle := TvnLifeCycle.OnCreateDestroy;
  HideView;
  NotifySelfCreate;
end;

destructor TvnViewInfo.Destroy;
begin
  NotifySelfDestroy;
  inherited;
end;

procedure TvnViewInfo.HideView;
begin
  Parent := nil;
  NotifySelfHide;
end;

procedure TvnViewInfo.ViewCreate;
begin
  FControl := TvnControl(FNavigationClass.Create(nil));
  FIsCreated := True;
end;

procedure TvnViewInfo.ViewDestroy;
begin
  FControl.Free; // or Dispose?
  FControl := nil;
  FIsCreated := False;
end;

function TvnViewInfo.IsCreated: Boolean;
begin
  Result := FIsCreated and Assigned(FControl);
end;

function TvnViewInfo.IsHaveParent: Boolean;
begin
  Result := FIsHaveParent;
end;

procedure TvnViewInfo.NotifyMainFormIsCreated;
begin
  if CanBeCreate(TvnLifeCycle.OnCreateDestroy) then
    ViewCreate;
end;

procedure TvnViewInfo.NotifySelfCreate;
begin

end;

procedure TvnViewInfo.NotifySelfDestroy;
begin
  if CanBeFree(TvnLifeCycle.OnCreateDestroy) then
    ViewDestroy;
end;

procedure TvnViewInfo.NotifySelfHide;
begin
  if CanBeFree(TvnLifeCycle.OnShowHide) then
    ViewDestroy;
end;

procedure TvnViewInfo.NotifySelfShow;
begin
  if CanBeCreate(TvnLifeCycle.OnShowHide) then
    ViewCreate;
end;

procedure TvnViewInfo.SetParent(const Value: TvnControl);
begin
  FParent := Value;
  if IsCreated then
    FControl.Parent := Value;
  FIsHaveParent := Assigned(Value);
end;

procedure TvnViewInfo.ShowView(AParent: TvnControl);
begin
  NotifySelfShow;
  Parent := AParent;
  FControl.Visible := True;
end;

end.
