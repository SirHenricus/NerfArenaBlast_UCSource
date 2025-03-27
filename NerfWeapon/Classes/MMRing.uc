//=============================================================================
// MightMoe ring o' death
//=============================================================================
class MMRing expands Effects;

#exec MESH IMPORT MESH=implane ANIVFILE=g:\NerfRes\weaponMesh\Models\Ringex_a.3d DATAFILE=g:\NerfRes\weaponMesh\Models\Ringex_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=implane X=0 Y=0 Z=0 YAW=0 PITCH=64
#exec MESH SEQUENCE MESH=implane SEQ=All STARTFRAME=0  NUMFRAMES=6
#exec MESH SEQUENCE MESH=implane SEQ=Explosion  STARTFRAME=0 NUMFRAMES=6
//#exec OBJ LOAD FILE=g:\NerfRes\weaponMesh\Textures\Smoke2.utx PACKAGE=NerfWeapon.MMRingFX
//#exec MESHMAP SCALE MESHMAP=implane X=1.0 Y=1.0 Z=1.0 YAW=128
//#exec MESHMAP SETTEXTURE MESHMAP=implane NUM=1 TEXTURE=NerfWeapon.MMRingFX.Smoke2

//##nerf WES Sounds FIXNE
// Need to get this file from the net.
//#exec AUDIO IMPORT FILE="Sounds\MM\ExpMMRing.wav" NAME="ExpMMRing" GROUP="MightyMo"

var() Sound ExploSound;
var Texture AnimTex[8];
var int ixAni;
var DartPop dp;
var Rotator MyRotation;

simulated function PostBeginPlay()
{
    if ( Level.NetMode != NM_DedicatedServer )
    {
        dp = Spawn(class'DartPop',,,Location);
        dp.RemoteRole = ROLE_None;
        dp.LightHue = 0;
        dp.LightSaturation = 255;
        dp.LifeSpan = 1.0;
        dp.ScaleGlow = 255;
        PlayAnim( 'Explosion' );
        PlaySound( ExploSound ,,6 );
        ixAni = 0;
    }
    MyRotation = Rotation;
}

simulated function Tick( float DeltaTime )
{
    if ( Level.NetMode != NM_DedicatedServer )
    {
        ScaleGlow = (Lifespan/Default.Lifespan);
        AmbientGlow = ScaleGlow * 255;
        Skin = AnimTex[ixAni];
        ixAni = RandRange( 0.0, 7.0 );
        MyRotation.Roll += 8000;
        MyRotation.Pitch += 2000;
        MyRotation.Yaw += 1000;

        SetRotation( MyRotation );
    }
}
//     Skin= some sort of a palette thingy
//

defaultproperties
{
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=1.000000
     DrawType=DT_Mesh
     Style=STY_Translucent
     Texture=None
     Mesh=LodMesh'NerfWeapon.implane'
     DrawScale=0.100000
     ScaleGlow=64.000000
     bUnlit=True
     LightType=LT_Steady
     LightBrightness=255
     LightHue=20
     LightSaturation=100
     LightRadius=1
}
