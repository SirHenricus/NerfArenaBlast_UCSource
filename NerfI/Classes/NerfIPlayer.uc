//=============================================================================
// NerfIPlayer.
//=============================================================================
class NerfIPlayer extends PlayerPawn
	config(User)
	abstract;

var(Messages)	localized string spreenote[10];
var(Sounds)		Sound Deaths[6];
var int			FaceSkin;
var int			FixedSkin;
var int			TeamSkin1;
var int			TeamSkin2;
var int			MultiLevel;
var string		DefaultSkinName;
var string		DefaultPackage;
var float		LastKillTime;

// dying anims
var     rotator     tmpRotation;
var     vector      tmpLocation;
var     int         spinCounter;

var(Sounds) sound 	drown;
var(Sounds) sound	breathagain;
var(Sounds) sound	Footstep1;
var(Sounds) sound	Footstep2;
var(Sounds) sound	Footstep3;
var(Sounds) sound	HitSound3;
var(Sounds) sound	HitSound4;
var(Sounds) sound	Die2;
var(Sounds) sound	Die3;
var(Sounds) sound	Die4;
var(Sounds) sound	GaspSound;
var(Sounds) sound	UWHit1;
var(Sounds) sound	UWHit2;
var(Sounds) sound	LandGrunt;

var bool bLastJumpAlt;
var  globalconfig bool bInstantRocket;
var	 globalconfig bool bAutoTaunt;
var  globalconfig bool bNoVoiceTaunts;
var bool bNeedActivate;
var int WeaponUpdate;

// HUD status 
var texture StatusDoll, StatusArmor, StatusBelt, StatusPads, StatusBoots;

// allowed voices
var string VoicePackMetaClass;

// DSL additions
var class<VoicePack> VoiceType;
var VoxBox myVox;       // voice
var bool bTrack;        // debug
var Actor Trackee;      // debug


// victory dance steps
var name VDance[8];
var int ixVDance;
var int ixVDMax;


var NavigationPoint StartSpot; //where player started the match

var Weapon ClientPending;

replication
{
	// Things the server should send to the client.
	unreliable if( Role==ROLE_Authority )
		ClientPlayTakeHit, TimeMessage;
	reliable if ( Role == ROLE_Authority )
		SendClientFire, SendClientAltFire, RealWeapon; 
	reliable if ( Role < ROLE_Authority )
		ServerSetTaunt;
}

function PreCacheReferences()
{
	//never called - here to force precaching of meshes
//	spawn(class'TMale1');
//	spawn(class'TMale2');
//	spawn(class'TFemale1');
//	spawn(class'TFemale2');

//	spawn(class'SShot');
//	spawn(class'Ballzoka');
//	spawn(class'Turbofir');
//	spawn(class'Scatter');
//	spawn(class'MightyMo');
//	spawn(class'Pulsator');
//	spawn(class'TripleShot');
//	spawn(class'Hyperst');
//	spawn(class'Sidewind');
//	spawn(class'Whomper');
}

// DSL
function PostBeginPlay()
{
    foreach AllActors( class'VoxBox', myVox )
        break;

	Super.PostBeginPlay();
	PlayerReplicationInfo.VoiceType = VoiceType;
}

function SendClientFire(weapon W, int N)
{
	RealWeapon(W,N);
	if ( Weapon.IsA('NerfWeapon') )
	{
		NerfWeapon(Weapon).bCanClientFire = true;
		NerfWeapon(Weapon).ForceClientFire();
	}
}

function SendClientAltFire(weapon W, int N)
{
	RealWeapon(W,N);
	if ( Weapon.IsA('NerfWeapon') )
	{
		NerfWeapon(Weapon).bCanClientFire = true;
		NerfWeapon(Weapon).ForceClientAltFire();
	}
}

//exec function KillAll(class<actor> aClass)
//{
//	if ( (Level.NetMode != NM_Standalone) && Level.Game.IsA('DeathMatchGame')
//		&& ((aClass == class'NerfBots') || (aClass == class'Pawn')) )
//		DeathMatchGame(Level.Game).MinPlayers = 0;
//
//	Super.KillAll(aClass);
//}

function ClientPutDown(Weapon Current, Weapon Next)
{	
	if ( Role == ROLE_Authority )
		return;
	bNeedActivate = false;
	if ( (Current != None) && (Current != Next) )
		Current.ClientPutDown(Next);
	else if ( Weapon != None )
	{
		if ( Weapon != Next )
			Weapon.ClientPutDown(Next);
		else
		{
			bNeedActivate = false;
			ClientPending = None;
			if ( Weapon.IsInState('ClientDown') || !Weapon.IsAnimating() )
			{
				Weapon.GotoState('idle');
//				log(class$ " WES: Calling Weapon TweenToStill");
				Weapon.TweenToStill();
			}
		}
	}
}

function SendFire(Weapon W)
{
	WeaponUpdate++;
	SendClientFire(W,WeaponUpdate);
}

function SendAltFire(Weapon W)
{
	WeaponUpdate++;
	SendClientAltFire(W,WeaponUpdate);
}

function UpdateRealWeapon(Weapon W)
{
	WeaponUpdate++;
	RealWeapon(W,WeaponUpdate);
}
	
function RealWeapon(weapon Real, int N)
{
	if ( N <= WeaponUpdate )
		return;
	WeaponUpdate = N;
	Weapon = Real;
	if ( !Weapon.IsAnimating() )
	{
		if ( bNeedActivate || (Weapon == ClientPending) )
			Weapon.GotoState('ClientActive');
		else
		{
//			log(class$ " WES: Calling Weapon TweenToStill at RealWeapon");
			Weapon.TweenToStill();
		}
	}
	bNeedActivate = false;
	ClientPending = None;	// make sure no client side weapon changes pending
}

function ClientAdjustPosition
(
	float TimeStamp, 
	name newState, 
	EPhysics newPhysics,
	float NewLocX, 
	float NewLocY, 
	float NewLocZ, 
	float NewVelX, 
	float NewVelY, 
	float NewVelZ,
	Actor NewBase
)
{
	Super.ClientAdjustPosition(TimeStamp, newState, newPhysics, NewLocX, NewLocY, NewLocZ, NewVelX, NewVelY, NewVelZ, NewBase);
	if ( (Weapon != None) && !Weapon.IsAnimating() )
	{
		if ( Weapon == ClientPending )
		{
			Weapon.GotoState('ClientActive');
			ClientPending = None;
			bNeedActivate = false;
		}
		else
		{
//			log(class$ " WES: calling Weapon TweenTostill at ClientAdjustPosition" @ClientPending);
			Weapon.TweenToStill();
		}
	}
}
	
function TimeMessage(int Num)
{
//	local class<CriticalEventPlus> TimeMessageClass;
//
//	TimeMessageClass = class<CriticalEventPlus>(DynamicLoadObject("Botpack.TimeMessage", class'Class'));
//	ReceiveLocalizedMessage( TimeMessageClass, 16 - Num );
}

//function SetVoice(class<ChallengeVoicePack> V)
//{
//	PlayerReplicationInfo.VoiceType = V;
//	UpdateURL("Voice", string(V), True);
//	ServerSetVoice(V);
//}

//function ServerSetVoice(class<ChallengeVoicePack> V)
//{
//	PlayerReplicationInfo.VoiceType = V;
//}

exec function ListBots()
{
	local Pawn P;

	for (P=Level.PawnList; P!=None; P=P.NextPawn)
		if ( P.bIsPlayer && P.IsA('Bot') ) 
			log(P.PlayerReplicationInfo.PlayerName$" skill "$P.Skill);
}

function PreSetMovement()
{
	bCanJump = true;
	bCanWalk = true;
	bCanSwim = true;
	bCanFly = false;
	bCanOpenDoors = true;
	bCanDoSpecial = true;
}

function ServerSetTaunt(bool B)
{
	bAutoTaunt = B;
}

function SetAutoTaunt(bool B)
{
	bAutoTaunt = B;
	ServerSetTaunt(B);
}

function ServerSetInstantRocket(bool B)
{
	bInstantRocket = B;
}

function SetInstantRocket(bool B)
{
	bInstantRocket = B;
	ServerSetInstantRocket(B);
}

event Possess()
{
//	local byte i;
//
//	if ( Level.Netmode == NM_Client )
//	{
//		ServerSetTaunt(bAutoTaunt);
//		ServerSetInstantRocket(bInstantRocket);
//	}

	Super.Possess();
}

function ClientVoiceMessage(PlayerReplicationInfo Sender, PlayerReplicationInfo Recipient, name messagetype, byte messageID)
{
	if ( bNoVoiceTaunts && (messageType == 'TAUNT') )
		return;

	Super.ClientVoiceMessage(Sender, Recipient, messagetype, messageID);
}

function SendGlobalMessage(PlayerReplicationInfo Recipient, name MessageType, byte MessageID, float Wait)
{
	if ( Level.TimeSeconds - OldMessageTime < 5 )
		return;

	SendVoiceMessage(PlayerReplicationInfo, Recipient, MessageType, MessageID, 'GLOBAL');
}


function SendTeamMessage(PlayerReplicationInfo Recipient, name MessageType, byte MessageID, float Wait)
{
	if ( Level.TimeSeconds - OldMessageTime < 10 )
		return;

	SendVoiceMessage(PlayerReplicationInfo, Recipient, MessageType, MessageID, 'TEAM');
}

function Killed(pawn Killer, pawn Other, name damageType)
{
	Super.Killed(Killer, Other, damageType);

	if ( (Killer == self) 
		&& (((bFire == 0) && (bAltFire == 0))
			|| ((Weapon != None) && !Weapon.IsA('Minigun2') && !Weapon.IsA('PulseGun'))) )
		Other.Health = FMin(Other.Health, -11); // don't let other do stagger death
}

/*
exec function Loaded()
{
	local inventory Inv;
	local weapon Weap;
	local DeathMatchGame DM;

	if( Level.Netmode!=NM_Standalone )
		return;

	DM = DeathMatchGame(Level.Game);
	if ( DM == None )
		return;

	DM.GiveWeapon(self, "NerfI.SShot");
	DM.GiveWeapon(self, "NerfWeapon.Ballzoka");
	DM.GiveWeapon(self, "NerfWeapon.Turbofir");
	DM.GiveWeapon(self, "NerfWeapon.Scatter");
	DM.GiveWeapon(self, "NerfWeapon.MightyMo");
	DM.GiveWeapon(self, "NerfWeapon.Pulsator");
	DM.GiveWeapon(self, "NerfWeapon.TripleShot");
	DM.GiveWeapon(self, "NerfWeapon.Hyperst");
	DM.GiveWeapon(self, "NerfWeapon.Sidewind");
	DM.GiveWeapon(self, "NerfWeapon.Whomper");
	
	for ( inv=inventory; inv!=None; inv=inv.inventory )
	{
		weap = Weapon(inv);
		if ( (weap != None) && (weap.AmmoType != None) )
			weap.AmmoType.AmmoAmount = weap.AmmoType.MaxAmmo;
	}

	inv = Spawn(class'NerfI.ElectroShield');
	if( inv != None )
	{
		inv.bHeldItem = true;
		inv.RespawnTime = 0.0;
		inv.GiveTo(self);
	}
	inv = Spawn(class'NerfI.ElectroPak');
	if( inv != None )
	{
		inv.bHeldItem = true;
		inv.RespawnTime = 0.0;
		inv.GiveTo(self);
	}
}
*/

/*
function PlayDodge(eDodgeDir DodgeMove)
{
	Velocity.Z = 210;
	if ( DodgeMove == DODGE_Left )
		TweenAnim('DodgeL', 0.25);
	else if ( DodgeMove == DODGE_Right )
		TweenAnim('DodgeR', 0.25);
	else if ( DodgeMove == DODGE_Back )
		TweenAnim('DodgeB', 0.25);
	else 
		PlayAnim('Flip', 1.35 * FMax(0.35, Region.Zone.ZoneGravity.Z/Region.Zone.Default.ZoneGravity.Z), 0.06);
}
*/

exec event ShowUpgradeMenu()
{
	bSpecialMenu = true;
	SpecialMenu = class'UpgradeMenu';
	ShowMenu();
}

exec function ShowLoadMenu()
{
	bSpecialMenu = true;
	SpecialMenu = class'NerfLoadMenu';
	ShowMenu();
}

function EndSpree(PlayerReplicationInfo Killer, PlayerReplicationInfo Other)
{
	if ( (Killer == Other) || (Killer == None) )
		ReceiveLocalizedMessage( class'KillingSpreeMessage', 1, None, Other );
	else
		ReceiveLocalizedMessage( class'KillingSpreeMessage', 0, Other, Killer );
}

exec function SetAirControl(float F)
{
	if ( bAdmin || (Level.Netmode == NM_Standalone) )
		AirControl = F;
}

exec function Verbose()
{
//	if ( Bot(ViewTarget) != None )
//		Bot(ViewTarget).bVerbose = true;
}

/* Skin Stuff */
static function SetMultiSkin( Actor SkinActor, string SkinName, string FaceName, byte TeamNum )
{
	local Texture NewSkin;
	local string MeshName;
	local int i;
	local string TeamColor[8];

	TeamColor[0]="Twister";
    TeamColor[1]="Tycoon";
    TeamColor[2]="Asteroid";
    TeamColor[3]="Sequoia";
    TeamColor[4]="Luna";
    TeamColor[5]="Barracuda";
    TeamColor[6]="Orbital";
    TeamColor[7]="Gator";


	MeshName = SkinActor.GetItemName(string(SkinActor.Mesh));

	if( InStr(SkinName, ".") == -1 )
		SkinName = MeshName$"Skins."$SkinName;

	if(TeamNum >=0 && TeamNum <= 7)
    {
		NewSkin = texture(DynamicLoadObject(MeshName$"Skins.T_"$TeamColor[TeamNum], class'Texture'));
    }

	// Set skin
	if ( NewSkin != None )
		SkinActor.Skin = NewSkin;
}

exec function Summon( string ClassName )
{
	if( !bAdmin && (Level.Netmode != NM_Standalone) )
		return;
	if( instr(ClassName,".")==-1 )
		ClassName = "NerfI." $ ClassName;
	Super.Summon( ClassName );
}

/*
// DSL -- debuggin object tracker
exec function Locate( string ObjectName )
{
    local Actor A;

    bTrack = False;
    Trackee = None;
    if ( ObjectName != "" )     // no ObjectName = turn off locator
    {
        foreach AllActors( class'Actor', A )
        {
            if ( instr(string(A.Name), ObjectName) > -1  )
            {
                BroadcastMessage( "Found "$A );
                Trackee = A;
                bTrack = True;
                break;
            }
        }
        if ( !bTrack )
            BroadcastMessage( "Unable to find "$ObjectName );
    }
}
*/

// DSL-- fleshing out the J-K-L keys --
// Dave Walls may want different key assignments

exec function Taunt( name Sequence )
{
//BroadcastMessage( "Taunt "$Sequence );
    if ( Sequence != 'None' )
    {
        ServerTaunt( Sequence );
        PlayAnim(Sequence, 0.7, 0.2);
    }
}

// DSL -- victory podium shameless display
simulated function ShowOff()
{
/* DSL -- needs to be part of playerpawn state GameEnd
	bFire = 0;
	bAltFire = 0;
	Enemy = None;
    Velocity = vect(0,0,0);
    Acceleration=vect(0,0,0);
    SetRotation(DesiredRotation);
	SetPhysics(PHYS_Falling);
*/
	LoopAnim('Victory2');
}

function CheckBob(float DeltaTime, float Speed2D, vector Y)
{
	local float OldBobTime;
	local int m,n;

	OldBobTime = BobTime;
	if ( Speed2D < 10 )
		BobTime += 0.2 * DeltaTime;
	else
		BobTime += DeltaTime * (0.3 + 0.7 * Speed2D/GroundSpeed);
	WalkBob = Y * 0.4 * Bob * Speed2D * sin(8 * BobTime);
	AppliedBob = FMin(1, 16 * deltatime) * LandBob + AppliedBob * (1 - FMin(1, 16 * deltatime));
	if ( Speed2D < 10 )
		WalkBob.Z = AppliedBob;
	else
		WalkBob.Z = AppliedBob + 0.3 * Bob * Speed2D * sin(16 * BobTime);
	LandBob *= (1 - 8*Deltatime);

	if ( bBehindView || (Speed2D < 10) )
		return;

	m = int(0.5 * Pi + 9.0 * OldBobTime/Pi);
	n = int(0.5 * Pi + 9.0 * BobTime/Pi);

	if ( m != n )
		FootStepping();
}

//-----------------------------------------------------------------------------
// Sound functions

simulated function PlayFootStep()
{
	if ( !bIsWalking && (Level.Game != None) && ((Weapon == None) || !Weapon.bPointing) )
		MakeNoise(0.1);
	if ( bBehindView || (Role==ROLE_SimulatedProxy) )	
		FootStepping();
}

function PlayDyingSound()
{
	local float rnd;

	if ( HeadRegion.Zone.bWaterZone )
	{
		if ( FRand() < 0.5 )
			PlaySound(UWHit1, SLOT_Pain,,,,Frand()*0.2+0.9);
		else
			PlaySound(UWHit2, SLOT_Pain,,,,Frand()*0.2+0.9);
		return;
	}

	PlaySound(Sound(DynamicLoadObject("NerfRes.DeathHitS", class'Sound')), SLOT_Interface);
}

simulated function PlayBeepSound()
{
//	PlaySound(sound'NewBeep',SLOT_Interface, 2.0);
}

function PlayTakeHitSound(int damage, name damageType, int Mult)
{
	if ( Level.TimeSeconds - LastPainSound < 0.3 )
		return;
	LastPainSound = Level.TimeSeconds;

	if ( HeadRegion.Zone.bWaterZone )
	{
		if ( damageType == 'Drowned' )
			PlaySound(drown, SLOT_Pain, 1.5);
		else if ( FRand() < 0.5 )
			PlaySound(UWHit1, SLOT_Pain,2.0,,,Frand()*0.15+0.9);
		else
			PlaySound(UWHit2, SLOT_Pain,2.0,,,Frand()*0.15+0.9);
		return;
	}
	damage *= FRand();

	if (damage < 8) 
		PlaySound(HitSound1, SLOT_Pain,2.0,,,Frand()*0.15+0.9);
	else if (damage < 25)
	{
		if (FRand() < 0.5) PlaySound(HitSound2, SLOT_Pain,2.0,,,Frand()*0.15+0.9);			
		else PlaySound(HitSound3, SLOT_Pain,2.0,,,Frand()*0.15+0.9);
	}
	else
		PlaySound(HitSound4, SLOT_Pain,2.0,,,Frand()*0.15+0.9);			
}

simulated function FootStepping()
{
	local sound step;
	local float decision;

	if ( FootRegion.Zone.bWaterZone )
	{
		PlaySound(WaterStep, SLOT_Interact, 1, false, 1000.0, 1.0);
		return;
	}

	decision = FRand();
	if ( decision < 0.34 )
		step = Footstep1;
	else if (decision < 0.67 )
		step = Footstep2;
	else
		step = Footstep3;

	if ( bIsWalking )
		PlaySound(step, SLOT_Interact, 0.5, false, 400.0, 1.0);
	else 
		PlaySound(step, SLOT_Interact, 2, false, 800.0, 1.0);
}

function ClientPlayTakeHit(float tweentime, vector HitLoc, int Damage, bool bServerGuessWeapon)
{
	if ( bServerGuessWeapon && ((GetAnimGroup(AnimSequence) == 'Dodge') || ((Weapon != None) && Weapon.bPointing)) )
		return;
	Enable('AnimEnd');
	bAnimTransition = true;
	BaseEyeHeight = Default.BaseEyeHeight;
	PlayTakeHit(tweentime, HitLoc, Damage);
}	

function Gasp()
{
	if ( Role != ROLE_Authority )
		return;
	if ( PainTime < 2 )
		PlaySound(GaspSound, SLOT_Talk, 2.0);
	else
		PlaySound(BreathAgain, SLOT_Talk, 2.0);
}

//-----------------------------------------------------------------------------
// Animation functions
//
//  kids  kids & bots                         bots
//  not   &                                   not
//  bots  bots                                kids
//
//        PlayRunning()
//        PlayWalking()
//        PlayTurning()
//        PlayWaiting()
//        PlayCrawling()
//        PlayRising()
//        PlaySwimming()
//        PlayFiring()
//                                            PlayChallenge()
//    *   PlayChatting()
//    *   PlayRecoil(float Rate)
//        PlayFeignDeath()
//        PlayDuck()
//        PlayGutHit(float tweentime)
//        PlayHeadHit(float tweentime)
//        PlayLeftHit(float tweentime)
//        PlayRightHit(float tweentime)
//        PlayHit(float Damage, vector HitLocation, name damageType, float MomentumZ)
//        PlayDeathHit(float Damage, vector HitLocation, name damageType)
//
//                                            PlayHitAnim(vector HitLocation, float Damage)
//        PlayInAir()
//        PlayLanded(float impactVel)
//        PlayWeaponSwitch(Weapon NewWeapon)
//
//        TweenToWalking(float tweentime)
//        TweenToRunning(float tweentime)
//        TweenToWaiting(float tweentime)
//        TweenToSwimming(float tweentime)
//                                            TweenToFighter()
//

/*
function PlayChatting()
{
	if ( mesh != None )
		LoopAnim('Chat1', 0.7, 0.25);
}
*/

function PlayWaiting()
{
	local name newAnim;

	if ( Mesh == None )
		return;

	if ( bIsTyping )
	{
		PlayChatting();
		return;
	}

	if ( (IsInState('PlayerSwimming')) || (Physics == PHYS_Swimming) )
	{
		BaseEyeHeight = 0.7 * Default.BaseEyeHeight;
		if ( (Weapon == None) || (Weapon.Mass < 20) )
			LoopAnim('TreadSM');
		else
			LoopAnim('TreadLG');
	}
	else
	{	
		BaseEyeHeight = Default.BaseEyeHeight;
		ViewRotation.Pitch = ViewRotation.Pitch & 65535;
		If ( (ViewRotation.Pitch > RotationRate.Pitch) 
			&& (ViewRotation.Pitch < 65536 - RotationRate.Pitch) )
		{
			If (ViewRotation.Pitch < 32768) 
			{
				if ( (Weapon == None) || (Weapon.Mass < 20) )
					TweenAnim('AimUpSm', 0.3);
				else
					TweenAnim('AimUpLg', 0.3);
			}
			else
			{
				if ( (Weapon == None) || (Weapon.Mass < 20) )
					TweenAnim('AimDnSm', 0.3);
				else
					TweenAnim('AimDnLg', 0.3);
			}
		}
		else if ( (Weapon != None) && Weapon.bPointing )
		{
			if ( Weapon.bRapidFire && ((bFire != 0) || (bAltFire != 0)) )
				LoopAnim('StillFRRP');
			else if ( Weapon.Mass < 20 )
				TweenAnim('StillSMFR', 0.3);
			else
				TweenAnim('StillFRRP', 0.3);
		}
		else
		{
			if ( FRand() < 0.1 )
			{
				if ( (Weapon == None) || (Weapon.Mass < 20) )
					PlayAnim('CockGun', 0.5 + 0.5 * FRand(), 0.3);
				else
					PlayAnim('CockGunL', 0.5 + 0.5 * FRand(), 0.3);
			}
			else
			{
				if ( (Weapon == None) || (Weapon.Mass < 20) )
				{
					if ( (FRand() < 0.75) && ((AnimSequence == 'Breath1') || (AnimSequence == 'Breath2')) )
						newAnim = AnimSequence;
					else if ( FRand() < 0.5 )
						newAnim = 'Breath1';
					else
						newAnim = 'Breath2';
				}
				else
				{
					if ( (FRand() < 0.75) && ((AnimSequence == 'Breath1L') || (AnimSequence == 'Breath2L')) )
						newAnim = AnimSequence;
					else if ( FRand() < 0.5 )
						newAnim = 'Breath1L';
					else
						newAnim = 'Breath2L';
				}
								
				if ( AnimSequence == newAnim )
					LoopAnim(newAnim, 0.4 + 0.4 * FRand());
				else
					PlayAnim(newAnim, 0.4 + 0.4 * FRand(), 0.25);
			}
		}
	}
}


function PlayTurning()
{
	BaseEyeHeight = Default.BaseEyeHeight;
	if ( (Weapon == None) || (Weapon.Mass < 20) )
		PlayAnim('TurnSM', 0.3, 0.3);
	else
		PlayAnim('TurnLG', 0.3, 0.3);
}

function TweenToWalking(float tweentime)
{
	BaseEyeHeight = Default.BaseEyeHeight;
	if (Weapon == None)
		TweenAnim('Walk', tweentime);
	else if ( Weapon.bPointing || (CarriedDecoration != None) ) 
	{
		if (Weapon.Mass < 20)
			TweenAnim('WalkSMFR', tweentime);
		else
			TweenAnim('WalkLGFR', tweentime);
	}
	else
	{
		if (Weapon.Mass < 20)
			TweenAnim('WalkSM', tweentime);
		else
			TweenAnim('WalkLG', tweentime);
	} 
}

function PlayWalking()
{
	BaseEyeHeight = Default.BaseEyeHeight;
	if (Weapon == None)
		LoopAnim('Walk');
	else if ( Weapon.bPointing || (CarriedDecoration != None) ) 
	{
		if (Weapon.Mass < 20)
			LoopAnim('WalkSMFR');
		else
			LoopAnim('WalkLGFR');
	}
	else
	{
		if (Weapon.Mass < 20)
			LoopAnim('WalkSM');
		else
			LoopAnim('WalkLG');
	}
}

function TweenToRunning(float tweentime)
{
	local vector X,Y,Z, Dir;

	BaseEyeHeight = Default.BaseEyeHeight;
	if (bIsWalking)
	{
		TweenToWalking(0.1);
		return;
	}

	GetAxes(Rotation, X,Y,Z);
	Dir = Normal(Acceleration);
	if ( (Dir Dot X < 0.75) && (Dir != vect(0,0,0)) )
	{
		// strafing or backing up
		if ( Dir Dot X < -0.75 )
			PlayAnim('BackRun', 0.9, tweentime);
		else if ( Dir Dot Y > 0 )
			PlayAnim('StrafeR', 0.9, tweentime);
		else
			PlayAnim('StrafeL', 0.9, tweentime);
	}
	else if (Weapon == None)
		PlayAnim('RunSM', 0.9, tweentime);
	else if ( Weapon.bPointing ) 
	{
		if (Weapon.Mass < 20)
			PlayAnim('RunSMFR', 0.9, tweentime);
		else
			PlayAnim('RunLGFR', 0.9, tweentime);
	}
	else
	{
		if (Weapon.Mass < 20)
			PlayAnim('RunSM', 0.9, tweentime);
		else
			PlayAnim('RunLG', 0.9, tweentime);
	} 
}

function PlayRunning()
{
	local vector X,Y,Z, Dir;

	BaseEyeHeight = Default.BaseEyeHeight;

	// determine facing direction
	GetAxes(Rotation, X,Y,Z);
	Dir = Normal(Acceleration);
	if ( (Dir Dot X < 0.75) && (Dir != vect(0,0,0)) )
	{
		// strafing or backing up
		if ( Dir Dot X < -0.75 )
			LoopAnim('BackRun');
		else if ( Dir Dot Y > 0 )
			LoopAnim('StrafeR');
		else
			LoopAnim('StrafeL');
	}
	else if (Weapon == None)
		LoopAnim('RunSM');
	else if ( Weapon.bPointing ) 
	{
		if (Weapon.Mass < 20)
			LoopAnim('RunSMFR');
		else
			LoopAnim('RunLGFR');
	}
	else
	{
		if (Weapon.Mass < 20)
			LoopAnim('RunSM');
		else
			LoopAnim('RunLG');
	}
}

function PlayRising()
{
	BaseEyeHeight = 0.4 * Default.BaseEyeHeight;
	TweenAnim('DuckWlkS', 0.7);
}

function PlayFeignDeath()
{
	local float decision;

	BaseEyeHeight = 0;
	if ( decision < 0.33 )
		TweenAnim('DeathEnd', 0.5);
	else if ( decision < 0.67 )
		TweenAnim('DeathEnd2', 0.5);
	else 
		TweenAnim('DeathEnd3', 0.5);
}

function PlayGutHit(float tweentime)
{
	if ( (AnimSequence == 'GutHit') || (AnimSequence == 'Dead2') )
	{
		if (FRand() < 0.5)
			TweenAnim('LeftHit', tweentime);
		else
			TweenAnim('RightHit', tweentime);
	}
	else if ( FRand() < 0.6 )
		TweenAnim('GutHit', tweentime);
	else
		TweenAnim('Dead2', tweentime);

}

function PlayHeadHit(float tweentime)
{
	if ( (AnimSequence == 'HeadHit') || (AnimSequence == 'Dead4') )
		TweenAnim('GutHit', tweentime);
	else if ( FRand() < 0.6 )
		TweenAnim('HeadHit', tweentime);
	else
		TweenAnim('Dead4', tweentime);
}

function PlayLeftHit(float tweentime)
{
	if ( (AnimSequence == 'LeftHit') || (AnimSequence == 'Dead3') )
		TweenAnim('GutHit', tweentime);
	else if ( FRand() < 0.6 )
		TweenAnim('LeftHit', tweentime);
	else 
		TweenAnim('Dead3', tweentime);
}

function PlayRightHit(float tweentime)
{
	if ( (AnimSequence == 'RightHit') || (AnimSequence == 'Dead5') )
		TweenAnim('GutHit', tweentime);
	else if ( FRand() < 0.6 )
		TweenAnim('RightHit', tweentime);
	else
		TweenAnim('Dead5', tweentime);
}
	
function PlayHit(float Damage, vector HitLocation, name damageType, float MomentumZ)
{
	local float rnd;
	local WaterBubble bub;
	local bool bServerGuessWeapon;
	local class<DamageType> DamageClass;
    local SuitHit locSuitHit;
    local vector tmpLoc;
	local int iDam;

	if ( (Damage <= 0) && (ReducedDamageType != 'All') )
		return;

	//DamageClass = class(damageType);
	if ( ReducedDamageType != 'All' ) //spawn some blood
	{
		if (damageType == 'Drowned')
		{
			bub = spawn(class 'WaterBubble',,, Location 
				+ 0.7 * CollisionRadius * vector(ViewRotation) + 0.3 * EyeHeight * vect(0,0,1));
			if (bub != None)
				bub.DrawScale = FRand()*0.06+0.04; 
		}
		else if ( (damageType != 'Burned') && (damageType != 'Corroded') 
					&& (damageType != 'Fell') )
		{
            tmpLoc = Location;
            tmpLoc.Z += 0.3 * CollisionHeight;  // chest area
            locSuitHit = spawn(class'SuitHit',,,tmpLoc );
            locSuitHit.SetBase(self);

//			spawn(class 'Shieldfx',self,,Location 
//				+ 0.7 * CollisionRadius * vector(ViewRotation) + 0.3 * EyeHeight * vect(0,0,1));
		}
	}	

	rnd = FClamp(Damage, 20, 60);
	if ( damageType == 'Burned' )
	{
		ClientFlash(-0.05,vect(0,0,400));
//		ClientFlash( -0.009375 * rnd, rnd * vect(16.41, 11.719, 4.6875));
	}
	else if ( damageType == 'corroded' )
	{
		ClientFlash(-0.05,vect(400,400,400));
//		ClientFlash( -0.01171875 * rnd, rnd * vect(9.375, 14.0625, 4.6875));
	}
	else if ( damageType == 'Drowned' )
	{
		ClientFlash(-0.05,vect(0,0,400));
//		ClientFlash(-0.390, vect(312.5,468.75,468.75));
	}
	else 
	{
		ClientFlash(-0.05,vect(0,0,400));
//		ClientFlash( -0.019 * rnd, rnd * vect(26.5, 4.5, 4.5));
	}

	ShakeView(0.15 + 0.005 * Damage, Damage * 30, 0.3 * Damage); 
	PlayTakeHitSound(Damage, damageType, 1);
	bServerGuessWeapon = ( ((Weapon != None) && Weapon.bPointing) || (GetAnimGroup(AnimSequence) == 'Dodge') );
	iDam = Clamp(Damage,0,200);
	ClientPlayTakeHit(0.1, hitLocation, iDam, bServerGuessWeapon ); 
	if ( !bServerGuessWeapon 
		&& ((Level.NetMode == NM_DedicatedServer) || (Level.NetMode == NM_ListenServer)) )
	{
		Enable('AnimEnd');
		BaseEyeHeight = Default.BaseEyeHeight;
		bAnimTransition = true;
		PlayTakeHit(0.1, hitLocation, Damage);
	}
}

function PlayDeathHit(float Damage, vector HitLocation, name damageType)
{
	local WaterBubble bub;

	if ( Region.Zone.bDestructive && (Region.Zone.ExitActor != None) )
		Spawn(Region.Zone.ExitActor);
	if (HeadRegion.Zone.bWaterZone)
	{
		bub = spawn(class 'WaterBubble',,, Location 
			+ 0.3 * CollisionRadius * vector(Rotation) + 0.8 * EyeHeight * vect(0,0,1));
		if (bub != None)
			bub.DrawScale = FRand()*0.08+0.03; 
		bub = spawn(class 'WaterBubble',,, Location 
			+ 0.2 * CollisionRadius * VRand() + 0.7 * EyeHeight * vect(0,0,1));
		if (bub != None)
			bub.DrawScale = FRand()*0.08+0.03; 
		bub = spawn(class 'WaterBubble',,, Location 
			+ 0.3 * CollisionRadius * VRand() + 0.6 * EyeHeight * vect(0,0,1));
		if (bub != None)
			bub.DrawScale = FRand()*0.08+0.03; 
	}

//##nerf WES FIXME
// Might want some of our effect. Definitely not blood.
//	if ( (damageType != 'Drowned') && (damageType != 'Corroded') )
//		spawn(class 'BloodSpray',self,'', hitLocation); 
}

function PlayLanded(float impactVel)
{	
	impactVel = impactVel/JumpZ;
	impactVel = 0.1 * impactVel * impactVel;
	BaseEyeHeight = Default.BaseEyeHeight;

	if ( impactVel > 0.17 )
		PlayOwnedSound(LandGrunt, SLOT_Talk, FMin(5, 5 * impactVel),false,1200,FRand()*0.4+0.8);
	if ( !FootRegion.Zone.bWaterZone && (impactVel > 0.01) )
		PlayOwnedSound(Land, SLOT_Interact, FClamp(4 * impactVel,0.5,5), false,1000, 1.0);
	if ( (impactVel > 0.06) || (GetAnimGroup(AnimSequence) == 'Jumping') || (GetAnimGroup(AnimSequence) == 'Ducking') )
	{
		if ( (Weapon == None) || (Weapon.Mass < 20) )
			TweenAnim('LandSMFR', 0.12);
		else
			TweenAnim('LandLGFR', 0.12);
	}
	else if ( !IsAnimating() )
	{
		if ( GetAnimGroup(AnimSequence) == 'TakeHit' )
		{
			SetPhysics(PHYS_Walking);
			AnimEnd();
		}
		else 
		{
			if ( (Weapon == None) || (Weapon.Mass < 20) )
				TweenAnim('LandSMFR', 0.12);
			else
				TweenAnim('LandLGFR', 0.12);
		}
	}
}
	
function PlayInAir()
{
	local vector X,Y,Z, Dir;
	local float f, TweenTime;

	BaseEyeHeight =  0.7 * Default.BaseEyeHeight;

	if ( (GetAnimGroup(AnimSequence) == 'Landing') && !bLastJumpAlt )
	{
		GetAxes(Rotation, X,Y,Z);
		Dir = Normal(Acceleration);
		f = Dir dot Y;
		if ( f > 0.7 )
			TweenAnim('DodgeL', 0.35);
		else if ( f < -0.7 )
			TweenAnim('DodgeR', 0.35);
		else if ( Dir dot X > 0 )
			TweenAnim('DodgeF', 0.35);
		else
			TweenAnim('DodgeB', 0.35);
		bLastJumpAlt = true;
		return;
	}
	bLastJumpAlt = false;
	if ( GetAnimGroup(AnimSequence) == 'Jumping' )
	{
		if ( (Weapon == None) || (Weapon.Mass < 20) )
			TweenAnim('DuckWlkS', 2);
		else
			TweenAnim('DuckWlkL', 2);
		return;
	}
	else if ( GetAnimGroup(AnimSequence) == 'Ducking' )
		TweenTime = 2;
	else 
		TweenTime = 0.7;

	if ( AnimSequence == 'StrafeL' )
		TweenAnim('DodgeR', TweenTime);
	else if ( AnimSequence == 'StrafeR' )
		TweenAnim('DodgeL', TweenTime);
	else if ( AnimSequence == 'BackRun' )
		TweenAnim('DodgeB', TweenTime);
	else if ( (Weapon == None) || (Weapon.Mass < 20) )
		TweenAnim('JumpSMFR', TweenTime);
	else
		TweenAnim('JumpLGFR', TweenTime); 
}

function PlayDuck()
{
	BaseEyeHeight = 0;
	if ( (Weapon == None) || (Weapon.Mass < 20) )
		TweenAnim('DuckWlkS', 0.25);
	else
		TweenAnim('DuckWlkL', 0.25);
}

function PlayCrawling()
{
	//log("Play duck");
	BaseEyeHeight = 0;
	if ( (Weapon == None) || (Weapon.Mass < 20) )
		LoopAnim('DuckWlkS');
	else
		LoopAnim('DuckWlkL');
}

function TweenToWaiting(float tweentime)
{
	if ( (IsInState('PlayerSwimming')) || (Physics == PHYS_Swimming) )
	{
		BaseEyeHeight = 0.7 * Default.BaseEyeHeight;
		if ( (Weapon == None) || (Weapon.Mass < 20) )
			TweenAnim('TreadSM', tweentime);
		else
			TweenAnim('TreadLG', tweentime);
	}
	else
	{
		BaseEyeHeight = Default.BaseEyeHeight;
		if ( (Weapon == None) || (Weapon.Mass < 20) )
			TweenAnim('StillSMFR', tweentime);
		else 
			TweenAnim('StillFRRP', tweentime);
	}
}
	
function PlayRecoil(float Rate)
{
	if ( Weapon.bRapidFire )
	{
		if ( !IsAnimating() && (Physics == PHYS_Walking) )
			LoopAnim('StillFRRP', 0.02);
	}
	else if ( AnimSequence == 'StillSmFr' )
		PlayAnim('StillSmFr', Rate, 0.02);
	else if ( (AnimSequence == 'StillLgFr') || (AnimSequence == 'StillFrRp') )	
		PlayAnim('StillLgFr', Rate, 0.02);
}

function PlayFiring()
{
	// switch animation sequence mid-stream if needed
	if (AnimSequence == 'RunLG')
		AnimSequence = 'RunLGFR';
	else if (AnimSequence == 'RunSM')
		AnimSequence = 'RunSMFR';
	else if (AnimSequence == 'WalkLG')
		AnimSequence = 'WalkLGFR';
	else if (AnimSequence == 'WalkSM')
		AnimSequence = 'WalkSMFR';
	else if ( AnimSequence == 'JumpSMFR' )
		TweenAnim('JumpSMFR', 0.03);
	else if ( AnimSequence == 'JumpLGFR' )
		TweenAnim('JumpLGFR', 0.03);
	else if ( (GetAnimGroup(AnimSequence) == 'Waiting') || (GetAnimGroup(AnimSequence) == 'Gesture')
		&& (AnimSequence != 'TreadLG') && (AnimSequence != 'TreadSM') )
	{
		if ( Weapon.Mass < 20 )
			TweenAnim('StillSMFR', 0.02);
		else
			TweenAnim('StillFRRP', 0.02);
	}
}

function PlayWeaponSwitch(Weapon NewWeapon)
{
	if ( (Weapon == None) || (Weapon.Mass < 20) )
	{
		if ( (NewWeapon != None) && (NewWeapon.Mass > 20) )
		{
			if ( (AnimSequence == 'RunSM') || (AnimSequence == 'RunSMFR') )
				AnimSequence = 'RunLG';
			else if ( (AnimSequence == 'WalkSM') || (AnimSequence == 'WalkSMFR') )
				AnimSequence = 'WalkLG';	
		 	else if ( AnimSequence == 'JumpSMFR' )
		 		AnimSequence = 'JumpLGFR';
			else if ( AnimSequence == 'DuckWlkL' )
				AnimSequence = 'DuckWlkS';
		 	else if ( AnimSequence == 'StillSMFR' )
		 		AnimSequence = 'StillFRRP';
			else if ( AnimSequence == 'AimDnSm' )
				AnimSequence = 'AimDnLg';
			else if ( AnimSequence == 'AimUpSm' )
				AnimSequence = 'AimUpLg';
		 }	
	}
	else if ( (NewWeapon == None) || (NewWeapon.Mass < 20) )
	{		
		if ( (AnimSequence == 'RunLG') || (AnimSequence == 'RunLGFR') )
			AnimSequence = 'RunSM';
		else if ( (AnimSequence == 'WalkLG') || (AnimSequence == 'WalkLGFR') )
			AnimSequence = 'WalkSM';
	 	else if ( AnimSequence == 'JumpLGFR' )
	 		AnimSequence = 'JumpSMFR';
		else if ( AnimSequence == 'DuckWlkS' )
			AnimSequence = 'DuckWlkL';
	 	else if (AnimSequence == 'StillFRRP')
	 		AnimSequence = 'StillSMFR';
		else if ( AnimSequence == 'AimDnLg' )
			AnimSequence = 'AimDnSm';
		else if ( AnimSequence == 'AimUpLg' )
			AnimSequence = 'AimUpSm';
	}
}

function PlaySwimming()
{
	BaseEyeHeight = 0.7 * Default.BaseEyeHeight;
	if ((Weapon == None) || (Weapon.Mass < 20) )
		LoopAnim('SwimSM');
	else
		LoopAnim('SwimLG');
}

function TweenToSwimming(float tweentime)
{
	BaseEyeHeight = 0.7 * Default.BaseEyeHeight;
	if ((Weapon == None) || (Weapon.Mass < 20) )
		TweenAnim('SwimSM',tweentime);
	else
		TweenAnim('SwimLG',tweentime);
}



function CalmDown()
{
	bFire = 0;
	bAltFire = 0;
	Enemy = None;
    Velocity = vect(0,0,0);
    Acceleration=vect(0,0,0);
    SetRotation(DesiredRotation);
	SetPhysics(PHYS_Falling);
}

state TakeABow
{
	exec function Fire( optional float F )
	{
		if ( Role < ROLE_Authority )
			return;

		if ( !bFrozen )
   			ServerReStartGame();
    }

Begin:
//log(self$": Take a bow label" );
    CalmDown();
	PlayAnim('Victory2');
Dance:
    ixVDance=RandRange(0,ixVDMax);
    TweenAnim(VDance[ixVDance], 0.3);
    FinishAnim();
    PlayAnim(VDance[ixVDance]);
    FinishAnim();
    Goto('Dance');
}

state Idle
{
}


state Dying
{
ignores SeePlayer, HearNoise, KilledBy, Bump, HitWall, HeadZoneChange, FootZoneChange, ZoneChange, SwitchWeapon, Falling, PainTimer;

	function ViewFlash(float DeltaTime)
	{
		if ( Carcass(ViewTarget) != None )
		{
			InstantFlash = -0.3;
			InstantFog = vect(0.25, 0.03, 0.03);
		}
		Super.ViewFlash(DeltaTime);
	}
}

/*
state Dying
{
ignores SeePlayer, HearNoise, KilledBy, Bump, HitWall, HeadZoneChange, FootZoneChange, ZoneChange, SwitchWeapon, Falling, PainTimer;

	function ViewFlash(float DeltaTime)
	{
		if ( Carcass(ViewTarget) != None )
		{
			InstantFlash = -0.3;
			InstantFog = vect(0.25, 0.03, 0.03);
		}
		Super.ViewFlash(DeltaTime);
	}

	function ReStartPlayer()
	{
		bMeshEnviromap = False;
		DamageScaling = 1.0;
		GroundSpeed = Default.groundspeed;
		JumpZ = Default.JumpZ;
		Texture = Default.Texture;
        Style = Default.Style;
		if( Level.Game.RestartPlayer(self) )
		{
			Velocity = vect(0,0,0);
			Acceleration = vect(0,0,0);
			ViewRotation = Rotation;
			ReSetSkill();
			SetPhysics(PHYS_Falling);
			GotoState('PlayerWalking');
		}
		else
			GotoState('Dying', 'TryAgain');
	}

	function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
							Vector momentum, name damageType)
	{
		if ( !bHidden )
			Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
	}

//DSL-- dying spinning animation	
    function Timer()
    {
        local SuitDeath locSuitDeath;

        tmpLocation = Location;
        tmpLocation.Z = tmpLocation.Z + 2.0;        // foat up in the air
        tmpRotation = Rotation;
        tmpRotation.Yaw += 7600;                    // spin around
//        DrawScale = 0.85 * DrawScale;                // get smaller
        if ( spinCounter == 2 );
            Style = STY_Modulated;                  // become transparent
        SetRotation(tmpRotation);        
        SetLocation(tmpLocation);
        spinCounter--;
        if ( spinCounter < 0 )
        {
//            spawn( class'SuitGone',,,Location);
            locSuitDeath = spawn( class'SuitDeath',self,,Location);
            locSuitDeath.SetBase(self);
            if ( !bHidden ) HidePlayer();
            SetTimer( 0.0, false );
            DrawScale = Default.DrawScale;
            Style = Default.Style;
        }
    }

	function BeginState()
	{
//		SetTimer(0, false);
		Enemy = None;
		bFire = 0;
		bAltFire = 0;
	}

	function EndState()
	{
        if ( !bHidden )
            HidePlayer();
//		if ( Health <= 0 )
//			log(self$" health still <0");
	}

Begin:
    bBlockActors = false;       // get out of Nick's way
    spinCounter = 12;
    FinishAnim();
    SetTimer(0.05, true);
    Enemy = None;
    bFire = 0;
    bAltFire = 0;
TryAgain:
	Sleep(1.25);
	ReStartPlayer();
	Goto('TryAgain');
WaitingForStart:
	bHidden = true;
}
*/
	
state GameEnded
{
	ignores SeePlayer, HearNoise, KilledBy, Bump, HitWall, HeadZoneChange, FootZoneChange, ZoneChange, Falling, TakeDamage, PainTimer, Died;

	exec function Fire( optional float F )
	{
		if ( Role < ROLE_Authority )
			return;
//		if ( Level.Game.IsA('DeathMatchGame') && DeathMatchGame(Level.Game).bRatedGame )
//			return;

		if ( !bFrozen )
			ServerReStartGame();
	}
}

defaultproperties
{
     spreenote(0)=is on a point spree!
     spreenote(1)=is on the loose!
     spreenote(2)=is dominating!
     spreenote(3)=is going bananas!
     spreenote(4)=is unstoppable!
     spreenote(5)=owns you!
     spreenote(6)=needs to find some real competition!
     spreenote(7)=is a GOD!
     LastKillTime=-1000.000000
     VDance(0)=Breath1
     VDance(1)=Look
     VDance(2)=Fidget
     VDance(3)=Wave
     VDance(4)=Victory2
     VDance(5)=WarmUp
     VDance(6)=Taunt1
     VDance(7)=StucknGoo
     ixVDMax=7
     bSinglePlayer=True
     bCanStrafe=True
     bIsHuman=True
     bIsMultiSkinned=True
     MeleeRange=50.000000
     GroundSpeed=400.000000
     AirSpeed=400.000000
     AccelRate=2048.000000
     AirControl=0.350000
     BaseEyeHeight=27.000000
     EyeHeight=27.000000
     UnderWaterTime=20.000000
     Intelligence=BRAINS_HUMAN
     Land=Sound'NerfI.Generic.Land1'
     AnimSequence=WalkSm
     DrawType=DT_Mesh
     CollisionRadius=17.000000
     CollisionHeight=39.000000
     LightBrightness=70
     LightHue=40
     LightSaturation=128
     LightRadius=6
     Buoyancy=99.000000
     RotationRate=(Pitch=3072,Yaw=65000,Roll=2048)
}
