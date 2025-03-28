//=============================================================================
// SHBallPick.
//
// Created by Wezo
//=============================================================================
class SHBallPick expands Pickup
	abstract;

#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\pickups\pkball.wav" NAME="SHBallpickS" GROUP="SHBall"

//##nerf WES Textures FIXME
//We might need another low poly ball.
//This Mesh should import in here cause all the balls share this mesh and it's not good to do
//Dynamic load all the time.

#exec MESH IMPORT MESH=SHBalls ANIVFILE=g:\NerfRes\weaponMesh\MODELS\goldball_a.3d DATAFILE=g:\NerfRes\weaponMesh\MODELS\goldball_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=SHBalls X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=SHBalls SEQ=All                      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=SHBalls MESH=SHBalls
#exec MESHMAP SCALE MESHMAP=SHBalls X=0.035 Y=0.035 Z=0.07

#exec MESHMAP SETTEXTURE MESHMAP=SHBalls NUM=0 TEXTURE=DefaultTexture

var()			byte	Sequence;
var(Advanced)	float	LifeSpawn;		// similar to Lifespan but ours respawns

function PreBeginPlay()
{
/*
    local int x,y,z;
    x = int(Location.X);
    y = int(Location.Y);
    z = int(Location.Z);
BroadcastMessage( self$" available for pickup at "$x$" "$y$" "$z );
*/
}

auto state Pickup
{	
	function BeginState()
	{
		//TraceLog(class, 10, "in BeginState()");

		if (LifeSpawn > 0)
		{
			bHeldItem = True;
			SetTimer(LifeSpawn, False);		// set the auto-destruct timer
		}
	}

	function Timer()
	{
		//TraceLog(class $ "[Pickup]", 10, "in Timer()");
		
		if ( RemoteRole != ROLE_SimulatedProxy )
		{
			NetPriority = 2;
			RemoteRole = ROLE_SimulatedProxy;
			if ( bHeldItem )
				SetTimer(LifeSpawn, false);
			return;
		}

		if ( bHeldItem )
		{
//BroadcastMessage( self$" recycling" );
			Destroy();
			Level.Game.RespawnColorBall(Sequence);
		}
	}

	// this is a hack to insure that BallHolding is updated before pawn's AddInventory
	// event is called as well as tricking the weapons system to allow switches to
	// this weapon
	function bool ValidTouch(actor Other)
	{
		local bool Ret;
		local SHBall FakeBall;

		//TraceLog(class, 10, "in ValidTouch(" $ Other $ ")");

		Ret = Super.ValidTouch(Other);
		if (Ret)
		{
    		Pawn(Other).SetHoldingBall(Sequence, True);

			// add fake ammo to gun to fake the weapons system
			// into allowing switching to this weapon
			FakeBall = Spawn(class'SHBall');
			if (FakeBall != None)
				FakeBall.GiveTo(Pawn(Other));
		}
					
		//TraceLog(class, 10, "returning " $ Ret);
		return Ret;
	}

	function Touch( actor Other )
	{
		local Inventory Copy;
	
		//TraceLog(class, 10, "in Touch(" $ Other $ ")");

		if ( ValidTouch(Other) ) 
		{
			Copy = SpawnCopy(Pawn(Other));

			//TraceLog(class $ "[Pickup]", 10, "in Touch(" $ Other $ "). Sequence = " $ Sequence);			

    		Pawn(Other).SetHoldingBall(Sequence, True);
			if (bActivatable && Pawn(Other).SelectedItem == None) 
				Pawn(Other).SelectedItem = Copy;
			if (bActivatable && bAutoActivate && Pawn(Other).bAutoActivate)
				Copy.Activate();
			Pawn(Other).ClientMessage(PickupMessage, 'Pickup');	// add to inventory and run pickupfunction	
			PlaySound(PickupSound,,2.0);	
			Pickup(Copy).PickupFunction(Pawn(Other));
		}
	}

}

defaultproperties
{
     LifeSpawn=90.000000
     PickupMessage=Press 1 to Shoot
     PickupViewMesh=LodMesh'NerfI.SHBalls'
     PickupSound=Sound'NerfI.SHBall.SHBallpickS'
     Mesh=LodMesh'NerfI.SHBalls'
     CollisionRadius=16.000000
     CollisionHeight=16.000000
}
