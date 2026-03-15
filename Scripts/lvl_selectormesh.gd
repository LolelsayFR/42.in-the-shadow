extends MeshInstance3D

const BUTTON_FUNC: Dictionary = {
	"1": "_on_lvl_1_pressed",
	"2": "_on_lvl_2_pressed",
	"3": "_on_lvl_3_pressed",
	"4": "_on_lvl_4_pressed",
	"5": "_on_lvl_5_pressed",
	"6": "_on_lvl_6_pressed",
	"7": "_on_lvl_7_pressed",
	"8": "_on_lvl_8_pressed",
	"9": "_on_lvl_9_pressed",
	"Play": "_on_play_pressed",
	"Back": "_on_return_to_main_pressed"
}

@onready var _buttons_3d: Node3D = $"3DButton"
@onready var _selector_2d: Control = $Sv/LevelSelector


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for mesh_name: String in BUTTON_FUNC.keys():
		var mesh_button := _buttons_3d.get_node_or_null(mesh_name) as MeshInstance3D
		if mesh_button == null:
			continue

		var click_body := StaticBody3D.new()
		click_body.name = "ClickBody"
		click_body.input_ray_pickable = true

		var collision_shape := CollisionShape3D.new()
		var box_shape := BoxShape3D.new()
		var mesh_aabb := mesh_button.get_aabb()
		var half_extents := mesh_aabb.size * 0.5

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
		click_body.mouse_entered.connect(_on_click_body_mouse_entered.bind(mesh_name))
		click_body.mouse_exited.connect(_on_click_body_mouse_exited.bind(mesh_name))
	_selector_2d._checkLvlAccess()


func _on_click_body_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int, button_name: String) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_trigger_2d_button(button_name)


func _on_click_body_mouse_entered(button_name: String) -> void:
	if _selector_2d.has_method("set_button_hover"):
		_selector_2d.call("set_button_hover", _mesh_to_level_button_name(button_name), true)


func _on_click_body_mouse_exited(button_name: String) -> void:
	if _selector_2d.has_method("set_button_hover"):
		_selector_2d.call("set_button_hover", _mesh_to_level_button_name(button_name), false)


func _mesh_to_level_button_name(button_name: String) -> String:
	if button_name.is_valid_int():
		return "Lvl%s" % button_name
	if button_name == "Back":
		return "Return to main"
	return button_name


func _trigger_2d_button(button_name: String) -> void:
	var method_name: String = BUTTON_FUNC.get(button_name, "")
	if method_name == "":
		return

	_selector_2d.call(method_name)
