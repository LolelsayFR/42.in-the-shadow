extends Node

func _ready() -> void:
	readData()
	pass # Replace with function body.
	
func _process(_delta: float) -> void:
	if isFullScreen != resDict[Resolution][1]:
		isFullScreen = resDict[Resolution][1]
		if isFullScreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	if ActualRes != resDict[Resolution][0]:
		ActualRes = resDict[Resolution][0]
		DisplayServer.window_set_size(ActualRes)


enum {
	MAIN,
	INGAME,
	PAUSE,
	SETTINGS,
	INGAME_SETTINGS,
	LVL_SELECTOR,
	INGAME_WIN,
	QUIT
}


const ROT = ["Y", "X", "Z", "XY", "XZ", "YZ", "XYZ"]

enum QUALITY {
	POTATO,
	MID,
	FULL,
}

enum RES {
	# Petites résolutions (performances)
	WIN_480P,
	WIN_540P,
	WIN_600P,
	WIN_720P,
	WIN_900P,
	WIN_1080P,
	WIN_1440P,
	WIN_4K,

	# Plein écran
	FULL_480P,
	FULL_540P,
	FULL_600P,
	FULL_720P,
	FULL_900P,
	FULL_1080P,
	FULL_1440P,
	FULL_4K,
}

var resDict:Dictionary =  {
	# Fenêtré (performances)
	RES.WIN_480P:   [Vector2i(854,  480),  false, "Fenêtré - 854x480 (480p)"],
	RES.WIN_540P:   [Vector2i(960,  540),  false, "Fenêtré - 960x540 (540p)"],
	RES.WIN_600P:   [Vector2i(1066, 600),  false, "Fenêtré - 1066x600 (600p)"],

	# Fenêtré (standard)
	RES.WIN_720P:   [Vector2i(1280, 720),  false, "Fenêtré - 1280x720 (720p)"],
	RES.WIN_900P:   [Vector2i(1600, 900),  false, "Fenêtré - 1600x900 (900p)"],
	RES.WIN_1080P:  [Vector2i(1920, 1080), false, "Fenêtré - 1920x1080 (1080p)"],
	RES.WIN_1440P:  [Vector2i(2560, 1440), false, "Fenêtré - 2560x1440 (1440p)"],
	RES.WIN_4K:     [Vector2i(3840, 2160), false, "Fenêtré - 3840x2160 (4K)"],

	# Plein écran (performances)
	RES.FULL_480P:  [Vector2i(854,  480),  true,  "Plein écran - 854x480 (480p)"],
	RES.FULL_540P:  [Vector2i(960,  540),  true,  "Plein écran - 960x540 (540p)"],
	RES.FULL_600P:  [Vector2i(1066, 600),  true,  "Plein écran - 1066x600 (600p)"],

	# Plein écran (standard)
	RES.FULL_720P:  [Vector2i(1280, 720),  true,  "Plein écran - 1280x720 (720p)"],
	RES.FULL_900P:  [Vector2i(1600, 900),  true,  "Plein écran - 1600x900 (900p)"],
	RES.FULL_1080P: [Vector2i(1920, 1080), true,  "Plein écran - 1920x1080 (1080p)"],
	RES.FULL_1440P: [Vector2i(2560, 1440), true,  "Plein écran - 2560x1440 (1440p)"],
	RES.FULL_4K:    [Vector2i(3840, 2160), true,  "Plein écran - 3840x2160 (4K)"]
}

var lvl:int = 0
var maxLvl:int = 0
var gameState:int = MAIN
var rotMod = ROT[0]
var mdlChoosen:int = 0
var percent: int = 0
var all_percent: Array[int] = []
var total_percent: int = 0
var camera:Camera3D = null

#Progress Save section
var ProgressLvl:int = 0

#Settings section
var defaultViewAxis:bool = false
var ViewAxis:bool = defaultViewAxis

var defaultQuality:int = QUALITY.FULL
var Quality:int = defaultQuality

var defaultResolution:int = RES.FULL_1080P
var Resolution:int = defaultResolution

var defaultMasterVol:float = 1
var MasterVol:float = defaultMasterVol

var defaultSoundVol:float = 1
var SoundVol:float = defaultSoundVol


var defaultMusicVol:float = 1
var MusicVol:float = defaultMusicVol


var pathSave="user://in-the-shadow-data.json";

var ActualRes:Vector2i = Vector2i.ZERO
var isFullScreen:bool = resDict[defaultResolution][1]

func writeData() -> void:
	var save_file = FileAccess.open(pathSave, FileAccess.WRITE)
	var data:Dictionary={
		"ViewAxis":ViewAxis, 
		"Quality":Quality, 
		"Resolution":Resolution, 
		"MasterVol":MasterVol, 
		"SoundVol":SoundVol, 
		"MusicVol":MusicVol,
		"ProgressLvl":ProgressLvl
	}
	var json_string = JSON.stringify(data)
	save_file.store_line(json_string)

func readData() -> void:
	if not FileAccess.file_exists(pathSave):
		return # Error! We don't have a save to load.
	var save_file = FileAccess.open(pathSave, FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		# Creates the helper class to interact with JSON.
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		var parseData = json.data

		for key in parseData.keys():
			match key:
				"ViewAxis": G.ViewAxis = parseData[key]
				"Quality": G.Quality = parseData[key]
				"Resolution": G.Resolution = parseData[key]
				"MasterVol": G.MasterVol = parseData[key]
				"SoundVol": G.SoundVol = parseData[key]
				"MusicVol": G.MusicVol = parseData[key]
				"ProgressLvl": G.ProgressLvl = int(parseData[key])
