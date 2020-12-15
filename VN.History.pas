unit VN.History;

interface

uses
  VN.Types,
  System.Generics.Collections,
  System.SysUtils;

type

  TvnHistory = class(TInterfacedObject, IvnHistory)
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
    /// Проверяет, есть ли такой элемент в истории
    /// </summary>
    function IsHistory(const AName: string): Boolean;
    /// <summary>
    /// Количество элементов в истории
    /// </summary>
    function Count: Integer;
    /// <summary>
    /// Возможно ли перейти на шаг вперед?
    /// </summary>
    function CanForward: Boolean;
    /// <summary>
    /// Возможно ли вернуться на шаг назад?
    /// </summary>
    function CanBack: Boolean;
    /// <summary>
    /// Текущий элемент истории
    /// </summary>
    function Current: string;
{$ENDREGION}
{$REGION 'Navigation'}
    /// <summary>
    /// Переход на новый элемент истории.
    /// </summary>
    procedure Navigate(const APageName: string); virtual;
    /// <summary>
    /// Перейти на шаг вперед
    /// </summary>
    function Next: string; virtual;
    /// <summary>
    /// Вернуться на шаг назад
    /// </summary>
    function Back: string; virtual;
{$ENDREGION}
    /// <summary>
    ///
    /// </summary>
    property Cursor: Integer read GetCursor write SetCursor;
    property OnNavigate: TProc<string> read fOnNavigate write fOnNavigate;
  end;

implementation

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
  Result := Cursor < FHistory.Count;
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
  if (FHistory.Count > 0) and (FCursor >= 0) and (CanForward) then
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

procedure TvnHistory.SetCursor(const Value: Integer);
begin
  FCursor := Value;
end;

end.
