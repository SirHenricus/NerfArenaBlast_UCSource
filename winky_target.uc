//=============================================================================
// winky_target.
//=============================================================================
class winky_target expands Actor;

// original 'iris' winky
//#exec MESH IMPORT MESH=winky_target03 ANIVFILE=g:\NerfRes\NerfMesh\MODELS\winky_target03_a.3d DATAFILE=g:\NerfRes\NerfMesh\MODELS\winky_target03_d.3d X=0 Y=0 Z=0
//#exec MESH ORIGIN MESH=winky_target03 X=0 Y=0 Z=0
//#exec MESH SEQUENCE MESH=winky_target03 SEQ=All                      STARTFRAME=0 NUMFRAMES=24
//#exec MESH SEQUENCE MESH=winky_target03 SEQ=opened                   STARTFRAME=0 NUMFRAMES=1
//#exec MESH SEQUENCE MESH=winky_target03 SEQ=close                    STARTFRAME=1 NUMFRAMES=11
//#exec MESH SEQUENCE MESH=winky_target03 SEQ=closed                   STARTFRAME=12 NUMFRAMES=1
//#exec MESH SEQUENCE MESH=winky_target03 SEQ=open                     STARTFRAME=13 NUMFRAMES=11
//#exec MESHMAP NEW   MESHMAP=winky_target03 MESH=winky_target03
//#exec MESHMAP SCALE MESHMAP=winky_target03 X=0.1 Y=0.1 Z=0.2
//#exec TEXTURE IMPORT NAME=Jwinky_target03_01 FILE=g:\NerfRes\NerfMesh\Textures\winky_target03_01.PCX GROUP=Skins FLAGS=2	//twosided
//#exec TEXTURE IMPORT NAME=Jwinky_target03_02 FILE=g:\NerfRes\NerfMesh\Textures\winky_target03_02.PCX GROUP=Skins FLAGS=2	//ap[2
//#exec TEXTURE IMPORT NAME=Jwinky_target03_03 FILE=g:\NerfRes\NerfMesh\Textures\winky_target03_03.PCX GROUP=Skins FLAGS=2	//skin
//#exec TEXTURE IMPORT NAME=Jwinky_250 FILE=g:\nerfres\nerfmesh\textures\250point.pcx Group=Skins    // score value
//#exec TEXTURE IMPORT NAME=Jwinky_500 FILE=g:\nerfres\nerfmesh\textures\500point.pcx Group=Skins    // score value
//#exec TEXTURE IMPORT NAME=Jwinky_1000 FILE=g:\nerfres\nerfmesh\textures\1000point.pcx Group=Skina  // score value
//#exec MESHMAP SETTEXTURE MESHMAP=winky_target03 NUM=1 TEXTURE=Jwinky_target03_01
//#exec MESHMAP SETTEXTURE MESHMAP=winky_target03 NUM=2 TEXTURE=Jwinky_target03_02
//#exec MESHMAP SETTEXTURE MESHMAP=winky_target03 NUM=0 TEXTURE=Jwinky_target03_03


#exec MESH IMPORT MESH=P_Target01 ANIVFILE=g:\NerfRes\NerfMesh\MODELS\P_Target01_a.3d DATAFILE=g:\NerfRes\NerfMesh\MODELS\P_Target01_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=P_Target01 X=0 Y=0 Z=0
#exec MESH SEQUENCE MESH=P_Target01 SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=P_Target01 SEQ=target                   STARTFRAME=0 NUMFRAMES=1
#exec MESHMAP NEW   MESHMAP=P_Target01 MESH=P_Target01
#exec MESHMAP SCALE MESHMAP=P_Target01 X=0.1 Y=0.1 Z=0.2


// WTS: WinkyTargetSkin
// _Cold    -- inactive, waiting for timer (default)
// _Hot     -- active, waiting to be shot
// _Anix    -- shot, animating
// WPS: WinkyPointSkin
#exec TEXTURE IMPORT NAME=WTS_Cold    FILE=g:\NerfRes\NerfMesh\Textures\P_Target01_06.PCX GROUP=Skins FLAGS=2	// Masked
#exec TEXTURE IMPORT NAME=WTS_Hot     FILE=g:\NerfRes\NerfMesh\Textures\P_Target01_05.PCX GROUP=Skins FLAGS=2	// Masked
#exec TEXTURE IMPORT NAME=WTS_Ani0    FILE=g:\NerfRes\NerfMesh\Textures\P_Target01_01.PCX GROUP=Skins FLAGS=2	// Masked
#exec TEXTURE IMPORT NAME=WTS_Ani1    FILE=g:\NerfRes\NerfMesh\Textures\P_Target01_02.PCX GROUP=Skins FLAGS=2	// Masked
#exec TEXTURE IMPORT NAME=WTS_Ani2    FILE=g:\NerfRes\NerfMesh\Textures\P_Target01_03.PCX GROUP=Skins FLAGS=2	// Masked
#exec TEXTURE IMPORT NAME=WTS_Ani3    FILE=g:\NerfRes\NerfMesh\Textures\P_Target01_04.PCX GROUP=Skins FLAGS=2	// Masked
#exec TEXTURE IMPORT NAME=WPS_250     FILE=g:\NerfRes\NerfMesh\Textures\P_Target02_04.PCX GROUP=Skins FLAGS=2   // Masked
#exec TEXTURE IMPORT NAME=WPS_500     FILE=g:\NerfRes\NerfMesh\Textures\P_Target02_03.PCX GROUP=Skins FLAGS=2 	// Masked
#exec TEXTURE IMPORT NAME=WPS_1000    FILE=g:\NerfRes\NerfMesh\Textures\P_Target02_01.PCX GROUP=Skins FLAGS=2		// Masked

#exec MESHMAP SETTEXTURE MESHMAP=P_Target01 NUM=0 TEXTURE=WTS_Cold


enum EWPoint
{
    WINK_250,
    WINK_500,
    WINK_1000
};

// editor settable
var() float     OpenDelay;
var() float     CloseDelay;
var() sound     HitSound;
var() sound     OpenSound;
var() sound     CloseSound;
var() name      DispatcherTag;
var() EWPoint   Value;          // 250, 500 or 1000 pts

// internal
var int       Points;
var bool        bOpen;          // initial state
var bool        bASpin;
var int         ixAni;
var int         TicksPerFrame;
var int         TPF_Counter;
var float       AnimTime;
var Dispatcher  Action;
var Texture     PointSkin[3];   // value displays
var Texture     SpinSkin[4];    // hit animation
var Texture     HotSkin;        // hot to get hit
var Texture     ColdSkin;       // mindin' its own business
var Texture     WinSkin;        // value display for this target

function PreBeginPlay()
{
//log( self$" prebegin" );

    if ( DispatcherTag != 'None' )
    {
        foreach AllActors( class 'Dispatcher', Action, DispatcherTag )
            break;
    }

//log( self$" found Action "$Action );

    Super.PreBeginPlay();
}



simulated function PostBeginPlay()
{
    switch( Value )
    {
        case WINK_250:
            WinSkin=PointSkin[0];
            Points = 250;
            break;
        case WINK_500:
            WinSkin=PointSkin[1];
            Points = 500;
            break;
        case WINK_1000:
            WinSkin=PointSkin[2];
            Points = 1000;
            break;
    }
}


auto state Startup
{
    function BeginState()
    {
//log( self$" startup beginstate" );
    }
Begin:
//log( self$" startup beginlabel" );
    SetPhysics( PHYS_MovingBrush );
    if ( bOpen )
        GotoState('Wink02Open');
    else
        GotoState('Wink02Close');
}


function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, name damageType)
{

// i don't need no stinkin' damages!
    Super.TakeDamage( 0.0, instigatedBy, hitlocation, 
						momentum, damageType);
}

function Bump( actor Other )
{
//log( self$" bumped by "$Other );
}



function SpinMe( Pawn Hitter )
{
    local winky_point    bonus;

    Hitter.PlayerReplicationInfo.Score += Points;
    if ( HitSound != None )
    {
        PlaySound( HitSound, SLOT_Pain );
    }
    if ( Action != None )
        Action.Trigger( None, Hitter );
    bASpin = true;          // start spining on ticks
    ixAni = 0;
    TPF_Counter = TicksPerFrame;
    Skin = SpinSkin[ixAni];
    bonus = spawn(class'winky_point',,,Location);
    bonus.DrawScale = DrawScale / 2.0;
    bonus.texture = WinSkin;
    bonus.gotostate('Hanging'); 
    enable('Tick');
    SetTimer( AnimTime, false );
}


state Wink02Open
{
    function BeginState()
    {
//log( self$" open beginstate" );
    }

    function Timer()
    {
        bASpin = false;
        disable('Tick');
        GotoState( 'Wink02Close' );
    }


    function Tick(float Delta)
    {
        if ( bASpin )
        {
            TPF_Counter--;
            if ( TPF_Counter < 0 )
            {
                TPF_Counter = TicksPerFrame;
                ixAni++;
                if ( ixAni > 3 ) ixAni = 0;
                Skin = SpinSkin[ixAni];
            }
        }
    }


// ballzooka hit comes in here
    function Touch( actor Other )
    {
        if ( Other.IsA('ball') )
        {
//log( self$" touched by ball and = "$Projectile(Other).Owner );
            if ( Projectile(Other).Owner != None && bASpin == false )
                SpinMe( Pawn(Projectile(Other).Owner) );
        }
    }

// all other weapons hit here
    function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, name damageType)
    {
        if ( instigatedBy != None && bASpin == false )
            SpinMe( instigatedBy );
    }

Begin:
//log( self$" open beginlabel" );
    bOpen = true;
    bASpin = false;

    if ( OpenSound != None )
        PlaySound( OpenSound );

    Skin = HotSkin;
    enable('Touch');
}

state Wink02Close
{
    ignores Trigger, Touch;

    function BeginState()
    {
//log( self$" close beginstate" );
    }

    function Timer()
    {
//log( self$" close timer" );
        GotoState('Wink02Open');
    }

Begin:
    bOpen = false;
    if ( CloseSound != None )
        PlaySound( CloseSound, SLOT_Misc );
    Skin = ColdSkin;
    SetTimer( OpenDelay, false );
}

defaultproperties
{
     OpenDelay=10.000000
     CloseDelay=3.000000
     TicksPerFrame=3
     AnimTime=3.000000
     PointSkin(0)=Texture'NerfI.Skins.WPS_250'
     PointSkin(1)=Texture'NerfI.Skins.WPS_500'
     PointSkin(2)=Texture'NerfI.Skins.WPS_1000'
     SpinSkin(0)=Texture'NerfI.Skins.WTS_Ani0'
     SpinSkin(1)=Texture'NerfI.Skins.WTS_Ani1'
     SpinSkin(2)=Texture'NerfI.Skins.WTS_Ani2'
     SpinSkin(3)=Texture'NerfI.Skins.WTS_Ani3'
     HotSkin=Texture'NerfI.Skins.WTS_Hot'
     ColdSkin=Texture'NerfI.Skins.WTS_Cold'
     bStasis=True
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=LodMesh'NerfI.P_Target01'
     AmbientGlow=231
     CollisionRadius=45.000000
     CollisionHeight=45.000000
     bCollideActors=True
     bProjTarget=True
}
