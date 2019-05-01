unit VN.Types.Attributes;

interface

uses
  VN.Types.ViewStore,
  VN.Types;

type
  vnViewAttribute = class(TCustomAttribute)
  private
    FName: string;
  public
    constructor Create(const AName: string);
  published
    property Name: string read FName write FName;
  end;

type
  TvnAttributeFinder = class
    class procedure Find(AViewStore: TViewsStore);
  end;

implementation

uses
  System.Rtti;

{ TvnViewAttribute }

constructor vnViewAttribute.Create(const AName: string);
begin
  FName := AName;
end;

{ TvnTest }

class procedure TvnAttributeFinder.Find(AViewStore: TViewsStore);
var
  Ctx: TRttiContext;
  CType: TRttiType;
  CAttribute: TCustomAttribute;
  CvnAttribute: vnViewAttribute;
  CvnType: TvnControlClass;
begin
  Ctx := TRttiContext.Create;
  try
    for CType in Ctx.GetTypes do
    begin
      for CAttribute in CType.GetAttributes do
      begin
        if CAttribute is vnViewAttribute then
        begin
          CvnType := TvnControlClass((CType as TRttiInstanceType).MetaclassType);
          CvnAttribute := CAttribute as vnViewAttribute;
          AViewStore.AddView(CvnAttribute.Name, CvnType);
        end;
      end;
    end;
  finally
    Ctx.Free;
  end;
end;

end.

