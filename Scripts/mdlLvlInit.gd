# ===============================================================
#  EEEEE    M   M     A     I    L        L        EEEEE    TTTTT
#  E        MM MM    A A    I    L        L        E          T
#  EEEE     M M M   AAAAA   I    L        L        EEEE       T
#  E        M   M   A   A   I    L        L        E          T
#  EEEEE    M   M   A   A   I    LLLLL    LLLLL    EEEEE      T
# ===============================================================
extends MeshInstance3D

var basePos:Vector3 = Vector3.ZERO
var baseQuaternion:Quaternion = Quaternion.IDENTITY

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	basePos = position
	baseQuaternion = quaternion


func select() -> void:
	get_material_override().set_shader_parameter("isSelected", true)

func unselect() -> void:
	get_material_override().set_shader_parameter("isSelected", false)
