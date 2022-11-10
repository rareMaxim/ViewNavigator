unit VN.Types;

interface

uses
  System.SysUtils,
  System.Rtti,
  VN.Framworks;

type
{$SCOPEDENUMS ON}
  TvnControl = VN.Framworks.TvnControl;

  TvnControlClass = class of TvnControl;

  TvnLifeCycle = (OnCreateDestroy, OnShowHide);
  TvnViewInfoState = (IsCreated, IsVisible);
  TvnViewInfoStates = set of TvnViewInfoState;
  TViewStoreParameter = (CreateOnShowAndFreeOnHide, CreateOnCreationAndFreeOnDestroy);

  EViewNavigator = class(Exception);

  TExceptionsBuilder = class
  public
    class procedure E_ViewNotFound(const AViewName: string);
    class procedure E_FrameWithotIvnDataView(const AViewName: string);
  end;

  IvnHistory = interface
    ['{26FC3B45-81D5-4AE8-9871-84E75295EE87}']
    // public
{$REGION 'Info'}
    function Count: Integer;
    function CanForward: Boolean;
    function CanBack: Boolean;
    function Current: string;
{$ENDREGION}
{$REGION 'Navigation'}
    procedure Navigate(const APageName: string);
    function Next: string;
    function Back: string;
{$ENDREGION}
  end;

  IvnNavigator = interface(IvnHistory)
    ['{699E29FA-9FC0-4392-923D-A2326CE78C55}']
    function GetParent: TvnControl;
    procedure SetParent(const Value: TvnControl);
    // public
    procedure Navigate(const APageName: string); overload;
    procedure Navigate(const APageName: string; const AData: TValue); overload;
    property Parent: TvnControl read GetParent write SetParent;
  end;

  IvnDataView = interface
    ['{E83C4096-6C79-4FB3-B23F-7D360A983A0D}']
    procedure DataReceive(AData: TValue);
  end;

  IvnSetViewNavigator = interface
    ['{DD58D0E8-3851-489E-97F7-CEF832B5D1D2}']
    procedure SetViewNavigator(const AViewNavigator: IvnNavigator);
  end;

implementation

class procedure TExceptionsBuilder.E_FrameWithotIvnDataView(const AViewName: string);
begin
  raise EViewNavigator.CreateFmt('TFrame unsupported IvnDataView: %s', [AViewName]);
end;

class procedure TExceptionsBuilder.E_ViewNotFound(const AViewName: string);
begin
  raise EViewNavigator.CreateFmt('Cant find view by name: %s', [AViewName]);
end;

end.
