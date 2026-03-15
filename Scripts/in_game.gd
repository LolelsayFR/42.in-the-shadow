extends Node3D

var go:Node3D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not is_node_ready():
		await ready
	go = $GameObjects
	pass # Replace with function body.


var localQuality:int = -1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse_click") || Input.is_action_just_pressed("mouse_click2") && G.gameState == G.INGAME:
		$"./Circle".scale = Vector2(1.5,1.5)
		$"./Circle".visible = true
		$"./Circle".position = get_viewport().get_mouse_position()
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
			pass
		if localQuality <= G.QUALITY.MID:
			pass
		if localQuality == G.QUALITY.POTATO:
			$Stand.visible = false
			$Plane.visible = true
			$World.visible = false
	$GameUi/gameUi/GameUi.percent =  go.get_meta("percent")
	$GameUi/gameUi/GameUi.totalPercent = go.get_meta("totalPercent")
	$ViewBar/Bar/Bar.active =  float(go.get_meta("percent")) / 100
	$ViewBar/Bar/Bar.total = float(go.get_meta("totalPercent")) / 100
	pass


func getGameObject() -> Node3D:
	return $GameObjects
