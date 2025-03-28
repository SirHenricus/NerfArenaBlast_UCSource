//=============================================================================
// EndgameHud.
//
// Integrated by Wezo
//=============================================================================
class EndgameHud extends NerfHUD;

var() localized string Message1;
var() localized string Message2;
var() localized string Message3;
var() localized string Message4;
var() localized string Message5;
var() localized string Message6;

var() int MessageNumber;

simulated function DrawMOTD(canvas Canvas);

simulated function Timer()
{
	MessageNumber++;
}

simulated function PostRender( canvas Canvas )
{
	local float StartX;
	local InterpolationPoint i;
	local int TempX,TempY;
	local Actor A;
	local Decoration D;

	HUDSetup(canvas);

	if ( PlayerPawn(Owner) != None )
	{
		i = InterpolationPoint(PlayerPawn(Owner).Target);
		
		
		if ( PlayerPawn(Owner).bShowMenu  )
		{
			DisplayMenu(Canvas);
			return;
		}
		
		if (i!=None && i.Position==50) PlayerPawn(Owner).AmbientSound=None;
		
		else if (i!=None && i.Position > 51)
		{
			if (MessageNumber==0) 
			{
				MessageNumber++;
				SetTimer(17.0,True);
			}
			HudSetup(Canvas);
			Canvas.bCenter = false;
			Canvas.Font = Canvas.MedFont;
			TempX = Canvas.ClipX;
			TempY = Canvas.ClipY;	
			Canvas.SetOrigin(20,Canvas.ClipY-64);
			Canvas.SetClip(225,110);
			Canvas.SetPos(0,0);
			Canvas.Style = 1;	
			if (MessageNumber == 1) Canvas.DrawText(Message1, False);	
			else if (MessageNumber == 2) Canvas.DrawText(Message2, False);
			else if (MessageNumber == 3) Canvas.DrawText(Message3, False);
			else if (MessageNumber == 4) Canvas.DrawText(Message4, False);
			else if (MessageNumber == 5) Canvas.DrawText(Message5, False);
			else if (MessageNumber == 6) Canvas.DrawText(Message6, False);		
			else if (MessageNumber > 6) {
				foreach AllActors( class 'Decoration', D)
					D.Destroy();
				PlayerPawn(Owner).ShowMenu();
			}
		}
	}
}

defaultproperties
{
}
