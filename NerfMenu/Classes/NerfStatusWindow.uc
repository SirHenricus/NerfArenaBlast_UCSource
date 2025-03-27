class NerfStatusWindow extends UWindowWindow;

var string Status;

function Created()
{
	Super.Created();
}

function SetStatus(string NewStatus)
{
	Status = NewStatus;
}

function Paint(Canvas C, float X, float Y)
{
	local float W, H;

	C.DrawColor.R = 255;
	C.DrawColor.G = 255;
	C.DrawColor.B = 255;

	C.Font = Root.Fonts[F_Normal];

	// centered
	TextSize(C, Status, W, H);
	W = (WinWidth-W)/2;
	H = (WinHeight-H)/2;
	ClipText(C, W, H, Status);
}

defaultproperties
{
}
