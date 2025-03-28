//
// Represents a schematic for a client localized message.
//
class LocalMessage expands Info;

var bool	bComplexString;									// Indicates a multicolor string message class.
var bool	bIsSpecial;										// If true, don't add to normal queue.
var bool	bIsUnique;										// If true and special, only one can be in the HUD queue at a time.
var bool	bIsConsoleMessage;								// If true, put a GetString on the console.
var bool	bFadeMessage;									// If true, use fade out effect on message.
var bool	bBeep;											// If true, beep!
var bool	bOffsetYPos;									// If the YPos indicated isn't where the message appears.
var int		Lifetime;										// # of seconds to stay in HUD message queue.

var class<LocalMessage> ChildMessage;						// In some cases, we need to refer to a child message.

// Canvas Variables
var bool	bFromBottom;									// Subtract YPos.
var color	DrawColor;										// Color to display message with.
var float	XPos, YPos;										// Coordinates to print message at.
var bool	bCenter;										// Whether or not to center the message.

static function RenderMessage( 
	Canvas Canvas, 
	out float XL,
	out float YL,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	);

static function RenderString(
	Canvas Canvas, 
	out float XL,
	out float YL,
	string StringMessage
	);

static function RenderFadeMessage( 
	Canvas Canvas, 
	out float XL,
	out float YL,
	float FadeTime,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	);

static function RenderFadeString(
	Canvas Canvas, 
	out float XL,
	out float YL,
	float FadeTime,
	string StringMessage
	);

static function RenderComplexMessage( 
	Canvas Canvas, 
	out float XL,
	out float YL,
	optional String MessageString,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	);

static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	return "";
}

static function string AssembleString(
	HUD myHUD,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional String MessageString
	)
{
	return "";
}

static function ClientReceive( 
	PlayerPawn P,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	if ( P.myHUD != None )
		P.myHUD.LocalizedMessage( Default.Class, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject );

	if ( Default.bBeep && P.bMessageBeep )
		P.PlayBeepSound();

	if ( Default.bIsConsoleMessage )
	{
		if ((P.Player != None) && (P.Player.Console != None))
			P.Player.Console.AddString(Static.GetString( Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject ));
	}
}

defaultproperties
{
     Lifetime=3
}
