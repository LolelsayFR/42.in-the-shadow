extends Node3D
var localState:String = ""
var localTransparency:float = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Y.visible = false
	$X.visible = false
	$Z.visible = false
	$"2D".visible = false
	pass # Replace with function body.

func axysSetOpacity(val:float) -> void:
	$Y.transparency = val
	$X.transparency = val
	$Z.transparency = val
	$"2D/Y".transparency = val
	$"2D/X".transparency = val
	localTransparency = val

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("object_movement") && $"..".get_child($"..".lvl).get_meta("CanMove") :
		$Y.visible = false
		$X.visible = false
		$Z.visible = false
		$"2D".visible = true
		return
	if Input.is_action_just_released("object_movement") && $"..".get_child($"..".lvl).get_meta("CanMove"):
		localState = ""
		$"2D".visible = false
	if localState != G.rotMod:
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
		visible = true
		axysSetOpacity(0)
	if not G.ViewAxis:
		if localTransparency < 1:
			axysSetOpacity(localTransparency + 0.1)
	pass
