Class NerfResource extends Object;

//  FIXME
//  Eventually, we should move the character meshes into here
//  and move this stuff into NerfRes.u

// NerfKids.
//##nerf WES Sounds FIXME We need 3 sound files not one. Right now we only have one step stone sounds.
#exec AUDIO IMPORT FILE=g:\NerfRes\scrptsnd\genericfx\Gstepston.WAV NAME=stwalk1 GROUP=Generic
#exec AUDIO IMPORT FILE=g:\NerfRes\scrptsnd\genericfx\Gstepston.WAV NAME=stwalk2 GROUP=Generic
#exec AUDIO IMPORT FILE=g:\NerfRes\scrptsnd\genericfx\Gstepston.WAV NAME=stwalk3 GROUP=Generic

// Male.
#exec AUDIO IMPORT FILE=g:\NerfRes\scrptsnd\vo\genchar\vom1die.WAV NAME=MDeath1 GROUP=Male
#exec AUDIO IMPORT FILE=g:\NerfRes\scrptsnd\vo\genchar\vom2die.WAV NAME=MDeath2 GROUP=Male
#exec AUDIO IMPORT FILE=g:\NerfRes\scrptsnd\vo\genchar\vom3die.WAV NAME=MDeath3 GROUP=Male
#exec AUDIO IMPORT FILE=g:\NerfRes\scrptsnd\vo\genchar\vom4die.WAV NAME=MDeath4 GROUP=Male
#exec AUDIO IMPORT FILE=g:\NerfRes\scrptsnd\vo\genchar\vom1hit.WAV NAME=MInjur1 GROUP=Male
#exec AUDIO IMPORT FILE=g:\NerfRes\scrptsnd\vo\genchar\vom2hit.WAV NAME=MInjur2 GROUP=Male
#exec AUDIO IMPORT FILE=g:\NerfRes\scrptsnd\vo\genchar\vom3hit.WAV NAME=MInjur3 GROUP=Male
#exec AUDIO IMPORT FILE=g:\NerfRes\scrptsnd\vo\genchar\vom2gsp.WAV NAME=MGasp1 GROUP=Male
#exec AUDIO IMPORT FILE=g:\NerfRes\scrptsnd\vo\genchar\vom1gsp.WAV NAME=MGasp2 GROUP=Male
#exec AUDIO IMPORT FILE=g:\NerfRes\scrptsnd\vo\genchar\vom1grnt.WAV NAME=lland01 GROUP=Male
#exec AUDIO IMPORT FILE=g:\NerfRes\scrptsnd\vo\genchar\vomyaho.WAV NAME=MYahoo GROUP=Male
#exec AUDIO IMPORT FILE=g:\NerfRes\SCRPTSND\GENERICFX\gglub.WAV NAME=MDrown1 GROUP=Male

// Female
#exec AUDIO IMPORT FILE=g:\NerfRes\scrptsnd\vo\genchar\vof1die.WAV NAME=death1dfem GROUP=Female
#exec AUDIO IMPORT FILE=g:\NerfRes\scrptsnd\vo\genchar\vof2die.WAV NAME=death2dfem GROUP=Female
#exec AUDIO IMPORT FILE=g:\NerfRes\scrptsnd\vo\genchar\vof3die.WAV NAME=death3dfem GROUP=Female
#exec AUDIO IMPORT FILE=g:\NerfRes\scrptsnd\vo\genchar\vof4die.WAV NAME=death4dfem GROUP=Female
#exec AUDIO IMPORT FILE=g:\NerfRes\scrptsnd\vo\genchar\vof1hit.WAV NAME=linjur1fem GROUP=Female
#exec AUDIO IMPORT FILE=g:\NerfRes\scrptsnd\vo\genchar\vof2hit.WAV NAME=linjur2fem GROUP=Female
#exec AUDIO IMPORT FILE=g:\NerfRes\scrptsnd\vo\genchar\vof1gsp.WAV NAME=hgasp3fem  GROUP=Female
#exec AUDIO IMPORT FILE=g:\NerfRes\scrptsnd\vo\genchar\vof2gsp.WAV NAME=lgasp1fem  GROUP=Female
#exec AUDIO IMPORT FILE=g:\NerfRes\scrptsnd\vo\genchar\vof1grnt.WAV NAME=lland1fem  GROUP=Female
#exec AUDIO IMPORT FILE=g:\NerfRes\scrptsnd\vo\genchar\vofyaho.WAV NAME=FYahoo GROUP=Female
#exec AUDIO IMPORT FILE=g:\NerfRes\SCRPTSND\GENERICFX\gglub.WAV NAME=mdrown2fem GROUP=Female

// Brin
#exec TEXTURE IMPORT NAME=I_Brin FILE=g:\NerfRes\NerfMesh\Textures\Hud\I_Brin.pcx GROUP=SkinIcons FLAGS=2 Mips=Off

// Callie
#exec TEXTURE IMPORT NAME=I_Callie FILE=g:\NerfRes\NerfMesh\Textures\Hud\I_Callie.pcx GROUP=SkinIcons FLAGS=2 Mips=Off

// Frazier
#exec TEXTURE IMPORT NAME=I_Frazier FILE=g:\NerfRes\NerfMesh\Textures\Hud\I_Frazier.pcx GROUP=SkinIcons FLAGS=2 Mips=Off

// Georgie
#exec TEXTURE IMPORT NAME=I_Georgie FILE=g:\NerfRes\NerfMesh\Textures\Hud\I_Georgie.pcx GROUP=SkinIcons FLAGS=2 Mips=Off

// Granite
#exec TEXTURE IMPORT NAME=I_Granite FILE=g:\NerfRes\NerfMesh\Textures\Hud\I_Granite.pcx GROUP=SkinIcons FLAGS=2 Mips=Off

// Hope
#exec TEXTURE IMPORT NAME=I_Hope FILE=g:\NerfRes\NerfMesh\Textures\Hud\I_Hope.pcx GROUP=SkinIcons FLAGS=2 Mips=Off

// Jami
#exec TEXTURE IMPORT NAME=I_Jami FILE=g:\NerfRes\NerfMesh\Textures\Hud\I_Jami.pcx GROUP=SkinIcons FLAGS=2 Mips=Off

// Jamie
#exec TEXTURE IMPORT NAME=I_Jamie FILE=g:\NerfRes\NerfMesh\Textures\Hud\I_Jamie.pcx GROUP=SkinIcons FLAGS=2 Mips=Off

// Jane
#exec TEXTURE IMPORT NAME=I_Jane FILE=g:\NerfRes\NerfMesh\Textures\Hud\I_Jane.pcx GROUP=SkinIcons FLAGS=2 Mips=Off

// Jonas
#exec TEXTURE IMPORT NAME=I_Jonas FILE=g:\NerfRes\NerfMesh\Textures\Hud\I_Jonas.pcx GROUP=SkinIcons FLAGS=2 Mips=Off

// Judge
#exec TEXTURE IMPORT NAME=I_Judge FILE=g:\NerfRes\NerfMesh\Textures\Hud\I_Judge.pcx GROUP=SkinIcons FLAGS=2 Mips=Off

// Justin
#exec TEXTURE IMPORT NAME=I_Justin FILE=g:\NerfRes\NerfMesh\Textures\Hud\I_Justin.pcx GROUP=SkinIcons FLAGS=2 Mips=Off

// LittleTree
#exec TEXTURE IMPORT NAME=I_LittleTree FILE=g:\NerfRes\NerfMesh\Textures\Hud\I_LittleTree.pcx GROUP=SkinIcons FLAGS=2 Mips=Off

// Lori
#exec TEXTURE IMPORT NAME=I_Lori FILE=g:\NerfRes\NerfMesh\Textures\Hud\I_Lori.pcx GROUP=SkinIcons FLAGS=2 Mips=Off

// Mary
#exec TEXTURE IMPORT NAME=I_Mary FILE=g:\NerfRes\NerfMesh\Textures\Hud\I_Mary.pcx GROUP=SkinIcons FLAGS=2 Mips=Off

// Newton
#exec TEXTURE IMPORT NAME=I_Newton FILE=g:\NerfRes\NerfMesh\Textures\Hud\I_Newton.pcx GROUP=SkinIcons FLAGS=2 Mips=Off

// OMalley
#exec TEXTURE IMPORT NAME=I_OMalley FILE=g:\NerfRes\NerfMesh\Textures\Hud\I_OMalley.pcx GROUP=SkinIcons FLAGS=2 Mips=Off

// Phoebe
#exec TEXTURE IMPORT NAME=I_Phoebe FILE=g:\NerfRes\NerfMesh\Textures\Hud\I_Phoebe.pcx GROUP=SkinIcons FLAGS=2 Mips=Off

// Rabbit
#exec TEXTURE IMPORT NAME=I_Rabbit FILE=g:\NerfRes\NerfMesh\Textures\Hud\I_Rabbit.pcx GROUP=SkinIcons FLAGS=2 Mips=Off

// Riles
#exec TEXTURE IMPORT NAME=I_Riles FILE=g:\NerfRes\NerfMesh\Textures\Hud\I_Riles.pcx GROUP=SkinIcons FLAGS=2 Mips=Off

// Roger
#exec TEXTURE IMPORT NAME=I_Roger FILE=g:\NerfRes\NerfMesh\Textures\Hud\I_Roger.pcx GROUP=SkinIcons FLAGS=2 Mips=Off

// Ryan
#exec TEXTURE IMPORT NAME=I_Ryan FILE=g:\NerfRes\NerfMesh\Textures\Hud\I_Ryan.pcx GROUP=SkinIcons FLAGS=2 Mips=Off

// Sam
#exec TEXTURE IMPORT NAME=I_Sam FILE=g:\NerfRes\NerfMesh\Textures\Hud\I_Sam.pcx GROUP=SkinIcons FLAGS=2 Mips=Off

// Sarge
#exec TEXTURE IMPORT NAME=I_Sarge FILE=g:\NerfRes\NerfMesh\Textures\Hud\I_Sarge.pcx GROUP=SkinIcons FLAGS=2 Mips=Off

// Sharon
#exec TEXTURE IMPORT NAME=I_Sharon FILE=g:\NerfRes\NerfMesh\Textures\Hud\I_Sharon.pcx GROUP=SkinIcons FLAGS=2 Mips=Off

// Ted
#exec TEXTURE IMPORT NAME=I_Ted FILE=g:\NerfRes\NerfMesh\Textures\Hud\I_Ted.pcx GROUP=SkinIcons FLAGS=2 Mips=Off

// Todd
#exec TEXTURE IMPORT NAME=I_Todd FILE=g:\NerfRes\NerfMesh\Textures\Hud\I_Todd.pcx GROUP=SkinIcons FLAGS=2 Mips=Off

// Troy
#exec TEXTURE IMPORT NAME=I_Troy FILE=g:\NerfRes\NerfMesh\Textures\Hud\I_Troy.pcx GROUP=SkinIcons FLAGS=2 Mips=Off

// Vince
#exec TEXTURE IMPORT NAME=I_Vince FILE=g:\NerfRes\NerfMesh\Textures\Hud\I_Vince.pcx GROUP=SkinIcons FLAGS=2 Mips=Off

// WaterSpirit
#exec TEXTURE IMPORT NAME=I_WaterSpirit FILE=g:\NerfRes\NerfMesh\Textures\Hud\I_WaterSpirit.pcx GROUP=SkinIcons FLAGS=2 Mips=Off

// Wes
#exec TEXTURE IMPORT NAME=I_Wes FILE=g:\NerfRes\NerfMesh\Textures\Hud\I_Wes.pcx GROUP=SkinIcons FLAGS=2 Mips=Off

// William
#exec TEXTURE IMPORT NAME=I_William FILE=g:\NerfRes\NerfMesh\Textures\Hud\I_William.pcx GROUP=SkinIcons FLAGS=2 Mips=Off

defaultproperties
{
}
