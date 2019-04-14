unit VN.Framworks;

interface
 {$DEFINE FMX_APP}
 {$IF Defined(FGX_NATIVE)}
  {$UNDEF FMX_APP}
 {$ENDIF}

uses
{$IF Defined(FMX_APP)}
  FMX.Controls,
{$ELSE IF Defined(FGX_NATIVE)}
  FGX.Control,
{$ELSE}

{$ENDIF}
  System.SysUtils;

type
{$IF Defined(FGX_NATIVE)}
  TvnControl = TfgControl;
{$ELSE IF Defined(FMX_APP)}
  TvnControl = TControl;
{$ELSE}
  TvnControl = TObject; //Error library config
{$ENDIF}

implementation

end.

