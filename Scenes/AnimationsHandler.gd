extends AnimationPlayer

var localAnimStates:int = G.MAIN



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var mousePos:Vector2 = get_viewport().get_mouse_position() - (G.ActualRes as Vector2 / 2)
	if not G.gameState == G.INGAME:
		$"../Main3D/Intheshadows".position.x = clampf(mousePos.x / 10000 + $"../Main3D/Intheshadows".position.x, $"../Main3D/Intheshadows".basePos.x - 1, $"../Main3D/Intheshadows".basePos.x + 1)
		$"../Main3D/Intheshadows".position.y = clampf($"../Main3D/Intheshadows".position.y - mousePos.y / 5000 ,$"../Main3D/Intheshadows".basePos.y - 8, $"../Main3D/Intheshadows".basePos.y + 8)
	$"../Main3D/RotMan/Camera3D".rotation = -Vector3(mousePos.y / 400000, mousePos.x / 400000, 0)

	if G.gameState == localAnimStates || G.gameState == G.PAUSE || G.gameState == G.SETTINGS || G.gameState == G.INGAME_SETTINGS:
		return
	if G.gameState == G.MAIN && (localAnimStates == G.INGAME || localAnimStates == G.INGAME_WIN || localAnimStates == G.PAUSE):
		current_animation = "GameToMain"
	if G.gameState == G.LVL_SELECTOR && (localAnimStates == G.INGAME || localAnimStates == G.INGAME_WIN || localAnimStates == G.PAUSE):
		current_animation = "GameToSelector"
	if G.gameState == G.INGAME && localAnimStates == G.MAIN:
		current_animation = "MainToGame"
	if G.gameState == G.MAIN && localAnimStates == G.LVL_SELECTOR:
		current_animation = "SelectorToMain"
	if G.gameState == G.LVL_SELECTOR && localAnimStates == G.MAIN:
		current_animation = "MainToSelector"
	if G.gameState == G.INGAME && localAnimStates == G.LVL_SELECTOR:
		current_animation = "SelectorToGame"
	localAnimStates = G.gameState 
	pass
