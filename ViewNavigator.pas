unit ViewNavigator;

interface

uses
  FMX.Controls,
  System.Classes,
  System.Generics.Collections,
  System.SysUtils,
  System.Rtti;

type
  TValue = System.Rtti.TValue;

  IvnView = interface
    ['{E83C4096-6C79-4FB3-B23F-7D360A983A0D}']
    procedure DataReceive(AData: TValue);
  end;

{$SCOPEDENUMS ON}

  TpmLifeStyle = (CreateDestroy, ShowHide);
  TvnViewInfoState = (IsCreated, IsVisible);
  TvnViewInfoStates = set of TvnViewInfoState;
{$SCOPEDENUMS OFF}

  ViewInfoAttribute = class(TCustomAttribute)
  private
    FLifeStyle: TpmLifeStyle;
    FName: string;
  public
    constructor Create(ALifeStyle: TpmLifeStyle); overload;
    constructor Create(const AName: string; ALifeStyle: TpmLifeStyle); overload;
    property LifeStyle: TpmLifeStyle read FLifeStyle write FLifeStyle;
    property Name: string read FName write FName;
  end;

  TControlClass = class of TControl;

  TvnViewInfo = class
  private
    FLifeStyle: TpmLifeStyle;
    FName: string;
    FControl: TControl;
    /// <summary>
    /// Тип сторінки
    /// </summary>
    FControlClass: TControlClass;
    FStates: TvnViewInfoStates;
    FOnChangeStateCallback: TProc<TvnViewInfoStates>;
    procedure DoCreate;
    procedure DoDestroy;
  protected
    /// <summary>
    /// За необхідністю створює інстанс. Викликає подію OnChangeStates
    /// </summary>
    procedure DoNotifyShow;
    procedure DoNotifyHide;
    procedure DoNotifyCreate;
    procedure DoNotifyDestroy;
    procedure DoChangeStates(AStates: TvnViewInfoStates);
    function CanBeCreate(ACreationTime: TpmLifeStyle): Boolean;
    function CanBeFree(ADestroyTime: TpmLifeStyle): Boolean;
    /// <summary>
    /// Инстанс сторінки
    /// </summary>
    property Control: TControl read FControl write FControl;

    function IsCreated: Boolean;
    procedure SetParent(const Value: TControl);
  public
    /// <summary>
    /// Приховати сторінку
    ///
    /// </summary>
    procedure Hide;
    /// <summary>
    /// Спробувати показати сторінку
    /// </summary>
    procedure Navigate(AParent: TControl);
    constructor Create(AControlClass: TControlClass);
    destructor Destroy; override;
    /// <summary>
    /// Правило створення та знищеня сторінки
    /// </summary>
    property LifeStyle: TpmLifeStyle read FLifeStyle write FLifeStyle;
    /// <summary>
    /// Ім'я сторінки
    /// </summary>
    property Name: string read FName write FName;
    /// <summary>
    /// Стан сторінки
    /// </summary>
    property States: TvnViewInfoStates read FStates write FStates;
    /// <summary>
    /// Подія, яка сповіщає про змін стану сторінки
    /// </summary>
    property OnChangeStateCallback: TProc<TvnViewInfoStates> read FOnChangeStateCallback write FOnChangeStateCallback;
  end;

  TvnHistory = class
  private
    FHistory: TList<string>;
    FCursor: Integer;
    fOnNavigate: TProc<string>;
    function GetCursor: Integer;
    procedure SetCursor(const Value: Integer);
  protected
    procedure DoClearBeforeNavigate;
    procedure DoOnNavigate(const AName: string);
  public
    constructor Create; virtual;
    destructor Destroy; override;
{$REGION 'Info'}
    /// <summary>
    /// Перевіряє наявність елементу в історії
    /// </summary>
    function IsHistory(const AName: string): Boolean;
    /// <summary>
    /// Кількість елементів в історії
    /// </summary>
    function Count: Integer;
    /// <summary>
    /// Можливість перейти вперед
    /// </summary>
    function CanForward: Boolean;
    /// <summary>
    /// Можливість повернутися
    /// </summary>
    function CanBack: Boolean;
    /// <summary>
    /// Поточний елемент
    /// </summary>
    function Current: string;
{$ENDREGION}
{$REGION 'Navigation'}
    /// <summary>
    /// Додавання елемента в історію
    /// </summary>
    procedure Navigate(const APageName: string); virtual;
    /// <summary>
    /// Вперед
    /// </summary>
    function Next: string; virtual;
    /// <summary>
    /// Назад
    /// </summary>
    function Back: string; virtual;
{$ENDREGION}
    /// <summary>
    ///
    /// </summary>
    property History: TList<string> read FHistory;
    property Cursor: Integer read GetCursor write SetCursor;
    property OnNavigate: TProc<string> read fOnNavigate write fOnNavigate;
  end;

  TViewNavigator = class(TComponent)
  private
    FHistory: TvnHistory;
    FParent: TControl;
    FPages: TObjectList<TvnViewInfo>;
    FOnChangeStateCallback: TProc<string, TvnViewInfoStates>;
    FVersion: string;
    FOnNavigationFailedCallback: TProc<string>;
    FOnNavigateCallback: TProc<TvnViewInfo>;
  protected
    procedure DoNavigationFailed(const APage: string);
    procedure DoHideCurrentView;
    function TryFindPageInfo(AControlClass: TControlClass; var APageInfo: TvnViewInfo): Boolean; overload;
    function TryFindPageInfo(AViewName: string; var APageInfo: TvnViewInfo): Boolean; overload;
    function DoNavigate(APageInfo: TvnViewInfo): Boolean;
    function DoSendData(APageInfo: TvnViewInfo; const AData: TValue): Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure RegisterFrame(AControlClass: TControlClass); overload;
    procedure RegisterFrame(AControlClasses: TArray<TControlClass>); overload;
    function Navigate(AControlClass: TControlClass): Boolean; overload;
    function Navigate(AControlClass: TControlClass; AData: TValue): Boolean; overload;
    function Navigate(ASourcePage: string): Boolean; overload;
    procedure SendData(const APageName: string; const AData: TValue); overload;
    procedure SendData(AControlClass: TControlClass; const AData: TValue); overload;
    procedure GoBack();
    procedure GoForward();
  public
    property History: TvnHistory read FHistory write FHistory;
    property Pages: TObjectList<TvnViewInfo> read FPages;
    property Parent: TControl read FParent write FParent;
    property OnChangeStateCallback: TProc<string, TvnViewInfoStates> read FOnChangeStateCallback
      write FOnChangeStateCallback;
    property OnNavigationFailedCallback: TProc<string> read FOnNavigationFailedCallback
      write FOnNavigationFailedCallback;
    property OnNavigateCallback: TProc<TvnViewInfo> read FOnNavigateCallback write FOnNavigateCallback;
    property Version: string read FVersion write FVersion;
  end;

  TvnOnChangeState = procedure(Sender: TViewNavigator; const APage: string; AState: TvnViewInfoStates) of object;

  TViewNavigatorUI = class(TViewNavigator)
  private
    FOnChangeState: TvnOnChangeState;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property History;
    property Pages;
    property OnChangeState: TvnOnChangeState read FOnChangeState write FOnChangeState;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Common controls', [TViewNavigatorUI])
end;

{ViewInfoAttribute}
constructor ViewInfoAttribute.Create(ALifeStyle: TpmLifeStyle);
begin
  Self.Create('', ALifeStyle);
end;

constructor ViewInfoAttribute.Create(const AName: string; ALifeStyle: TpmLifeStyle);
begin
  inherited Create;
  FLifeStyle := ALifeStyle;
  FName := AName;
end;
{ TViewNavigator }

constructor TViewNavigator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Version := '2.0';
  if AOwner is TControl then
    Parent := AOwner as TControl;
  FPages := TObjectList<TvnViewInfo>.Create();
  FHistory := TvnHistory.Create();
end;

destructor TViewNavigator.Destroy;
begin
  FHistory.Free;
  FPages.Free;
  inherited Destroy;
end;

procedure TViewNavigator.DoHideCurrentView;
var
  AView: TvnViewInfo;
begin
  if (not FHistory.Current.IsEmpty) and TryFindPageInfo(FHistory.Current, AView) then
    AView.Hide();
end;

function TViewNavigator.DoNavigate(APageInfo: TvnViewInfo): Boolean;
var
  LOldPage: TvnViewInfo;
begin
  Result := False;
  if FHistory.Current = APageInfo.Name then
    Exit;
  if TryFindPageInfo(FHistory.Current, LOldPage) then
  begin
    LOldPage.Hide;
  end;
  FHistory.Navigate(APageInfo.Name);
  APageInfo.Navigate(Parent);
  if Assigned(OnNavigateCallback) then
    OnNavigateCallback(APageInfo);
  Result := True;
end;

procedure TViewNavigator.DoNavigationFailed(const APage: string);
begin
  if Assigned(OnNavigationFailedCallback) then
    OnNavigationFailedCallback(APage);
end;

function TViewNavigator.DoSendData(APageInfo: TvnViewInfo; const AData: TValue): Boolean;
var
  LDataView: IvnView;
begin
  if Supports(APageInfo.Control, IvnView, LDataView) then
  begin
    LDataView.DataReceive(AData);
    Result := True;
  end
  else
    Result := False;
end;

procedure TViewNavigator.GoBack;
var
  LCurrentPage: TvnViewInfo;
  LBackPage: TvnViewInfo;
begin
  if TryFindPageInfo(FHistory.Current, LCurrentPage) then
    LCurrentPage.Hide;
  if TryFindPageInfo(FHistory.Back, LBackPage) then
    LBackPage.Navigate(Parent);
end;

procedure TViewNavigator.GoForward;
var
  LCurrentPage: TvnViewInfo;
  LForwardPage: TvnViewInfo;
begin
  if TryFindPageInfo(FHistory.Current, LCurrentPage) then
    LCurrentPage.Hide;
  if TryFindPageInfo(FHistory.Next, LForwardPage) then
    LForwardPage.Navigate(Parent);
end;

function TViewNavigator.Navigate(ASourcePage: string): Boolean;
var
  LPage: TvnViewInfo;
begin
  if TryFindPageInfo(ASourcePage, LPage) then
  begin
    Result := DoNavigate(LPage);
  end
  else
  begin
    DoNavigationFailed(ASourcePage);
    Result := False;
  end;
end;

function TViewNavigator.Navigate(AControlClass: TControlClass): Boolean;
var
  LPage: TvnViewInfo;
begin
  if TryFindPageInfo(AControlClass, LPage) then
  begin
    Result := DoNavigate(LPage);
  end
  else
  begin
    DoNavigationFailed(AControlClass.ClassName);
    Result := False;
  end;
end;

function TViewNavigator.Navigate(AControlClass: TControlClass; AData: TValue): Boolean;
begin
  Result := Navigate(AControlClass);
  if Result then
    SendData(AControlClass, AData);
end;

procedure TViewNavigator.RegisterFrame(AControlClasses: TArray<TControlClass>);
begin
  for var LView in AControlClasses do
    RegisterFrame(LView);
end;

procedure TViewNavigator.RegisterFrame(AControlClass: TControlClass);
var
  lPageInfo: TvnViewInfo;
begin
  lPageInfo := TvnViewInfo.Create(AControlClass);
  FPages.Add(lPageInfo);
  lPageInfo.OnChangeStateCallback := procedure(AState: TvnViewInfoStates)
    begin
      if Assigned(FOnChangeStateCallback) then
        FOnChangeStateCallback(lPageInfo.Name, AState);
    end;
  lPageInfo.DoNotifyCreate;
end;

procedure TViewNavigator.SendData(AControlClass: TControlClass; const AData: TValue);
var
  LView: TvnViewInfo;
begin
  if TryFindPageInfo(AControlClass, LView) then
    DoSendData(LView, AData)
  else
    raise EResNotFound.Create(AControlClass.ClassName);
end;

procedure TViewNavigator.SendData(const APageName: string; const AData: TValue);
var
  LView: TvnViewInfo;
begin
  if TryFindPageInfo(APageName, LView) then
    DoSendData(LView, AData)
  else
    raise EResNotFound.Create(APageName);
end;

function TViewNavigator.TryFindPageInfo(AControlClass: TControlClass; var APageInfo: TvnViewInfo): Boolean;
begin
  Result := False;
  for var I := 0 to FPages.Count - 1 do
    if FPages[I].FControlClass = AControlClass then
    begin
      Result := True;
      APageInfo := FPages[I];
    end;
end;

function TViewNavigator.TryFindPageInfo(AViewName: string; var APageInfo: TvnViewInfo): Boolean;
begin
  Result := False;
  for var I := 0 to FPages.Count - 1 do
    if FPages[I].Name = AViewName then
    begin
      Result := True;
      APageInfo := FPages[I];
    end;
end;

{ TvnViewInfo }

function TvnViewInfo.CanBeCreate(ACreationTime: TpmLifeStyle): Boolean;
begin
  Result := (FLifeStyle = ACreationTime) and (not IsCreated);
end;

function TvnViewInfo.CanBeFree(ADestroyTime: TpmLifeStyle): Boolean;
begin
  Result := IsCreated and (FLifeStyle = ADestroyTime) and (not Assigned(FControl.Parent));
end;

constructor TvnViewInfo.Create(AControlClass: TControlClass);
var
  LRttiObj: TRttiContext;
  LRttiType: TRttiType;
begin
  FControl := nil;
  FControlClass := AControlClass;
  LRttiObj := TRttiContext.Create;
  try
    LRttiType := LRttiObj.GetType(AControlClass);
    for var LRttiAttribute in LRttiType.GetAttributes do
      if LRttiAttribute is ViewInfoAttribute then
      begin
        FLifeStyle := (LRttiAttribute as ViewInfoAttribute).LifeStyle;
        FName := (LRttiAttribute as ViewInfoAttribute).Name;
      end;
    if FName.IsEmpty then
      FName := LRttiType.Name;
  finally
    LRttiObj.Free;
  end;
end;

destructor TvnViewInfo.Destroy;
begin
  DoNotifyDestroy;
  inherited;
end;

procedure TvnViewInfo.DoChangeStates(AStates: TvnViewInfoStates);
begin
  FStates := AStates;
  if Assigned(OnChangeStateCallback) then
    OnChangeStateCallback(AStates);
end;

procedure TvnViewInfo.DoCreate;
begin
  FControl := (FControlClass.Create(nil));
  DoChangeStates(FStates + [TvnViewInfoState.IsCreated]);
end;

procedure TvnViewInfo.DoDestroy;
begin
  FreeAndNil(FControl);
  DoChangeStates(FStates - [TvnViewInfoState.IsCreated]);
end;

procedure TvnViewInfo.Hide;
begin
  FControl.Parent := nil;
  DoChangeStates(FStates - [TvnViewInfoState.IsVisible]);
  DoNotifyHide;
end;

function TvnViewInfo.IsCreated: Boolean;
begin
  Result := Assigned(FControl) and (FControl.Name <> '');
end;

procedure TvnViewInfo.Navigate(AParent: TControl);
begin
  DoNotifyShow;
  SetParent(AParent);
  FControl.Visible := True;
  DoChangeStates(FStates + [TvnViewInfoState.IsVisible]);
end;

procedure TvnViewInfo.DoNotifyCreate;
begin
  if CanBeCreate(TpmLifeStyle.CreateDestroy) then
    DoCreate;
end;

procedure TvnViewInfo.DoNotifyDestroy;
begin
  if CanBeFree(TpmLifeStyle.CreateDestroy) then
    DoDestroy;
end;

procedure TvnViewInfo.DoNotifyHide;
begin
  if CanBeFree(TpmLifeStyle.ShowHide) then
    DoDestroy;
end;

procedure TvnViewInfo.DoNotifyShow;
begin
  if CanBeCreate(TpmLifeStyle.ShowHide) then
    DoCreate;
end;

procedure TvnViewInfo.SetParent(const Value: TControl);
begin
  if IsCreated then
    FControl.Parent := Value;
end;

{ TvnHistory }

function TvnHistory.Back: string;
begin
  if CanBack then
    Dec(FCursor);
  Result := Current;
  DoOnNavigate(Result);
end;

function TvnHistory.CanBack: Boolean;
begin
  Result := Cursor > 0;
end;

function TvnHistory.CanForward: Boolean;
begin
  Result := Cursor < FHistory.Count - 1;
end;

function TvnHistory.Count: Integer;
begin
  Result := FHistory.Count;
end;

constructor TvnHistory.Create;
begin
  FHistory := TList<string>.Create;
  FCursor := -1;
end;

function TvnHistory.Current: string;
begin
  if (FHistory.Count > 0) and (FCursor >= 0) then
    Result := FHistory[FCursor]
  else
    Result := '';
end;

destructor TvnHistory.Destroy;
begin
  FHistory.Free;
  inherited;
end;

procedure TvnHistory.DoClearBeforeNavigate;
var
  I: Integer;
begin
  if FCursor <= 0 then
    Exit;
  for I := FHistory.Count - 1 downto FCursor do
    FHistory.Delete(I);
end;

procedure TvnHistory.DoOnNavigate(const AName: string);
begin
  if Assigned(OnNavigate) then
    OnNavigate(AName);
end;

function TvnHistory.GetCursor: Integer;
begin
  Result := FCursor;
end;

function TvnHistory.IsHistory(const AName: string): Boolean;
begin
  Result := FHistory.IndexOf(AName) > -1;
end;

procedure TvnHistory.Navigate(const APageName: string);
begin
  Inc(FCursor);
  DoClearBeforeNavigate;
  FHistory.Add(APageName);
  DoOnNavigate(APageName);
end;

function TvnHistory.Next: string;
begin
  if CanForward then
  begin
    Inc(FCursor);
    Result := Current;
    DoOnNavigate(Result);
  end
  else
    Result := '';
end;

procedure TvnHistory.SetCursor(const Value: Integer);
begin
  FCursor := Value;
end;

{ TViewNavigatorUI }

constructor TViewNavigatorUI.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Self.OnChangeStateCallback := procedure(APage: string; AState: TvnViewInfoStates)
    begin
      if Assigned(FOnChangeState) then
        FOnChangeState(Self, APage, AState);
    end;
end;

end.
