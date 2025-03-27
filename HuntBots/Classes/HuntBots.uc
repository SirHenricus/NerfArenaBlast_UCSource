//=============================================================================
// HuntBots.
//=============================================================================
class HuntBots expands NerfBots
	abstract;

//#exec AUDIO IMPORT FILE="Sounds\Generic\land1.WAV" NAME="Land1" GROUP="Generic"
//#exec AUDIO IMPORT FILE="Sounds\Generic\lsplash.WAV" NAME="LSplash" GROUP="Generic"

var		Pawn			LastHitBy;				// who shot me last
var		float			LastHitTime;			// last time shot
var		ScorePoint		ScorePtOrder;
var		Weapon			LastWeapon;

// from RaceBots:
var     mover       tMov;
var     int         TurnCount;
var     int         TurnCounter;
var     float       Mood;
var     float       MoodThreshhold;
var     float       DamageThreshhold;
var     bool        bMoodTimer;

var		ScorePoint	DepositPoint;
var		actor		DepositPath;
var     StartGun    sg;                     // to see whether we should wait
var(AI) float		PickupSightRadius;		// used in LookForInventory()
var(AI) float		ScoreShootInterval;


struct HuntPointInfo
{
	var	byte		bIsNeeded;		// booleans in struct arrays appear not to work
	var	HuntPoint	HuntPoint;
};
var HuntPointInfo	LevelHuntPoints[20];
var int				LevelNumBalls;

function PostBeginPlay()
{
    local float     moodlevel;
    local float     damagelevel;
    local float     speedbump;

	//TraceLog(class, 10, "in PostBeginPlay()");
	SetSeekPattern();

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

function SetSeekPattern()
{
	local HuntPoint hp;
	local HuntPointInfo	hpi;
	local int i, Slot1, Slot2;

	//TraceLog(class, 10, "in SetSeekPattern()");

	//
	// build the level ball generator list
	//

	// optimization: only enum allactors upon initialization
	if (LevelNumBalls == 0)
	{
		// initialize LevelHuntPoints array
		foreach AllActors(class'HuntPoint', hp)
		{
			LevelHuntPoints[i].HuntPoint = hp;
			LevelHuntPoints[i].bIsNeeded = 1;
			i++;
		}
		LevelNumBalls = i;
	}
	else	// only reinitialize flags
		for (i = 0; i < LevelNumBalls; i++)
			LevelHuntPoints[i].bIsNeeded = 1;

	// shuffle the order
	for (i = 0; i < LevelNumBalls; i++)
	{
		// pick two random slots
		slot1 = Rand(LevelNumBalls);
		slot2 = Rand(LevelNumBalls);

		// swap them
		hpi = LevelHuntPoints[Slot2];
		LevelHuntPoints[Slot2] = LevelHuntPoints[Slot1];
		LevelHuntPoints[Slot1] = hpi;
	}
}

//
// switch to suggested weapon
// return TRUE if switch successful
// else FALSE if weapon not it inventory
//

function bool SwitchToWeapon(class <Weapon>DesiredWeapon)
{
	local float rating;
	local int usealt, favalt;
	local inventory MyFav;

	if (Inventory == None)
		return false;

    MyFav = FindInventoryType(DesiredWeapon);
    if (MyFav == None)        // not available, must find one
        return false;

	PendingWeapon = Weapon(MyFav);

	if (Weapon == None)
		ChangedWeapon();
	else if (Weapon != PendingWeapon)
		Weapon.PutDown();
    Weapon = PendingWeapon;

    return true;
}


function bool SwitchHuntGun(class<Weapon> DesiredClass )
{
    local Weapon    s;
    local bool      bResult;
	local inventory MyFav;

    bResult = true;

    if ( FindInventoryType(DesiredClass) == None )
    {
//spawn a desired weapon and attach it to bots inventory
        s = Spawn( DesiredClass,,, Location);
        if (s != None)
        {
            s.bHeldItem = true;
            s.GiveTo( self );
        }
        else bResult = false;
    }

    if ( bResult )
    {
        MyFav = FindInventoryType(DesiredClass);
        if ( MyFav == None )
            bResult = false;
        else
        {
            PendingWeapon = Weapon(MyFav);
            if (Weapon == None) ChangedWeapon();
        	else Weapon.PutDown();
            Weapon = PendingWeapon;
        }
    }
    return bResult;
}

/*
function ReplaceWeapon( pawn Player )
{
    local weapon newWeapon;

    newWeapon = Spawn(class'SShot');
    if( newWeapon != None )
    {
        newWeapon.Instigator = Player;
        newWeapon.BecomeItem();
        Player.AddInventory(newWeapon);
        newWeapon.BringUp();
        newWeapon.GiveAmmo(Player);
        newWeapon.SetSwitchPriority(Player);
        newWeapon.WeaponSet(Player);
    }
}

function bool SwitchToBestWeapon()
{
	local float rating;
	local int usealt, favalt;
	local inventory MyFav;
    local Weapon OldWeapon;

	if ( Inventory == None )
		return false;

    OldWeapon = Weapon;
//log( self$" oldweapon = "$OldWeapon );

	PendingWeapon = Inventory.RecommendWeapon(rating, usealt);
//log( self$" pendweapon = "$PendingWeapon );

	if ( PendingWeapon == None )
		return false;

//log( self$" pendweapon.isa(bg) = "$PendingWeapon.IsA('SHBallGun') );

    if ( PendingWeapon.IsA('SHBallGun') )
    {
//log( self$" looking for my SShot" );
        PendingWeapon = Weapon(FindInventoryType(class 'SShot'));
        if ( PendingWeapon == None )       // somehow lost default weapon
        {
//log( self$" replacing my LOST SShot" );
            ReplaceWeapon( self );
            return false;
        }            
    }
    else
    {
    	if ( (FavoriteWeapon != None) && (PendingWeapon.class != FavoriteWeapon) )
    	{
    		MyFav = FindInventoryType(FavoriteWeapon);
    		if ( (MyFav != None) && (Weapon(MyFav).RateSelf(favalt) + 0.22 > PendingWeapon.RateSelf(usealt)) )
    		{
    			usealt = favalt;
    			PendingWeapon = Weapon(MyFav);
    		}
    	}
    }

//log( self$" pre swapping "$Weapon$" for "$PendingWeapon );

	if ( Weapon == None )
		ChangedWeapon();
	else if ( Weapon != PendingWeapon )
		Weapon.PutDown();

//log( self$" swapping "$OldWeapon$" for "$PendingWeapon );

	return (usealt > 0);
}
*/

function WhatToDoNext(name LikelyState, optional name LikelyLabel)
{
	local float f;
	local SHBallPick bp;

//Log(self$" in WhatToDoNext(" $ LikelyState $ "," $ LikelyLabel $ ")");

	if (Health <= 0)
	{
		GotoState('Dying');			// ???
		return;
	}

	if (LikelyState == '')
		LikelyState = 'Seeking';		// default to Seeking state
	bFire = 0;
	bAltFire = 0;

	if (SHBallCount() > 0)		//FRand() * (1/Skill) * 4)
	{
		//TraceLog(class, 5, "Got SH Balls to deposit, going to Delivering state");
		GotoState('Delivering');
		return;
	}

//	Enemy = None;
	if (OldEnemy != None)
	{
		//TraceLog(class, 5, "OldEnemy = " $ OldEnemy $ ", going to Attacking state");
		Enemy = OldEnemy;
		OldEnemy = None;
		GotoState('Attacking');
		return;
	}

	f = FRand();
	switch (LikelyState)
	{
		case 'Acquisition':
			if (f < Aggressiveness)
				GotoState('Acquisition');
			else
				GotoState('Seeking');
			return;

		case 'Attacking':
            if ( bReadyToAttack )
                GotoState('Attacking');
            else
                GotoState('Seeking');
			return;

		case 'RangedAttack':
			if (f < Aggressiveness)
				GotoState('RangedAttack');
			else
				GotoState('Seeking');
			return;

		default:
			// do nothing
			break;
	}

	// any SH balls in the area?
	foreach visiblecollidingactors(class'SHBallPick', bp, 2 * PickupSightRadius)
	{
		if (bp.IsInState('PickUp'))
		{
			// hunt for them
			GotoState('Hunting');
			return;
		}
	}

//Log(self$" WhatToDoNext defaulting state to " $ LikelyState $ "," $ LikelyLabel);
	GotoState(LikelyState, LikelyLabel);
}

function Actor FindNearest(class<actor> ClassName)
{
	local float ThisDist, NearestDist;
	local Actor ThisActor, NearestActor;

	//TraceLog(class, 10, "in FindNearest(" $ ClassName.name $ ")");

	foreach AllActors(ClassName, ThisActor)
	{
		ThisDist = VSize(ThisActor.Location - Location);
		//TraceLog(class, 10, "Actor: " $ ThisActor $ " Dist = " $ ThisDist);
		if (NearestDist == 0 || ThisDist < NearestDist)
		{
			// assume it's reachable
			NearestDist = ThisDist;
			NearestActor = ThisActor;
		}
	}	
	return NearestActor;
}

function Actor LookForInventory(optional float MaxDist)
{
	local inventory Inv, BestInv, KnowPath;
	local float Bestweight, NewWeight, DroppedDist;
	local actor BestPath, HitActor;
	local vector HitNormal, HitLocation;
	local decoration Dec;
	local bool bCanReach;
	local NavigationPoint N;
	local int i;
	local Actor BestItem;

	if (MaxDist == 0.0)						// did not include optional parameter?
		MaxDist = PickupSightRadius;		// use default from property

	//TraceLog(class, 10, "in LookForInventory(" $ MaxDist $ ")");

	// look for enemy-dropped items
	if ((EnemyDropped != None) && !EnemyDropped.bDeleteMe 
		&& (EnemyDropped.Owner == None))
	{
		DroppedDist = VSize(EnemyDropped.Location - Location);
		if ((DroppedDist < MaxDist+200) && ActorReachable(EnemyDropped))
		{
			BestWeight = EnemyDropped.BotDesireability(self); 		
			if (BestWeight > 0.4)
			{
				BestItem = EnemyDropped;
				EnemyDropped = None;
				//TraceLog(class, 10, "found EnemyDrop: " $ BestItem);
				return (BestItem); 
			}
			BestInv = EnemyDropped;
			BestWeight = BestWeight/DroppedDist;
			KnowPath = BestInv;
		}	
		else
			BestWeight = 0;
	}	
	else
		BestWeight = 0;

	EnemyDropped = None;
								
	//first look at nearby inventory < MaxDist distance
	foreach visiblecollidingactors(class'Inventory', Inv, MaxDist)
	{
		if ((Inv.IsInState('PickUp')) && (Inv.MaxDesireability/50 > BestWeight)
			&& (Inv.Location.Z < Location.Z + MaxStepHeight + CollisionHeight))
		{
			NewWeight = inv.BotDesireability(self)/VSize(Inv.Location - Location);
			// log("looking at local "$Inv$" weight "$100000*NewWeight);
			if (NewWeight > BestWeight)
			{
				BestWeight = NewWeight;
				BestInv = Inv;
			}
		}
	}

	if (BestInv != None)
	{
		bCanJump = (BestInv.Location.Z > Location.Z - CollisionHeight - MaxStepHeight);
		bCanReach = ActorReachable(BestInv);
	}
	else
		bCanReach = false;
	bCanJump = true;
	if (bCanReach)
	{
		//TraceLog(class, 5, "Found best reachable inventory: " $ BestInv);
		return BestInv;
	}
	else if (KnowPath != None)
	{
		//TraceLog(class, 10, "Found KnowPath: " $ KnowPath);
		return KnowPath;
	}

	// nothing found
	//TraceLog(class, 10, "No nearby inventory found");
	return None;
}

function eAttitude AttitudeTo(Pawn Other)
{
	//TraceLog(class, 10, "in AttitudeTo(" $ Other.name $ ")");

	// give bot an attitude adjustment


    if ( Level.Game.IsA('SHTraining') )
        return ATTITUDE_Ignore;


	if (Level.Game.bTeamGame && (PlayerReplicationInfo.Team == Other.PlayerReplicationInfo.Team))
	{
		//TraceLog(class, 10,"Other is a teammate, AttitudeTo returning ATTITUDE_Friendly");
		return ATTITUDE_Friendly;	// teammate
	}

	if ((Other == LastHitBy) && (Level.TimeSeconds - LastHitTime < 5))
	{
		//TraceLog(class, 10, "bot was hit recently by pawn");
		if (aggressiveness + (FRand() * 0.25) > relativestrength(Other))
		{
			//TraceLog(class, 10, "AttitudeTo returning ATTITUDE_Hate");
			return ATTITUDE_Hate;
		}
		else
		{
			//TraceLog(class, 10, "AttitudeTo returning ATTITUDE_Hate");
			return ATTITUDE_Fear;
		}
	}

	if (FRand() < Aggressiveness)	// 0.15)		// 0.5 + 0.17 * skill???
	{
		//TraceLog(class, 10, "AttitudeTo Returning ATTITUDE_Friendly");
// 		return ATTITUDE_Friendly;
		return ATTITUDE_Hate;
	}
	else
	{
		//TraceLog(class, 10, "AttitudeTo Returning ATTITUDE_Hate");
		return ATTITUDE_Hate;
	}
}

function EnemyAcquired()
{
	//TraceLog(class, 10, "in EnemyAcquired()");

	WhatToDoNext('Acquisition');
}

/*
// AddInventory()
//
// called when bot is about to grab a game level pickup
// return true if picked up
//
function bool AddInventory(inventory NewItem)
{
	//TraceLog(class, 10, "in AddInventory(" $ NewItem.name $ ")");

	if (!Super.AddInventory(NewItem))
		return false;

	WhatToDoNext('', '');

	return true;
}
*/

function int SHBallCount()
{
	local int i, BallCount;

	BallCount = 0;
	for (i = 1; i < 8; i++)
		if (IsHoldingBall(i))
			BallCount++;

	return BallCount;
}

////////////////////////////////////////////////////////////////////////
//Base Monster AI

// DSL = mp synch
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
   foreach AllActors(class'StartGun', sg )
        break;
    if ( sg == None )               // no startgun to start us, start us anyway
    {
        bReadyToRun = true;
// log( self$" didn't see a startgun" );
        Level.Game.EquipPlayer(self);
    }
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
///////////////////////////////// SEEKING ////////////////////////////////////////
//
// Seeking generally means seeking the OrderObject while
// keeping an eye out for pickups
//
state Seeking
{
	ignores EnemyNotVisible;

	function Bump(actor Other)
	{
		local vector VelDir, OtherDir;
		local float speed;

//Log(self $ "[Seeking] in Bump(" $ Other.name $ ")");

		if (Pawn(Other) != None)
		{
			if ((Other == Enemy) || SetEnemy(Pawn(Other)))
			{
				if (FRand() < Aggressiveness)
					return;
				bReadyToAttack = true;
				GotoState('Attacking');
			}
			return;
		}
		if (TimerRate <= 0)
			setTimer(1.0, false);
		speed = VSize(Velocity);
		if (speed > 1)
		{
			VelDir = Velocity/speed;
			VelDir.Z = 0;
			OtherDir = Other.Location - Location;
			OtherDir.Z = 0;
			OtherDir = Normal(OtherDir);
			if ((VelDir Dot OtherDir) > 0.9)
			{
				Velocity.X = VelDir.Y;
				Velocity.Y = -1 * VelDir.X;
				Velocity *= FMax(speed, 200);
			}
		}
		else if (bCamping)
			GotoState('Hunting');
		Disable('Bump');
	}
	
	function HandleHelpMessageFrom(Pawn Other)
	{
		//TraceLog(class $ "[Seeking]", 10, "in HandleMessageFrom(" $ Other.name $ ")");

		if ((Health > 70) && (Weapon.AIRating > 0.5) && (Other.PlayerReplicationInfo.Team == PlayerReplicationInfo.Team)
			&& (Other.Enemy != None)
			&& (VSize(Other.Enemy.Location - Location) < 1200))
		{
			SetEnemy(Other.Enemy);
			GotoState('Attacking');
		}
	}

	function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, 
							Vector momentum, name damageType)
	{
		//TraceLog(class $ "[Seeking]", 10, "in TakeDamage(...)");

		LastHitBy = instigatedBy;
		LastHitTime = Level.TimeSeconds;
		Global.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
		if (health <= 0)
			return;

		if (NextState == 'TakeHit')
		{
			NextState = 'Attacking'; 
			NextLabel = '';
			GotoState('TakeHit'); 
		}
		else 
		{
			bReadyToAttack = true;
			GotoState('Attacking');
		}
	}

	function FearThisSpot(Actor aSpot)
	{
		//TraceLog(class $ "[Seeking]", 10, "in FearThisSpot(" $ aSpot.name $ ")");

		Destination = Location + 120 * Normal(Location - aSpot.Location); 
		GotoState('Hunting', 'Moving');
	}
	
	function Timer()
	{
		//TraceLog(class $ "[Seeking]", 10, "in Timer()");

		bReadyToAttack = True;
		Enable('Bump');
	}

	function SetFall()
	{
		//TraceLog(class $ "[Seeking]", 10, "in SetFall()");

		bWallAdjust = false;
		NextState = 'Seeking'; 
		NextLabel = 'Landed';
		NextAnim = AnimSequence;
		GotoState('FallingState'); 
	}

	function EnemyAcquired()
	{
		//TraceLog(class $ "[Seeking]", 10, "in EnemyAcquired()");

		GotoState('Acquisition');
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		//TraceLog(class $ "[Seeking]", 10, "in HitWall(...)");

		if (Physics == PHYS_Falling)
			return;
		if (Wall.IsA('Mover') && Mover(Wall).HandleDoor(self))
		{
			if (SpecialPause > 0)
				Acceleration = vect(0,0,0);
			GotoState('Seeking', 'SpecialNavig');
			return;
		}
		Focus = Destination;
		if (!bWallAdjust && PickWallAdjust())
			GotoState('Seeking', 'AdjustFromWall');
		else
		{
			MoveTimer = -1.0;
			bWallAdjust = false;
		}
	}

	function PickDestination(optional bool bNoCharge)
	{
		local int i;
		local float Dist;
		local actor MyDestination;

		//TraceLog(class $ "[Seeking]", 10, "in PickDestination()");

		// find next HuntPoint
		MyDestination = none;
		for (i = 0; i <= LevelNumBalls; i++)
			if (LevelHuntPoints[i].bIsNeeded == 1)
			{
				MyDestination = LevelHuntPoints[i].HuntPoint;
				break;
			}

		if (MyDestination == none)
		{
			//TraceLog(class $ "[Seeking]", 5, "no more HuntPoints to seek, resetting list");
			SetSeekPattern();
			return;
		}

		//TraceLog(class $ "[Seeking]", 5, "seeking HuntPoint#" $ i $ ": " $ MyDestination.Name);

		if (ActorReachable(MyDestination))
		{
			Dist = VSize(MyDestination.Location - Location);
			if (Dist < 200)
			{
				// arrived!!!
				//TraceLog(class $ "[Seeking]", 5, "arrived at destination!  Dist = " $ Dist);
				LevelHuntPoints[i].bIsNeeded = 0;
				GotoState('Hunting');
				return;
			}

			//TraceLog(class $ "[Seeking]", 5, "ActorReachable, but not close enough yet.  Dist = " $ Dist);
			MoveTarget = MyDestination;
			return;
		}

		//TraceLog(class $ "[Seeking]", 5, "HuntPoint not directly reachable");

		MoveTarget = FindPathToward(MyDestination);

		if (MoveTarget == none)
		{
			// uhoh!
			// try somewhere else
			//TraceLog(class $ "[Seeking]", 5, "no path toward" $ LevelHuntPoints[i].HuntPoint);
			//LevelHuntPoints[i].bIsNeeded = 0;		// avoid this spot to avoid infinite loops...
			//GotoState('Seeking', 'Begin');
			GotoState('Lost');						// admit it, we're lost...
		}
		else
			;//TraceLog(class $ "[Seeking]", 5, "setting MoveTarget (PathToward) to " $ MoveTarget);
	}


	function AnimEnd() 
	{
		//TraceLog(class $ "[Seeking]", 10, "in AnimEnd()");

		if (bCamping)
			PlayWaiting();
		else
			PlayRunning();
	}

	function ShareWithTeam()
	{
		local bool bHaveItem, bIsHealth, bOtherHas;
		local Inventory goalItem;
		local Pawn P;

		//TraceLog(class $ "[Seeking]", 10, "in ShareWithTeam()");

		goalItem = InventorySpot(MoveTarget).markedItem;
		if (goalItem == None) // FIXME REMOVE
		{
//			log(" No marked item for "$MoveTarget);
			return;
		}

		if (goalItem.IsA('Weapon'))
		{
			if ((Weapon == None) || (Weapon.AIRating < 0.45))
				return;
			bHaveItem = (FindInventoryType(goalItem.class) != None);
		}
		else if (goalItem.IsA('Health'))
		{
			bIsHealth = true;
			if (Health < 60)
				return;
		}
		else 
			return;

		CampTime = 2.0;

		for (P=Level.PawnList; P!=None; P=P.nextPawn)
			if (P.bIsPlayer && (P.PlayerReplicationInfo.Team == PlayerReplicationInfo.Team)
				&& ((P.MoveTarget == MoveTarget) || (P.MoveTarget == goalItem) 
					|| (!bIsHealth && P.IsA('PlayerPawn') && !P.IsA('Spectator') 
						&& (VSize(P.Location - Location) < 1250) && LineOfSightTo(P))))
			{
				//decide who needs it more
				if (bIsHealth)
				{
					if (Health > P.Health + 10)
					{
						WhatToDoNext('Seeking','GiveAway');
						return;
					}
					else if ((P.IsInState('Seeking')) && (Health < P.Health - 10))
						P.GotoState('Seeking', 'GiveWay');
				}
				else
				{
					bOtherHas = (P.FindInventoryType(goalItem.class) != None);
					if (!bHaveItem && bOtherHas)
					{
						if (P.IsInState('Seeking'))
							P.GotoState('Seeking', 'GiveWay');	
					}					
					else if (bHaveItem && !bOtherHas)
					{
						GotoState('Seeking', 'GiveWay');
						return;
					}
				}
			}
	}
						 
	function BeginState()
	{
		//TraceLog(class $ "[Seeking]", 10, "in BeginState()");

//        SwitchToBestWeapon();
		bNoShootDecor = false;
		bCanFire = false;
		bCamping = false;
		if (bNoClearSpecial)
			bNoClearSpecial = false;
		else
		{
			bSpecialPausing = false;
			bSpecialGoal = false;
			SpecialGoal = None;
			SpecialPause = 0.0;
		}
	}

	function EndState()
	{
		//TraceLog(class $ "[Seeking]", 10, "in EndState()");

		if (AmbushSpot != None)
		{
			AmbushSpot.taken = false;
			if (Enemy != None)
				AmbushSpot = None;
		}
		bCamping = false;
		bWallAdjust = false;
	}

LongCamp:
	//TraceLog(class $ "[Seeking]", 10, "at LongCamp:");

	bCamping = true;
	Acceleration = vect(0,0,0);
	TweenToWaiting(0.15);
	if (OrderObject.IsA('AmbushPoint'))
		TurnTo(Location + (Ambushpoint(OrderObject)).lookdir);
	Sleep(CampTime);
	Goto('Begin');

GiveWay:	
	//TraceLog(class $ "[Seeking]", 10, "at GiveAway:");
	bCamping = true;
	Acceleration = vect(0,0,0);
	TweenToWaiting(0.15);
	if (NearWall(200))
	{
		PlayTurning();
		TurnTo(MoveTarget.Location);
	}
	Sleep(CampTime);
	Goto('Begin');

Camp:
	//TraceLog(class $ "[Seeking]", 10, "at Camp:");
	bCamping = true;
	Acceleration = vect(0,0,0);
	TweenToWaiting(0.15);
ReCamp:
	//TraceLog(class $ "[Seeking]", 10, "at ReCamp:");
	if (NearWall(200))
	{
		PlayTurning();
		TurnTo(Focus);
	}
	Sleep(CampTime);
	if ((Weapon != None) && (Weapon.AIRating > 0.4) && (3 * FRand() > skill + 1))
		Goto('ReCamp');
Begin:
	//TraceLog(class $ "[Seeking]", 10, "at Begin:");
//    SwitchToBestWeapon();
	bCamping = false;
	TweenToRunning(0.1);
	WaitForLanding();
	
RunAway:
	//TraceLog(class $ "[Seeking]", 10, "at RunAway:");
	if (LookForInventory() != None)
	{
		//TraceLog(class $ "[Seeking]", 10, "Inventory nearby, going to Hunting state");
		GotoState('Hunting');
	}
	PickDestination();
	Sleep(0.001);

// DSL -- label not found error fix 
// (supplying label, but no associated code)
SpecialNavig:

Moving:
	//TraceLog(class $ "[Seeking]", 10, "at Moving:");
	//TraceLog(class $ "[Seeking]", 5, "MoveTarget = " $ MoveTarget);

	if (!IsAnimating())
		AnimEnd();
	if (MoveTarget == None)
	{
		Acceleration = vect(0,0,0);
		Sleep(0.0);
		Goto('RunAway');
	}
	if (MoveTarget.IsA('InventorySpot')) 
	{
		if (Level.Game.bTeamGame)
			ShareWithTeam();
		if (InventorySpot(MoveTarget).markedItem.BotDesireability(self) > 0)
		{
			if (InventorySpot(MoveTarget).markedItem.GetStateName() == 'Pickup')
				MoveTarget = InventorySpot(MoveTarget).markedItem;
			else if (VSize(Location - MoveTarget.Location) < CollisionRadius)
			{
				CampTime = 3.5 + FRand() - skill;
				Goto('Camp');
			}
		}
	}
	bCamping = false;
    PlayRunning();
	MoveToward(MoveTarget);
	Goto('RunAway');

TakeHit:
	//TraceLog(class $ "[Seeking]", 10, "at TakeHit:");
	TweenToRunning(0.12);
	Goto('Moving');

Landed:
	//TraceLog(class $ "[Seeking]", 10, "at Landed:");
	if (MoveTarget == None) //FIXME - do this in all landed: !!!
		Goto('RunAway');
	Goto('Moving');

AdjustFromWall:
	//TraceLog(class $ "[Seeking]", 10, " at AdjustFromWall:");
	bWallAdjust = true;
	bCamping = false;
	StrafeTo(Destination, Focus); 
	Destination = Focus; 
    PlayRunning();
	MoveTo(Destination);
	bWallAdjust = false;
	Goto('Moving');

ShootDecoration:
	//TraceLog(class $ "[Seeking]", 10, "at ShootDecoration:");
	TurnToward(Target);
	if (Target != None)
	{
		FireWeapon();
		bAltFire = 0;
		bFire = 0;
	}
	Goto('RunAway');
}

///////////////////////////////// HUNTING ////////////////////////////////////////
//
// Hunting is milling around an area looking for pickups
//
state Hunting
{
	ignores EnemyNotVisible;

	function Bump(actor Other)
	{
		local vector VelDir, OtherDir;
		local float speed;

		//TraceLog(class $ "[Hunting]", 10, "in Bump(" $ Other.name $ ")");

		if (Pawn(Other) != None)
		{
			if ((Other == Enemy) || SetEnemy(Pawn(Other)))
			{
				if (FRand() < Aggressiveness)
					return;
				bReadyToAttack = true;
				WhatToDoNext('Attacking');
			}
			return;
		}
//		if (TimerRate <= 0)
//			setTimer(1.0, false);
		speed = VSize(Velocity);
		if (speed > 1)
		{
			VelDir = Velocity/speed;
			VelDir.Z = 0;
			OtherDir = Other.Location - Location;
			OtherDir.Z = 0;
			OtherDir = Normal(OtherDir);
			if ((VelDir Dot OtherDir) > 0.9)
			{
				Velocity.X = VelDir.Y;
				Velocity.Y = -1 * VelDir.X;
				Velocity *= FMax(speed, 200);
			}
		}
		else if (bCamping)
			GotoState('Hunting');
		Disable('Bump');
	}
	
	function HandleHelpMessageFrom(Pawn Other)
	{
		//TraceLog(class $ "[Hunting]", 10, "in HandleMessageFrom(" $ Other.name $ ")");

		if ((Health > 70) && (Weapon.AIRating > 0.5) && (Other.PlayerReplicationInfo.Team == PlayerReplicationInfo.Team)
			&& (Other.Enemy != None)
			&& (VSize(Other.Enemy.Location - Location) < 1200))
		{
			SetEnemy(Other.Enemy);
			WhatToDoNExt('Attacking');
		}
	}

	function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, 
							Vector momentum, name damageType)
	{
		//TraceLog(class $ "[Hunting]", 10, "in TakeDamage(...)");

		LastHitBy = instigatedBy;
		LastHitTime = Level.TimeSeconds;
		Global.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
		if (health <= 0)
			return;

		if (NextState == 'TakeHit')
		{
			NextState = 'Attacking'; 
			NextLabel = '';
			GotoState('TakeHit'); 
		}
		else 
		{
			bReadyToAttack = true;
			WhatToDoNext('Attacking');
		}
	}

	function FearThisSpot(Actor aSpot)
	{
		//TraceLog(class $ "[Hunting]", 10, "in FearThisSpot(" $ aSpot.name $ ")");

		Destination = Location + 120 * Normal(Location - aSpot.Location); 
		WhatToDoNext('Hunting', 'Moving');
	}
	
	function Timer()
	{
		local int i;

		//TraceLog(class $ "[Hunting]", 10, "in Timer()");

		bReadyToAttack = True;
		Enable('Bump');

		// timed out
		//TraceLog(class $ "[Hunting]", 10, "Timed out in Hunting state; seeking next HuntPoint");

		// mark this huntpoint off the list
		// FIXME - make an currentball index instead of always searching for next
		for (i = 0; i <= LevelNumBalls; i++)
			if (LevelHuntPoints[i].bIsNeeded == 1)
				break;
		
		LevelHuntPoints[i].bIsNeeded = 0;
		GotoState('Seeking');
	}

	function SetFall()
	{
		//TraceLog(class $ "[Hunting]", 10, "in SetFall()");

		bWallAdjust = false;
		NextState = 'Hunting'; 
		NextLabel = 'Landed';
		NextAnim = AnimSequence;
		GotoState('FallingState'); 
	}

	function EnemyAcquired()
	{
		//TraceLog(class $ "[Hunting]", 10, "in EnemyAcquired()");

		WhatToDoNext('Acquisition');
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		//TraceLog(class $ "[Hunting]", 10, "in HitWall(...)");

		if (Physics == PHYS_Falling)
			return;
		if (Wall.IsA('Mover') && Mover(Wall).HandleDoor(self))
		{
			if (SpecialPause > 0)
				Acceleration = vect(0,0,0);
			GotoState('Hunting', 'SpecialNavig');
			return;
		}
		Focus = Destination;
		if (!bWallAdjust && PickWallAdjust())
			GotoState('Hunting', 'AdjustFromWall');
		else
		{
			MoveTimer = -1.0;
			bWallAdjust = false;
		}
	}

	function PickDestination(optional bool bNoCharge)
	{
		local inventory Inv, BestInv, KnowPath;
		local SHBallPick Ball, BestBall;
		local float Bestweight, NewWeight, DroppedDist;
		local actor BestPath, HitActor;
		local vector HitNormal, HitLocation;
		local decoration Dec;
		local bool bCanReach;
		local NavigationPoint N;
		local int i;
		local Actor BallGen;

		//TraceLog(class $ "[Hunting]", 10, "in PickDestination()");

		// first look for nearby SHBallPick-derived objects
		foreach visiblecollidingactors(class'SHBallPick', Ball, 2 * PickupSightRadius)
		{
			if (Ball.IsInState('PickUp'))
			{
				NewWeight = Ball.BotDesireability(self) / VSize(Ball.Location - Location);
				// log("looking at local "$Ball$" weight "$100000*NewWeight);
				if (NewWeight > BestWeight)
				{
					BestWeight = NewWeight;
					BestBall = Ball;
				}
			}
		}

		if (BestBall != None)
		{
			bCanJump = (BestBall.Location.Z > Location.Z - CollisionHeight - MaxStepHeight);
			bCanReach = ActorReachable(BestBall);
		}
		else
			bCanReach = false;
		bCanJump = true;
		if (bCanReach)
		{
			//TraceLog(class $ "[Hunting]", 5, "Found best ball: " $ BestBall);
			MoveTarget = BestBall;
			return;
		}

		//TraceLog(class $ "[Hunting]", 5, "No SHBalls found nearby; looking for other inventory...");

		// look at nearby inventory < PickupSightRadius dist
		foreach visiblecollidingactors(class'Inventory', Inv, PickupSightRadius)
		{
			if ((Inv.IsInState('PickUp')) && (Inv.MaxDesireability/50 > BestWeight)
				&& (Inv.Location.Z < Location.Z + MaxStepHeight + CollisionHeight))
			{
				NewWeight = inv.BotDesireability(self)/VSize(Inv.Location - Location);
				// log("looking at local "$Inv$" weight "$100000*NewWeight);
				if (NewWeight > BestWeight)
				{
					BestWeight = NewWeight;
					BestInv = Inv;
				}
			}
		}

		if (BestInv != None)
		{
			bCanJump = (BestInv.Location.Z > Location.Z - CollisionHeight - MaxStepHeight);
			bCanReach = ActorReachable(BestInv);
		}
		else
			bCanReach = false;
		bCanJump = true;
		if (bCanReach)
		{
			//TraceLog(class $ "[Hunting]", 5, "Found best inventory:  " $ BestInv);
			MoveTarget = BestInv;
			return;
		}
		else if (KnowPath != None)
		{
			MoveTarget = KnowPath;
			return;
		}

		if ((Weapon != none) && (Weapon.AIRating > 0.5) && (Health > 90))
		{			
			bWantsToCamp = (bWantsToCamp || (FRand() < CampingRate * FMin(1.0, Level.TimeSeconds - LastCampCheck)));
			LastCampCheck = Level.TimeSeconds;
		}
		else 
			bWantsToCamp = false;

		if (bWantsToCamp && FindAmbushSpot())
			return;

		// if none found, check for decorations with inventory
		if (!bNoShootDecor)
			foreach visiblecollidingactors(class'Decoration', Dec, PickupSightRadius)
				if (Dec.Contents != None)
				{
					bNoShootDecor = true;
					Target = Dec;
					GotoState('Hunting', 'ShootDecoration');
					return;
				}

		bNoShootDecor = false;
		BestWeight = 0;

		// look for long distance inventory 
		BestPath = FindBestInventoryPath(BestWeight, (skill >= 2));
		if (BestPath != None)
		{
			MoveTarget = BestPath;
			return;
		}

		// do we have SH Balls to deposit?
		if (SHBallCount() > 0)
		{
			GotoState('Delivering');		// might as well as score now...
			return;
		}

		 // if nothing to do, then wander or camp
		if (FRand() > 0.35)
			return;		// just keep wandering
		else
		{
			CampTime = 3.5 + FRand() - skill;
			WhatToDoNext('Hunting', 'Camp');
		}
	}

	function bool FindAmbushSpot()
	{
		//TraceLog(class $ "[Hunting]", 10, "in FindAmbushSpot()");

		if ((AmbushSpot == None) && (Ambushpoint(MoveTarget) != None))
			AmbushSpot = Ambushpoint(MoveTarget);

		if (Ambushspot != None)
		{
			Ambushspot.taken = true;
			if (VSize(Ambushspot.Location - Location) < 2 * CollisionRadius)
			{	
				CampTime = 10.0;
				WhatToDoNext('Hunting', 'LongCamp');
				return true;
			}
			if (ActorReachable(Ambushspot))
			{
				MoveTarget = Ambushspot;
				return true;
			}
			MoveTarget = FindPathToward(Ambushspot);
			if (MoveTarget != None)
				return true;
			Ambushspot.taken = false;
			Ambushspot = None;
		}
		return false;
	}		

	function AnimEnd() 
	{
		//TraceLog(class $ "[Hunting]", 10, "in AnimEnd()");

		if (bCamping)
			PlayWaiting();
		else
			PlayRunning();
	}

	function ShareWithTeam()
	{
		local bool bHaveItem, bIsHealth, bOtherHas;
		local Inventory goalItem;
		local Pawn P;

		//TraceLog(class $ "[Hunting]", 10, "in ShareWithTeam()");

		goalItem = InventorySpot(MoveTarget).markedItem;
		if (goalItem == None) // FIXME REMOVE
		{
//			log(" No marked item for "$MoveTarget);
			return;
		}

		if (goalItem.IsA('Weapon'))
		{
			if ((Weapon == None) || (Weapon.AIRating < 0.45))
				return;
			bHaveItem = (FindInventoryType(goalItem.class) != None);
		}
		else if (goalItem.IsA('Health'))
		{
			bIsHealth = true;
			if (Health < 60)
				return;
		}
		else 
			return;

		CampTime = 2.0;

		for (P=Level.PawnList; P!=None; P=P.nextPawn)
			if (P.bIsPlayer && (P.PlayerReplicationInfo.Team == PlayerReplicationInfo.Team)
				&& ((P.MoveTarget == MoveTarget) || (P.MoveTarget == goalItem) 
					|| (!bIsHealth && P.IsA('PlayerPawn') && !P.IsA('Spectator') 
						&& (VSize(P.Location - Location) < 1250) && LineOfSightTo(P))))
			{
				//decide who needs it more
				if (bIsHealth)
				{
					if (Health > P.Health + 10)
					{
						WhatToDoNext('Hunting','GiveAway');
						return;
					}
					else if ((P.IsInState('Hunting')) && (Health < P.Health - 10))
						P.GotoState('Hunting', 'GiveWay');
				}
				else
				{
					bOtherHas = (P.FindInventoryType(goalItem.class) != None);
					if (!bHaveItem && bOtherHas)
					{
						if (P.IsInState('Hunting'))
							P.GotoState('Hunting', 'GiveWay');	
					}					
					else if (bHaveItem && !bOtherHas)
					{
						GotoState('Hunting', 'GiveWay');
						return;
					}
				}
			}
	}
						 
	function BeginState()
	{
		//TraceLog(class $ "[Hunting]", 10, "in BeginState()");

		bNoShootDecor = false;
		bCanFire = false;
		bCamping = false;
		if (bNoClearSpecial)
			bNoClearSpecial = false;
		else
		{
			bSpecialPausing = false;
			bSpecialGoal = false;
			SpecialGoal = None;
			SpecialPause = 0.0;
		}
		SetTimer(15.0, False);			// set the hunting state timeout
	}

	function EndState()
	{
		//TraceLog(class $ "[Hunting]", 10, "in EndState()");

		if (AmbushSpot != None)
		{
			AmbushSpot.taken = false;
			if (Enemy != None)
				AmbushSpot = None;
		}
		bCamping = false;
		bWallAdjust = false;
	}

LongCamp:
	//TraceLog(class $ "[Hunting]", 10, "at LongCamp:");

	bCamping = true;
	Acceleration = vect(0,0,0);
	TweenToWaiting(0.15);
	if (OrderObject.IsA('AmbushPoint'))
		TurnTo(Location + (Ambushpoint(OrderObject)).lookdir);
	Sleep(CampTime);
	Goto('Begin');

GiveWay:	
	//TraceLog(class $ "[Hunting]", 10, "at GiveAway:");
	bCamping = true;
	Acceleration = vect(0,0,0);
	TweenToWaiting(0.15);
	if (NearWall(200))
	{
		PlayTurning();
		TurnTo(MoveTarget.Location);
	}
	Sleep(CampTime);
	Goto('Begin');

Camp:
	//TraceLog(class $ "[Hunting]", 10, "at Camp:");
	bCamping = true;
	Acceleration = vect(0,0,0);
	TweenToWaiting(0.15);
ReCamp:
	//TraceLog(class $ "[Hunting]", 10, "at ReCamp:");
	if (NearWall(200))
	{
		PlayTurning();
		TurnTo(Focus);
	}
	Sleep(CampTime);
	if ((Weapon != None) && (Weapon.AIRating > 0.4) && (3 * FRand() > skill + 1))
		Goto('ReCamp');
Begin:
	//TraceLog(class $ "[Hunting]", 10, "at Begin:");
	bCamping = false;
	TweenToRunning(0.1);
	WaitForLanding();
	
RunAway:
	//TraceLog(class $ "[Hunting]", 10, "at RunAway:");
	PickDestination();

// DSL -- label not found error fix 
// (supplying label, but no associated code)
SpecialNavig:

Moving:
	//TraceLog(class $ "[Hunting]", 10, "at Moving:");
	//TraceLog(class $ "[Hunting]", 5, "MoveTarget = " $ MoveTarget);

	if (!IsAnimating())
        PlayRunning();
	if (MoveTarget == None)
	{
		Acceleration = vect(0,0,0);
		Sleep(0.0);
		Goto('RunAway');
	}
	if (MoveTarget.IsA('InventorySpot')) 
	{
		if (Level.Game.bTeamGame)
			ShareWithTeam();
		if (InventorySpot(MoveTarget).markedItem.BotDesireability(self) > 0)
		{
			if (InventorySpot(MoveTarget).markedItem.GetStateName() == 'Pickup')
				MoveTarget = InventorySpot(MoveTarget).markedItem;
			else if (VSize(Location - MoveTarget.Location) < CollisionRadius)
			{
				CampTime = 3.5 + FRand() - skill;
				Goto('Camp');
			}
		}
	}
	bCamping = false;
    PlayRunning();
	MoveToward(MoveTarget);
	Goto('RunAway');

TakeHit:
	//TraceLog(class $ "[Hunting]", 10, "at TakeHit:");
	TweenToRunning(0.12);
	Goto('Moving');

Landed:
	//TraceLog(class $ "[Hunting]", 10, "at Landed:");
	if (MoveTarget == None) //FIXME - do this in all landed: !!!
		Goto('RunAway');
	Goto('Moving');

AdjustFromWall:
	//TraceLog(class $ "[Hunting]", 10, "at AdjustFromWall:");
	bWallAdjust = true;
	bCamping = false;
	StrafeTo(Destination, Focus); 
	Destination = Focus; 
    PlayRunning();
	MoveTo(Destination);
	bWallAdjust = false;
	Goto('Moving');

ShootDecoration:
	//TraceLog(class $ "[Hunting]", 10, "at ShootDecoration:");
	TurnToward(Target);
	if (Target != None)
	{
		FireWeapon();
		bAltFire = 0;
		bFire = 0;
	}
	Goto('RunAway');
}
	

////////////////////////////////// DELIVERING ////////////////////////////////////////
//
// Bot has collected some inventory items (SH balls) and wants to
// deliver them in a recepticle.

state Delivering
{
	ignores EnemyNotVisible;

	function Bump(actor Other)
	{
		local vector VelDir, OtherDir;
		local float speed;

		//TraceLog(class $ "[Delivering]", 10, "in Bump(" $ Other.name $ ")");

		if (Pawn(Other) != None)
		{
			if ((Other == Enemy) || SetEnemy(Pawn(Other)))
			{
				if (FRand() < Aggressiveness)
					return;
				bReadyToAttack = true;
				WhatToDoNext('Attacking');
			}
			return;
		}
		if (TimerRate <= 0)
			setTimer(1.0, false);
		speed = VSize(Velocity);
		if (speed > 1)
		{
			VelDir = Velocity/speed;
			VelDir.Z = 0;
			OtherDir = Other.Location - Location;
			OtherDir.Z = 0;
			OtherDir = Normal(OtherDir);
			if ((VelDir Dot OtherDir) > 0.9)
			{
				Velocity.X = VelDir.Y;
				Velocity.Y = -1 * VelDir.X;
				Velocity *= FMax(speed, 200);
			}
		}
		else if (bCamping)
			GotoState('Hunting');
		Disable('Bump');
	}
	
	function HandleHelpMessageFrom(Pawn Other)
	{
		//TraceLog(class $ "[Delivering]", 10, "in HandleMessageFrom(" $ Other.name $ ")");

		if ((Health > 70) && (Weapon.AIRating > 0.5) && (Other.PlayerReplicationInfo.Team == PlayerReplicationInfo.Team)
			&& (Other.Enemy != None)
			&& (VSize(Other.Enemy.Location - Location) < 1200))
		{
			SetEnemy(Other.Enemy);
			WhatToDoNExt('Attacking');
		}
	}

	function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, 
							Vector momentum, name damageType)
	{
		//TraceLog(class $ "[Delivering]", 10, "in TakeDamage(...)");

		LastHitBy = instigatedBy;
		LastHitTime = Level.TimeSeconds;
		Global.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
		if (health <= 0)
			return;

		if (NextState == 'TakeHit')
		{
			NextState = 'Attacking';
			NextLabel = '';
			GotoState('TakeHit'); 
		}
		else 
		{
			bReadyToAttack = true;
			WhatToDoNext('Attacking');
		}
	}

	function FearThisSpot(Actor aSpot)
	{
		//TraceLog(class $ "[Delivering]", 10, "in FearThisSpot(" $ aSpot.name $ ")");

		Destination = Location + 120 * Normal(Location - aSpot.Location); 
		WhatToDoNext('Hunting', 'Moving');
	}
	
	function Timer()
	{
		//TraceLog(class $ "[Delivering]", 10, "in Timer()");

		bReadyToAttack = True;
		Enable('Bump');
	}

	function SetFall()
	{
		//TraceLog(class $ "[Delivering]", 10, "in SetFall()");

		bWallAdjust = false;
		NextState = 'Delivering'; 
		NextLabel = 'Landed';
		NextAnim = AnimSequence;
		GotoState('FallingState'); 
	}

	function EnemyAcquired()
	{
		//TraceLog(class $ "[Delivering]", 10, "in EnemyAcquired()");

		WhatToDoNext('Acquisition');
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		//TraceLog(class $ "[Delivering]", 10, "in HitWall(...)");

		if (Physics == PHYS_Falling)
			return;
		if (Wall.IsA('Mover') && Mover(Wall).HandleDoor(self))
		{
			if (SpecialPause > 0)
				Acceleration = vect(0,0,0);
			GotoState('Delivering', 'SpecialNavig');
			return;
		}
		Focus = Destination;
		if (!bWallAdjust && PickWallAdjust())
			GotoState('Delivering', 'AdjustFromWall');
		else
		{
			MoveTimer = -1.0;
			bWallAdjust = false;
		}
	}

	function PickDestination(optional bool bNoCharge)
	{
		local float Dist;

		//TraceLog(class $ "[Delivering]", 10, "in PickDestination()");

		Dist = VSize(Location - OrderObject.Location);
		//TraceLog(class $ "[Delivering]", 5, "Distance to " $ OrderObject.name $ " is " $ Dist);

		if (Dist < 200)
		{
			//TraceLog(class $ "[Delivering]", 5, "arrived at destination! distance = " $ Dist);	
//			MoveTarget = OrderObject;
			GotoState('Scoring');
			return;
		}
		else if (ActorReachable(OrderObject))
		{
			//TraceLog(class $ "[Delivering]", 5, "OrderObject is reachable, but not close");	
			MoveTarget = OrderObject;
		}
		else
		{
			//TraceLog(class $ "[Delivering]", 5, "OrderObject is NOT directly reachable");	
			MoveTarget = FindPathToward(OrderObject);
			if (MoveTarget == None)
			{
				// this generally shouldent happen often; all HuntPoints and ScorePoints
				// should be on the main navigation network
				//TraceLog(class $ "[Delivering]", 5, "Cannot reach " $ OrderObject);	
				//MoveTarget = OrderObject;
				GotoState('Lost');						// admit it, we're lost...
				return;
			}
			GotoState('Delivering', 'Moving');
		}
	}

	function AnimEnd() 
	{
		//TraceLog(class $ "[Delivering]", 10, "in AnimEnd()");

		if (bCamping)
			PlayWaiting();
		else
			PlayRunning();
	}

	function ShareWithTeam()
	{
		local bool bHaveItem, bIsHealth, bOtherHas;
		local Inventory goalItem;
		local Pawn P;

		//TraceLog(class $ "[Delivering]", 10, "in ShareWithTeam()");

		goalItem = InventorySpot(MoveTarget).markedItem;
		if (goalItem == None) // FIXME REMOVE
		{
//			log(" No marked item for "$MoveTarget);
			return;
		}

		if (goalItem.IsA('Weapon'))
		{
			if ((Weapon == None) || (Weapon.AIRating < 0.45))
				return;
			bHaveItem = (FindInventoryType(goalItem.class) != None);
		}
		else if (goalItem.IsA('Health'))
		{
			bIsHealth = true;
			if (Health < 60)
				return;
		}
		else 
			return;

		CampTime = 2.0;

		for (P=Level.PawnList; P!=None; P=P.nextPawn)
			if (P.bIsPlayer && (P.PlayerReplicationInfo.Team == PlayerReplicationInfo.Team)
				&& ((P.MoveTarget == MoveTarget) || (P.MoveTarget == goalItem) 
					|| (!bIsHealth && P.IsA('PlayerPawn') && !P.IsA('Spectator') 
						&& (VSize(P.Location - Location) < 1250) && LineOfSightTo(P))))
			{
				//decide who needs it more
				if (bIsHealth)
				{
					if (Health > P.Health + 10)
					{
						WhatToDoNext('Delivering','GiveAway');
						return;
					}
					else if ((P.IsInState('Delivering')) && (Health < P.Health - 10))
						P.GotoState('Delivering', 'GiveWay');
				}
				else
				{
					bOtherHas = (P.FindInventoryType(goalItem.class) != None);
					if (!bHaveItem && bOtherHas)
					{
						if (P.IsInState('Delivering'))
							P.GotoState('Delivering', 'GiveWay');	
					}					
					else if (bHaveItem && !bOtherHas)
					{
						GotoState('Delivering', 'GiveWay');
						return;
					}
				}
			}
	}
						 
	function BeginState()
	{
		//TraceLog(class $ "[Delivering]", 10, "in BeginState()");

		bNoShootDecor = false;
		bCanFire = false;
		bCamping = false;
		if (bNoClearSpecial)
			bNoClearSpecial = false;
		else
		{
			bSpecialPausing = false;
			bSpecialGoal = false;
			SpecialGoal = None;
			SpecialPause = 0.0;
		}
	}

	function EndState()
	{
		//TraceLog(class $ "[Delivering]", 10, "in EndState()");

		if (AmbushSpot != None)
		{
			AmbushSpot.taken = false;
			if (Enemy != None)
				AmbushSpot = None;
		}
		bCamping = false;
		bWallAdjust = false;
	}

GiveWay:	
	//TraceLog(class $ "[Delivering]", 10, "at GiveAway:");
	bCamping = true;
	Acceleration = vect(0,0,0);
	TweenToWaiting(0.15);
	if (NearWall(200))
	{
		PlayTurning();
		TurnTo(MoveTarget.Location);
	}
	Sleep(CampTime);
	Goto('Begin');

Camp:
	//TraceLog(class $ "[Delivering]", 10, "at Camp:");
	bCamping = true;
	Acceleration = vect(0,0,0);
	TweenToWaiting(0.15);
ReCamp:
	//TraceLog(class $ "[Delivering]", 10, "at ReCamp:");
	if (NearWall(200))
	{
		PlayTurning();
		TurnTo(Focus);
	}
	Sleep(CampTime);
	if ((Weapon != None) && (Weapon.AIRating > 0.4) && (3 * FRand() > skill + 1))
		Goto('ReCamp');
Begin:
	//TraceLog(class $ "[Delivering]", 10, "at Begin:");
	bCamping = false;

	OrderObject = FindNearest(class'ScorePoint');

	//TraceLog(class $ "[Delivering]", 5, "setting OrderObject to " $ OrderObject.name);

	TweenToRunning(0.1);
	WaitForLanding();
	
RunAway:
	//TraceLog(class $ "[Delivering]", 10, "at RunAway:");
	if (LookForInventory() != None)
	{
		//TraceLog(class $ "[Delivering]", 10, "Inventory nearby, going to Hunting state");
		GotoState('Hunting');
	}
	PickDestination();

// DSL -- label not found error fix 
// (supplying label, but no associated code)
SpecialNavig:

Moving:
	//TraceLog(class $ "[Delivering]", 10, "at Moving:");
	//TraceLog(class $ "[Delivering]", 5, "MoveTarget = " $ MoveTarget);

	if (!IsAnimating())
		AnimEnd();
	if (MoveTarget == None)
	{
		Acceleration = vect(0,0,0);
		Sleep(0.0);
		Goto('RunAway');
	}
	if (MoveTarget.IsA('InventorySpot')) 
	{
		if (Level.Game.bTeamGame)
			ShareWithTeam();
		if (InventorySpot(MoveTarget).markedItem.BotDesireability(self) > 0)
		{
			if (InventorySpot(MoveTarget).markedItem.GetStateName() == 'Pickup')
				MoveTarget = InventorySpot(MoveTarget).markedItem;
			else if (VSize(Location - MoveTarget.Location) < CollisionRadius)
			{
				CampTime = 3.5 + FRand() - skill;
				Goto('Camp');
			}
		}
	}
	bCamping = false;
    PlayRunning();
	MoveToward(MoveTarget);
	Goto('RunAway');

TakeHit:
	//TraceLog(class $ "[Delivering]", 10, "at TakeHit:");
	TweenToRunning(0.12);
	Goto('Moving');

Landed:
	//TraceLog(class $ "[Delivering]", 10, "at Landed:");
	if (MoveTarget == None) //FIXME - do this in all landed: !!!
		Goto('RunAway');
	Goto('Moving');

AdjustFromWall:
	//TraceLog(class $ "[Delivering]", 10, "at AdjustFromWall:");
	bWallAdjust = true;
	bCamping = false;
	StrafeTo(Destination, Focus); 
	Destination = Focus; 
    PlayRunning();
	MoveTo(Destination);
	bWallAdjust = false;
	Goto('Moving');

ShootDecoration:
	//TraceLog(class $ "[Delivering]", 10, "at ShootDecoration:");
	TurnToward(Target);
	if (Target != None)
	{
		FireWeapon();
		bAltFire = 0;
		bFire = 0;
	}
	Goto('RunAway');
}

////////////////////////////////// SCORING ////////////////////////////////////////
//
// Bot has reached a HuntPoint and needs to follow it's advice
//

state Scoring
{
	ignores EnemyNotVisible;

	function Bump(actor Other)
	{
		local vector VelDir, OtherDir;
		local float speed;

		//TraceLog(class $ "[Scoring]", 10, "in Bump(" $ Other.name $ ")");

		if (Pawn(Other) != None)
		{
			if ((Other == Enemy) || SetEnemy(Pawn(Other)))
			{
				if (FRand() < Aggressiveness)
					return;
				bReadyToAttack = true;
				WhatToDoNext('Attacking');
			}
			return;
		}
		if (TimerRate <= 0)
			setTimer(1.0, false);
		speed = VSize(Velocity);
		if (speed > 1)
		{
			VelDir = Velocity/speed;
			VelDir.Z = 0;
			OtherDir = Other.Location - Location;
			OtherDir.Z = 0;
			OtherDir = Normal(OtherDir);
			if ((VelDir Dot OtherDir) > 0.9)
			{
				Velocity.X = VelDir.Y;
				Velocity.Y = -1 * VelDir.X;
				Velocity *= FMax(speed, 200);
			}
		}
		else if (bCamping)
			GotoState('Hunting');
		Disable('Bump');
	}
	
	function HandleHelpMessageFrom(Pawn Other)
	{
		//TraceLog(class $ "[Scoring]", 10, "in HandleMessageFrom(" $ Other.name $ ")");

		if ((Health > 70) && (Weapon.AIRating > 0.5) && (Other.PlayerReplicationInfo.Team == PlayerReplicationInfo.Team)
			&& (Other.Enemy != None)
			&& (VSize(Other.Enemy.Location - Location) < 1200))
		{
			SetEnemy(Other.Enemy);
			WhatToDoNExt('Attacking');
		}
	}

	function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, 
							Vector momentum, name damageType)
	{
//Log(self $ "[Scoring] TakeDamage" );

		LastHitBy = instigatedBy;
		LastHitTime = Level.TimeSeconds;
		Global.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
		if (health <= 0)
			return;

		if (NextState == 'TakeHit')
		{
			NextState = 'Attacking';
			NextLabel = '';
			GotoState('TakeHit'); 
		}
		else 
		{
			bReadyToAttack = true;
			WhatToDoNext('Attacking');
		}
	}

	function FearThisSpot(Actor aSpot)
	{
		//TraceLog(class $ "[Scoring]", 10, "in FearThisSpot(" $ aSpot.name $ ")");

		Destination = Location + 120 * Normal(Location - aSpot.Location); 
		WhatToDoNext('Hunting', 'Moving');
	}
	
	function Timer()
	{
		//TraceLog(class $ "[Scoring]", 10, "in Timer()");

		bReadyToAttack = True;
		Enable('Bump');
	}

	function SetFall()
	{
//Log(self$"DSL [Scoring] in SetFall()");

		bWallAdjust = false;
		NextState = 'Scoring'; 
		NextLabel = 'Landed';
		NextAnim = AnimSequence;
		GotoState('FallingState'); 
	}

	function EnemyAcquired()
	{
		//TraceLog(class $ "[Scoring]", 10, "in EnemyAcquired()");

		WhatToDoNext('Acquisition');
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		//TraceLog(class $ "[Scoring]", 10, "in HitWall(...)");

		if (Physics == PHYS_Falling)
			return;

		if (Wall.IsA('Mover') && Mover(Wall).HandleDoor(self))
		{
			if (SpecialPause > 0)
				Acceleration = vect(0,0,0);
//log( self$" DSL in scoring spot A" );
			GotoState('Scoring', 'SpecialNavig');
			return;
		}

		Focus = Destination;
		if (!bWallAdjust && PickWallAdjust())
        {
			GotoState('Scoring', 'AdjustFromWall');
//log( self$" DSL in scoring spot B" );
        }
		else
		{
			MoveTimer = -1.0;
			bWallAdjust = false;
		}
	}

	function bool SwitchToBestWeapon()
	{
		//TraceLog(class $ "[Scoring]", 10, "in SwitchToBestWeapon()");
		// special case: override default weapon-switch logic when we're scoring
		return false;
	}

	function PickDestination(optional bool bNoCharge)
	{
//log( self$" scoring - picking dest" );
        GotoState('Hunting');
    }

/*
	function PickDestination(optional bool bNoCharge)
	{
		local float Dist;

		//TraceLog(class $ "[Scoring]", 10, "in PickDestination()");

		Dist = VSize(Location - OrderObject.Location);
		//TraceLog(class $ "[Scoring]", 5, "Distance to " $ OrderObject.name $ " is " $ Dist);

		if (Dist < 200)
		{
//log(self$"arrived at destination! distance = " $ Dist);	
//			MoveTarget = OrderObject;
//			GotoState('Scoring');
			GotoState('Scoring','Begin');
			return;
		}
		else if (ActorReachable(OrderObject))
		{
			//TraceLog(class $ "[Scoring]", 5, "OrderObject is reachable, but not close");	
			MoveTarget = OrderObject;
		}
		else
		{
			//TraceLog(class $ "[Scoring]", 5, "OrderObject is NOT directly reachable");	
			MoveTarget = FindPathToward(OrderObject);
			if (MoveTarget == None)
			{
				// this generally shouldent happen often; all HuntPoints and ScorePoints
				// should be on the main navigation network
				//TraceLog(class $ "[Delivering]", 5, "Cannot reach " $ OrderObject);	
				//MoveTarget = OrderObject;
				GotoState('Lost');						// admit it, we're lost...
				return;
			}
			GotoState('Scoring', 'Moving');
		}
	}
*/

	function AnimEnd() 
	{
		//TraceLog(class $ "[Scoring]", 10, "in AnimEnd()");

		if (bCamping)
			PlayWaiting();
		else
			PlayRunning();
	}


	function BeginState()
	{
		//TraceLog(class $ "[Scoring]", 10, "in BeginState()");

		bNoShootDecor = false;
		bCanFire = false;
		bCamping = false;
		if (bNoClearSpecial)
			bNoClearSpecial = false;
		else
		{
			bSpecialPausing = false;
			bSpecialGoal = false;
			SpecialGoal = None;
			SpecialPause = 0.0;
		}
	}

	function EndState()
	{
		//TraceLog(class $ "[Scoring]", 10, "in EndState()");

        SwitchHuntGun(class'SShot');
		if (AmbushSpot != None)
		{
			AmbushSpot.taken = false;
			if (Enemy != None)
				AmbushSpot = None;
		}
		bCamping = false;
		bWallAdjust = false;
	}

// DSL -- label not found error fix 
// (supplying label, but no associated code)
SpecialNavig:
Moving:
	if (!IsAnimating())
		AnimEnd();
	if (MoveTarget == None)
	{
		Acceleration = vect(0,0,0);
		Sleep(0.0);
		GotoState('Hunting');
	}
	if (MoveTarget.IsA('InventorySpot')) 
	{
		if (InventorySpot(MoveTarget).markedItem.BotDesireability(self) > 0)
		{
			if (InventorySpot(MoveTarget).markedItem.GetStateName() == 'Pickup')
				MoveTarget = InventorySpot(MoveTarget).markedItem;
			else if (VSize(Location - MoveTarget.Location) < CollisionRadius)
			{
				CampTime = 3.5 + FRand() - skill;
				Goto('Camp');
			}
		}
	}
	bCamping = false;
    PlayRunning();
	MoveToward(MoveTarget);
	Goto('Begin');

GiveWay:	
	//TraceLog(class $ "[Scoring]", 10, "at GiveAway:");
	bCamping = true;
	Acceleration = vect(0,0,0);
	TweenToWaiting(0.15);
	if (NearWall(200))
	{
		PlayTurning();
		TurnTo(MoveTarget.Location);
	}
	Sleep(CampTime);
	Goto('Begin');

Camp:
	//TraceLog(class $ "[Scoring]", 10, "at Camp:");
	bCamping = true;
	Acceleration = vect(0,0,0);
	TweenToWaiting(0.15);
ReCamp:
	//TraceLog(class $ "[Scoring]", 10, "at ReCamp:");
	if (NearWall(200))
	{
		PlayTurning();
		TurnTo(Focus);
	}
	Sleep(CampTime);
	if ((Weapon != None) && (Weapon.AIRating > 0.4) && (3 * FRand() > skill + 1))
		Goto('ReCamp');
Begin:
	//TraceLog(class $ "[Scoring]", 10, "at Begin:");
	bCamping = false;
	Sleep(0.1);
    WaitForLanding();
    Disable('AnimEnd');

	//TraceLog(class $ "[Scoring]", 5, "OrderObject = " $ OrderObject.name);

	ScorePtOrder = ScorePoint(OrderObject);
	if (ScorePtOrder == none)
	{
		//TraceLog(class $ "[Scoring]", 5, "OrderObject is not a ScorePoint!");
		Goto('GiveUp');
	}
	TweenToRunning(0.3);
	FinishAnim();
	PlayRunning();
		
	switch (ScorePtOrder.BotAdvice)
	{
		case ADV_Start:
			//TraceLog(class $ "[Scoring]", 5, "BotAdvice = ADV_Start");
			break;

		case ADV_Jump:
			//TraceLog(class $ "[Scoring]", 5, "BotAdvice = ADV_Start");
			if (ScorePtOrder.bDirectional)
				SetRotation(ScorePtOrder.Rotation);

			ScorePtOrder.HandleJump(self);
			Velocity.Z = RecommendedJumpZ;
			break;
	
		case ADV_Shoot:
			Target = ScorePtOrder.Target;

			if (Target == None)
				Goto('DoneShooting');
			if (BallHolding == 0)
				Goto('DoneShooting');

			Acceleration = vect(0,0,0); //stop
			DesiredRotation = Rotator(Target.Location - Location);
            bRotateToDesired = true;
			PlayTurning();
            TurnCounter = TurnCount;
FaceTarget:
            TurnCounter--;
            if ( TurnCounter < 1 )
                Goto('Faced');
			if (NeedToTurn(Target.Location))
			{       
				TurnToward(Target);
				Goto('FaceTarget');
			}
Faced:
//			TweenToFighter(0.1);
			ViewRotation = Rotation;
//			FinishAnim();

			// switch to the proper weapon
            if ( !Weapon.IsA('SHBallGun') )
            {
                if ( (BallHolding==0) || !SwitchHuntGun(class'SHBallGun') )
    				Goto('DoneShooting');
            }

			PlayFiring();													 
			bFire = 0;
FireAtTarget:
//log( self$" -----about to shoot "$Weapon$" with BH = "$BallHolding );
//log( self$" my "$Weapon$" is in state "$Weapon.GetStateName() );
            Weapon.AltFire(0.1);
//log( self$" my "$Weapon$" is in state "$Weapon.GetStateName() );
            Sleep(0.8);
//log( self$"-------just shot and BH = "$BallHolding );

			if ( BallHolding != 0 )
				Goto('FireAtTarget');
StopShooting:
			HaltFiring();
			FinishAnim();
DoneShooting:
            SwitchHuntGun(class'SShot');
            if ( BallHolding == 0 )
    			GotoState('Seeking');
            else
                GotoState('Delivering');
			break;

		default:
			Goto('GiveUp');
	}
	Goto('Begin');

AdjustFromWall:
	StrafeTo(Destination, Focus); 
	Destination = Focus; 
    PlayRunning();
	MoveTo(Destination);
	Goto('Begin');          // was goto 'Moving' of which there wasn't one

GiveUp:
//Log(self$" DSL - at giveup:");
	Acceleration = vect(0,0,0);     
	TweenToPatrolStop(0.3);
	FinishAnim();
DelayedPatrol:
	Enable('AnimEnd');
	PlayPatrolStop();
    GotoState('Lost');
}

///////////////////////////////// LOST ////////////////////////////////////////
//
// Lost state handles the condition where the bot is unable to find a path to
// known navigation points.
//
// Possible solutions:
// * Look for a special navigation point with instructions (Bot advice)
// * Look for a navigatoin point that is not on our current network
// * Follow the left wall???
// * Random wandering until we get back on a good network
// * Teleport back to a known location (playerstart)
//

state Lost
{
	ignores EnemyNotVisible;

	function Bump(actor Other)
	{
		local vector VelDir, OtherDir;
		local float speed;

		//TraceLog(class $ "[Lost]", 10, "in Bump(" $ Other.name $ ")");

		if (Pawn(Other) != None)
		{
			if ((Other == Enemy) || SetEnemy(Pawn(Other)))
			{
				if (FRand() < Aggressiveness)
					return;
				bReadyToAttack = true;
				WhatToDoNext('Attacking');
			}
			return;
		}
		if (TimerRate <= 0)
			setTimer(1.0, false);
		speed = VSize(Velocity);
		if (speed > 1)
		{
			VelDir = Velocity/speed;
			VelDir.Z = 0;
			OtherDir = Other.Location - Location;
			OtherDir.Z = 0;
			OtherDir = Normal(OtherDir);
			if ((VelDir Dot OtherDir) > 0.9)
			{
				Velocity.X = VelDir.Y;
				Velocity.Y = -1 * VelDir.X;
				Velocity *= FMax(speed, 200);
			}
		}
		else if (bCamping)
			GotoState('Lost');
		Disable('Bump');
	}
	
	function HandleHelpMessageFrom(Pawn Other)
	{
		//TraceLog(class $ "[Lost]", 10, "in HandleMessageFrom(" $ Other.name $ ")");

		if ((Health > 70) && (Weapon.AIRating > 0.5) && (Other.PlayerReplicationInfo.Team == PlayerReplicationInfo.Team)
			&& (Other.Enemy != None)
			&& (VSize(Other.Enemy.Location - Location) < 1200))
		{
			SetEnemy(Other.Enemy);
			WhatToDoNExt('Attacking');
		}
	}

	function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, 
							Vector momentum, name damageType)
	{
		//TraceLog(class $ "[Lost]", 10, "in TakeDamage(...)");

		LastHitBy = instigatedBy;
		LastHitTime = Level.TimeSeconds;
		Global.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
		if (health <= 0)
			return;

		if (NextState == 'TakeHit')
		{
			NextState = 'Attacking'; 
			NextLabel = '';
			GotoState('TakeHit'); 
		}
		else 
		{
			bReadyToAttack = true;
			WhatToDoNext('Attacking');
		}
	}

	function FearThisSpot(Actor aSpot)
	{
		//TraceLog(class $ "[Lost]", 10, "in FearThisSpot(" $ aSpot.name $ ")");

		Destination = Location + 120 * Normal(Location - aSpot.Location); 
		WhatToDoNext('Lost', 'Moving');
	}
	
	function Timer()
	{
		//TraceLog(class $ "[Lost]", 10, "in Timer()");

		bReadyToAttack = True;
		Enable('Bump');
	}

	function SetFall()
	{
		//TraceLog(class $ "[Lost]", 10, "in SetFall()");

		bWallAdjust = false;
		NextState = 'Lost'; 
		NextLabel = 'Landed';
		NextAnim = AnimSequence;
		GotoState('FallingState'); 
	}

	function EnemyAcquired()
	{
		//TraceLog(class $ "[Lost]", 10, "in EnemyAcquired()");

		WhatToDoNext('Acquisition');
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		//TraceLog(class $ "[Lost]", 10, "in HitWall(...)");

		if (Physics == PHYS_Falling)
			return;
		if (Wall.IsA('Mover') && Mover(Wall).HandleDoor(self))
		{
			if (SpecialPause > 0)
				Acceleration = vect(0,0,0);
			GotoState('Lost', 'SpecialNavig');
			return;
		}
		Focus = Destination;
		if (!bWallAdjust && PickWallAdjust())
			GotoState('Lost', 'AdjustFromWall');
		else
		{
			MoveTimer = -1.0;
			bWallAdjust = false;
		}
	}

	function bool TestDirection(vector dir, out vector pick)
	{	
		local vector HitLocation, HitNormal, dist;
		local float minDist;
		local actor HitActor;

		minDist = FMin(150.0, 4*CollisionRadius);
		pick = dir * (minDist + (450 + 12 * CollisionRadius) * FRand());

		HitActor = Trace(HitLocation, HitNormal, Location + pick + 1.5 * CollisionRadius * dir , Location, false);
		if (HitActor != None)
		{
			pick = HitLocation + (HitNormal - dir) * 2 * CollisionRadius;
			HitActor = Trace(HitLocation, HitNormal, pick , Location, false);
			if (HitActor != None)
				return false;
		}
		else
			pick = Location + pick;
		 
		dist = pick - Location;
		if (Physics == PHYS_Walking)
			dist.Z = 0;
		
		return (VSize(dist) > minDist); 
	}

	function PickDestination(optional bool bNoCharge)
	{
		local inventory Inv, BestInv, KnowPath;
		local SHBallPick Ball, BestBall;
		local float Bestweight, NewWeight, DroppedDist;
		local actor BestPath, HitActor;
		local vector HitNormal, HitLocation;
		local decoration Dec;
		local bool bCanReach;
		local NavigationPoint N;
		local int i;
		local Actor BallGen;

		local vector pick, pickdir;
		local bool success;
		local float XY;

		//TraceLog(class $ "[Lost]", 10, "in PickDestination()");

		// first look for nearby SHBallPick-derived objects
		foreach visiblecollidingactors(class'SHBallPick', Ball, 1200)
		{
			if (Ball.IsInState('PickUp'))
			{
				NewWeight = Ball.BotDesireability(self) / VSize(Ball.Location - Location);
				// log("looking at local "$Ball$" weight "$100000*NewWeight);
				if (NewWeight > BestWeight)
				{
					BestWeight = NewWeight;
					BestBall = Ball;
				}
			}
		}

		if (BestBall != None)
		{
			bCanJump = (BestBall.Location.Z > Location.Z - CollisionHeight - MaxStepHeight);
			bCanReach = ActorReachable(BestBall);
		}
		else
			bCanReach = false;
		bCanJump = true;
		if (bCanReach)
		{
			//TraceLog(class $ "[Lost]", 5, "Found best ball: " $ BestBall);
			MoveTarget = BestBall;
			return;
		}

		//TraceLog(class $ "[Lost]", 5, "No SHBalls found nearby; looking for other inventory...");

		// look at nearby inventory < 600 dist
		foreach visiblecollidingactors(class'Inventory', Inv, PickupSightRadius)
		{
			if ((Inv.IsInState('PickUp')) && (Inv.MaxDesireability/50 > BestWeight)
				&& (Inv.Location.Z < Location.Z + MaxStepHeight + CollisionHeight))
			{
				NewWeight = inv.BotDesireability(self)/VSize(Inv.Location - Location);
				// log("looking at local "$Inv$" weight "$100000*NewWeight);
				if (NewWeight > BestWeight)
				{
					BestWeight = NewWeight;
					BestInv = Inv;
				}
			}
		}

		if (BestInv != None)
		{
			bCanJump = (BestInv.Location.Z > Location.Z - CollisionHeight - MaxStepHeight);
			bCanReach = ActorReachable(BestInv);
		}
		else
			bCanReach = false;
		bCanJump = true;
		if (bCanReach)
		{
			//TraceLog(class $ "[Lost]", 5, "Found best inventory:  " $ BestInv);
			MoveTarget = BestInv;
			return;
		}
		else if (KnowPath != None)
		{
			MoveTarget = KnowPath;
			return;
		}

		if ((Weapon != none) && (Weapon.AIRating > 0.5) && (Health > 90))
		{			
			bWantsToCamp = (bWantsToCamp || (FRand() < CampingRate * FMin(1.0, Level.TimeSeconds - LastCampCheck)));
			LastCampCheck = Level.TimeSeconds;
		}
		else 
			bWantsToCamp = false;

		if (bWantsToCamp && FindAmbushSpot())
			return;

		// if none found, check for decorations with inventory
		if (!bNoShootDecor)
			foreach visiblecollidingactors(class'Decoration', Dec, PickupSightRadius)
				if (Dec.Contents != None)
				{
					bNoShootDecor = true;
					Target = Dec;
					GotoState('Lost', 'ShootDecoration');
					return;
				}

		bNoShootDecor = false;
		BestWeight = 0;

		// look for long distance inventory 
		BestPath = FindBestInventoryPath(BestWeight, (skill >= 2));
		if (BestPath != None)
		{
			MoveTarget = BestPath;
			return;
		}

		// do we have SH Balls to deposit?
		if (SHBallCount() > 0)
		{
			GotoState('Delivering');		// might as well as score now...
			return;
		}

		 // nothing to do
		//TraceLog(class $ "[Lost]", 10, "Nothing to do, wandering around...");
		//Favor XY alignment
		XY = FRand();
		if (XY < 0.3)
		{
			pickdir.X = 1;
			pickdir.Y = 0;
		}
		else if (XY < 0.6)
		{
			pickdir.X = 0;
			pickdir.Y = 1;
		}
		else
		{
			pickdir.X = 2 * FRand() - 1;
			pickdir.Y = 2 * FRand() - 1;
		}
		if (Physics != PHYS_Walking)
		{
			pickdir.Z = 2 * FRand() - 1;
			pickdir = Normal(pickdir);
		}
		else
		{
			pickdir.Z = 0;
			if (XY >= 0.6)
				pickdir = Normal(pickdir);
		}	

		success = TestDirection(pickdir, pick);
		if (!success)
			success = TestDirection(-1 * pickdir, pick);
		
		if (success)	
			Destination = pick;
//		else
//			GotoState('Lost', 'Turn');
	}
	
	function Actor FindReachableHuntPoint()
	{
		local int	i;
		local Actor	Dest;

		//TraceLog(class $ "[Lost]", 10, "in FindAnyHuntPoint()");

		// are ANY of the HuntPoints reachable?
		for (i = 0; i < LevelNumBalls; i++)
		{
			// is this huntpoint reachable?
			Dest = FindPathToward(LevelHuntPoints[i].HuntPoint);
			if (Dest != None)
				return Dest;				// found one!
		}
	}

	function Actor FindAnotherNetwork()
	{
		local float				ThisDist, NearestDist;
		local NavigationPoint	ThisNav, NearestNav;

		//TraceLog(class $ "[Lost]", 10, "in FindAnotherNetwork()");

		// can I see any nearby navigation points that are not on my network?
		foreach VisibleCollidingActors(class'NavigationPoint', ThisNav, 1000)
		{
			//TraceLog(class $ "[Lost]", 10, "Found nearby nav point: " $ ThisNav);
			// ignore if it's on my network
			if (FindPathToward(ThisNav) != None)
				continue;

			//TraceLog(class $ "[Lost]", 10, "is on another net!");
			ThisDist = VSize(ThisNav.Location - Location);
			if (NearestDist == 0 || ThisDist < NearestDist)
			{
				// assume it's reachable
				NearestDist = ThisDist;
				NearestNav = ThisNav;
			}
		}

		return NearestNav;
	}

	function bool FindAmbushSpot()
	{
		//TraceLog(class $ "[Lost]", 10, "in FindAmbushSpot()");

		if ((AmbushSpot == None) && (Ambushpoint(MoveTarget) != None))
			AmbushSpot = Ambushpoint(MoveTarget);

		if (Ambushspot != None)
		{
			Ambushspot.taken = true;
			if (VSize(Ambushspot.Location - Location) < 2 * CollisionRadius)
			{	
				CampTime = 10.0;
				WhatToDoNext('Lost', 'LongCamp');
				return true;
			}
			if (ActorReachable(Ambushspot))
			{
				MoveTarget = Ambushspot;
				return true;
			}
			MoveTarget = FindPathToward(Ambushspot);
			if (MoveTarget != None)
				return true;
			Ambushspot.taken = false;
			Ambushspot = None;
		}
		return false;
	}		

	function AnimEnd() 
	{
		//TraceLog(class $ "[Lost]", 10, "in AnimEnd()");

		if (bCamping)
			PlayWaiting();
		else
			PlayRunning();
	}

	function ShareWithTeam()
	{
		local bool bHaveItem, bIsHealth, bOtherHas;
		local Inventory goalItem;
		local Pawn P;

		//TraceLog(class $ "[Lost]", 10, "in ShareWithTeam()");

		goalItem = InventorySpot(MoveTarget).markedItem;
		if (goalItem == None) // FIXME REMOVE
		{
//			log(" No marked item for "$MoveTarget);
			return;
		}

		if (goalItem.IsA('Weapon'))
		{
			if ((Weapon == None) || (Weapon.AIRating < 0.45))
				return;
			bHaveItem = (FindInventoryType(goalItem.class) != None);
		}
		else if (goalItem.IsA('Health'))
		{
			bIsHealth = true;
			if (Health < 60)
				return;
		}
		else 
			return;

		CampTime = 2.0;

		for (P=Level.PawnList; P!=None; P=P.nextPawn)
			if (P.bIsPlayer && (P.PlayerReplicationInfo.Team == PlayerReplicationInfo.Team)
				&& ((P.MoveTarget == MoveTarget) || (P.MoveTarget == goalItem) 
					|| (!bIsHealth && P.IsA('PlayerPawn') && !P.IsA('Spectator') 
						&& (VSize(P.Location - Location) < 1250) && LineOfSightTo(P))))
			{
				//decide who needs it more
				if (bIsHealth)
				{
					if (Health > P.Health + 10)
					{
						WhatToDoNext('Lost','GiveAway');
						return;
					}
					else if ((P.IsInState('Lost')) && (Health < P.Health - 10))
						P.GotoState('Lost', 'GiveWay');
				}
				else
				{
					bOtherHas = (P.FindInventoryType(goalItem.class) != None);
					if (!bHaveItem && bOtherHas)
					{
						if (P.IsInState('Lost'))
							P.GotoState('Lost', 'GiveWay');	
					}					
					else if (bHaveItem && !bOtherHas)
					{
						GotoState('Lost', 'GiveWay');
						return;
					}
				}
			}
	}
						 
	function BeginState()
	{
		//TraceLog(class $ "[Lost]", 10, "in BeginState()");

		bNoShootDecor = false;
		bCanFire = false;
		bCamping = false;
		if (bNoClearSpecial)
			bNoClearSpecial = false;
		else
		{
			bSpecialPausing = false;
			bSpecialGoal = false;
			SpecialGoal = None;
			SpecialPause = 0.0;
		}
	}

	function EndState()
	{
		//TraceLog(class $ "[Lost]", 10, "in EndState()");

		if (AmbushSpot != None)
		{
			AmbushSpot.taken = false;
			if (Enemy != None)
				AmbushSpot = None;
		}
		bCamping = false;
		bWallAdjust = false;
	}

LongCamp:
	//TraceLog(class $ "[Lost]", 10, "at LongCamp:");

	bCamping = true;
	Acceleration = vect(0,0,0);
	TweenToWaiting(0.15);
	if (OrderObject.IsA('AmbushPoint'))
		TurnTo(Location + (Ambushpoint(OrderObject)).lookdir);
	Sleep(CampTime);
	Goto('Begin');

GiveWay:	
	//TraceLog(class $ "[Lost]", 10, "at GiveAway:");
	bCamping = true;
	Acceleration = vect(0,0,0);
	TweenToWaiting(0.15);
	if (NearWall(200))
	{
		PlayTurning();
		TurnTo(MoveTarget.Location);
	}
	Sleep(CampTime);
	Goto('Begin');

Camp:
	//TraceLog(class $ "[Lost]", 10, "at Camp:");
	bCamping = true;
	Acceleration = vect(0,0,0);
	TweenToWaiting(0.15);
ReCamp:
	//TraceLog(class $ "[Lost]", 10, "at ReCamp:");
	if (NearWall(200))
	{
		PlayTurning();
		TurnTo(Focus);
	}
	Sleep(CampTime);
	if ((Weapon != None) && (Weapon.AIRating > 0.4) && (3 * FRand() > skill + 1))
		Goto('ReCamp');
Begin:
	//TraceLog(class $ "[Lost]", 10, "at Begin:");
	bCamping = false;
	TweenToRunning(0.1);
	WaitForLanding();
	
	MoveTarget = FindReachableHuntPoint();
	if (MoveTarget != None)
	{
		//TraceLog(class $ "[Lost]", 10, "Found a way back to " $ MoveTarget $ "!!!");
		//GotoState('Seeking');
		Goto('Moving');
	}
	MoveTarget = FindAnotherNetwork();
	if (MoveTarget != None)
	{
		//TraceLog(class $ "[Lost]", 10, "Found another network!  Path =" $ MoveTarget);
    PlayRunning();
		MoveToward(MoveTarget);
	}

RunAway:
	//TraceLog(class $ "[Lost]", 10, "at RunAway:");
	PickDestination();

// DSL -- label not found error fix 
// (supplying label, but no associated code)
SpecialNavig:
Moving:
	//TraceLog(class $ "[Lost]", 10, "at Moving:  MoveTarget = " $ MoveTarget);

	if (!IsAnimating())
		AnimEnd();
	if (MoveTarget == None)
	{
		Acceleration = vect(0,0,0);
		Sleep(0.0);
		Goto('RunAway');
	}
	if (MoveTarget.IsA('InventorySpot')) 
	{
		if (Level.Game.bTeamGame)
			ShareWithTeam();
		if (InventorySpot(MoveTarget).markedItem.BotDesireability(self) > 0)
		{
			if (InventorySpot(MoveTarget).markedItem.GetStateName() == 'Pickup')
				MoveTarget = InventorySpot(MoveTarget).markedItem;
			else if (VSize(Location - MoveTarget.Location) < CollisionRadius)
			{
				CampTime = 3.5 + FRand() - skill;
				Goto('Camp');
			}
		}
	}
	bCamping = false;
    PlayRunning();
	MoveToward(MoveTarget);
	Goto('RunAway');

TakeHit:
	//TraceLog(class $ "[Lost]", 10, "at TakeHit:");
	TweenToRunning(0.12);
	Goto('Moving');

Landed:
	//TraceLog(class $ "[Lost]", 10, "at Landed:");
	if (MoveTarget == None) //FIXME - do this in all landed: !!!
		Goto('RunAway');
	Goto('Moving');

AdjustFromWall:
	//TraceLog(class $ "[Lost]", 10, "at AdjustFromWall:");
	bWallAdjust = true;
	bCamping = false;
	StrafeTo(Destination, Focus); 
	Destination = Focus; 
    PlayRunning();
	MoveTo(Destination);
	bWallAdjust = false;
	Goto('Moving');

ShootDecoration:
	//TraceLog(class $ "[Lost]", 10, "at ShootDecoration:");
	TurnToward(Target);
	if (Target != None)
	{
		FireWeapon();
		bAltFire = 0;
		bFire = 0;
	}
	Goto('RunAway');
}


///////////////////////////////// ACQUISITION ////////////////////////////////////////
//
// Creature has just reacted to stimulus, and set an enemy
// - depending on strength of stimulus, and ongoing stimulii,
// vary time to focus on target and start attacking (or whatever.)
// FIXME - need some acquisition specific animation
// HearNoise and SeePlayer used to improve/change stimulus
//

state Acquisition
{
ignores falling, landed; //fixme

	function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, 
							Vector momentum, name damageType)
	{
		//TraceLog(class $ "[Acquisition]", 10, "in TakeDamage(" $ damage $ "," $ instigatedBy.name $ ", ...)");

		LastHitBy = instigatedBy;
		LastHitTime = Level.TimeSeconds;
		LastSeenPos = Enemy.Location;
		Global.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
		if (health <= 0)
			return;
		if (NextState == 'TakeHit')
		{
			NextState = 'Attacking'; 
			NextLabel = 'Begin';
			GotoState('TakeHit'); 
		}
		else
			WhatToDoNext('Attacking');
	}
}

///////////////////////////////// ATTACKING ////////////////////////////////////////
//
//  Master attacking state - choose which type of attack to do from here
//

state Attacking
{
ignores SeePlayer, HearNoise, Bump, HitWall;

	function ChooseAttackMode()
	{
		local eAttitude AttitudeToEnemy;
		local float Aggression;
		local pawn changeEn;

//		if (health <= 0)
//			Log(class $ "[Attacking] Error: choose attack while dead");

		if (Enemy == None)
		{
//log( self$" state Attacking, wtdn00" );
			WhatToDoNext('','');
			return;
		}
		if (Enemy.Health <= 0)
		{
//log( self$" state Attacking, wtdn01" );
			WhatToDoNext('','');
			return;
		}
			
		AttitudeToEnemy = AttitudeTo(Enemy);
			
		if (AttitudeToEnemy == ATTITUDE_Fear)
		{
			WhatToDoNExt('Retreating');
			return;
		}
		else if (AttitudeToEnemy == ATTITUDE_Friendly)
		{
//log( self$" state Attacking, wtdn02" );
			WhatToDoNext('','');
			return;
		}
		
		if (bReadyToAttack)
		{
			////log("Attack!");
			Target = Enemy;
			If (VSize(Enemy.Location - Location) <= (MeleeRange + Enemy.CollisionRadius + CollisionRadius))
			{
				WhatToDoNext('RangedAttack');
				return;
			}
			else
				SetTimer(TimeBetweenAttacks, False);
		}
			
		WhatToDoNext('TacticalMove');
	}
	
}


///////////////////////////////// RETREATING ////////////////////////////////////////
//
// Retreating for a bot is going toward an item while still engaged with an enemy,
// but fearing that enemy (so no desire to remain engaged)
// TacticalGet is for going to an item while engaged, and remaining engaged. TBD
// Seeking is going to items w/ no enemy. TBD
//

state Retreating
{
ignores EnemyNotVisible;

	function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, 
							Vector momentum, name damageType)
	{
		//TraceLog(class $ "[Retreating]", 10, "in TakeDamage(" $ Damage $ "," $ instigatedBy.name $ ", ...)");

		LastHitBy = instigatedBy;
		LastHitTime = Level.TimeSeconds;
		Global.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
		if (health <= 0)
			return;
		if (NextState == 'TakeHit')
		{
			NextState = 'Retreating'; 
			NextLabel = 'TakeHit';
			GotoState('TakeHit'); 
		}
		else if (!bCanFire && (skill > 3 * FRand()))
			WhatToDoNext('Retreating', 'Moving');
	}
}

///////////////////////////////// FALLBACK ////////////////////////////////////////
//

state Fallback
{
ignores EnemyNotVisible;

	function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, 
							Vector momentum, name damageType)
	{
		//TraceLog(class $ "[Fallback]", 10, "in TakeDamage(" $ Damage $ "," $ instigatedBy.name $ ", ...)");

		LastHitBy = instigatedBy;
		LastHitTime = Level.TimeSeconds;
		Global.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
		if (health <= 0)
			return;
		if (NextState == 'TakeHit')
		{
			NextState = 'Fallback'; 
			NextLabel = 'TakeHit';
			GotoState('TakeHit'); 
		}
		else if (!bCanFire && (skill > 3 * FRand()))
			WhatToDoNext('Fallback', 'Moving');
	}

}

///////////////////////////////// CHARGING ////////////////////////////////////////
//

state Charging
{
ignores SeePlayer, HearNoise;

	function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, 
							Vector momentum, name damageType)
	{
		local float pick;
		local vector sideDir, extent;
		local bool bWasOnGround;

		//TraceLog(class $ "[Charging]", 10, "in TakeDamage(" $ Damage $ "," $ instigatedBy.name $ ", ...)");

		LastHitBy = instigatedBy;
		LastHitTime = Level.TimeSeconds;
		bWasOnGround = (Physics == PHYS_Walking);
		Global.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
		if (health <= 0)
			return;
		if (NextState == 'TakeHit')
		{
			if (AttitudeTo(Enemy) == ATTITUDE_Fear)
			{
				NextState = 'Retreating';
				NextLabel = 'Begin';
			}
			else if (StrafeFromDamage(momentum, Damage, damageType, false))
			{
				NextState = 'TacticalMove';
				NextLabel = 'NoCharge';
			}
			else
			{
				NextState = 'Charging';
				NextLabel = 'TakeHit';
			}
			GotoState('TakeHit');
		}
		else if (StrafeFromDamage(momentum, Damage, damageType, true))
			return;
		else if (bWasOnGround && (MoveTarget == Enemy) && 
					(Physics == PHYS_Falling)) //weave
		{
			pick = 1.0;
			if (bStrafeDir)
				pick = -1.0;
			sideDir = Normal(Normal(Enemy.Location - Location) Cross vect(0,0,1));
			sideDir.Z = 0;
			Velocity += pick * GroundSpeed * 0.7 * sideDir;   
			if (FRand() < 0.2)
				bStrafeDir = !bStrafeDir;
		}
	}
							
	function EnemyNotVisible()
	{
		//TraceLog(class $ "[Charging]", 10, "in EnemyNotVisible()");

		WhatToDoNext('Seeking');		// oh well, give up attack...
	}

CloseIn:
	if ( (Enemy == None) || (Enemy.Health <=0) )
		GotoState('Attacking');

	if ( Enemy.Region.Zone.bWaterZone )
	{
		if (!bCanSwim)
			GotoState('TacticalMove', 'NoCharge');
	}
	else if (!bCanFly && !bCanWalk)
		GotoState('TacticalMove', 'NoCharge');

	if (Physics == PHYS_Falling)
	{
		DesiredRotation = Rotator(Enemy.Location - Location);
		Focus = Enemy.Location;
		Destination = Enemy.Location;
		WaitForLanding();
	}
	if( actorReachable(Enemy) )
	{
		bCanFire = true;
    PlayRunning();
		MoveToward(Enemy);
		if (bFromWall)
		{
			bFromWall = false;
			if (PickWallAdjust())
				StrafeFacing(Destination, Enemy);
			else
				GotoState('TacticalMove', 'NoCharge');
		}
	}
	else
	{
NoReach:
		bCanFire = false;
		bFromWall = false;
		//log("route to enemy "$Enemy);
		if (!FindBestPathToward(Enemy))
		{
			Sleep(0.0);
			GotoState('TacticalMove', 'NoCharge');
		}
SpecialNavig:
		if ( SpecialPause > 0.0 )
		{
			Target = Enemy;
			bFiringPaused = true;
			NextState = 'Charging';
			NextLabel = 'Begin';
			GotoState('RangedAttack');
		}
Moving:
		if (VSize(MoveTarget.Location - Location) < 2.5 * CollisionRadius)
		{
			bCanFire = true;
			StrafeFacing(MoveTarget.Location, Enemy);
		}
		else
		{
			if ( !bCanStrafe || !LineOfSightTo(Enemy) ||
				(Skill - 2 * FRand() + (Normal(Enemy.Location - Location - vect(0,0,1) * (Enemy.Location.Z - Location.Z)) 
					Dot Normal(MoveTarget.Location - Location - vect(0,0,1) * (MoveTarget.Location.Z - Location.Z))) < 0) )
			{
				if ( GetAnimGroup(AnimSequence) == 'MovingAttack' )
				{
					AnimSequence = '';
					TweenToRunning(0.12);
				}
				HaltFiring();
    PlayRunning();
				MoveToward(MoveTarget);
			}
			else
			{
				bCanFire = true;
				StrafeFacing(MoveTarget.Location, Enemy);	
			}
		}
	}

	WhatToDoNext('Attacking');

}

///////////////////////////////// TACTICALMOVE ////////////////////////////////////////
//
state TacticalMove
{
ignores SeePlayer, HearNoise;


    function SetFall()
    {
        Acceleration = vect(0,0,0);
        Destination = Location;
        NextState = 'Seeking';
        NextLabel = 'Begin';
        NextAnim = 'SPJump';
        GotoState('FallingState');
    }

	function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, name damageType)
	{
		//TraceLog(class $ "[TacticalMove]", 10, "in TakeDamage(" $ Damage $ "," $ instigatedBy.name $ ", ...)");

		LastHitBy = instigatedBy;
		LastHitTime = Level.TimeSeconds;
		Global.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
		if (health <= 0)
			return;
		if (NextState == 'TakeHit')
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
        //  GotoState('TacticalMove', 'AdjustFromWall');
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
    }

    function GiveUpTactical(bool bNoCharge)
    {
        if ( !bNoCharge && (2 * CombatStyle > (3 - Skill) * FRand()) )
            GotoState('Charging');
        else if ( BallHolding == 0 )
            GotoState('Seeking');
        else
            GotoState('Delivering');
    }


    function Timer()
    {
        bReadyToAttack = True;
        Enable('Bump');
        if ( Enemy != None )
        {
            Target = Enemy;
            if (VSize(Enemy.Location - Location)
                    <= (MeleeRange + Enemy.CollisionRadius + CollisionRadius))
                GotoState('RangedAttack');
            else if ( FRand() > 0.5 + 0.17 * skill )
                GotoState('RangedAttack');
        }
        else if ( BallHolding == 0 )
            GotoState('Seeking');
        else
            GotoState('Delivering');

    }


	function EnemyNotVisible()
	{
		//TraceLog(class $ "[TacticalMove]", 10, "in EnemyNotVisible()");

        if ( BallHolding == 0 )
            GotoState('Seeking');
        else
            GotoState('Delivering');
/*
		if (!bGathering && (aggressiveness > relativestrength(enemy)))
		{
			if (ValidRecovery())
				WhatToDoNext('TacticalMove', 'RecoverEnemy');
			else
				WhatToDoNext('Attacking');
		}
*/
		Disable('EnemyNotVisible');
	}
	

RecoverEnemy:
	//TraceLog(class $ "[TacticalMove]", 10, "at RecoverEnemy:");

	Enable('AnimEnd');
	bReadyToAttack = true;
	HidingSpot = Location;
	bCanFire = false;
	Destination = LastSeeingPos + 3 * CollisionRadius * Normal(LastSeeingPos - Location);
	if (bCanStrafe || (VSize(LastSeeingPos - Location) < 3 * CollisionRadius))
		StrafeFacing(Destination, Enemy);
	else
    {
        PlayRunning();
		MoveTo(Destination);
    }
	if (Weapon == None) 
		Acceleration = vect(0,0,0);
	if (NeedToTurn(Enemy.Location))
	{
		PlayTurning();
		TurnToward(Enemy);
	}
	if (CanFireAtEnemy())
	{
		Disable('AnimEnd');
		DesiredRotation = Rotator(Enemy.Location - Location);
		if (Weapon == None) 
		{
			PlayRangedAttack();
			FinishAnim();
			TweenToRunning(0.1);
			bReadyToAttack = false;
			SetTimer(TimeBetweenAttacks, false);
		}
		else
		{
			FireWeapon();
			if (Weapon.bSplashDamage)
			{
				bFire = 0;
				bAltFire = 0;
				Acceleration = vect(0,0,0);
				Sleep(0.1);
			}
		}

		if ((FRand() + 0.1 > CombatStyle))
		{
			Enable('EnemyNotVisible');
			Enable('AnimEnd');
			Destination = HidingSpot + 4 * CollisionRadius * Normal(HidingSpot - Location);
			Goto('DoMove');
		}
	}

	WhatToDoNext('Seeking');
}


///////////////////////////////// RANGEDATTACK ////////////////////////////////////////
//

state RangedAttack
{
ignores SeePlayer, HearNoise, Bump;

	function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, name damageType)
	{
		//TraceLog(class $ "[RangedAttack]", 10, "in TakeDamage(" $ Damage $ "," $ instigatedBy.name $ ", ...)");

		LastHitBy = instigatedBy;
		LastHitTime = Level.TimeSeconds;
		Global.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
		if (health <= 0)
			return;
		if (NextState == 'TakeHit')
		{
			NextState = 'RangedAttack';
			NextLabel = 'Begin';
		}
	}
}

///////////////////////////////// TAKEHIT ////////////////////////////////////////
//


state TakeHit 
{
ignores seeplayer, hearnoise, bump, hitwall;

	function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, name damageType)
	{
		//TraceLog(class $ "[TakeHit]", 10, "in TakeDamage(" $ Damage $ "," $ instigatedBy.name $ ", ...)");

		LastHitBy = instigatedBy;
		LastHitTime = Level.TimeSeconds;
		Global.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
	}
}


///////////////////////////////// FALLINGSTATE ////////////////////////////////////////
//

state FallingState 
{
ignores Bump, Hitwall, WarnTarget;

	function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, 
							Vector momentum, name damageType)
	{
		//TraceLog(class $ "[FallingState]", 10, "in TakeDamage(" $ Damage $ "," $ instigatedBy.name $ ", ...)");

		LastHitBy = instigatedBy;
		LastHitTime = Level.TimeSeconds;
		Global.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);

		if (Enemy == None)
		{
			Enemy = instigatedBy;
			NextState = 'Attacking'; 
			NextLabel = 'Begin';
		}
		if (Enemy != None)
			LastSeenPos = Enemy.Location;
		if (NextState == 'TakeHit')
		{
			NextState = 'Attacking'; 
			NextLabel = 'Begin';
			GotoState('TakeHit'); 
		}
	}

    singular event BaseChange()
    {
        local actor HitActor;
        local vector HitNormal, HitLocation;

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


LongFall:
	//TraceLog(class $ "[FallingState]", 10, "at LongFall:");
	if (bCanFly)
	{
		SetPhysics(PHYS_Flying);
		Goto('Done');
	}
	Sleep(0.7);
	TweenToFighter(0.2);
	if (Enemy != None)
	{
		TurnToward(Enemy);
		FinishAnim();
		if (CanFireAtEnemy())
		{
			PlayRangedAttack();
			FinishAnim();
		}
		PlayChallenge();
		FinishAnim();
	}
	TweenToFalling();
	if (Velocity.Z > -150) //stuck
	{
		SetPhysics(PHYS_Falling);
		if (Enemy != None)
			Velocity = groundspeed * normal(Enemy.Location - Location);
		else
			Velocity = groundspeed * VRand();

		Velocity.Z = FMax(JumpZ, 250);
	}
	Goto('LongFall');	

Landed:
	//TraceLog(class $ "[FallingState]", 10, "at Landed:");
	FinishAnim();
Done:
	//TraceLog(class $ "[FallingState]", 10, "at Done:");
//    TweenAnim('SpLand', 0.1);
//    FinishAnim();
    PlayAnim('SpLand');
//    FinishAnim();


	if (NextAnim == '')
	{
		bUpAndOut = false;
		if (NextState != '')
			WhatToDoNext(NextState, NextLabel);
		else 
			WhatToDoNext('Attacking');
	}
	if (!bUpAndOut)
	{
		if (NextAnim == 'Fighter')
			TweenToFighter(0.2);
		else
			TweenAnim(NextAnim, 0.12);
	} 

Splash:
	//TraceLog(class $ "[FallingState]", 10, "at Splash:");
	bUpAndOut = false;
	if (NextState != '')
		WhatToDoNext(NextState, NextLabel);
	else 
		WhatToDoNext('Attacking');
			
Begin:
	//TraceLog(class $ "[FallingState]", 10, "at Begin:");
	if (Enemy == None)
		Disable('EnemyNotVisible');
	else
	{
		Disable('HearNoise');
		Disable('SeePlayer');
	}
	if (!bUpAndOut) // not water jump
	{	
		if (Region.Zone.bWaterZone)
		{
			SetPhysics(PHYS_Swimming);
			WhatToDoNext(NextState, NextLabel);
		}	
		if (!bJumpOffPawn)
			AdjustJump();
		else
			bJumpOffPawn = false;
PlayFall:
        PlayAnim('SpJump');
        FinishAnim();
        LoopAnim('SpMidAir');
//		TweenToFalling();
//		FinishAnim();
//		PlayInAir();
	}
	if (Physics != PHYS_Falling)
		Goto('Done');
	Sleep(2.0);
	Goto('LongFall');
}


///////////////////////////////// VICTORYDANCE ////////////////////////////////////////
//

state VictoryDance
{
ignores EnemyNotVisible; 

	function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, 
							Vector momentum, name damageType)
	{
		//TraceLog(class $ "[VictoryDance]", 10, "in TakeDamage(" $ Damage $ "," $ instigatedBy.name $ ", ...)");

		LastHitBy = instigatedBy;
		LastHitTime = Level.TimeSeconds;
		Global.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
		if (health <= 0)
			return;
		Enemy = instigatedBy;
		if (NextState == 'TakeHit')
		{
			NextState = 'Attacking'; //default
			NextLabel = 'Begin';
			GotoState('TakeHit'); 
		}
		else if (health > 0)
			WhatToDoNext('Attacking');
	}

	function EnemyAcquired()
	{
		//TraceLog(class $ "[VictoryDance]", 10, "in EnemyAcquired()");
		WhatToDoNext('Acquisition');
	}
	
Begin:
	//TraceLog(class $ "[VictoryDance]", 10, "at Begin:");
	Acceleration = vect(0,0,0);
	TweenToFighter(0.2);
	FinishAnim();
	PlayTurning();
	TurnToward(Target);
	DesiredRotation = rot(0,0,0);
	DesiredRotation.Yaw = Rotation.Yaw;
	setRotation(DesiredRotation);
	TweenToFighter(0.2);
	FinishAnim();
	PlayVictoryDance();
	FinishAnim(); 
	WhatToDoNext('','');
}


///////////////////////////////// FINDAIR ////////////////////////////////////////
//

state FindAir
{
ignores SeePlayer, HearNoise, Bump;

	function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, name damageType)
	{
		//TraceLog(class $ "[FindAir]", 10, "in TakeDamage(" $ Damage $ "," $ instigatedBy.name $ ", ...)");

		LastHitBy = instigatedBy;
		LastHitTime = Level.TimeSeconds;
		Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
		
		if (health <= 0)
			return;
		if (NextState == 'TakeHit')
		{
			NextState = 'FindAir'; 
			NextLabel = 'TakeHit';
			GotoState('TakeHit'); 
		}
	}

DoMove:
	//TraceLog(class $ "[FindAir]", 10, "at DoMove:");
	if (Enemy == None)
    {
    PlayRunning();
		MoveTo(Destination);
    }
	else
	{
		bCanFire = true;
		StrafeFacing(Destination, Enemy);	
	}
	WhatToDoNext('Attacking');
}

defaultproperties
{
     TurnCount=4
     PickupSightRadius=300.000000
     ScoreShootInterval=1.500000
     TimeBetweenAttacks=7.000000
     Aggressiveness=0.400000
     RefireRate=0.700000
     GroundSpeed=300.000000
}
