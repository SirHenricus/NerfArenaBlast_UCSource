//=============================================================================
// mover_target.
//=============================================================================
class mover_target expands Actor;

#exec MESH IMPORT MESH=mover_target ANIVFILE=g:\NerfRes\NerfMesh\MODELS\mover_target_a.3d DATAFILE=g:\NerfRes\NerfMesh\MODELS\mover_target_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=mover_target X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=mover_target SEQ=All                      STARTFRAME=0 NUMFRAMES=27
#exec MESH SEQUENCE MESH=mover_target SEQ=still                    STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=mover_target SEQ=spin                     STARTFRAME=1 NUMFRAMES=9
#exec MESH SEQUENCE MESH=mover_target SEQ=pulse                    STARTFRAME=10 NUMFRAMES=17

#exec MESHMAP NEW   MESHMAP=mover_target MESH=mover_target
#exec MESHMAP SCALE MESHMAP=mover_target X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jmover_target_01 FILE=g:\NerfRes\NerfMesh\Textures\mover_target_01.PCX GROUP=Skins FLAGS=2	//skin

#exec MESHMAP SETTEXTURE MESHMAP=mover_target NUM=0 TEXTURE=Jmover_target_01

// user setable
var() int   Points;
var() name  DispatcherTag;
var() sound HitSound;
var() sound PulseSound;
var() sound SpinSound;
var() float PulseTime;
var() float SpinTime;

// internal
var Dispatcher Action;
var int counter;
var int count;

function PreBeginPlay()
{
    if ( DispatcherTag != 'None' )
    {
        foreach AllActors( class'Dispatcher',Action,DispatcherTag)
            break;
    }
    count = 10;
    Super.PreBeginPlay();
}

auto state Startup
{
    function BeginState()
    {
        SetPhysics(PHYS_MovingBrush);
    }

Begin:
    GotoState('MindingMyOwnBusiness');
}


function SpinMe( Pawn Hitter )
{
    Hitter.PlayerReplicationInfo.Score += Points;

    if ( HitSound != None )
        PlaySound( HitSound, SLOT_Pain );

    if ( Action != None )
        Action.Trigger( None, Hitter );

    GotoState('Spinning');
}


function HandleEvent( Pawn Instigator)
{
	local Actor A;

// Broadcast the Trigger message to all matching actors.
    if( Event != '' )
        foreach AllActors( class 'Actor', A, Event )
            A.Trigger( None, Instigator );
}


state MindingMyOwnBusiness
{
// ballzooka knocks on this door
    function Touch( actor Other )
    {
        if ( Other.IsA('ball') )
        {
//log( self$" touched by ball and = "$Projectile(Other).Owner );
            if ( Projectile(Other).Owner != None )
			{
                SpinMe( Pawn(Projectile(Other).Owner) );
				if ( Other.Instigator.IsA('NerfBots') )		// tell bot he/she got me
					HandleEvent( Other.Instigator );
			}
        }
    }


// all other weapons knock on this door
    function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation,
                        Vector momentum, name damageType)
    {
        if ( instigatedBy != None )
		{
            SpinMe( instigatedBy ); 
			if ( instigatedBy.IsA('NerfBots') )				// tell bot he/she got me
				HandleEvent( instigatedBy );
		}
    }

Begin:
    AmbientGlow=5;
    ScaleGlow=0.5;
    PlayAnim('still');
}

state Spinning
{
    ignores TakeDamage;

    function Tick( float delta )
    {
        AmbientGlow += 25;
        ScaleGlow += 0.25;
        if ( AmbientGlow > 255 )
        {
            AmbientGlow = 0;
            ScaleGlow = 0;
        }
    }

    function Timer()
    {
        GotoState('Pulsing');
    }
Begin:
    if ( SpinSound != None )
        PlaySound( SpinSound, SLOT_Pain );
    LoopAnim('spin');
    SetTimer( SpinTime, false );
}

state Pulsing
{
    ignores TakeDamage;

    function Tick( float delta )
    {
        counter--;
        if ( counter < 1 )
        {
            if ( ScaleGlow == 0.5 )
                ScaleGlow = 5.0;
            else ScaleGlow = 0.5;
            counter = count;
        }
    }

    function Timer()
    {
        GotoState('MindingMyOwnBusiness');
    }
Begin:
    if ( PulseSound != None )
        PlaySound( PulseSound, SLOT_Pain );
    AmbientGlow = 255;
    LoopAnim('pulse');
    SetTimer( PulseTime, false );
}

defaultproperties
{
     Points=100
     PulseTime=2.000000
     SpinTime=2.000000
     DrawType=DT_Mesh
     Mesh=LodMesh'NerfI.mover_target'
     bCollideActors=True
     bProjTarget=True
}
