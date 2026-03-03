extends Node3D

var tracked_model_target: Node3D = null
var tracked_lvl: Node3D = null
var base_quaternion: Quaternion = Quaternion.IDENTITY
var percent: int = 0
var allpercent: int = 0
var mdlChoosen: int = 0
var lvl: int = 0
var moveStrength:float = 0
func _ready() -> void:
	setLvl(lvl)
	set_meta("percent", percent)
	if tracked_model_target == null:
		return

func _process(_delta: float) -> void:
	if tracked_model_target == null:
		return
	percent = int(round(_compare_quaternion_and_pos(tracked_model_target) * 100.0))
	allpercent = getAllPercent()
	set_meta("percent", percent)
	set_meta("totalPercent", allpercent)
	if Input.is_action_just_pressed("change_mdl"):
		mdlChoosen = mdlChoosen + 1
		tracked_model_target = _get_compare_target(get_child(lvl))

func getAllPercent() -> int:
	var result: int = 0
	var count: int = 0
	var parent = get_child(lvl)
	for i in range(parent.get_child_count()):
		var child = parent.get_child(i)
		if child.visible:
			result += int(round(_compare_quaternion_and_pos(child) * 100.0))
			count += 1
	if count == 0:
		return 0
	@warning_ignore("integer_division")
	return result / count

func _get_compare_target(model: Node3D) -> Node3D:
	if model == null:
		return null
	if model.get_child_count() > 0 and model.get_child(mdlChoosen % model.get_child_count()) is Node3D:
		return model.get_child(mdlChoosen % model.get_child_count())
	return model
	
func _randomize_model_angles_pos(mdl: Node3D, canRotVer:bool, canMove:bool) -> void:
	if mdl == null:
		return
	base_quaternion = _get_compare_target(get_child(lvl)).baseQuaternion
	# Assure tracked_lvl est bien défini
	if tracked_lvl == null:
		tracked_lvl = get_child(lvl)
	if not tracked_lvl.is_node_ready():
		await tracked_lvl.ready
	moveStrength = tracked_lvl.get_meta("moveRange")
	var random_euler: Vector3 = Vector3(
		randf_range(0.0, TAU * (canRotVer as int)),  # x Rotation
		randf_range(0.0, TAU),  # y Rotation
		0.0   # z no rotation
	)
	var random_quat: Quaternion = Quaternion.from_euler(random_euler)
	mdl.quaternion = base_quaternion * random_quat
	if canMove:
		mdl.position = Vector3(randf_range(-moveStrength, moveStrength), randf_range(-moveStrength, moveStrength), 0)
	if getAllPercent() > get_meta("randomCapPercent"):
		_randomize_model_angles_pos(mdl, canRotVer, canMove)

func _compare_quaternion_and_pos(mdl: Node3D) -> float:
	if mdl == null:
		return 0.0
	var current_quat: Quaternion = mdl.quaternion
	var current_pos: Vector3 = mdl.position
	# Calcule l'angle entre le quaternion de référence et le courant (en radians).
	var angle_diff: float = base_quaternion.angle_to(current_quat)
	var similarity_rot: float = 1.0 - (angle_diff / PI)
	similarity_rot = clampf(similarity_rot, 0.0, 1.0)
	# Comparaison de position (distance euclidienne, normalisée sur moveStrength)
	var base_pos: Vector3 = _get_compare_target(get_child(lvl)).basePos
	var dist = current_pos.distance_to(base_pos)
	var similarity_pos: float = 1.0
	if moveStrength > 0.0:
		similarity_pos = 1.0 - clampf(dist / moveStrength, 0.0, 1.0)
	# 90% rotation, 10% position
	return clampf((similarity_rot * 0.9 + similarity_pos * 0.1), 0.0, 1.0)

func setLvl(nlvl:int) -> void:
	lvl = nlvl
	var last_index: int = get_child_count() - 1
	if nlvl > last_index:
		set_meta("percent", percent)
		return
	for i in range(last_index, -1, -1):
		if not is_node_ready():
			await ready
		if nlvl != i:
			get_child(i).visible = false
		else:
			tracked_model_target = _get_compare_target(get_child(i))
			tracked_model_target.visible = true
			base_quaternion = tracked_model_target.quaternion
			tracked_lvl = get_child(i)
	if tracked_lvl != null:
		moveStrength = tracked_lvl.get_meta("moveRange")
	var count: int = get_child(nlvl).get_child_count()
	for r in range(count):
		_randomize_model_angles_pos(get_child(nlvl).get_child(r), get_child(nlvl).get_meta("CanRotVert"), get_child(nlvl).get_meta("CanMove"))
