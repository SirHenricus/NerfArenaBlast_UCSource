class VictimMessage expands LocalMessagePlus;

var localized string YouWereKilledBy;

static function RenderMessage( 
	Canvas Canvas, 
	out float XL,
	out float YL,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	if (RelatedPRI_1 == None)
		return;

	Canvas.Font = Static.GetFont( Canvas );
	Canvas.DrawColor = Default.DrawColor;
	Canvas.StrLen( Static.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject), XL, YL );
	Canvas.SetPos( (Canvas.ClipX - XL) / 2, (Default.YPos/768.0) * Canvas.ClipY + 2*YL );
	Canvas.DrawText( Static.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject), False );
}

static function RenderFadeMessage( 
	Canvas Canvas, 
	out float XL,
	out float YL,
	float FadeTime,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	if (RelatedPRI_1 == None)
		return;

	Canvas.Font = Static.GetFont( Canvas );
	Canvas.DrawColor.R = Default.DrawColor.R * (FadeTime/Default.LifeTime);
	Canvas.DrawColor.G = Default.DrawColor.G * (FadeTime/Default.LifeTime);
	Canvas.DrawColor.B = Default.DrawColor.B * (FadeTime/Default.LifeTime);
	Canvas.StrLen( Static.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject), XL, YL );
	Canvas.SetPos( (Canvas.ClipX - XL) / 2, (Default.YPos/768.0) * Canvas.ClipY + 2*YL );
	Canvas.DrawText( Static.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject), False );
}

static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject 
	)
{
	if (RelatedPRI_1 == None)
		return "";

	if (RelatedPRI_1.PlayerName != "")
		return Default.YouWereKilledBy@RelatedPRI_1.PlayerName$"!";
}

defaultproperties
{
     YouWereKilledBy=You were knocked out by
     FontSize=1
     bIsSpecial=True
     bIsUnique=True
     bFadeMessage=True
     bOffsetYPos=True
     DrawColor=(R=255)
     YPos=196.000000
     bCenter=True
}
