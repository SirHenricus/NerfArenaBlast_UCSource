class CriticalEventPlus expands LocalMessagePlus;

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
	Canvas.Font = Static.GetFont( Canvas );
	Canvas.DrawColor = Default.DrawColor;
	Canvas.StrLen( Static.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject), XL, YL );
	Canvas.SetPos( (Canvas.ClipX - XL) / 2, (Default.YPos/768.0) * Canvas.ClipY );
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
	Canvas.Font = Static.GetFont( Canvas );
	Canvas.DrawColor.R = Default.DrawColor.R * (FadeTime/Default.LifeTime);
	Canvas.DrawColor.G = Default.DrawColor.G * (FadeTime/Default.LifeTime);
	Canvas.DrawColor.B = Default.DrawColor.B * (FadeTime/Default.LifeTime);
	Canvas.StrLen( Static.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject), XL, YL );
	Canvas.SetPos( (Canvas.ClipX - XL) / 2, (Default.YPos/768.0) * Canvas.ClipY );
	Canvas.DrawText( Static.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject), False );
}

defaultproperties
{
     FontSize=1
     bIsSpecial=True
     bIsUnique=True
     bFadeMessage=True
     bBeep=True
     DrawColor=(G=128,B=255)
     YPos=196.000000
     bCenter=True
}
