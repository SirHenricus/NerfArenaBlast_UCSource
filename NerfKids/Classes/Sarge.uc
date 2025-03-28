//=============================================================================
// Sarge
//=============================================================================
class Sarge expands Female;

#exec MESH IMPORT MESH=F_Regular ANIVFILE=MODELS\t01d_a.3d DATAFILE=MODELS\t01d_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=F_Regular X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=F_Regular SEQ=All        STARTFRAME=0 NUMFRAMES=767
#exec MESH SEQUENCE MESH=F_Regular SEQ=Walk       STARTFRAME=0 NUMFRAMES=16 RATE=15     
#exec MESH SEQUENCE MESH=F_Regular SEQ=WalkLg     STARTFRAME=16 NUMFRAMES=16 RATE=15
#exec MESH SEQUENCE MESH=F_Regular SEQ=WalkLgFr   STARTFRAME=32 NUMFRAMES=16 RATE=15
#exec MESH SEQUENCE MESH=F_Regular SEQ=WalkSm     STARTFRAME=48 NUMFRAMES=16 RATE=15
#exec MESH SEQUENCE MESH=F_Regular SEQ=WalkSmFr   STARTFRAME=64 NUMFRAMES=16 RATE=15
#exec MESH SEQUENCE MESH=F_Regular SEQ=RunLg      STARTFRAME=80 NUMFRAMES=12 RATE=15
#exec MESH SEQUENCE MESH=F_Regular SEQ=RunLgFr    STARTFRAME=92 NUMFRAMES=12 RATE=15
#exec MESH SEQUENCE MESH=F_Regular SEQ=RunSm      STARTFRAME=104 NUMFRAMES=12 RATE=15
#exec MESH SEQUENCE MESH=F_Regular SEQ=RunSmFr    STARTFRAME=116 NUMFRAMES=12 RATE=15
#exec MESH SEQUENCE MESH=F_Regular SEQ=SwimLg     STARTFRAME=128 NUMFRAMES=12 RATE=15
#exec MESH SEQUENCE MESH=F_Regular SEQ=SwimSm     STARTFRAME=140 NUMFRAMES=12 RATE=15
#exec MESH SEQUENCE MESH=F_Regular SEQ=TurnLg     STARTFRAME=152 NUMFRAMES=2 RATE=15
#exec MESH SEQUENCE MESH=F_Regular SEQ=TurnSm     STARTFRAME=154 NUMFRAMES=2 RATE=15
#exec MESH SEQUENCE MESH=F_Regular SEQ=JumpLgFr   STARTFRAME=156 NUMFRAMES=1 RATE=1     Group=Jumping
#exec MESH SEQUENCE MESH=F_Regular SEQ=JumpSmFr   STARTFRAME=157 NUMFRAMES=1 RATE=1     Group=Jumping
#exec MESH SEQUENCE MESH=F_Regular SEQ=LandLgFr   STARTFRAME=158 NUMFRAMES=1 RATE=1     Group=Landing
#exec MESH SEQUENCE MESH=F_Regular SEQ=LandSmFr   STARTFRAME=159 NUMFRAMES=1 RATE=1     Group=Landing
#exec MESH SEQUENCE MESH=F_Regular SEQ=DuckWlkL   STARTFRAME=160 NUMFRAMES=16 RATE=15   Group=Ducking
#exec MESH SEQUENCE MESH=F_Regular SEQ=DuckWlkS   STARTFRAME=176 NUMFRAMES=16 RATE=15   Group=Ducking
#exec MESH SEQUENCE MESH=F_Regular SEQ=LadderClim STARTFRAME=192 NUMFRAMES=8 RATE=15
#exec MESH SEQUENCE MESH=F_Regular SEQ=AimDnLg    STARTFRAME=200 NUMFRAMES=1 RATE=1     Group=Waiting
#exec MESH SEQUENCE MESH=F_Regular SEQ=AimDnSm    STARTFRAME=201 NUMFRAMES=1 RATE=1     Group=Waiting
#exec MESH SEQUENCE MESH=F_Regular SEQ=AimUpLg    STARTFRAME=202 NUMFRAMES=1 RATE=1     Group=Waiting
#exec MESH SEQUENCE MESH=F_Regular SEQ=AimUpSm    STARTFRAME=203 NUMFRAMES=1 RATE=1     Group=Waiting
#exec MESH SEQUENCE MESH=F_Regular SEQ=Breath1    STARTFRAME=204 NUMFRAMES=8 RATE=6     Group=Waiting
#exec MESH SEQUENCE MESH=F_Regular SEQ=Breath2    STARTFRAME=212 NUMFRAMES=8 RATE=15    Group=Waiting
#exec MESH SEQUENCE MESH=F_Regular SEQ=Breath1L   STARTFRAME=220 NUMFRAMES=8 RATE=6     Group=Waiting
#exec MESH SEQUENCE MESH=F_Regular SEQ=Breath2L   STARTFRAME=228 NUMFRAMES=8 RATE=15    Group=Waiting
#exec MESH SEQUENCE MESH=F_Regular SEQ=CockGun    STARTFRAME=236 NUMFRAMES=12 RATE=15   Group=Waiting
#exec MESH SEQUENCE MESH=F_Regular SEQ=Look       STARTFRAME=248 NUMFRAMES=24 RATE=15   Group=Waiting
#exec MESH SEQUENCE MESH=F_Regular SEQ=LookL      STARTFRAME=272 NUMFRAMES=24 RATE=15   Group=Waiting
#exec MESH SEQUENCE MESH=F_Regular SEQ=StillFrRp  STARTFRAME=296 NUMFRAMES=12 RATE=15   Group=Waiting
#exec MESH SEQUENCE MESH=F_Regular SEQ=StillLgFr  STARTFRAME=308 NUMFRAMES=10 RATE=15   Group=Waiting
#exec MESH SEQUENCE MESH=F_Regular SEQ=StillSmFr  STARTFRAME=318 NUMFRAMES=8 RATE=15    Group=Waiting
#exec MESH SEQUENCE MESH=F_Regular SEQ=TreadLg    STARTFRAME=326 NUMFRAMES=16 RATE=15   Group=Waiting
#exec MESH SEQUENCE MESH=F_Regular SEQ=TreadSm    STARTFRAME=342 NUMFRAMES=16 RATE=15   Group=Waiting
#exec MESH SEQUENCE MESH=F_Regular SEQ=LeftHit    STARTFRAME=358 NUMFRAMES=1 RATE=1     Group=TakeHit
#exec MESH SEQUENCE MESH=F_Regular SEQ=RightHit   STARTFRAME=359 NUMFRAMES=1 RATE=1     Group=TakeHit
#exec MESH SEQUENCE MESH=F_Regular SEQ=HeadHit    STARTFRAME=360 NUMFRAMES=1 RATE=1     Group=TakeHit
#exec MESH SEQUENCE MESH=F_Regular SEQ=GutHit     STARTFRAME=361 NUMFRAMES=1 RATE=1     Group=TakeHit
#exec MESH SEQUENCE MESH=F_Regular SEQ=Dead1      STARTFRAME=362 NUMFRAMES=39 RATE=15
#exec MESH SEQUENCE MESH=F_Regular SEQ=Dead2      STARTFRAME=401 NUMFRAMES=22 RATE=15   Group=TakeHit
#exec MESH SEQUENCE MESH=F_Regular SEQ=Dead3      STARTFRAME=423 NUMFRAMES=16 RATE=15   Group=TakeHit
#exec MESH SEQUENCE MESH=F_Regular SEQ=Dead4      STARTFRAME=439 NUMFRAMES=13 RATE=15   Group=TakeHit
#exec MESH SEQUENCE MESH=F_Regular SEQ=Dead5      STARTFRAME=452 NUMFRAMES=16 RATE=15   Group=TakeHit
#exec MESH SEQUENCE MESH=F_Regular SEQ=Dead6      STARTFRAME=468 NUMFRAMES=11 RATE=15
#exec MESH SEQUENCE MESH=F_Regular SEQ=Dead7      STARTFRAME=479 NUMFRAMES=23 RATE=15
#exec MESH SEQUENCE MESH=F_Regular SEQ=DeathEnd   STARTFRAME=502 NUMFRAMES=1 RATE=1
#exec MESH SEQUENCE MESH=F_Regular SEQ=DeathEnd2  STARTFRAME=503 NUMFRAMES=1 RATE=1
#exec MESH SEQUENCE MESH=F_Regular SEQ=DeathEnd3  STARTFRAME=504 NUMFRAMES=1 RATE=1
#exec MESH SEQUENCE MESH=F_Regular SEQ=Victory1   STARTFRAME=505 NUMFRAMES=18 RATE=15   Group=Gesture
#exec MESH SEQUENCE MESH=F_Regular SEQ=Fidget     STARTFRAME=523 NUMFRAMES=18 RATE=15   Group=Waiting
#exec MESH SEQUENCE MESH=F_Regular SEQ=Wave       STARTFRAME=541 NUMFRAMES=15 RATE=15   Group=Gesture
#exec MESH SEQUENCE MESH=F_Regular SEQ=JoinMe     STARTFRAME=556 NUMFRAMES=15 RATE=15   Group=Gesture
#exec MESH SEQUENCE MESH=F_Regular SEQ=Taunt1     STARTFRAME=571 NUMFRAMES=24 RATE=15   Group=Gesture
#exec MESH SEQUENCE MESH=F_Regular SEQ=Taunt1L    STARTFRAME=595 NUMFRAMES=1 RATE=1     Group=Gesture
#exec MESH SEQUENCE MESH=F_Regular SEQ=StrafeLgL  STARTFRAME=596 NUMFRAMES=12 RATE=18
#exec MESH SEQUENCE MESH=F_Regular SEQ=StrafeLgR  STARTFRAME=608 NUMFRAMES=12 RATE=18
#exec MESH SEQUENCE MESH=F_Regular SEQ=StrafeSmL  STARTFRAME=620 NUMFRAMES=12 RATE=18
#exec MESH SEQUENCE MESH=F_Regular SEQ=StrafeSmR  STARTFRAME=632 NUMFRAMES=12 RATE=18
#exec MESH SEQUENCE MESH=F_Regular SEQ=CockGun2   STARTFRAME=644 NUMFRAMES=12 RATE=15   Group=Waiting
#exec MESH SEQUENCE MESH=F_Regular SEQ=WarmUp     STARTFRAME=656 NUMFRAMES=30 RATE=15   Group=Waiting
#exec MESH SEQUENCE MESH=F_Regular SEQ=SpJump     STARTFRAME=686 NUMFRAMES=10 RATE=7    Group=Jumping
#exec MESH SEQUENCE MESH=F_Regular SEQ=SpLand     STARTFRAME=696 NUMFRAMES=10 RATE=7    Group=Landing
#exec MESH SEQUENCE MESH=F_Regular SEQ=SpMidair   STARTFRAME=706 NUMFRAMES=6 RATE=15
#exec MESH SEQUENCE MESH=F_Regular SEQ=ArmsBound  STARTFRAME=712 NUMFRAMES=1 RATE=1     Group=Waiting
#exec MESH SEQUENCE MESH=F_Regular SEQ=Victory2   STARTFRAME=713 NUMFRAMES=30 RATE=15   Group=Gesture
#exec MESH SEQUENCE MESH=F_Regular SEQ=StucknGoo  STARTFRAME=743 NUMFRAMES=24 RATE=15   Group=Waiting

#exec TEXTURE IMPORT NAME=Sarge FILE=MODELS\T01d_01.pcx GROUP=Skins FLAGS=2 // T01d_01.pcx

#exec MESHMAP NEW   MESHMAP=F_Regular MESH=F_Regular
#exec MESHMAP SCALE MESHMAP=F_Regular X=0.125 Y=0.125 Z=0.25

#exec MESHMAP SETTEXTURE MESHMAP=F_Regular NUM=0 TEXTURE=Sarge


function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Twisters;
    PlayerReplicationInfo.BotIndex=AKA_Sarge;
}

function Texture Face()
{
    return Texture'NerfKids.SkinIcons.I_Sarge';
}

defaultproperties
{
     bIsFemale=True
     BaseEyeHeight=34.735603
     Mesh=LodMesh'NerfKids.F_Regular'
     CollisionRadius=25.000000
     CollisionHeight=43.419506
}
