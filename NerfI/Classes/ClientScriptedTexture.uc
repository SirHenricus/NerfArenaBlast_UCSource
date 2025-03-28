class ClientScriptedTexture expands Info;

var() Texture ScriptedTexture;

simulated function BeginPlay()
{
	if(ScriptedTexture != None)
		ScriptedTexture(ScriptedTexture).NotifyActor = Self;
}

simulated function Destroyed()
{
	if(ScriptedTexture != None)
		ScriptedTexture(ScriptedTexture).NotifyActor = None;
}

simulated event RenderTexture(ScriptedTexture Tex)
{
}

defaultproperties
{
     bNoDelete=True
     RemoteRole=ROLE_SimulatedProxy
     bAlwaysRelevant=True
}
