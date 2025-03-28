//=============================================================================
// NerfArenaRaceHUD
// Parent class of heads up display
//
// Integrated by Wezo
//=============================================================================
class NerfArenaRaceHUD extends NerfHUD;

simulated function PostRender( canvas Canvas )
{
	local Inventory Inv;

// courtesy of DSL's intrusion below
    local string WinnerMsg;
	local float XL, YL;

	HUDSetup(canvas);
	
    if (bRaceWinner)
    {
        WinnerMsg = "WINNER";
    	Canvas.bCenter = false;
    	Canvas.Font = Canvas.LargeFont;
    	Canvas.StrLen(WinnerMsg, XL, YL);
	    Canvas.SetPos(Canvas.ClipX/2 - XL/2, Canvas.ClipY/2 - YL/2);
    	Canvas.DrawText(WinnerMsg, false);
        if (Winner != "")
        {
            Canvas.Font = Canvas.MedFont;					// LargeFont doesn't have lower case
            Canvas.StrLen(WinnerMsg, XL, YL);
            Canvas.SetPos(Canvas.ClipX/2 - XL/2, (Canvas.ClipY/2 - YL/2) + 40);
            Canvas.DrawText(Winner, false);
        }
    }

	Super.PostRender(Canvas);
}

function DrawClock( canvas Canvas )
{
	if (Level.NetMode != NM_DedicatedServer)
	{
		DrawFlag(Canvas);		
		return;
	}
}

simulated function DrawFlag(Canvas Canvas)
{
	local int FlagStartX, FlagStartY;

	FlagStartX = Canvas.ClipX/2 - 128*ResScale;
	FlagStartY = Canvas.ClipY - 32*ResScale;
	Canvas.Style = 2;
	Canvas.SetPos(FlagStartX,FlagStartY);
	Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.Flagoff", class'Texture')), ResScale);
	DrawHLFlag(Canvas, FlagStartX, FlagStartY);
}

simulated function DrawHLFlag(Canvas Canvas, int X, int Y)
{
	local Inventory Inv;
	local int i;
	
	Canvas.CurY = Y;

	Canvas.Style = 2;
	for (i=0; i<=Pawn(Owner).RFNum; i++)
	{
		Canvas.CurX = X + 18*ResScale + (32*i*ResScale);
		switch (i)
		{
			case 0: Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.BFlagHold", class'Texture')),ResScale);
					break;
			case 1: Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.GFlagHold", class'Texture')),ResScale);
					break;
			case 2: Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.YFlagHold", class'Texture')),ResScale);
					break;
			case 3: Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.OFlagHold", class'Texture')),ResScale);
					break;
			case 4: Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.RFlagHold", class'Texture')),ResScale);
					break;
			case 5: Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.PFlagHold", class'Texture')),ResScale);
					break;
			case 6: Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.GOFlagHold", class'Texture')),ResScale);
					break;
			default: break;
			
		}

	}
//	Canvas.CurX = X + (36*Pawn(Owner).RFNum*ResScale);
	Canvas.CurX = X + 10*ResScale + (32*Pawn(Owner).RFNum*ResScale);
	switch(Pawn(Owner).RFNum)
	{
		case 0: Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.BFlagon", class'Texture')),ResScale);
				break;
		case 1: Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.GFlagon", class'Texture')),ResScale);
				break;
		case 2: Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.YFlagon", class'Texture')),ResScale);
				break;
		case 3: Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.OFlagon", class'Texture')),ResScale);
				break;
		case 4: Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.RFlagon", class'Texture')),ResScale);
				break;
		case 5: Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.PFlagon", class'Texture')),ResScale);
				break;
		case 6: Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.GOFlagon", class'Texture')),ResScale);
				break;
		case 7: Canvas.CurX = X + 8;
				Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.BFlagon", class'Texture')),ResScale);
				break;
	}
	Canvas.Style = 1;
}

defaultproperties
{
}
