class KillerMessagePlus expands LocalMessagePlus;

var localized string YouKilled;
var localized string ScoreString;

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
	if (RelatedPRI_2 == None)
		return;

	Canvas.Font = Static.GetFont( Canvas );
	Canvas.DrawColor = Default.DrawColor;
	Canvas.StrLen( Static.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject), XL, YL );
	Canvas.SetPos( (Canvas.ClipX - XL) / 2, (Default.YPos/768.0) * Canvas.ClipY - YL );
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
	if (RelatedPRI_2 == None)
		return;

	Canvas.Font = Static.GetFont( Canvas );
	Canvas.DrawColor.R = Default.DrawColor.R * (FadeTime/Default.LifeTime);
	Canvas.DrawColor.G = Default.DrawColor.G * (FadeTime/Default.LifeTime);
	Canvas.DrawColor.B = Default.DrawColor.B * (FadeTime/Default.LifeTime);
	Canvas.StrLen( Static.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject), XL, YL );
	Canvas.SetPos( (Canvas.ClipX - XL) / 2, (Default.YPos/768.0) * Canvas.ClipY - YL );
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
	if (RelatedPRI_2 == None)
		return "";

	if (RelatedPRI_2.PlayerName != "")
		return Default.YouKilled@RelatedPRI_2.PlayerName@"("$Default.ScoreString@int(RelatedPRI_1.Score)$")";
}

defaultproperties
{
     YouKilled=You knocked out
     ScoreString=Score:
     FontSize=1
     bIsSpecial=True
     bIsUnique=True
     bFadeMessage=True
     bOffsetYPos=True
     DrawColor=(R=255,G=155,B=55)
     YPos=196.000000
     bCenter=True
}
