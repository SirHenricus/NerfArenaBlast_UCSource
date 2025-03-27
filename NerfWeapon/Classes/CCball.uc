//=============================================================================
// CCball.
//=============================================================================
class CCball expands Effects;

var texture AnimTex[20];
var int ixAni;
var int ixMax;
var bool bOnceOnly;
var int tcount;

var int chargeAmmount;
var bool bomb;

//This could be the palette for the Effect.
//#exec TEXTURE IMPORT NAME=ExplosionPal2 FILE=textures\exppal.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=TrHit00 FILE=g:\NerfRes\nerfmesh\effects\TRANS_HIT\TrHit_a00.pcx GROUP=Transit
#exec TEXTURE IMPORT NAME=TrHit01 FILE=g:\NerfRes\nerfmesh\effects\TRANS_HIT\TrHit_a01.pcx GROUP=Transit
#exec TEXTURE IMPORT NAME=TrHit02 FILE=g:\NerfRes\nerfmesh\effects\TRANS_HIT\TrHit_a02.pcx GROUP=Transit
#exec TEXTURE IMPORT NAME=TrHit03 FILE=g:\NerfRes\nerfmesh\effects\TRANS_HIT\TrHit_a03.pcx GROUP=Transit
#exec TEXTURE IMPORT NAME=TrHit04 FILE=g:\NerfRes\nerfmesh\effects\TRANS_HIT\TrHit_a04.pcx GROUP=Transit
#exec TEXTURE IMPORT NAME=TrHit05 FILE=g:\NerfRes\nerfmesh\effects\TRANS_HIT\TrHit_a05.pcx GROUP=Transit
#exec TEXTURE IMPORT NAME=TrHit06 FILE=g:\NerfRes\nerfmesh\effects\TRANS_HIT\TrHit_a06.pcx GROUP=Transit
#exec TEXTURE IMPORT NAME=TrHit07 FILE=g:\NerfRes\nerfmesh\effects\TRANS_HIT\TrHit_a07.pcx GROUP=Transit
#exec TEXTURE IMPORT NAME=TrHit08 FILE=g:\NerfRes\nerfmesh\effects\TRANS_HIT\TrHit_a08.pcx GROUP=Transit
#exec TEXTURE IMPORT NAME=TrHit09 FILE=g:\NerfRes\nerfmesh\effects\TRANS_HIT\TrHit_a09.pcx GROUP=Transit
#exec TEXTURE IMPORT NAME=TrHit10 FILE=g:\NerfRes\nerfmesh\effects\TRANS_HIT\TrHit_a10.pcx GROUP=Transit

simulated function PreBeginPlay()
{
    ixAni = 0;              // current texture is first one
    tcount = 10;
    SetTimer( (1/15), true );
    Super.PreBeginPlay();   // since we overrode, we need to call
}

simulated function Timer()
{
    ScaleGlow = (Lifespan/Default.Lifespan);
    AmbientGlow = ScaleGlow * 255;
    Texture = AnimTex[ixAni];
    ixAni++;
    if ( ixAni > ixMax )
        ixAni=0;

		if (DrawScale >= 0.4)
		{
			Destroy();
			bomb=True;
			Disable('Timer');
		}
		else
		{
			DrawScale = ChargeAmmount * 0.02 + 0.1;
			ChargeAmmount++;
		}
}

defaultproperties
{
     AnimTex(0)=Texture'NerfWeapon.Transit.TrHit00'
     AnimTex(1)=Texture'NerfWeapon.Transit.TrHit01'
     AnimTex(2)=Texture'NerfWeapon.Transit.TrHit02'
     AnimTex(3)=Texture'NerfWeapon.Transit.TrHit03'
     AnimTex(4)=Texture'NerfWeapon.Transit.TrHit04'
     AnimTex(5)=Texture'NerfWeapon.Transit.TrHit05'
     AnimTex(6)=Texture'NerfWeapon.Transit.TrHit06'
     AnimTex(7)=Texture'NerfWeapon.Transit.TrHit07'
     AnimTex(8)=Texture'NerfWeapon.Transit.TrHit08'
     AnimTex(9)=Texture'NerfWeapon.Transit.TrHit09'
     AnimTex(10)=Texture'NerfWeapon.Transit.TrHit10'
     ixMax=10
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=2.000000
     DrawType=DT_Sprite
     Style=STY_Translucent
     Texture=Texture'Engine.Transit.TrHit00'
     DrawScale=0.100000
     bUnlit=True
     bCorona=True
}
