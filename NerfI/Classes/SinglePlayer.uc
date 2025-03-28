//=============================================================================
// SinglePlayer.
//
// default game info is normal single player
//
// Intergrated by Wezo at 7-7-99
//=============================================================================
class SinglePlayer extends NerfGameInfo;

var string StartMap;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	bClassicDeathmessages = True;
}

function PlayTeleportEffect( actor Incoming, bool bOut, bool bSound)
{
}

function DiscardInventory(Pawn Other)
{
	if ( Other.Weapon != None )
		Other.Weapon.PickupViewScale *= 0.7;
	Super.DiscardInventory(Other);
}

defaultproperties
{
     StartMap=..\maps\RR-Amateur.unr
     bHumansOnly=True
     GameName=Nerf
}
