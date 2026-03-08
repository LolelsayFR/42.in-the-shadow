extends Node

enum {
	MAIN,
	INGAME,
	PAUSE,
	SETTINGS,
	INGAME_SETTINGS,
	LVL_SELECTOR
}


const ROT = ["Y", "X", "Z", "XY", "XZ", "YZ", "XYZ"]

enum QUALITY {
	POTATO,
	MID,
	FULL,
}

var lvl:int = 0
var gameState:int = MAIN
var lvlProgress:int = 0
var rotMod = ROT[0]

#Settings sections
var defaultAngleMode:bool = true
var AngleMode:bool = defaultAngleMode

var defaultViewAxis:bool = false
var ViewAxis:bool = defaultViewAxis

var defaultQuality:int = QUALITY.FULL
var Quality:int = defaultQuality

var defaultResolution:Vector2i = Vector2i(1920, 1080)
var Resolution:Vector2i = defaultResolution

var defaultMasterVol:float = 1
var MasterVol:float = defaultMasterVol

var defaultSoundVol:float = 1
var SoundVol:float = defaultSoundVol


var defaultMusicVol:float = 1
var MusicVol:float = defaultMusicVol
