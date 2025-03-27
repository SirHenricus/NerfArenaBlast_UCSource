//=============================================================================
// RBRyan
//=============================================================================
class RBRyan expands MaleRaceBot;

function ForceMeshToExist()
{
    spawn( class'NerfKids.Ryan' );
}

function PreBeginPlay()
{
    local class<NerfKids> P;
    local float collrad, collhgt;

    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Twisters;
    PlayerReplicationInfo.BotIndex=AKA_Ryan;
}


function Texture Face()
{
	return Texture'NerfKids.SkinIcons.I_Ryan';
}

defaultproperties
{
     FavoriteWeapon=Class'NerfWeapon.Turbofir'
     Accuracy=0.600000
     CampingRate=0.200000
     BaseEyeHeight=34.957966
     EyeHeight=34.957966
     CombatStyle=0.500000
     Skin=Texture'NerfKids.Skins.Ryan'
     Mesh=LodMesh'NerfKids.M_Regular'
     CollisionRadius=25.000000
     CollisionHeight=43.697456
}
