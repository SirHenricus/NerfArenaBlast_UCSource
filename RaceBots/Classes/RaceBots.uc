//=============================================================================
// RaceBots.
//=============================================================================
class RaceBots expands NerfBots
	abstract;

// Advanced AI attributes.
var     Pawn        tmpPawn;
var     name        RaceTag[70];
var(Orders) bool    bDelayedPatrol;
var     Pawn        Hated;
var     Pawn        MyEnemy;
var     float       Mood;
var     float       MoodThreshhold;
var     float       DamageThreshhold;
var     bool        bMoodTimer;

var     int         RPIndex;
var     int         RPMax;

var     name        MyName;
var     RacePoint   lastPoint;
var     int         ixTaunt;


var(AI) bool        bHateWhenTriggered;
var     bool        bTargetHit;         // feedback from target trigger
var     bool        bWFlag;

var     inventory   tInv;
var     mover       tMov;
var     float       RPReach;
var     float       LastRPReach;
var     int         PatienceCounter;
var     int         PatienceCount;      // for refilling counter
var     int         HornCounter;
var     vector      RPRotation;


function PreBeginPlay()
{
    MyName = Tag;       // remember who I am in case tag changes
    Mood = 0.0;
    bMoodTimer = false;
	Super.PreBeginPlay();
    HornCounter = 10;
}



function PostBeginPlay()
{
    local float     collrad, collhgt;
    local float     moodlevel;
    local float     damagelevel;
    local float     speedbump;
    local int       rpCounter;
    local RacePoint tRP;

/*------------------------------
// collision cheat for sky race
// DSL -- AR-SkyRace is too tight for anybot over (48.5*2)/16 feet tall

    if ( InStr( self, "sky" ) >= 0 )
    {
        if ( CollisionHeight > 48 )
        {
//log( self$" adjusting collision size "$CollisionHeight$" for skyrace" );
            collrad = Default.CollisionRadius;
            collhgt = 48;
            SetCollisionSize( collrad, collhgt );
        }
    }
------------------------------*/

//------------------------------
//collision cheat for all levels

    if ( CollisionHeight > 48 )
    {
        collrad = Default.CollisionRadius;
        collhgt = 48;
        SetCollisionSize( collrad, collhgt );
    }
//------------------------------
    rpCounter = 0;
    foreach AllActors( class 'RacePoint', tRP )
    {
        if ( !tRP.bAux )
            rpCounter++;
    }
	RPMax = rpCounter-1;		// index of last racepoint
//log( self$" found "$rpCounter$" RacePoints" );

    moodlevel = 1.0;
    damagelevel = 50;
    speedbump = 0.0;
    switch( Level.Game.Difficulty )
    {
        case 0:
            moodlevel = 0.35;
            damagelevel = 25;
            speedbump = 0.0;
            break;
        case 1:
            moodlevel = 0.30;
            damagelevel = 15;
            speedbump = 30.0;
            break;
        case 2:
            moodlevel = 0.25;
            damagelevel = 10;
            speedbump = 60.0;
            break;
        case 3:
            moodlevel = 0.20;
            damagelevel =  5;
            speedbump = 90.0;
            break;
    }    
    MoodThreshhold = moodlevel;         // how easily RaceBots get ticked off
    DamageThreshhold = damagelevel;
    Groundspeed = Default.Groundspeed + speedbump;
    Default.Groundspeed = Groundspeed;
    Super.PostBeginPlay();
}


//**********************************************************************************
// racebot support stuff
//
// use these functions rather than RPIndex-- and RPIndex++
// to have wrap around safety
//
function PrevRPIndex()
{
    RPIndex--;
//log( self$" previx to "$RPIndex );
    if ( RPIndex < 0 )
    {
//log( self$" around the horn, HC = "$HornCounter );
        HornCounter--;
        if ( HornCounter > 0 )
            RPIndex = RPMax;
        else
            Destroy();      // hopelessly lost
    }
}
function NextRPIndex()
{
    RPIndex++;
    if ( RPIndex > RPMax )
        RPIndex = 0;
}
// back up the number of steps suggested
// by current racepoint
function Regress( RacePoint rp )
{
    local   int i;
    local   int j;

    j = rp.iBackTrack;
    if ( j < 1 )
    {
//TraceLog( class, 5, "ERROR: "$rp$" advice failure with iBackTrack = "$j );
        j = 1;     // safety from infinite nulls
    }
//log ( "Regressing "$j$" RacePoints" );
    for ( i = 0; i < j; i++ )
        PrevRPIndex();
}

// enemy safety net -- make sure we always have an enemy handy
function CheckEnemy()
{
    local NerfIPlayer Suspect;

    if ( Enemy != None ) return;
    Enemy = MyEnemy;
    if ( Enemy != None ) return;
    foreach allactors( class'NerfIPlayer', Suspect )
    {
        Enemy = Suspect;
        break;
    }
}

//**********************************************************************************
// top level functions:
//    function WhatToDoNext(name LikelyState, name LikelyLabel)   // auto Startup

function WhatToDoNext(name LikelyState, name LikelyLabel)
{
	bFire = 0;
	bAltFire = 0;
	bReadyToAttack = false;
	Enemy = None;
//log ( "NB-wtdn: Enemy = "$Enemy );
//log ( "NB-wtdn: Old Enemy = "$OldEnemy );

// if no current enemy, see if we had an old one to go after
	if ( OldEnemy != None )
	{
		Enemy = OldEnemy;
		OldEnemy = None;
		GotoState('Defending');
	}
// else look around for one
	else
	{
//      SetPhysics( PHYS_Walking );
      GotoState('Racing');
		if ( Skill > 2.7 )
			bReadyToAttack = true; 
	}
}

// for all states not covered by their own attitude adjustment --
function eAttitude AttitudeTo(Pawn Other)
{
    local EAttitude att;

    att = ATTITUDE_Ignore;

    if ( Other.IsA( 'NerfIPlayer' ) )
    {
        switch( Level.Game.Difficulty )
        {
            case 0: att = ATTITUDE_Friendly;    break;
            case 1: att = ATTITUDE_Ignore;      break;
            case 2: att = ATTITUDE_Fear;        break;
            case 3: att = ATTITUDE_Hate;        break;
        }
    }
    else
        att = ATTITUDE_Ignore;

    return att;
}

/*
var(AI) enum EAttitude  //important - order in decreasing importance
{
    ATTITUDE_Fear,      // will try to run away
    ATTITUDE_Hate,      // will attack enemy
    ATTITUDE_Frenzy,    // will attack anything, indiscriminately
    ATTITUDE_Threaten,  // animations, but no attack
    ATTITUDE_Ignore,
    ATTITUDE_Friendly,
    ATTITUDE_Follow     // accepts player as leader
} AttitudeToPlayer;		// determines how creature will react on seeing player
*/

// for states with attitude issues
function eAttitude AdjustAttitude(Pawn Other)
{
    local eAttitude att;
    local float gut;

    att = ATTITUDE_Ignore;
    if ( Level.Game.bTeamGame && (PlayerReplicationInfo.Team == Other.PlayerReplicationInfo.Team) )
        att = ATTITUDE_Friendly; //teammate

    else if ( Mood > MoodThreshhold && Other.IsA( 'NerfIPlayer') )
	{
	    gut = FRand();      // get a gut feeling
	    if ( gut < Mood )
	    {
	        att = ATTITUDE_Hate;
	        if ( FRand() < 0.5 )
	            att = ATTITUDE_Fear;
	    }
	    else att = ATTITUDE_Ignore;
	}
    return att;
}

//**********************************************************************************

function PlayRangedDefense()
{
	TweenToWaiting(0.11);
	FireWeapon();
}

function SetFall()
{
//	if ( Health <= 0 )
//		log("setfall while dead");
	if (Enemy != None)
	{
        bWallAdjust = false;
		NextState = 'Racing'; //default  (this is what keeps it from NerfBots.uc)
		NextLabel = 'Begin';
		TweenToFalling();
		NextAnim = AnimSequence;
		GotoState('FallingState');
	}
}


//**********************************************************************************
// weapon stuff
//**********************************************************************************

// racebots need a non-alt fire based weapon firer
function FireWeapon()
{
	local bool bUseAltMode;

	if ( (Enemy == None) && bShootSpecial )
	{
//##nerf WES FIXME
// Don't know what is going on here. May be the bot is shoting in the air or something.
		//fake use dispersion pistol
//		Spawn(class'DispersionAmmo',,, Location,Rotator(Target.Location - Location));
		return;
	}

	bUseAltMode = SwitchToBestWeapon();

	if( Weapon!=None )
	{
		if ( (Weapon.AmmoType != None) && (Weapon.AmmoType.AmmoAmount <= 0) )
		{
			bReadyToAttack = true;
			return;
		}

 		if ( !bFiringPaused && !bShootSpecial && (Enemy != None) )
 			Target = Enemy;
		ViewRotation = Rotation;
		if ( bUseAltMode )
		{
//TraceLog( class, 5, "Trying to switch to altfire" );
//			bFire = 0;
//			bAltFire = 1;
//			Weapon.AltFire(1.0);
            bUseAltMode = False;        // reject the suggestion
		}
//		else
//		{
			bFire = 1;
			bAltFire = 0;
			Weapon.Fire(1.0);
//		}
		PlayFiring();
	}
	bShootSpecial = false;
}

/*
 * switch to suggested weapon
 * return TRUE if switch successful
 * else FALSE if weapon not it inventory
 */

function bool SwitchToWeapon( class <Weapon>DesiredWeapon )
{
	local float rating;
	local int usealt, favalt;
	local inventory MyFav;

	if ( Inventory == None )
		return false;

    MyFav = FindInventoryType( DesiredWeapon );
    if ( MyFav == None )        // not available, must find one
        return false;

	PendingWeapon = Weapon(MyFav);

	if ( Weapon == None )
		ChangedWeapon();
	else if ( Weapon != PendingWeapon )
		Weapon.PutDown();
    Weapon = PendingWeapon;

//log( "RB: switched to "$DesiredWeapon );
    return true;
}

function PlayVictoryDance()
{
    PlayAnim('Taunt1');
}

/*
state Gloating
{
Begin:
    Velocity = vect(0,0,0);
    DesiredSpeed = 0.0;
    tmpPawn = None;
    foreach AllActors( class 'Pawn', tmpPawn  )
        if  ( !tmpPawn.IsA('NerfBots') )    
            break;
    if ( tmpPawn != None )
    {
FacePlayer:
        if (NeedToTurn(tmpPawn.Location))
        {       
        	TurnToward(tmpPawn);
            Goto('FacePlayer');
        }
    }
Gloat:
    TweenAnim('Taunt1', 0.2 );
    PlayAnim('Taunt1');
    FinishAnim();
    TweenAnim('Victory1', 0.2 );
    PlayAnim('Victory1');
    FinishAnim();
    TweenAnim('Victory2', 0.2 );
    PlayAnim('Victory2');
    FinishAnim();
    Goto('Gloat');
}
*/

//**********************************************************************************
// Base Monster AI
//

function Timer()
{
//log (self$" in big timer, state = "$GetStateName() );
    Mood = 0.0;
    bMoodTimer = false;
}

auto state StartUp
{
	function BeginState()
	{
		SetMovementPhysics(); 
		SetPhysics(PHYS_Falling);
	}

Begin:
//log( self$" auto startup begin" );    // 9999
    LoopAnim('WarmUp');
WaitForGun:
    if ( !bReadyToRun )
    {
        Sleep(0.1);
        Goto('WaitForGun');
    }
    SetPhysics(PHYS_Walking);
    TweenToFighter(0.1);
	WhatToDoNext('','');
}


// Racebots do not Roam -- overwrite NerfBots definition of this state
state Roaming
{
    function BeginState()
    {
    }
Begin:
    GotoState('Racing');
}

// DSL - based on 'patroling'
state Racing
{
    function eAttitude AttitudeTo(Pawn Other)
    {
//log ( self$" adjatt in "$GetStateName() );
        return AdjustAttitude(Other);
    }


/*////////////////////// Old Bump-TakeDamage combo
	function Bump(actor Other)
	{
		local vector VelDir, OtherDir, tmpvel, tmpdir;
		local float speed;
        local int xm, ym;


        if ( Other.IsA('RaceBots') )
        {
    		if ( TimerRate <= 0 )
    			setTimer(1.0, false);
    		speed = VSize(Velocity);


        	if ( speed > 1 && FRand() < 0.7 )
        	{
        		VelDir = Velocity/speed;
                tmpdir = -1 * VelDir;
                if ( FRand() < 0.5 ) VelDir = tmpdir;

        		VelDir.Z = 0;
        		OtherDir = Other.Location - Location;
        		OtherDir.Z = 0;
        		OtherDir = Normal(OtherDir);
        		if ( (VelDir Dot OtherDir) > 0.7 )
        		{
                    xm = -1;
                    ym = -1;
                    if ( FRand() < 0.5 ) xm = 1;
                    if ( FRand() < 0.5 ) ym = 1;
//    			Velocity.X = VelDir.Y;
//    			Velocity.Y = -1 * VelDir.X;
//    			Velocity *= FMax(speed, 200);
        			tmpvel.X = xm * VelDir.Y;
        			tmpvel.Y = ym * VelDir.X;
                    tmpvel.Z = 0;
                    if ( FRand() < 0.5 ) tmpvel.Z = 150;
        			tmpvel *= FMax(speed, GroundSpeed);
                    Velocity = tmpvel;        
                    PlayAnim('Taunt1');
        		}

            	Disable('Bump');
            }
            else
                Super.Bump( Other );

        }
        else
            Super.Bump( Other );
	}


	function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
							Vector momentum, name damageType)
	{
		Global.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
        if ( health <= 0 )
            return;

//log ( self$" took damage of "$Damage );
        if ( Damage > 6 )
        {
            Mood += 0.2;
            if ( !bMoodTimer )
            {
                bMoodTimer = true;
                SetTimer( 3.0, false );
            }
        }


		if (Enemy == None)
		{
			Enemy = instigatedBy;       // DSL -- SetEnemy(instigatedby)???
			NextState = 'Defending'; 
			NextLabel = 'Begin';
		}
		if (NextState == 'TakeHit')
		{
			NextState = 'Defending'; 
			NextLabel = 'Begin';
			GotoState('TakeHit'); 
		}
		else if (Enemy != None)
        {
			LastSeenPos = Enemy.Location;
            if ( FRand() < 0.66 )       // maybe we will and maybe we won't
                GotoState('Defending');
        }
        if ( Enemy != None )
            MyEnemy = Enemy;
	}

/////////////////////// end of Old Bump-TakeDamage combo */

/////////////////////// New Bump-TakeDamage combo

	function Bump(actor Other)
	{
		local vector VelDir, OtherDir, tmpvel, tmpdir;
		local float speed, otherspeed, dotp, moodstep;
        local name OldAnim;

//        if ( Other.IsA('RaceBots') )
        if ( Other.IsA('Pawn') )
        {
            OldAnim = AnimSequence;
            moodstep = 0.0;
    		speed = VSize(Velocity);
            VelDir = Velocity/speed;
            otherspeed = VSize( Other.Velocity );
            OtherDir = Other.Velocity/otherspeed;
            VelDir = Normal(VelDir);
            OtherDir = Normal(OtherDir);
            dotp = VelDir Dot OtherDir;


            if ( dotp > 0.5 )           // side swipe
            {
                moodstep = 0.1;
                RPRotation.X = VelDir.Y + RandRange(-100.0, +100.0);
                RPRotation.Y = VelDir.X + RandRange(-100.0, +100.0);
            }
            else if ( dotp < -0.5 )     // head on
            {
                moodstep = 0.3;
                RPRotation.X = OtherDir.Y + RandRange(-100.0, +100.0);
                RPRotation.Y = OtherDir.X + RandRange(-100.0, +100.0);
                tmpvel = Other.Velocity/Other.Mass;
                tmpvel.Z = 0;
                tmpvel *= 0.4;
                AddVelocity(tmpvel);
            }

            else                        // side ram
            {
                moodstep = 0.2;
                RPRotation = VelDir Cross OtherDir;
                RPRotation.X += RandRange(-100.0, +100.0);
                RPRotation.Y += RandRange(-100.0, +100.0);
                RPRotation.Z = 0;
            }
            DesiredRotation = rotator(RPRotation);
            bRotateToDesired = true;
          	Disable('Bump');
            Mood += moodstep;
            if ( TimerRate <= 0 )
                SetTimer( 2.0, false );
        }
        else
            Super.Bump( Other );
	}


	function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
							Vector momentum, name damageType)
	{
		Global.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
        if ( health <= 0 )
            return;

        if ( Damage > DamageThreshhold )
        {
            Mood += 0.1;
            if ( !bMoodTimer )
            {
                bMoodTimer = true;
                if ( TimerRate <= 0 )
                    SetTimer( 4.0, false );
            }
        }


		if (Enemy == None)
		{
			Enemy = instigatedBy;       // DSL -- SetEnemy(instigatedby)???
			NextState = 'Defending'; 
			NextLabel = 'Begin';
		}
		if (NextState == 'TakeHit')
		{
			NextState = 'Defending'; 
			NextLabel = 'Begin';
			GotoState('TakeHit'); 
		}
		else if (Enemy != None)
        {
			LastSeenPos = Enemy.Location;
            if ( FRand() < 0.66 )       // maybe we will and maybe we won't
                GotoState('Defending');
        }
        if ( Enemy != None )
            MyEnemy = Enemy;
	}

/////////////////////// end of New Bump-TakeDamage combo

	function bool SetEnemy(Pawn NewEnemy)
	{
		local bool result;
		result = false;
		if ( Global.SetEnemy(NewEnemy))
		{
			result = true;
			NextState = 'Defending'; 
			NextLabel = 'Begin';
		}
		return result;
	} 

	function rotator AdjustAim(float projSpeed, vector projStart, int aimerror, bool leadTarget, bool warnTarget)
	{
		local rotator FireRotation;
		local vector FireSpot;
		local actor HitActor;
		local vector HitLocation, HitNormal;
				
//log( self$" adjusting aim at target = "$Target );
        if ( !Target.IsA('Pawn') )
            return rotator(Target.Location - Location);

		FireSpot = Target.Location;
		aimerror = aimerror * (0.5 * (4 - skill - FRand()));	
			 
		HitActor = Trace(HitLocation, HitNormal, FireSpot, ProjStart, false);
		if( HitActor != None ) 
		{
			//log("adjust aim up");
 			FireSpot.Z += 0.9 * Target.CollisionHeight;
 			HitActor = Trace(HitLocation, HitNormal, FireSpot, ProjStart, false);
			bClearShot = (HitActor == None);
		}
		
		FireRotation = Rotator(FireSpot - ProjStart);
			 
		FireRotation.Yaw = FireRotation.Yaw + 0.5 * (Rand(2 * aimerror) - aimerror);
		viewRotation = FireRotation;			
		return FireRotation;
	}

	function adjustJump()
	{
		local float velZ;
		local vector FullVel;

		velZ = Velocity.Z;
		FullVel = Normal(Velocity) * GroundSpeed;

		If (Location.Z > Destination.Z + CollisionHeight + 2 * MaxStepHeight)
		{
			Velocity = FullVel;
			Velocity.Z = velZ;
			Velocity = EAdjustJump();
			Velocity.Z = 0;
			if ( VSize(Velocity) < 0.9 * GroundSpeed )
			{
				Velocity.Z = velZ;
				return;
			}
		}

		Velocity = FullVel;
		Velocity.Z = JumpZ + velZ;
		Velocity = EAdjustJump();
//log( "RB: adjustjump velocity = "$Velocity );
	}

    function SetFall()
    {
        bWallAdjust = false;
        NextState = 'Racing'; 
        NextLabel = 'Patrol';
        NextAnim = AnimSequence;
//log( "RB: about to fall at velocity = "$Velocity );
        GotoState('FallingState' ); 
    }

    function SetLongFall()
    {
//log( "RB: setlongfall" );
        NextState = 'Racing'; 
        NextLabel = 'ResumePatrol';
        NextAnim = AnimSequence;
        GotoState('FallingState', 'LongFall' ); 
    }

    function HitWall(vector HitNormal, actor Wall)
    {
        local vector VelDir, tmpvel;
        local float speed;

        if (Physics == PHYS_Falling)
            return;

        speed = VSize(Velocity);
        VelDir = Velocity/speed;
        VelDir = Normal(Veldir);
        
        RPRotation.X = VelDir.Y + RandRange(-100.0, +100.0);
        RPRotation.Y = VelDir.X + RandRange(-100.0, +100.0);
        DesiredRotation = rotator(RPRotation);
        bRotateToDesired = true;
        tmpvel = Velocity/Mass;
        tmpvel.Z = 0;
        tmpvel *= 0.3;
        AddVelocity(tmpvel);


        if ( Wall.IsA('Mover') && Mover(Wall).HandleDoor(self) )
        {
            if ( SpecialPause > 0 )
                Acceleration = vect(0,0,0);
            GotoState('Racing', 'SpecialNavig');
            return;
        }
        Focus = Destination;
        if ( !bWallAdjust && PickWallAdjust())
            GotoState('Racing', 'AdjustFromWall');
        else
        {
            MoveTimer = -1.0;
            bWallAdjust = false;
        }
    }

    function Trigger( actor Other, pawn EventInstigator )
    {
//        if ( EventInstigator == self )    // DSL -- doesn't matter who hit it
            bTargetHit = True;
//log( self$"RBTrig my EI is "$EventInstigator$", other is "$Other$", and bTH = "$bTargetHit );   //9999

/*
        if ( bDelayedPatrol )
        {
            if ( bHateWhenTriggered )
            {
                if ( EventInstigator.bIsPlayer)
                    AttitudeToPlayer = ATTITUDE_Hate;
                else
                    Hated = EventInstigator;
            }
            GotoState('Racing', 'Patrol');
        }
        else
            Global.Trigger(Other, EventInstigator);
*/
    }
    
    function Timer()
    {
        Enable('Bump');
        Mood = 0.0;
        OldEnemy = Enemy;
        Enemy = None;
        bMoodTimer = false;
    }
    
    function AnimEnd()
    {
        PlayPatrolStop();
    }


	function Landed(vector HitNormal)
	{
		local vector Vel2D;

//log( "RB: racing state landed with velocity.z = "$Velocity.Z );
		if ( MoveTarget != None )
		{
			Vel2D = Velocity;
			Vel2D.Z = 0;
			if ( (Vel2D Dot (MoveTarget.Location - Location)) < 0 )
				Acceleration = vect(0,0,0);
		}
		//Note - physics changes type to PHYS_Walking by default for landed pawns
		PlayLanded(Velocity.Z);
		if (Velocity.Z < -1.4 * JumpZ)
		{
			MakeNoise(-0.5 * Velocity.Z/(FMax(JumpZ, 150.0)));
			if (Velocity.Z <= -1100)
			{
				if ( (Velocity.Z < -2000) && (ReducedDamageType != 'All') )
				{
					health = -1000; //make sure gibs
					Died(None, 'fell', Location);
				}
				else if ( Role == ROLE_Authority )
					TakeDamage(-0.15 * (Velocity.Z + 1050), None, Location, vect(0,0,0), 'fell');
			}
			if ( health > 0 )
				GotoState('FallingState', 'Landed');
		}
		else 
			GotoState('FallingState', 'Done');
	}


    function EnemyAcquired()
    {
//log(Class$" just acquired an enemy");
        GotoState('Acquisition');
    }

    function PickDestination(optional bool bNoCharge)
    {
        local Actor path;
        
//log( "PD start with OO = "$RacePoint(OrderObject).Tag );
//log( "PD start with SG = "$SpecialGoal );
        path = None;
        if (SpecialGoal != None)
            path = FindPathToward(SpecialGoal);
        else if ( OrderObject != None )
            path = FindPathToward(OrderObject);

//log( "PD 2, path = "$path );
        if (path != None)
        {
//log( "PD 3" );
            MoveTarget = path;
            Destination = path.Location;
        }
        else
            OrderObject = None;
//log( self$": PD end with path = "$path );
    }

    function FindNextPatrol()
    {
        local RacePoint pat;

// this hooks race progress to RaceTag array initialized at startup
//log( "Finding next with RPIndex = "$RPIndex );
        OrderTag = RaceTag[RPIndex];
        foreach AllActors( class 'RacePoint', pat, OrderTag )
        {
            OrderObject = pat;
                return;
        }
    }

    function BeginState()
    {
//log( "DSL - racing state begin func" );
        SpecialGoal = None;
        SpecialPause = 0.0;
        Enemy = None;
        NextAnim = '';
        Disable('AnimEnd');
        SetAlertness(0.0);
        bReadyToAttack = (FRand() < 0.3 + 0.2 * skill); 
    }

    function EndState()
    {
        bCamping = false;
        bWallAdjust = false;
    }

AdjustFromWall:
    bWallAdjust = true;
    bCamping = false;
    StrafeTo(Destination, Focus); 
    Destination = Focus; 
    MoveTo(Destination);
    bWallAdjust = false;
    Goto('MoveToPatrol');

ResumePatrol:
//log( "RB: resuming patrol, mt = "$MoveTarget );
    if (MoveTarget != None)
    {
        PlayRunning();
        MoveToward(MoveTarget);
   //log( "going to reachedpatrol from resumepatrol" );
        Goto('ReachedPatrol');
    }
    else
        Goto('Patrol');
            
Begin:
//log("RB: starting patrol with Vel = "$Velocity);
    sleep(0.1);

Patrol: //FIXME -add stasis mode? - also set random start point in roam area
    WaitForLanding();
    FindNextPatrol();
    Disable('AnimEnd');
    if (RacePoint(OrderObject) != None)
    {
        //log("Move to next patrol point");
        TweenToRunning(0.3);    // runmod
        PlayRunning();          // runmod
        numHuntPaths = 0;

MoveToPatrol:
//log( "Off to find "$RacePoint(OrderObject).Tag );
        if (actorReachable(OrderObject))
        {
//            MoveToward(OrderObject, WalkingSpeed);
// FIXME -- tween to running only if not currently running
                    TweenToRunning(0.1);
                    FinishAnim();
                    PlayRunning();
            MoveToward(OrderObject, GroundSpeed);    // runmod
        }
        else if ( VSize(Location - OrderObject.Location) < 150.0 )     // jumpto-able?
        {
//log ( "Moving sans reachability toward "$RacePoint(OrderObject).Tag );
// FIXME -- tween to running only if not currently running
                    TweenToRunning(0.1);
                    FinishAnim();
                    PlayRunning();
            MoveToward(OrderObject, GroundSpeed);    // runmod
        }
        else
        {
            PickDestination();
            if (OrderObject != None)
            {
SpecialNavig:
/*
                if (SpecialPause > 0.0)
                {
                    Acceleration = vect(0,0,0);
                    TweenToPatrolStop(0.3);
                    Sleep(SpecialPause);
                    SpecialPause = 0.0;
                    TweenToRunning(0.1);
                    FinishAnim();
                    PlayRunning();
                }
*/
                numHuntPaths++;
//                MoveToward(MoveTarget, WalkingSpeed);
                PlayRunning();
                MoveToward(MoveTarget);     // runmod
                if ( numHuntPaths < 30 )
                    Goto('MoveToPatrol');
                else
                {
                    //log( "TH: specnav to giveup, huntpaths = "$numHuntPaths );
//                    Goto('GiveUp');
                    if ( lastPoint != None )
                    {
                        Regress( lastPoint );
                        Goto('Patrol');
                    }
                    else
                    {
                        if ( RPIndex > 0 )
                        {
//log("RB - discounting RPIndex with oo" );
                            PrevRPIndex();
                            Goto('Patrol');
                        }
                    }
                }
            }
            else    // OrderObject == None
            {
                if ( lastPoint != None )
                {
                    Regress( lastPoint );
                    Goto('Patrol');
                }
                else
                {
                    if ( RPIndex > 0 )
                    {
//log("RB - discounting RPIndex with no oo" );
                        PrevRPIndex();
                        Goto('Patrol');
                    }
                }
            }
        }

//
// DSL -- this is where most of the RacePoint advice is handled
//
ReachedPatrol:      
        //log("Got to patrol point "$RacePoint(OrderObject).Tag);   
        lastPoint = RacePoint(OrderObject);
//    if ( RacePoint(OrderObject).Tag == 'RP00' )
//        log( self$": my GS is "$GroundSpeed$" and my DGS is "$Default.GroundSpeed );
        NextRPIndex();
AuxPatrol:
        switch ( RacePoint(OrderObject).BotAdvice )
        {
////////////////////////////////////
// Noneing
// Starting
////////////////////////////////////
        case ADV_None:
        case ADV_Start:
            Goto('Patrol');
            break;
////////////////////////////////////
// Jumping
////////////////////////////////////
        case ADV_Jump:

// brutish method:
            if ( RacePoint(OrderObject).bDirectional )
            {                
                DesiredRotation = RacePoint(OrderObject).Rotation;
                bRotateToDesired = true;
            }
            RacePoint(OrderObject).HandleJump(self);
            PlayAnim('SpJump');
//            Velocity.Z = RecommendedJumpZ;
/*
 * non-brutish method:
 *            if ( RacePoint(OrderObject).bDirectional )
 *            {
 *                PlayTurning();
 *                RPRotation = vector((RacePoint(OrderObject)).Rotation);
 *                if ( Rotation != rotator(RPRotation) )
 *                    TurnTo( RPRotation );
 *                PlayRunning();
 *            }
 */
            break;
////////////////////////////////////
// Shooting
////////////////////////////////////
		case ADV_Shoot:
ShootTarget:
			Target=RacePoint(OrderObject).Target;
//log( self$" shooting target "$Target );
            if ( RacePoint(OrderObject).SwitchWeapon != None )
                SwitchToWeapon(RacePoint(OrderObject).SwitchWeapon);
// we change our tagname to the event of the trigger we
// are about to shoot, so when we get triggered we know
// the target has been hit
            if ( Target != None && Weapon != None )
            {
                Tag = Target.Event;     // connect me up to get event msg from target trigger
         	    Acceleration = vect(0,0,0); //stop
         	    DesiredRotation = Rotator(Target.Location - Location);
       		    PlayTurning();
FaceTarget:
         	    if (NeedToTurn(Target.Location))
             	{       
             		TurnToward(Target);
                    Goto('FaceTarget');
             	}
           		TweenToFighter(0.1);
                ViewRotation = Rotation;
             	FinishAnim();

                bTargetHit = False;
                bFire = 1;
                bAltFire = 0;
             //   Enemy = pawn(Target);
                PlayFiring();
                                         // don't want to wait too long
                PatienceCounter = RacePoint(OrderObject).iPatience;
MustHitTarget:                           // DSL -- provide another way out if ammo gone
                Weapon.Fire(1.0);        //semi-semiautomatic
                PatienceCounter--;
                if ( bTargetHit == False )
                {
                     Sleep(0.1);
                     if ( PatienceCounter > 0 )
                         Goto('MustHitTarget');
                }
                HaltFiring();
             	FinishAnim();
                if ( bTargetHit == False )      // never did hit it
                {
                    Regress(RacePoint(OrderObject));    // go back and try again
                }
                else if ( myVox != None )        // do we have a voice?
                {
                    if ( FRand() < 0.5 )    // 1 out of 2 times
                    {
                        WiseCrack();
                    }
                }

            } // Target!=None
            Tag = MyName;                       // restore original moniker
            break;
////////////////////////////////////
// Waiting for next racepoint to get near
////////////////////////////////////
		case ADV_WaitForNext:
                                         // don't want to wait too long
            PatienceCount = RacePoint(OrderObject).iPatience;
            PatienceCounter = PatienceCount;
            LastRPReach = 0.0;
			PlayWaiting();
			FindNextPatrol();
Waiting:                                // DSL - provide another loop escape route
			Sleep(0.1);
            RPReach = VSize(Location - OrderObject.Location);
            if ( RPReach == LastRPReach )       // stuck in one spot?
            {
                PatienceCounter--;
                if ( PatienceCounter < 0 )       // seem to be staying here...
                {
                    PlayWalking();
                    Regress(RacePoint(OrderObject));    // go back and try again
        			Goto('MoveToPatrol');
                }
            }
            else
            {
                LastRPReach = RPReach;
                PatienceCounter = PatienceCount;    // refill
            }

			if ( RPReach > 160.0 )
				Goto('Waiting');

		    if ( NeedToTurn(OrderObject.Location) ) // has our attention drifted?
            {
                PlayTurning();
                TurnToward(OrderObject);
            }

            PlayWalking();
			Goto('MoveToPatrol');
            break;
////////////////////////////////////
// Switching weapon
////////////////////////////////////
        case ADV_SwitchWeapon:
//  make sure one is in inventory
            bWFlag = SwitchToWeapon(RacePoint(OrderObject).SwitchWeapon);
            if ( bWFlag )   // we have weapon, but do we have ammo?
            {
                if ( Weapon.AmmoType.AmmoAmount == 0 )
                    bWFlag = False;
            }
            if ( !bWFlag )
            {
// DSL - TODO search for ammo rather than replacement weapon
                foreach visiblecollidingactors(class'Inventory', tInv, 600 )
                {
                    if ( (tInv.IsInState('PickUp'))
                && (tInv.IsA(RacePoint(OrderObject).SwitchTag))
				&& (tInv.Location.Z < Location.Z + MaxStepHeight + CollisionHeight) )
                    {
                        bWFlag = True;
                        break;
                    }
                }
                if ( bWFlag )
                    MoveToward(tInv);
                else
                    Regress( RacePoint(OrderObject) );
            }
            break;
////////////////////////////////////
// Inspecting mover
//
// if subject mover is not in desired keyframe, this racepoint
// should contain ADV_Shoot to trigger mover
////////////////////////////////////
        case ADV_Inspect:
//          if ( Mover(RacePoint(OrderObject).CheckMover).KeyNum
//log( self$" inspecting tMov = "$RacePoint(OrderObject).CheckMover );
            tMov = RacePoint(OrderObject).CheckMover;

            if ( tMov.KeyNum != RacePoint(OrderObject).DesiredKeyNum )
                Goto('ShootTarget');
            break;
////////////////////////////////////
// WaitForMover
//
// if subject mover is not in desired keyframe, wait
////////////////////////////////////
		case ADV_WaitForMover:
                                         // don't want to wait too long
            PatienceCount = RacePoint(OrderObject).iPatience;
            PatienceCounter = PatienceCount;
			PlayWaiting();
			tMov = RacePoint(OrderObject).CheckMover;
MoverWaiting:                                // DSL - provide another loop escape route
			Sleep(0.1);
            if ( tMov.KeyNum != RacePoint(OrderObject).DesiredKeyNum )
            {
                PatienceCounter--;
                if ( PatienceCounter < 0 )       // seem to be staying here...
                {
                    Regress(RacePoint(OrderObject));    // go back and try again
        			Goto('MoveToPatrol');
                }
				else
					Goto('MoverWaiting');
            }
			FindNextPatrol();
            PlayWalking();
			Goto('MoveToPatrol');
			break;
////////////////////////////////////
// end point
////////////////////////////////////
        case ADV_EndOfLap:
            GotoState('Wandering');
            break;
        } // end of switch(advice)

////////////////////////////////////
// other point property juggling
////////////////////////////////////
/*
        if ( RacePoint(OrderObject).pausetime > 0.0 )
        {
            //log("Pause patrol");
            Acceleration = vect(0,0,0);
            TweenToFighter(0.2);
            FinishAnim();
            PlayTurning();
            TurnTo(Location + (RacePoint(OrderObject)).lookdir);
            if ( RacePoint(OrderObject).RaceAnim != '')
            {
                TweenAnim( RacePoint(OrderObject).RaceAnim, 0.3);
                FinishAnim();
                RacePoint(OrderObject).AnimCount = RacePoint(OrderObject).numAnims;
                While ( RacePoint(OrderObject).AnimCount > 0 )
                {
                    RacePoint(OrderObject).AnimCount--;
                    if (RacePoint(OrderObject).RaceSound != None )
                        PlaySound( RacePoint(OrderObject).RaceSound ); 
                    PlayAnim(RacePoint(OrderObject).RaceAnim);
                    FinishAnim();
                }
            }
            else
            {
                TweenToPatrolStop(0.3);
                FinishAnim();
                Enable('AnimEnd');
                NextAnim = '';
                PlayPatrolStop();
                ////log("stop here for "$(RacePoint(OrderObject)).pausetime);
                Sleep((RacePoint(OrderObject)).pausetime);
                Disable('AnimEnd');
                FinishAnim();
            }
        }
*/
// handling auxtension of a racepoint
// NOTE: this relies on the level editor who sets
// bAux to true and supplies the AuxRacePoint reference
// knows in his or her heart of hearts that the RacePoint
// actor is reachable
        if ( RacePoint(OrderObject).bAux )
        {
            OrderObject = RacePoint(OrderObject).AuxRacePoint;
            MoveToward(OrderObject, GroundSpeed);    // runmod
            Goto('AuxPatrol');
        }
        Goto('Patrol');
    }

GiveUp:
//log(self$" gave up race (sob)");
    NextState = 'Racing'; //default  (this is what keeps it from NerfBots.uc)
	NextLabel = 'Begin';
    GotoState('Wandering');        
DelayedPatrol:
        Enable('AnimEnd');
        PlayPatrolStop();
}


state Defending
{
ignores SeePlayer, HearNoise, Bump, HitWall;

    function eAttitude AttitudeTo(Pawn Other)
    {
//log ( self$" adjatt in "$GetStateName() );
        return AdjustAttitude(Other);
    }

	function ChooseAttackMode()
	{
		local eAttitude AttitudeToEnemy;
		local float Aggression;
		local pawn changeEn;


//		if ( health <= 0 )
//			log(self$" choose attack while dead");		
		if ((Enemy == None) || (Enemy.Health <= 0))
		{
			WhatToDoNext('','');
			return;
		}
			
		AttitudeToEnemy = AttitudeTo(Enemy);
			
		if (AttitudeToEnemy == ATTITUDE_Fear)
		{
			GotoState('Racing');    // DSL -- kludge
			return;
		}
		else if (AttitudeToEnemy == ATTITUDE_Friendly)
		{
			WhatToDoNext('','');
			return;
		}
		else if ( !LineOfSightTo(Enemy) )
		{
             GotoState('Racing');
		}	
		
		if (bReadyToAttack && Enemy != None)
		{
//log("Attack!"); // 9999
			Target = Enemy;
			If (VSize(Enemy.Location - Location) <= (MeleeRange + Enemy.CollisionRadius + CollisionRadius))
			{
				GotoState('RangedDefense');
				return;
			}
			else
				SetTimer(TimeBetweenAttacks, False);
		}
			
        GotoState('Racing');
		GotoState('TacticalMove');
		//log("Next state is "$state);
	}
	
	//EnemyNotVisible implemented so engine will update LastSeenPos
	function EnemyNotVisible()
	{
		////log("enemy not visible");
			GotoState('Racing');    // DSL -- kludge
	}

	function Timer()
	{
		bReadyToAttack = True;
	}

	function BeginState()
	{
		if ( TimerRate <= 0.0 )
			SetTimer(TimeBetweenAttacks  * (1.0 + FRand()),false); 
		if (Physics == PHYS_None)
			SetMovementPhysics(); 
	}

Begin:
// DSL -- looks like a good spot to speak up
    if ( FRand() < 0.5 )    // 1 out of 2 times
        WiseCrack();

	//log( "DEF - Enemy = "$Enemy );
	ChooseAttackMode();
}


state RangedDefense
{
ignores SeePlayer, HearNoise, Bump;

    function eAttitude AttitudeTo(Pawn Other)
    {
//log ( self$" adjatt in "$GetStateName() );
        return AdjustAttitude(Other);
    }

	function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, name damageType)
	{
		Global.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
		if ( health <= 0 )
			return;
		if (NextState == 'TakeHit')
		{
			NextState = 'RangedDefense';
			NextLabel = 'Begin';
		}
	}

	function StopWaiting()
	{
		Timer();
	}

	function EnemyNotVisible()
	{
		////log("enemy not visible");
		//let attack animation completes
	}

	function KeepDefending()
	{
		if ( bFiringPaused )
			return;
		if ( (Enemy == None) || (Enemy.Health <= 0) || !LineOfSightTo(Enemy) )
		{
			bFire = 0;
			bAltFire = 0; 
			GotoState('Defending');
		}
		else if ( Skill > 3.5 * FRand() - 0.5 )
		{
			bReadyToAttack = true;
			GotoState('TacticalMove');
		}	
	}

	function Timer()
	{
		if ( bFiringPaused )
		{
			TweenToRunning(0.12);
			GotoState(NextState, NextLabel);
		}
	}

	function AnimEnd()
	{
		local float decision;

		decision = FRand() - 0.27 * skill - 0.1;
		if ( (bFire == 0) && (bAltFire == 0) )
			decision = decision - 0.5;
		if ( decision < 0 )
			GotoState('RangedDefense', 'DoneFiring');
		else
		{
			PlayWaiting();
			FireWeapon();
		}
	}
	
	function SpecialFire()
	{
		bFiringPaused = true;
		SetTimer(0.75 + VSize(Target.Location - Location)/Weapon.AltProjectileSpeed, false);
		SpecialPause = 0.0;
		NextState = 'Defending';
		NextLabel = 'Begin'; 
	}
	
	function BeginState()
	{
		Disable('AnimEnd');
		if ( bFiringPaused )
		{
			SetTimer(SpecialPause, false);
			SpecialPause = 0;
		}
		else
			Target = Enemy;
	}
	
	function EndState()
	{
		bFiringPaused = false;
	}

Challenge:
	Disable('AnimEnd');
	Acceleration = vect(0,0,0); //stop
	DesiredRotation = Rotator(Enemy.Location - Location);
	PlayChallenge();
	FinishAnim();
	if ( bCrouching && !Region.Zone.bWaterZone )
		Sleep(0.8 + FRand());
	bCrouching = false;
	TweenToFighter(0.1);
	Goto('FaceTarget');

Begin:
	if ( Target == None )
	{
		Target = Enemy;
		if ( Target == None )
			GotoState('Defending');
	}
	Acceleration = vect(0,0,0); //stop
	DesiredRotation = Rotator(Target.Location - Location);
	TweenToFighter(0.15);
	
FaceTarget:
	Disable('AnimEnd');
	if (NeedToTurn(Target.Location))
	{
		PlayTurning();
		TurnToward(Target);
		TweenToFighter(0.1);
	}
	FinishAnim();

ReadyToAttack:
	DesiredRotation = Rotator(Target.Location - Location);
	PlayRangedDefense();
	Enable('AnimEnd');
Firing:
	if ( Target == None )
		GotoState('Defending');
	TurnToward(Target);
	Goto('Firing');
DoneFiring:
	Disable('AnimEnd');
	KeepDefending();  
	Goto('FaceTarget');
}

state TakeHit 
{
ignores seeplayer, hearnoise, bump, hitwall;

    function eAttitude AttitudeTo(Pawn Other)
    {
//log ( self$" adjatt in "$GetStateName() );
        return AdjustAttitude(Other);
    }

	function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, name damageType)
	{
		Global.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
	}

	function Landed(vector HitNormal)
	{
		if (Velocity.Z < -1.4 * JumpZ)
			MakeNoise(-0.5 * Velocity.Z/(FMax(JumpZ, 150.0)));
		bJustLanded = true;
	}

	function Timer()
	{
		bReadyToAttack = true;
	}

	function PlayHitAnim(vector HitLocation, float Damage)
	{
		if ( LastPainTime - Level.TimeSeconds > 0.1 )
		{
			PlayTakeHit(0.1, hitLocation, Damage);
			BeginState();
			GotoState('TakeHit', 'Begin');
		} 
	}	

	function BeginState()
	{
		LastPainTime = Level.TimeSeconds;
		LastPainAnim = AnimSequence;
	}
		
Begin:
	// Acceleration = Normal(Acceleration);
//log( "DSL: Begin TakeHit" );
	FinishAnim();
	if ( skill < 2 )
		Sleep(0.05);
	if ( (Physics == PHYS_Falling) && !Region.Zone.bWaterZone )
	{
		Acceleration = vect(0,0,0);
		NextAnim = '';
//		if ( Health <= 0 )
//			log(self$" fall from takehit while dead");
		GotoState('FallingState', 'Ducking');
	}
	else if (NextState != '')
		GotoState(NextState, NextLabel);
	else
		GotoState('Defending');
}

state FallingState 
{
ignores Bump, Hitwall, WarnTarget;

    function eAttitude AttitudeTo(Pawn Other)
    {
//log ( self$" adjatt in "$GetStateName() );
        return AdjustAttitude(Other);
    }

	singular event BaseChange()
	{
		local actor HitActor;
		local vector HitNormal, HitLocation;

//log( self$" fallingstate func BaseChange from "$Base );
        if ( (Base != None) && Base.IsA('Pawn') )
            JumpOffPawn();


		if ( (Base != None) && Base.IsA('Mover')
			&& ((MoveTarget == Base) 
				|| ((MoveTarget != None) && (MoveTarget == Mover(Base).myMarker))) )
		{
			MoveTimer = -1.0;
			MoveTarget = None;
			acceleration = vect(0,0,0);
		}
		else
			Super.BaseChange();
	}

	function ZoneChange(ZoneInfo newZone)
	{
//log( "RB: fallingstate func ZoneChange" );
//		if ( Health <= 0 )
//			log("Zonechange in falling state while dead");
		Global.ZoneChange(newZone);
		if (newZone.bWaterZone)
		{
			TweenToWaiting(0.15);
			//FIXME - play splash sound and effect
			GotoState('FallingState', 'Splash');
		}
	}
	
	//choose a jump velocity
	function adjustJump()
	{
		local float velZ;
		local vector FullVel;

//log( "RB: fallingstate func adjustJump" );
		velZ = Velocity.Z;
		FullVel = Normal(Velocity) * GroundSpeed;

		If (Location.Z > Destination.Z + CollisionHeight + 2 * MaxStepHeight)
		{
			Velocity = FullVel;
			Velocity.Z = velZ;
			Velocity = EAdjustJump();
			Velocity.Z = 0;
			if ( VSize(Velocity) < 0.9 * GroundSpeed )
			{
				Velocity.Z = velZ;
				return;
			}
		}

		Velocity = FullVel;
		Velocity.Z = JumpZ + velZ;
		Velocity = EAdjustJump();
	}

	function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
							Vector momentum, name damageType)
	{
//log( "RB: fallingstate func TakeDamage" );
		Global.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);

		if (Enemy == None)
		{
			Enemy = instigatedBy;
			NextState = 'Defending'; 
			NextLabel = 'Begin';
		}
		if (Enemy != None)
			LastSeenPos = Enemy.Location;
		if (NextState == 'TakeHit')
		{
			NextState = 'Defending'; 
			NextLabel = 'Begin';
			GotoState('TakeHit'); 
		}
	}

	function bool SetEnemy(Pawn NewEnemy)
	{
		local bool result;

//log( "RB: fallingstate func SetEnemy" );
		result = false;
		if ( Global.SetEnemy(NewEnemy))
		{
			result = true;
			NextState = 'Defending'; 
			NextLabel = 'Begin';
		}
		return result;
	} 

	function Timer()
	{
//log( "RB: fallingstate func Timer" );
//		if ( Health <= 0 )
//			log(self$" fall from timer while dead");
		if ( Enemy != None )
		{
			bReadyToAttack = true;
			if ( CanFireAtEnemy() )
				GotoState('FallingState', 'FireWhileFalling');
		}
	}

	function Landed(vector HitNormal)
	{
		local vector Vel2D;

//log( "RB: falling state landed with velocity = "$Velocity );
		if ( MoveTarget != None )
		{
			Vel2D = Velocity;
			Vel2D.Z = 0;
			if ( (Vel2D Dot (MoveTarget.Location - Location)) < 0 )
				Acceleration = vect(0,0,0);
		}
		//Note - physics changes type to PHYS_Walking by default for landed pawns
		PlayLanded(Velocity.Z);
		if (Velocity.Z < -1.4 * JumpZ)
		{
			MakeNoise(-0.5 * Velocity.Z/(FMax(JumpZ, 150.0)));
			if (Velocity.Z <= -1100)
			{
				if ( (Velocity.Z < -2000) && (ReducedDamageType != 'All') )
				{
					health = -1000; //make sure gibs
					Died(None, 'fell', Location);
				}
				else if ( Role == ROLE_Authority )
					TakeDamage(-0.15 * (Velocity.Z + 1050), None, Location, vect(0,0,0), 'fell');
			}
			if ( health > 0 )
				GotoState('FallingState', 'Landed');
		}
		else 
			GotoState('FallingState', 'Done');
	}
	
	function SeePlayer(Actor SeenPlayer)
	{
//log( "RB: fallingstate func SeePlayer" );
		Global.SeePlayer(SeenPlayer);
		disable('SeePlayer');
		disable('HearNoise');
	}

	function EnemyNotVisible()
	{
//log( "RB: fallingstate func EnemyNotVisible" );
		enable('SeePlayer');
		enable('HearNoise');
	}

	function SetFall()
	{
//log( "RB: fallingstate func SetFall" );
//		if ( Health < 0 )
//			log(self$" setfall from fall");
		if (!bUpAndOut)
			GotoState('FallingState');
	}
	
	function EnemyAcquired()
	{
//log( "RB: fallingstate func EnemyAcquired" );
		NextState = 'Acquisition';
		NextLabel = 'Begin';
	}

	function BeginState()
	{
//log("RB: begin falling state with velocity = "$Velocity );
//		if ( Health <= 0 )
//			log(self$" entered falling state at "$Level.Timeseconds$ "with next "$NextState);
		if (Enemy == None)
			Disable('EnemyNotVisible');
		else
		{
			Disable('HearNoise');
			Disable('SeePlayer');
		}
		if ( (bFire > 0) || (bAltFire > 0) || (Skill == 3) )
			SetTimer(0.01, false);
        TweenAnim('SpJump', 0.8 );
        PlayAnim('SpJump');
	}

	function EndState()
	{
//log("RB: ending falling state with velocity = "$Velocity );
		bUpAndOut = false;
	}

FireWhileFalling:
	if ( Physics != PHYS_Falling )
		Goto('Done');
	TurnToward(Enemy);
	if ( CanFireAtEnemy() )
		FireWeapon();
	Sleep(0.9 + 0.2 * FRand());
	Goto('FireWhileFalling');
 			
LongFall:
    //log( "Longfalling - "$self );
	if ( bCanFly )
	{
		SetPhysics(PHYS_Flying);
		Goto('Done');
	}
	Sleep(0.7);
	TweenToFighter(0.2);
/*
	if ( Enemy != None )
	{
		TurnToward(Enemy);
		FinishAnim();
		if ( CanFireAtEnemy() )
		{
			PlayRangedDefense();
			FinishAnim();
		}
		PlayChallenge();
		FinishAnim();
	}
*/
	TweenToFalling();
	if ( Velocity.Z > -150 ) //stuck
	{
		SetPhysics(PHYS_Falling);
		if ( Enemy != None )
			Velocity = groundspeed * normal(Enemy.Location - Location);
		else
			Velocity = groundspeed * VRand();

		Velocity.Z = FMax(JumpZ, 250);
	}
	Goto('LongFall');	

Landed:
	//log("Playing "$animsequence$" at "$animframe);
//	FinishAnim();
	//log("Finished "$animsequence$" at "$animframe);
Done:
//log( "RB: fallingstate label Done, vel = "$Velocity );

//    Velocity = vect(0,0,0); 
//    TweenAnim('SpLand', 0.08 );
    PlayAnim('SpLand');
//    FinishAnim();
    TweenToRunning(0.3);

	if ( NextAnim == '' )
	{
		bUpAndOut = false;
		if ( NextState != '' )
			GotoState(NextState, NextLabel);
		else 
			GotoState('Racing');    //defending
	}
	if ( !bUpAndOut )
	{
		if ( NextAnim == 'Fighter' )
			TweenToFighter(0.2);
		else
			TweenAnim(NextAnim, 0.12);
	} 

Splash:
	bUpAndOut = false;
	if ( NextState != '' )
		GotoState(NextState, NextLabel);
	else 
			GotoState('Racing');        // defending
			
Begin:
	if (Enemy == None)
		Disable('EnemyNotVisible');
	else
	{
		Disable('HearNoise');
		Disable('SeePlayer');
	}
	if ( !bUpAndOut ) // not water jump
	{	
		if (Region.Zone.bWaterZone)
		{
			SetPhysics(PHYS_Swimming);
			GotoState(NextState, NextLabel);
		}	
		if ( !bJumpOffPawn )
			AdjustJump();
		else
			bJumpOffPawn = false;
PlayFall:
        TweenAnim('SpMidAir',0.1);
        LoopAnim('SpMidAir');
	}
	
	if (Physics != PHYS_Falling)
		Goto('Done');
	Sleep(2.0);
	Goto('LongFall');

Ducking:
		
}

state TacticalMove
{
ignores SeePlayer, HearNoise;

    function eAttitude AttitudeTo(Pawn Other)
    {
//log ( self$" adjatt in "$GetStateName() );
        return AdjustAttitude(Other);
    }

	function SetFall()
	{
		Acceleration = vect(0,0,0);
		Destination = Location;
		NextState = 'Defending'; 
		NextLabel = 'Begin';
		NextAnim = 'Fighter';
		GotoState('FallingState');
	}

	function WarnTarget(Pawn shooter, float projSpeed, vector FireDir)
	{	
		if ( bCanFire && (FRand() < 0.4) ) 
			return;

		Super.WarnTarget(shooter, projSpeed, FireDir);
	}

	function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, name damageType)
	{
		Global.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
		if ( health <= 0 )
			return;
		if ( NextState == 'TakeHit' )
		{
			NextState = 'TacticalMove'; 
			NextLabel = 'TakeHit';
			GotoState('TakeHit'); 
		}
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Focus = Destination;
		//if (PickWallAdjust())
		//	GotoState('TacticalMove', 'AdjustFromWall');
        if ( Enemy != None )
        {
    		if ( bChangeDir || (FRand() < 0.5) 
    			|| (((Enemy.Location - Location) Dot HitNormal) < 0) )
    		{
    			DesiredRotation = Rotator(Enemy.Location - location);
    			GiveUpTactical(false);
    		}
    		else
    		{
    			bChangeDir = true;
    			Destination = Location - HitNormal * FRand() * 500;
    		}
        }
		else
		{
			bChangeDir = true;
			Destination = Location - HitNormal * FRand() * 500;
		}
	}

	function FearThisSpot(Actor aSpot)
	{
		Destination = Location + 120 * Normal(Location - aSpot.Location); 
	}

	function AnimEnd() 
	{
		PlayCombatMove();
	}

	function Timer()
	{
		bReadyToAttack = True;
		Enable('Bump');
		Target = Enemy;
		if (VSize(Enemy.Location - Location) 
				<= (MeleeRange + Enemy.CollisionRadius + CollisionRadius))
			GotoState('RangedDefense');		 
		else if ( FRand() > 0.5 + 0.17 * skill ) 
			GotoState('RangedDefense');
	}

	function EnemyNotVisible()
	{
		if ( !bGathering && (aggressiveness > relativestrength(enemy)) )
		{
			if (ValidRecovery())
				GotoState('TacticalMove','RecoverEnemy');
			else
				GotoState('Defending');
		}
		Disable('EnemyNotVisible');
	}

	function bool ValidRecovery()
	{
		local actor HitActor;
		local vector HitLocation, HitNormal;
		
		HitActor = Trace(HitLocation, HitNormal, Enemy.Location, LastSeeingPos, false);
		return (HitActor == None);
	}
		
	function GiveUpTactical(bool bNoCharge)
	{	
		if ( !bNoCharge && (2 * CombatStyle > (3 - Skill) * FRand()) )
			GotoState('Charging');
		else if ( bReadyToAttack && (skill > 3 * FRand() - 1) )
			GotoState('RangedDefense');
		else
			GotoState('RangedDefense', 'Challenge'); 
	}		

	function bool TryToward(inventory Inv, float Weight)
	{
		local bool success; 
		local vector pickdir, collSpec, minDest, HitLocation, HitNormal;
		local Actor HitActor;
        local int step;

        step = 0;

//log( self$" Weight = "$Weight$" RBTT step "$step++ );
		if ( (Weight < 0.0008) && ((Weight < 0.0008 - 0.0002 * skill) 
				|| !Enemy.LineOfSightTo(Inv)) )
			return false;

//log( "RBTT step "$step++ );
		pickdir = Inv.Location - Location;
		if ( Physics == PHYS_Walking )
			pickDir.Z = 0;
//log( "RBTT step "$step++ );
		pickDir = Normal(PickDir);

		collSpec.X = CollisionRadius;
		collSpec.Y = CollisionRadius;
		collSpec.Z = FMax(6, CollisionHeight - 18);
		
//log( "RBTT step "$step++ );
		minDest = Location + FMin(160.0, 3*CollisionRadius) * pickDir;
		HitActor = Trace(HitLocation, HitNormal, minDest, Location, false, collSpec);
//log( "RBTT step "$step++ );
		if (HitActor == None)
		{
			success = (Physics != PHYS_Walking);
//log( self$" success = "$success$" RBTT step "$step++ );
			if ( !success )
			{
				collSpec.X = FMin(14, 0.5 * CollisionRadius);
				collSpec.Y = collSpec.X;
				HitActor = Trace(HitLocation, HitNormal, minDest - (18 + MaxStepHeight) * vect(0,0,1), minDest, false, collSpec);
				success = (HitActor != None);
			}
//log( "RBTT step "$step++ );
			if ( success )
			{
				Destination = Inv.Location;
				bGathering = true;
				if ( 2.7 * FRand() < skill )
					GotoState('TacticalMove','DoStrafeMove');
				else
					GotoState('TacticalMove','DoDirectMove');
				return true;
			}
		}

		return false;
	}

	function PainTimer()
	{
		if ( (FootRegion.Zone.bPainZone) && (FootRegion.Zone.DamagePerSec > 0)
			&& (FootRegion.Zone.DamageType != ReducedDamageType) )
			GotoState('Retreating');
		Super.PainTimer();
	}


/* PickDestination()
Choose a destination for the tactical move, based on aggressiveness and the tactical
situation. Make sure destination is reachable
*/
	function PickDestination(bool bNoCharge)
	{
		local inventory Inv, BestInv, SecondInv;
		local float Bestweight, NewWeight, MaxDist, SecondWeight;


   
		// possibly pick nearby inventory
		// higher skill bots will always strafe, lower skill
		// both do this less, and strafe less

		if ( !bReadyToAttack && (TimerRate == 0.0) )
			SetTimer(0.7, false);
		if ( Level.TimeSeconds - LastInvFind < 2.5 - 0.5 * skill )
		{
			PickRegDestination(bNoCharge);
			return;
		}

		LastInvFind = Level.TimeSeconds;
		bGathering = false;
		BestWeight = 0;
		MaxDist = 600 + 70 * skill;
/* with Enemy version
		foreach visiblecollidingactors(class'Inventory', Inv, MaxDist)
			if ( (Inv.IsInState('PickUp')) && (Inv.MaxDesireability/200 > BestWeight)
				&& (Inv.Location.Z < Location.Z + MaxStepHeight + CollisionHeight)
				&& (Inv.Location.Z > FMin(Location.Z, Enemy.Location.Z) - CollisionHeight) )
*/
		foreach visiblecollidingactors(class'Inventory', Inv, MaxDist)
			if ( (Inv.IsInState('PickUp')) && (Inv.MaxDesireability/200 > BestWeight)
				&& (Inv.Location.Z < Location.Z + MaxStepHeight + CollisionHeight)
				&& (Inv.Location.Z > Location.Z - CollisionHeight) )

			{
				NewWeight = inv.BotDesireability(self)/VSize(Inv.Location - Location);
				if ( NewWeight > BestWeight )
				{
					SecondWeight = BestWeight;
					BestWeight = NewWeight;
					SecondInv = BestInv;
					BestInv = Inv;
				}
			}

		if ( BestInv == None )
		{
			PickRegDestination(bNoCharge);
			return;
		}

		if ( TryToward(BestInv, BestWeight) )
			return;

		if ( SecondInv == None )
		{
			PickRegDestination(bNoCharge);
			return;
		}

		if ( TryToward(SecondInv, SecondWeight) )
			return;

		PickRegDestination(bNoCharge);
	}

	function PickRegDestination(bool bNoCharge)
	{
		local vector pickdir, enemydir, enemyPart, Y, minDest;
		local actor HitActor;
		local vector HitLocation, HitNormal, collSpec;
		local float Aggression, enemydist, minDist, strafeSize, optDist;
		local bool success, bNoReach;
	
// DSL no enemy = accessed none --
// how do we get here without an enemy?

        if ( Enemy == None )
        {
            GotoState( 'Racing' );
            return;
        }

		bChangeDir = false;
		if (Region.Zone.bWaterZone && !bCanSwim && bCanFly)
		{
			Destination = Location + 75 * (VRand() + vect(0,0,1));
			Destination.Z += 100;
			return;
		}
		if ( Enemy.Region.Zone.bWaterZone )
			bNoCharge = bNoCharge || !bCanSwim;
		else 
			bNoCharge = bNoCharge || (!bCanFly && !bCanWalk);
		
		success = false;
		enemyDist = VSize(Location - Enemy.Location);
		Aggression = 2 * (CombatStyle + FRand()) - 1.1;
		if ( Enemy.bIsPlayer && (AttitudeTo(Enemy) == ATTITUDE_Fear) && (CombatStyle > 0) )
			Aggression = Aggression - 2 - 2 * CombatStyle;
		if ( Weapon != None )
			Aggression += 2 * Weapon.SuggestAttackStyle();
		if ( Enemy.Weapon != None )
			Aggression += 2 * Enemy.Weapon.SuggestDefenseStyle();

		if ( enemyDist > 1000 )
			Aggression += 1;
		if ( !bNoCharge )
			bNoCharge = ( Aggression < FRand() );

		if ( (Physics == PHYS_Walking) || (Physics == PHYS_Falling) )
		{
			if (Location.Z > Enemy.Location.Z + 140) //tactical height advantage
				Aggression = FMax(0.0, Aggression - 1.0 + CombatStyle);
			else if (Location.Z < Enemy.Location.Z - CollisionHeight) // below enemy
			{
				if ( !bNoCharge && (Aggression > 0) && (FRand() < 0.6) )
				{
					GotoState('Charging');
					return;
				}
				else if ( (enemyDist < 1.1 * (Enemy.Location.Z - Location.Z)) 
						&& !actorReachable(Enemy) ) 
				{
					bNoReach = true;
					aggression = -1.5 * FRand();
				}
			}
		}
	
		if (!bNoCharge && (Aggression > 2 * FRand()))
		{
			if ( bNoReach && (Physics != PHYS_Falling) )
			{
				TweenToRunning(0.15);
				GotoState('Charging', 'NoReach');
			}
			else
				GotoState('Charging');
			return;
		}

		if (enemyDist > FMax(VSize(OldLocation - Enemy.OldLocation), 240))
			Aggression += 0.4 * FRand();
			 
		enemydir = (Enemy.Location - Location)/enemyDist;
		minDist = FMin(160.0, 3*CollisionRadius);
		optDist = 80 + FMin(EnemyDist, 250 * (FRand() + FRand()));  
		Y = (enemydir Cross vect(0,0,1));
		if ( Physics == PHYS_Walking )
		{
			Y.Z = 0;
			enemydir.Z = 0;
		}
		else 
			enemydir.Z = FMax(0,enemydir.Z);
			
		strafeSize = FMax(-0.7, FMin(0.85, (2 * Aggression * FRand() - 0.3)));
		enemyPart = enemydir * strafeSize;
		strafeSize = FMax(0.0, 1 - Abs(strafeSize));
		pickdir = strafeSize * Y;
		if ( bStrafeDir )
			pickdir *= -1;
		bStrafeDir = !bStrafeDir;
		collSpec.X = CollisionRadius;
		collSpec.Y = CollisionRadius;
		collSpec.Z = FMax(6, CollisionHeight - 18);
		
		minDest = Location + minDist * (pickdir + enemyPart);
		HitActor = Trace(HitLocation, HitNormal, minDest, Location, false, collSpec);
		if (HitActor == None)
		{
			success = (Physics != PHYS_Walking);
			if ( !success )
			{
				collSpec.X = FMin(14, 0.5 * CollisionRadius);
				collSpec.Y = collSpec.X;
				HitActor = Trace(HitLocation, HitNormal, minDest - (18 + MaxStepHeight) * vect(0,0,1), minDest, false, collSpec);
				success = (HitActor != None);
			}
			if (success)
				Destination = minDest + (pickdir + enemyPart) * optDist;
		}
	
		if ( !success )
		{					
			collSpec.X = CollisionRadius;
			collSpec.Y = CollisionRadius;
			minDest = Location + minDist * (enemyPart - pickdir); 
			HitActor = Trace(HitLocation, HitNormal, minDest, Location, false, collSpec);
			if (HitActor == None)
			{
				success = (Physics != PHYS_Walking);
				if ( !success )
				{
					collSpec.X = FMin(14, 0.5 * CollisionRadius);
					collSpec.Y = collSpec.X;
					HitActor = Trace(HitLocation, HitNormal, minDest - (18 + MaxStepHeight) * vect(0,0,1), minDest, false, collSpec);
					success = (HitActor != None);
				}
				if (success)
					Destination = minDest + (enemyPart - pickdir) * optDist;
			}
			else 
			{
				if ( (CombatStyle <= 0) || (Enemy.bIsPlayer && (AttitudeTo(Enemy) == ATTITUDE_Fear)) )
					enemypart = vect(0,0,0);
				else if ( (enemydir Dot enemyPart) < 0 )
					enemyPart = -1 * enemyPart;
				pickDir = Normal(enemyPart - pickdir + HitNormal);
				minDest = Location + minDist * pickDir;
				collSpec.X = CollisionRadius;
				collSpec.Y = CollisionRadius;
				HitActor = Trace(HitLocation, HitNormal, minDest, Location, false, collSpec);
				if (HitActor == None)
				{
					success = (Physics != PHYS_Walking);
					if ( !success )
					{
						collSpec.X = FMin(14, 0.5 * CollisionRadius);
						collSpec.Y = collSpec.X;
						HitActor = Trace(HitLocation, HitNormal, minDest - (18 + MaxStepHeight) * vect(0,0,1), minDest, false, collSpec);
						success = (HitActor != None);
					}
					if (success)
						Destination = minDest + pickDir * optDist;
				}
			}	
		}
					
		if ( !success )
			GiveUpTactical(bNoCharge);
		else 
		{
			pickDir = (Destination - Location);
			enemyDist = VSize(pickDir);
			if ( enemyDist > minDist + 2 * CollisionRadius )
			{
				pickDir = pickDir/enemyDist;
				HitActor = Trace(HitLocation, HitNormal, Destination + 2 * CollisionRadius * pickdir, Location, false);
				if ( (HitActor != None) && ((HitNormal Dot pickDir) < -0.6) )
					Destination = HitLocation - 2 * CollisionRadius * pickdir;
			}
		}
	}

	function BeginState()
	{
		MinHitWall += 0.15;
		bAvoidLedges = ( !bCanJump && (CollisionRadius > 40) );
		bCanJump = false;
		bCanFire = false;
	}
	
	function EndState()
	{
		bAvoidLedges = false;
		MinHitWall -= 0.15;
		if (JumpZ > 0)
			bCanJump = true;
	}

//FIXME - what if bReadyToAttack at start
TacticalTick:
	Sleep(0.02);	
Begin:
//log( self$" beginning tactics" );
	TweenToRunning(0.15);
	Enable('AnimEnd');
	if (Physics == PHYS_Falling)
	{
        if ( Enemy != None )
        {
    		DesiredRotation = Rotator(Enemy.Location - Location);
    		Focus = Enemy.Location;
    		Destination = Enemy.Location;
        }
		WaitForLanding();
	}
// dsl-tranq
    if ( FRand() < 0.5 )
        GotoState('Racing');
    else
    	PickDestination(false);
DoMove:
	if ( !bCanStrafe )
	{ 
DoDirectMove:
		Enable('AnimEnd');
		if ( GetAnimGroup(AnimSequence) == 'MovingAttack' )
		{
			AnimSequence = '';
			TweenToRunning(0.12);
		}
		HaltFiring();
		MoveTo(Destination);
	}
	else
	{
DoStrafeMove:
		Enable('AnimEnd');
		bCanFire = true;
		StrafeFacing(Destination, Enemy);	
	}

	if ( (Enemy != None) && !LineOfSightTo(Enemy) && ValidRecovery() )
		Goto('RecoverEnemy');
	else
	{
		bReadyToAttack = true;
		GotoState('Defending');
	}
	
NoCharge:
	TweenToRunning(0.15);
	Enable('AnimEnd');
	if (Physics == PHYS_Falling)
	{
        if ( Enemy != None )
        {
    		DesiredRotation = Rotator(Enemy.Location - Location);
    		Focus = Enemy.Location;
    		Destination = Enemy.Location;
        }
		WaitForLanding();
	}
	PickDestination(true);
	Goto('DoMove');
	
AdjustFromWall:
	Enable('AnimEnd');
	StrafeTo(Destination, Focus); 
	Destination = Focus; 
	Goto('DoMove');

TakeHit:
	TweenToRunning(0.12);
	Goto('DoMove');

RecoverEnemy:
	Enable('AnimEnd');
	bReadyToAttack = true;
	HidingSpot = Location;
	bCanFire = false;
	Destination = LastSeeingPos + 3 * CollisionRadius * Normal(LastSeeingPos - Location);
	if ( bCanStrafe || (VSize(LastSeeingPos - Location) < 3 * CollisionRadius) )
		StrafeFacing(Destination, Enemy);
	else
		MoveTo(Destination);
	if ( Weapon == None ) 
		Acceleration = vect(0,0,0);
	if ( NeedToTurn(Enemy.Location) )
	{
		PlayTurning();
		TurnToward(Enemy);
	}
	if ( CanFireAtEnemy() )
	{
		Disable('AnimEnd');
		DesiredRotation = Rotator(Enemy.Location - Location);
		if ( Weapon == None ) 
		{
			PlayRangedDefense();
			FinishAnim();
			TweenToRunning(0.1);
			bReadyToAttack = false;
			SetTimer(TimeBetweenAttacks, false);
		}
		else
		{
			FireWeapon();
			if ( Weapon.bSplashDamage )
			{
				bFire = 0;
				bAltFire = 0;
				Acceleration = vect(0,0,0);
				Sleep(0.1);
			}
		}

		if ( (FRand() + 0.1 > CombatStyle) )
		{
			Enable('EnemyNotVisible');
			Enable('AnimEnd');
			Destination = HidingSpot + 4 * CollisionRadius * Normal(HidingSpot - Location);
			Goto('DoMove');
		}
	}

	GotoState('Defending');
}

defaultproperties
{
     RaceTag(0)=RP00
     RaceTag(1)=RP01
     RaceTag(2)=RP02
     RaceTag(3)=RP03
     RaceTag(4)=RP04
     RaceTag(5)=RP05
     RaceTag(6)=RP06
     RaceTag(7)=RP07
     RaceTag(8)=RP08
     RaceTag(9)=RP09
     RaceTag(10)=RP10
     RaceTag(11)=RP11
     RaceTag(12)=RP12
     RaceTag(13)=RP13
     RaceTag(14)=RP14
     RaceTag(15)=RP15
     RaceTag(16)=RP16
     RaceTag(17)=RP17
     RaceTag(18)=RP18
     RaceTag(19)=RP19
     RaceTag(20)=RP20
     RaceTag(21)=RP21
     RaceTag(22)=RP22
     RaceTag(23)=RP23
     RaceTag(24)=RP24
     RaceTag(25)=RP25
     RaceTag(26)=RP26
     RaceTag(27)=RP27
     RaceTag(28)=RP28
     RaceTag(29)=RP29
     RaceTag(30)=RP30
     RaceTag(31)=RP31
     RaceTag(32)=RP32
     RaceTag(33)=RP33
     RaceTag(34)=RP34
     RaceTag(35)=RP35
     RaceTag(36)=RP36
     RaceTag(37)=RP37
     RaceTag(38)=RP38
     RaceTag(39)=RP39
     RaceTag(40)=RP40
     RaceTag(41)=RP41
     RaceTag(42)=RP42
     RaceTag(43)=RP43
     RaceTag(44)=RP44
     RaceTag(45)=RP45
     RaceTag(46)=RP46
     RaceTag(47)=RP47
     RaceTag(48)=RP48
     RaceTag(49)=RP49
     RaceTag(50)=RP50
     RaceTag(51)=RP51
     RaceTag(52)=RP52
     RaceTag(53)=RP53
     RaceTag(54)=RP54
     RaceTag(55)=RP55
     RaceTag(56)=RP56
     RaceTag(57)=RP57
     RaceTag(58)=RP58
     RaceTag(59)=RP59
     RaceTag(60)=RP60
     RaceTag(61)=RP61
     RaceTag(62)=RP62
     RaceTag(63)=RP63
     RaceTag(64)=RP64
     RaceTag(65)=RP65
     RaceTag(66)=RP66
     RaceTag(67)=RP67
     RaceTag(68)=RP68
     RaceTag(69)=RP69
     RPMax=69
     TimeBetweenAttacks=7.000000
     Aggressiveness=0.150000
     OrderTag='
     AccelRate=1024.000000
     BaseEyeHeight=22.219999
     Buoyancy=100.000000
     RotationRate=(Pitch=4096,Yaw=60000,Roll=3072)
}
