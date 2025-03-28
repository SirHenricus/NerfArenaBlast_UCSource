//=============================================================================
// NerfTeamScoreBoard
//=============================================================================
class NerfTeamScoreBoard extends NerfScoreBoard;

var int PlayerCounts[8];
var localized string TeamName[8];
var() color TeamColor[8];
var() color AltTeamColor[8];
var localized float TeamTotalScore[8];

function ShowIcons( canvas Canvas, bool LowRes )
{
    SportsCast();
}

function DrawName( canvas Canvas, int I, float XOffset, int LoopCount )
{
	local float YOffset;

	switch (Teams[I])
	{
		case 0:
		case 1: YOffset = Canvas.ClipY/6 + (LoopCount * 16); 
				break;
		case 2:
		case 3: YOffset = Canvas.ClipY/6 * 2 + (LoopCount * 16);
				break;
		case 4:
		case 5: YOffset = Canvas.ClipY/6 * 3 + (LoopCount * 16);
				break;
		case 6:
		case 7: YOffset = Canvas.ClipY/6 * 4 + (LoopCount * 16);
				break;
	}

	Canvas.SetPos(XOffset, YOffset);
	Canvas.DrawText(PlayerNames[I], false);
}

function DrawPing( canvas Canvas, int I, float XOffset, int LoopCount )
{
	local float XL, YL;
	local float YOffset;

	if (Level.Netmode == NM_Standalone)
		return;

	switch (Teams[I])
	{
		case 0:
		case 1:	YOffset = Canvas.ClipY/6 + (LoopCount * 16);
				break;
		case 2:
		case 3:	YOffset = Canvas.ClipY/6 * 2 + (LoopCount * 16);
				break;
		case 4:
		case 5:	YOffset = Canvas.ClipY/6 * 3 + (LoopCount * 16);
				break;
		case 6:
		case 7:	YOffset = Canvas.ClipY/6 * 4 + (LoopCount * 16);
				break;
	}

	Canvas.StrLen(Pings[I], XL, YL);
	Canvas.SetPos(XOffset - XL - 8, YOffset);
	Canvas.Font = Font(DynamicLoadObject("NerfRes.TinyWhiteFont", class'Font'));
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
	Canvas.DrawText(Pings[I], false);
	Canvas.Font = Font(DynamicLoadObject("NerfRes.WhiteFont", class'Font'));
}

function DrawScore( canvas Canvas, int I, float XOffset, int LoopCount )
{
	local float XL, YL;
	local float YOffset;

	switch (Teams[I])
	{
		case 0:
			XOffset = Canvas.ClipX/2 - Canvas.ClipX/8;
			YOffset = Canvas.ClipY/6 + (LoopCount * 16);
			break;
		case 1:
			XOffset = Canvas.ClipX - Canvas.ClipX/8;
			YOffset = Canvas.ClipY/6 + (LoopCount * 16);
			break;
		case 2:
			XOffset = Canvas.ClipX/2 - Canvas.ClipX/8;
			YOffset = Canvas.ClipY/6 * 2 + (LoopCount * 16);
			break;
		case 3:
			XOffset = Canvas.ClipX - Canvas.ClipX/8;
			YOffset = Canvas.ClipY/6 * 2 + (LoopCount * 16);
			break;
		case 4:
			XOffset = Canvas.ClipX/2 - Canvas.ClipX/8;
			YOffset = Canvas.ClipY/6 * 3 + (LoopCount * 16);
			break;
		case 5:
			XOffset = Canvas.ClipX - Canvas.ClipX/8;
			YOffset = Canvas.ClipY/6 * 3 + (LoopCount * 16);
			break;
		case 6:
			XOffset = Canvas.ClipX/2- Canvas.ClipX/8;
			YOffset = Canvas.ClipY/6 * 4 + (LoopCount * 16);
			break;
		case 7:
			XOffset = Canvas.ClipX - Canvas.ClipX/8;
			YOffset = Canvas.ClipY/6 * 4 + (LoopCount * 16);
			break;
	}

	Canvas.StrLen(Scores[I], XL, YL);
	XOffset -= XL;
	Canvas.SetPos(XOffset, YOffset);

	if(Scores[I] >= 100.0)
		Canvas.CurX -= 6.0;
	if(Scores[I] >= 10.0)
		Canvas.CurX -= 6.0;
	if(Scores[I] < 0.0)
		Canvas.CurX -= 6.0;
	Canvas.DrawText(int(Scores[I]), false);
}

function ShowScores( canvas Canvas )
{
	local PlayerReplicationInfo PRI;
	local int PlayerCount, I, XOffset;
	local int LoopCountTeam[8];
	local float XL, YL, YOffset;
	local TeamInfo TI;

	Canvas.Font = RegFont;

	// Header
	DrawHeader(Canvas);

	// Trailer
	DrawTrailer(Canvas);

	for ( I=0; I<16; I++ )
		Scores[I] = -500;

	for ( I=0; I<8; I++ )
	{
		PlayerCounts[I] = 0;
		TeamTotalScore[I] = 0;
	}

	PlayerCount = 0;
	foreach AllActors (class'PlayerReplicationInfo', PRI)
		if ( !PRI.bIsSpectator )
		{
			if (PlayerCount >= 16)
				break;

			PlayerNames[PlayerCount] = PRI.PlayerName;
			TeamNames[PlayerCount] = PRI.TeamName;
			Scores[PlayerCount] = PRI.Score;
			Teams[PlayerCount] = PRI.Team;
			Pings[PlayerCount] = PRI.Ping;
			SkinIcons[PlayerCount] = PRI.SkinIcon;

			TeamTotalScore[PRI.Team] += PRI.Score;

			PlayerCount++;
			PlayerCounts[PRI.Team]++;
		}
	SortScores(PlayerCount);

	foreach AllActors(class'TeamInfo', TI)
	{
		TI.Score = TeamTotalScore[TI.TeamIndex];

		if (PlayerCounts[TI.TeamIndex] > 0)
		{
			if ( TI.TeamIndex % 2 == 1 )
				XOffset = Canvas.ClipX/8 + Canvas.ClipX/2;
			else
				XOffset = Canvas.ClipX/8;

			switch (TI.TeamIndex)
			{
				case 0:
				case 1: YOffset = Canvas.ClipY/6 - 16; 
						break;
				case 2:
				case 3: YOffset = Canvas.ClipY/6 * 2 -16;
						break;
				case 4:
				case 5: YOffset = Canvas.ClipY/6 * 3 -16;
						break;
				case 6:
				case 7: YOffset = Canvas.ClipY/6 * 4 -16;
						break;
			}

			Canvas.DrawColor = TeamColor[TI.TeamIndex];
			Canvas.SetPos(XOffset, YOffset);
			Canvas.StrLen(TeamName[TI.TeamIndex], XL, YL);
			Canvas.DrawText(TeamName[TI.TeamIndex], false);
			Canvas.SetPos(XOffset + XL, YOffset);
			Canvas.DrawText(int(TI.Score), false);
		}
	}

	for ( I=0; I<PlayerCount; I++ )
	{
		if ( Teams[I] % 2 == 1 )
			XOffset = Canvas.ClipX/8 + Canvas.ClipX/2;
		else
			XOffset = Canvas.ClipX/8;
		Canvas.DrawColor = AltTeamColor[Teams[I]];

		// Player name
		DrawName( Canvas, I, XOffset, LoopCountTeam[Teams[I]] );

		// Player ping
		DrawPing( Canvas, I, XOffset, LoopCountTeam[Teams[I]] );

		// Player score
		Canvas.DrawColor = TeamColor[Teams[I]];
		DrawScore( Canvas, I, XOffset, LoopCountTeam[Teams[I]] );

		LoopCountTeam[Teams[I]]++;
	}

	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
}

function ShowTeamScores( canvas Canvas )
{
	local PlayerReplicationInfo PRI;
	local int PlayerCount, I, XOffset;
	local int LoopCountTeam[8];
	local float XL, YL, YOffset;
	local TeamInfo TI;

	Canvas.Font = RegFont;

	for ( I=0; I<16; I++ )
		Scores[I] = -500;

	for ( I=0; I<8; I++ )
	{
		PlayerCounts[I] = 0;
		TeamTotalScore[I] = 0;
	}

	PlayerCount = 0;
	foreach AllActors (class'PlayerReplicationInfo', PRI)
		if ( !PRI.bIsSpectator )
		{
			if (PlayerCount >= 16)
				break;

			PlayerNames[PlayerCount] = PRI.PlayerName;
			TeamNames[PlayerCount] = PRI.TeamName;
			Scores[PlayerCount] = PRI.Score;
			Teams[PlayerCount] = PRI.Team;
			Pings[PlayerCount] = PRI.Ping;
			SkinIcons[PlayerCount] = PRI.SkinIcon;

			TeamTotalScore[PRI.Team] += PRI.Score;

			PlayerCount++;
			PlayerCounts[PRI.Team]++;
		}
	SortScores(PlayerCount);

	foreach AllActors(class'TeamInfo', TI)
	{
		TI.Score = TeamTotalScore[TI.TeamIndex];
	}

	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
}

defaultproperties
{
     TeamName(0)=Twister Team: 
     TeamName(1)=Tycoon Team: 
     TeamName(2)=Asteroid Team: 
     TeamName(3)=Sequoia Team: 
     TeamName(4)=Luna Team: 
     TeamName(5)=Barracuda Team: 
     TeamName(6)=Orbital Team: 
     TeamName(7)=Gator Team: 
     TeamColor(0)=(R=255)
     TeamColor(1)=(G=255)
     TeamColor(2)=(B=255)
     TeamColor(3)=(R=255,G=255)
     TeamColor(4)=(R=255,B=255)
     TeamColor(5)=(G=255,B=255)
     TeamColor(6)=(R=255,G=255,B=255)
     TeamColor(7)=(R=128,G=128,B=128)
     AltTeamColor(0)=(R=128)
     AltTeamColor(1)=(G=128)
     AltTeamColor(2)=(B=128)
     AltTeamColor(3)=(R=128,G=128)
     AltTeamColor(4)=(R=128,B=128)
     AltTeamColor(5)=(G=128,B=128)
     AltTeamColor(6)=(R=128,G=128,B=128)
     AltTeamColor(7)=(R=255,G=255,B=255)
}
