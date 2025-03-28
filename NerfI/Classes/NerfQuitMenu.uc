//=============================================================================
// NerfQuitMenu
//
// Integrated by Wezo
//=============================================================================
class NerfQuitMenu extends NerfLongMenu;

var bool bResponse;
var localized string YesSelString;
var localized string NoSelString;

function bool ProcessYes()
{
	bResponse = true;
	return true;
}

function bool ProcessNo()
{
	bResponse = false;
	return true;
}

function bool ProcessLeft()
{
	bResponse = !bResponse;
	return true;
}

function bool ProcessRight()
{
	bResponse = !bResponse;
	return true;
}

function bool ProcessSelection()
{
	local Menu ChildMenu;

//##nerf WES FIXME
// Waiting for Dave to implement it. 
//	local CDAudio a;

	ChildMenu = None;

	if ( bResponse )
	{
		PlayerOwner.SaveConfig();
		//PlayerOwner.PlayerReplicationInfo.SaveConfig();
		if ( Level.Game != None ) {
			Level.Game.SaveConfig();
			Level.Game.GameReplicationInfo.SaveConfig();
		}
		PlayerOwner.ConsoleCommand("Exit");

		// kill the looping audio (DWG)
		// there's probably a better place to do this...
//		a = spawn(class'NerfI.CDAudio');
//		a.StopCDTrack();
	}
	else 
		ExitMenu();
}

function DrawMenu(canvas Canvas)
{
	local int StartX, StartY, Spacing, SecSpace;
	
	DrawBackGround(Canvas, (Canvas.ClipY < 320));
	
	StartX = 0.5 * Canvas.ClipX - 120;
	StartY = 2;
	Spacing = 9;
	Canvas.Font = Canvas.MedFont;
	
	Canvas.SetPos(StartX, StartY );
	Canvas.DrawText(MenuList[0], False);	
	Canvas.SetPos(StartX+72, StartY+10 );	
	Canvas.DrawText(MenuList[1], False);	
	StartX = Max(8, 0.5 * Canvas.ClipX - 116);	
	Spacing = Clamp(0.04 * Canvas.ClipY, 7, 40);
	StartY = 16 + Spacing;
	SecSpace = 2 + Spacing/6;
	Canvas.Font = Canvas.SmallFont;
	
//	Canvas.DrawColor.R = 30;
//	Canvas.DrawColor.G = 90;
//	Canvas.DrawColor.B = 30;
// DSL - let's brighten it up a bit
	Canvas.DrawColor.R = 128;
	Canvas.DrawColor.G = 192;
	Canvas.DrawColor.B = 128;
		
	Canvas.SetPos(StartX, StartY);
	Canvas.DrawText(MenuList[2], false);
	Canvas.SetPos(StartX+8, StartY+Spacing);
	Canvas.DrawText(MenuList[3], false);
	Canvas.SetPos(StartX, StartY+Spacing*2+SecSpace);
	Canvas.DrawText(MenuList[4], false);	
	Canvas.SetPos(StartX+8, StartY+Spacing*3+SecSpace);
	Canvas.DrawText(MenuList[5],  false);	
	Canvas.SetPos(StartX+8, StartY+Spacing*4+SecSpace);
	Canvas.DrawText(MenuList[6],  false);		
	Canvas.SetPos(StartX+8, StartY+Spacing*5+SecSpace);
	Canvas.DrawText(MenuList[7],  false);
	
	Canvas.SetPos(StartX, StartY+Spacing*6+SecSpace*2);
	Canvas.DrawText(MenuList[8],  false);
	
	Canvas.SetPos(StartX, StartY+Spacing*7+SecSpace*3);
	Canvas.DrawText(MenuList[9],  false);
	Canvas.SetPos(StartX, StartY+Spacing*8+SecSpace*3);
	Canvas.DrawText(MenuList[10],  false);	

	Canvas.SetPos(StartX, StartY+Spacing*9+SecSpace*4);
	Canvas.DrawText(MenuList[11],  false);
	Canvas.SetPos(StartX, StartY+Spacing*10+SecSpace*4);
	Canvas.DrawText(MenuList[12],  false);
	Canvas.SetPos(StartX, StartY+Spacing*11+SecSpace*4);
	Canvas.DrawText(MenuList[13],  false);		

	Canvas.SetPos(StartX, StartY+Spacing*12+SecSpace*5);
	Canvas.DrawText(MenuList[14],  false);	
	Canvas.SetPos(StartX+8, StartY+Spacing*13+SecSpace*5);
	Canvas.DrawText(MenuList[15],  false);
	
	Canvas.SetPos(StartX, StartY+Spacing*14+SecSpace*6);
	Canvas.DrawText(MenuList[16],  false);	

	Canvas.DrawColor.R = 40;
	Canvas.DrawColor.G = 60;
	Canvas.DrawColor.B = 20;
	
	Canvas.SetPos(StartX, StartY+Spacing*15+SecSpace*7);
	Canvas.DrawText(MenuList[17],  false);	
	
	Canvas.SetPos(StartX, StartY+Spacing*16+SecSpace*8);
	Canvas.DrawText(MenuList[18],  false);
			
	// draw text
	Canvas.Font = Canvas.MedFont;	
	SetFontBrightness(Canvas, true);
// DSL: repositioning quityesno prompt
//    StartY = Canvas.ClipY - 128 - (Spacing+SecSpace);
    StartY = Canvas.ClipY - 128 - Spacing;
//	StartY = Clamp(StartY+Spacing*17+SecSpace*9, Canvas.ClipY - 66, Canvas.ClipY - 12);
	Canvas.bCenter = true;
	Canvas.SetPos(0, StartY );
	if ( bResponse )
		Canvas.DrawText(MenuTitle$YesSelString, False);
	else
		Canvas.DrawText(MenuTitle$NoSelString, False);
	Canvas.DrawColor = Canvas.Default.DrawColor;
	Canvas.bCenter = false;

	// Draw help panel
//	DrawHelpPanel(Canvas, 0.5 * Canvas.ClipY + 16, 228);
}

defaultproperties
{
     YesSelString= [YES]  No
     NoSelString=  Yes  [NO]
     HelpMessage(1)=Select yes and hit enter to quit.
     MenuTitle=Quit?
}
