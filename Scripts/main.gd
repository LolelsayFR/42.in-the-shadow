extends Node

var gameplay:Resource = preload("res://Scenes/3D/inGame.tscn")
var gameplay_instance:Node3D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_loadLevel(0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (G.gameState == G.INGAME || G.gameState == G.PAUSE) && Input.is_action_just_pressed("pause"):
		if G.gameState == G.PAUSE:
			$Pause.visible = false
			G.gameState = G.INGAME
		else:
			$Pause.visible = true
			G.gameState = G.PAUSE
	if gameplay_instance == null || G.gameState == G.PAUSE:
		return
	if (!$GameSounds):
		return
	if Input.is_action_pressed("mouse_click"):
		$GameSounds.moveVol = 1
	else:
		$GameSounds.moveVol = 0
	$GameSounds.bassVol = gameplay_instance.go.get_meta("percent") as float / 100
	$GameSounds.meloVol = gameplay_instance.go.get_meta("totalPercent") as float / 100
	if Input.is_physical_key_pressed(KEY_1):
		_loadLevel(0)
	if Input.is_physical_key_pressed(KEY_2):
		_loadLevel(1)
	if Input.is_physical_key_pressed(KEY_3):
		_loadLevel(2)
	if Input.is_physical_key_pressed(KEY_4):
		_loadLevel(3)
	if Input.is_physical_key_pressed(KEY_5):
		_loadLevel(4)
	pass

func _loadLevel(lvl:int) -> void:
	G.gameState = G.INGAME
	if gameplay_instance != null:
		remove_child(gameplay_instance)
		gameplay_instance = null
	gameplay_instance = gameplay.instantiate()
	gameplay_instance.getGameObject().setLvl(lvl)
	add_child(gameplay_instance)
		
