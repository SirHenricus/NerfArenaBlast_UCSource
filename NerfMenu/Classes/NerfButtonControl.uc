class NerfButtonControl extends UWindowButton;

var color AltTextColor;

function SetAltTextColor(Color c)
{
	AltTextColor = c;
}

function Created()
{
	bNoKeyboard = True;

	Super.Created();

	ToolTipString = "";
	SetText("");
	SetFont(F_Normal);
	OverSound = NerfLookAndFeel(LookAndFeel).OverSound;
	DownSound = NerfLookAndFeel(LookAndFeel).DownSound;
}

function AutoWidth(Canvas C)
{
	local float W, H;
	C.Font = Root.Fonts[Font];
	
	TextSize(C, RemoveAmpersand(Text), W, H);

	if(WinWidth < W + 10)
		WinWidth = W + 10;
}

function BeforePaint(Canvas C, float X, float Y)
{
	local float W, H;

	C.Font = Root.Fonts[Font];
	TextSize(C, RemoveAmpersand(Text), W, H);

	TextX = (WinWidth-W) / 2 + 1;
	TextY = (WinHeight-H) / 2 + 1;

	if(bMouseDown)
	{
		TextX += 1;
		TextY += 1;
	}		
}

function Paint(Canvas C, float X, float Y)
{
	local color SaveColor;

	if (bMouseDown)
	{
		SaveColor = TextColor;
		TextColor = AltTextColor;
	}

	Super.Paint(C, X, Y);

	if (bMouseDown)
		TextColor = SaveColor;
}

defaultproperties
{
}
