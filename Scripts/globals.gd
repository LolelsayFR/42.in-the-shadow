extends Node

func _ready() -> void:
	readCData()
	pass # Replace with function body.

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


var pathSave="user://in-the-shadow-data.json";


func writeData() -> void:
	var save_file = FileAccess.open(pathSave, FileAccess.WRITE)
	var data:Dictionary={
		"AngleMode":AngleMode, 
		"ViewAxis":ViewAxis, 
		"Quality":Quality, 
		"Resolution":Resolution, 
		"MasterVol":MasterVol, 
		"SoundVol":SoundVol, 
		"MusicVol":MusicVol
	}
	var json_string = JSON.stringify(data)
	save_file.store_line(json_string)

func readCData() -> void:
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
				"AngleMode": G.AngleMode = parseData[key]
				"ViewAxis": G.ViewAxis = parseData[key]
				"Quality": G.Quality = parseData[key]
				"MasterVol": G.MasterVol = parseData[key]
				"SoundVol": G.SoundVol = parseData[key]
				"MusicVol": G.MusicVol = parseData[key]
				"Resolution":
					var parts = parseData[key].replace("(", "").replace(")", "").replace(" ", "").split(",")
					G.Resolution = Vector2i(int(parts[0]), int(parts[1]))
