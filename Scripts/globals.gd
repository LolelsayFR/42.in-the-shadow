# ===============================================================
#  EEEEE    M   M     A     I    L        L        EEEEE    TTTTT
#  E        MM MM    A A    I    L        L        E          T
#  EEEE     M M M   AAAAA   I    L        L        EEEE       T
#  E        M   M   A   A   I    L        L        E          T
#  EEEEE    M   M   A   A   I    LLLLL    LLLLL    EEEEE      T
# ===============================================================
extends Node


var _ui_click_player:AudioStreamPlayer = null

func _ready() -> void:
	readData()
	
func _process(_delta: float) -> void:
	if ProgressLvl >= maxLvl:
		ProgressLvl = maxLvl - 1
	if isFullScreen != resDict[Resolution][1]:
		isFullScreen = resDict[Resolution][1]
		if isFullScreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	if ActualRes != resDict[Resolution][0]:
		ActualRes = resDict[Resolution][0]
		DisplayServer.window_set_size(ActualRes)
	_handle_ingame_input()

func _handle_ingame_input() -> void:
	if gameState != INGAME:
		return

	if Input.is_action_just_pressed("change_mdl"):
		mdlChoosen += 1

	if Input.is_action_just_pressed("change_rot"):
		var can_rot_vert:bool = false
		if gameObject != null and lvl >= 0 and lvl < gameObject.get_child_count():
			var lvl_node:Node = gameObject.get_child(lvl)
			if lvl_node.has_meta("CanRotVert"):
				can_rot_vert = bool(lvl_node.get_meta("CanRotVert"))

		if can_rot_vert:
			var rot_index:int = ROT.find(rotMod)
			if rot_index < 0:
				rot_index = 0
			rotMod = ROT[(rot_index + 1) % ROT.size()]
		else:
			rotMod = ROT[0]

func play_ui_click() -> void:
	if main == null:
		return

	var linear_volume:float = clampf(MasterVol * SoundVol, 0.001, 1.0)
	_ui_click_player.volume_db = linear_to_db(linear_volume)
	_ui_click_player.pitch_scale = 1.0 * MasterVol
	_ui_click_player.play(0.08)


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


const ROT:Array[String] = ["Y", "X", "Z", "XY", "XZ", "YZ", "XYZ"]

enum QUALITY {
	POTATO,
	MID,
	FULL,
}

enum RES {
	# Small resolutions (performance)
	WIN_480P,
	WIN_540P,
	WIN_600P,
	WIN_720P,
	WIN_900P,
	WIN_1080P,
	WIN_1440P,
	WIN_4K,

	# Fullscreen
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
	# Windowed (performance)
	RES.WIN_480P:   [Vector2i(854,  480),  false, "Windowed - 854x480 (480p)"],
	RES.WIN_540P:   [Vector2i(960,  540),  false, "Windowed - 960x540 (540p)"],
	RES.WIN_600P:   [Vector2i(1066, 600),  false, "Windowed - 1066x600 (600p)"],

	# Windowed (standard)
	RES.WIN_720P:   [Vector2i(1280, 720),  false, "Windowed - 1280x720 (720p)"],
	RES.WIN_900P:   [Vector2i(1600, 900),  false, "Windowed - 1600x900 (900p)"],
	RES.WIN_1080P:  [Vector2i(1920, 1080), false, "Windowed - 1920x1080 (1080p)"],
	RES.WIN_1440P:  [Vector2i(2560, 1440), false, "Windowed - 2560x1440 (1440p)"],
	RES.WIN_4K:     [Vector2i(3840, 2160), false, "Windowed - 3840x2160 (4K)"],

	# Fullscreen (performance)
	RES.FULL_480P:  [Vector2i(854,  480),  true,  "Fullscreen - 854x480 (480p)"],
	RES.FULL_540P:  [Vector2i(960,  540),  true,  "Fullscreen - 960x540 (540p)"],
	RES.FULL_600P:  [Vector2i(1066, 600),  true,  "Fullscreen - 1066x600 (600p)"],

	# Fullscreen (standard)
	RES.FULL_720P:  [Vector2i(1280, 720),  true,  "Fullscreen - 1280x720 (720p)"],
	RES.FULL_900P:  [Vector2i(1600, 900),  true,  "Fullscreen - 1600x900 (900p)"],
	RES.FULL_1080P: [Vector2i(1920, 1080), true,  "Fullscreen - 1920x1080 (1080p)"],
	RES.FULL_1440P: [Vector2i(2560, 1440), true,  "Fullscreen - 2560x1440 (1440p)"],
	RES.FULL_4K:    [Vector2i(3840, 2160), true,  "Fullscreen - 3840x2160 (4K)"]
}

var lvl:int = 0
var maxLvl:int = 0
var gameState:int = MAIN
var rotMod:String = ROT[0]
var mdlChoosen:int = 0
var percent:int = 0
var all_percent:Array[int] = []
var total_percent:int = 0
var main:Node = null
var camera:Camera3D = null
var gameObject:Node3D = null
var sandbox:bool = false
var hint:String = ""

#Progress Save section
var ProgressLvl:int = 0

#Settings section
var defaultViewAxis:bool = false
var ViewAxis:bool = defaultViewAxis

var defaultEzmode:bool = false
var ezmode:bool = defaultEzmode

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


const SAVE_PATH:String = "user://in-the-shadow-data.json"

var ActualRes:Vector2i = Vector2i.ZERO
var isFullScreen:bool = resDict[defaultResolution][1]

func writeData() -> bool:
	var save_file:FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if save_file == null:
		push_error("Failed to open save file: %s (Error: %d)" % [SAVE_PATH, FileAccess.get_open_error()])
		return false
	
	var data:Dictionary={
		"ViewAxis":ViewAxis, 
		"ezmod":ezmode,
		"Quality":Quality, 
		"Resolution":Resolution, 
		"MasterVol":MasterVol, 
		"SoundVol":SoundVol, 
		"MusicVol":MusicVol,
		"ProgressLvl":ProgressLvl
	}
	var json_string:String = JSON.stringify(data)
	save_file.store_line(json_string)
	return true

func readData() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		push_warning("Save file not found, using default values")
		return false
	var save_file:FileAccess = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if save_file == null:
		push_error("Failed to read save file: %d" % FileAccess.get_open_error())
		return false
	while save_file.get_position() < save_file.get_length():
		var json_string:String = save_file.get_line()

		# Creates the helper class to interact with JSON.
		var json:JSON = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result:int = json.parse(json_string)
		if not parse_result == OK:
			push_error("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		var parseData:Dictionary = json.data

		for key in parseData.keys():
			match key:
				"ViewAxis": G.ViewAxis = parseData[key]
				"ezmod": G.ezmode = parseData[key]
				"Quality": G.Quality = parseData[key]
				"Resolution": G.Resolution = parseData[key]
				"MasterVol": G.MasterVol = parseData[key]
				"SoundVol": G.SoundVol = parseData[key]
				"MusicVol": G.MusicVol = parseData[key]
				"ProgressLvl": G.ProgressLvl = int(parseData[key])

		# Sanitize loaded settings to avoid invalid save values crashing runtime lookups.
		if not (ViewAxis is bool):
			ViewAxis = defaultViewAxis
		if not (ezmode is bool):
			ezmode = defaultEzmode

		Quality = int(Quality)
		if Quality < QUALITY.POTATO or Quality > QUALITY.FULL:
			Quality = defaultQuality

		Resolution = int(Resolution)
		if not resDict.has(Resolution):
			Resolution = defaultResolution

		MasterVol = clampf(float(MasterVol), 0.0, 1.0)
		SoundVol = clampf(float(SoundVol), 0.0, 1.0)
		MusicVol = clampf(float(MusicVol), 0.0, 1.0)

		ProgressLvl = maxi(0, int(ProgressLvl))
		if maxLvl > 0:
			ProgressLvl = mini(ProgressLvl, maxLvl - 1)
	return true
