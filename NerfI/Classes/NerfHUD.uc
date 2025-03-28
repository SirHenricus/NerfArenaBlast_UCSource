//=============================================================================
// NerfHUD
// Parent class of heads up display
//
// Integrated by Wezo
//=============================================================================
class NerfHUD extends HUD;

var int TranslatorTimer;
var() int TranslatorY,CurTranY,SizeY,Count;
var string CurrentMessage;
var bool bDisplayTran, bFlashTranslator;
var float MOTDFadeOutTime;

var float IdentifyFadeTime;
var Pawn IdentifyTarget;

// Identify Strings
var localized string IdentifyName;
var localized string IdentifyHealth;

var() localized string VersionMessage;

var localized string TeamName[8];
var() color TeamColor[8];
var() color AltTeamColor[8];
var color RedColor, GreenColor;

var int ArmorOffset;

// DSL added these for ArenaRace winner
var bool bRaceWinner;
var string Winner;

var	int CountDownClock;

var bool bLowRes;		//512 and below
var float ResScale;

var HUDLocalizedMessage ShortMessageQueue[4];
var HUDLocalizedMessage LocalMessages[16];
var bool bHideCenterMessages;

// scoring 
var float ScoreTime;

// Message Struct
Struct MessageStruct
{
	var name Type;
	var PlayerReplicationInfo PRI;
};

replication
{
    unreliable if( Role==ROLE_Authority )
           CountDownClock;
}

// DSL added this for ArenaRace Winner
simulated function SetWinnerSplash( bool bOnOff, string Moniker )
{
    bRaceWinner = bOnOff;
    Winner = Moniker;
}

simulated function PostBeginPlay()
{
	local LevelController LC;

	MOTDFadeOutTime = 255;

	foreach allactors( class'LevelController', LC)
			LC.Trigger(self, Pawn(owner));

	Super.PostBeginPlay();
}

simulated function ChangeHud(int d)
{
	HudMode = HudMode + d;
	if ( HudMode>5 ) HudMode = 0;
	else if ( HudMode < 0 ) HudMode = 5;
}

simulated function ChangeCrosshair(int d)
{
	Crosshair = Crosshair + d;
	if ( Crosshair>6 ) Crosshair=0;
	else if ( Crosshair < 0 ) Crosshair = 6;
}

simulated function CreateMenu()
{
	if ( PlayerPawn(Owner).bSpecialMenu && (PlayerPawn(Owner).SpecialMenu != None) )
	{
		MainMenu = Spawn(PlayerPawn(Owner).SpecialMenu, self);
		PlayerPawn(Owner).bSpecialMenu = false;
	}
	
	if ( MainMenu == None )
	{
		if(PlayerPawn(Owner).Player.Console.IsA('NerfConsole'))
			Owner.ConsoleCommand("SHOWNERFMENU");
		else
			MainMenu = Spawn(MainMenuType, self);
	}
		
	if ( MainMenu == None )
	{
		PlayerPawn(Owner).bShowMenu = false;
		Level.bPlayersOnly = false;
		return;
	}
	else
	{
		MainMenu.PlayerOwner = PlayerPawn(Owner);
		MainMenu.PlayEnterSound();
		MainMenu.MenuInit();
	}
}

simulated function HUDSetup(canvas canvas)
{
	// Setup the way we want to draw all HUD elements
	Canvas.Reset();
	Canvas.SpaceX=0;
	Canvas.bNoSmooth = True;
	Canvas.DrawColor.r = 255;
	Canvas.DrawColor.g = 255;
	Canvas.DrawColor.b = 255;	
	Canvas.Font = Canvas.LargeFont;
	if (Canvas.ClipX < 640)
	{
		bLowRes=True;
		ResScale=0.5;
	}
	else 
	{
		bLowRes=False;
		ResScale=1.0;
	}
}

simulated function DrawCrossHair( canvas Canvas, int StartX, int StartY )
{
	if (Crosshair>5) Return;
	Canvas.SetPos(StartX, StartY );
	Canvas.Style = 2;
	if		(Crosshair==0) 	Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.Crosshair1", class'Texture')), 1.0);
	else if (Crosshair==1) 	Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.Crosshair2", class'Texture')), 1.0);
	else if (Crosshair==2) 	Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.Crosshair3", class'Texture')), 1.0);
	else if (Crosshair==3) 	Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.Crosshair4", class'Texture')), 1.0);
	else if (Crosshair==4) 	Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.Crosshair5", class'Texture')), 1.0);
	else if (Crosshair==5) 	Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.Crosshair7", class'Texture')), 1.0);
	Canvas.Style = 1;	
}

simulated function DisplayProgressMessage( canvas Canvas )
{
	local int i;
	local float YOffset, XL, YL;

	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
	Canvas.bCenter = true;
	
	if (bLowRes)
		Canvas.Font = Canvas.SmallFont;
	else
		Canvas.Font = Canvas.MedFont;

	YOffset = 0;
	Canvas.StrLen("TEST", XL, YL);
	for (i=0; i<5; i++)
	{
		Canvas.SetPos(0, 0.25 * Canvas.ClipY + YOffset);
		Canvas.DrawColor = PlayerPawn(Owner).ProgressColor[i];
		Canvas.DrawText(PlayerPawn(Owner).ProgressMessage[i], false);
		YOffset += YL + 1;
	}
	Canvas.bCenter = false;
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
}

simulated function PreRender( canvas Canvas )
{
	if (PlayerPawn(Owner).Weapon != None)
		PlayerPawn(Owner).Weapon.PreRender(Canvas);
}

simulated function DisplayMenu( canvas Canvas )
{
	local float VersionW, VersionH;

	if ( MainMenu == None )
		CreateMenu();

	if (MainMenu == None)
		return;

	MainMenu.DrawMenu(Canvas);

	if ( MainMenu.Class == MainMenuType )
	{
		Canvas.bCenter = false;
		Canvas.Font = Canvas.MedFont;
		Canvas.Style = 1;
		Canvas.StrLen(VersionMessage@Level.EngineVersion, VersionW, VersionH);
		Canvas.SetPos(Canvas.ClipX - VersionW - 4, 4);	
		Canvas.DrawText(VersionMessage@Level.EngineVersion, False);	
	}
}

simulated function ShowEveryThing(canvas Canvas)
{
	if ( (PlayerPawn(Owner).Scoring == None) && (PlayerPawn(Owner).ScoringType != None) )
		PlayerPawn(Owner).Scoring = Spawn(PlayerPawn(Owner).ScoringType, PlayerPawn(Owner));
	if ( PlayerPawn(Owner).Scoring != None )
		PlayerPawn(Owner).Scoring.ShowIcons(Canvas, bLowRes);
	DrawStanding(Canvas);
	DrawScore(Canvas);
	DrawHealth(Canvas);
	DrawAmmo(Canvas);
	DrawPowerUp(Canvas);
	DrawClock(Canvas);
}

simulated function NoIcons(canvas Canvas)
{
	DrawStanding(Canvas);
	DrawScore(Canvas);
	DrawHealth(Canvas);
	DrawAmmo(Canvas);
	DrawPowerUp(Canvas);
	DrawClock(Canvas);
}

simulated function NoAmmos(canvas Canvas)
{
	DrawStanding(Canvas);
	DrawScore(Canvas);
	DrawHealth(Canvas);
	DrawPowerUp(Canvas);
	DrawClock(Canvas);
}

simulated function NoPowerUps(canvas Canvas)
{
	DrawStanding(Canvas);
	DrawScore(Canvas);
	DrawHealth(Canvas);
	DrawClock(Canvas);
}

simulated function NoHealth(canvas Canvas)
{
	DrawStanding(Canvas);
	DrawScore(Canvas);
	DrawClock(Canvas);
}

simulated function PostRender( canvas Canvas )
{
	local Inventory Inv;

// courtesy of DSL's intrusion below
    local string WinnerMsg;
	local float XL, YL;

/*************************************************************************************/
	local int i;
	local float FadeValue;
/*************************************************************************************/


	HUDSetup(canvas);
	
//##nerf WES FIXME
// This might cause a problem in the client side during multiplayer cause the client won't have
// Level.Game. We can always set the Defaultgame type to single player and solve it. But now
// I will just use it cause I don't want to bother the artists now.

	if ((Level.NetMode==NM_Standalone) && (!Level.Game.bDeathMatch))
		HudMode = 5;
/*************************************************************************************/
	if ( !PlayerPawn(Owner).bShowScores && !bHideCenterMessages && !bLowRes)
	{
		// Master localized message control loop.
		for (i=0; i<15; i++)
		{
			if (LocalMessages[i].Message != None)
			{
				if (LocalMessages[i].Message.Default.bFadeMessage && Level.bHighDetailMode)
				{
					Canvas.Style = ERenderStyle.STY_Translucent;
					FadeValue = (LocalMessages[i].EndOfLife - Level.TimeSeconds);
					if (FadeValue > 0.0)
					{
						if (LocalMessages[i].StringMessage == "")
							LocalMessages[i].Message.Static.RenderFadeMessage(Canvas, XL, YL, FadeValue, LocalMessages[i].Switch, LocalMessages[i].RelatedPRI_1, LocalMessages[i].RelatedPRI_2, LocalMessages[i].OptionalObject);
						else
							LocalMessages[i].Message.Static.RenderFadeString(Canvas, XL, YL, FadeValue, LocalMessages[i].StringMessage);
					}
					Canvas.Style = ERenderStyle.STY_Masked;
				} 
				else 
				{
					Canvas.Style = ERenderStyle.STY_Normal;
					if (LocalMessages[i].StringMessage == "")
						LocalMessages[i].Message.Static.RenderMessage(Canvas, XL, YL, LocalMessages[i].Switch, LocalMessages[i].RelatedPRI_1, LocalMessages[i].RelatedPRI_2, LocalMessages[i].OptionalObject);
					else
						LocalMessages[i].Message.Static.RenderString(Canvas, XL, YL, LocalMessages[i].StringMessage);
				}
			}
		}
	}
	Canvas.Style = ERenderStyle.STY_Normal;
/*************************************************************************************/
	if ( PlayerPawn(Owner) != None )
	{
		if ( PlayerPawn(Owner).PlayerReplicationInfo == None )
			return;
		if ( PlayerPawn(Owner).bShowMenu )
		{
			DisplayMenu(Canvas);
			return;
		}
		if ( PlayerPawn(Owner).bShowScores )
		{
			if ( ( PlayerPawn(Owner).Weapon != None ) && ( !PlayerPawn(Owner).Weapon.bOwnsCrossHair ) )
				DrawCrossHair(Canvas, 0.5 * Canvas.ClipX - 8, 0.5 * Canvas.ClipY - 8);
			if ( (PlayerPawn(Owner).Scoring == None) && (PlayerPawn(Owner).ScoringType != None) )
				PlayerPawn(Owner).Scoring = Spawn(PlayerPawn(Owner).ScoringType, PlayerPawn(Owner));
			if ( PlayerPawn(Owner).Scoring != None )
			{ 
				PlayerPawn(Owner).Scoring.ShowScores(Canvas);
				return;
			}
		}
		else if ( (PlayerPawn(Owner).Weapon != None) && (Level.LevelAction == LEVACT_None) )
		{
			Canvas.Font = Font(DynamicLoadObject("NerfRes.WhiteFont", class'Font'));
			PlayerPawn(Owner).Weapon.PostRender(Canvas);
			if ( !PlayerPawn(Owner).Weapon.bOwnsCrossHair )
				DrawCrossHair(Canvas, 0.5 * Canvas.ClipX - 8, 0.5 * Canvas.ClipY - 8);
		}

		if ( PlayerPawn(Owner).ProgressTimeOut > Level.TimeSeconds )
			DisplayProgressMessage(Canvas);

	}

	switch(HudMode)
	{
		case 0 :	ShowEveryThing(Canvas); break;
		case 1 :	NoIcons(Canvas); break;
		case 2 :	NoAmmos(Canvas); break;
		case 3 :	NoPowerUps(Canvas); break;
		case 4 :	NoHealth(Canvas); break;
		case 5 :	return; break;
	}

	// Display Identification Info
	DrawIdentifyInfo(Canvas, 0, Canvas.ClipY - 64.0);

	// Message of the Day / Map Info Header
	if (MOTDFadeOutTime != 0.0)
		DrawMOTD(Canvas);

	// Team Game Synopsis
	if ( (PlayerPawn(Owner).GameReplicationInfo != None) && PlayerPawn(Owner).GameReplicationInfo.bTeamGame)
	{
		PlayerPawn(Owner).Scoring.ShowTeamScores(Canvas);
		DrawTeamGameSynopsis(Canvas);
	}
}

simulated function TrackLocation(Canvas Canvas, int X, int Y, Actor Suspect)
{
    local int num;

    Canvas.SetPos(X,Y);
	Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.IconSelection", class'Texture')), 1.0);	
	Canvas.Font = Font(DynamicLoadObject("NerfRes.TinyWhiteFont", class'Font'));	
    Canvas.CurX = X+2;
    Canvas.CurY = Y+2;
    num = int(Suspect.Location.X);
    Canvas.DrawText( num, false );
    Canvas.CurX = X+2;
    Canvas.CurY = Y+12;
    num = int(Suspect.Location.Y);
    Canvas.DrawText( num, false );
    Canvas.CurX = X+2;
    Canvas.CurY = Y+22;
    num = int(Suspect.Location.Z);
    Canvas.DrawText( num, false );
}

simulated function DrawLocation(Canvas Canvas, int X, int Y)
{
    local int num;

    Canvas.SetPos(X,Y);
	Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.IconSelection", class'Texture')), 1.0);	
	Canvas.Font = Font(DynamicLoadObject("NerfRes.TinyWhiteFont", class'Font'));
    Canvas.CurX = X+2;
    Canvas.CurY = Y+2;
    num = int(Pawn(Owner).Location.X);
    Canvas.DrawText( num, false );
    Canvas.CurX = X+2;
    Canvas.CurY = Y+12;
    num = int(Pawn(Owner).Location.Y);
    Canvas.DrawText( num, false );
    Canvas.CurX = X+2;
    Canvas.CurY = Y+22;
    num = int(Pawn(Owner).Location.Z);
    Canvas.DrawText( num, false );
}

simulated function DrawTeamGameSynopsis(Canvas Canvas)
{
	local TeamInfo TI;
	local float XL, YL;

	foreach AllActors(class'TeamInfo', TI)
	{
		if (TI.Size > 0)
		{
			Canvas.Font = Font(DynamicLoadObject("NerfRes.WhiteFont", class'Font'));
			Canvas.DrawColor = TeamColor[TI.TeamIndex]; 
			Canvas.StrLen(TeamName[TI.TeamIndex], XL, YL);
			Canvas.SetPos(0, 48 + 16 * TI.TeamIndex);
			Canvas.DrawText(TeamName[TI.TeamIndex], false);
			Canvas.SetPos(XL, 48 + 16 * TI.TeamIndex);
			Canvas.DrawText(int(TI.Score), false);
		}
	}

	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
}

simulated function DrawPowerUp(Canvas Canvas)
{	
	local inventory Inv;

	for ( Inv=Owner.Inventory; Inv!=None; Inv=Inv.Inventory )
	{
		if (Inv.bIsAnArmor) 
		{
			Canvas.CurX = Canvas.ClipX - 64*ResScale;
			Canvas.CurY = Canvas.ClipY/2 - 128*ResScale;
			Canvas.Style = 2;
			if (Inv.Charge > 25)
				Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.PowerArmor", class'Texture')),ResScale);
			else
				Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.PowerArmorl", class'Texture')),ResScale);
		}
		else if ( MegaSpeed(Inv) !=None)
		{
			Canvas.CurX = Canvas.ClipX - 64*ResScale;
			Canvas.CurY = Canvas.ClipY/2 - 52*ResScale;
			Canvas.Style = 2;
			if (Inv.Charge > 10)
				Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.PowerSpeed", class'Texture')),ResScale);
			else
			{
				if (Inv.Charge % 2 > 0)
					Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.PowerSpeedl", class'Texture')),ResScale);
				else 
					Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.PowerSpeed", class'Texture')),ResScale);
			}
		}
		else if ( Megajump(Inv) !=None)
		{
			Canvas.CurX = Canvas.ClipX - 64*ResScale;
			Canvas.CurY = Canvas.ClipY/2 - 14*ResScale;
			Canvas.Style = 2;
			if (Inv.Charge > 10)
				Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.PowerJump", class'Texture')),ResScale);
			else
			{
				if (Inv.Charge % 2 > 0)
					Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.PowerJumpl", class'Texture')),ResScale);
				else 
					Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.PowerJump", class'Texture')),ResScale);
			}
		}

	}
	Canvas.Style = 1;

}

simulated function DrawAmmo(Canvas Canvas)
{
	local int AmmoIconSize, RedlineCount;
	local Inventory Inv;

	if ( (Pawn(Owner).Weapon == None) || (Pawn(Owner).Weapon.AmmoType == None) )
		return;

	Canvas.Style = 2;

	Canvas.CurX = Canvas.ClipX-64*ResScale;
	Canvas.CurY = Canvas.ClipY-(52+121)*ResScale;
	Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.BackHalfHud", class'Texture')), ResScale);

	if ((Pawn(Owner).Weapon != None) &&
	(Pawn(Owner).Weapon.AmmoType != None) && (Pawn(Owner).Weapon.AmmoType.AmmoAmount>0) ) 
	{
		RedlineCount=Pawn(Owner).Weapon.AmmoType.MaxAmmo*0.2;

		Canvas.CurX = Canvas.ClipX-36*ResScale;
		Canvas.CurY = Canvas.ClipY-52*ResScale;
		AmmoIconSize = 104.0*ResScale*FMin(1.0,(float(Pawn(Owner).Weapon.AmmoType.AmmoAmount)/float(Pawn(Owner).Weapon.AmmoType.MaxAmmo)));

		Canvas.CurY -= AmmoIconSize;
		Canvas.DrawColor.g = 255;
		Canvas.DrawColor.r = 0;		
		Canvas.DrawColor.b = 0;					
		if (Pawn(Owner).Weapon.AmmoType.AmmoAmount<=RedlineCount) 
		{
			Canvas.DrawColor.r = 255;
			Canvas.DrawColor.g = 0;				
		}
		if (Pawn(Owner).Weapon.AmmoType.AmmoAmount >0) 
			Canvas.DrawTile(Texture(DynamicLoadObject("NerfRes.HudGreenAmmo", class'Texture')),32.0*ResScale,AmmoIconSize,0,0,32.0*ResScale,AmmoIconSize);		

		Canvas.DrawColor.g = 255;
		Canvas.DrawColor.r = 255;		
		Canvas.DrawColor.b = 255;	
	}

	Canvas.CurX = Canvas.ClipX-256*ResScale;
	Canvas.CurY = Canvas.ClipY-52*ResScale;

	Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.HalfHud", class'Texture')), ResScale);	
	Canvas.CurX = Canvas.ClipX-64*ResScale;

	Canvas.CurY -= 121*ResScale;
	Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.TopHalfHud", class'Texture')), ResScale);

	Canvas.CurY = Canvas.ClipY-80*ResScale;
	Canvas.CurX = Canvas.ClipX-72*ResScale;

	if (bLowRes)
		Canvas.Font = Font(DynamicLoadObject("NerfRes.RankingSmallFont", class'Font'));
	else
		Canvas.Font = Font(DynamicLoadObject("NerfRes.RankingFont", class'Font'));

	if (Pawn(Owner).Weapon.AmmoType.AmmoAmount>=100) Canvas.CurX -= 16*ResScale;
	if (Pawn(Owner).Weapon.AmmoType.AmmoAmount>=10) Canvas.CurX -= 16*ResScale;

	if (Pawn(Owner).Weapon.IsA('SShot'))
	{
		Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.Infinity", class'Texture')), ResScale);
	}
	else
		Canvas.DrawText(Pawn(Owner).Weapon.AmmoType.AmmoAmount,False);

	for ( Inv=Owner.Inventory; Inv!=None; Inv=Inv.Inventory )
	{
		if ( (Inv.InventoryGroup>0) && (Weapon(Inv)!=None) ) 
		{
			if (Pawn(Owner).Weapon == Inv)
			{
				Canvas.CurX = Canvas.ClipX - 90*ResScale;
				Canvas.CurY = Canvas.ClipY - 48*ResScale;

				if ((Pawn(Owner).Weapon.AmmoType != None)
				&& (Pawn(Owner).Weapon.AmmoType.AmmoAmount<=RedlineCount))
				{
					switch(Inv.InventoryGroup)
					{
						case 1:	Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.HUDWeap1", class'Texture')), ResScale);
								break;
						case 2:	Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.HUDWeap2l", class'Texture')), ResScale);
								break;
						case 3:	Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.HUDWeap3l", class'Texture')), ResScale);
								break;
						case 4:	Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.HUDWeap4l", class'Texture')), ResScale);
								break;
						case 5:	Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.HUDWeap5l", class'Texture')), ResScale);
								break;
						case 6:	Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.HUDWeap6l", class'Texture')), ResScale);
								break;
						case 7:	Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.HUDWeap7l", class'Texture')), ResScale);
								break;
						case 8:	Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.HUDWeap8l", class'Texture')), ResScale);
								break;
						case 9:	Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.HUDWeap9l", class'Texture')), ResScale);
								break;
						case 10:Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.HUDWeap10l", class'Texture')), ResScale);
								break;
					}
				}
				else
				{
					switch(Inv.InventoryGroup)
					{
						case 1:	Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.HUDWeap1", class'Texture')), ResScale);
								break;
						case 2:	Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.HUDWeap2", class'Texture')), ResScale);
								break;
						case 3:	Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.HUDWeap3", class'Texture')), ResScale);
								break;
						case 4:	Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.HUDWeap4", class'Texture')), ResScale);
								break;
						case 5:	Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.HUDWeap5", class'Texture')), ResScale);
								break;
						case 6:	Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.HUDWeap6", class'Texture')), ResScale);
								break;
						case 7:	Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.HUDWeap7", class'Texture')), ResScale);
								break;
						case 8:	Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.HUDWeap8", class'Texture')), ResScale);
								break;
						case 9:	Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.HUDWeap9", class'Texture')), ResScale);
								break;
						case 10:Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.HUDWeap10", class'Texture')), ResScale);
								break;
					}
				}

					Canvas.CurX = Canvas.ClipX - 130*ResScale;
					Canvas.CurY = Canvas.ClipY - 37*ResScale;

				switch(Inv.InventoryGroup)
				{
					case 1:	
					case 3:	Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.AmmoDart", class'Texture')), ResScale);
							break;
					case 2:
					case 6:	Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.AmmoBall", class'Texture')), ResScale);
							break;	
					case 7:
					case 8: Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.AmmoRox", class'Texture')), ResScale);
							break;
					case 9: Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.AmmoDisk", class'Texture')), ResScale);
							break;
					case 4: Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.AmmoScat", class'Texture')), ResScale);
							break;
					case 5: Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.AmmoMMBall", class'Texture')), ResScale);
							break;
					case 10:Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.AmmoWhom", class'Texture')), ResScale);
							break;

				}
			}
		}

	}
}

simulated function DrawHealth(Canvas Canvas)
{
	Canvas.CurY = Canvas.ClipY-52*ResScale;
	Canvas.CurX = 0;

	if (bLowRes)
		Canvas.Font = Font(DynamicLoadObject("NerfRes.RankingSmallFont", class'Font'));
	else
		Canvas.Font = Font(DynamicLoadObject("NerfRes.RankingFont", class'Font'));
	Canvas.Style = 2;
	if (Pawn(Owner).Health<25) 
		if (bLowRes)
			Canvas.Font = Font(DynamicLoadObject("NerfRes.SmallRedFont", class'Font'));
		else
			Canvas.Font = Font(DynamicLoadObject("NerfRes.LargeRedFont", class'Font'));
	if(Pawn(Owner).Health > 100)
		Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.IconHealth200", class'Texture')), ResScale);
	else if (Pawn(Owner).Health > 90)
		Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.IconHealth100", class'Texture')), ResScale);
	else if (Pawn(Owner).Health > 80)
		Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.IconHealth90", class'Texture')), ResScale);
	else if (Pawn(Owner).Health > 70)
		Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.IconHealth80", class'Texture')), ResScale);
	else if (Pawn(Owner).Health > 60)
		Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.IconHealth70", class'Texture')), ResScale);
	else if (Pawn(Owner).Health > 50)
		Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.IconHealth60", class'Texture')), ResScale);
	else if (Pawn(Owner).Health > 25)
		Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.IconHealth50", class'Texture')), ResScale);
	else if (Pawn(Owner).Health > 10)
	{
		if (int(Level.TimeSeconds) % 4 == 0)
		{
			Owner.PlaySound(Sound(DynamicLoadObject("NerfRes.LowHealthS", class'Sound')), SLOT_Interface);
		}
		Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.IconHealth25", class'Texture')), ResScale);
	}
	else if (Pawn(Owner).Health > 0)
	{
		if (int(Level.TimeSeconds) % 3 == 0)
		{
			Owner.PlaySound(Sound(DynamicLoadObject("NerfRes.LowHealthS", class'Sound')), SLOT_Interface);
		}
		Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.IconHealth10", class'Texture')), ResScale);
	}
	else if (Pawn(Owner).Health <= 0)
		Canvas.DrawIcon(Texture(DynamicLoadObject("NerfRes.IconHealth", class'Texture')), ResScale);
	Canvas.CurX = 32*ResScale;
	Canvas.CurY -= 28*ResScale;
	Canvas.DrawText(Max(0,Pawn(Owner).Health),False);	
	Canvas.Style = 1;
}

//##nerf WES

function DrawClock( canvas Canvas )
{
	local int Hours, Minutes, Seconds;
	local int subSeconds;
	local string HourString, MinuteString, SecondString;
	local float XL, YL;

	if (( Level.NetMode != NM_Client) && (Level.Game.bDeathMatch))
		CountDownClock=DeathMatchGame(Level.Game).RemainingTime;

	if (CountDownClock > 0 )
	{
		Seconds = CountDownClock;
		Minutes = Seconds / 60;
		Hours   = Minutes / 60;
		Minutes = Minutes - (Hours * 60);
		Seconds = Seconds - (Minutes * 60) - (Hours * 3600);;


		if (Seconds < 10)
			SecondString = "0"$Seconds;
		else
			SecondString = string(Seconds);

		if (Minutes < 10)
			MinuteString = "0"$Minutes;
		else
			MinuteString = string(Minutes);

		if (Hours < 10)
			HourString = "0"$Hours;
		else
			HourString = string(Hours);

		Canvas.bCenter = true;
		Canvas.SetPos(0, 0);
		
		if (bLowRes)
			Canvas.Font=Font(DynamicLoadObject("NerfRes.ScoreSmallFont", class'Font'));
		else
			Canvas.Font=Font(DynamicLoadObject("NerfRes.ScoreFont", class'Font'));

		Canvas.DrawText(//HourString$":"$
						MinuteString$":"$SecondString, false);
		Canvas.bCenter = false;
	}
	else return;
}

simulated function DrawStanding(Canvas Canvas)
{
	local PlayerReplicationInfo PRI;
	local int Pos;
	local float AdjScale;
	local texture Place;

//##nerf WES FIXME
// We should put a byte in the PlayerReplicationInfo to maintain the Position.
// So we don't have to do the ForEach loop every frame..

	ForEach AllActors(class'PlayerReplicationInfo', PRI )
	{
		if ( PRI.Score > Pawn(Owner).PlayerReplicationInfo.Score )
			Pos++;
	}

	Canvas.Style = 2;	
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;

	if (bLowRes)
		Canvas.Font = Font(DynamicLoadObject("NerfRes.RankingSmallFont", class'Font'));
	else
		Canvas.Font = Font(DynamicLoadObject("NerfRes.RankingFont", class'Font'));

	switch(Pos%10)
	{
		case 0: Place = Texture(DynamicLoadObject("NerfRes.First", class'Texture'));
				break;
		case 1: Place = Texture(DynamicLoadObject("NerfRes.Second", class'Texture'));
				break;
		case 2: Place = Texture(DynamicLoadObject("NerfRes.Third", class'Texture'));
				break;
		default : Place = Texture(DynamicLoadObject("NerfRes.Th", class'Texture'));
				break;

	}
	if (Pos > 9)
		Canvas.CurX = Canvas.ClipX-64*ResScale;
	else 
		Canvas.CurX = Canvas.ClipX-48*ResScale;
	Canvas.CurY = 48*ResScale;
	Canvas.Drawtext(Pos+1,false);
	Canvas.CurY = 48*ResScale;
	Canvas.DrawIcon(Place, ResScale);
}

simulated function DrawScore(Canvas Canvas)
{
	Canvas.Style = 2;	
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
	if (bLowRes)
		Canvas.Font=Font(DynamicLoadObject("NerfRes.ScoreSmallFont", class'Font'));
	else
		Canvas.Font=Font(DynamicLoadObject("NerfRes.ScoreFont", class'Font'));
	Canvas.CurY = 16*ResScale;
	Canvas.CurX = Canvas.ClipX-100*ResScale;	
	if (Pawn(Owner).PlayerReplicationInfo.Score < 10000) Canvas.CurX+=20*ResScale;
	if (Pawn(Owner).PlayerReplicationInfo.Score < 1000) Canvas.CurX+=20*ResScale;
	if (Pawn(Owner).PlayerReplicationInfo.Score < 100) Canvas.CurX+=20*ResScale;
	if (Pawn(Owner).PlayerReplicationInfo.Score < 10) Canvas.CurX+=20*ResScale;
	Canvas.Drawtext(Max(0,Pawn(Owner).PlayerReplicationInfo.Score),false);
}

simulated function DrawTypingPrompt( canvas Canvas, console Console )
{
	local string TypingPrompt;
	local float XL, YL;

	if ( Console.bTyping )
	{
		Canvas.DrawColor.r = 0;
		Canvas.DrawColor.g = 255;
		Canvas.DrawColor.b = 0;	
		TypingPrompt = "(> "$Console.TypedStr$"_";
		Canvas.Font = Font(DynamicLoadObject("NerfRes.WhiteFont", class'Font'));
		Canvas.StrLen( TypingPrompt, XL, YL );
		Canvas.SetPos( 2, Console.FrameY - Console.ConsoleLines - YL - 1 );
		Canvas.DrawText( TypingPrompt, false );
	}
}

simulated function bool DisplayMessages( canvas Canvas )
{
	local string TypingPrompt;
	local float XL, YL;
	local int I, J, YPos, ExtraSpace;
	local float PickupColor;
	local console Console;
	local inventory Inv;
	local MessageStruct ShortMessages[4];
	local string MessageString[4];
	local name MsgType;

	Console = PlayerPawn(Owner).Player.Console;

	Canvas.Font = Font(DynamicLoadObject("NerfRes.WhiteFont", class'Font'));

	if ( !Console.Viewport.Actor.bShowMenu )
		DrawTypingPrompt(Canvas, Console);

	if ( (Console.TextLines > 0) && (!Console.Viewport.Actor.bShowMenu || Console.Viewport.Actor.bShowScores) )
	{
		MsgType = Console.GetMsgType(Console.TopLine);
		if ( MsgType == 'Pickup' )
		{
			Canvas.bCenter = true;
			if ( Level.bHighDetailMode )
				Canvas.Style = ERenderStyle.STY_Translucent;
			else
				Canvas.Style = ERenderStyle.STY_Normal;
			PickupColor = 42.0 * FMin(6, Console.GetMsgTick(Console.TopLine));
			Canvas.DrawColor.r = PickupColor;
			Canvas.DrawColor.g = PickupColor;
			Canvas.DrawColor.b = PickupColor;
			Canvas.SetPos(4, Console.FrameY - 44);
			Canvas.DrawText( Console.GetMsgText(Console.TopLine), true );
			Canvas.bCenter = false;
			Canvas.Style = 1;
			J = Console.TopLine - 1;
		} 
		else if ( (MsgType == 'CriticalEvent') || (MsgType == 'LowCriticalEvent')
					|| (MsgType == 'RedCriticalEvent') ) 
		{
			Canvas.bCenter = true;
			Canvas.Style = 1;
			Canvas.DrawColor.r = 0;
			Canvas.DrawColor.g = 128;
			Canvas.DrawColor.b = 255;
			if ( MsgType == 'CriticalEvent' ) 
				Canvas.SetPos(0, Console.FrameY/2 - 32);
			else if ( MsgType == 'LowCriticalEvent' ) 
				Canvas.SetPos(0, Console.FrameY/2 + 32);
			else if ( MsgType == 'RedCriticalEvent' ) {
				PickupColor = 42.0 * FMin(6, Console.GetMsgTick(Console.TopLine));
				Canvas.DrawColor.r = PickupColor;
				Canvas.DrawColor.g = 0;
				Canvas.DrawColor.b = 0;	
				Canvas.SetPos(4, Console.FrameY - 44);
			}

			Canvas.DrawText( Console.GetMsgText(Console.TopLine), true );
			Canvas.bCenter = false;
			J = Console.TopLine - 1;
		} 
		else 
			J = Console.TopLine;

		I = 0;
		while ( (I < 4) && (J >= 0) )
		{
			MsgType = Console.GetMsgType(J);
			if ((MsgType != '') && (MsgType != 'Log'))
			{
				MessageString[I] = Console.GetMsgText(J);
				if ( (MessageString[I] != "") && (Console.GetMsgTick(J) > 0.0) )
				{
					if ( (MsgType == 'Event') || (MsgType == 'DeathMessage') )
					{
						ShortMessages[I].PRI = None;
						ShortMessages[I].Type = MsgType;
						I++;
					} 
					else if ( (MsgType == 'Say') || (MsgType == 'TeamSay') )
					{
						ShortMessages[I].PRI = Console.GetMsgPlayer(J);
						ShortMessages[I].Type = MsgType;
						I++;
					}
				}
			}
			J--;
		}

		// decide which speech message to show face for
		// FIXME - get the face from the PlayerReplicationInfo.TalkTexture
		J = 0;
		Canvas.Font = Font(DynamicLoadObject("NerfRes.WhiteFont", class'Font'));
		Canvas.StrLen("TEST", XL, YL );
		for ( I=0; I<4; I++ )
			if (MessageString[3 - I] != "")
			{
				YPos = 2 + (10 * J) + (10 * ExtraSpace); 
				if ( !DrawMessageHeader(Canvas, ShortMessages[3 - I], YPos) )
				{
					if (ShortMessages[3 - I].Type == 'DeathMessage')
						Canvas.DrawColor = RedColor;
					else 
					{
						Canvas.DrawColor.r = 200;
						Canvas.DrawColor.g = 200;
						Canvas.DrawColor.b = 200;	
					}
					Canvas.SetPos(4, YPos);
				}
				if ( !SpecialType(ShortMessages[3 - I].Type) ) {
					Canvas.DrawText(MessageString[3-I], false );
					J++;
				}
				if ( YL == 18.0 )
					ExtraSpace++;
			}
	}
	return true;
}

simulated function bool SpecialType(Name Type)
{
	if (Type == '')
		return true;
	if (Type == 'Log')
		return true;
	if (Type == 'Pickup')
		return true;
	if (Type == 'CriticalEvent')
		return true;
	if (Type == 'LowCriticalEvent')
		return true;
	if (Type == 'RedCriticalEvent')
		return true;
	return false;
}

simulated function float DrawNextMessagePart( Canvas Canvas, coerce string MString, float XOffset, int YPos )
{
	local float XL, YL;

	Canvas.SetPos(4 + XOffset, YPos);
	Canvas.StrLen( MString, XL, YL );
	XOffset += XL;
	Canvas.DrawText( MString, false );
	return XOffset;
}

simulated function bool DrawMessageHeader(Canvas Canvas, MessageStruct ShortMessage, int YPos)
{
	local float XOffset;

	if ( ShortMessage.Type != 'Say' )
		return false;

	Canvas.DrawColor = GreenColor;
	XOffset += ArmorOffset;
	XOffset = DrawNextMessagePart(Canvas, ShortMessage.PRI.PlayerName$": ", XOffset, YPos);	
	Canvas.SetPos(4 + XOffset, YPos);
	return true;
}

simulated function Tick(float DeltaTime)
{
	IdentifyFadeTime -= DeltaTime;
	if (IdentifyFadeTime < 0.0)
		IdentifyFadeTime = 0.0;

	MOTDFadeOutTime -= DeltaTime * 45;
	if (MOTDFadeOutTime < 0.0)
		MOTDFadeOutTime = 0.0;
}

simulated function bool TraceIdentify(canvas Canvas)
{
	local actor Other;
	local vector HitLocation, HitNormal, X, Y, Z, StartTrace, EndTrace;

	StartTrace = Owner.Location;
	StartTrace.Z += Pawn(Owner).BaseEyeHeight;

	EndTrace = StartTrace + vector(Pawn(Owner).ViewRotation) * 1000.0;

	Other = Trace(HitLocation, HitNormal, EndTrace, StartTrace, true);

	if ( (Pawn(Other) != None) && (Pawn(Other).bIsPlayer) )
	{
		IdentifyTarget = Pawn(Other);
		IdentifyFadeTime = 3.0;
	}

	if ( IdentifyFadeTime == 0.0 )
		return false;

	if ( (IdentifyTarget == None) || (!IdentifyTarget.bIsPlayer) ||
		 (IdentifyTarget.bHidden) || (IdentifyTarget.PlayerReplicationInfo == None ))
		return false;

	return true;
}

simulated function DrawIdentifyInfo(canvas Canvas, float PosX, float PosY)
{
	local float XL, YL, XOffset;

//##nerf WES 
// Dave's Bot debugging state identify code.
	local NerfBots B;
	local string PlayerName;
	local string S;
	local string Topic;
	local int Depth, Dynamic;


	if (IdentifyTarget == None)
		return;

	PlayerName = IdentifyTarget.PlayerReplicationInfo.PlayerName;

	if (!TraceIdentify(Canvas))
		return;

	Canvas.Font = Font(DynamicLoadObject("NerfRes.WhiteFont", class'Font'));
	Canvas.Style = 3;

	XOffset = 0.0;
	Canvas.StrLen(IdentifyName$": "$IdentifyTarget.PlayerReplicationInfo.PlayerName, XL, YL);
	XOffset = Canvas.ClipX/2 - XL/2;
	Canvas.SetPos(XOffset, Canvas.ClipY - 54);
	
	if(IdentifyTarget.IsA('PlayerPawn'))
		if(PlayerPawn(IdentifyTarget).PlayerReplicationInfo.bFeigningDeath)
			return;

	if(IdentifyTarget.PlayerReplicationInfo.PlayerName != "")
	{
		Canvas.DrawColor.R = 0;
		Canvas.DrawColor.G = 160 * (IdentifyFadeTime / 3.0);
		Canvas.DrawColor.B = 0;

		Canvas.StrLen(IdentifyName$": ", XL, YL);
		XOffset += XL;
		Canvas.DrawText(IdentifyName$": ");
		Canvas.SetPos(XOffset, Canvas.ClipY - 54);

		Canvas.DrawColor.R = 0;
		Canvas.DrawColor.G = 255 * (IdentifyFadeTime / 3.0);
		Canvas.DrawColor.B = 0;

		Canvas.StrLen(IdentifyTarget.PlayerReplicationInfo.PlayerName, XL, YL);
		Canvas.DrawText(IdentifyTarget.PlayerReplicationInfo.PlayerName);

//##nerf WES 
// Dave's code.
		GetTrace(Topic, Depth, Dynamic);
		if (Dynamic < 0)
		{
			// for debugging only

			// find the playerpawn for the target
			foreach AllActors(class'NerfBots', B)
				if (B.PlayerReplicationInfo.PlayerName == PlayerName)
					break;			// found it

			if (B != None)
			{
				S = "State: " $ B.GetStateName();
			}
			else
				S = "State is unknown";

			Canvas.StrLen(S, XL, YL);
			Canvas.DrawColor.R = 255 * (IdentifyFadeTime / 3.0);
			Canvas.DrawColor.G = 0;
			Canvas.DrawColor.B = 0;

			Canvas.SetPos(Canvas.ClipX/2 - XL/2, Canvas.ClipY - 44);
			Canvas.DrawText(S);

			S = "MoveTarget: " $ B.MoveTarget;
			Canvas.StrLen(S, XL, YL);
			Canvas.SetPos(Canvas.ClipX/2 - XL/2, Canvas.ClipY - 33);
			Canvas.DrawText(S);
		}
		else if (Dynamic > 0)
			SetTrace(PlayerName, Depth, Dynamic);
			
	}

	Canvas.Style = 1;
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
}

simulated function DrawMOTD(Canvas Canvas)
{
	local GameReplicationInfo GRI;
	local float XL, YL;

	if(Owner == None) return;

	Canvas.Font = Font(DynamicLoadObject("NerfRes.WhiteFont", class'Font'));
	Canvas.Style = 3;

	Canvas.DrawColor.R = MOTDFadeOutTime;
	Canvas.DrawColor.G = MOTDFadeOutTime;
	Canvas.DrawColor.B = MOTDFadeOutTime;

	Canvas.bCenter = true;

	foreach AllActors(class'GameReplicationInfo', GRI)
	{
		if (GRI.GameName != "Game")
		{
			Canvas.DrawColor.R = 0;
			Canvas.DrawColor.G = MOTDFadeOutTime / 2;
			Canvas.DrawColor.B = MOTDFadeOutTime;
			Canvas.SetPos(0.0, 32);
			Canvas.StrLen("TEST", XL, YL);
			if (Level.NetMode != NM_Standalone)
				Canvas.DrawText(GRI.ServerName);
			Canvas.DrawColor.R = MOTDFadeOutTime;
			Canvas.DrawColor.G = MOTDFadeOutTime;
			Canvas.DrawColor.B = MOTDFadeOutTime;

			Canvas.SetPos(0.0, 32 + YL);
			Canvas.DrawText("Game Type: "$GRI.GameName, true);
			Canvas.SetPos(0.0, 32 + 2*YL);
			Canvas.DrawText("Map Title: "$Level.Title, true);
			Canvas.SetPos(0.0, 32 + 3*YL);
			Canvas.DrawText("Author: "$Level.Author, true);
			Canvas.SetPos(0.0, 32 + 4*YL);
			if (Level.IdealPlayerCount != "")
				Canvas.DrawText("Ideal Player Load:"$Level.IdealPlayerCount, true);

			Canvas.DrawColor.R = 0;
			Canvas.DrawColor.G = MOTDFadeOutTime / 2;
			Canvas.DrawColor.B = MOTDFadeOutTime;

			Canvas.SetPos(0, 32 + 6*YL);
			Canvas.DrawText(Level.LevelEnterText, true);

			Canvas.SetPos(0.0, 32 + 8*YL);
			Canvas.DrawText(GRI.MOTDLine1, true);
			Canvas.SetPos(0.0, 32 + 9*YL);
			Canvas.DrawText(GRI.MOTDLine2, true);
			Canvas.SetPos(0.0, 32 + 10*YL);
			Canvas.DrawText(GRI.MOTDLine3, true);
			Canvas.SetPos(0.0, 32 + 11*YL);
			Canvas.DrawText(GRI.MOTDLine4, true);
		}
	}
	Canvas.bCenter = false;

	Canvas.Style = 1;
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
}

simulated function Message( PlayerReplicationInfo PRI, coerce string Msg, name MsgType )
{
	local int i;
	local Class<LocalMessage> MessageClass;

	switch (MsgType)
	{
/*
		case 'Say':
		case 'TeamSay':
			MessageClass = class'SayMessagePlus';
			break;
		case 'CriticalEvent':
			MessageClass = class'CriticalStringPlus';
			LocalizedMessage( MessageClass, 0, None, None, None, Msg );
			return;
		case 'DeathMessage':
			MessageClass = class'RedSayMessagePlus';
			break;
		case 'Pickup':
			PickupTime = Level.TimeSeconds;

		default:
			MessageClass = class'StringMessagePlus';
			break;
*/
		default: 
			MessageClass = class'LocalMessagePlus';
	}

	for (i=0; i<4; i++)
	{
		if ( ShortMessageQueue[i].Message == None )
		{
			// Add the message here.
			ShortMessageQueue[i].Message = MessageClass;
			ShortMessageQueue[i].Switch = 0;
			ShortMessageQueue[i].RelatedPRI_1 = PRI;
			ShortMessageQueue[i].RelatedPRI_2 = None;
			ShortMessageQueue[i].OptionalObject = None;
			ShortMessageQueue[i].EndOfLife = MessageClass.Default.Lifetime + Level.TimeSeconds;
			ShortMessageQueue[i].bIsString = True;
			ShortMessageQueue[i].StringMessage = Msg;
			return;
		}
	}

	// No empty slots.  Force a message out.
	for (i=0; i<3; i++)
	{
		ShortMessageQueue[i].Message = ShortMessageQueue[i+1].Message;
		ShortMessageQueue[i].Switch = ShortMessageQueue[i+1].Switch;
		ShortMessageQueue[i].RelatedPRI_1 = ShortMessageQueue[i+1].RelatedPRI_1;
		ShortMessageQueue[i].RelatedPRI_2 = ShortMessageQueue[i+1].RelatedPRI_2;
		ShortMessageQueue[i].OptionalObject = ShortMessageQueue[i+1].OptionalObject;
		ShortMessageQueue[i].EndOfLife = ShortMessageQueue[i+1].EndOfLife;
		ShortMessageQueue[i].bIsString = ShortMessageQueue[i+1].bIsString;
		ShortMessageQueue[i].StringMessage = ShortMessageQueue[i+1].StringMessage;
	}
	ShortMessageQueue[3].Message = MessageClass;
	ShortMessageQueue[3].Switch = 0;
	ShortMessageQueue[3].RelatedPRI_1 = PRI;
	ShortMessageQueue[3].RelatedPRI_2 = None;
	ShortMessageQueue[3].OptionalObject = None;
	ShortMessageQueue[3].EndOfLife = MessageClass.Default.Lifetime + Level.TimeSeconds;
	ShortMessageQueue[3].bIsString = True;
	ShortMessageQueue[3].StringMessage = Msg;
}

simulated function LocalizedMessage( class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject, optional String CriticalString )
{
	local int i;

/*
	if ( ClassIsChildOf( Message, class'PickupMessagePlus' ) )
		PickupTime = Level.TimeSeconds;
*/
	if ( !Message.Default.bIsSpecial )
	{
		// Find an empty slot.
		for (i=0; i<4; i++)
		{
			if ( ShortMessageQueue[i].Message == None )
			{
				ShortMessageQueue[i].Message = Message;
				ShortMessageQueue[i].Switch = Switch;
				ShortMessageQueue[i].RelatedPRI_1 = RelatedPRI_1;
				ShortMessageQueue[i].RelatedPRI_2 = RelatedPRI_2;
				ShortMessageQueue[i].OptionalObject = OptionalObject;
				ShortMessageQueue[i].EndOfLife = Message.Default.Lifetime + Level.TimeSeconds;
				ShortMessageQueue[i].bIsString = False;
				ShortMessageQueue[i].StringMessage = "";
				return;
			}

		}
		// No empty slots.  Force a message out.
		for (i=0; i<3; i++)
		{
			ShortMessageQueue[i].Message = ShortMessageQueue[i+1].Message;
			ShortMessageQueue[i].Switch = ShortMessageQueue[i+1].Switch;
			ShortMessageQueue[i].RelatedPRI_1 = ShortMessageQueue[i+1].RelatedPRI_1;
			ShortMessageQueue[i].RelatedPRI_2 = ShortMessageQueue[i+1].RelatedPRI_2;
			ShortMessageQueue[i].OptionalObject = ShortMessageQueue[i+1].OptionalObject;
			ShortMessageQueue[i].EndOfLife = ShortMessageQueue[i+1].EndOfLife;
			ShortMessageQueue[i].bIsString = ShortMessageQueue[i+1].bIsString;
			ShortMessageQueue[i].StringMessage = ShortMessageQueue[i+1].StringMessage;
		}
		ShortMessageQueue[3].Message = Message;
		ShortMessageQueue[3].Switch = Switch;
		ShortMessageQueue[3].RelatedPRI_1 = RelatedPRI_1;
		ShortMessageQueue[3].RelatedPRI_2 = RelatedPRI_2;
		ShortMessageQueue[3].OptionalObject = OptionalObject;
		ShortMessageQueue[3].EndOfLife = Message.Default.Lifetime + Level.TimeSeconds;
		ShortMessageQueue[3].bIsString = False;
		ShortMessageQueue[3].StringMessage = "";
		return;
	} else {
		if ( Message.Default.bIsUnique )
		{
			for (i=0; i<16; i++)
			{
				if (LocalMessages[i].Message != None)
				{
					if ((LocalMessages[i].Message == Message) ||
						((LocalMessages[i].Message.Default.YPos == Message.Default.YPos) &&
						 (!LocalMessages[i].Message.Default.bOffsetYPos)))
					{
						LocalMessages[i].Message = Message;
						LocalMessages[i].Switch = Switch;
						LocalMessages[i].RelatedPRI_1 = RelatedPRI_1;
						LocalMessages[i].RelatedPRI_2 = RelatedPRI_2;
						LocalMessages[i].OptionalObject = OptionalObject;
						LocalMessages[i].EndOfLife = Message.Default.Lifetime + Level.TimeSeconds;
						LocalMessages[i].bIsString = False;
						LocalMessages[i].StringMessage = CriticalString;
						return;
					}
				}
			}
		}
		for (i=0; i<16; i++)
		{
			if (LocalMessages[i].Message == None)
			{
				LocalMessages[i].Message = Message;
				LocalMessages[i].Switch = Switch;
				LocalMessages[i].RelatedPRI_1 = RelatedPRI_1;
				LocalMessages[i].RelatedPRI_2 = RelatedPRI_2;
				LocalMessages[i].OptionalObject = OptionalObject;
				LocalMessages[i].EndOfLife = Message.Default.Lifetime + Level.TimeSeconds;
				LocalMessages[i].bIsString = False;
				LocalMessages[i].StringMessage = CriticalString;
				return;
			}
		}

		// No empty slots.  Force a message out.
		for (i=0; i<15; i++)
		{
			LocalMessages[i].Message = LocalMessages[i+1].Message;
			LocalMessages[i].Switch = LocalMessages[i+1].Switch;
			LocalMessages[i].RelatedPRI_1 = LocalMessages[i+1].RelatedPRI_1;
			LocalMessages[i].RelatedPRI_2 = LocalMessages[i+1].RelatedPRI_2;
			LocalMessages[i].OptionalObject = LocalMessages[i+1].OptionalObject;
			LocalMessages[i].EndOfLife = LocalMessages[i+1].EndOfLife;
			LocalMessages[i].bIsString = LocalMessages[i+1].bIsString;
			LocalMessages[i].StringMessage = LocalMessages[i+1].StringMessage;
		}
		LocalMessages[15].Message = Message;
		LocalMessages[15].Switch = Switch;
		LocalMessages[15].RelatedPRI_1 = RelatedPRI_1;
		LocalMessages[15].RelatedPRI_2 = RelatedPRI_2;
		LocalMessages[15].OptionalObject = OptionalObject;
		LocalMessages[15].EndOfLife = Message.Default.Lifetime + Level.TimeSeconds;
		LocalMessages[15].bIsString = False;
		LocalMessages[15].StringMessage = CriticalString;
		return;
	}
}

defaultproperties
{
     TranslatorY=-128
     CurTranY=-128
     IdentifyName=Name
     IdentifyHealth=Health
     VersionMessage=Version
     TeamName(0)=Twister Team: 
     TeamName(1)=Tycoon Team: 
     TeamName(2)=Asteroid Team: 
     TeamName(3)=Sequoia Team: 
     TeamName(4)=Luna Team: 
     TeamName(5)=Barracuda Team: 
     TeamName(6)=Orbital Team: 
     TeamName(7)=Gator Team: 
     TeamColor(0)=(R=255)
     TeamColor(1)=(G=255)
     TeamColor(2)=(B=255)
     TeamColor(3)=(R=255,G=255)
     TeamColor(4)=(R=255,B=255)
     TeamColor(5)=(G=255,B=255)
     TeamColor(6)=(R=255,G=255,B=255)
     TeamColor(7)=(R=128,G=128,B=128)
     AltTeamColor(0)=(R=128)
     AltTeamColor(1)=(G=128)
     AltTeamColor(2)=(B=128)
     AltTeamColor(3)=(R=128,G=128)
     AltTeamColor(4)=(R=128,B=128)
     AltTeamColor(5)=(G=128,B=128)
     AltTeamColor(6)=(R=128,G=128,B=128)
     AltTeamColor(7)=(R=255,G=255,B=255)
     RedColor=(R=255)
     GreenColor=(G=255)
     ScoreTime=-10000000.000000
     MainMenuType=Class'NerfI.NerfMainMenu'
}
