# ===============================================================
#  EEEEE    M   M     A     I    L        L        EEEEE    TTTTT
#  E        MM MM    A A    I    L        L        E          T
#  EEEE     M M M   AAAAA   I    L        L        EEEE       T
#  E        M   M   A   A   I    L        L        E          T
#  EEEEE    M   M   A   A   I    LLLLL    LLLLL    EEEEE      T
# ===============================================================
extends Node3D

var _win_target_reached:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not is_node_ready():
		await ready


var localQuality:int = -1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if G.camera != null && _win_target_reached && !$Timer.is_stopped() && G.camera.fov < 90 + (10 - (10 * $Timer.time_left)):
		G.camera.fov += 0.1
	if G.camera != null && (!_win_target_reached || G.gameState != G.INGAME) && G.camera.fov > 90:
		G.camera.fov -= 1
		if G.camera.fov < 90:
			G.camera.fov = 90
	if not (Input.is_action_pressed("mouse_click") || Input.is_action_pressed("mouse_click2")):
		_win_target_reached = G.total_percent > $GameObjects.get_meta("winCapPercent")
	else :
		_win_target_reached = false
		$Timer.stop()
	if _win_target_reached && G.gameState == G.INGAME:
		if $Timer.is_stopped():
			$Timer.start()
	else:
		$Timer.stop()
	if (Input.is_action_just_pressed("mouse_click") || Input.is_action_just_pressed("mouse_click2")) && G.gameState == G.INGAME:
		$"./Circle".scale = Vector2(1.5,1.5)
		$"./Circle".visible = true
		$"./Circle".position = get_viewport().get_mouse_position()
		$Timer.stop()
	if !Input.is_action_pressed("mouse_click") && !Input.is_action_pressed("mouse_click2")  && $"./Circle".scale <= Vector2(0.5,0.5):
		$"./Circle".visible = false
	if $"./Circle".scale > Vector2(0.5,0.5):
		$"./Circle".scale -= delta * 10 * Vector2(0.5,0.5)
	if $"./Circle".scale < Vector2(0.5,0.5):
		$"./Circle".scale = Vector2(0.5,0.5)
	if localQuality != G.Quality:
		localQuality = G.Quality
		if localQuality <= G.QUALITY.FULL:
			$Stand.visible = true
			$Plane.visible = false
			$World.visible = true
		if localQuality <= G.QUALITY.MID:
			pass # au cas ou
		if localQuality == G.QUALITY.POTATO:
			$Stand.visible = false
			$Plane.visible = true
			$World.visible = false


func getGameObject() -> Node3D:
	return $GameObjects


func _on_timer_timeout() -> void:
	if _win_target_reached:
		G.gameState = G.INGAME_WIN
