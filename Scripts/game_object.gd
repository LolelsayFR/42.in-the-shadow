extends Node3D

var tracked_model_target: Node3D = null
var tracked_lvl: Node3D = null
var percent: int = 0
var all_percent: Array[int] = []
var mdlChoosen: int = 0
var lvl: int = 0
var moveStrength: float = 0.0

func _ready() -> void:
	G.maxLvl = get_child_count() - 1
	setLvl(lvl)
	_update_progress_meta()

func _process(_delta: float) -> void:
	if tracked_lvl == null:
		return

	if Input.is_action_just_pressed("change_mdl"):
		mdlChoosen += 1
		_update_tracked_model()

	_update_progress_meta()

func _get_level_models(level_node: Node3D) -> Array[Node3D]:
	var models: Array[Node3D] = []
	if level_node == null:
		return models

	for child in level_node.get_children():
		if child is Node3D:
			models.append(child as Node3D)

	if models.is_empty():
		models.append(level_node)

	return models

func _get_selected_model_index(models: Array[Node3D]) -> int:
	if models.is_empty():
		return -1
	return mdlChoosen % models.size()

func _update_tracked_model() -> void:
	var models: Array[Node3D] = _get_level_models(tracked_lvl)
	var selected_index: int = _get_selected_model_index(models)
	if selected_index == -1:
		tracked_model_target = null
		return
	tracked_model_target = models[selected_index]

func _get_model_percent(model: Node3D) -> int:
	return int(round(_compare_quaternion_and_pos(model) * 100.0))

func _get_average_percent(percents: Array[int]) -> int:
	if percents.is_empty():
		return 0

	var total: int = 0
	for value in percents:
		total += value

	@warning_ignore("integer_division")
	return total / percents.size()

func _update_progress_meta() -> void:
	all_percent = get_all_percent()
	percent = 0

	if tracked_model_target != null:
		percent = _get_model_percent(tracked_model_target)

	set_meta("percent", percent)
	set_meta("allPercent", all_percent)
	set_meta("totalPercent", _get_average_percent(all_percent))

func get_all_percent() -> Array[int]:
	var percents: Array[int] = []
	for model in _get_level_models(tracked_lvl):
		percents.append(_get_model_percent(model))
	return percents

func _randomize_model_angles_pos(model: Node3D, canRotVer: bool, canMove: bool) -> void:
	if model == null || tracked_lvl == null:
		return

	if not tracked_lvl.is_node_ready():
		await tracked_lvl.ready

	moveStrength = tracked_lvl.get_meta("moveRange")
	var model_base_quaternion: Quaternion = model.baseQuaternion
	var random_euler: Vector3 = Vector3(
		randf_range(0.0, TAU * (canRotVer as int)),
		randf_range(0.0, TAU),
		0.0
	)
	var random_quat: Quaternion = Quaternion.from_euler(random_euler)
	model.quaternion = model_base_quaternion * random_quat
	if canMove:
		model.position = Vector3(
			randf_range(-moveStrength, moveStrength),
			randf_range(-moveStrength, moveStrength),
			0
		)

	if _get_average_percent(get_all_percent()) > get_meta("randomCapPercent"):
		_randomize_model_angles_pos(model, canRotVer, canMove)

func _compare_quaternion_and_pos(model: Node3D) -> float:
	if model == null:
		return 0.0

	var model_base_quaternion: Quaternion = model.baseQuaternion
	var model_base_pos: Vector3 = model.basePos
	var angle_diff: float = model_base_quaternion.angle_to(model.quaternion)
	var similarity_rot: float = 1.0 - (angle_diff / PI)
	similarity_rot = clampf(similarity_rot, 0.0, 1.0)

	var dist: float = model.position.distance_to(model_base_pos)
	var similarity_pos: float = 1.0
	if moveStrength > 0.0:
		similarity_pos = 1.0 - clampf(dist / moveStrength, 0.0, 1.0)

	return clampf((similarity_rot * 0.9 + similarity_pos * 0.1), 0.0, 1.0)

func setLvl(nlvl:int) -> void:
	lvl = nlvl
	var last_index: int = get_child_count() - 1
	if nlvl > last_index:
		tracked_lvl = null
		tracked_model_target = null
		all_percent.clear()
		set_meta("percent", 0)
		set_meta("allPercent", all_percent)
		set_meta("totalPercent", 0)
		return

	mdlChoosen = 0

	for i in range(last_index, -1, -1):
		if not is_node_ready():
			await ready
		if nlvl != i:
			get_child(i).visible = false
		else:
			tracked_lvl = get_child(i)
			tracked_lvl.visible = true

	if tracked_lvl != null:
		moveStrength = tracked_lvl.get_meta("moveRange")
		var can_rot_vert: bool = tracked_lvl.get_meta("CanRotVert")
		var can_move: bool = tracked_lvl.get_meta("CanMove")
		for model in _get_level_models(tracked_lvl):
			await _randomize_model_angles_pos(model, can_rot_vert, can_move)

	_update_tracked_model()
	_update_progress_meta()
