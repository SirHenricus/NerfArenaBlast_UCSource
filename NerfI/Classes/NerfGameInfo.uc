//=============================================================================
// NerfGameInfo.
//
// default game info is normal single player
//
// Intergrated by Wezo at 7-7-99
//=============================================================================
class NerfGameInfo extends GameInfo;

#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\genericfx\Gteleprt.WAV" NAME="Teleport1" GROUP="Generic"

// Don't know if we need it now course I think we have string manipulation.
// DSL -- initialized by prebegin in DeathMatch, postbegin in ArenaRace
// and ScavengerHunt
var EAIGameType AIType;

var(DeathMessage) localized string DeathMessage[32];    // Player name, or blank if none.
var(DeathMessage) localized string DeathModifier[5];
var(DeathMessage) localized string MajorDeathMessage[8];
var(DeathMessage) localized string HeadLossMessage[2];
var(DeathMessage) localized string DeathVerb;
var(DeathMessage) localized string DeathPrep;
var(DeathMessage) localized string DeathTerm;
var(DeathMessage) localized string ExplodeMessage;
var(DeathMessage) localized string SuicideMessage;
var(DeathMessage) localized string FallMessage;
var(DeathMessage) localized string DrownedMessage;
var(DeathMessage) localized string BurnedMessage;
var(DeathMessage) localized string CorrodedMessage;
var(DeathMessage) localized string HackedMessage;
var(DeathMessage) localized string MortarMessage;
var(DeathMessage) localized string MaleSuicideMessage;
var(DeathMessage) localized string FemaleSuicideMessage;

function PostBeginPlay()
{
//	local CDAudio a;

	//TraceLog(class, 10, "in NerfGameInfo.PostBeginPlay()");

	Super.PostBeginPlay();
// DSL -- speechifying may need some replication work
    Spawn(class'VoxBox');


//	// start looping audio
//	a = spawn(class'NerfI.CDAudio');
//	a.StartCDTrack(Level.CdTrack, 1);
}

function EndGame( string Reason )
{
//	local CDAudio a;

	//TraceLog(class, 10, "in EndGame()");

	// kill the looping audio
//	a = spawn(class'NerfI.CDAudio');
//	a.StopCDTrack();

	Super.EndGame( Reason );
}

function Killed( pawn Killer, pawn Other, name damageType )
{
//	log(class$ " WES: killed got call at NerfGameInfo" @damagetype);
	Super.Killed(killer, Other, damageType);
}

function int ReduceDamage(int Damage, name DamageType, pawn injured, pawn instigatedBy)
{
	if (injured.Region.Zone.bNeutralZone)
		return 0;

	if ( instigatedBy == None)
		return Damage;
	//skill level modification
	if ( instigatedBy.bIsPlayer )
	{
		if ( injured == instigatedby )
		{ 
			if ( instigatedby.skill == 0 )
				Damage = 0.25 * Damage;
			else if ( instigatedby.skill == 1 )
				Damage = 0.5 * Damage;
		}
		else if ( !injured.bIsPlayer )
			Damage = float(Damage) * (1.1 - 0.1 * injured.skill);
	}
	else if ( injured.bIsPlayer )
		Damage = Damage * (0.4 + 0.2 * instigatedBy.skill);
	return (Damage * instigatedBy.DamageScaling);
}

function float PlaySpawnEffect(inventory Inv)
{
	spawn( class 'ReSpawn',,, Inv.Location );
	return 0.3;
}

function bool ShouldRespawn(Actor Other)
{
	return false;
}

static function string KillMessage( name damageType, pawn Other )
{
	local string message;
	
	if (damageType == 'Exploded')
		message = Default.ExplodeMessage;
	else if (damageType == 'Suicided')
		message = Default.SuicideMessage;
	else if ( damageType == 'Fell' )
		message = Default.FallMessage;
	else if ( damageType == 'Drowned' )
		message = Default.DrownedMessage;
	else if ( damageType == 'Special' )
		message = Default.SpecialDamageString;
	else if ( damageType == 'Burned' )
		message = Default.BurnedMessage;
	else if ( damageType == 'Corroded' )
		message = Default.CorrodedMessage;
	else
		message = Default.DeathVerb$Default.DeathTerm;
		
	return message;	
}

static function string CreatureKillMessage( name damageType, pawn Other )
{
	local string message;
	
	if (damageType == 'exploded')
		message = Default.ExplodeMessage;
	else if ( damageType == 'Burned' )
		message = Default.BurnedMessage;
	else if ( damageType == 'Corroded' )
		message = Default.CorrodedMessage;
	else if ( damageType == 'Hacked' )
		message = Default.HackedMessage;
	else
		message = Default.DeathVerb$Default.DeathTerm;

	return ( message$Default.DeathPrep );
}

static function string PlayerKillMessage( name damageType, PlayerReplicationInfo Other )
{
	local string message;
	local float decision;
	
	decision = FRand();

	if ( decision < 0.2 )
		message = Default.MajorDeathMessage[Rand(3)];
	else
	{
		if ( DamageType == 'Decapitated' )
			message = Default.HeadLossMessage[Rand(2)];
		else
			message = Default.DeathMessage[Rand(32)];

		if ( decision < 0.75 )
			message = Default.DeathModifier[Rand(5)]$message;
	}	
	
	return ( Default.DeathVerb$message$Default.DeathPrep );
} 	

function PlayTeleportEffect( actor Incoming, bool bOut, bool bSound)
{
	local PawnTeleportEffect PTE;

	if ( Incoming.IsA('Pawn') )
	{
		if ( bSound )
		{
			PTE = Spawn(class'PawnTeleportEffect',,, Incoming.Location, Incoming.Rotation);
			PTE.Initialize(Pawn(Incoming), bOut);
			if ( Incoming.IsA('PlayerPawn') )
				PlayerPawn(Incoming).SetFOVAngle(170);
			Incoming.PlaySound(sound'Teleport1',, 10.0);
		}
	}
}

function BroadcastRegularDeathMessage(pawn Killer, pawn Other, name damageType)
{
	if (Killer.Weapon != None)
		BroadcastLocalizedMessage(DeathMessageClass, 0, Killer.PlayerReplicationInfo, Other.PlayerReplicationInfo, Killer.Weapon.Class);
	else
		BroadcastLocalizedMessage(DeathMessageClass, 0, Killer.PlayerReplicationInfo, Other.PlayerReplicationInfo, None);
}

static function string GenderKillMessage( PlayerReplicationInfo OtherPRI )
{
	local string message;

	if (OtherPRI == None)
		return "";

	// We don't want exploded.
	if ( OtherPRI.SuicideType == 'Suicided' )
		message = Default.SuicideMessage;
	else if ( OtherPRI.SuicideType == 'Fell' )
		message = Default.FallMessage;
	else if ( OtherPRI.SuicideType == 'Drowned' )
		message = Default.DrownedMessage;
	else if ( OtherPRI.SuicideType == 'Burned' )
		message = Default.BurnedMessage;
	else if ( OtherPRI.SuicideType == 'Corroded' )
		message = Default.CorrodedMessage;
	else if ( OtherPRI.SuicideType == 'Mortared' )
		message = Default.MortarMessage;
	else {
		if ( OtherPRI.bIsFemale )
			message = Default.FemaleSuicideMessage;
		else
			message = Default.MaleSuicideMessage;
	}

	return message;
}

//##nerf WES FIXME
// Need our own kill message. Somebody better write some scripts.

defaultproperties
{
     DeathMessage(0)=shutdown
     DeathMessage(1)=wiped out
     DeathMessage(2)=smoked
     DeathMessage(3)=knocked out
     DeathMessage(4)=creamed
     DeathMessage(5)=embarrassed
     DeathMessage(6)=stunned
     DeathMessage(7)=wiped out
     DeathMessage(8)=smoked
     DeathMessage(9)=tamed
     DeathMessage(10)=creamed
     DeathMessage(11)=canned
     DeathMessage(12)=busted
     DeathMessage(13)=shutdown
     DeathMessage(14)=subdued
     DeathMessage(15)=eliminated
     DeathMessage(16)=out-maneuvered
     DeathMessage(17)=smacked
     DeathMessage(18)=stunned
     DeathMessage(19)=shutdown
     DeathMessage(20)=hammered
     DeathMessage(21)=knocked out
     DeathMessage(22)=outgunned
     DeathMessage(23)=beat
     DeathMessage(24)=nailed
     DeathMessage(25)=outgunned
     DeathMessage(26)=routed
     DeathMessage(27)=whipped
     DeathMessage(28)=eliminated
     DeathMessage(29)=thrashed
     DeathMessage(30)=hammered
     DeathMessage(31)=trounced
     DeathModifier(0)=thoroughly 
     DeathModifier(1)=completely 
     DeathModifier(2)=absolutely 
     DeathModifier(3)=totally 
     DeathModifier(4)=utterly 
     MajorDeathMessage(0)=humiliated
     MajorDeathMessage(1)=put down
     MajorDeathMessage(2)=snubbed
     HeadLossMessage(0)=humbled
     HeadLossMessage(1)=sent packing
     DeathVerb= was 
     DeathPrep= by 
     DeathTerm=eliminated
     ExplodeMessage= was re-assigned
     SuicideMessage= dropped out.
     FallMessage= started over.
     DrownedMessage= forgot to come up for air.
     BurnedMessage= was knocked-out
     CorrodedMessage= was slurped
     HackedMessage= was wiped out
     MortarMessage= was snubbed
     MaleSuicideMessage= put down his own dumb self.
     FemaleSuicideMessage= put down her own dumb self.
     GameMenuType=Class'NerfI.NerfGameOptionsMenu'
     HUDType=Class'NerfI.NerfHUD'
     WaterZoneType=Class'NerfI.WaterZone'
}
