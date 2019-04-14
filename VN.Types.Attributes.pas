unit VN.Types.Attributes;

interface

uses
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
  TvnTest = class
    class procedure Test;
  end;

implementation

uses
  VN.Types.ViewStore,
  System.Rtti;

{ TvnViewAttribute }

constructor vnViewAttribute.Create(const AName: string);
begin
  FName := AName;
end;

{ TvnTest }

class procedure TvnTest.Test;
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
      Writeln(CType.ToString);
      for CAttribute in CType.GetAttributes do
      begin
        if CAttribute is vnViewAttribute then
        begin
          CvnType := TvnControlClass((CType as TRttiInstanceType)
            .MetaclassType);
          CvnAttribute := CAttribute as vnViewAttribute;
          TViewsStore.AddView(CvnAttribute.Name, CvnType);
        end;
      end;
    end;
  finally
    Ctx.Free;
  end;
end;

end.
