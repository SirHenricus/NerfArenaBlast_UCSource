// Created by Wezo

class SuitPowerPlus extends Pickup;

#exec MESH IMPORT MESH=suitPowerPlus ANIVFILE=g:\NerfRes\nerfmesh\MODELS\suitPowerExtra_a.3d DATAFILE=g:\NerfRes\nerfmesh\MODELS\suitPowerExtra_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=suitPowerPlus X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=suitPowerPlus SEQ=All                      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=suitPowerPlus MESH=suitPowerPlus
#exec MESHMAP SCALE MESHMAP=suitPowerPlus X=0.075 Y=0.075 Z=0.15

#exec TEXTURE IMPORT NAME=JsuitPowerExtra_01 FILE=g:\NerfRes\nerfmesh\Models\suitPowerExtra_01.PCX GROUP=Skins FLAGS=2	//Material #14

#exec MESHMAP SETTEXTURE MESHMAP=suitPowerPlus NUM=1 TEXTURE=JsuitPowerExtra_01

var() int HealingAmount;
var() bool bSuperHeal;

function PostBeginPlay()
{
	PickupViewMesh=Mesh(DynamicLoadObject("NerfI.SuitPowerPlus", class'Mesh'));
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
     HealingAmount=50
     PickupMessage=You picked up a SuitPowerPlus
     RespawnTime=30.000000
     MaxDesireability=0.750000
     PickupSound=Sound'NerfI.Pickups.SuitpickS'
     RemoteRole=ROLE_DumbProxy
     Mesh=LodMesh'NerfI.SuitPowerPlus'
     AmbientGlow=64
     CollisionRadius=25.000000
     CollisionHeight=10.000000
     Mass=10.000000
}
