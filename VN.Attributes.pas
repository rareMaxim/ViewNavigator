unit VN.Attributes;

interface

uses
  VN.Types;

type
  TvnLifeCycle = VN.Types.TvnLifeCycle;

  vnNameAttribute = class(TCustomAttribute)
  private
    fName: string;
  public
    constructor Create(const AName: string);
    property Name: string read fName write fName;
  end;

  vnLifeCycleAttribute = class(TCustomAttribute)
  private
    fLifeCycle: TvnLifeCycle;
  public
    constructor Create(const ALifeCycle: TvnLifeCycle);
    property LifeCycle: TvnLifeCycle read fLifeCycle write fLifeCycle;
  end;

implementation

{ vnNameAttribute }

constructor vnNameAttribute.Create(const AName: string);
begin
  fName := AName;
end;

{ vnLifeCycleAttribute }

constructor vnLifeCycleAttribute.Create(const ALifeCycle: TvnLifeCycle);
begin
  fLifeCycle := ALifeCycle;
end;

end.
