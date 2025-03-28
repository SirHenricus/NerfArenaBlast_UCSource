//=============================================================================
// DefaultDart.
//=============================================================================
class DefaultPowerDart extends NerfDart;

#exec TEXTURE IMPORT NAME=DPDart FILE=g:\NerfRes\weaponMesh\MODELS\reddart.PCX GROUP=Skins 

// Audio sound effects
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\specialfx\htlrmalt.wav" NAME="PowerDartHitS" GROUP="SShot"

/////////////////////////////////////////////////////
auto state Flying
{
	simulated function HitWall( vector HitNormal, actor Wall )
	{
        local PowerBlast mo;           // DSL: using projected sprite for now

		SetPhysics(PHYS_None);		
		MakeNoise(0.3);	
		bOnGround = True;
		PlaySound(ImpactSound);
		SetWall(HitNormal, Wall);

//##nerf WES 
		Wall.TakeDamage(0, Instigator, Location, Vect(0,0,0), 'shot');

// DSL -- using projected sprite in place of dartpop for now
        mo = Spawn(class'PowerBlast',,,Location,Rotation);
        if ( mo != None )
        {
            mo.RemoteRole = ROLE_None;
            mo.DrawScale = 000.600;
        }

	}

	function ProcessTouch( Actor Other, Vector HitLocation )
	{
		if (Other != Instigator)
			BlowUp(HitLocation);
	}

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
					Vector momentum, name damageType)
{
	BlowUp(HitLocation);
	Destroy();
}

function BlowUp(vector HitLocation)
{
	HurtRadius(damage, 35, MyDamageType, MomentumTransfer, HitLocation);
	MakeNoise(1.0);
}

}

defaultproperties
{
     speed=2000.000000
     Damage=15.000000
     ImpactSound=Sound'NerfI.SShot.PowerDartHitS'
     Skin=Texture'NerfI.Skins.DPDart'
}
