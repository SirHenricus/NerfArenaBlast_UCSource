class WaterZone extends ZoneInfo;

#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\genericfx\Gsplsh1.WAV" NAME="LSplash" GROUP="Generic"
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\genericfx\Gswmexit.WAV" NAME="WtrExit1" GROUP="Generic"

defaultproperties
{
     EntrySound=Sound'NerfI.Generic.LSplash'
     ExitSound=Sound'NerfI.Generic.WtrExit1'
     EntryActor=Class'NerfI.WaterImpact'
     ExitActor=Class'NerfI.WaterImpact'
     bWaterZone=True
     ViewFlash=(X=-0.078000,Y=-0.078000,Z=-0.078000)
     ViewFog=(X=0.128900,Y=0.195300,Z=0.175780)
}
