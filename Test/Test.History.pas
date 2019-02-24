unit Test.History;

interface

uses
  VN.History,
  System.SysUtils,
  DUnitX.TestFramework;

type

  [TestFixture]
  TestHistory = class(TObject)
  strict private
    FHistory: TvnHistory;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure Nav_Current;
    [Test]
    procedure Nav_Back;
    [Test]
    procedure Nav_Nav_Back;
    [Test]
    procedure Nav_Nav_Nav_Back;
    procedure Nav_Nav_Nav_Back_Back_Forw;
  end;

implementation

procedure TestHistory.Setup;
begin
  FHistory := TvnHistory.Create;
end;

procedure TestHistory.TearDown;
begin
  FreeAndNil(FHistory);
end;

procedure TestHistory.Nav_Back;
begin
  FHistory.Navigate('home');
  Assert.AreEqual('home', FHistory.Current);
  FHistory.Back;
  Assert.AreEqual('home', FHistory.Current);
end;

procedure TestHistory.Nav_Current;
begin
  FHistory.Navigate('home');
  Assert.AreEqual('home', FHistory.Current);
end;

procedure TestHistory.Nav_Nav_Back;
begin
  FHistory.Navigate('home');
  FHistory.Navigate('2');
  Assert.AreEqual('home', FHistory.Back);
end;

procedure TestHistory.Nav_Nav_Nav_Back;
begin
  FHistory.Navigate('home');
  FHistory.Navigate('2');
  FHistory.Navigate('3');
  Assert.AreEqual('2', FHistory.Back);
end;

procedure TestHistory.Nav_Nav_Nav_Back_Back_Forw;
begin
  FHistory.Navigate('home');
  FHistory.Navigate('2');
  FHistory.Navigate('3');
  FHistory.Back;
  FHistory.Back;
  FHistory.Forward;
  Assert.AreEqual('2', FHistory.Current);
end;

initialization

TDUnitX.RegisterTestFixture(TestHistory);

end.
