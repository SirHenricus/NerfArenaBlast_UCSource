//=============================================================================
// NerfMenu
//
// Master class of all NerfI menus.  Contains nonstyle specific utilities
// for all menu types (Info/Long/Short).
//
// Integrated by Wezo 7-8-99
//=============================================================================
class NerfMenu extends Menu;

//##nerf WES Textures FIXME
// Need our fonts and art. These are from Unreal.

/*
#exec Texture Import File=g:\NerfRes\NerfMesh\Textures\ex.pcx Name=ex MIPS=OFF
#exec Texture Import File=g:\NerfRes\NerfMesh\Textures\check.pcx Name=Check MIPS=OFF
*/

//#exec OBJ LOAD FILE=..\system\NerfRes.u PACKAGE=NerfI.Res

//##nerf WES Sounds
// Menu selection sounds. Need to get our own
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\specialfx\keyopt1.WAV" NAME="Select4" GROUP="Menu"
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\specialfx\keyopt2.WAV" NAME="Updown3" GROUP="Menu"

simulated function PlaySelectSound()
{
	PlayerOwner.PlaySound(sound'updown3');
}

simulated function PlayModifySound()
{
	PlayerOwner.PlaySound(sound'Select4',,2.0);
}

simulated function PlayEnterSound() 
{
	PlayerOwner.PlaySound(sound'Select4',,2.0);
}

function DrawTitle(canvas Canvas)
{
	if ( Canvas.ClipY < 300 )
	{
		Canvas.Font = Canvas.BigFont;
		Canvas.SetPos(Max(8, 0.5 * Canvas.ClipX - 4 * Len(MenuTitle)), 4 );
	}
	else
	{
		Canvas.Font = Canvas.LargeFont;
		Canvas.SetPos(Max(8, 0.5 * Canvas.ClipX - 8 * Len(MenuTitle)), 4 );
	}
	Canvas.DrawText(MenuTitle, False);
}

function DrawList(canvas Canvas, bool bLargeFont, int Spacing, int StartX, int StartY)
{
	local int i;

	if ( bLargeFont )
	{
		if ( Spacing < 30 )
		{
			StartX += 0.5 * ( 0.5 * Canvas.ClipX - StartX);
			Canvas.Font = Canvas.BigFont;
		}
		else
			Canvas.Font = Canvas.LargeFont;
	}
	else
		Canvas.Font = Canvas.MedFont;

	for (i=0; i< (MenuLength); i++ )
	{
		SetFontBrightness(Canvas, (i == Selection - 1) );
		Canvas.SetPos(StartX, StartY + Spacing * i);
		Canvas.DrawText(MenuList[i + 1], false);
	}
	Canvas.DrawColor = Canvas.Default.DrawColor;
}

function DrawSlider( canvas Canvas, int StartX, int StartY, int Value, int sMin, int StepSize )
{
	local bool bFoundValue;
	local int i;

	Canvas.SetPos( StartX, StartY );
	Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.Slide1", class'Texture')),1.0);	
	Canvas.Style = 2;
	bFoundValue = false;
	For ( i=1; i<8; i++ )
	{
		if ( !bFoundValue && ( StepSize * i + sMin > Value) )
		{
			bFoundValue = true; 
			Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.Slide2", class'Texture')),1.0);
		}
		else
			Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.Slide4", class'Texture')),1.0);
	}
	if ( bFoundValue )
		Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.Slide4", class'Texture')),1.0);
	else
		Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.Slide2", class'Texture')),1.0);

	Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.Slide3", class'Texture')),1.0);							
	Canvas.Style = 1;	
}

defaultproperties
{
}
