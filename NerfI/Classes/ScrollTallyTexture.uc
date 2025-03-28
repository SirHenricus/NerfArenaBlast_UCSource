class ScrollTallyTexture expands ClientScriptedTexture;

var() localized string LevelMessage;
var() sound NextLevelPA;
var() localized string BonusMessage;
var() sound BonusPA;
var() Font Font;
var() color FontColor;
var() int PixelsPerSecond;
var() int ScrollWidth;
var() float YPos;
var() int LevelToClear;
var() int BonusScore;
var() name BonusDoorTag;
var() sound Welcome;

var Trigger BonusDoor;
var string CurrentText;
var sound CurrentSound;
var int Position;
var string WelcomeStr;
var float LastDrawTime;
var PlayerPawn Player;
var bool bFlipFlag;			// true = we are flipping
var bool bFlipFlop;			// current state of flip if we are flipping
var bool bBonusFlag;		// need we contend with bonuses at all?
var bool bScrollFlag;		// true = we got something to say
var bool bAllClear;			// true = opening sounds have been done with
var int ixMax;				// total number of levels to include in bonus calc

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	bAllClear = false;				// welcoming msg hasn't been played yet
	SetTimer( 2.0, false );			// wake me when everyone's logged in
}


simulated function SetWelcomeStr()
{
	local string str;

	switch( Player.LastGameType )
	{
		case AIType_PointMatch:
			str = "pafplpb";		// assume winner
			if ( Player.LevelClear[LevelToClear] == 0 )
				str = "pafgtpb";
			break;
		case AIType_ArenaRace:
			str = "pafplsb";		// assume winner
			if ( Player.LevelClear[LevelToClear+1] == 0 )
				str = "pafgtsb";
			break;
		case AIType_ScavengerHunt:
			str = "pafplbb";		// assume winner
			if ( Player.LevelClear[LevelToClear+2] == 0 )
				str = "pafgtbb";
			break;
		default:
			str = "";
			break;
	}
	Player.SetLastGameType(AIType_None);
	if ( str != "" )
		WelcomeStr = "ReadyRoom."$str;
}


function bool CheckForBeginner()
{
    local bool bResult;
	local sound S;

    bResult = false;
    if ( Player.PlayerReplicationInfo.TeamType != TEAM_Twisters )
    {
        bResult = true;
        Player.ShowMenu();
        S = sound(DynamicLoadObject("ReadyRoom.paopen1", class'Sound'));
		if ( S != None ) PlaySound(S);
    }    

    return(bResult);
}

simulated function Timer()
{
	local PlayerPawn P;
	local sound S;
	local int ix, total;
    local bool bMenuTime;

	foreach AllActors(class'PlayerPawn', P)
		if(Viewport(P.Player) != None)
			Player = P;

// do we have someone to parse?
	if ( Player != None )
	{
		if ( bAllClear == false )			// has welcoming msg been played?
		{
			bAllClear = true;
// play welcoming message
			if ( Player.LastGameType == AIType_None )		// came from Plaza?
			{
                bMenuTime = CheckForBeginner();
                if ( !bMenuTime )
                {
    				if ( Welcome != None )
    					PlaySound(Welcome);
                }
			}
			else
			{
				SetWelcomeStr();							// else we need to calc which string
				if ( WelcomeStr != "" )
				{
					S = sound(DynamicLoadObject(WelcomeStr, class'Sound'));
					if ( S != None ) PlaySound(S);
				}
			}
//			SetTimer( 2.0, false );
//			return;
		}

// don't scroll message if level hasn't opened up
		bScrollFlag = true;
	    if ( LevelToClear > 0 && LevelToClear < 19 )
	    {       // all internal rr's have 3 arenas each
	        if ( (Player.LevelClear[LevelToClear] == 0)
	          || (Player.LevelClear[LevelToClear+1] == 0)
	          || (Player.LevelClear[LevelToClear+2] == 0) )
	            bScrollFlag = false;
	    }
	    else    // amateur or champion check only one arena
	    {
	        if ( Player.LevelClear[LevelToClear] == 0 )
				bScrollFlag = false;
	    }


		if ( BonusScore > 0 && BonusDoorTag != '' )
		{
			foreach AllActors( class'Trigger', BonusDoor, BonusDoorTag )
				break;
			if ( BonusDoor != None )
			{
// bonus door is available -- see if player qualifies
				total = 0.0;
				for ( ix = 0; ix < ixMax; ix++ )
					total += int(Player.LevelHighScore[ix]);

				if ( total >= BonusScore )
				{
					bBonusFlag = true;
					BonusDoor.bInitiallyActive = true;
				}
			}
		}

		if ( bScrollFlag )
		{
			CurrentText = LevelMessage;
			CurrentSound = NextLevelPA;
			bFlipFlop = false;
		}
		else if ( bBonusFlag )
		{
			CurrentText = BonusMessage;
			CurrentSound = BonusPA;
			bFlipFlop = true;
		}

		bFlipFlag = false;				// assume we are not flipping
		if ( bScrollFlag == true && bBonusFlag == true )
			bFlipFlag = true;			// else we is
	}
	else
		SetTimer( 2.0, false );			// keep plugging until we find the player
}


simulated event RenderTexture(ScriptedTexture Tex)
{
	local string Text;

// if nobody to brag on, take short cut
	if ( Player == None ) return;

// if nothing to scroll, take short cut
	if ( (bScrollFlag == false) && (bBonusFlag == false) ) return;

	if(LastDrawTime == 0)
		Position = Tex.USize;
	else
		Position -= (Level.TimeSeconds-LastDrawTime) * PixelsPerSecond;

// have we reached end of this scroll?
	if(Position < -ScrollWidth)
	{
		Position = Tex.USize;		// restarting...
		if ( bFlipFlag == true )	// are we alternating?
		{
			if ( bFlipFlop == false )
			{
				bFlipFlop = true;
				CurrentText = BonusMessage;
				CurrentSound = BonusPA;
			}
			else
			{
				bFlipFlop = false;
				CurrentText = LevelMessage;
				CurrentSound = NextLevelPA;
			}
		}

		if ( (CurrentSound != None) && (bAllClear == true) )
			PlaySound( CurrentSound );
	}

	LastDrawTime = Level.TimeSeconds;
	Tex.DrawColoredText( Position, YPos, CurrentText, Font, FontColor );
}

defaultproperties
{
     ixMax=19
}
