//=============================================================================
// Resource
//
// Master class of all NerfI menus.  Contains nonstyle specific utilities
// for all menu types (Info/Long/Short).
//
// Integrated by Wezo 7-8-99
//=============================================================================
class Resource extends Object;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
//
//					*********** Textures *************
//
//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

//##nerf WES Textures FIXME
// Need our fonts and art. These are from Unreal.
//************************ NerfMenu *********************************************
#exec Font Import File=g:\NerfRes\NerfMesh\Textures\TinyFont.pcx Name=TinyFont MIPS=OFF
#exec Font Import File=g:\NerfRes\NerfMesh\Textures\TinyFon3.pcx Name=TinyWhiteFont MIPS=OFF
#exec Font Import File=g:\NerfRes\NerfMesh\Textures\TinyFon2.pcx Name=TinyRedFont MIPS=OFF
#exec Font Import File=g:\NerfRes\NerfMesh\Textures\MedFont3.pcx Name=WhiteFont MIPS=OFF

//#exec Texture Import File=g:\NerfRes\NerfMesh\Textures\dot.pcx Name=Dot FLAGS=2 MIPS=OFF
#exec Texture Import File=g:\NerfRes\NerfMesh\Textures\Slide1.pcx Name=Slide1 FLAGS=2 MIPS=OFF
#exec Texture Import File=g:\NerfRes\NerfMesh\Textures\Slide2.pcx Name=Slide2 FLAGS=2 MIPS=OFF
#exec Texture Import File=g:\NerfRes\NerfMesh\Textures\Slide3.pcx Name=Slide3 FLAGS=2 MIPS=OFF
#exec Texture Import File=g:\NerfRes\NerfMesh\Textures\Slide4.pcx Name=Slide4 FLAGS=2 MIPS=OFF
//#exec Texture Import File=g:\NerfRes\NerfMesh\Textures\ex.pcx Name=ex FLAGS=2 MIPS=OFF
//#exec Texture Import File=g:\NerfRes\NerfMesh\Textures\check.pcx Name=Check FLAGS=2 MIPS=OFF

//##nerf WES FIXME
// These are unreal pictures
//************************ NerfOptionMenu *********************************************
#exec Texture Import File=g:\NerfRes\NerfMesh\Textures\hud1.pcx Name=Hud1 MIPS=OFF
#exec Texture Import File=g:\NerfRes\NerfMesh\Textures\hud2.pcx Name=Hud2 MIPS=OFF
#exec Texture Import File=g:\NerfRes\NerfMesh\Textures\hud3.pcx Name=Hud3 MIPS=OFF
#exec Texture Import File=g:\NerfRes\NerfMesh\Textures\hud4.pcx Name=Hud4 MIPS=OFF
#exec Texture Import File=g:\NerfRes\NerfMesh\Textures\hud5.pcx Name=Hud5 MIPS=OFF
#exec Texture Import File=g:\NerfRes\NerfMesh\Textures\hud6.pcx Name=Hud6 MIPS=OFF

//************************ NerfHud *********************************************
//HUD Icons
#exec TEXTURE IMPORT NAME=HudLine FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\Line.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=HudGreenAmmo FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\greenammo.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=IconSelection FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\i_rim.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=IconScore FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\i_score.PCX GROUP="Icons" FLAGS=2 MIPS=OFF

//Health Icons
#exec TEXTURE IMPORT NAME=IconHealth FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\i_health.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=IconHealth10 FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\i_health_b.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=IconHealth25 FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\i_health_c.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=IconHealth50 FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\i_health_d.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=IconHealth60 FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\i_health_e.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=IconHealth70 FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\i_health_f.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=IconHealth80 FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\i_health_g.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=IconHealth90 FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\i_health_h.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=IconHealth100 FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\i_health_i.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=IconHealth200 FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\i_health_j.PCX GROUP="Icons" FLAGS=2 MIPS=OFF

//HUD Ammo Icon
#exec TEXTURE IMPORT NAME=HalfHud FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\HalfHud.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=BackHalfHud FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\HalfHud_a.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=TopHalfHud FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\HalfHud_b.PCX GROUP="Icons" FLAGS=2 MIPS=OFF

//HUD Weapon Icon
#exec TEXTURE IMPORT NAME=HUDWeap1 FILE=g:\NerfRes\WeaponMesh\TEXTURES\HUD\I_Secretshot_a.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
//#exec TEXTURE IMPORT NAME=HUDWeap1l FILE=g:\NerfRes\WeaponMesh\TEXTURES\HUD\I_Secretshot_b.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=HUDWeap2 FILE=g:\NerfRes\WeaponMesh\TEXTURES\HUD\I_Ballzooka_a.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=HUDWeap2l FILE=g:\NerfRes\WeaponMesh\TEXTURES\HUD\I_Ballzooka_b.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=HUDWeap3 FILE=g:\NerfRes\WeaponMesh\TEXTURES\HUD\I_Wildfire_a.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=HUDWeap3l FILE=g:\NerfRes\WeaponMesh\TEXTURES\HUD\I_Wildfire_b.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=HUDWeap4 FILE=g:\NerfRes\WeaponMesh\TEXTURES\HUD\I_Scattershot_a.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=HUDWeap4l FILE=g:\NerfRes\WeaponMesh\TEXTURES\HUD\I_Scattershot_b.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=HUDWeap5 FILE=g:\NerfRes\WeaponMesh\TEXTURES\HUD\I_MightMo_a.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=HUDWeap5l FILE=g:\NerfRes\WeaponMesh\TEXTURES\HUD\I_MightMo_b.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=HUDWeap6 FILE=g:\NerfRes\WeaponMesh\TEXTURES\HUD\I_Pulsator_a.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=HUDWeap6l FILE=g:\NerfRes\WeaponMesh\TEXTURES\HUD\I_Pulsator_b.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=HUDWeap7 FILE=g:\NerfRes\WeaponMesh\TEXTURES\HUD\I_Tripleshot_a.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=HUDWeap7l FILE=g:\NerfRes\WeaponMesh\TEXTURES\HUD\I_Tripleshot_b.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=HUDWeap8 FILE=g:\NerfRes\WeaponMesh\TEXTURES\HUD\I_Hypershot_a.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=HUDWeap8l FILE=g:\NerfRes\WeaponMesh\TEXTURES\HUD\I_Hypershot_b.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=HUDWeap9 FILE=g:\NerfRes\WeaponMesh\TEXTURES\HUD\I_Sidewinder_a.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=HUDWeap9l FILE=g:\NerfRes\WeaponMesh\TEXTURES\HUD\I_Sidewinder_b.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=HUDWeap10 FILE=g:\NerfRes\WeaponMesh\TEXTURES\HUD\I_Whomper_a.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=HUDWeap10l FILE=g:\NerfRes\WeaponMesh\TEXTURES\HUD\I_Whomper_b.PCX GROUP="Icons" FLAGS=2 MIPS=OFF

//HUD Weapon Ammo
#exec TEXTURE IMPORT NAME=AmmoBall FILE=g:\NerfRes\WeaponMesh\TEXTURES\HUD\ball.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=AmmoRox FILE=g:\NerfRes\WeaponMesh\TEXTURES\HUD\rocket.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=AmmoDart FILE=g:\NerfRes\WeaponMesh\TEXTURES\HUD\Darts.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=AmmoDisk FILE=g:\NerfRes\WeaponMesh\TEXTURES\HUD\Disks.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=AmmoMMBall FILE=g:\NerfRes\WeaponMesh\TEXTURES\HUD\MOballs.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=AmmoScat FILE=g:\NerfRes\WeaponMesh\TEXTURES\HUD\ScatAmmo.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=AmmoWhom FILE=g:\NerfRes\WeaponMesh\TEXTURES\HUD\WhomperAmmo.PCX GROUP="Icons" FLAGS=2 MIPS=OFF

#exec TEXTURE IMPORT NAME=Crosshair1 FILE=g:\NerfRes\NerfMesh\Textures\Hud\chair1.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=Crosshair2 FILE=g:\NerfRes\NerfMesh\Textures\Hud\chair2.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=Crosshair3 FILE=g:\NerfRes\NerfMesh\Textures\Hud\chair3.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=Crosshair4 FILE=g:\NerfRes\NerfMesh\Textures\Hud\chair4.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=Crosshair5 FILE=g:\NerfRes\NerfMesh\Textures\Hud\chair5.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=Crosshair6 FILE=g:\NerfRes\NerfMesh\Textures\Hud\chair6.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=Crosshair7 FILE=g:\NerfRes\NerfMesh\Textures\Hud\chair7.PCX GROUP="Icons" FLAGS=2 MIPS=OFF

//Flag Icons
#exec TEXTURE IMPORT NAME=Flagoff FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\flag_strip32_low.PCX  GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=BFlagon FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\flag_32_blue.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=GFlagon FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\flag_32_green.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=YFlagon FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\flag_32_yellow.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=OFlagon FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\flag_32_orange.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=RFlagon FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\flag_32_red.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=PFlagon FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\flag_32_purple.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=GOFlagon FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\flag_32_gold.PCX GROUP="Icons" FLAGS=2 MIPS=OFF

//Flag Holding
#exec TEXTURE IMPORT NAME=BFlagHold FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\flag_32_blue_med.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=GFlagHold FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\flag_32_green_med.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=YFlagHold FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\flag_32_yellow_med.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=OFlagHold FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\flag_32_orange_med.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=RFlagHold FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\flag_32_red_med.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=PFlagHold FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\flag_32_purple_med.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=GOFlagHold FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\flag_32_gold_med.PCX GROUP="Icons" FLAGS=2 MIPS=OFF

//Ball Icons
#exec TEXTURE IMPORT NAME=Balloff FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\Ball_strip32_low.PCX  GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=BBallon FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\Ball_big32_blue.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=GBallon FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\Ball_big32_green.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=YBallon FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\Ball_big32_yellow.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=OBallon FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\Ball_big32_orange.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=RBallon FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\Ball_big32_red.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=PBallon FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\Ball_big32_purple.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=GOBallon FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\Ball_big32_gold.PCX GROUP="Icons" FLAGS=2 MIPS=OFF

//Ball Holding
#exec TEXTURE IMPORT NAME=BBallHold FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\Ball_bigger32_blue.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=GBallHold FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\Ball_bigger32_green.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=YBallHold FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\Ball_bigger32_yellow.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=OBallHold FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\Ball_bigger32_orange.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=RBallHold FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\Ball_bigger32_red.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=PBallHold FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\Ball_bigger32_purple.PCX GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=GOBallHold FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\bigger32_gold.PCX GROUP="Icons" FLAGS=2 MIPS=OFF

// Ranking 
#exec TEXTURE IMPORT NAME=First FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\st.PCX GROUP="Icons" MIPS=OFF FLAGS=2
#exec TEXTURE IMPORT NAME=Second FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\nd.PCX GROUP="Icons" MIPS=OFF FLAGS=2
#exec TEXTURE IMPORT NAME=Third FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\rd.PCX GROUP="Icons" MIPS=OFF FLAGS=2
#exec TEXTURE IMPORT NAME=Th FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\th.PCX GROUP="Icons" MIPS=OFF FLAGS=2

// Ranking Number font
#exec FONT IMPORT FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\PlaceNumbers2.PCX NAME=RankingFont Mips=Off Flags=2
#exec FONT IMPORT FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\PlaceNumbers2small.PCX NAME=RankingSmallFont Mips=Off Flags=2
#exec FONT IMPORT FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\PlaceNumbers.PCX NAME=ScoreFont Mips=Off Flags=2
#exec FONT IMPORT FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\PlaceNumberssmall.PCX NAME=ScoreSmallFont Mips=Off Flags=2
#exec FONT IMPORT FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\PNum2red.PCX NAME=LargeRedFont Mips=Off Flags=2
#exec FONT IMPORT FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\PNum2Smallred.PCX NAME=SmallRedFont Mips=Off Flags=2
#exec TEXTURE IMPORT FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\Infinity.PCX NAME=Infinity Mips=Off Flags=2

// Player Marker
#exec TEXTURE IMPORT NAME=I_Marker FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\arow.pcx GROUP="Icons" FLAGS=2 MIPS=OFF

// Power ups
#exec TEXTURE IMPORT NAME=PowerupStrip FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\powerups_c.pcx GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=PowerArmor FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\powerups_s_on.pcx GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=PowerArmorl FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\powerups_s_low.pcx GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=PowerJump FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\powerups_jb_on.pcx GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=PowerJumpl FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\powerups_jb_low.pcx GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=PowerSpeed FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\powerups_sb_on.pcx GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=PowerSpeedl FILE=g:\NerfRes\NerfMesh\TEXTURES\HUD\powerups_sb_low.pcx GROUP="Icons" FLAGS=2 MIPS=OFF

//************************ Translator Hud *********************************************
//##nerf WES FIXME
// Again Unreal art.
#exec TEXTURE IMPORT NAME=TranslatorHUD3 FILE=g:\NerfRes\NerfMesh\models\TRANHUD3.PCX GROUP="Icons" FLAGS=2 MIPS=OFF

//************************ IntroNullHud *********************************************
// VMI and Nerf Logo on the startup flyby screen
#exec TEXTURE IMPORT NAME=NerfLogo FILE=g:\NerfRes\NerfMesh\TEXTURES\I_nerf.PCX MIPS=OFF Flags=2
#exec TEXTURE IMPORT NAME=VMI FILE=g:\NerfRes\NerfMesh\TEXTURES\Vmi.PCX MIPS=OFF Flags=2

//************************ Water Bubble *********************************************
//##nerf WES FIXME
// This is Unreal art. need our own.
#exec Texture Import File=g:\NerfRes\NerfMesh\models\WaterBubble1.pcx  Name=W_bubble1 Mips=Off Flags=2
#exec Texture Import File=g:\NerfRes\NerfMesh\models\WaterBubble2.pcx  Name=W_bubble2 Mips=Off Flags=2
#exec Texture Import File=g:\NerfRes\NerfMesh\models\WaterBubble3.pcx  Name=W_bubble3 Mips=Off Flags=2

//************************ Nerf Long Menu ***********************************************
#exec Texture Import File=g:\NerfRes\NerfMesh\Textures\Menutile.pcx Name=Menu2 MIPS=OFF
#exec Texture Import File=g:\NerfRes\NerfMesh\Textures\logo_01.pcx Name=NerfLogo2 MIPS=OFF Flags=2

//************************ HandTextures ******************************************************
#exec TEXTURE IMPORT NAME=Hand_back FILE=G:\NerfRes\WeaponAnimation\Textures\ballzooka_01.PCX GROUP=Skins Mips=Off FLAGS=2  //Material #7
#exec TEXTURE IMPORT NAME=Hand_in FILE=G:\NerfRes\WeaponAnimation\Textures\ballzooka_02.PCX GROUP=Skins Mips=Off FLAGS=2    //Material #8

//************************ BallSkins ******************************************************
#exec TEXTURE IMPORT NAME=YellowBallSkin FILE=g:\NerfRes\NerfMesh\MODELS\YellowBall.PCX GROUP=Skins FLAGS=2	
#exec TEXTURE IMPORT NAME=GoldBallSkin FILE=g:\NerfRes\NerfMesh\MODELS\GoldBall.PCX GROUP=Skins FLAGS=2	
#exec TEXTURE IMPORT NAME=GreenBallSkin FILE=g:\NerfRes\NerfMesh\MODELS\GreenBall.PCX GROUP=Skins FLAGS=2	
#exec TEXTURE IMPORT NAME=OrangeBallSkin FILE=g:\NerfRes\NerfMesh\MODELS\OrangeBall.PCX GROUP=Skins FLAGS=2	
#exec TEXTURE IMPORT NAME=PurpleBallSkin FILE=g:\NerfRes\NerfMesh\MODELS\PurpleBall.PCX GROUP=Skins FLAGS=2	
#exec TEXTURE IMPORT NAME=RedBallSkin FILE=g:\NerfRes\NerfMesh\MODELS\RedBall.PCX GROUP=Skins FLAGS=2	
#exec TEXTURE IMPORT NAME=BlueBallSkin FILE=g:\NerfRes\NerfMesh\MODELS\BlueBall.PCX GROUP=Skins FLAGS=2	

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
//
//					*********** Meshes *************
//
//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

//************************ Projection Screen *********************************************
/*
#exec MESH IMPORT MESH=M32Screen ANIVFILE=g:\NerfRes\NerfMesh\models\M32Screen_a.3d DATAFILE=g:\NerfRes\NerfMesh\models\M32Screen_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=M32Screen X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=M32Screen SEQ=All STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=M32Screen SEQ=Still STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=M32Screen MESH=M32Screen
#exec MESHMAP SCALE MESHMAP=M32Screen X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=ScreenPal FILE=g:\NerfRes\NerfMesh\models\DefaultPal.pcx FLAGS=2 GROUP=Skins
#exec MESHMAP SETTEXTURE MESHMAP=M32Screen NUM=0 TEXTURE=ScreenPal
*/

#exec MESH IMPORT MESH=M32Screen ANIVFILE=g:\NerfRes\WeaponMesh\MODELS\triple_shot_smoke_a.3d DATAFILE=g:\NerfRes\WeaponMesh\MODELS\triple_shot_smoke_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=M32Screen X=0 Y=0 Z=0 YAW=-64

#exec MESH SEQUENCE MESH=M32Screen SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=M32Screen SEQ=still                   STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=M32Screen MESH=M32Screen
#exec MESHMAP SCALE MESHMAP=M32Screen X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=ScreenPal FILE=g:\NerfRes\NerfMesh\models\DefaultPal.pcx FLAGS=2 GROUP=Skins
#exec MESHMAP SETTEXTURE MESHMAP=M32Screen NUM=0 TEXTURE=ScreenPal


//************************ SHBall Gun ******************************************************
// Pickup version

#exec MESH IMPORT MESH=SHpickup ANIVFILE=g:\NerfRes\weaponMesh\MODELS\mighty_a.3d DATAFILE=g:\NerfRes\weaponMesh\MODELS\mighty_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=SHpickup X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=SHpickup SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=SHpickup SEQ=idle                      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=SHpickup MESH=SHpickup
#exec MESHMAP SCALE MESHMAP=SHpickup X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jmmh_01 FILE=g:\NerfRes\weaponMesh\MODELS\mightyMoHunt.PCX GROUP=Skins FLAGS=2	//Material #7

#exec MESHMAP SETTEXTURE MESHMAP=SHpickup NUM=1 TEXTURE=Jmmh_01

// 3rd
#exec MESH IMPORT MESH=SH3rd ANIVFILE=g:\NerfRes\weaponMesh\MODELS\mighty_a.3d DATAFILE=g:\NerfRes\weaponMesh\MODELS\mighty_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=SH3rd X=0 Y=0 Z=0 PITCH=35

#exec MESH SEQUENCE MESH=SH3rd SEQ=All                      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=SH3rd MESH=SH3rd
#exec MESHMAP SCALE MESHMAP=SH3rd X=0.05 Y=0.05 Z=0.1

#exec MESHMAP SETTEXTURE MESHMAP=SH3rd NUM=1 TEXTURE=Jmmh_01

//POV

#exec MESH IMPORT MESH=SH ANIVFILE=g:\NerfRes\weaponMesh\MODELS\mmcamera_a.3d DATAFILE=g:\NerfRes\weaponMesh\MODELS\mmcamera_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=SH X=0 Y=0 Z=0 PITCH=10

#exec MESH SEQUENCE MESH=SH SEQ=All                      STARTFRAME=0 NUMFRAMES=1

//##nerf WES Textures FIXME
//No animation. In order to fix the script warning in the log. I am faking the animation.
#exec MESH SEQUENCE MESH=SH SEQ=Select		             STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=SH SEQ=Down		             STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=SH SEQ=Idle		             STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=SH SEQ=still		             STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=SH MESH=SH
#exec MESHMAP SCALE MESHMAP=SH X=0.07 Y=0.07 Z=0.14

#exec MESHMAP SETTEXTURE MESHMAP=SH NUM=1 TEXTURE=Jmmh_01

// Audio sound effects
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\pickups\pkpwr.wav" NAME="SuitpickS" GROUP="Pickups"

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
//
//					*********** Sounds *************
//
//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

// Death Sound. Only happen to the Player
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\genericfx\Ggone2.wav" NAME="DeathHitS" GROUP="Generic"

//##nerf WES FIXME
// Lava Zone in and out sound.
//#exec AUDIO IMPORT FILE="Sounds\Generic\GoopE1.WAV" NAME="LavaEx" GROUP="Generic"
//#exec AUDIO IMPORT FILE="Sounds\Generic\GoopJ1.WAV" NAME="LavaEn" GROUP="Generic"

//************************ NerfHUD ******************************************************
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\genericfx\gloenrgy.wav" NAME="LowHealthS" GROUP="SHBall"



//
//	Resources for NerfMenu package (DWG)
//

// ***NerfCard.uc:

// horiz tiled screen background
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\CardBack11.pcx Name=CardBack FLAGS=2 MIPS=OFF

// Options button
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\NameGo.pcx Name=Go FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\NameGoOver.pcx Name=GoOver FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\NameGoDown.pcx Name=GoDown FLAGS=2 MIPS=OFF


// ***NerfCardChar.uc:

// Character Card Pictures
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\CardTed.pcx Name=CardTed FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\CardJami.pcx Name=CardJami FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\CardRyan.pcx Name=CardRyan FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\CardSarge.pcx Name=CardSarge FLAGS=2 MIPS=OFF

// Previous button
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\Previous.pcx Name=Previous FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\PreviousOver.pcx Name=PreviousOver FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\PreviousDown.pcx Name=PreviousDown FLAGS=2 MIPS=OFF

// Next button
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\Next.pcx Name=Next FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\NextOver.pcx Name=NextOver FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\NextDown.pcx Name=NextDown FLAGS=2 MIPS=OFF


// ***NerfCardLevel.uc:

// Level Button
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\CardLevelButtons2.pcx Name=Level FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\CardLevelButtonsOver.pcx Name=LevelOver FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\CardLevelButtonsDown.pcx Name=LevelDown FLAGS=2 MIPS=OFF


// ***NerfCardProfile.uc:

// New Game Button
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\NewGame.pcx Name=NewGame2 FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\NewGameOver.pcx Name=NewGameOver2 FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\NewGameDown.pcx Name=NewGameDown2 FLAGS=2 MIPS=OFF

// New Player Button
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\NewPlayer.pcx Name=NewPlayer FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\NewPlayerOver.pcx Name=NewPlayerOver FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\NewPlayerDown.pcx Name=NewPlayerDown FLAGS=2 MIPS=OFF

// Delete Player Button
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\DeletePlayer.pcx Name=DeletePlayer FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\DeletePlayerOver.pcx Name=DeletePlayerOver FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\DeletePlayerDown.pcx Name=DeletePlayerDown FLAGS=2 MIPS=OFF


// ***NerfLookAndFeel.uc:

#exec TEXTURE IMPORT NAME=NerfActiveFrame FILE=G:\NerfRes\NerfMenu\Textures\Med\ActiveFrame.pcx GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=NerfInactiveFrame FILE=G:\NerfRes\NerfMenu\Textures\Med\InactiveFrame.pcx GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=NerfActiveFrameS FILE=G:\NerfRes\NerfMenu\Textures\Med\ActiveFrameS.pcx GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=NerfInactiveFrameS FILE=G:\NerfRes\NerfMenu\Textures\Med\InactiveFrameS.pcx GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=NerfMisc FILE=G:\NerfRes\NerfMenu\Textures\Med\Misc.pcx GROUP="Icons" MIPS=OFF


// ***NerfPDALow.uc:

// low-res version of background
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\MainBack11.pcx Name=LOW_MainBack11 FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\MainBack12.pcx Name=LOW_MainBack12 FLAGS=2 MIPS=OFF

// Stats button
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\Stats.pcx Name=LOW_Stats FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\StatsOver.pcx Name=LOW_StatsOver FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\StatsDown.pcx Name=LOW_StatsDown FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\StatsDisabled.pcx Name=LOW_StatsDisabled FLAGS=2 MIPS=OFF

// Options button
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\Options.pcx Name=LOW_Options FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\OptionsOver.pcx Name=LOW_OptionsOver FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\OptionsDown.pcx Name=LOW_OptionsDown FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\OptionsDisabled.pcx Name=LOW_OptionsDisabled FLAGS=2 MIPS=OFF

// Controls button
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\Controls.pcx Name=LOW_Controls FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\ControlsOver.pcx Name=LOW_ControlsOver FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\ControlsDown.pcx Name=LOW_ControlsDown FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\ControlsDisabled.pcx Name=LOW_ControlsDisabled FLAGS=2 MIPS=OFF

// Multiplayer button
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\Multi.pcx Name=LOW_MultiPlayer FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\MultiOver.pcx Name=LOW_MultiPlayerOver FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\MultiDown.pcx Name=LOW_MultiPlayerDown FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\MultiDisabled.pcx Name=LOW_MultiPlayerDisabled FLAGS=2 MIPS=OFF

// Singleplayer button
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\Single.pcx Name=LOW_SinglePlayer FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\SingleOver.pcx Name=LOW_SinglePlayerOver FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\SingleDown.pcx Name=LOW_SinglePlayerDown FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\SingleDisabled.pcx Name=LOW_SinglePlayerDisabled FLAGS=2 MIPS=OFF

// Play button
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\Play.pcx Name=LOW_Play FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\PlayOver.pcx Name=LOW_PlayOver FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\PlayDown.pcx Name=LOW_PlayDown FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\PlayDisabled.pcx Name=LOW_PlayDisabled FLAGS=2 MIPS=OFF

// New Game button
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\NewGame.pcx Name=LOW_NewGame FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\NewGameOver.pcx Name=LOW_NewGameOver FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\NewGameDown.pcx Name=LOW_NewGameDown FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\NewGameDisabled.pcx Name=LOW_NewGameDisabled FLAGS=2 MIPS=OFF

// Exit Event button
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\MainScrEvent.pcx Name=LOW_ExitEvent FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\MainScrEventOver.pcx Name=LOW_ExitEventOver FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\MainScrEventDown.pcx Name=LOW_ExitEventDown FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\MainScrEventDisabled.pcx Name=LOW_ExitEventDisabled FLAGS=2 MIPS=OFF

// Quit button
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\Quit.pcx Name=LOW_Quit FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\QuitOver.pcx Name=LOW_QuitOver FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\QuitDown.pcx Name=LOW_QuitDown FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Low\QuitDisabled.pcx Name=LOW_QuitDisabled FLAGS=2 MIPS=OFF

// PDA Char Pictures
#exec Texture Import NAME=PDA_LOW_Brin FILE=g:\NerfRes\NerfMenu\Textures\Low\PDA_Brin.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_LOW_Callie FILE=g:\NerfRes\NerfMenu\Textures\Low\PDA_Callie.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_LOW_Frazier FILE=g:\NerfRes\NerfMenu\Textures\Low\PDA_Frazier.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_LOW_Georgie FILE=g:\NerfRes\NerfMenu\Textures\Low\PDA_Georgie.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_LOW_Granite FILE=g:\NerfRes\NerfMenu\Textures\Low\PDA_Granite.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_LOW_Hope FILE=g:\NerfRes\NerfMenu\Textures\Low\PDA_Hope.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_LOW_Jami FILE=g:\NerfRes\NerfMenu\Textures\Low\PDA_Jami.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_LOW_Jamie FILE=g:\NerfRes\NerfMenu\Textures\Low\PDA_Jamie.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_LOW_Jane FILE=g:\NerfRes\NerfMenu\Textures\Low\PDA_Jane.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_LOW_Jonas FILE=g:\NerfRes\NerfMenu\Textures\Low\PDA_Jonas.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_LOW_Judge FILE=g:\NerfRes\NerfMenu\Textures\Low\PDA_Judge.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_LOW_Justin FILE=g:\NerfRes\NerfMenu\Textures\Low\PDA_Justin.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME="PDA_LOW_Little Tree" FILE=g:\NerfRes\NerfMenu\Textures\Low\PDA_LittleTree.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_LOW_Lori FILE=g:\NerfRes\NerfMenu\Textures\Low\PDA_Lori.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_LOW_Mary FILE=g:\NerfRes\NerfMenu\Textures\Low\PDA_Mary.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_LOW_Newton FILE=g:\NerfRes\NerfMenu\Textures\Low\PDA_Newton.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_LOW_OMalley FILE=g:\NerfRes\NerfMenu\Textures\Low\PDA_OMalley.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_LOW_Phoebe FILE=g:\NerfRes\NerfMenu\Textures\Low\PDA_Phoebe.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_LOW_Rabbit FILE=g:\NerfRes\NerfMenu\Textures\Low\PDA_Rabbit.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_LOW_Riles FILE=g:\NerfRes\NerfMenu\Textures\Low\PDA_Riles.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_LOW_Roger FILE=g:\NerfRes\NerfMenu\Textures\Low\PDA_Roger.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_LOW_Ryan FILE=g:\NerfRes\NerfMenu\Textures\Low\PDA_Ryan.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_LOW_Sam FILE=g:\NerfRes\NerfMenu\Textures\Low\PDA_Sam.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_LOW_Sarge FILE=g:\NerfRes\NerfMenu\Textures\Low\PDA_Sarge.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_LOW_Sharon FILE=g:\NerfRes\NerfMenu\Textures\Low\PDA_Sharon.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_LOW_Ted FILE=g:\NerfRes\NerfMenu\Textures\Low\PDA_Ted.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_LOW_Todd FILE=g:\NerfRes\NerfMenu\Textures\Low\PDA_Todd.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_LOW_Troy FILE=g:\NerfRes\NerfMenu\Textures\Low\PDA_Troy.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_LOW_Vince FILE=g:\NerfRes\NerfMenu\Textures\Low\PDA_Vince.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME="PDA_LOW_Water Spirit" FILE=g:\NerfRes\NerfMenu\Textures\Low\PDA_WaterSpirit.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_LOW_Wes FILE=g:\NerfRes\NerfMenu\Textures\Low\PDA_Wes.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_LOW_William FILE=g:\NerfRes\NerfMenu\Textures\Low\PDA_William.pcx FLAGS=2 MIPS=OFF



// ***NerfPDAMed.uc:

// tiled menu background
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\MainBack11.pcx Name=MainBack11 FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\MainBack12.pcx Name=MainBack12 FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\MainBack21.pcx Name=MainBack21 FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\MainBack22.pcx Name=MainBack22 FLAGS=2 MIPS=OFF

// Stats button
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\Stats.pcx Name=Stats FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\StatsOver.pcx Name=StatsOver FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\StatsDown.pcx Name=StatsDown FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\StatsDisabled.pcx Name=StatsDisabled FLAGS=2 MIPS=OFF

// Options button
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\Options.pcx Name=Options FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\OptionsOver.pcx Name=OptionsOver FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\OptionsDown.pcx Name=OptionsDown FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\OptionsDisabled.pcx Name=OptionsDisabled FLAGS=2 MIPS=OFF

// Controls button
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\Controls.pcx Name=Controls FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\ControlsOver.pcx Name=ControlsOver FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\ControlsDown.pcx Name=ControlsDown FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\ControlsDisabled.pcx Name=ControlsDisabled FLAGS=2 MIPS=OFF

// Multiplayer button
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\Multi.pcx Name=MultiPlayer FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\MultiOver.pcx Name=MultiPlayerOver FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\MultiDown.pcx Name=MultiPlayerDown FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\MultiDisabled.pcx Name=MultiPlayerDisabled FLAGS=2 MIPS=OFF

// Singleplayer button
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\Single.pcx Name=SinglePlayer FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\SingleOver.pcx Name=SinglePlayerOver FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\SingleDown.pcx Name=SinglePlayerDown FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\SingleDisabled.pcx Name=SinglePlayerDisabled FLAGS=2 MIPS=OFF

// Play button
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\Play.pcx Name=Play FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\PlayOver.pcx Name=PlayOver FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\PlayDown.pcx Name=PlayDown FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\PlayDisabled.pcx Name=PlayDisabled FLAGS=2 MIPS=OFF

// New Game button
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\MainScrNew.pcx Name=NewGame FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\MainScrNewOver.pcx Name=NewGameOver FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\MainScrNewDown.pcx Name=NewGameDown FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\MainScrNewDisabled.pcx Name=NewGameDisabled FLAGS=2 MIPS=OFF

// Exit Event button
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\MainScrEvent.pcx Name=ExitEvent FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\MainScrEventOver.pcx Name=ExitEventOver FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\MainScrEventDown.pcx Name=ExitEventDown FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\MainScrEventDisabled.pcx Name=ExitEventDisabled FLAGS=2 MIPS=OFF

// Quit button
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\Quit.pcx Name=Quit FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\QuitOver.pcx Name=QuitOver FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\QuitDown.pcx Name=QuitDown FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\QuitDisabled.pcx Name=QuitDisabled FLAGS=2 MIPS=OFF

// PDA Char Pictures
#exec Texture Import NAME=PDA_Brin FILE=g:\NerfRes\NerfMenu\Textures\Med\PDA_Brin.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_Callie FILE=g:\NerfRes\NerfMenu\Textures\Med\PDA_Callie.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_Frazier FILE=g:\NerfRes\NerfMenu\Textures\Med\PDA_Frazier.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_Georgie FILE=g:\NerfRes\NerfMenu\Textures\Med\PDA_Georgie.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_Granite FILE=g:\NerfRes\NerfMenu\Textures\Med\PDA_Granite.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_Hope FILE=g:\NerfRes\NerfMenu\Textures\Med\PDA_Hope.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_Jami FILE=g:\NerfRes\NerfMenu\Textures\Med\PDA_Jami.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_Jamie FILE=g:\NerfRes\NerfMenu\Textures\Med\PDA_Jamie.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_Jane FILE=g:\NerfRes\NerfMenu\Textures\Med\PDA_Jane.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_Jonas FILE=g:\NerfRes\NerfMenu\Textures\Med\PDA_Jonas.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_Judge FILE=g:\NerfRes\NerfMenu\Textures\Med\PDA_Judge.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_Justin FILE=g:\NerfRes\NerfMenu\Textures\Med\PDA_Justin.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME="PDA_Little Tree" FILE=g:\NerfRes\NerfMenu\Textures\Med\PDA_LittleTree.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_Lori FILE=g:\NerfRes\NerfMenu\Textures\Med\PDA_Lori.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_Mary FILE=g:\NerfRes\NerfMenu\Textures\Med\PDA_Mary.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_Newton FILE=g:\NerfRes\NerfMenu\Textures\Med\PDA_Newton.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_OMalley FILE=g:\NerfRes\NerfMenu\Textures\Med\PDA_OMalley.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_Phoebe FILE=g:\NerfRes\NerfMenu\Textures\Med\PDA_Phoebe.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_Rabbit FILE=g:\NerfRes\NerfMenu\Textures\Med\PDA_Rabbit.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_Riles FILE=g:\NerfRes\NerfMenu\Textures\Med\PDA_Riles.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_Roger FILE=g:\NerfRes\NerfMenu\Textures\Med\PDA_Roger.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_Ryan FILE=g:\NerfRes\NerfMenu\Textures\Med\PDA_Ryan.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_Sam FILE=g:\NerfRes\NerfMenu\Textures\Med\PDA_Sam.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_Sarge FILE=g:\NerfRes\NerfMenu\Textures\Med\PDA_Sarge.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_Sharon FILE=g:\NerfRes\NerfMenu\Textures\Med\PDA_Sharon.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_Ted FILE=g:\NerfRes\NerfMenu\Textures\Med\PDA_Ted.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_Todd FILE=g:\NerfRes\NerfMenu\Textures\Med\PDA_Todd.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_Troy FILE=g:\NerfRes\NerfMenu\Textures\Med\PDA_Troy.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_Vince FILE=g:\NerfRes\NerfMenu\Textures\Med\PDA_Vince.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME="PDA_Water Spirit" FILE=g:\NerfRes\NerfMenu\Textures\Med\PDA_WaterSpirit.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_Wes FILE=g:\NerfRes\NerfMenu\Textures\Med\PDA_Wes.pcx FLAGS=2 MIPS=OFF
#exec Texture Import NAME=PDA_William FILE=g:\NerfRes\NerfMenu\Textures\Med\PDA_William.pcx FLAGS=2 MIPS=OFF


// ***NerfPDAScreenGeneral.uc:

// Generic button backgrounds
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\BtnOn.pcx Name=ButtonOn FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\BtnOff.pcx Name=ButtonOff FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\BtnOver.pcx Name=ButtonOver FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\BtnDown.pcx Name=ButtonDown FLAGS=2 MIPS=OFF


// ***NerfPDAScreenGeneral.uc:

// horiz tiled screen background
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\Twisters.pcx Name=MainScrBack FLAGS=2 MIPS=OFF


// ***NerfPDAScreen*.uc:

// Oval button
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\Oval.pcx Name=Oval FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\OvalOver.pcx Name=OvalOver FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\OvalDown.pcx Name=OvalDown FLAGS=2 MIPS=OFF

// Round button
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\Round.pcx Name=Round FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\RoundOver.pcx Name=RoundOver FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\RoundDown.pcx Name=RoundDown FLAGS=2 MIPS=OFF

// Oval2 button, meant to be stretched
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\Oval2.pcx Name=Oval2 FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\Oval2Over.pcx Name=Oval2Over FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\Oval2Down.pcx Name=Oval2Down FLAGS=2 MIPS=OFF


// ***NerfMessageBox.uc:

// Message Box background
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\MessageBack1.pcx Name=NerfMessageBoxBack FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\MessageBack2.pcx Name=NerfOkayBoxBack FLAGS=2 MIPS=OFF

// Yes button
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\Yes.pcx Name=Yes FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\YesOver.pcx Name=YesOver FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\YesDown.pcx Name=YesDown FLAGS=2 MIPS=OFF

// No button
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\No.pcx Name=No FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\NoOver.pcx Name=NoOver FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\NoDown.pcx Name=NoDown FLAGS=2 MIPS=OFF

// Okay button
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\Okay.pcx Name=Okay FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\OkayOver.pcx Name=OkayOver FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\OkayDown.pcx Name=OkayDown FLAGS=2 MIPS=OFF

// Cancel button
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\Cancel.pcx Name=Cancel FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\CancelOver.pcx Name=CancelOver FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\CancelDown.pcx Name=CancelDown FLAGS=2 MIPS=OFF


// ***NerfQuitBox.uc:

// Credits button
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\Credits.pcx Name=Credits FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\CreditsOver.pcx Name=CreditsOver FLAGS=2 MIPS=OFF
#exec Texture Import File=G:\NerfRes\NerfMenu\Textures\Med\CreditsDown.pcx Name=CreditsDown FLAGS=2 MIPS=OFF

// Menu Sounds (various source files)
#exec Audio Import NAME=PDAUp		File=G:\NerfRes\NerfMenu\Sounds\PDAUp.wav
#exec Audio Import NAME=PDADown		File=G:\NerfRes\NerfMenu\Sounds\PDADown.wav
#exec Audio Import NAME=PDAOver		File=G:\NerfRes\NerfMenu\Sounds\PDAOver.wav
#exec Audio Import NAME=PDAClick	File=G:\NerfRes\NerfMenu\Sounds\PDAClick.wav
//#exec Audio Import NAME=PDAExit		File=G:\NerfRes\NerfMenu\Sounds\PDAExit.wav

defaultproperties
{
}
