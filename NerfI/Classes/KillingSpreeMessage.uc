//
// Switch is the note.
// RelatedPRI_1 is the player on the spree.
//
class KillingSpreeMessage expands CriticalEventLowPlus;

var(Messages)	localized string EndSpreeNote, EndSelfSpree, EndFemaleSpree, MultiKillString;
var(Messages)	localized string SpreeNote[10];
var(Messages)	sound SpreeSound[10];
 
static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	if (RelatedPRI_2 == None)
	{
		if (RelatedPRI_1 == None)
			return "";

		if (RelatedPRI_1.PlayerName != "")
			return RelatedPRI_1.PlayerName@Default.SpreeNote[Switch];
	} 
	else 
	{
		if (RelatedPRI_1 == None)
		{
			if (RelatedPRI_2.PlayerName != "")
			{
				if ( RelatedPRI_2.bIsFemale )
					return RelatedPRI_2.PlayerName@Default.EndFemaleSpree;
				else
					return RelatedPRI_2.PlayerName@Default.EndSelfSpree;
			}
		} 
		else 
		{
			return RelatedPRI_1.PlayerName$Default.EndSpreeNote@RelatedPRI_2.PlayerName;
		}
	}
	return "";
}

static simulated function ClientReceive( 
	PlayerPawn P,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);

	if (RelatedPRI_2 != None)
		return;

	if (RelatedPRI_1 != P.PlayerReplicationInfo)
	{
//##nerf WES FIXME
// Don't have the sound file yet.
//		P.PlaySound(sound'SpreeSound',, 4.0);
		return;
	}
//	P.ClientPlaySound(Default.SpreeSound[Switch]);

}

defaultproperties
{
     EndSpreeNote='s point spree was ended by
     EndSelfSpree=was looking good till he knocked himself out!
     EndFemaleSpree=was looking good till she knocked herself out!
     spreenote(0)=is on a point spree!
     spreenote(1)=is on the loose!
     spreenote(2)=is dominating!
     spreenote(3)=is going bananas!
     spreenote(4)=is unstoppable!
     spreenote(5)=owns you!
     spreenote(6)=needs to find some real competition!
     spreenote(7)=is a GOD!
     bBeep=False
     DrawColor=(R=255,G=255,B=0)
}
