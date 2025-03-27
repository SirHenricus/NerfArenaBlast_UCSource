//=============================================================================
// BAP.
//=============================================================================
class BAP expands WhomProj;

auto state Flying
{

	simulated function Explode(vector HitLocation, vector HitNormal)
	{
		local WhomExp s;
		local ShockWave sw;

		HurtRadius(Damage,300.0, MyDamageType, MomentumTransfer, HitLocation );	 		 		
		s = Spawn(class'WhomExp',,,HitLocation+HitNormal*9);
		s.RemoteRole = ROLE_None;
 		sw = spawn(class'ShockWave',,,HitLocation+ HitNormal*16);
		sw.ExpRadius = 400;
		sw.MaxScale = 8;
		PlaySound(ImpactSound);
 		Destroy();
	}

	function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, name damageType)
	{
		Explode(HitLocation,Normal(HitLocation));
	}

}

defaultproperties
{
     speed=1000.000000
     Damage=120.000000
     bProjTarget=True
}
