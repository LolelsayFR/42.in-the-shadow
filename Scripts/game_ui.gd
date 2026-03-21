# ===============================================================
#  EEEEE    M   M     A     I    L        L        EEEEE    TTTTT
#  E        MM MM    A A    I    L        L        E          T
#  EEEE     M M M   AAAAA   I    L        L        EEEE       T
#  E        M   M   A   A   I    L        L        E          T
#  EEEEE    M   M   A   A   I    LLLLL    LLLLL    EEEEE      T
# ===============================================================
extends Control

@onready var _level_label:Label = get_node_or_null("PanelContainer/MarginContainer/VBox/TopRow/Level") as Label
@onready var _mode_label:Label = get_node_or_null("PanelContainer/MarginContainer/VBox/TopRow/Mode") as Label
@onready var _selected_label:Label = get_node_or_null("PanelContainer/MarginContainer/VBox/TopRow/Selected") as Label
@onready var _rot_label:Label = get_node_or_null("PanelContainer/MarginContainer/VBox/StatusRow/Rot") as Label
@onready var _win_target_label:Label = get_node_or_null("PanelContainer/MarginContainer/VBox/StatusRow/Target") as Label
@onready var _selected_card:PanelContainer = get_node_or_null("PanelContainer/MarginContainer/VBox/SelectedCard") as PanelContainer
@onready var _total_card:PanelContainer = get_node_or_null("PanelContainer/MarginContainer/VBox/TotalCard") as PanelContainer
@onready var _objects_card:PanelContainer = get_node_or_null("PanelContainer/MarginContainer/VBox/ObjectsCard") as PanelContainer
@onready var _controls_label:Label = get_node_or_null("PanelContainer/MarginContainer/VBox/ControlsCard/Margin/Controls") as Label

@onready var _selected_value_label:Label = get_node_or_null("PanelContainer/MarginContainer/VBox/SelectedCard/MarginContainer/Margin/Header/Value") as Label
@onready var _selected_bar:ProgressBar = get_node_or_null("PanelContainer/MarginContainer/VBox/SelectedCard/MarginContainer/Margin/Bar") as ProgressBar
@onready var _total_value_label:Label = get_node_or_null("PanelContainer/MarginContainer/VBox/TotalCard/MarginContainer/Margin/Header/Value") as Label
@onready var _total_bar:ProgressBar = get_node_or_null("PanelContainer/MarginContainer/VBox/TotalCard/MarginContainer/Margin/Bar") as ProgressBar

@onready var _hint_value_label:Label = get_node_or_null("PanelContainer/MarginContainer/VBox/HintCard/Margin/Hint") as Label
@onready var _obj_row_1:HBoxContainer = get_node_or_null("PanelContainer/MarginContainer/VBox/ObjectsCard/Margin/VBox/ObjectsList/Obj1") as HBoxContainer
@onready var _obj_row_2:HBoxContainer = get_node_or_null("PanelContainer/MarginContainer/VBox/ObjectsCard/Margin/VBox/ObjectsList/Obj2") as HBoxContainer
@onready var _obj_row_3:HBoxContainer = get_node_or_null("PanelContainer/MarginContainer/VBox/ObjectsCard/Margin/VBox/ObjectsList/Obj3") as HBoxContainer

@onready var _obj_name_1:Label = get_node_or_null("PanelContainer/MarginContainer/VBox/ObjectsCard/Margin/VBox/ObjectsList/Obj1/Name") as Label
@onready var _obj_name_2:Label = get_node_or_null("PanelContainer/MarginContainer/VBox/ObjectsCard/Margin/VBox/ObjectsList/Obj2/Name") as Label
@onready var _obj_name_3:Label = get_node_or_null("PanelContainer/MarginContainer/VBox/ObjectsCard/Margin/VBox/ObjectsList/Obj3/Name") as Label

@onready var _obj_bar_1:ProgressBar = get_node_or_null("PanelContainer/MarginContainer/VBox/ObjectsCard/Margin/VBox/ObjectsList/Obj1/Bar") as ProgressBar
@onready var _obj_bar_2:ProgressBar = get_node_or_null("PanelContainer/MarginContainer/VBox/ObjectsCard/Margin/VBox/ObjectsList/Obj2/Bar") as ProgressBar
@onready var _obj_bar_3:ProgressBar = get_node_or_null("PanelContainer/MarginContainer/VBox/ObjectsCard/Margin/VBox/ObjectsList/Obj3/Bar") as ProgressBar

@onready var _obj_value_1:Label = get_node_or_null("PanelContainer/MarginContainer/VBox/ObjectsCard/Margin/VBox/ObjectsList/Obj1/Value") as Label
@onready var _obj_value_2:Label = get_node_or_null("PanelContainer/MarginContainer/VBox/ObjectsCard/Margin/VBox/ObjectsList/Obj2/Value") as Label
@onready var _obj_value_3:Label = get_node_or_null("PanelContainer/MarginContainer/VBox/ObjectsCard/Margin/VBox/ObjectsList/Obj3/Value") as Label

var _last_level:int = -1
var _last_sandbox:bool = true
const MAX_OBJECT_ROWS:int = 3
const FONT_SIZE_NORMAL:int = 32
const FONT_SIZE_FOCUS:int = 58
const CONTROLS_SANDBOX:String = "Controls:\n- Left click drag: rotate\n- Right click drag: precise rotate\n- Shift + click drag: move object"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_apply_mode_visibility(true)
	_update_ui(true)


# Called every frame. '_delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_update_ui(false)

func _update_ui(force:bool) -> void:
	if force or _last_sandbox != G.sandbox:
		_apply_mode_visibility(force)

	var model_count:int = G.all_percent.size()
	if model_count <= 0 and G.gameObject != null:
		model_count = G.gameObject.get_child_count()

	if G.sandbox:
		_apply_sandbox_detail_visibility(model_count > 1)

	if force or _last_level != G.lvl:
		_last_level = G.lvl
		_level_label.text = "Lvl: %d" % G.lvl

	if G.gameObject != null and G.gameObject.has_meta("winCapPercent"):
		var win_target:int = int(G.gameObject.get_meta("winCapPercent"))
		_win_target_label.text = "Target: %d%%" % win_target
	else:
		_win_target_label.text = "Target: -"

	_hint_value_label.text = "Hint : " + G.hint if not G.hint.is_empty() else "No hint available"

	_mode_label.text = "Mode: %s" % ("Sandbox" if G.sandbox else "Classic")
	_rot_label.text = "Rotation: %s" % G.rotMod

	var selected_index:int = -1
	if G.all_percent.size() > 0:
		selected_index = G.mdlChoosen % G.all_percent.size()

	_selected_label.text = "Selected: %s" % ("-" if selected_index < 0 else str(selected_index))
	_controls_label.text = _build_controls_text(model_count)

	if G.sandbox:
		_selected_bar.value = clampf(G.percent, 0.0, 100.0)
		_selected_value_label.text = "#%s | %d%%" % (["-" if selected_index < 0 else str(selected_index), G.percent])

		_total_bar.value = clampf(G.total_percent, 0.0, 100.0)
		_total_value_label.text = "%d%%" % G.total_percent

		_update_object_rows(selected_index)

func _apply_mode_visibility(force:bool) -> void:
	if not force and _last_sandbox == G.sandbox:
		return

	_last_sandbox = G.sandbox

	_level_label.visible = true
	_mode_label.visible = G.sandbox
	_win_target_label.visible = G.sandbox
	_selected_label.visible = not G.sandbox
	_selected_card.visible = G.sandbox
	_total_card.visible = G.sandbox
	_objects_card.visible = G.sandbox

	_selected_label.add_theme_font_size_override("font_size", FONT_SIZE_FOCUS if not G.sandbox else FONT_SIZE_NORMAL)
	_rot_label.add_theme_font_size_override("font_size", FONT_SIZE_FOCUS if not G.sandbox else FONT_SIZE_NORMAL)

func _apply_sandbox_detail_visibility(show_percentages:bool) -> void:
	_selected_card.visible = show_percentages
	_total_card.visible = show_percentages
	_objects_card.visible = show_percentages

func _build_controls_text(model_count:int) -> String:
	if G.sandbox:
		return CONTROLS_SANDBOX

	var can_move:bool = false
	var can_rot_vert:bool = false

	if G.gameObject != null and G.lvl >= 0 and G.lvl < G.gameObject.get_child_count():
		var lvl_node:Node = G.gameObject.get_child(G.lvl)
		if lvl_node.has_meta("CanMove"):
			can_move = bool(lvl_node.get_meta("CanMove"))
		if lvl_node.has_meta("CanRotVert"):
			can_rot_vert = bool(lvl_node.get_meta("CanRotVert"))

	var lines:Array[String] = []
	lines.append("Controls:")
	lines.append("- Left click drag: rotate")
	lines.append("- Right click drag: precise rotate")
	if model_count > 1:
		lines.append("- Mouse wheel down: next model")

	if can_rot_vert:
		lines.append("- Mouse wheel up / Ctrl: change axis")

	if can_move:
		lines.append("- Shift + click drag: move object")

	return "\n".join(lines)

func _update_object_rows(selected_index:int) -> void:
	var rows:Array[HBoxContainer] = [_obj_row_1, _obj_row_2, _obj_row_3]
	var names:Array[Label] = [_obj_name_1, _obj_name_2, _obj_name_3]
	var bars:Array[ProgressBar] = [_obj_bar_1, _obj_bar_2, _obj_bar_3]
	var values:Array[Label] = [_obj_value_1, _obj_value_2, _obj_value_3]

	for i in range(MAX_OBJECT_ROWS):
		var row:HBoxContainer = rows[i]
		var name_label:Label = names[i]
		var bar:ProgressBar = bars[i]
		var value_label:Label = values[i]

		if i >= G.all_percent.size():
			row.visible = false
			name_label.text = "Object %d" % (i + 1)
			bar.value = 0.0
			value_label.text = "--"
			row.modulate = Color(0.45, 0.45, 0.45, 1.0)
			continue

		row.visible = true

		var percent:int = G.all_percent[i]
		name_label.text = "Object %d" % (i + 1)

		bar.value = clampf(percent, 0.0, 100.0)
		value_label.text = "%d%%" % percent

		if i == selected_index:
			row.modulate = Color(1.0, 1.0, 1.0, 1.0)
		else:
			row.modulate = Color(0.85, 0.85, 0.85, 1.0)
