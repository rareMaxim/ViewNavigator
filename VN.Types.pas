unit VN.Types;

interface

uses
  System.Rtti,
  VN.Types.FGX;

type
  TvnControl = VN.Types.FGX.TvnControl;

  TvnControlClass = class of TvnControl;

  TvnCreateDestroyTime = (OnCreateDestroy, OnShowHide);

  IvnDataView = interface
    ['{E83C4096-6C79-4FB3-B23F-7D360A983A0D}']
    procedure DataReceive(AData: TValue);
  end;

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
  public
    procedure NotifySelfCreate;
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
    procedure Show(AParent: TvnControl);
    procedure Hide();
    constructor Create(const AName: string; ANavClass: TvnControlClass;
      ACreateDestroyTime: TvnCreateDestroyTime = TvnCreateDestroyTime.OnShowHide);
    destructor Destroy; override;
    property Name: string read FName write FName;
    property NavigationClass: TvnControlClass read FNavigationClass write
      FNavigationClass;
    property CreateDestroyTime: TvnCreateDestroyTime read FCreateDestroyTime
      write FCreateDestroyTime;
    property Control: TvnControl read FControl write FControl;
    property Parent: TvnControl read FParent write SetParent;
  public
  end;

implementation

uses
  System.SysUtils;
{ TvnViewInfoFMX }

function TvnViewInfo.CanBeCreate(ACreationTime: TvnCreateDestroyTime): Boolean;
begin
  Result := (FCreateDestroyTime = ACreationTime) and (not IsCreated);
end;

function TvnViewInfo.CanBeFree(ADestroyTime: TvnCreateDestroyTime): Boolean;
begin
  Result := IsCreated and (FCreateDestroyTime = ADestroyTime) and (not IsHaveParent);
end;

constructor TvnViewInfo.Create(const AName: string; ANavClass: TvnControlClass;
  ACreateDestroyTime: TvnCreateDestroyTime = TvnCreateDestroyTime.OnShowHide);
begin
  FName := AName;
  FNavigationClass := ANavClass;
  FCreateDestroyTime := ACreateDestroyTime;
  Hide;
end;

destructor TvnViewInfo.Destroy;
begin
  NotifySelfDestroy;
  inherited;
end;

procedure TvnViewInfo.Hide;
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
  FreeAndNil(FControl);
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

procedure TvnViewInfo.Show(AParent: TvnControl);
begin
  NotifySelfShow;
  Parent := AParent;
  FControl.Visible := True;
end;

end.

