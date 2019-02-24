unit ViewNavigator;

interface

{$SCOPEDENUMS ON}
{$DEFINE ModeFMX}

uses
  VN.History,
{$IF Defined(ModeFMX)}
  VN.Framwork.FMX,
{$ENDIF}
  System.Generics.Collections;

type
  IvnCore = interface
    ['{2326FC08-E0CC-46C9-833B-E7A5700EE7BE}']
  end;

  TvnControlClass = class of TvnControl;

  IvnViewInfo = interface
    ['{EC33A966-2F9A-4CEC-B66B-1FD5F488C8DD}']
    function GetName: string;
  end;

  TvnCreationTime = (OnRegister, OnShow);

  TvnDestroyTime = (OnHide, OnViewNavDestroy);

  IvnViewInfoFluent = interface
    ['{A4E26E22-4122-4193-96BA-201E37B93305}']
    function SetName(const AName: string): IvnViewInfoFluent;
    function GetName: string;
    function SetCreationTime(ACreationTime: TvnCreationTime): IvnViewInfoFluent;
    function SetDestroyTime(ADestroyTime: TvnDestroyTime): IvnViewInfoFluent;
    function SetNavClass(ANavigationClass: TvnControlClass): IvnViewInfoFluent;
  end;

  TvnViewInfoBase = class(TInterfacedObject, IvnViewInfoFluent)
  private
    FName: string;
    FCreationTime: TvnCreationTime;
    FDestroyTime: TvnDestroyTime;
    FNavigationClass: TvnControlClass;
  public
    constructor Create;
    destructor Destroy; override;
    function SetName(const AName: string): IvnViewInfoFluent;
    function GetName: string;
    function SetCreationTime(ACreationTime: TvnCreationTime): IvnViewInfoFluent;
    function SetDestroyTime(ADestroyTime: TvnDestroyTime): IvnViewInfoFluent;
    function SetNavClass(ANavigationClass: TvnControlClass): IvnViewInfoFluent;
  public
    class function Init: IvnViewInfoFluent;
  end;

  TViewNavigator = class(TvnHistory, IvnCore)
  private
    class var
      FViews: TDictionary<string, IvnViewInfoFluent>;
  private
    FParent: TvnControl;
    function GetParent: TvnControl;
    procedure SetParent(const Value: TvnControl);
  protected
  public
    class constructor Create;
    class destructor Destroy;
    class function AddView: IvnViewInfoFluent;
  public
    procedure Navigate(const APageName: string); override;
  published
    property Parent: TvnControl read GetParent write SetParent;
  end;

implementation

uses
  System.SysUtils;

{ TvnViewInfoFMX }

constructor TvnViewInfoBase.Create;
begin

end;

destructor TvnViewInfoBase.Destroy;
begin

  inherited;
end;

function TvnViewInfoBase.GetName: string;
begin
  Result := FName;
end;

class function TvnViewInfoBase.Init: IvnViewInfoFluent;
begin
  Result := TvnViewInfoBase.Create;
end;

function TvnViewInfoBase.SetCreationTime(ACreationTime: TvnCreationTime):
  IvnViewInfoFluent;
begin
  FCreationTime := ACreationTime;
  Result := Self;
end;

function TvnViewInfoBase.SetDestroyTime(ADestroyTime: TvnDestroyTime): IvnViewInfoFluent;
begin
  FDestroyTime := ADestroyTime;
  Result := Self;
end;

function TvnViewInfoBase.SetName(const AName: string): IvnViewInfoFluent;
begin
  FName := AName;
  Result := Self;
end;

function TvnViewInfoBase.SetNavClass(ANavigationClass: TvnControlClass):
  IvnViewInfoFluent;
begin
  FNavigationClass := ANavigationClass;
  Result := Self;
end;

{ TViewNavigator }

class function TViewNavigator.AddView: IvnViewInfoFluent;
begin
  { TODO -oOwner -cGeneral : При совпадении имени вьюшки - нужно разрушить существующую и зарегистрировать новую }
  Result := TvnViewInfoBase.Create;
  FViews.AddOrSetValue(Result.GetName, Result);
end;

class constructor TViewNavigator.Create;
begin
  FViews := TDictionary<string, IvnViewInfoFluent>.Create();
end;

class destructor TViewNavigator.Destroy;
begin
  FreeAndNil(FViews);
end;

function TViewNavigator.GetParent: TvnControl;
begin
  Result := FParent;
end;

procedure TViewNavigator.Navigate(const APageName: string);
begin
  inherited Navigate(APageName);

end;

procedure TViewNavigator.SetParent(const Value: TvnControl);
begin
  FParent := Value;
end;

end.

