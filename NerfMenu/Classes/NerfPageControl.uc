class NerfPageControl extends UWindowPageControl;

function Paint(Canvas C, float X, float Y)
{
	local Region R;
	local Texture T;

	T = GetLookAndFeelTexture();
	R = LookAndFeel.TabBackground;
//	DrawStretchedTextureSegment( C, 0, 0, WinWidth, LookAndFeel.Size_TabAreaHeight * TabArea.TabRows, R.X, R.Y, R.W, R.H, T );

	LookAndFeel.Tab_DrawTabPageArea(Self, C, UWindowPageControlPage(SelectedTab).Page);
}

defaultproperties
{
}
