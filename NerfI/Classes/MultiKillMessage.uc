class MultiKillMessage extends LocalMessagePlus;

var(Messages)	localized string 	DoubleKillString;
var(Messages)	localized string 	TripleKillString;
var(Messages)	localized string 	MultiKillString;
var(Messages)	localized string 	UltraKillString;
var(Messages)	localized string 	MonsterKillString;

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
	switch (Switch)
	{
		case 1:
			Canvas.Font = class'FontInfo'.Static.GetBigFont( Canvas.ClipX );
			break;
		case 2:
		case 3:
		case 4:
		case 5:
		case 6:
		case 7:
		case 8:
		case 9:
		case 10:
			Canvas.Font = class'FontInfo'.Static.GetHugeFont( Canvas.ClipX );
			break;
	}
	Canvas.DrawColor = Default.DrawColor;
	Canvas.StrLen( Static.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject), XL, YL );
	Canvas.SetPos( (Canvas.ClipX - XL) / 2, (Default.YPos/768.0) * Canvas.ClipY + YL );
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
	switch (Switch)
	{
		case 1:
			Canvas.Font = class'FontInfo'.Static.GetBigFont( Canvas.ClipX );
			break;
		case 2:
		case 3:
		case 4:
		case 5:
		case 6:
		case 7:
		case 8:
		case 9:
		case 10:
			Canvas.Font = class'FontInfo'.Static.GetHugeFont( Canvas.ClipX );
			break;
	}
	Canvas.DrawColor.R = Default.DrawColor.R * (FadeTime/Default.LifeTime);
	Canvas.DrawColor.G = Default.DrawColor.G * (FadeTime/Default.LifeTime);
	Canvas.DrawColor.B = Default.DrawColor.B * (FadeTime/Default.LifeTime);
	Canvas.StrLen( Static.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject), XL, YL );
	Canvas.SetPos( (Canvas.ClipX - XL) / 2, (Default.YPos/768.0) * Canvas.ClipY + YL );
	Canvas.DrawText( Static.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject), False );
}

static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject 
	)
{
	switch (Switch)
	{
		case 1:
			return Default.DoubleKillString;
			break;
		case 2:
			return Default.MultiKillString;
			break;
		case 3:
			return Default.UltraKillString;
			break;
		case 4:
		case 5:
		case 6:
		case 7:
		case 8:
		case 9:
			return Default.MonsterKillString;
			break;
	}
	return "";
}

static simulated function ClientReceive( 
	PlayerPawn P,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);

	switch (Switch)
	{
		case 1:
//##nerf WES FIXME
// If would be nice if we have the sound file for those.
//			P.ClientPlaySound(sound'Announcer.DoubleKill');
			break;
		case 2:
//			P.ClientPlaySound(sound'Announcer.MultiKill');
			break;
		case 3:
//			P.ClientPlaySound(sound'Announcer.UltraKill');
			break;
		case 4:
		case 5:
		case 6:
		case 7:
		case 8:
		case 9:
//			P.ClientPlaySound(sound'Announcer.MonsterKill');
			break;
	}
}

defaultproperties
{
     DoubleKillString=Excellent!
     TripleKillString=Triple Kill!
     MultiKillString=Hat Trick!
     UltraKillString=AWESOME!!
     MonsterKillString=UNSTOPPABLE !!!
     FontSize=1
     bIsSpecial=True
     bIsUnique=True
     bFadeMessage=True
     bOffsetYPos=True
     DrawColor=(R=255)
     YPos=196.000000
     bCenter=True
}
