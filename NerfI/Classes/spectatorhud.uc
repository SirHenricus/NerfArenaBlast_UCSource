//=============================================================================
// SpectatorHud.
//
// Integrated by
//=============================================================================
class SpectatorHud extends NerfHUD;

simulated function PostRender( canvas Canvas )
{
	local float StartX;

	HUDSetup(canvas);

	if ( PlayerPawn(Owner) != None )
	{
		if ( PlayerPawn(Owner).bShowMenu  )
		{
			DisplayMenu(Canvas);
			return;
		}
		if ( PlayerPawn(Owner).bShowScores )
		{
			if ( (PlayerPawn(Owner).Scoring == None) && (PlayerPawn(Owner).ScoringType != None) )
				PlayerPawn(Owner).Scoring = Spawn(PlayerPawn(Owner).ScoringType, PlayerPawn(Owner));
			if ( PlayerPawn(Owner).Scoring != None )
			{ 
				PlayerPawn(Owner).Scoring.ShowScores(Canvas);
				return;
			}
		}
		else if ( PlayerPawn(Owner).ProgressTimeOut > Level.TimeSeconds )
			DisplayProgressMessage(Canvas);
	}
	if (Canvas.ClipY<290) Return;

	Canvas.Style = ERenderStyle.STY_Normal;
	StartX = 0.5 * Canvas.ClipX - 128;
	Canvas.SetPos(StartX,Canvas.ClipY-52);
	Canvas.DrawIcon(texture(DynamicLoadObject("NerfRes.NerfLogo2", class'Texture')), 1.0);	
	Canvas.Style = 1;
}

defaultproperties
{
}
