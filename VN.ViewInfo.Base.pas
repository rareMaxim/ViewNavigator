unit VN.ViewInfo.Base;

interface

type
  TvnCreationTime = (OnRegister, OnShow);
  TvnDestroyTime = (OnHide, OnViewNavDestroy);


  TvnViewInfoBase = class
  private
    FCreationTime: TvnCreationTime;
    FDestroyTime: TvnDestroyTime;
    FName: string;
  public
    constructor Create;
    destructor Destroy; override;
  public
    /// <summary>
    /// Имя вьюшки
    /// </summary>
    property Name: string read FName write FName;
    /// <summary>
    /// Когда будет создаваться вьюшка
    /// </summary>
    property CreationTime: TvnCreationTime read FCreationTime write FCreationTime
      default TvnCreationTime.OnShow;
    /// <summary>
    /// Когда будет разрушаться вьюшка
    /// </summary>
    property DestroyTime: TvnDestroyTime read FDestroyTime write FDestroyTime
      default TvnDestroyTime.OnHide;
  end;

implementation

{ TvnViewInfoFMX }

constructor TvnViewInfoBase.Create;
begin
  FCreationTime := TvnCreationTime.OnShow;
  FDestroyTime := TvnDestroyTime.OnHide;
end;

destructor TvnViewInfoBase.Destroy;
begin

  inherited;
end;

end.
