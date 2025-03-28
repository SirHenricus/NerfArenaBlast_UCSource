//=============================================================================
// ChampionshipGame.
//
// Intergrated by Wezo 
//=============================================================================
class ChampionshipGame extends DeathmatchGame;

var int RemainPawn;

event InitGame( string Options, out string Error )
{
	local string InOpt;
//	local Class<Mutator> M;
	local Inventory Inv;

	Super.InitGame(Options, Error);

	SetGameSpeed(GameSpeed);
	FragLimit = GetIntOption( Options, "FragLimit", FragLimit );
   	TimeLimit = GetIntOption( Options, "TimeLimit", TimeLimit );

	InOpt = ParseOption( Options, "CoopWeaponMode");
	if ( InOpt != "" )
	{
		log("CoopWeaponMode "$bool(InOpt));
		bCoopWeaponMode = bool(InOpt);
	}

//##nerf WES
// Not using Mutator here cause Mutator got call even after the game launch and
// we just neet to do it once.

	Foreach AllActors(class'Inventory', Inv)
	{
		Inv.Respawntime=0.0;
		Inv.Destroy();
	}
}

function PostBeginPlay()
{
	Super.PostBeginPlay();
	InitialBots=8;
	RemainPawn=InitialBots;
//	log(class$ " WES: RemainPawn is" @RemainPawn);
    TimeLimit = 0.0;
}

//
// Spawn any default inventory for the player.
//
function AddDefaultInventory( pawn PlayerPawn )
{
	local Weapon newWeapon;
	local class<Weapon> WeapClass;

	PlayerPawn.JumpZ = PlayerPawn.Default.JumpZ * PlayerJumpZScaling();
	 
	if( PlayerPawn.IsA('Spectator') )
		return;
	BaseMutator.ModifyPlayer(PlayerPawn);

	// Spawn default weapon.
	WeapClass = BaseMutator.MutatedDefaultWeapon();
	if( WeapClass==None || PlayerPawn.FindInventoryType(WeapClass)!=None )
		return;

	GiveEveryThing(PlayerPawn);
	GivePowerUp(PlayerPawn);
/*
	newWeapon = Spawn(WeapClass);
	if( newWeapon != None )
	{
		newWeapon.Instigator = PlayerPawn;
		newWeapon.BecomeItem();
		PlayerPawn.AddInventory(newWeapon);
		newWeapon.BringUp();
		newWeapon.GiveAmmo(PlayerPawn);
		newWeapon.SetSwitchPriority(PlayerPawn);
		newWeapon.WeaponSet(PlayerPawn);
	}
*/
}

function GiveEveryThing(pawn PlayerPawn)
{
	local int i;

	for(i=0; i<10; i++)
	{
		switch(i)
		{
			case 0:	GiveWeapon(PlayerPawn, class'SShot');
					break;
			case 1:	GiveWeapon(PlayerPawn, class<Weapon>(DynamicLoadObject("NerfWeapon.Ballzoka", class'Class')));
					break;
			case 2:	GiveWeapon(PlayerPawn, class<Weapon>(DynamicLoadObject("NerfWeapon.turbofir", class'Class')));
					break;
			case 3:	GiveWeapon(PlayerPawn, class<Weapon>(DynamicLoadObject("NerfWeapon.scatter", class'Class')));
					break;
			case 4:	GiveWeapon(PlayerPawn, class<Weapon>(DynamicLoadObject("NerfWeapon.MightyMo", class'Class')));
					break;
			case 5:	GiveWeapon(PlayerPawn, class<Weapon>(DynamicLoadObject("NerfWeapon.Pulsator", class'Class')));
					break;
			case 6:	GiveWeapon(PlayerPawn, class<Weapon>(DynamicLoadObject("NerfWeapon.Tripleshot", class'Class')));
					break;
			case 7:	GiveWeapon(PlayerPawn, class<Weapon>(DynamicLoadObject("NerfWeapon.hyperst", class'Class')));
					break;
			case 8:	GiveWeapon(PlayerPawn, class<Weapon>(DynamicLoadObject("NerfWeapon.sidewind", class'Class')));
					break;
			case 9:	GiveWeapon(PlayerPawn, class<Weapon>(DynamicLoadObject("NerfWeapon.whomper", class'Class')));
					break;
		}
	}

}

function GiveWeapon(pawn PlayerPawn, class<Weapon> WeapClass)
{
	local Weapon newWeapon;

	newWeapon = Spawn(WeapClass);
	if( newWeapon != None )
	{
		newWeapon.Instigator = PlayerPawn;
		newWeapon.BecomeItem();
		PlayerPawn.AddInventory(newWeapon);
		newWeapon.BringUp();
		newWeapon.GiveAmmo(PlayerPawn);
		newWeapon.SetSwitchPriority(PlayerPawn);
		newWeapon.WeaponSet(PlayerPawn);
	}
	else
		log(" Fail to give weapon to" @PlayerPawn);
}

function GivePowerUp(pawn PlayerPawn)
{
	local Pickup Powerup;
	
	Powerup = Spawn(class'MegaPower');
	if( Powerup != None )
	{
		Powerup.bHeldItem = true;
		Powerup.RespawnTime = 0.0;
		Powerup.GiveTo(PlayerPawn);
		Powerup.Activate();
	}

	Powerup = Spawn(class'ElectroShield');
	if( Powerup != None )
	{
		Powerup.bHeldItem = true;
		Powerup.RespawnTime = 0.0;
		Powerup.GiveTo(PlayerPawn);
		Powerup.Activate();
	}
}

function DiscardInventory( Pawn Other )
{
	local actor dropped;
	local inventory Inv, BonusHealth;
	local weapon weap;
	local float speed;
	local vector X,Y,Z;
	local Pawn P;
	local int Pos;

	if( Other.DropWhenKilled != None )
	{
		dropped = Spawn(Other.DropWhenKilled,,,Other.Location);
		Inv = Inventory(dropped);
		if ( Inv != None )
		{ 
			Inv.RespawnTime = 0.0; //don't respawn
			Inv.Charge=Other.DropWhenKilledCharge;
			Inv.BecomePickup();		
		}
		if ( dropped != None )
		{
			dropped.RemoteRole = ROLE_DumbProxy;
			dropped.SetPhysics(PHYS_Falling);
			dropped.bCollideWorld = true;
			dropped.Velocity = Other.Velocity + VRand() * 280;
		}
		if ( Inv != None )
			Inv.GotoState('PickUp', 'Dropped');
	}					
	if( (Other.Weapon!=None) && (Other.Weapon.Class!=Level.Game.BaseMutator.MutatedDefaultWeapon()) 
		&& Other.Weapon.bCanThrow )
	{
		speed = VSize(Other.Velocity);
		weap = Other.Weapon;
		if (speed != 0)
			weap.Velocity = Normal(Other.Velocity/speed + 0.5 * VRand()) * (speed + 280);
		else {
			weap.Velocity.X = 0;
			weap.Velocity.Y = 0;
			weap.Velocity.Z = 0;
		}
		Other.TossWeapon();
		if ( weap.PickupAmmoCount == 0 )
			weap.PickupAmmoCount = 1;
	}
	Other.Weapon = None;
	Pos=0;
	Other.SelectedItem = None;	
	for( Inv=Other.Inventory; Inv!=None; Inv=Inv.Inventory )
			Inv.Destroy();

	Other.GetAxes(FRand()*Rotation,X,Y,Z);

//##nerf WES
// Check ranking	
	for( P=Level.PawnList; P!=None; P=P.nextPawn )
	{
		if(P.PlayerReplicationInfo.Score > Other.PlayerReplicationInfo.Score)
			Pos++;
	}
	switch(Pos)
	{
		case 0:	BonusHealth=Spawn(class'NerfI.MegaPower',,,Other.Location);
				break;
		case 1:	BonusHealth=Spawn(class'NerfI.SuitPowerPlus',,,Other.Location);
				break;
		case 2:	BonusHealth=Spawn(class'NerfI.SuitPower',,,Other.Location);
				break;
		default:BonusHealth=Spawn(class'NerfI.ElectroShield',,,Other.Location);
				break;
	}

	BonusHealth.DropFrom(Other.Location + 0.8 * Other.CollisionRadius * X + - 0.5 * Other.CollisionRadius * Y); 
	BonusHealth.LifeSpan=0.00;
	BonusHealth.SetPhysics(PHYS_Rotating);
}

function int ReduceDamage(int Damage, name DamageType, pawn injured, pawn instigatedBy)
{
	if (injured.Region.Zone.bNeutralZone)
		return 0;

	if ( instigatedBy == None)
		return (Damage/2);

	if ( bHardCoreMode )
		Damage *= 1.5;

	//skill level modification
	if ( (instigatedBy.Skill < 1.5) && instigatedBy.IsA('NerfBots') && injured.IsA('PlayerPawn') )
		Damage = Damage * (0.7 + 0.15 * instigatedBy.skill);

	return ((Damage * instigatedBy.DamageScaling)/2);
}

//
// Restart a player.
//
function bool RestartPlayer( pawn aPlayer )	
{
	local Pawn P;

//	log(class$ " WES: bRestartLevel" @bRestartLevel);
//	log(class$ " WES: NetMode" @Level.NetMode);
//	log(class$ " WES: aPlayer" @aPlayer);
//	log(class$ " WES: Is he a player" @aPlayer.bIsPlayer);


	for( P=Level.PawnList; P!=None; P=P.nextPawn )
	{
		if(P == aPlayer)
		{
//			log(class$ " WES: Someone die" @aPlayer);
//			log(class$ " WES: Is he a bot" @aPlayer.PlayerReplicationInfo.bIsABot);
//			log(class$ " WES: Remainpawns" @RemainPawn);
			RemainPawn--;
			aPlayer.PlayerReplicationInfo.bDead = True;
			if (Level.NetMode == NM_StandAlone)
			{
				if (!aPlayer.PlayerReplicationInfo.bIsABot)
				{
//					log(class$ " WES: calling end game, player die");
					Level.Game.EndGame("fraglimit");
				}
				else if (RemainPawn <1)
				{
//					log(class$ " WES: calling end game, player win");
					Level.Game.EndGame("fraglimit");
				}
				else aPlayer.Destroy();
			}
			else if (RemainPawn<1)
				Level.Game.EndGame("fraglimit");
		}
	}


	if( bRestartLevel && Level.NetMode!=NM_DedicatedServer && Level.NetMode!=NM_ListenServer )
		return true;
	return false;
}

defaultproperties
{
     ScoreBoardType=Class'NerfI.NerfChampScoreBoard'
     GameName=ChampionShip
}
