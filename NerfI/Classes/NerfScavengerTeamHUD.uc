//=============================================================================
// NerfScavengerTeamHUD
//=============================================================================
class NerfScavengerTeamHUD extends NerfTeamHUD;

function DrawClock( canvas Canvas )
{
	if (Level.NetMode != NM_DedicatedServer)
	{
		DrawSHBall(Canvas);		
		return;
	}
}

simulated function DrawSHBall(Canvas Canvas)
{
	local int BallStartX, BallStartY;

	BallStartX = Canvas.ClipX/2 - 128*ResScale;
	BallStartY = Canvas.ClipY - 32*ResScale;
	Canvas.Style = 2;
	Canvas.SetPos(BallStartX,BallStartY);
	Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.Balloff", class'Texture')), ResScale);
	Canvas.Style = 1;
	DrawHLBall(Canvas, BallStartX, BallStartY);
}

simulated function DrawHLBall(Canvas Canvas, int X, int Y)
{
	local Inventory Inv;
	local int i;
	
	Canvas.CurY = Y;

	Canvas.Style = 2;

//##nerf WES 
// i started at 1 is because the Blue Ball sequence is 1. 
// Sequence 0 is the parent class SHBallpick which you can never pickup in the level.
	
	for (i = 1; i < 8; i++) 
	{
		if (Pawn(Owner).IsHoldingBall(i))
		{
			Canvas.CurX = X + 16*ResScale + (32*ResScale*(i-1));
			switch(i)
			{
				case 1: Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.BBallHold", class'Texture')), ResScale);
						break;
				case 2: Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.GBallHold", class'Texture')), ResScale);
						break;
				case 3: Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.YBallHold", class'Texture')), ResScale);
						break;
				case 4: Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.OBallHold", class'Texture')), ResScale);
						break;
				case 5: Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.RBallHold", class'Texture')), ResScale);
						break;
				case 6: Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.PBallHold", class'Texture')), ResScale);
						break;
				case 7: Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.GOBallHold", class'Texture')), ResScale);
						break;
			}
		}
		else if (Pawn(Owner).HasDepositedBall(i))
		{
			Canvas.CurX = X + 16*ResScale + (32*ResScale*(i-1));
			switch(i)
			{
				case 1: Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.BBallon", class'Texture')),ResScale);
						break;
				case 2: Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.GBallon", class'Texture')),ResScale);
						break;
				case 3: Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.YBallon", class'Texture')),ResScale);
						break;
				case 4: Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.OBallon", class'Texture')),ResScale);
						break;
				case 5: Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.RBallon", class'Texture')),ResScale);
						break;
				case 6: Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.PBallon", class'Texture')),ResScale);
						break;
				case 7: Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.GOBallon", class'Texture')),ResScale);
						break;
			}
		}
	}
	Canvas.Style = 1;
}

defaultproperties
{
}
