# ===============================================================
#  EEEEE    M   M     A     I    L        L        EEEEE    TTTTT
#  E        MM MM    A A    I    L        L        E          T
#  EEEE     M M M   AAAAA   I    L        L        EEEE       T
#  E        M   M   A   A   I    L        L        E          T
#  EEEEE    M   M   A   A   I    LLLLL    LLLLL    EEEEE      T
# ===============================================================
extends Node3D
var localState:String = "null"
var localTransparency:float = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	axysSetTransparency(0)
	$Y.visible = false
	$X.visible = false
	$Z.visible = false
	$"2D".visible = false

func axysSetTransparency(val:float) -> void:
	$Y.transparency = val
	$X.transparency = val
	$Z.transparency = val
	$"2D/Y".transparency = val
	$"2D/X".transparency = val
	localTransparency = val

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	visible = true
	if not G.ViewAxis:
		if localTransparency < 1:
			axysSetTransparency(localTransparency + 0.1)
	if Input.is_action_just_pressed("object_movement") && $"..".get_child($"..".lvl).get_meta("CanMove") :
		axysSetTransparency(0)
		localState = ""
		$Y.visible = false
		$X.visible = false
		$Z.visible = false
		$"2D".visible = true
	if Input.is_action_just_released("object_movement"):
		$"2D".visible = false
		axysSetTransparency(0)
	if (localState != G.rotMod || G.ViewAxis) && not Input.is_action_pressed("object_movement") :
		localState = G.rotMod
		$Y.visible = false
		$X.visible = false
		$Z.visible = false
		if localState.find("X") != -1:
			$X.visible = true
		if localState.find("Y") != -1:
			$Y.visible = true
		if localState.find("Z") != -1:
			$Z.visible = true
		axysSetTransparency(0)
