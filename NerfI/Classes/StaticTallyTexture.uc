class StaticTallyTexture expands ClientScriptedTexture;

var() Font Font;
var() color FontColor;
var() float YPos[3];
var() float XPos[2];
var() int LevelToClear;
var PlayerPawn Player;
var string PBTally;
var string SBTally;
var string BBTally;
var string PBPlace;
var string SBPlace;
var string BBPlace;


simulated function PostBeginPlay()
{
	Super.PreBeginPlay();
	SetTimer( 2.0, false );
}


simulated function Timer()
{
	local PlayerPawn P;

	foreach AllActors(class'PlayerPawn', P)
		if(Viewport(P.Player) != None)
			Player = P;

// if we found Player, get his or her scores
	if ( Player != None )
	{
// all ReadyRooms have at least PointBlast
	    PBTally = string(int(Player.LevelHighScore[LevelToClear]));    
		PBPlace = Player.LevelRank[LevelToClear];

// if not Amateur or Championship, level has SpeedBlast and BallBlast as well
		if ( (LevelToClear > 0) && (LevelToClear < 19) )
		{
		    SBTally = string(int(Player.LevelHighScore[LevelToClear+1]));    
			SBPlace = Player.LevelRank[LevelToClear+1];
			BBTally = string(int(Player.LevelHighScore[LevelToClear+2]));    
			BBPlace = Player.LevelRank[LevelToClear+2];
		}
	}
	else			// keep looking until we have a player
		SetTimer( 2.0, false );
}


simulated event RenderTexture(ScriptedTexture Tex)
{
// if nobody to brag on yet, take short cut
	if ( Player == None ) return;

	Tex.DrawColoredText( XPos[0], YPos[0], PBTally, Font, FontColor );
	Tex.DrawColoredText( XPos[1], YPos[0], PBPlace, Font, FontColor );

// if we are not amateur or champion (or, gasp, beyond), do other game types
	if ( (LevelToClear != 0) && (LevelToClear < 19) )
	{
		Tex.DrawColoredText( XPos[0], YPos[1], SBTally, Font, FontColor );
		Tex.DrawColoredText( XPos[1], YPos[1], SBPlace, Font, FontColor );

		Tex.DrawColoredText( XPos[0], YPos[2], BBTally, Font, FontColor );
		Tex.DrawColoredText( XPos[1], YPos[2], BBPlace, Font, FontColor );
	}
}

defaultproperties
{
     YPos(0)=140.000000
     YPos(1)=165.000000
     YPos(2)=190.000000
     XPos(0)=1.000000
     XPos(1)=105.000000
}
