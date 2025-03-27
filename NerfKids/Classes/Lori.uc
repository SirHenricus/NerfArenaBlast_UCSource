//=============================================================================
//=============================================================================
class Lori expands Female;

#exec MESH IMPORT MESH=F_Small_L ANIVFILE=MODELS\t06d_a.3d DATAFILE=MODELS\t06d_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=F_Small_L X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=F_Small_L SEQ=All        STARTFRAME=0 NUMFRAMES=777
#exec MESH SEQUENCE MESH=F_Small_L SEQ=Walk       STARTFRAME=0 NUMFRAMES=16 RATE=16     
#exec MESH SEQUENCE MESH=F_Small_L SEQ=WalkLg     STARTFRAME=16 NUMFRAMES=16 RATE=16
#exec MESH SEQUENCE MESH=F_Small_L SEQ=WalkLgFr   STARTFRAME=32 NUMFRAMES=16 RATE=16
#exec MESH SEQUENCE MESH=F_Small_L SEQ=WalkSm     STARTFRAME=48 NUMFRAMES=16 RATE=16
#exec MESH SEQUENCE MESH=F_Small_L SEQ=WalkSmFr   STARTFRAME=64 NUMFRAMES=16 RATE=16
#exec MESH SEQUENCE MESH=F_Small_L SEQ=RunLg      STARTFRAME=80 NUMFRAMES=12 RATE=17
#exec MESH SEQUENCE MESH=F_Small_L SEQ=RunLgFr    STARTFRAME=92 NUMFRAMES=12 RATE=17
#exec MESH SEQUENCE MESH=F_Small_L SEQ=RunSm      STARTFRAME=104 NUMFRAMES=12 RATE=17
#exec MESH SEQUENCE MESH=F_Small_L SEQ=RunSmFr    STARTFRAME=116 NUMFRAMES=12 RATE=17
#exec MESH SEQUENCE MESH=F_Small_L SEQ=SwimLg     STARTFRAME=128 NUMFRAMES=12 RATE=15
#exec MESH SEQUENCE MESH=F_Small_L SEQ=SwimSm     STARTFRAME=140 NUMFRAMES=12 RATE=15
#exec MESH SEQUENCE MESH=F_Small_L SEQ=TurnLg     STARTFRAME=152 NUMFRAMES=2 RATE=15
#exec MESH SEQUENCE MESH=F_Small_L SEQ=TurnSm     STARTFRAME=154 NUMFRAMES=2 RATE=15
#exec MESH SEQUENCE MESH=F_Small_L SEQ=JumpLgFr   STARTFRAME=156 NUMFRAMES=1 RATE=1     Group=Jumping
#exec MESH SEQUENCE MESH=F_Small_L SEQ=JumpSmFr   STARTFRAME=157 NUMFRAMES=1 RATE=1     Group=Jumping
#exec MESH SEQUENCE MESH=F_Small_L SEQ=LandLgFr   STARTFRAME=158 NUMFRAMES=1 RATE=1     Group=Landing
#exec MESH SEQUENCE MESH=F_Small_L SEQ=LandSmFr   STARTFRAME=159 NUMFRAMES=1 RATE=1     Group=Landing
#exec MESH SEQUENCE MESH=F_Small_L SEQ=DuckWlkL   STARTFRAME=160 NUMFRAMES=16 RATE=16   Group=Ducking
#exec MESH SEQUENCE MESH=F_Small_L SEQ=DuckWlkS   STARTFRAME=176 NUMFRAMES=16 RATE=16   Group=Ducking
#exec MESH SEQUENCE MESH=F_Small_L SEQ=LadderClim STARTFRAME=192 NUMFRAMES=8 RATE=16
#exec MESH SEQUENCE MESH=F_Small_L SEQ=AimDnLg    STARTFRAME=200 NUMFRAMES=1 RATE=1     Group=Waiting
#exec MESH SEQUENCE MESH=F_Small_L SEQ=AimDnSm    STARTFRAME=201 NUMFRAMES=1 RATE=1     Group=Waiting
#exec MESH SEQUENCE MESH=F_Small_L SEQ=AimUpLg    STARTFRAME=202 NUMFRAMES=1 RATE=1     Group=Waiting
#exec MESH SEQUENCE MESH=F_Small_L SEQ=AimUpSm    STARTFRAME=203 NUMFRAMES=1 RATE=1     Group=Waiting
#exec MESH SEQUENCE MESH=F_Small_L SEQ=Breath1    STARTFRAME=204 NUMFRAMES=8 RATE=6     Group=Waiting
#exec MESH SEQUENCE MESH=F_Small_L SEQ=Breath2    STARTFRAME=212 NUMFRAMES=8 RATE=15    Group=Waiting
#exec MESH SEQUENCE MESH=F_Small_L SEQ=Breath1L   STARTFRAME=220 NUMFRAMES=8 RATE=6     Group=Waiting
#exec MESH SEQUENCE MESH=F_Small_L SEQ=Breath2L   STARTFRAME=228 NUMFRAMES=8 RATE=15    Group=Waiting
#exec MESH SEQUENCE MESH=F_Small_L SEQ=CockGun    STARTFRAME=236 NUMFRAMES=12 RATE=12   Group=Waiting
#exec MESH SEQUENCE MESH=F_Small_L SEQ=Look       STARTFRAME=248 NUMFRAMES=24 RATE=15   Group=Waiting
#exec MESH SEQUENCE MESH=F_Small_L SEQ=LookL      STARTFRAME=272 NUMFRAMES=24 RATE=15   Group=Waiting
#exec MESH SEQUENCE MESH=F_Small_L SEQ=StillFrRp  STARTFRAME=296 NUMFRAMES=12 RATE=15   Group=Waiting
#exec MESH SEQUENCE MESH=F_Small_L SEQ=StillLgFr  STARTFRAME=308 NUMFRAMES=10 RATE=15   Group=Waiting
#exec MESH SEQUENCE MESH=F_Small_L SEQ=StillSmFr  STARTFRAME=318 NUMFRAMES=8 RATE=15    Group=Waiting
#exec MESH SEQUENCE MESH=F_Small_L SEQ=TreadLg    STARTFRAME=326 NUMFRAMES=16 RATE=16   Group=Waiting
#exec MESH SEQUENCE MESH=F_Small_L SEQ=TreadSm    STARTFRAME=342 NUMFRAMES=16 RATE=16   Group=Waiting
#exec MESH SEQUENCE MESH=F_Small_L SEQ=LeftHit    STARTFRAME=358 NUMFRAMES=1 RATE=1     Group=TakeHit
#exec MESH SEQUENCE MESH=F_Small_L SEQ=RightHit   STARTFRAME=359 NUMFRAMES=1 RATE=1     Group=TakeHit
#exec MESH SEQUENCE MESH=F_Small_L SEQ=HeadHit    STARTFRAME=360 NUMFRAMES=1 RATE=1     Group=TakeHit
#exec MESH SEQUENCE MESH=F_Small_L SEQ=GutHit     STARTFRAME=361 NUMFRAMES=1 RATE=1     Group=TakeHit
#exec MESH SEQUENCE MESH=F_Small_L SEQ=Dead1      STARTFRAME=362 NUMFRAMES=39 RATE=15
#exec MESH SEQUENCE MESH=F_Small_L SEQ=Dead2      STARTFRAME=401 NUMFRAMES=22 RATE=15   Group=TakeHit
#exec MESH SEQUENCE MESH=F_Small_L SEQ=Dead3      STARTFRAME=423 NUMFRAMES=16 RATE=12   Group=TakeHit
#exec MESH SEQUENCE MESH=F_Small_L SEQ=Dead4      STARTFRAME=439 NUMFRAMES=13 RATE=12   Group=TakeHit
#exec MESH SEQUENCE MESH=F_Small_L SEQ=Dead5      STARTFRAME=452 NUMFRAMES=16 RATE=12   Group=TakeHit
#exec MESH SEQUENCE MESH=F_Small_L SEQ=Dead6      STARTFRAME=468 NUMFRAMES=11 RATE=12
#exec MESH SEQUENCE MESH=F_Small_L SEQ=Dead7      STARTFRAME=479 NUMFRAMES=23 RATE=12
#exec MESH SEQUENCE MESH=F_Small_L SEQ=DeathEnd   STARTFRAME=502 NUMFRAMES=1 RATE=1
#exec MESH SEQUENCE MESH=F_Small_L SEQ=DeathEnd2  STARTFRAME=503 NUMFRAMES=1 RATE=1
#exec MESH SEQUENCE MESH=F_Small_L SEQ=DeathEnd3  STARTFRAME=504 NUMFRAMES=1 RATE=1
#exec MESH SEQUENCE MESH=F_Small_L SEQ=Victory1   STARTFRAME=505 NUMFRAMES=18 RATE=15   Group=Gesture
#exec MESH SEQUENCE MESH=F_Small_L SEQ=Fidget     STARTFRAME=523 NUMFRAMES=18 RATE=15   Group=Waiting
#exec MESH SEQUENCE MESH=F_Small_L SEQ=Wave       STARTFRAME=541 NUMFRAMES=15 RATE=15   Group=Gesture
#exec MESH SEQUENCE MESH=F_Small_L SEQ=JoinMe     STARTFRAME=556 NUMFRAMES=15 RATE=15   Group=Gesture
#exec MESH SEQUENCE MESH=F_Small_L SEQ=Taunt1     STARTFRAME=571 NUMFRAMES=39 RATE=15   Group=Gesture
#exec MESH SEQUENCE MESH=F_Small_L SEQ=Taunt1L    STARTFRAME=610 NUMFRAMES=1 RATE=1     Group=Gesture
#exec MESH SEQUENCE MESH=F_Small_L SEQ=StrafeLgL  STARTFRAME=611 NUMFRAMES=12 RATE=19
#exec MESH SEQUENCE MESH=F_Small_L SEQ=StrafeLgR  STARTFRAME=623 NUMFRAMES=12 RATE=19
#exec MESH SEQUENCE MESH=F_Small_L SEQ=StrafeSmL  STARTFRAME=635 NUMFRAMES=12 RATE=19
#exec MESH SEQUENCE MESH=F_Small_L SEQ=StrafeSmR  STARTFRAME=647 NUMFRAMES=12 RATE=19
#exec MESH SEQUENCE MESH=F_Small_L SEQ=CockGun2   STARTFRAME=659 NUMFRAMES=12 RATE=15   Group=Waiting
#exec MESH SEQUENCE MESH=F_Small_L SEQ=WarmUp     STARTFRAME=671 NUMFRAMES=30 RATE=15   Group=Waiting
#exec MESH SEQUENCE MESH=F_Small_L SEQ=SpJump     STARTFRAME=701 NUMFRAMES=10 RATE=12   Group=Jumping
#exec MESH SEQUENCE MESH=F_Small_L SEQ=SpLand     STARTFRAME=711 NUMFRAMES=10 RATE=12   Group=Landing
#exec MESH SEQUENCE MESH=F_Small_L SEQ=SpMidair   STARTFRAME=721 NUMFRAMES=1 RATE=1
#exec MESH SEQUENCE MESH=F_Small_L SEQ=ArmsBound  STARTFRAME=722 NUMFRAMES=1 RATE=1     Group=Waiting
#exec MESH SEQUENCE MESH=F_Small_L SEQ=Victory2   STARTFRAME=723 NUMFRAMES=30 RATE=15   Group=Gesture
#exec MESH SEQUENCE MESH=F_Small_L SEQ=StucknGoo  STARTFRAME=753 NUMFRAMES=24 RATE=15   Group=Waiting

#exec TEXTURE IMPORT NAME=Lori FILE=MODELS\T06d_01.pcx GROUP=Skins FLAGS=2 // T06d_01.pcx

#exec MESHMAP NEW   MESHMAP=F_Small_L MESH=F_Small_L
#exec MESHMAP SCALE MESHMAP=F_Small_L X=0.125 Y=0.125 Z=0.25

#exec MESHMAP SETTEXTURE MESHMAP=F_Small_L NUM=0 TEXTURE=Lori

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Baracudas;
    PlayerReplicationInfo.BotIndex=AKA_Lori;
}

function Texture Face()
{
    return Texture'NerfKids.SkinIcons.I_Lori';
}

defaultproperties
{
     bIsFemale=True
     BaseEyeHeight=34.299393
     Mesh=LodMesh'NerfKids.F_Small_L'
     CollisionRadius=25.000000
     CollisionHeight=42.754242
}
