//
// An Nerf ArenaBlast Death Message.
//
// Switch 0: Kill
//	RelatedPRI_1 is the Killer.
//	RelatedPRI_2 is the Victim.
//	OptionalObject is the Killer's Weapon Class.
//
// Switch 1: Suicide
//	RelatedPRI_1 guy who killed himself.

class DeathMessagePlus extends LocalMessagePlus;

var localized string KilledString;

static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject 
	)
{
	switch (Switch)
	{
		case 0:
			if (RelatedPRI_1 == None)
				return "";
			if (RelatedPRI_2 == None)
				return "";
			if (Class<Weapon>(OptionalObject) == None)
			{
				return "";
			}
			return class'GameInfo'.Static.ParseKillMessage(
				RelatedPRI_1.PlayerName, 
				RelatedPRI_2.PlayerName,
				Class<Weapon>(OptionalObject).Default.ItemName,
				Class<Weapon>(OptionalObject).Default.DeathMessage
			);
			break;
		case 1:
			if (RelatedPRI_1 == None)
				return "";
			return RelatedPRI_1.PlayerName$class'NerfGameInfo'.Static.GenderKillMessage(RelatedPRI_1);
			break;
	}
}

static function ClientReceive( 
	PlayerPawn P,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	if (RelatedPRI_1 == P.PlayerReplicationInfo)
	{
		// Interdict and send the child message instead.
		if ( NerfIPlayer(P).myHUD != None )
		{
			NerfIPlayer(P).myHUD.LocalizedMessage( Default.ChildMessage, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject );
			NerfIPlayer(P).myHUD.LocalizedMessage( Default.Class, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject );
		}

		if ( Default.bIsConsoleMessage )
		{
			NerfIPlayer(P).Player.Console.AddString(Static.GetString( Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject ));
		}

		if (( RelatedPRI_1 != RelatedPRI_2 ) && ( RelatedPRI_2 != None ))
		{
			if ( (NerfIPlayer(P).Level.TimeSeconds - NerfIPlayer(P).LastKillTime < 3) && (Switch != 1) )
			{
				NerfIPlayer(P).MultiLevel++;
				NerfIPlayer(P).ReceiveLocalizedMessage( class'MultiKillMessage', NerfIPlayer(P).MultiLevel );
			} 
			else
				NerfIPlayer(P).MultiLevel = 0;
			NerfIPlayer(P).LastKillTime = NerfIPlayer(P).Level.TimeSeconds;
		}
		else
			NerfIPlayer(P).MultiLevel = 0;
		if ( NerfHUD(P.MyHUD) != None )
			NerfHUD(P.MyHUD).ScoreTime = NerfIPlayer(P).Level.TimeSeconds;
	} else if (RelatedPRI_2 == P.PlayerReplicationInfo) {
		NerfIPlayer(P).ReceiveLocalizedMessage( class'VictimMessage', 0, RelatedPRI_1 );
		Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
	} else
		Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}

defaultproperties
{
     KilledString=was knocked out by 
     ChildMessage=Class'NerfI.KillerMessagePlus'
     DrawColor=(R=255)
}
