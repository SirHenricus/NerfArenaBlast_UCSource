//=============================================================================
// NerfScoreBoard
//
// Integrated by Wezo
//=============================================================================
class NerfScoreBoard extends ScoreBoard;

var string PlayerNames[16];
var string TeamNames[16];
var float Scores[16];
var byte Teams[16];
var int Pings[16];
var texture SkinIcons[16];
var NerfBotInfo NBI;

////////////////////
// DSL added for Sportscaster VO
var VoxBox      myVox;
var EBotIndex   ixLastLeader;
var EBotIndex   ixLeader[16];
var float       fLastCast;
var bool		bFirstPass;

replication
{
    reliable if ( Role < ROLE_Authority )
        ixLastLeader, ixLeader;
}


function PostBeginPlay()
{
// find a way to talk
	RegFont = Font(DynamicLoadObject("NerfRes.WhiteFont", class'Font'));
    foreach AllActors( class 'VoxBox', myVox )
        break;
	bFirstPass = true;			// don't make an announcement at start up
    Super.PostBeginPlay();
}

function SportsCast()
{
    if ( Level.NetMode != NM_Client )
    {
		if ( bFirstPass )					// first time through?
		{
			bFirstPass = false;				// yes, don't announce
			ixLastLeader = ixLeader[0];
		}
        else if ( ixLeader[0] != ixLastLeader )
        {
            ixLastLeader = ixLeader[0];
//BroadcastMessage( "SC: New Leader is "$ixLastLeader );
            myVox.VJNewLeader(ixLeader[0]);
        }
    }
}

// end of DSL Sportscaster section
// (except for a few insertions in ShowScores() below)
////////////////////

function DrawHeader( canvas Canvas )
{
	local GameReplicationInfo GRI;
	local float XL, YL;

	if (Canvas.ClipX > 500)
	{
		foreach AllActors(class'GameReplicationInfo', GRI)
		{
			Canvas.bCenter = true;

			Canvas.SetPos(0.0, 32);
			Canvas.StrLen("TEST", XL, YL);
			if (Level.Netmode != NM_StandAlone)
				Canvas.DrawText(GRI.ServerName);
			Canvas.SetPos(0.0, 32 + YL);
//			Canvas.DrawText("Game Type: "$GRI.GameName, true);
			Canvas.SetPos(0.0, 32 + 2*YL);
			Canvas.DrawText("Map Title: "$Level.Title, true);
			Canvas.SetPos(0.0, 32 + 3*YL);
			Canvas.DrawText("Author: "$Level.Author, true);
			Canvas.SetPos(0.0, 32 + 4*YL);
			if (Level.IdealPlayerCount != "")
				Canvas.DrawText("Ideal Player Load:"$Level.IdealPlayerCount, true);

			Canvas.bCenter = false;
		}
	}
}

function DrawTrailer( canvas Canvas )
{
	local int Hours, Minutes, Seconds;
	local string HourString, MinuteString, SecondString;
	local float XL, YL;

//##nerf WES 
// NO Elapsed Time: Sucker!!
/*
	if (Canvas.ClipX > 500)
	{
		Seconds = int(Level.TimeSeconds);
		Minutes = Seconds / 60;
		Hours   = Minutes / 60;
		Seconds = Seconds - (Minutes * 60);
		Minutes = Minutes - (Hours * 60);

		if (Seconds < 10)
			SecondString = "0"$Seconds;
		else
			SecondString = string(Seconds);

		if (Minutes < 10)
			MinuteString = "0"$Minutes;
		else
			MinuteString = string(Minutes);

		if (Hours < 10)
			HourString = "0"$Hours;
		else
			HourString = string(Hours);

		Canvas.bCenter = true;
		Canvas.StrLen("Test", XL, YL);
		Canvas.SetPos(0, Canvas.ClipY - YL);
		Canvas.DrawText("Elapsed Time: "$HourString$":"$MinuteString$":"$SecondString, true);
		Canvas.bCenter = false;
	}
*/
	if ((Pawn(Owner) != None) && (Pawn(Owner).Health <= 0))
	{
		Canvas.bCenter = true;
		Canvas.StrLen("Test", XL, YL);
		Canvas.SetPos(0, Canvas.ClipY - YL*7);  // DSL - raised from YL*6
		Canvas.DrawColor.R = 0;
		Canvas.DrawColor.G = 255;
		Canvas.DrawColor.B = 0;
//		Canvas.DrawText("You are dead.  Hit [Fire] to respawn!", true);
		Canvas.DrawText("Your energy is gone! Hit [Fire] to recharge!", true); // DSL rewrite
		Canvas.bCenter = false;
	}
}

function DrawName( canvas Canvas, int I, float XOffset, int LoopCount )
{
	local int Step;

	if (Canvas.ClipX >= 640)
		Step = 16;
	else
		Step = 8;

	Canvas.SetPos(Canvas.ClipX/4, Canvas.ClipY/4 + (LoopCount * Step));
	Canvas.DrawText(PlayerNames[I], false);
}

function DrawPing( canvas Canvas, int I, float XOffset, int LoopCount )
{
	local float XL, YL;
	local int Step;

	if (Canvas.ClipX >= 640)
		Step = 16;
	else
		Step = 8;

	if (Level.Netmode == NM_Standalone)
		return;

	Canvas.StrLen(Pings[I], XL, YL);
	Canvas.SetPos(Canvas.ClipX/4 - XL - 8, Canvas.ClipY/4 + (LoopCount * Step));
	Canvas.Font = Font(DynamicLoadObject("NerfRes.TinyWhiteFont", class'Font'));
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
	Canvas.DrawText(Pings[I], false);
	Canvas.Font = RegFont;
	Canvas.DrawColor.R = 0;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 0;
}

function DrawScore( canvas Canvas, int I, float XOffset, int LoopCount )
{
	local int Step;

	if (Canvas.ClipX >= 640)
		Step = 16;
	else
		Step = 8;

	Canvas.SetPos(Canvas.ClipX/4 * 3, Canvas.ClipY/4 + (LoopCount * Step));

	if(Scores[I] >= 100.0)
		Canvas.CurX -= 6.0;
	if(Scores[I] >= 10.0)
		Canvas.CurX -= 6.0;
	if(Scores[I] < 0.0)
		Canvas.CurX -= 6.0;
	Canvas.DrawText(int(Scores[I]), false);
}

function Swap( int L, int R )
{
	local string TempPlayerName, TempTeamName;
	local float TempScore;
	local byte TempTeam;
	local int TempPing;
	local texture TempSkinIcon;
    local EBotIndex TempIndex;

	TempPlayerName = PlayerNames[L];
	TempTeamName = TeamNames[L];
	TempScore = Scores[L];
	TempTeam = Teams[L];
	TempPing = Pings[L];
	TempSkinIcon = SkinIcons[L];
    TempIndex = ixLeader[L];
	
	PlayerNames[L] = PlayerNames[R];
	TeamNames[L] = TeamNames[R];
	Scores[L] = Scores[R];
	Teams[L] = Teams[R];
	Pings[L] = Pings[R];
	SkinIcons[L] = SkinIcons[R];
    ixLeader[L] = ixLeader[R];
	
	PlayerNames[R] = TempPlayerName;
	TeamNames[R] = TempTeamName;
	Scores[R] = TempScore;
	Teams[R] = TempTeam;
	Pings[R] = TempPing;
	SkinIcons[R] = TempSkinIcon;
    ixLeader[R] = TempIndex;
}

function SortScores(int N)
{
	local int I, J, Max;
	
	for ( I=0; I<N-1; I++ )
	{
		Max = I;
		for ( J=I+1; J<N; J++ )
			if (Scores[J] > Scores[Max])
				Max = J;
		Swap( Max, I );
	}
}

function ShowScores( canvas Canvas )
{
	local PlayerReplicationInfo PRI;
	local int PlayerCount, LoopCount, I;
	local float XL, YL, Marg;

	local string CurrentURL;
	local int levelslot;


	Canvas.Font = Font(DynamicLoadObject("NerfRes.WhiteFont", class'Font'));

	// Header
	DrawHeader(Canvas);

	// Trailer
	DrawTrailer(Canvas);

	// Wipe everything.
	for ( I=0; I<16; I++ )
	{
		Scores[I] = -500;
	}

	Canvas.DrawColor.R = 0;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 0;

// DSL - see if we can get access to native bot names
    if ( NBI == None )
    {
        foreach AllActors( class'NerfBotInfo', NBI )
            break;
    }

	foreach AllActors (class'PlayerReplicationInfo', PRI)
		if ( !PRI.bIsSpectator )
		{
// DSL - extend Player name info to include name of avatar
            if ( !PRI.bIsABot && (NBI != None) )
                PlayerNames[PlayerCount] = PRI.PlayerName$" ("$NBI.BotNames[PRI.BotIndex]$")";
            else
    			PlayerNames[PlayerCount] = PRI.PlayerName;

			TeamNames[PlayerCount] = PRI.TeamName;
			Scores[PlayerCount] = PRI.Score;
			Teams[PlayerCount] = PRI.Team;
			Pings[PlayerCount] = PRI.Ping;
		    	SkinIcons[PlayerCount] = PRI.SkinIcon;

			PlayerCount++;
		}
	
	SortScores(PlayerCount);
	
	LoopCount = 0;
	
	for ( I=0; I<PlayerCount; I++ )
	{
		// Player name
		DrawName(Canvas, I, 0, LoopCount);
		
		// Player ping
		DrawPing(Canvas, I, 0, LoopCount);

		// Player score
		DrawScore(Canvas, I, 0, LoopCount);
	
		LoopCount++;
	}

	if (Level.NetMode == NM_StandAlone)
	{
		CurrentURL=Level.GetLocalURL();
		if (CurrentURL != "")
			CurrentURL = Left( CurrentURL, InStr(CurrentURL,"."));
		
		switch(CurrentURL)
		{
				case "PM-Amateur"	:	levelslot=0;
										break;
				case "PM-Sequoia"	:	levelslot=1;
										break;
				case "AR-Sequoia"	:	levelslot=2;
										break;
				case "SH-Sequoia"	:	levelslot=3;
										break;
				case "PM-Orbital"	:	levelslot=4;
										break;
				case "AR-Orbital"	:	levelslot=5;
										break;
				case "SH-Orbital"	:	levelslot=6;
										break;
				case "PM-Barracuda"	:	levelslot=7;
										break;
				case "AR-Barracuda"	:	levelslot=8;
										break;
				case "SH-Barracuda"	:	levelslot=9;
										break;
				case "PM-Asteroid"	:	levelslot=10;
										break;
				case "AR-Asteroid"	:	levelslot=11;
										break;
				case "SH-Asteroid"	:	levelslot=12;
										break;
				case "PM-Sky"		:	levelslot=13;
										break;
				case "AR-Sky"		:	levelslot=14;
										break;
				case "SH-Sky"		:	levelslot=15;
										break;
				case "PM-Luna"		:	levelslot=16;
										break;
				case "AR-Luna"		:	levelslot=17;
										break;
				case "SH-Luna"		:	levelslot=18;
										break;
				case "PM-Champion"	:	levelslot=19;
										break;
		}		

	Canvas.CurX = Canvas.ClipX/2 - 96;
	Canvas.CurY = Canvas.ClipY - 48;
	Canvas.DrawText("Level High Score is ", false);
	Canvas.CurY = Canvas.ClipY - 48;

	Canvas.DrawText(int(PlayerPawn(Owner).LevelHighScore[levelslot]), false);

	Canvas.CurX = Canvas.ClipX/2 - 96;
	Canvas.CurY = Canvas.ClipY - 32;
	Canvas.DrawText("Your Total Score is ", false);
	Canvas.CurY = Canvas.ClipY - 32;
	Canvas.DrawText(int(PlayerPawn(Owner).TotalScore), false);
	}


    Canvas.DrawColor.R = 255;
    Canvas.DrawColor.G = 255;
    Canvas.DrawColor.B = 255;
}

//##nerf WES
// Show Icons function
function ShowIcons( canvas Canvas, bool LowRes )
{
	local PlayerReplicationInfo PRI;
	local int PlayerCount, LoopCount, I, NumIcon;
	local float XL, YL, ResScale;
	local int TmpYLocation;

	// Wipe everything.
	for ( I=0; I<16; I++ )
	{
		Scores[I] = -500;
		SkinIcons[I] = None;
	}

	foreach AllActors (class'PlayerReplicationInfo', PRI)
	{
		PlayerNames[PlayerCount] = PRI.PlayerName;
		TeamNames[PlayerCount] = PRI.TeamName;
		Scores[PlayerCount] = PRI.Score;
		Teams[PlayerCount] = PRI.Team;
		Pings[PlayerCount] = PRI.Ping;
		SkinIcons[PlayerCount] = PRI.SkinIcon;
// DSL Sportscaster
        ixLeader[PlayerCount] = PRI.BotIndex;
		PlayerCount++;
	}
	
	SortScores(PlayerCount);



// DSL pointlimit reached?	
    if ( Level.NetMode != NM_Client )
    {
        if ( Level.Game != None )
        {
            if ( DeathMatchGame(Level.Game).bGameInProgress == true  
              && DeathMatchGame(Level.Game).FragLimit > 0 )     // lookin' for points?
            {
                if ( Scores[0] >= DeathMatchGame(Level.Game).FragLimit )
                    Level.Game.CeasePlay();
            }
        }
    }

	if (LowRes)
	{
		ResScale = 0.5;
		NumIcon = 4;
	}
	else
	{
		ResScale = 1.0;
		NumIcon = 6;
	}

	Canvas.CurX = 0;
	Canvas.CurY = 40;

	for ( I=0; I<NumIcon; I++ )
	{
		if (SkinIcons[i] != None)
		{
			Canvas.Style = 2;	
			Canvas.DrawColor.R = 255;
			Canvas.DrawColor.G = 255;
			Canvas.DrawColor.B = 255;
			TmpYLocation = Canvas.CurY;
			Canvas.DrawIcon(SkinIcons[i], ResScale);

//##nerf WES FIXME
// This is just a chessy check. It will fail when 2 or more player use the same name.
// We might use the user id card # to check it.

			if ((Pawn(Owner).PlayerReplicationInfo.PlayerName == PlayerNames[i]) &&
				(Pawn(Owner).PlayerReplicationInfo.Score == Scores[i]))
			{
				Canvas.SetPos(Canvas.CurX, Canvas.CurY+2);
				Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.I_Marker", class'Texture')), ResScale);
			}

			Canvas.CurX = 0;
			if (LowRes)
				Canvas.CurY = TmpYLocation - 4;
			else
				Canvas.CurY = TmpYLocation + 12;
			Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.IconScore", class'Texture')), 1);
			Canvas.CurY = TmpYLocation;
			
			Canvas.CurX = 30;
			Canvas.CurY +=30*ResScale;
			Canvas.Font = Font'Engine.SmallFont';
			Canvas.DrawText(int(Scores[i]), false);

			Canvas.CurX=0;
			Canvas.CurY+=10*ResScale;
			Canvas.Style = 1;

		}
	}
    SportsCast();
}

defaultproperties
{
     ixLastLeader=AKA_None
}
