# ===============================================================
#  EEEEE    M   M     A     I    L        L        EEEEE    TTTTT
#  E        MM MM    A A    I    L        L        E          T
#  EEEE     M M M   AAAAA   I    L        L        EEEE       T
#  E        M   M   A   A   I    L        L        E          T
#  EEEEE    M   M   A   A   I    LLLLL    LLLLL    EEEEE      T
# ===============================================================
extends Node3D

const DRAG_DISTANCE_SCALE:float = 20.0
const MOVEMENT_DRAG_SCALE:float = 2.0
const XYZ_Z_ROT_SCALE:float = 0.5

var mouseMode:bool = false
var mouse2Mode:bool = false
var mouseSpeed:float = 0.01
var mouseOrigin:Vector2
var rotateOrigin:Vector3
var moveRange:float = 0
var localMdlChoosen:int = -1

func _ready() -> void:
	moveRange = get_meta("moveRange")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if localMdlChoosen != G.mdlChoosen:
		localMdlChoosen = G.mdlChoosen
		for i in range(get_child_count()):
			if i != G.mdlChoosen % get_child_count():
				get_child(i).unselect()
			else:
				get_child(i).select()
	_keyHandler()

func _get_current_model() -> Node3D:
	if get_child_count() == 0:
		return null
	return get_child(G.mdlChoosen % get_child_count()) as Node3D

func _get_drag_distance(drag:Vector2) -> float:
	var direction:float = sign(drag.x + drag.y)
	if direction == 0:
		direction = 1
	return drag.length() * mouseSpeed * direction * DRAG_DISTANCE_SCALE

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
	var distance:float = _get_drag_distance(Vector2(x, y))
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
			mdl.rotate_z(y * XYZ_Z_ROT_SCALE)
			mdl.rotate_x(y * XYZ_Z_ROT_SCALE)

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
		var mousePos:Vector2 = get_viewport().get_mouse_position()
		var drag:Vector2 = mousePos - mouseOrigin
		var x:float = drag.x * mouseSpeed
		var y:float = drag.y * mouseSpeed
		if Input.is_action_pressed("object_movement") && get_meta("CanMove"):
			mdl.position += _oobCheck(Vector3(x * MOVEMENT_DRAG_SCALE, -(y * MOVEMENT_DRAG_SCALE), 0), mdl.position)
		else:
			for child in get_children():
				rotMdl(drag.angle(), x, y, child)
		if !_uses_angle_rotation():
			mouseOrigin = mousePos

func _keyHandler() -> void:
	if G.gameState != G.INGAME || !visible:
		return

	mouseMode = Input.is_action_pressed("mouse_click") || Input.is_action_pressed("mouse_click2")
	mouse2Mode = Input.is_action_pressed("mouse_click2")

	_mouseDrag()

#Out of bound check
func _oobCheck(move:Vector3, oldPos:Vector3) -> Vector3:
	var new_x:float = clamp(oldPos.x + move.x, -moveRange, moveRange)
	var new_y:float = clamp(oldPos.y + move.y, -moveRange, moveRange)
	return Vector3(new_x - oldPos.x, new_y - oldPos.y, 0)
