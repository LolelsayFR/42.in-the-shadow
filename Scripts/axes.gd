extends Node3D
var localState:String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Y.visible = false
	$X.visible = false
	$Z.visible = false
	$"2D".visible = false
	pass # Replace with function body.




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("object_movement") && $"..".get_child($"..".lvl).get_meta("CanMove") :
		$Y.visible = false
		$X.visible = false
		$Z.visible = false
		$"2D".visible = true
	if Input.is_action_just_released("object_movement") && $"..".get_child($"..".lvl).get_meta("CanMove"):
		localState = ""
		$"2D".visible = false
	if localState != $"..".get_child($"..".lvl).rotMdl(0, 0, null):
		localState = $"..".get_child($"..".lvl).rotMdl(0, 0, null)
		print("print",localState, "coucou   ", localState.find("Y"))
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
	pass
