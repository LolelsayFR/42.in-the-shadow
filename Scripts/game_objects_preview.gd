# ===============================================================
#  EEEEE    M   M     A     I    L        L        EEEEE    TTTTT
#  E        MM MM    A A    I    L        L        E          T
#  EEEE     M M M   AAAAA   I    L        L        EEEE       T
#  E        M   M   A   A   I    L        L        E          T
#  EEEEE    M   M   A   A   I    LLLLL    LLLLL    EEEEE      T
# ===============================================================
extends Node3D
var localLvl:int = -1
var baseScale:Vector3 = Vector3(0.6, 0.6, 0.6)
var scaleFactor:float = 1
var animTime:float = 0.0

const ROTATION_SPEED:float = 0.1
const ROTATION_AMPLITUDE:float = 0.5
const SCALE_SPEED:float = 0.2
const SCALE_PHASE:float = 1.4

const PHASE_X:float = 0.0
const PHASE_Y:float = TAU / 3.0
const PHASE_Z:float = 2.0 * TAU / 3.0
const PHASE_G:float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
func _moveSpecial(delta:float, node:Node3D, shift:float) -> void:
	animTime += delta

	node.rotation.x = sin(animTime * ROTATION_SPEED + PHASE_X + shift) * ROTATION_AMPLITUDE
	node.rotation.y = sin(animTime * ROTATION_SPEED + PHASE_Y + shift) * ROTATION_AMPLITUDE
	node.rotation.z = sin(animTime * ROTATION_SPEED + PHASE_Z + shift) * ROTATION_AMPLITUDE

	scaleFactor = sin(animTime * SCALE_SPEED + SCALE_PHASE + shift)
	node.scale = baseScale * abs(scaleFactor) + baseScale * 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for child in get_children():
		for i in child.get_child_count():
			_moveSpecial(delta, child.get_child(i), i)
	if visible && G.gameState != G.LVL_SELECTOR:
		visible = false
	if !visible && G.gameState == G.LVL_SELECTOR:
		visible = true
	if !visible:
		return

	
	if localLvl != G.lvl:
		localLvl = G.lvl
		for i in get_child_count():
			if i == localLvl:
				get_child(i).visible = true
			else:
				get_child(i).visible = false
