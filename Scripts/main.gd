extends Node

var gameplay:Resource = preload("res://Scenes/3D/inGame.tscn")
var gameplay_instance:Node3D = null
var localGameState:int = -1
var localLvl:int = -1
var localRes:Vector2i = G.resDict[G.Resolution][0]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_viewport().content_scale_mode = true
	get_viewport().content_scale_stretch = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if localRes != G.resDict[G.Resolution][0]:
		localRes = G.resDict[G.Resolution][0]
		get_viewport().content_scale_size = localRes
		if not G.isFullScreen:
			get_viewport().position = Vector2i.ZERO
	if (G.gameState == G.INGAME || G.gameState == G.PAUSE) && Input.is_action_just_pressed("pause"):
		if G.gameState == G.PAUSE:
			G.gameState = G.INGAME
		else:
			G.gameState = G.PAUSE
	if gameplay_instance != null:
		$GameSounds.bassVol = gameplay_instance.go.get_meta("percent") as float / 100
		$GameSounds.meloVol = gameplay_instance.go.get_meta("totalPercent") as float / 100
	if G.gameState != localGameState:
		localGameState = G.gameState
		$LevelSelector.visible = false
		$MainMenu.visible = false
		$Pause.visible = false
		$Settings.visible = false
		$LevelSelector.visible = false
		$Main3D.visible = false
		if gameplay_instance != null &&  G.gameState != G.PAUSE && G.gameState != G.INGAME_SETTINGS: gameplay_instance.visible = false
		match G.gameState:
			G.INGAME: if gameplay_instance != null : gameplay_instance.visible = true
			G.INGAME_SETTINGS: $Settings.visible = true
			G.SETTINGS: $Settings.visible = true
			G.MAIN: $MainMenu.visible = true
			G.PAUSE: $Pause.visible = true
			G.LVL_SELECTOR: $LevelSelector.visible = true
	if G.gameState != G.INGAME:
		if $Main3D.visible != true && G.gameState != G.INGAME_SETTINGS && G.gameState != G.PAUSE:
			$Main3D.visible = true
		return
	if localLvl != G.lvl:
		_loadLevel(G.lvl)
	if Input.is_action_pressed("mouse_click"):
		$GameSounds.moveVol = 1
	else:
		$GameSounds.moveVol = 0
	if Input.is_physical_key_pressed(KEY_1):
		G.lvl = 0
	if Input.is_physical_key_pressed(KEY_2):
		G.lvl = 1
	if Input.is_physical_key_pressed(KEY_3):
		G.lvl = 2
	if Input.is_physical_key_pressed(KEY_4):
		G.lvl = 3
	if Input.is_physical_key_pressed(KEY_5):
		G.lvl = 4
	pass

func _loadLevel(lvl:int) -> void:
	localLvl = lvl
	G.gameState = G.INGAME
	if gameplay_instance != null:
		remove_child(gameplay_instance)
		gameplay_instance = null
	gameplay_instance = gameplay.instantiate()
	gameplay_instance.getGameObject().setLvl(lvl)
	add_child(gameplay_instance)
		
