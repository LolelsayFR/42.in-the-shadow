# ===============================================================
#  EEEEE    M   M     A     I    L        L        EEEEE    TTTTT
#  E        MM MM    A A    I    L        L        E          T
#  EEEE     M M M   AAAAA   I    L        L        EEEE       T
#  E        M   M   A   A   I    L        L        E          T
#  EEEEE    M   M   A   A   I    LLLLL    LLLLL    EEEEE      T
# ===============================================================
extends Node3D

var tracked_model_target:Node3D = null
var tracked_lvl:Node3D = null
var lvl:int = 0
var moveStrength:float = 0.0
var _last_mdl_choosen:int = -1

func _ready() -> void:
	G.maxLvl = get_child_count() - 1
	setLvl(lvl)
	_sync_tracked_model_with_global()
	_update_progress_var()

func _process(_delta: float) -> void:
	if tracked_lvl == null:
		return
	if G.hint != tracked_lvl.get_meta("hint"):
		G.hint = tracked_lvl.get_meta("hint")
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
	var models:Array[Node] = tracked_lvl.get_children()
	var selected_index:int = G.mdlChoosen % tracked_lvl.get_child_count()
	tracked_model_target = models[selected_index]

func _get_model_percent(model: Node3D, model_index: int = 0) -> int:
	return int(round(_compare_quaternion_and_pos(model, model_index) * 100.0))

func _get_average_percent(percents: Array[int]) -> int:
	if percents.is_empty():
		return 0

	var total:int = 0
	for value in percents:
		total += value

	@warning_ignore("integer_division")
	return total / percents.size()

func _update_progress_var() -> void:
	G.all_percent = get_all_percent()
	G.percent = 0

	if tracked_model_target != null:
		var selected_index:int = get_selected_index()
		G.percent = _get_model_percent(tracked_model_target, selected_index)
	G.total_percent = _get_average_percent(G.all_percent)

func get_all_percent() -> Array[int]:
	var percents:Array[int] = []
	if tracked_lvl != null:
		for i in range(tracked_lvl.get_child_count()):
			var model:Node3D = tracked_lvl.get_child(i) as Node3D
			percents.append(_get_model_percent(model, i))
	return percents

func get_selected_index() -> int:
	if tracked_lvl == null or tracked_lvl.get_child_count() == 0:
		return -1
	return G.mdlChoosen % tracked_lvl.get_child_count()

func get_current_level_name() -> String:
	if tracked_lvl == null:
		return "-"
	return tracked_lvl.name

func get_current_hint() -> String:
	if tracked_lvl == null:
		return "No hint for this level"
	if tracked_lvl.has_meta("hint"):
		return str(tracked_lvl.get_meta("hint"))
	return "No hint for this level"

func _randomize_model_pos(model: Node3D, canMove: bool) -> void:
	if model == null || tracked_lvl == null:
		return

	if not tracked_lvl.is_node_ready():
		await tracked_lvl.ready

	moveStrength = tracked_lvl.get_meta("moveRange")
	if canMove:
		model.position = Vector3(
			randf_range(-moveStrength, moveStrength),
			randf_range(-moveStrength, moveStrength),
			0
		)


func _randomize_model_angle(model: Node3D, canRotVer: bool) -> void:
	if model == null || tracked_lvl == null:
		return

	if not tracked_lvl.is_node_ready():
		await tracked_lvl.ready

	var model_base_quaternion:Quaternion = model.baseQuaternion
	var base_euler:Vector3 = model_base_quaternion.get_euler()
	var random_cap_percent:float = clampf(float(get_meta("randomCapPercent")), 0.0, 99.9)
	var min_opposite_offset:float = (random_cap_percent / 200.0) * TAU
	var max_opposite_offset:float = TAU - min_opposite_offset
	var random_euler:Vector3 = Vector3(
		wrapf(base_euler.x + (randf_range(min_opposite_offset, max_opposite_offset) if canRotVer else 0.0), 0.0, TAU),
		wrapf(base_euler.y + randf_range(min_opposite_offset, max_opposite_offset), 0.0, TAU),
		0.0
	)
	var random_quat:Quaternion = Quaternion.from_euler(random_euler)
	model.quaternion = model_base_quaternion * random_quat

		
func _compare_quaternion_and_pos(model: Node3D, model_index: int) -> float:
	if model == null:
		return 0.0

	var model_base_quaternion:Quaternion = model.baseQuaternion
	var model_base_pos:Vector3 = model.basePos
	var angle_diff:float = model_base_quaternion.angle_to(model.quaternion)
	var similarity_rot:float = 1.0 - (angle_diff / PI)
	similarity_rot = clampf(similarity_rot, 0.0, 1.0)

	var dist:float = model.position.distance_to(model_base_pos)
	if model_index > 0 and tracked_lvl != null and tracked_lvl.get_child_count() > 0:
		var reference_model:Node3D = tracked_lvl.get_child(0) as Node3D
		if reference_model != null:
			var expected_delta:Vector3 = model.basePos - reference_model.basePos
			var actual_delta:Vector3 = model.position - reference_model.position
			dist = actual_delta.distance_to(expected_delta)
	var similarity_pos:float = 1.0
	if moveStrength > 0.0:
		similarity_pos = 1.0 - clampf(dist / moveStrength, 0.0, 1.0)

	return clampf((similarity_rot * 0.9 + similarity_pos * 0.1), 0.0, 1.0)

func setLvl(nlvl:int) -> void:
	lvl = nlvl
	var last_index:int = get_child_count() - 1
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
		var can_rot_vert:bool = tracked_lvl.get_meta("CanRotVert")
		var can_move:bool = tracked_lvl.get_meta("CanMove")
		await _randomize_model_angle(tracked_lvl.get_child(0), can_rot_vert)
		for model in tracked_lvl.get_children():
			model.quaternion = tracked_lvl.get_child(0).quaternion
			await _randomize_model_pos(model, can_move)

	_update_tracked_model()
	_update_progress_var()
