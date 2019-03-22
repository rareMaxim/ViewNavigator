unit VN.History;

interface

uses
  System.Generics.Collections;

type
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
    function forward: string;
    function Back: string;
{$ENDREGION}
  end;

  TvnHistory = class(TInterfacedObject, IvnHistory)
  private
    FHistory: TList<string>;
    FCursor: Integer;
    function GetCursor: Integer;
    procedure SetCursor(const Value: Integer);
  protected
    procedure DoClearBeforeNavigate;
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
    function forward: string; virtual;
    /// <summary>
    /// Вернуться на шаг назад
    /// </summary>
    function Back: string; virtual;
{$ENDREGION}
    /// <summary>
    ///
    /// </summary>
    property Cursor: Integer read GetCursor write SetCursor;
  end;

implementation

{ TvnHistory }

function TvnHistory.Back: string;
begin
  if CanBack then
    Dec(FCursor);
  Result := Current;
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

function TvnHistory.forward: string;
begin
  if CanForward then
  begin
    Inc(FCursor);
    Result := Current;
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
end;

procedure TvnHistory.SetCursor(const Value: Integer);
begin
  FCursor := Value;
end;

end.
