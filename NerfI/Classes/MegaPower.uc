// Created by Wezo

class MegaPower extends Pickup;


#exec MESH IMPORT MESH=MegaPower ANIVFILE=g:\NerfRes\nerfmesh\MODELS\suitPowerSuper_a.3d DATAFILE=g:\NerfRes\nerfmesh\MODELS\suitPowerSuper_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=MegaPower X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=MegaPower SEQ=All                      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=MegaPower MESH=MegaPower
#exec MESHMAP SCALE MESHMAP=MegaPower X=0.055 Y=0.055 Z=0.11

#exec TEXTURE IMPORT NAME=JsuitPowerSuper_01 FILE=g:\NerfRes\nerfmesh\Models\suitPowerSuper_01.PCX GROUP=Skins FLAGS=2	//Material #14

#exec MESHMAP SETTEXTURE MESHMAP=MegaPower NUM=1 TEXTURE=JsuitPowerSuper_01

// Audio sound effects
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\pickups\pkspwr.wav" NAME="MegapickS" GROUP="Pickups"

var() int HealingAmount;
var() bool bSuperHeal;

function PostBeginPlay()
{
	PickupViewMesh=Mesh(DynamicLoadObject("NerfI.MegaPower", class'Mesh'));
	Super.PostBeginPlay();
}

event float BotDesireability(Pawn Bot)
{
	local float desire;

	desire = HealingAmount;
	if ( !bSuperHeal )
		desire = Min(desire, 100 - Bot.Health);

	if ( (Bot.Weapon != None) && (Bot.Weapon.AIRating > 0.3) )
		desire *= 2;
	if ( Bot.Health < 40 )
		return ( FMin(0.03 * desire, 2) );
	else if ( Bot.Health < 100 )
		return ( 0.01 * desire ); 
	else
		return 0;
}

auto state Pickup
{	
	function Touch( actor Other )
	{
		local int HealMax;
	
		if ( ValidTouch(Other) ) 
		{		
			HealMax = Pawn(Other).default.health;
			if (bSuperHeal) HealMax = HealMax * 2.0;
			if (Pawn(Other).Health < HealMax) 
			{
				Pawn(Other).Health += HealingAmount;
				if (Pawn(Other).Health > HealMax) Pawn(Other).Health = HealMax;

				if (Level.Game.LocalLog != None)
					Level.Game.LocalLog.LogPickup(Self, Pawn(Other));
				if (Level.Game.WorldLog != None)
					Level.Game.WorldLog.LogPickup(Self, Pawn(Other));
				if ( PickupMessageClass == None )
					Pawn(Other).ClientMessage(PickupMessage, 'Pickup');
				else
					Pawn(Other).ReceiveLocalizedMessage( PickupMessageClass, 0, None, None, Self.Class );
				PlaySound (PickupSound,,2.5);
				if ( Level.Game.Difficulty > 1 )
					Other.MakeNoise(0.1 * Level.Game.Difficulty);		
				SetRespawn();
			}
		}
	}
}

defaultproperties
{
     HealingAmount=100
     bSuperHeal=True
     PickupMessage=You picked up a Mega Power
     RespawnTime=90.000000
     MaxDesireability=1.000000
     PickupSound=Sound'NerfI.Pickups.MegapickS'
     RemoteRole=ROLE_DumbProxy
     Mesh=LodMesh'NerfI.MegaPower'
     AmbientGlow=64
     CollisionRadius=25.000000
     CollisionHeight=23.000000
     Mass=10.000000
}
