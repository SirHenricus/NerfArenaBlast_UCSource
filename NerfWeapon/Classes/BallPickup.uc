//=============================================================================
// BallPickup.
//=============================================================================
class BallPickup expands BallAmmo;

defaultproperties
{
     AmmoAmount=1
     MaxAmmo=30
     ParentAmmo=Class'NerfWeapon.BallAmmo'
     PickupMessage=You picked up Ball ammo.
     PlayerViewMesh=LodMesh'NerfWeapon.ball'
     PlayerViewScale=0.150000
     PickupViewMesh=LodMesh'NerfWeapon.ball'
     PickupViewScale=0.150000
     Mesh=LodMesh'NerfWeapon.ball'
     DrawScale=0.150000
     CollisionRadius=5.000000
     CollisionHeight=5.000000
}
