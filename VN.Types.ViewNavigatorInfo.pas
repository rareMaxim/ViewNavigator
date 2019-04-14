unit VN.Types.ViewNavigatorInfo;

interface

uses
  VN.Types;

type
  TvnViewInfo = class(TInterfacedObject)
  private
    FName: string;
    FCreateDestroyTime: TvnCreateDestroyTime;
    FNavigationClass: TvnControlClass;
    FControl: TvnControl;
    FIsCreated: Boolean;
    FIsHaveParent: Boolean;
    FParent: TvnControl;
    procedure SetParent(const Value: TvnControl);
  private
    procedure NotifySelfShow;
    procedure NotifySelfHide;
    procedure NotifySelfDestroy;
    function CanBeFree(ADestroyTime: TvnCreateDestroyTime): Boolean;
    function CanBeCreate(ACreationTime: TvnCreateDestroyTime): Boolean;
    function IsCreated: Boolean;
    function IsHaveParent: Boolean;
    procedure ViewCreate;
    procedure ViewDestroy;
  public
    procedure NotifySelfCreate;        // must be private
    procedure ShowView(AParent: TvnControl);
    procedure HideView();
    constructor Create(const AName: string; ANavClass: TvnControlClass; ACreateDestroyTime: TvnCreateDestroyTime = TvnCreateDestroyTime.OnShowHide);
    destructor Destroy; override;
    property Name: string read FName write FName;
    property NavigationClass: TvnControlClass read FNavigationClass write FNavigationClass;
    property CreateDestroyTime: TvnCreateDestroyTime read FCreateDestroyTime write FCreateDestroyTime;
    property Control: TvnControl read FControl write FControl;
    property Parent: TvnControl read FParent write SetParent;
  end;

implementation

{ TvnViewInfo }

function TvnViewInfo.CanBeCreate(ACreationTime: TvnCreateDestroyTime): Boolean;
begin
  Result := (FCreateDestroyTime = ACreationTime) and (not IsCreated);
end;

function TvnViewInfo.CanBeFree(ADestroyTime: TvnCreateDestroyTime): Boolean;
begin
  Result := IsCreated and (FCreateDestroyTime = ADestroyTime) and (not IsHaveParent);
end;

constructor TvnViewInfo.Create(const AName: string; ANavClass: TvnControlClass; ACreateDestroyTime: TvnCreateDestroyTime = TvnCreateDestroyTime.OnShowHide);
begin
  FName := AName;
  FNavigationClass := ANavClass;
  FCreateDestroyTime := ACreateDestroyTime;
  HideView;
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
  FControl.DisposeOf; // or Free?
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

procedure TvnViewInfo.NotifySelfCreate;
begin
  if CanBeCreate(TvnCreateDestroyTime.OnCreateDestroy) then
    ViewCreate;
end;

procedure TvnViewInfo.NotifySelfDestroy;
begin
  if CanBeFree(TvnCreateDestroyTime.OnCreateDestroy) then
    ViewDestroy;
end;

procedure TvnViewInfo.NotifySelfHide;
begin
  if CanBeFree(TvnCreateDestroyTime.OnShowHide) then
    ViewDestroy;
end;

procedure TvnViewInfo.NotifySelfShow;
begin
  if CanBeCreate(TvnCreateDestroyTime.OnShowHide) then
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

