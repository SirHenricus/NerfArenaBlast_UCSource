//=============================================================================
// NerfChampScoreBoard
//
// Integrated by Wezo
//=============================================================================
class NerfChampScoreBoard extends NerfScoreBoard;

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
		if (( !PRI.bIsSpectator ) && (!PRI.bDead))
		{
// DSL - extend Player name info to include name of avatar
            if ( !PRI.bIsABot && (NBI != None) )
                PlayerNames[PlayerCount] = PRI.PlayerName$" ( as "$NBI.BotNames[PRI.BotIndex]$" )";
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
		if (PRI.bDead)
			continue;
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
}
