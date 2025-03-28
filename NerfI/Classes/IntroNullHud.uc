//=============================================================================
// IntroNullHud.
//
// Integrated by Wezo
//=============================================================================
class IntroNullHud extends NerfHUD;

var() localized string ESCMessage;

simulated function DrawMOTD(canvas Canvas);

simulated function PostRender( canvas Canvas )
{
	local float StartX;

	HUDSetup(canvas);

	if ( (PlayerPawn(Owner) != None) && PlayerPawn(Owner).bShowMenu  )
	{
		DisplayMenu(Canvas);
		return;
	}
	else if ( PlayerPawn(Owner).ProgressTimeOut > Level.TimeSeconds )
		DisplayProgressMessage(Canvas);

	Canvas.Font = Canvas.MedFont;
	Canvas.SetPos(Canvas.ClipX/2.0-66,4);	
	Canvas.DrawText(ESCMessage, False);	

	if (Canvas.ClipX>790)
	{
		Canvas.SetPos(0,Canvas.ClipY-128);
		Canvas.DrawIcon(texture(DynamicLoadObject("NerfRes.VMI", class'Texture')), 1.0);		
		Canvas.SetPos(0,Canvas.ClipY-256);
		Canvas.DrawIcon(texture(DynamicLoadObject("NerfRes.NerfLogo", class'Texture')), 1.0);			
	}	
	else if (Canvas.ClipX>390)
	{
		Canvas.SetPos(0,Canvas.ClipY-64);
		Canvas.DrawIcon(texture(DynamicLoadObject("NerfRes.VMI", class'Texture')), 0.5);		
		Canvas.SetPos(0,Canvas.ClipY-128);
		Canvas.DrawIcon(texture(DynamicLoadObject("NerfRes.NerfLogo", class'Texture')), 0.5);			
	}
	
	Canvas.Style = 1;
}

defaultproperties
{
     ESCMessage=Press ESC to begin
}
