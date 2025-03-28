//=============================================================================
// Lesson.
// Tutorial sequence controller
//=============================================================================
class Lesson expands Info;

#exec Texture Import File=g:\NerfRes\nerfmesh\Textures\Lesson.pcx Name=S_Lesson Mips=Off Flags=2

enum ELessonType
{
    LESSON_None,
    LESSON_First,
    LESSON_DontUse,
    LESSON_Triggered,
    LESSON_Last
};


// level editor settables
var() name          NextLessonTag;
var() name          GroupTriggerTag;
var() name          MainDispatchTag;
var() name          ReminderDispatchTag;
var() ELessonType   LessonType;
var() int           LessonTime;

// internals
var bool        bActive;
var Lesson      NextLesson;
var Dispatcher  ReminderDispatcher;


// link up to following lesson, if any
// kick of this lesson, if first
function BeginPlay()
{
    local Lesson L;

//log( self$" beginning play" );
// join up to next lesson, if any
    if ( NextLessonTag != '' )
    {
        foreach AllActors( class'Lesson', L, NextLessonTag )
        {
            NextLesson = L;
//log ( self$" found next lesson "$L );
            break;
        }
    }

    if ( ReminderDispatchTag != '' )
    {
        foreach AllActors( class'Dispatcher', ReminderDispatcher, ReminderDispatchTag )
            break;
    }
}


// kick off this lesson --
//  enable group triggers, if any
//  trigger main dispatcher 
//  start timer if timerval supplied
function RunLesson()
{
    local Trigger T;
    local Dispatcher D;
    local PlayerPawn PP;

//log( self$" running lesson" );
//BroadcastMessage( self$" running lesson" );

    bActive = true;

// turn on triggers associated with me
    if ( GroupTriggerTag != '' )
    {
        foreach AllActors( class'Trigger', T, GroupTriggerTag )
        {
            T.bInitiallyActive = true;
//log( self$" enabling group "$T );
        }
    }

    if ( MainDispatchTag != '' )
    {
        foreach AllActors( class'PlayerPawn', PP )
        {
//log( "L - found playerpawn "$PP$" for Main" );
            break;            
        }

        foreach AllActors( class'Dispatcher', D, MainDispatchTag )
        {
//log( self$" enabling and triggering main "$D );
            D.Trigger( self, PP );
            break;
        }
    }

    if ( LessonTime != 0 )
        SetTimer( LessonTime, false );
}


// end this lesson
//  disable group triggers
//  kick off subsequent lesson, if any
function EndLesson()
{
    local Trigger T;

    bActive = false;

//log( self$" ending lesson" );
//BroadcastMessage( self$" ending lesson" );

// turn off triggers associated with me
    if ( GroupTriggerTag != '' )
    {
        foreach AllActors( class'Trigger', T, GroupTriggerTag )
        {
            T.bInitiallyActive = false;
//log( self$" disabling group "$T );
        }
    }

    disable('Timer');

    if ( NextLesson != None )
        NextLesson.RunLesson();
}


// if we are active and trigger-controlled, end lesson
// else, ignore
event Trigger( actor Other, pawn EventInstigator )
{
//log( self$" got triggered" );
    if ( bActive )
            EndLesson();
}

// trigger reminder and recycle timer
function Timer()
{
    local PlayerPawn PP;

    if ( ReminderDispatcher != None )
    {
        foreach AllActors( class'PlayerPawn', PP )
        {
//log( "L - found playerpawn "$PP$" for Reminder" );
            break;            
        }
//log( "L - reminding "$PP$" for "$self$" via "$ReminderDispatcher );
        ReminderDispatcher.Trigger( self, PP );
    }

    if ( LessonTime != 0 )
        SetTimer( LessonTime, false );
}

defaultproperties
{
     Texture=Texture'NerfI.S_Lesson'
}
