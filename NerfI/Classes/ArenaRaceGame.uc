//=============================================================================
// ArenaRaceGame.
//
// Intergrated by Wezo at 7-7-99
//=============================================================================
class ArenaRaceGame extends DeathmatchGame;


//##nerf WES FIXME
// I think there's a better way to do it.

function PostBeginPlay()
{
    AIType = AITYPE_ArenaRace;
	Super.PostBeginPlay();
    bGameIsAfoot = false;
	if ( Level.NetMode == NM_Standalone )
    {
	    RemainingTime = 0.0;
        FragLimit = 0.0;
    }
}

event playerpawn Login
(
	string Portal,
	string Options,
	out string Error,
	class<playerpawn> SpawnClass
)
{
	local playerpawn NewPlayer;
    local StartGun sg;

//log( self$" logging in "$SpawnClass );
	NewPlayer = Super.Login(Portal, Options, Error, SpawnClass );
	if ( NewPlayer != None )
	{
		ChangeTeam(newPlayer, newPlayer.PlayerReplicationInfo.TeamType);
		NewPlayer.AirControl = AirControl;
		if ( Left(NewPlayer.PlayerReplicationInfo.PlayerName, 6) == DefaultPlayerName )
			ChangeName( NewPlayer, (DefaultPlayerName$NumPlayers), false );
		NewPlayer.PlayerReplicationInfo.SkinIcon = NewPlayer.Face();
		NewPlayer.bAutoActivate = true;

        foreach AllActors(class'StartGun', sg )
            break;
        if ( sg == None )               // no startgun to start us up?
        {
log( self$" didn't see a startgun" );
            Level.Game.EquipPlayer(NewPlayer);
        }
        else if ( DeathMatchGame(Level.Game).bGameIsAfoot == false )  // startgun has not gone off yet
        {
            NewPlayer.GroundSpeed = -1;
            NewPlayer.AirControl = 0.0;
        }
	}

	return NewPlayer;
}



function EquipPlayer( pawn Player )
{
    local Weapon newWeapon;
    local class<Weapon> WeapClass;

    // Spawn default weapon.
    WeapClass = BaseMutator.MutatedDefaultWeapon();
    if( WeapClass==None || Player.FindInventoryType(WeapClass)!=None )
        return;

    newWeapon = Spawn(WeapClass);
    if( newWeapon != None )
    {
        newWeapon.Instigator = Player;
        newWeapon.BecomeItem();
        Player.AddInventory(newWeapon);
        newWeapon.BringUp();
        newWeapon.GiveAmmo(Player);
        newWeapon.SetSwitchPriority(Player);
        newWeapon.WeaponSet(Player);
    }
}

//
// Spawn any default inventory for the player.
//
function AddDefaultInventory( pawn PlayerPawn )
{
    local PointPickup Pp;

//log( "DSL: ArenaRace version of DefaultInventory for "$PlayerPawn );

    PlayerPawn.JumpZ = PlayerPawn.Default.JumpZ * PlayerJumpZScaling();

//##nerf WES
// Give all the players a Pointpickup to drop when they die.
    Pp = Spawn(class'PointPickup',,, PlayerPawn.Location);
    if (Pp != None)
    {
        Pp.bHeldItem = true;
        Pp.GiveTo( PlayerPawn );
        PlayerPawn.Pointpickup=pp;
    }

    if( PlayerPawn.IsA('Spectator') )
        return;
    BaseMutator.ModifyPlayer(PlayerPawn);

    if ( bGameIsAfoot )
        EquipPlayer(PlayerPawn);
}

function bool RestartPlayer( pawn aPlayer )	
{
    local NavigationPoint startSpot;
	local bool foundStart;

//log( "DSL: ArenaRace version of RestartPlayer at "$aPlayer.SpawnSpot );

	if( bRestartLevel && Level.NetMode!=NM_DedicatedServer && Level.NetMode!=NM_ListenServer )
		return true;

    startSpot = aPlayer.SpawnSpot;

    if ( startSpot == None )
        startSpot = FindPlayerStart(aPlayer, aPlayer.PlayerReplicationInfo.Team);
    if( startSpot == None )
         return false;

	foundStart = aPlayer.SetLocation(startSpot.Location);

//    log( aPlayer$" has spawnspot of "$aPlayer.SpawnSpot$" and fs of "$foundStart );
	if( foundStart )
	{
		startSpot.PlayTeleportEffect(aPlayer, true);
		aPlayer.SetRotation(startSpot.Rotation);
		aPlayer.ViewRotation = aPlayer.Rotation;
		aPlayer.Acceleration = vect(0,0,0);
		aPlayer.Velocity = vect(0,0,0);
		aPlayer.Health = aPlayer.Default.Health;
		aPlayer.SetCollision( true, true, true );
		aPlayer.ClientSetRotation( startSpot.Rotation );
		aPlayer.bHidden = false;

		aPlayer.SoundDampening = aPlayer.Default.SoundDampening;
// recover from our suitdeath routine
        aPlayer.Style = aPlayer.Default.Style;
        aPlayer.bBlockActors = aPlayer.Default.bBlockActors;
		AddDefaultInventory(aPlayer);
	}
	return foundStart;
}

defaultproperties
{
     HUDType=Class'NerfI.NerfArenaRaceHUD'
     MapListType=Class'NerfI.ARmaplist'
     MapPrefix=AR
     BeaconName=AR
     GameName=Speed Blast
}
