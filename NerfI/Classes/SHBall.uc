//=============================================================================
// SHBall
// This is really just a dummy ammo class used to
// fake out the weapons system for SHBallGun 
//=============================================================================
class SHBall extends Ammo;

//##nerf WES 
// It's just a dummy ammo class so it doesn't really need a mesh. Sound is not needed as well

defaultproperties
{
     AmmoAmount=1
     MaxAmmo=7
     UsedInWeaponSlot(11)=1
     bCollideActors=True
}
