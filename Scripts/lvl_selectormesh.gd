# ===============================================================
#  EEEEE    M   M     A     I    L        L        EEEEE    TTTTT
#  E        MM MM    A A    I    L        L        E          T
#  EEEE     M M M   AAAAA   I    L        L        EEEE       T
#  E        M   M   A   A   I    L        L        E          T
#  EEEEE    M   M   A   A   I    LLLLL    LLLLL    EEEEE      T
# ===============================================================
extends MeshInstance3D

@onready var _buttons_3d: Node3D = $"3DButton"
@onready var _selector_2d: Control = $Sv/LevelSelector


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var button_names:Array[String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "Play", "Back"]
	
	for mesh_name: String in button_names:
		var mesh_button:MeshInstance3D = _buttons_3d.get_node_or_null(mesh_name) as MeshInstance3D
		if mesh_button == null:
			continue

		var click_body:StaticBody3D = StaticBody3D.new()
		click_body.name = "ClickBody"
		click_body.input_ray_pickable = true

		var collision_shape:CollisionShape3D = CollisionShape3D.new()
		var box_shape:BoxShape3D = BoxShape3D.new()
		var mesh_aabb:AABB = mesh_button.get_aabb()
		var half_extents:Vector3 = mesh_aabb.size * 0.5

		box_shape.size = Vector3(
			max(mesh_aabb.size.x, 0.02),
			max(mesh_aabb.size.y, 0.02),
			max(mesh_aabb.size.z, 0.02)
		)
		collision_shape.shape = box_shape
		collision_shape.position = mesh_aabb.position + half_extents

		click_body.add_child(collision_shape)
		mesh_button.add_child(click_body)
		click_body.input_event.connect(_on_click_body_input_event.bind(mesh_name))


func _on_click_body_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int, button_name: String) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_trigger_2d_button(button_name)



func _trigger_2d_button(button_name: String) -> void:
	if button_name.is_valid_int():
		var index:int = int(button_name) - 1
		_selector_2d._on_level_pressed(index)
	elif button_name == "Play":
		_selector_2d._on_play_pressed()
	elif button_name == "Back":
		_selector_2d._on_return_to_main_pressed()
