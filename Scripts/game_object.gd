extends Node3D

var tracked_model_target: Node3D = null
var tracked_lvl: Node3D = null
var lvl: int = 0
var moveStrength: float = 0.0
var _last_mdl_choosen: int = -1

func _ready() -> void:
	G.maxLvl = get_child_count() - 1
	setLvl(lvl)
	_sync_tracked_model_with_global()
	_update_progress_var()

func _process(_delta: float) -> void:
	if tracked_lvl == null:
		return
	_sync_tracked_model_with_global()
	_update_progress_var()

func _sync_tracked_model_with_global() -> void:
	if tracked_lvl == null or tracked_lvl.get_child_count() == 0:
		return

	if _last_mdl_choosen == G.mdlChoosen:
		return

	_update_tracked_model()
	_last_mdl_choosen = G.mdlChoosen

func _update_tracked_model() -> void:
	var models: Array[Node] = tracked_lvl.get_children()
	var selected_index: int = G.mdlChoosen % tracked_lvl.get_child_count()
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

func _update_progress_var() -> void:
	G.all_percent = get_all_percent()
	G.percent = 0

	if tracked_model_target != null:
		G.percent = _get_model_percent(tracked_model_target)
	G.total_percent = _get_average_percent(G.all_percent)

func get_all_percent() -> Array[int]:
	var percents: Array[int] = []
	for model in tracked_lvl.get_children():
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

	if _get_model_percent(model) > get_meta("randomCapPercent"):
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
		G.all_percent.clear()
		G.percent = 0
		G.total_percent = 0
		return

	G.mdlChoosen = 0
	_last_mdl_choosen = -1

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
		for model in tracked_lvl.get_children():
			await _randomize_model_angles_pos(model, can_rot_vert, can_move)

	_update_tracked_model()
	_update_progress_var()
