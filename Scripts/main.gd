# ===============================================================
#  EEEEE    M   M     A     I    L        L        EEEEE    TTTTT
#  E        MM MM    A A    I    L        L        E          T
#  EEEE     M M M   AAAAA   I    L        L        EEEE       T
#  E        M   M   A   A   I    L        L        E          T
#  EEEEE    M   M   A   A   I    LLLLL    LLLLL    EEEEE      T
# ===============================================================
extends Node

var localGameState:int = -1
var localRes:Vector2i = G.resDict[G.Resolution][0]
var localIsFullScreen:bool = G.resDict[G.Resolution][1]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_viewport().content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT
	get_viewport().content_scale_stretch = true
	get_viewport().content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
	G.main = self
	G.camera = $Main3D/RotMan/Camera3D
	G.gameObject = $InGame.getGameObject()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if G.gameState == G.QUIT:
		G.writeData()
		for child:AudioStreamPlayer in $GameSounds.get_children():
			child.stop()
		get_tree().quit(0)
		return
	if localRes != G.resDict[G.Resolution][0] && G.resDict[G.Resolution][0].x <= DisplayServer.screen_get_size().x && G.resDict[G.Resolution][0].y <= DisplayServer.screen_get_size().y:
		localRes = G.resDict[G.Resolution][0]
		if localRes.x > DisplayServer.screen_get_size().x || localRes.y > DisplayServer.screen_get_size().y:
			localRes = DisplayServer.screen_get_size()
		get_tree().root.size = localRes
		get_viewport().content_scale_size = localRes
	if localIsFullScreen != G.resDict[G.Resolution][1]:
		localIsFullScreen = G.resDict[G.Resolution][1]
		get_viewport().content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
	if (G.gameState == G.INGAME || G.gameState == G.PAUSE) && Input.is_action_just_pressed("pause"):
		if G.gameState == G.PAUSE:
			G.gameState = G.INGAME
		else:
			G.gameState = G.PAUSE
	@warning_ignore("integer_division")
	if  $GameSounds.bassVol <= (G.percent as float) / 100:
		$GameSounds.bassVol += _delta as float
	if  $GameSounds.bassVol > (G.percent as float) / 100:
		$GameSounds.bassVol -= _delta as float
	if G.gameState != G.INGAME && G.gameState != G.PAUSE && G.gameState != G.SETTINGS && G.gameState != G.INGAME_SETTINGS:
		$GameSounds.bassVol = 1
	if G.gameState != localGameState:
		localGameState = G.gameState
		$Main3D/LevelSelector.visible = false
		$MainMenu.visible = false
		$Pause.visible = false
		$Settings.visible = false
		$Main3D/LevelSelector.visible = false
		$Main3D.visible = false
		if G.gameState != G.PAUSE && G.gameState != G.INGAME_SETTINGS: $InGame.visible = false
		match G.gameState:
			G.INGAME: $InGame.visible = true
			G.INGAME_SETTINGS: $Settings.visible = true
			G.SETTINGS: $Settings.visible = true
			G.MAIN: $MainMenu.visible = true
			G.PAUSE: $Pause.visible = true
			G.LVL_SELECTOR: $Main3D/LevelSelector.visible = true ; G.lvl = 0
	if G.gameState != G.INGAME:
		if $Main3D.visible != true && G.gameState != G.INGAME_SETTINGS && G.gameState != G.PAUSE:
			$Main3D.visible = true
		return
	if Input.is_action_pressed("mouse_click") ||  Input.is_action_pressed("mouse_click2"):
		$GameSounds.moveVol = 1
	else:
		$GameSounds.moveVol = 0

func loadLevel(lvl:int) -> void:
	G.gameState = G.INGAME
	G.gameObject = $InGame.getGameObject()
	G.gameObject.setLvl(lvl)


func _on_pause_button_pressed() -> void:
	G.play_ui_click()
	G.gameState = G.PAUSE
	pass # Replace with function body.
