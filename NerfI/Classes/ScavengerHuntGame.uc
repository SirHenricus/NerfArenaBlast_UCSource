//=============================================================================
// ScavengerHuntGame.
//
// Intergrated by Wezo 
//=============================================================================
class ScavengerHuntGame extends DeathmatchGame;

var int LastGen;
var int BallGenCount;
var BallGenerator BallGens[20];		// warning: only 20 ball generators per level

function PostBeginPlay()
{
	local int i;

    AIType = AITYPE_ScavengerHunt;
    bGameIsAfoot = false;
	Super.PostBeginPlay();

	if ( Level.NetMode == NM_Standalone )
    {
	    RemainingTime = 0.0;
        FragLimit = 0.0;
    }

	// force the first ball spawns except the Gold Ball
	for (i = 1; i < 7; i++)
		RespawnColorBall(i);
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

log( self$" logging in "$SpawnClass );
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



function DiscardBall(Pawn Other, int BallSlot)
{
	local inventory Inv;

    //TraceLog(class, 10, "in DiscardBall(" $ Other $ "," $ BallSlot $ ")");

	for(Inv = Other.Inventory; Inv != None; Inv = Inv.Inventory)
	{
		if ((Inv.IsA('SHBallPick')) && (SHBallPick(Inv).Sequence == BallSlot))
        {
			Inv.Destroy();
        }
	}
}



function bool CheckBalls( bool bRSFlag )
{
	local SHBallpick b;
	local SHBallproj p;
    local bool bResult;
	local int LevelBallSlot[8], i;

    bResult = false;            // assume none missing

// if pickups ( includes inv ) exist, 'balls' exists
	foreach AllActors ( class 'SHBallpick', b)
		LevelBallSlot[b.Sequence] = 1;

// if projectiles exist, 'balls' exists
	foreach AllActors ( class 'SHBallproj', p)
        LevelBallSlot[p.slot] = 1;

	for ( i=1; i<8; i++)
	{
                                                // are we concerned with ball 7?
		if ((i==7) && !Level.Game.Goldspawned)  // no, skip possible respawn
			continue;
		if (LevelBallSlot[i] == 0)              // if this one is empty...
		{
            bResult = true;                     // make sure we look again
            if ( bRSFlag )                      // are we serious this time?
                RespawnColorBall(i);
		}
	}

    return( bResult );
}



function Timer()
{
	local int TrackTime;
    local bool bCheck;

	Super.Timer();


    if ( bGameInProgress )
    {
    	TrackTime = Level.TimeSeconds%30;
    	if (TrackTime == 1)
    	{
            bCheck = CheckBalls( false );       // check and don't respawn
            if ( bCheck )                       // uh oh, at least one is missing
                bCheck = CheckBalls( true );    // check and respawn
    	}
    }
}



function RespawnColorBall(int Ballslot)
{
	local BallGenerator BG;
    local int   ix;

//    Log(class$ " WES: in RespawnColorBall "$Ballslot );

	// optimization: only enum ballgens on first pass
	if (BallGenCount == 0)
    {
		foreach AllActors(class 'BallGenerator', BG)
        {
//log ( "BG #"$BallGenCount$" is "$BG$" at "$BG.Location );
			BallGens[BallGenCount++] = BG;
        }
    }

	if (BallGenCount < 1)
		return;				// no ball generators in the level

//	BallGens[FRand() * BallGenCount + 1].SpawnColorBall(Ballslot);

//	if (LastGen > BallGenCount)
//		LastGen = FRand() * BallGenCount + 1;

    ix = Rand(BallGenCount-1);      // DSL -- less predictable
	BallGens[ix].SpawnColorBall(Ballslot);
//BroadcastMessage( "SHG telling "$BallGens[ix]$" to pop one out" );
}

function AddDefaultInventory(pawn aPlayer)
{
	local SHBallGun s;
	local Inventory Inv;
    local PointPickup Pp;

    //TraceLog(class, 10, "in AddDefaultInventory(" $ aPlayer $ ")");

//	Super.AddDefaultInventory(aPlayer);
	
    aPlayer.JumpZ = aPlayer.Default.JumpZ * PlayerJumpZScaling();

    Pp = Spawn(class'PointPickup',,, aPlayer.Location);
    if (Pp != None)
    {
        Pp.bHeldItem = true;
        Pp.GiveTo( aPlayer );
        aPlayer.Pointpickup=pp;
    }

    if( aPlayer.IsA('Spectator') )
        return;
    BaseMutator.ModifyPlayer(aPlayer);

    aPlayer.BallHolding = 0;
/*
	if ( aPlayer.FindInventoryType(class'SHBallGun') == None )
    {
    	//spawn a depositor weapon and attach it to bots inventory
    	s = Spawn(class'SHBallGun',,, Location);
    	if (s != None)
    	{
    		s.bHeldItem = true;
    		s.GiveTo( aPlayer );
    	}
    }
*/
    if ( bGameIsAfoot )
        EquipPlayer( aPlayer );
}

function EquipPlayer( pawn Player )
{
    local Weapon newWeapon;
    local class<Weapon> WeapClass;
	local SHBallGun s;

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

	if ( Player.FindInventoryType(class'SHBallGun') == None )
    {
    	//spawn a depositor weapon and attach it to bots inventory
    	s = Spawn(class'SHBallGun',,, Location);
    	if (s != None)
    	{
    		s.bHeldItem = true;
    		s.GiveTo( Player );
    	}
    }



}


function DiscardInventory( Pawn Other )
{
	local actor dropped;
	local inventory Inv;
	local weapon weap;
	local float speed;
	local int i;
	local vector X,Y,Z;
	local Pawn P;
	local int Pos;


	if (Other.DropWhenKilled != None)
	{
		dropped = Spawn(Other.DropWhenKilled,,,Other.Location);
		Inv = Inventory(dropped);
		if (Inv != None)
		{ 
			Inv.RespawnTime = 0.0; //don't respawn
			Inv.BecomePickup();		
		}
		if (dropped != None)
		{
			dropped.RemoteRole = ROLE_DumbProxy;
			dropped.SetPhysics(PHYS_Falling);
			dropped.bCollideWorld = true;
			dropped.Velocity = Other.Velocity + VRand() * 280;
		}
		if (Inv != None)
        {
			Inv.GotoState('PickUp', 'Dropped');
        }
	}					

	if( (Other.Weapon != None) && (Other.Weapon.Class != DefaultWeapon) && 
	(!Other.Weapon.IsA('SHBallGun'))	&& Other.Weapon.bCanThrow)
	{
		speed = VSize(Other.Velocity);
		weap = Other.Weapon;
		weap.Velocity = Normal(Other.Velocity/speed + 0.5 * VRand()) * (speed + 280);
		Other.TossWeapon();
		if ( weap.PickupAmmoCount == 0 )
			weap.PickupAmmoCount = 1;
		Other.Weapon = None;
	}
	Other.SelectedItem = None;	
	for(Inv = Other.Inventory; Inv !=None; Inv = Inv.Inventory)
	{
		if (Inv.IsA('SHBallPick')) 
		{
			speed = VSize(Other.Velocity);
			Inv.Velocity = Normal(Other.Velocity/speed + 0.5 * VRand()) * (speed + 280);
			Other.TossBall(Inv);
		}
		else if (Inv.IsA('PointPickup'))
		{
			Other.GetAxes(FRand()*Rotation,X,Y,Z);
			for( P=Level.PawnList; P!=None; P=P.nextPawn )
			{
				if(P.PlayerReplicationInfo.Score > Other.PlayerReplicationInfo.Score)
					Pos++;
			}
			switch(Pos)
			{
				case 0:	PointPickup(Inv).Skin=Texture'Engine.S_1000point';
						PointPickup(Inv).PickupSound=Sound'Engine.Lozenge.PP1000S';
						PointPickup(Inv).Points=1000;
						break;
				case 1:	PointPickup(Inv).Skin=Texture'Engine.S_750point';
						PointPickup(Inv).PickupSound=Sound'Engine.Lozenge.PP750S';
						PointPickup(Inv).Points=750;
						break;
				case 2:	PointPickup(Inv).Skin=Texture'Engine.S_500point';
						PointPickup(Inv).PickupSound=Sound'Engine.Lozenge.PP500S';
						PointPickup(Inv).Points=500;
						break;
				default:PointPickup(Inv).Skin=Texture'Engine.S_250point';
						PointPickup(Inv).Points=250;
						break;
			}

			Inv.DropFrom(Other.Location + 0.8 * Other.CollisionRadius * X + - 0.5 * Other.CollisionRadius * Y); 
			Inv.LifeSpan=10.00;
			Inv.SetPhysics(PHYS_Rotating);
		}
		else
			Inv.Destroy();
	}

	// reset ball ball holding array
	//for (i = 0; i < 8; i++)
	//	Other.SetHoldingBall(i, False);
	Other.BallHolding = 0;				// faster
}


function CeasePlay()
{
    local NerfIPlayer   p;
    local NerfBots      n;
    local SHBallPick    b;
    local SHBallProj    a;

//log( self$" in CeasePlay()" );

	foreach AllActors ( class 'Shballpick', b)
    {
//log( self$" dispensing with pickup "$b );
        b.Destroy();
    }
	foreach AllActors ( class 'SHBallproj', a)
    {
//log( self$" dispensing with proj "$a );
        a.Destroy();
    }
    foreach AllActors( class 'NerfBots', n )
    {
//log( self$" sending bot "$n$" to the showers" );
        n.BallHolding = 0;
        n.GotoState('GameEnded');
    }
/*
    foreach AllActors( class 'NerfIPlayer', p )
    {
log( self$" sending player "$p$" to the showers" );
        p.BallHolding = 0;
        p.GotoState('Idle');
    }
*/

log( self$" counter to "$coolcount );
    coolcounter = coolcount;
    bGameInProgress = false;
}

defaultproperties
{
     HUDType=Class'NerfI.NerfScavengerHUD'
     MapListType=Class'NerfI.SHmaplist'
     MapPrefix=SH
     BeaconName=SH
     GameName=Ball Blast
}
