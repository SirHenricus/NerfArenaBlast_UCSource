//=============================================================================
// HUD: Superclass of the heads-up display.
//=============================================================================
class HUD extends Actor
	abstract
	native
	config(user);

//=============================================================================
// Variables.

var globalconfig int HudMode;	
var globalconfig int Crosshair;
var() class<menu> MainMenuType;
var() string HUDConfigWindowType;

var	Menu MainMenu;

struct HUDLocalizedMessage
{
	var Class<LocalMessage> Message;
	var int Switch;
	var PlayerReplicationInfo RelatedPRI_1;
	var PlayerReplicationInfo RelatedPRI_2;
	var Object OptionalObject;
	var float EndOfLife;

	var bool bIsString;
	var string StringMessage;
};

//=============================================================================
// Status drawing.

simulated event PreRender( canvas Canvas );
simulated event PostRender( canvas Canvas );
simulated function InputNumber(byte F);
simulated function ChangeHud(int d);
simulated function ChangeCrosshair(int d);
simulated function DrawCrossHair( canvas Canvas, int StartX, int StartY);

//=============================================================================
// Messaging.

simulated function Message( PlayerReplicationInfo PRI, coerce string Msg, name N );
simulated function LocalizedMessage( class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject, optional string CriticalString );

simulated function SetWinnerSplash( bool bOnOff, string Moniker );       // NERF:DSL

simulated function PlayReceivedMessage( string S, string PName, ZoneInfo PZone )
{
	PlayerPawn(Owner).ClientMessage(S);
	if (PlayerPawn(Owner).bMessageBeep)
		PlayerPawn(Owner).PlayBeepSound();
}

// DisplayMessages is called by the Console in PostRender.
// It offers the HUD a chance to deal with messages instead of the
// Console.  Returns true if messages were dealt with.
simulated function bool DisplayMessages(canvas Canvas)
{
	return false;
}

defaultproperties
{
     HUDConfigWindowType=UMenu.UMenuHUDConfigCW
     bHidden=True
     RemoteRole=ROLE_SimulatedProxy
}
