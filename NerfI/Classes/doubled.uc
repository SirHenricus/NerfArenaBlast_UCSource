//=============================================================================
// doubled.
//=============================================================================
class doubled extends Pickup;

#exec MESH IMPORT MESH=doubled ANIVFILE=g:\NerfRes\NerfMesh\MODELS\dbdamag_a.3d DATAFILE=g:\NerfRes\NerfMesh\MODELS\dbdamag_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=doubled X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=doubled SEQ=All                      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=doubled MESH=doubled
#exec MESHMAP SCALE MESHMAP=doubled X=0.07 Y=0.07 Z=0.14

//#exec TEXTURE IMPORT NAME=Jdbdamag_01 FILE=g:\NerfRes\NerfMesh\Models\dbdamag_01.PCX GROUP=Skins FLAGS=2	//Material #2
// Double Damage Skin
//#exec TEXTURE IMPORT NAME=DoubSkin FILE=g:\NerfRes\NerfMesh\Models\doubledskin.PCX GROUP="Skins" MIP=OFF
#exec OBJ LOAD FILE=g:\NerfRes\NerfMesh\Textures\Doubledamage.utx PACKAGE=NerfI.Doubledamage

#exec MESHMAP SETTEXTURE MESHMAP=doubled NUM=0 TEXTURE=NerfI.Doubledamage.Doubledamage


// Double Damage Icon
#exec TEXTURE IMPORT NAME=I_doubled FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\i_doubled.PCX GROUP="Icons" FLAGS=2 MIPS=OFF

// Audio sound effects
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\pickups\pkddmg.wav" NAME="DoubpickS" GROUP="Pickups"

var Weapon DDamageWeapon;
var sound ExtraFireSound;
var sound EndFireSound;
var int FinalCount;

function PostBeginPlay()
{
	PickupViewMesh=Mesh(DynamicLoadObject("NerfI.doubled", class'Mesh'));
	Super.PostBeginPlay();
	SetDisplayProperties(ERenderStyle.STY_Translucent, 
									 FireTexture'NerfI.Doubledamage.Doubledamage',
									 true,
									 true);
}

singular function UsedUp()
{
	local NerfWeapon DW;

	if ( DDamageWeapon != None )
	{
		DDamageWeapon.SetDefaultDisplayProperties();
		DDamageWeapon.ThirdPersonScale = 1.000;
		if ( DDamageWeapon.IsA('NerfWeapon') )
			NerfWeapon(DDamageWeapon).Affector = None;
	}
	if ( Owner != None )
	{
		if ( Owner.bIsPawn )
		{
			if ( !Pawn(Owner).bIsPlayer  )
			{
				Owner.bUnlit = false;
				Owner.LightType = LT_None;
			}
			Pawn(Owner).DamageScaling = 1.0;
		}
		bActive = false;
		if ( Owner.Inventory != None )
		{
			Owner.Inventory.SetOwnerDisplay();
			Owner.Inventory.ChangedWeapon();
		}
	}
	Foreach allactors(class'NerfWeapon', DW)
	{
		DW.ThirdPersonScale = DW.Default.ThirdPersonScale;
	}
	Destroy();
}


function FireEffect()
{
	SetLocation(Owner.Location);
	SetBase(Owner);
	if ( TimerRate - TimerCounter < 5 )
		PlaySound(EndFireSound, SLOT_None, 8);
	else 
		PlaySound(ExtraFireSound, SLOT_None, 8);
}

function PickupFunction(Pawn Other)
{
	Other.DropWhenkilled=class<inventory>(DynamicLoadObject("NerfI.doubled", class'Class'));
	SetTimer(1.0,True);
}

function SetOwnerLighting()
{
	if ( Owner.bIsPawn && Pawn(Owner).bIsPlayer)
		
		return;
	Owner.bUnLit = true; 
	Owner.LightEffect=LE_NonIncidence;
	Owner.LightBrightness=255;
	Owner.LightHue=210;
	Owner.LightRadius=10;
	Owner.LightSaturation=0;
	Owner.LightType=LT_Steady;
}

function SetDDamageWeapon()
{
	if ( !bActive )
		return;

	SetOwnerLighting();

	// Make old weapon normal again.
	if ( DDamageWeapon != None )
	{
		DDamageWeapon.SetDefaultDisplayProperties();
		if ( DDamageWeapon.IsA('NerfWeapon') )
			NerfWeapon(DDamageWeapon).Affector = None;
	}
		
	DDamageWeapon = Pawn(Owner).Weapon;
	// Make new weapon cool.
	if ( DDamageWeapon != None )
	{
		if ( DDamageWeapon.IsA('NerfWeapon') )
			NerfWeapon(DDamageWeapon).Affector = self;
		if ( Level.bHighDetailMode )
			DDamageWeapon.SetDisplayProperties(ERenderStyle.STY_Translucent, 

//##nerf WES FIXME
// using standing right now. Need a kick ass FireTexture.
//									 FireTexture'UnrealShare.Belt_fx.UDamageFX',
									 FireTexture'NerfI.Doubledamage.Doubledamage',
									 true,
									 true);
		else
			DDamageWeapon.SetDisplayProperties(ERenderStyle.STY_Normal, 

//##nerf WES FIXME
// using standing right now. Need a kick ass FireTexture.
//									 FireTexture'UnrealShare.Belt_fx.UDamageFX',
									 FireTexture'NerfI.Doubledamage.Doubledamage',
							 true,
							 true);
		DDamageWeapon.ThirdPersonScale=2.000;
	}
}

state Activated
{
/*
	function Timer()
	{
		Pawn(Owner).DropWhenkilledcharge = charge;
		if ( FinalCount > 0 )
		{
			SetTimer(1.0, true);
			Owner.PlaySound(DeActivateSound,, 8);
			FinalCount--;
			return;
		}
		UsedUp();
	}
*/
	function SetOwnerDisplay()
	{
		if( Inventory != None )
			Inventory.SetOwnerDisplay();

		SetDDamageWeapon();
	}

	function ChangedWeapon()
	{
		if( Inventory != None )
			Inventory.ChangedWeapon();

		SetDDamageWeapon();
	}

	function Timer()
	{
		Charge -= 1;
		Pawn(Owner).DropWhenkilledcharge = charge;
		if (Charge<=0) 
		{
			UsedUp();		
		}
		else if ((Charge % 10) ==5)
		{
		//Play Quad Sound
		
		}
	}

	function EndState()
	{
		Pawn(Owner).DropWhenkilled=none;
		Pawn(Owner).DropWhenKilledCharge=0;
		UsedUp();
	}

	function BeginState()
	{
		bActive = true;
		FinalCount = Min(FinalCount, Charge - 1);
		SetTimer(1,True);
		Owner.PlaySound(ActivateSound);	
		SetOwnerLighting();
		Pawn(Owner).DamageScaling = 2.0;
		SetDDamageWeapon();	
	}
}

defaultproperties
{
     FinalCount=5
     bCanActivate=True
     ExpireMessage=Double Damage is out of power
     bAutoActivate=True
     bActivatable=True
     bDisplayableInv=True
     bRotatingPickup=True
     PickupMessage=You got the Double Damage
     RespawnTime=60.000000
     Charge=30
     MaxDesireability=2.000000
     PickupSound=Sound'NerfI.Pickups.DoubpickS'
     RemoteRole=ROLE_DumbProxy
     Style=STY_Translucent
     Mesh=LodMesh'NerfI.doubled'
     bUnlit=True
     bMeshEnviroMap=True
     CollisionRadius=32.000000
     CollisionHeight=28.000000
}
