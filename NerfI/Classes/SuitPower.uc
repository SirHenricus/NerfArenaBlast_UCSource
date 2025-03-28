// Created by Wezo
class SuitPower extends PickUp;

#exec MESH IMPORT MESH=suitPower ANIVFILE=g:\NerfRes\nerfmesh\MODELS\suitPowerBasic_a.3d DATAFILE=g:\NerfRes\nerfmesh\MODELS\suitPowerBasic_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=suitPower X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=suitPower SEQ=All                      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=suitPower MESH=suitPower
#exec MESHMAP SCALE MESHMAP=suitPower X=0.05 Y=0.05 Z=0.1

#exec TEXTURE IMPORT NAME=JsuitPowerBasic_01 FILE=g:\NerfRes\nerfmesh\Models\suitPowerBasic_01.PCX GROUP=Skins FLAGS=2	//Material #14

#exec MESHMAP SETTEXTURE MESHMAP=suitPower NUM=1 TEXTURE=JsuitPowerBasic_01

// Audio sound effects
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\pickups\pkpwr.wav" NAME="SuitpickS" GROUP="Pickups"

var() int HealingAmount;
var() bool bSuperHeal;

function PostBeginPlay()
{
	PickupViewMesh=Mesh(DynamicLoadObject("NerfI.SuitPower", class'Mesh'));
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
     HealingAmount=25
     PickupMessage=You picked up a SuitPower +
     RespawnTime=30.000000
     MaxDesireability=0.500000
     PickupSound=Sound'NerfI.Pickups.SuitpickS'
     RemoteRole=ROLE_DumbProxy
     Mesh=LodMesh'NerfI.SuitPower'
     AmbientGlow=64
     CollisionRadius=25.000000
     CollisionHeight=10.000000
     Mass=10.000000
}
