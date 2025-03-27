//=============================================================================
// Troy
//=============================================================================
class Troy expands Male;

#exec MESH IMPORT MESH=M_Tall_T ANIVFILE=MODELS\t06b_a.3d DATAFILE=MODELS\t06b_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=M_Tall_T X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=M_Tall_T SEQ=All        STARTFRAME=0 NUMFRAMES=727
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=Walk       STARTFRAME=0 NUMFRAMES=16 RATE=13     
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=WalkLg     STARTFRAME=16 NUMFRAMES=16 RATE=13
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=WalkLgFr   STARTFRAME=32 NUMFRAMES=16 RATE=13
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=WalkSm     STARTFRAME=48 NUMFRAMES=16 RATE=13
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=WalkSmFr   STARTFRAME=64 NUMFRAMES=16 RATE=13
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=RunLg      STARTFRAME=80 NUMFRAMES=12 RATE=12
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=RunLgFr    STARTFRAME=92 NUMFRAMES=12 RATE=12
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=RunSm      STARTFRAME=104 NUMFRAMES=12 RATE=12
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=RunSmFr    STARTFRAME=116 NUMFRAMES=12 RATE=12
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=SwimLg     STARTFRAME=128 NUMFRAMES=12 RATE=15
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=SwimSm     STARTFRAME=140 NUMFRAMES=12 RATE=15
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=TurnLg     STARTFRAME=152 NUMFRAMES=2 RATE=15
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=TurnSm     STARTFRAME=154 NUMFRAMES=2 RATE=15
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=JumpLgFr   STARTFRAME=156 NUMFRAMES=1 RATE=1     Group=Jumping
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=JumpSmFr   STARTFRAME=157 NUMFRAMES=1 RATE=1     Group=Jumping
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=LandLgFr   STARTFRAME=158 NUMFRAMES=1 RATE=1     Group=Landing
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=LandSmFr   STARTFRAME=159 NUMFRAMES=1 RATE=1     Group=Landing
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=DuckWlkL   STARTFRAME=160 NUMFRAMES=16 RATE=12   Group=Ducking
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=DuckWlkS   STARTFRAME=176 NUMFRAMES=16 RATE=12   Group=Ducking
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=LadderClim STARTFRAME=192 NUMFRAMES=8 RATE=10
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=AimDnLg    STARTFRAME=200 NUMFRAMES=1 RATE=1     Group=Waiting
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=AimDnSm    STARTFRAME=201 NUMFRAMES=1 RATE=1     Group=Waiting
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=AimUpLg    STARTFRAME=202 NUMFRAMES=1 RATE=1     Group=Waiting
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=AimUpSm    STARTFRAME=203 NUMFRAMES=1 RATE=1     Group=Waiting
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=Breath1    STARTFRAME=204 NUMFRAMES=8 RATE=6     Group=Waiting
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=Breath2    STARTFRAME=212 NUMFRAMES=8 RATE=12    Group=Waiting
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=Breath1L   STARTFRAME=220 NUMFRAMES=8 RATE=6     Group=Waiting
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=Breath2L   STARTFRAME=228 NUMFRAMES=8 RATE=12    Group=Waiting
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=CockGun    STARTFRAME=236 NUMFRAMES=12 RATE=15   Group=Waiting
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=Look       STARTFRAME=248 NUMFRAMES=24 RATE=15   Group=Waiting
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=LookL      STARTFRAME=272 NUMFRAMES=24 RATE=15   Group=Waiting
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=StillFrRp  STARTFRAME=296 NUMFRAMES=12 RATE=15   Group=Waiting
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=StillLgFr  STARTFRAME=308 NUMFRAMES=10 RATE=15   Group=Waiting
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=StillSmFr  STARTFRAME=318 NUMFRAMES=8 RATE=15    Group=Waiting
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=TreadLg    STARTFRAME=326 NUMFRAMES=16 RATE=15   Group=Waiting
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=TreadSm    STARTFRAME=342 NUMFRAMES=16 RATE=15   Group=Waiting
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=LeftHit    STARTFRAME=358 NUMFRAMES=1 RATE=1     Group=TakeHit
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=RightHit   STARTFRAME=359 NUMFRAMES=1 RATE=1     Group=TakeHit
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=HeadHit    STARTFRAME=360 NUMFRAMES=1 RATE=1     Group=TakeHit
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=GutHit     STARTFRAME=361 NUMFRAMES=1 RATE=1     Group=TakeHit
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=Dead1      STARTFRAME=362 NUMFRAMES=20 RATE=15
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=Dead2      STARTFRAME=382 NUMFRAMES=22 RATE=15   Group=TakeHit
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=Dead3      STARTFRAME=404 NUMFRAMES=16 RATE=15   Group=TakeHit
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=Dead4      STARTFRAME=420 NUMFRAMES=13 RATE=15   Group=TakeHit
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=Dead5      STARTFRAME=433 NUMFRAMES=16 RATE=15   Group=TakeHit
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=Dead6      STARTFRAME=449 NUMFRAMES=11 RATE=15
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=Dead7      STARTFRAME=460 NUMFRAMES=23 RATE=15
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=DeathEnd   STARTFRAME=483 NUMFRAMES=1 RATE=1
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=DeathEnd2  STARTFRAME=484 NUMFRAMES=1 RATE=1
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=DeathEnd3  STARTFRAME=485 NUMFRAMES=1 RATE=1
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=Victory1   STARTFRAME=486 NUMFRAMES=18 RATE=15   Group=Gesture
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=Fidget     STARTFRAME=504 NUMFRAMES=18 RATE=15   Group=Waiting
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=Wave       STARTFRAME=522 NUMFRAMES=15 RATE=15   Group=Gesture
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=JoinMe     STARTFRAME=537 NUMFRAMES=15 RATE=15   Group=Gesture
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=Taunt1     STARTFRAME=552 NUMFRAMES=24 RATE=15   Group=Gesture
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=Taunt1L    STARTFRAME=576 NUMFRAMES=1 RATE=1     Group=Gesture
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=StrafeLgL  STARTFRAME=577 NUMFRAMES=12 RATE=18
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=StrafeLgR  STARTFRAME=589 NUMFRAMES=12 RATE=18
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=StrafeSmL  STARTFRAME=601 NUMFRAMES=12 RATE=18
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=StrafeSmR  STARTFRAME=613 NUMFRAMES=12 RATE=18
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=CockGun2   STARTFRAME=625 NUMFRAMES=12 RATE=15   Group=Waiting
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=WarmUp     STARTFRAME=637 NUMFRAMES=16 RATE=15   Group=Waiting
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=SpJump     STARTFRAME=653 NUMFRAMES=10 RATE=12   Group=Jumping
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=SpLand     STARTFRAME=663 NUMFRAMES=10 RATE=12   Group=Landing
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=SpMidair   STARTFRAME=673 NUMFRAMES=1 RATE=1
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=ArmsBound  STARTFRAME=674 NUMFRAMES=1 RATE=1     Group=Waiting
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=Victory2   STARTFRAME=675 NUMFRAMES=28 RATE=15   Group=Gesture
#exec MESH SEQUENCE MESH=M_Tall_T SEQ=StucknGoo  STARTFRAME=703 NUMFRAMES=24 RATE=15   Group=Waiting

#exec TEXTURE IMPORT NAME=Troy FILE=MODELS\T06b_01.pcx GROUP=Skins FLAGS=2 // T06b_01.pcx

#exec MESHMAP NEW   MESHMAP=M_Tall_T MESH=M_Tall_T
#exec MESHMAP SCALE MESHMAP=M_Tall_T X=0.125 Y=0.125 Z=0.25

#exec MESHMAP SETTEXTURE MESHMAP=M_Tall_T NUM=0 TEXTURE=Troy

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Baracudas;
    PlayerReplicationInfo.BotIndex=AKA_Troy;
}

function Texture Face()
{
    return Texture'NerfKids.SkinIcons.I_Troy';
}

defaultproperties
{
     BaseEyeHeight=41.260143
     Mesh=LodMesh'NerfKids.M_Tall_T'
     CollisionRadius=25.000000
     CollisionHeight=51.575180
}
