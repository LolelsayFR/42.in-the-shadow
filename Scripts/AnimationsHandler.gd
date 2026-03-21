# ===============================================================
#  EEEEE    M   M     A     I    L        L        EEEEE    TTTTT
#  E        MM MM    A A    I    L        L        E          T
#  EEEE     M M M   AAAAA   I    L        L        EEEE       T
#  E        M   M   A   A   I    L        L        E          T
#  EEEEE    M   M   A   A   I    LLLLL    LLLLL    EEEEE      T
# ===============================================================
extends AnimationPlayer

const LOGO_PARALLAX_X_DIVISOR:float = 10000.0
const LOGO_PARALLAX_Y_DIVISOR:float = 5000.0
const LOGO_X_CLAMP_RANGE:float = 1.0
const LOGO_Y_CLAMP_RANGE:float = 8.0
const CAMERA_ROTATION_SENSITIVITY:float = 1.0 / 400000.0

var localAnimStates:int = G.MAIN



# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var mousePos:Vector2 = get_viewport().get_mouse_position() - (G.ActualRes as Vector2 / 2)
	if not G.gameState == G.INGAME:
		$"../Main3D/Intheshadows".position.x = clampf(mousePos.x / LOGO_PARALLAX_X_DIVISOR + $"../Main3D/Intheshadows".position.x, $"../Main3D/Intheshadows".basePos.x - LOGO_X_CLAMP_RANGE, $"../Main3D/Intheshadows".basePos.x + LOGO_X_CLAMP_RANGE)
		$"../Main3D/Intheshadows".position.y = clampf($"../Main3D/Intheshadows".position.y - mousePos.y / LOGO_PARALLAX_Y_DIVISOR ,$"../Main3D/Intheshadows".basePos.y - LOGO_Y_CLAMP_RANGE, $"../Main3D/Intheshadows".basePos.y + LOGO_Y_CLAMP_RANGE)
	$"../Main3D/RotMan/Camera3D".rotation = -Vector3(mousePos.y * CAMERA_ROTATION_SENSITIVITY, mousePos.x * CAMERA_ROTATION_SENSITIVITY, 0)

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
