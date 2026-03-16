extends MeshInstance3D

var basePos:Vector3 = Vector3.ZERO
var baseQuaternion:Quaternion = Quaternion.IDENTITY

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	basePos = position
	baseQuaternion = quaternion
	pass # Replace with function body.


func select() -> void:
	get_material_override().set_shader_parameter("isSelected", true)

func unselect() -> void:
	get_material_override().set_shader_parameter("isSelected", false)
