//=============================================================================
// MOBlast
//=============================================================================
class MOBlast extends ProjScreen;

// use the projection screen to show an amusing animation

#exec TEXTURE IMPORT NAME=MOBlast_0 FILE=G:\NerfRes\WeaponEffects\SECRET_WILD\SS_REG_exp\SSR_00.pcx GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=MOBlast_1 FILE=G:\NerfRes\WeaponEffects\SECRET_WILD\SS_REG_exp\SSR_01.pcx GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=MOBlast_2 FILE=G:\NerfRes\WeaponEffects\SECRET_WILD\SS_REG_exp\SSR_02.pcx GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=MOBlast_3 FILE=G:\NerfRes\WeaponEffects\SECRET_WILD\SS_REG_exp\SSR_03.pcx GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=MOBlast_4 FILE=G:\NerfRes\WeaponEffects\SECRET_WILD\SS_REG_exp\SSR_04.pcx GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=MOBlast_5 FILE=G:\NerfRes\WeaponEffects\SECRET_WILD\SS_REG_exp\SSR_05.pcx GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=MOBlast_6 FILE=G:\NerfRes\WeaponEffects\SECRET_WILD\SS_REG_exp\SSR_06.pcx GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=MOBlast_7 FILE=G:\NerfRes\WeaponEffects\SECRET_WILD\SS_REG_exp\SSR_07.pcx GROUP=Skins FLAGS=2

//=============================================================================
var Texture AnimTex[20];    // ptrs to imported textures
var int ixAni;              // index to current texture
var int ixMax;              // max index ( e.g. max = 7 if there are 8 textures )
var bool bOnceOnly;         // true = show anim once, else cycle
//=============================================================================

simulated function PreBeginPlay()
{
    ixAni = 0;              // current texture is first one
    Super.PreBeginPlay();   // since we overrode, we need to call
}

simulated function Tick( float DeltaTime )
{
    if ( Level.NetMode != NM_DedicatedServer )
    {
        ScaleGlow = (Lifespan/Default.Lifespan);
        AmbientGlow = ScaleGlow * 255;
        Skin = AnimTex[ixAni];
        ixAni++;
        if ( ixAni > ixMax )    // end of a cycle?
        {
            if ( bOnceOnly == True )
                ixAni--;        // yes, stay there
            else
                ixAni = 0;      // else go around again
        }
    }
}

defaultproperties
{
     AnimTex(0)=Texture'NerfI.Skins.MOBlast_0'
     AnimTex(1)=Texture'NerfI.Skins.MOBlast_1'
     AnimTex(2)=Texture'NerfI.Skins.MOBlast_2'
     AnimTex(3)=Texture'NerfI.Skins.MOBlast_3'
     AnimTex(4)=Texture'NerfI.Skins.MOBlast_4'
     AnimTex(5)=Texture'NerfI.Skins.MOBlast_5'
     AnimTex(6)=Texture'NerfI.Skins.MOBlast_6'
     AnimTex(7)=Texture'NerfI.Skins.MOBlast_7'
     ixMax=7
     bOnceOnly=True
     LifeSpan=0.300000
     Skin=Texture'NerfI.Skins.MOBlast_0'
     AmbientGlow=16
}
