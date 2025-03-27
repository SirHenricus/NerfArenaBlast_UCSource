//=============================================================================
// HBTed
//=============================================================================
class HBTed expands MaleHuntBot;

function ForceMeshToExist()
{
    spawn( class'NerfKids.Ted' );
}

function PreBeginPlay()
{
    local float collrad, collhgt;

    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Twisters;
    PlayerReplicationInfo.BotIndex=AKA_Ted;
}

function Texture Face()
{
	return Texture'NerfKids.SkinIcons.I_Ted';
}

defaultproperties
{
     FavoriteWeapon=Class'NerfWeapon.Hyperst'
     Accuracy=0.500000
     CampingRate=0.100000
     Alertness=0.200000
     BaseEyeHeight=40.024925
     EyeHeight=40.024925
     Skill=1.000000
     CombatStyle=0.500000
     Mesh=LodMesh'NerfKids.M_Sport'
     CollisionRadius=25.000000
     CollisionHeight=47.754002
}
