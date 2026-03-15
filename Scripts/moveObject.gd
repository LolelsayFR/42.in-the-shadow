extends Node3D

var mouseMode:bool = false
var mouse2Mode:bool = false
var mouseSpeed:float = 0.01
var mouseOrigin:Vector2
var rotateOrigin:Vector3
var mdlChoosen:int = 0
var moveRange:float = 0
var rotMod:int = 0

func _ready() -> void:
	moveRange = get_meta("moveRange")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_keyHandler()

func _get_current_model() -> Node3D:
	if get_child_count() == 0:
		return null
	return get_child(mdlChoosen % get_child_count()) as Node3D

func _get_drag_distance(drag:Vector2) -> float:
	var direction:float = sign(drag.x + drag.y)
	if direction == 0:
		direction = 1
	return drag.length() * mouseSpeed * direction * 20

func _uses_angle_rotation() -> bool:
	return mouse2Mode && G.rotMod.length() == 1

func _rotate_model_by_angle(ang:float, mdl:Node3D) -> void:
	match G.rotMod:
		"Y":
			mdl.rotation.y = rotateOrigin.y + ang
		"X":
			mdl.rotation.x = rotateOrigin.x + ang
		"Z":
			mdl.rotation.z = rotateOrigin.z + ang

func _rotate_model_by_distance(x:float, y:float, mdl:Node3D) -> void:
	var distance := _get_drag_distance(Vector2(x, y))
	match G.rotMod:
		"Y":
			mdl.rotate_y(distance)
		"X":
			mdl.rotate_x(distance)
		"Z":
			mdl.rotate_z(distance)
		"XY":
			mdl.rotate_y(x)
			mdl.rotate_x(y)
		"XZ":
			mdl.rotate_x(y)
			mdl.rotate_z(x)
		"YZ":
			mdl.rotate_y(x)
			mdl.rotate_z(y)
		"XYZ":
			mdl.rotate_y(x)
			mdl.rotate_z(y / 2)
			mdl.rotate_x(y / 2)

func rotMdl(ang:float, x:float, y:float, mdl:Node3D) -> void:
	if _uses_angle_rotation():
		_rotate_model_by_angle(ang, mdl)
		return

	_rotate_model_by_distance(x, y, mdl)

func _mouseDrag() -> void:
	var mdl:Node3D = _get_current_model()
	if mdl == null:
		return

	if Input.is_action_just_pressed("mouse_click") || Input.is_action_just_pressed("mouse_click2"):
		mouseOrigin = get_viewport().get_mouse_position()
		rotateOrigin = mdl.rotation

	if mouseMode:
		var mousePos := get_viewport().get_mouse_position()
		var drag := mousePos - mouseOrigin
		var x = drag.x * mouseSpeed
		var y = drag.y * mouseSpeed
		if Input.is_action_pressed("object_movement") && get_meta("CanMove"):
			mdl.position += _oobCheck(Vector3(x * 2, -(y * 2), 0), mdl.position)
		else:
			rotMdl(drag.angle(), x, y, mdl)
		if !_uses_angle_rotation():
			mouseOrigin = mousePos

func _keyHandler() -> void:
	if G.gameState != G.INGAME || !visible:
		return

	if Input.is_action_just_pressed("change_rot"):
		rotMod += 1
		G.rotMod = G.ROT[rotMod % 7] if get_meta("CanRotVert") else G.ROT[0]

	mouseMode = Input.is_action_pressed("mouse_click") || Input.is_action_pressed("mouse_click2")
	mouse2Mode = Input.is_action_pressed("mouse_click2")

	_mouseDrag()

	if Input.is_action_just_pressed("change_mdl"):
		mdlChoosen += 1

#Out of bound check
func _oobCheck(move:Vector3, oldPos:Vector3) -> Vector3:
	var new_x = clamp(oldPos.x + move.x, -moveRange, moveRange)
	var new_y = clamp(oldPos.y + move.y, -moveRange, moveRange)
	return Vector3(new_x - oldPos.x, new_y - oldPos.y, 0)
