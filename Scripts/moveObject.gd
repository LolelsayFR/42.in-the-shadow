extends Node

var speed:float = 0.1
var mouseMode:bool = false
var mouseSpeed:float = 0.01
var mouseOrigin:Vector2
var mousePos:Vector2
var mdlChoosen:int = 0
var moveRange:float = 0
var basePos:Vector3 = Vector3.ZERO
var isBased:bool = false
var rotMod:int = 0

func _ready() -> void:
	moveRange = get_meta("moveRange")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_keyHandler()
	pass

func rotMdl(x:float, y:float, mdl:Node3D) -> String:
	match rotMod % 7:
		0:
			if mdl != null:
				mdl.rotate_y(y + x)
			return "Y"
		1:
			if mdl != null:
				mdl.rotate_x(y + x)
			return "X"
		2:
			if mdl != null:
				mdl.rotate_z(y + x)
			return "Z"
		3:
			if mdl != null:
				mdl.rotate_y(x)
				mdl.rotate_x(y)
			return "XY"
		4:
			if mdl != null:
				mdl.rotate_x(y)
				mdl.rotate_z(x)
			return "XZ"
		5:
			if mdl != null:
				mdl.rotate_y(x)
				mdl.rotate_z(y)
			return "YZ"
		6:
			if mdl != null:
				mdl.rotate_y(x)
				mdl.rotate_z(y / 2)
				mdl.rotate_x(y / 2)
			return "XYZ"
	return ""


func _mouseDrag() -> void:
	if not isBased:
		basePos = get_child(mdlChoosen % get_child_count()).position
		isBased = true
	if mouseMode:
		mousePos = get_viewport().get_mouse_position()
		var x = (mousePos.x - mouseOrigin.x) * mouseSpeed
		var y = (mousePos.y - mouseOrigin.y) * mouseSpeed
		var pos = get_child(mdlChoosen % get_child_count()).position
		if Input.is_action_pressed("object_movement") && get_meta("CanMove"):\
			get_child(mdlChoosen % get_child_count()).position += _oobCheck(Vector3(x * 2, -(y * 2), 0), pos)
		else:
			rotMdl(x, y, get_child(mdlChoosen % get_child_count()))
	mouseOrigin = get_viewport().get_mouse_position()
	pass

func _keyHandler() -> void:
	if G.gameState != G.INGAME:
		return
	if Input.is_action_just_pressed("change_rot") && get_meta("CanRotVert"):
		rotMod = rotMod + 1
	if Input.is_action_pressed("mouse_click"):
		mouseMode = true;
	else:
		mouseMode = false;
	_mouseDrag()
	if Input.is_action_just_pressed("change_mdl"):
		mdlChoosen = mdlChoosen + 1
	pass

#Out of bound check
func _oobCheck(move:Vector3, oldPos:Vector3) -> Vector3:
	var new_x = clamp(oldPos.x + move.x, -moveRange, moveRange)
	var new_y = clamp(oldPos.y + move.y, -moveRange, moveRange)
	return Vector3(new_x - oldPos.x, new_y - oldPos.y, 0)
