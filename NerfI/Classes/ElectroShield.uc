//=============================================================================
// ElectroShield - Lessens damage from hits (aka Armor)
// DWG 3/1/99
//=============================================================================

class ElectroShield extends Pickup;

#exec MESH IMPORT MESH=ElectroShield ANIVFILE=g:\NerfRes\NerfMesh\MODELS\shield_a.3d DATAFILE=g:\NerfRes\NerfMesh\MODELS\shield_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=ElectroShield X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=ElectroShield SEQ=All                      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=ElectroShield MESH=ElectroShield
#exec MESHMAP SCALE MESHMAP=ElectroShield X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jshield_01 FILE=g:\NerfRes\NerfMesh\MODELS\shield_01.PCX GROUP=Skins FLAGS=2	//Material #3
#exec TEXTURE IMPORT NAME=Jshield_02 FILE=g:\NerfRes\NerfMesh\MODELS\shield_02.PCX GROUP=Skins FLAGS=2	//Material #2

#exec MESHMAP SETTEXTURE MESHMAP=ElectroShield NUM=1 TEXTURE=Jshield_01
#exec MESHMAP SETTEXTURE MESHMAP=ElectroShield NUM=2 TEXTURE=Jshield_02

// Audio sound effects
// ##nerf WES Sounds
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\pickups\pkfldsld.wav" NAME="ESpickS" GROUP="Pickups"

var() localized String RechargeMessage; // Messages shown when pickup charge refilled

function PostBeginPlay()
{
	PickupViewMesh=Mesh(DynamicLoadObject("NerfI.ElectroShield", class'Mesh'));
	Super.PostBeginPlay();
}


event float BotDesireability( pawn Bot )
{
    local Inventory AlreadyHas;
    local float desire;

    desire = MaxDesireability;
    AlreadyHas = Bot.FindInventoryType(class);
    if ( AlreadyHas != None )
        desire = 0.0;
//log( Bot$" check desire for "$self$" and got "$desire$" Already = "$AlreadyHas );
    return desire;
}

function bool HandlePickupQuery( inventory Item )
{
    if ( Item.class == class )      // one of us?
    {
        if ( Charge < Default.Charge )
        {
            Charge = Default.Charge;
			if ( PickupMessageClass == None )
				Pawn(Owner).ClientMessage(RechargeMessage, 'Pickup');
			else
				Pawn(Owner).ReceiveLocalizedMessage( PickupMessageClass, 0, None, None, Self.Class );
			Item.PlaySound (PickupSound,,2.0);
			Item.SetReSpawn();
        }
        return true;        // fergeddit
    }

	if ( Inventory == None )
		return false;

	return Inventory.HandlePickupQuery(Item);
}

// dead code - not sharing battery with Whomper
/* ============================================
function bool ChargeUp(Pawn Other)
{
    local Ammo AmmoType;
    local bool bOTT;    // OverTheTop ?

    bOTT = false;
    AmmoType = Ammo(Other.FindInventoryType(class'ElectroPak'));
    if ( AmmoType != None )
    {
        if ( AmmoType.AmmoAmount == AmmoType.MaxAmmo )
            bOTT = true;
        else
            AmmoType.AddAmmo(50);
    }
    else
    {
        AmmoType = Spawn(class'ElectroPak');
        Other.AddInventory(AmmoType);
        AmmoType.BecomeItem();
        AmmoType.AmmoAmount = 50;
        AmmoType.GotoState('Idle2');    // null state, waiting to be used up
    }

    return bOTT;
}

function PickupFunction(Pawn Other)
{
    Owner.PlaySound(ActivateSound);
    ChargeUp( Other );
}

// this function will be called only if there
// is already an ElectroShield in owner-pawn's inventory,
// sitting there just waiting to execute this function
function bool HandlePickupQuery( inventory Item )
{
	if (Item.class == class) 
	{
        if ( !ChargeUp(Pawn(Owner)) )      // just gas up, don't re-suit
            Item.SetReSpawn();             // don't take it unless we used it
        else if ( Pawn(Owner).IsA('NerfBots') )
            Item.SetReSpawn();              // DSL - FIXME - bot will stay
		return true;				        // right here unless item disappears    
	}                                       // which doesn't seem fair

	if ( Inventory == None )
		return false;

	return Inventory.HandlePickupQuery(Item);
}

function Timer()
{
    enable('touch');
    GotoState('Pickup');
}

============================================*/
// end of dead code

defaultproperties
{
     RechargeMessage=You recharged your Electro Shield
     ExpireMessage=Your ElectroShield has expired
     bDisplayableInv=True
     bRotatingPickup=True
     PickupMessage=You got the Electro Shield
     RespawnTime=30.000000
     Charge=100
     ArmorAbsorption=95
     bIsAnArmor=True
     AbsorptionPriority=7
     MaxDesireability=1.800000
     PickupSound=Sound'NerfI.Pickups.ESpickS'
     RemoteRole=ROLE_DumbProxy
     Mesh=LodMesh'NerfI.ElectroShield'
     AmbientGlow=64
     CollisionRadius=40.000000
     CollisionHeight=28.000000
}
