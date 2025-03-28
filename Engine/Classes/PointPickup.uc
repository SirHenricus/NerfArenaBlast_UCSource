//=============================================================================
// PointPickup.
//=============================================================================
class PointPickup extends Pickup;

#exec MESH IMPORT MESH=400point ANIVFILE=g:\nerfres\NerfMesh\MODELS\400point_a.3d DATAFILE=g:\NerfRes\NerfMesh\MODELS\400point_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=400point X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=400point SEQ=All                      STARTFRAME=0 NUMFRAMES=10

#exec MESHMAP NEW   MESHMAP=400point MESH=400point
#exec MESHMAP SCALE MESHMAP=400point X=0.065 Y=0.065 Z=0.13

#exec TEXTURE IMPORT NAME=S_1000point FILE=g:\NerfRes\NerfMesh\textures\1000point.PCX GROUP=Skins FLAGS=2	//Material #1
#exec TEXTURE IMPORT NAME=S_750point FILE=g:\NerfRes\NerfMesh\textures\750point.PCX GROUP=Skins FLAGS=2	//Material #1
#exec TEXTURE IMPORT NAME=S_500point FILE=g:\NerfRes\NerfMesh\textures\500point.PCX GROUP=Skins FLAGS=2	//Material #1
#exec TEXTURE IMPORT NAME=S_250point FILE=g:\NerfRes\NerfMesh\textures\250point.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=400point NUM=0 TEXTURE=DefaultTexture

// Audio sound effects
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\pickups\pk1000.wav" NAME="PP1000S" GROUP="Lozenge"
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\pickups\pk750.wav" NAME="PP750S" GROUP="Lozenge"
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\pickups\pk500.wav" NAME="PP500S" GROUP="Lozenge"
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\pickups\pk250.wav" NAME="PP250S" GROUP="Lozenge"

var()			int	Points;

event float BotDesireability(Pawn Bot)
{
	return 1.0;
}

auto state Pickup
{	
	function Touch( actor Other )
	{
		local Inventory Copy;
	
		if (( Pawn(Other)!=None ) && (Pawn(Other).Health > 0))
		{
    		Pawn(Other).PlayerReplicationInfo.Score += Points;
			Pawn(Other).ClientMessage(PickupMessage, 'Pickup');	// add to inventory and run pickupfunction	
			PlaySound(PickupSound,,2.0);	
			Destroy();
		}
	}

}

defaultproperties
{
     Points=250
     bRotatingPickup=True
     PickupMessage=Bonus Points
     PlayerViewMesh=LodMesh'Engine.400point'
     PickupViewMesh=LodMesh'Engine.400point'
     MaxDesireability=1.000000
     PickupSound=Sound'Engine.Lozenge.PP250S'
     Skin=Texture'Engine.Skins.S_250point'
     Mesh=LodMesh'Engine.400point'
     CollisionRadius=22.000000
     CollisionHeight=26.000000
     bCollideWorld=True
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=156
     LightHue=28
     LightSaturation=64
     LightRadius=6
}
