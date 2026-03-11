extends Node3D

var basePos:Vector3 = Vector3.ZERO
var baseQuaternion:Quaternion = Quaternion.IDENTITY

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	basePos = position
	baseQuaternion = quaternion
	pass # Replace with function body.
