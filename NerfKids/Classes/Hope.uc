//=============================================================================
// Hope
//=============================================================================
class Hope expands Female;

#exec MESH IMPORT MESH=F_Model ANIVFILE=MODELS\t02a_a.3d DATAFILE=MODELS\t02a_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=F_Model X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=F_Model SEQ=All        STARTFRAME=0 NUMFRAMES=773
#exec MESH SEQUENCE MESH=F_Model SEQ=Walk       STARTFRAME=0 NUMFRAMES=16 RATE=15     
#exec MESH SEQUENCE MESH=F_Model SEQ=WalkLg     STARTFRAME=16 NUMFRAMES=16 RATE=15
#exec MESH SEQUENCE MESH=F_Model SEQ=WalkLgFr   STARTFRAME=32 NUMFRAMES=16 RATE=15
#exec MESH SEQUENCE MESH=F_Model SEQ=WalkSm     STARTFRAME=48 NUMFRAMES=16 RATE=15
#exec MESH SEQUENCE MESH=F_Model SEQ=WalkSmFr   STARTFRAME=64 NUMFRAMES=16 RATE=15
#exec MESH SEQUENCE MESH=F_Model SEQ=RunLg      STARTFRAME=80 NUMFRAMES=12 RATE=15
#exec MESH SEQUENCE MESH=F_Model SEQ=RunLgFr    STARTFRAME=92 NUMFRAMES=12 RATE=15
#exec MESH SEQUENCE MESH=F_Model SEQ=RunSm      STARTFRAME=104 NUMFRAMES=12 RATE=15
#exec MESH SEQUENCE MESH=F_Model SEQ=RunSmFr    STARTFRAME=116 NUMFRAMES=12 RATE=15
#exec MESH SEQUENCE MESH=F_Model SEQ=SwimLg     STARTFRAME=128 NUMFRAMES=12 RATE=13
#exec MESH SEQUENCE MESH=F_Model SEQ=SwimSm     STARTFRAME=140 NUMFRAMES=12 RATE=13
#exec MESH SEQUENCE MESH=F_Model SEQ=TurnLg     STARTFRAME=152 NUMFRAMES=2 RATE=15
#exec MESH SEQUENCE MESH=F_Model SEQ=TurnSm     STARTFRAME=154 NUMFRAMES=2 RATE=15
#exec MESH SEQUENCE MESH=F_Model SEQ=JumpLgFr   STARTFRAME=156 NUMFRAMES=1 RATE=1     Group=Jumping
#exec MESH SEQUENCE MESH=F_Model SEQ=JumpSmFr   STARTFRAME=157 NUMFRAMES=1 RATE=1     Group=Jumping
#exec MESH SEQUENCE MESH=F_Model SEQ=LandLgFr   STARTFRAME=158 NUMFRAMES=1 RATE=1     Group=Landing
#exec MESH SEQUENCE MESH=F_Model SEQ=LandSmFr   STARTFRAME=159 NUMFRAMES=1 RATE=1     Group=Landing
#exec MESH SEQUENCE MESH=F_Model SEQ=DuckWlkL   STARTFRAME=160 NUMFRAMES=16 RATE=14   Group=Ducking
#exec MESH SEQUENCE MESH=F_Model SEQ=DuckWlkS   STARTFRAME=176 NUMFRAMES=16 RATE=14   Group=Ducking
#exec MESH SEQUENCE MESH=F_Model SEQ=LadderClim STARTFRAME=192 NUMFRAMES=8 RATE=10
#exec MESH SEQUENCE MESH=F_Model SEQ=AimDnLg    STARTFRAME=200 NUMFRAMES=1 RATE=1     Group=Waiting
#exec MESH SEQUENCE MESH=F_Model SEQ=AimDnSm    STARTFRAME=201 NUMFRAMES=1 RATE=1     Group=Waiting
#exec MESH SEQUENCE MESH=F_Model SEQ=AimUpLg    STARTFRAME=202 NUMFRAMES=1 RATE=1     Group=Waiting
#exec MESH SEQUENCE MESH=F_Model SEQ=AimUpSm    STARTFRAME=203 NUMFRAMES=1 RATE=1     Group=Waiting
#exec MESH SEQUENCE MESH=F_Model SEQ=Breath1    STARTFRAME=204 NUMFRAMES=8 RATE=6     Group=Waiting
#exec MESH SEQUENCE MESH=F_Model SEQ=Breath2    STARTFRAME=212 NUMFRAMES=8 RATE=12    Group=Waiting
#exec MESH SEQUENCE MESH=F_Model SEQ=Breath1L   STARTFRAME=220 NUMFRAMES=8 RATE=6     Group=Waiting
#exec MESH SEQUENCE MESH=F_Model SEQ=Breath2L   STARTFRAME=228 NUMFRAMES=8 RATE=12    Group=Waiting
#exec MESH SEQUENCE MESH=F_Model SEQ=CockGun    STARTFRAME=236 NUMFRAMES=12 RATE=12   Group=Waiting
#exec MESH SEQUENCE MESH=F_Model SEQ=Look       STARTFRAME=248 NUMFRAMES=24 RATE=13   Group=Waiting
#exec MESH SEQUENCE MESH=F_Model SEQ=LookL      STARTFRAME=272 NUMFRAMES=24 RATE=13   Group=Waiting
#exec MESH SEQUENCE MESH=F_Model SEQ=StillFrRp  STARTFRAME=296 NUMFRAMES=12 RATE=15   Group=Waiting
#exec MESH SEQUENCE MESH=F_Model SEQ=StillLgFr  STARTFRAME=308 NUMFRAMES=10 RATE=15   Group=Waiting
#exec MESH SEQUENCE MESH=F_Model SEQ=StillSmFr  STARTFRAME=318 NUMFRAMES=8 RATE=15    Group=Waiting
#exec MESH SEQUENCE MESH=F_Model SEQ=TreadLg    STARTFRAME=326 NUMFRAMES=16 RATE=14   Group=Waiting
#exec MESH SEQUENCE MESH=F_Model SEQ=TreadSm    STARTFRAME=342 NUMFRAMES=16 RATE=14   Group=Waiting
#exec MESH SEQUENCE MESH=F_Model SEQ=LeftHit    STARTFRAME=358 NUMFRAMES=1 RATE=1     Group=TakeHit
#exec MESH SEQUENCE MESH=F_Model SEQ=RightHit   STARTFRAME=359 NUMFRAMES=1 RATE=1     Group=TakeHit
#exec MESH SEQUENCE MESH=F_Model SEQ=HeadHit    STARTFRAME=360 NUMFRAMES=1 RATE=1     Group=TakeHit
#exec MESH SEQUENCE MESH=F_Model SEQ=GutHit     STARTFRAME=361 NUMFRAMES=1 RATE=1     Group=TakeHit
#exec MESH SEQUENCE MESH=F_Model SEQ=Dead1      STARTFRAME=362 NUMFRAMES=39 RATE=14
#exec MESH SEQUENCE MESH=F_Model SEQ=Dead2      STARTFRAME=401 NUMFRAMES=22 RATE=15   Group=TakeHit
#exec MESH SEQUENCE MESH=F_Model SEQ=Dead3      STARTFRAME=423 NUMFRAMES=16 RATE=15   Group=TakeHit
#exec MESH SEQUENCE MESH=F_Model SEQ=Dead4      STARTFRAME=439 NUMFRAMES=13 RATE=15   Group=TakeHit
#exec MESH SEQUENCE MESH=F_Model SEQ=Dead5      STARTFRAME=452 NUMFRAMES=16 RATE=15   Group=TakeHit
#exec MESH SEQUENCE MESH=F_Model SEQ=Dead6      STARTFRAME=468 NUMFRAMES=11 RATE=15
#exec MESH SEQUENCE MESH=F_Model SEQ=Dead7      STARTFRAME=479 NUMFRAMES=23 RATE=15
#exec MESH SEQUENCE MESH=F_Model SEQ=DeathEnd   STARTFRAME=502 NUMFRAMES=1 RATE=1
#exec MESH SEQUENCE MESH=F_Model SEQ=DeathEnd2  STARTFRAME=503 NUMFRAMES=1 RATE=1
#exec MESH SEQUENCE MESH=F_Model SEQ=DeathEnd3  STARTFRAME=504 NUMFRAMES=1 RATE=1
#exec MESH SEQUENCE MESH=F_Model SEQ=Victory1   STARTFRAME=505 NUMFRAMES=24 RATE=15   Group=Gesture
#exec MESH SEQUENCE MESH=F_Model SEQ=StucknGoo  STARTFRAME=529 NUMFRAMES=24 RATE=15   Group=Waiting
#exec MESH SEQUENCE MESH=F_Model SEQ=Wave       STARTFRAME=553 NUMFRAMES=15 RATE=15   Group=Gesture
#exec MESH SEQUENCE MESH=F_Model SEQ=JoinMe     STARTFRAME=568 NUMFRAMES=15 RATE=15   Group=Gesture
#exec MESH SEQUENCE MESH=F_Model SEQ=Taunt1     STARTFRAME=583 NUMFRAMES=31 RATE=15   Group=Gesture
#exec MESH SEQUENCE MESH=F_Model SEQ=Taunt1L    STARTFRAME=614 NUMFRAMES=1 RATE=1     Group=Gesture
#exec MESH SEQUENCE MESH=F_Model SEQ=StrafeLgL  STARTFRAME=615 NUMFRAMES=12 RATE=19
#exec MESH SEQUENCE MESH=F_Model SEQ=StrafeLgR  STARTFRAME=627 NUMFRAMES=12 RATE=19
#exec MESH SEQUENCE MESH=F_Model SEQ=StrafeSmL  STARTFRAME=639 NUMFRAMES=12 RATE=19
#exec MESH SEQUENCE MESH=F_Model SEQ=StrafeSmR  STARTFRAME=651 NUMFRAMES=12 RATE=19
#exec MESH SEQUENCE MESH=F_Model SEQ=CockGun2   STARTFRAME=663 NUMFRAMES=12 RATE=15   Group=Waiting
#exec MESH SEQUENCE MESH=F_Model SEQ=WarmUp     STARTFRAME=675 NUMFRAMES=30 RATE=15   Group=Waiting
#exec MESH SEQUENCE MESH=F_Model SEQ=SpJump     STARTFRAME=705 NUMFRAMES=10 RATE=12   Group=Jumping
#exec MESH SEQUENCE MESH=F_Model SEQ=SpLand     STARTFRAME=715 NUMFRAMES=10 RATE=12   Group=Landing
#exec MESH SEQUENCE MESH=F_Model SEQ=SpMidair   STARTFRAME=725 NUMFRAMES=1 RATE=1
#exec MESH SEQUENCE MESH=F_Model SEQ=ArmsBound  STARTFRAME=726 NUMFRAMES=1 RATE=1     Group=Waiting
#exec MESH SEQUENCE MESH=F_Model SEQ=Victory2   STARTFRAME=727 NUMFRAMES=28 RATE=15   Group=Gesture
#exec MESH SEQUENCE MESH=F_Model SEQ=Fidget     STARTFRAME=755 NUMFRAMES=18 RATE=15   Group=Waiting

#exec TEXTURE IMPORT NAME=Hope FILE=MODELS\T02a_01.pcx GROUP=Skins FLAGS=2 // T02a_01.pcx

#exec MESHMAP NEW   MESHMAP=F_Model MESH=F_Model
#exec MESHMAP SCALE MESHMAP=F_Model X=0.125 Y=0.125 Z=0.25

#exec MESHMAP SETTEXTURE MESHMAP=F_Model NUM=0 TEXTURE=Hope

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Tycoons;
    PlayerReplicationInfo.BotIndex=AKA_Hope;
}

function Texture Face()
{
    return Texture'NerfKids.SkinIcons.I_Hope';
}

defaultproperties
{
     bIsFemale=True
     BaseEyeHeight=39.452862
     Mesh=LodMesh'NerfKids.F_Model'
     CollisionRadius=25.000000
     CollisionHeight=50.617947
}
