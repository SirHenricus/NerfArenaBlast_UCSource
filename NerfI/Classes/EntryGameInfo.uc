//=============================================================================
// EntryGameInfo.
//
// Intergrated by Wezo at 7-7-99
//=============================================================================
class EntryGameInfo extends NerfGameInfo;

event PreLogin
(
	string Options,
	out string Error
)
{
	local int RealMax;

	RealMax=MaxPlayers;
	MaxPlayers = 0;
	Super.PreLogin(Options, Error);
	MaxPlayers = RealMax;
}

event playerpawn Login
(
	string Portal,
	string Options,
	out string Error,
	class<playerpawn> SpawnClass
)
{
	local int RealMax;
	local PlayerPawn result;

	RealMax=MaxPlayers;
	MaxPlayers = 0;
	result = Super.Login(Portal, Options, Error, SpawnClass);
	MaxPlayers = RealMax;
	return result;
}

defaultproperties
{
}
