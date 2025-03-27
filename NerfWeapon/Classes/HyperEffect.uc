//=============================================================================
// HyperEffect.
//=============================================================================
class HyperEffect expands ProjScreen;

#exec TEXTURE IMPORT NAME=HPEffect0 FILE=G:\NerfRes\WeaponEffects\HYPER\HYPR_proj\hprstfx_a00.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=HPEffect1 FILE=G:\NerfRes\WeaponEffects\HYPER\HYPR_proj\hprstfx_a01.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=HPEffect2 FILE=G:\NerfRes\WeaponEffects\HYPER\HYPR_proj\hprstfx_a02.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=HPEffect3 FILE=G:\NerfRes\WeaponEffects\HYPER\HYPR_proj\hprstfx_a03.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=HPEffect4 FILE=G:\NerfRes\WeaponEffects\HYPER\HYPR_proj\hprstfx_a04.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=HPEffect5 FILE=G:\NerfRes\WeaponEffects\HYPER\HYPR_proj\hprstfx_a05.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=HPEffect6 FILE=G:\NerfRes\WeaponEffects\HYPER\HYPR_proj\hprstfx_a06.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=HPEffect7 FILE=G:\NerfRes\WeaponEffects\HYPER\HYPR_proj\hprstfx_a07.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=HPEffect8 FILE=G:\NerfRes\WeaponEffects\HYPER\HYPR_proj\hprstfx_a08.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=HPEffect9 FILE=G:\NerfRes\WeaponEffects\HYPER\HYPR_proj\hprstfx_a09.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=HPEffect10 FILE=G:\NerfRes\WeaponEffects\HYPER\HYPR_proj\hprstfx_a10.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=HPEffect11 FILE=G:\NerfRes\WeaponEffects\HYPER\HYPR_proj\hprstfx_a11.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=HPEffect12 FILE=G:\NerfRes\WeaponEffects\HYPER\HYPR_proj\hprstfx_a12.pcx GROUP=Effects

var float Count;
var Texture TexArray[16];    
var int frameNum;              
var int Maxframe;              

var vector MoveAmount;
var int NumPuffs;
var int numwaits;

replication
{
	// Things the server should send to the client.
	unreliable if( Role==ROLE_Authority )
		MoveAmount, NumPuffs;
}

simulated function Tick( float DeltaTime )
{
	if ( Level.NetMode != NM_DedicatedServer )
	{
		ScaleGlow = (Lifespan/Default.Lifespan)*1.2;
		AmbientGlow = ScaleGlow * 210;
		Count+=DeltaTime;
		if (Count > (LifeSpan/15)) // Lifespan/fps
		{
			Skin = TexArray[frameNum];
	        frameNum++;
			if ( frameNum > Maxframe )    
                frameNum = 0;      
			Count=0;
		}
	}
}


simulated function PostBeginPlay()
{
	if ( Level.NetMode != NM_DedicatedServer )
	{
	    Count=0;
		frameNum=0;
		Maxframe=13;
		SetTimer(0.06, false);
	}
}

simulated function Timer()
{
	local HyperEffect HP;

	if (NumPuffs>0)
	{
		HP = Spawn(class'HyperEffect',,,Location+MoveAmount);
		HP.RemoteRole = ROLE_None;
		HP.NumPuffs = NumPuffs -1;
		HP.MoveAmount = MoveAmount;
	}
}

defaultproperties
{
     TexArray(0)=Texture'NerfWeapon.Effects.HPEffect0'
     TexArray(1)=Texture'NerfWeapon.Effects.HPEffect1'
     TexArray(2)=Texture'NerfWeapon.Effects.HPEffect2'
     TexArray(3)=Texture'NerfWeapon.Effects.HPEffect3'
     TexArray(4)=Texture'NerfWeapon.Effects.HPEffect4'
     TexArray(5)=Texture'NerfWeapon.Effects.HPEffect5'
     TexArray(6)=Texture'NerfWeapon.Effects.HPEffect6'
     TexArray(7)=Texture'NerfWeapon.Effects.HPEffect7'
     TexArray(8)=Texture'NerfWeapon.Effects.HPEffect8'
     TexArray(9)=Texture'NerfWeapon.Effects.HPEffect9'
     TexArray(10)=Texture'NerfWeapon.Effects.HPEffect10'
     TexArray(11)=Texture'NerfWeapon.Effects.HPEffect11'
     TexArray(12)=Texture'NerfWeapon.Effects.HPEffect12'
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=0.400000
     Texture=Texture'NerfWeapon.Effects.HPEffect0'
     DrawScale=0.400000
}
