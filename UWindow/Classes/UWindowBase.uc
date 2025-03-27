class UWindowBase extends Object;

// Fonts array constants
const F_Normal = 0;			// Normal font
const F_Bold = 1;			// Bold font
const F_Large = 2;			// Large font
const F_LargeBold = 3;		// Large, Bold font

struct Region
{
	var() int X;
	var() int Y;
	var() int W;
	var() int H;
};

struct TexRegion
{
	var() int X;
	var() int Y;
	var() int W;
	var() int H;
	var() Texture T;
};

enum TextAlign
{
	TA_Left,
	TA_Right,
	TA_Center
};

enum FrameHitTest
{
	HT_NW,
	HT_N,
	HT_NE,
	HT_W,
	HT_E,
	HT_SW,
	HT_S,
	HT_SE,
	HT_TitleBar,
	HT_DragHandle,
	HT_None
};

enum MenuSound
{
	MS_MenuPullDown,
	MS_MenuCloseUp,
	MS_MenuItem,
	MS_WindowOpen,
	MS_WindowClose,
	MS_ChangeTab
};

enum MessageBoxButtons
{
	MB_YesNo,
	MB_OKCancel,
	MB_OK
};

enum MessageBoxResult
{
	MR_None,
	MR_Yes,
	MR_No,
	MR_OK,
	MR_Cancel	// also if you press the Close box.
};

struct HTMLStyle
{
	var int BulletLevel;			// 0 = no bullet depth
	var string LinkDestination;
	var Color TextColor;
	var Color BGColor;
	var bool bCenter;
	var bool bLink;
	var bool bUnderline;
	var bool bNoBR;
	var bool bHeading;
	var bool bBold;
	var bool bBlink;
};

function Region NewRegion(float X, float Y, float W, float H)
{
	local Region R;
	R.X = X;
	R.Y = Y;
	R.W = W;
	R.H = H;
	return R;
}

function TexRegion NewTexRegion(float X, float Y, float W, float H, Texture T)
{
	local TexRegion R;
	R.X = X;
	R.Y = Y;
	R.W = W;
	R.H = H;
	R.T = T;
	return R;
}

function Region GetRegion(TexRegion T)
{
	local Region R;

	R.X = T.X;
	R.Y = T.Y;
	R.W = T.W;
	R.H = T.H;

	return R;
}

defaultproperties
{
}
