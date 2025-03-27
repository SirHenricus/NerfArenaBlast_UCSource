// UWindowEditBox - simple edit box, for use in other controls such as 
// UWindowComboxBoxControl, UWindowEditBoxControl etc.

class UWindowEditBox extends UWindowDialogControl;

var string		Value;
var string		Value2;
var int			CaretOffset;
var int			MaxLength;
var float		LastDrawTime;
var bool		bShowCaret;
var float		Offset;
var UWindowDialogControl	NotifyOwner;
var bool		bNumericOnly;
var bool		bCanEdit;
var bool		bAllSelected;
var bool		bSelectOnFocus;
var bool		bDelayedNotify;
var bool		bChangePending;
var bool		bControlDown;
var bool		bShiftDown;

function Created()
{
	Super.Created();
	bCanEdit = True;
	bControlDown = False;
	bShiftDown = False;

	MaxLength = 255;
	CaretOffset = 0;
	Offset = 0;
	LastDrawTime = GetLevel().TimeSeconds;
}

function SetEditable(bool bEditable)
{
	bCanEdit = bEditable;
}

function SetValue(string NewValue, optional string NewValue2)
{
	Value = NewValue;
	Value2 = NewValue2;

	if(CaretOffset > Len(Value))
		CaretOffset = Len(Value);		
	Notify(DE_Change);
}

function Clear()
{
	CaretOffset = 0;
	Value="";
	Value2="";
	bAllSelected = False;
	if(bDelayedNotify)
		bChangePending = True;
	else
		Notify(DE_Change);
}

function SelectAll()
{
	if(bCanEdit && Value != "")
	{
		CaretOffset = Len(Value);
		bAllSelected = True;
	}
}

function string GetValue()
{
	return Value;
}

function string GetValue2()
{
	return Value2;
}

function Notify(byte E)
{
	if(NotifyOwner != None)
	{
		NotifyOwner.Notify(E);
	} else {
		Super.Notify(E);
	}
}

// Inserts a character at the current caret position
function bool Insert(byte C)
{
	local string	NewValue;

	NewValue = Left(Value, CaretOffset) $ Chr(C) $ Mid(Value, CaretOffset);

	if(Len(NewValue) > MaxLength) 
		return False;

	CaretOffset++;

	Value = NewValue;
	if(bDelayedNotify)
		bChangePending = True;
	else
		Notify(DE_Change);
	return True;
}

function bool Backspace()
{
	local string	NewValue;

	if(CaretOffset == 0) return False;

	NewValue = Left(Value, CaretOffset - 1) $ Mid(Value, CaretOffset);
	CaretOffset--;

	Value = NewValue;
	if(bDelayedNotify)
		bChangePending = True;
	else
		Notify(DE_Change);
	return True;
}

function bool Delete()
{
	local string	NewValue;

	if(CaretOffset == Len(Value)) return False;

	NewValue = Left(Value, CaretOffset) $ Mid(Value, CaretOffset + 1);

	Value = NewValue;
	Notify(DE_Change);
	return True;
}

function bool WordLeft()
{
	while(CaretOffset > 0 && Mid(Value, CaretOffset - 1, 1) == " ")
		CaretOffset--;
	while(CaretOffset > 0 && Mid(Value, CaretOffset - 1, 1) != " ")
		CaretOffset--;

	LastDrawTime = GetLevel().TimeSeconds;
	bShowCaret = True;

	return True;	
}

function bool MoveLeft()
{
	if(CaretOffset == 0) return False;
	CaretOffset--;

	LastDrawTime = GetLevel().TimeSeconds;
	bShowCaret = True;

	return True;	
}

function bool MoveRight()
{
	if(CaretOffset == Len(Value)) return False;
	CaretOffset++;

	LastDrawTime = GetLevel().TimeSeconds;
	bShowCaret = True;

	return True;	
}

function bool WordRight()
{
	while(CaretOffset < Len(Value) && Mid(Value, CaretOffset, 1) != " ")
		CaretOffset++;
	while(CaretOffset < Len(Value) && Mid(Value, CaretOffset, 1) == " ")
		CaretOffset++;

	LastDrawTime = GetLevel().TimeSeconds;
	bShowCaret = True;

	return True;	
}

function bool MoveHome()
{
	CaretOffset = 0;

	LastDrawTime = GetLevel().TimeSeconds;
	bShowCaret = True;

	return True;	
}

function bool MoveEnd()
{
	CaretOffset = Len(Value);

	LastDrawTime = GetLevel().TimeSeconds;
	bShowCaret = True;

	return True;	
}

function KeyType( int Key, float MouseX, float MouseY )
{
	// Log("KeyType: bCanEdit = "$bCanEdit);

	if(bCanEdit) 
	{
		if(bAllSelected)
			Clear();

		bAllSelected = False;

		if(bNumericOnly)
		{
			if( Key>=0x30 && Key<=0x39 )  
			{
				Insert(Key);
			}
		}
		else
		{
			if( Key>=0x20 && Key<0x80 )
			{
				Insert(Key);
			}
		}
	}
}

function KeyUp(int Key, float X, float Y)
{
	local PlayerPawn P;

	P = GetPlayerOwner();
	switch (Key)
	{
	case P.EInputKey.IK_Ctrl:
		bControlDown = False;
		break;
	case P.EInputKey.IK_Shift:
		bShiftDown = False;
		break;
	}
}

function KeyDown(int Key, float X, float Y)
{
	local PlayerPawn P;

	P = GetPlayerOwner();
	switch (Key)
	{
	case P.EInputKey.IK_Ctrl:
		bControlDown = True;
		break;
	case P.EInputKey.IK_Shift:
		bShiftDown = True;
		break;
	case P.EInputKey.IK_Escape:
		break;
	case P.EInputKey.IK_Enter:
		if(bCanEdit)
			Notify(DE_EnterPressed);
		break;
	case P.EInputKey.IK_MouseWheelUp:
		if(bCanEdit)
			Notify(DE_WheelUpPressed);
		break;
	case P.EInputKey.IK_MouseWheelDown:
		if(bCanEdit)
			Notify(DE_WheelDownPressed);
		break;
	case P.EInputKey.IK_Right:
		if(bCanEdit) 
		{
			if(bControlDown)
				WordRight();
			else
				MoveRight();
		}
		bAllSelected = False;
		break;
	case P.EInputKey.IK_Left:
		if(bCanEdit)
		{
			if(bControlDown)
				WordLeft();
			else
				MoveLeft();
		}
		bAllSelected = False;
		break;
	case P.EInputKey.IK_Home:
		if(bCanEdit)
			MoveHome();
		bAllSelected = False;
		break;
	case P.EInputKey.IK_End:
		if(bCanEdit)
			MoveEnd();
		bAllSelected = False;
		break;
	case P.EInputKey.IK_Backspace:
		if(bCanEdit)
		{
			if(bAllSelected)
				Clear();
			else
				Backspace();
		}
		bAllSelected = False;
		break;
	case P.EInputKey.IK_Delete:
		if(bCanEdit)
		{
			if(bAllSelected)
				Clear();
			else
				Delete();
		}
		bAllSelected = False;
		break;
	default:
		if(NotifyOwner != None)
			NotifyOwner.KeyDown(Key, X, Y);
		else
			Super.KeyDown(Key, X, Y);
		break;
	}
}

function Click(float X, float Y)
{
	Notify(DE_Click);
}

function LMouseDown(float X, float Y)
{
	Super.LMouseDown(X, Y);
	Notify(DE_LMouseDown);
}

function Paint(Canvas C, float X, float Y)
{
	local float W, H;
	local float TextY;

	C.Font = Root.Fonts[Font];

	TextSize(C, "A", W, H);
	TextY = (WinHeight - H) / 2;

	TextSize(C, Left(Value, CaretOffset), W, H);

	C.DrawColor.R = 255;
	C.DrawColor.G = 255;
	C.DrawColor.B = 255;

	if(W + Offset < 0)
		Offset = -W;

	if(W + Offset > (WinWidth - 2))
	{
		Offset = (WinWidth - 2) - W;
		if(Offset > 0) Offset = 0;
	}

	C.DrawColor = TextColor;

	if(bAllSelected)
	{
		DrawStretchedTexture(C, Offset + 1, TextY, W, H, Texture'UWindow.WhiteTexture');

		// Invert Colors
		C.DrawColor.R = 255 ^ C.DrawColor.R;
		C.DrawColor.G = 255 ^ C.DrawColor.G;
		C.DrawColor.B = 255 ^ C.DrawColor.B;
	}

	ClipText(C, Offset + 1, TextY,  Value);

	if((!bHasKeyboardFocus) || (!bCanEdit))
		bShowCaret = False;
	else
	{
		if((GetLevel().TimeSeconds > LastDrawTime + 0.3) || (GetLevel().TimeSeconds < LastDrawTime))
		{
			LastDrawTime = GetLevel().TimeSeconds;
			bShowCaret = !bShowCaret;
		}
	}

	if(bShowCaret)
		ClipText(C, Offset + W - 1, TextY, "|");
}

function Close(optional bool bByParent)
{
	if(bChangePending)
	{
		bChangePending = False;
		Notify(DE_Change);
	}

	Super.Close(bByParent);
}

function FocusOtherWindow(UWindowWindow W)
{
	if(bChangePending)
	{
		bChangePending = False;
		Notify(DE_Change);
	}

	if(NotifyOwner != None)
		NotifyOwner.FocusOtherWindow(W);
	else
		Super.FocusOtherWindow(W);
}

function KeyFocusEnter()
{
	if(bSelectOnFocus && !bHasKeyboardFocus)
		SelectAll();

	Super.KeyFocusEnter();
}

function DoubleClick(float X, float Y)
{
	Super.DoubleClick(X, Y);
	SelectAll();
}

function FocusWindow()
{
	if(bChangePending)
	{
		bChangePending = False;
		Notify(DE_Change);			// NERF: hack to fix missing change message
	}
}

function KeyFocusExit()
{
	bAllSelected = False;
	Super.KeyFocusExit();
	if(bChangePending)
	{
		bChangePending = False;
		Notify(DE_Change);			// NERF: hack to fix missing change message
	}
}
	

defaultproperties
{
}
