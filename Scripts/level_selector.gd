extends Control

var isActive:int = G.MAIN
var _last_progress_lvl: int = -1
var _button_lookup: Dictionary = {}

const LEVEL_BUTTON_NAMES: Array[String] = [
	"Lvl1", "Lvl2", "Lvl3", "Lvl4", "Lvl5", "Lvl6", "Lvl7", "Lvl8", "Lvl9"
]

const HOVER_COLOR: Color = Color(1.12, 1.12, 1.12, 1.0)
const NORMAL_COLOR: Color = Color(1.0, 1.0, 1.0, 1.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_cache_buttons()
	_checkLvlAccess(true)
	_checkGood()

func _process(_delta:float) -> void:
	_checkLvlAccess()
		
func _checkLvlAccess(force: bool = false) -> void:
	if not force and isActive == G.gameState and _last_progress_lvl == G.ProgressLvl:
		return

	isActive = G.gameState
	_last_progress_lvl = G.ProgressLvl

	if G.gameState != G.LVL_SELECTOR:
		return

	for i: int in LEVEL_BUTTON_NAMES.size():
		if _is_level_unlocked(i):
			_enableOne(i)
		else:
			_disableOne(i)

	if not _is_level_unlocked(G.lvl):
		G.lvl = clampi(G.ProgressLvl, 0, LEVEL_BUTTON_NAMES.size() - 1)

	_checkGood()


func _cache_buttons() -> void:
	_button_lookup.clear()
	for i: int in LEVEL_BUTTON_NAMES.size():
		var node_name: String = LEVEL_BUTTON_NAMES[i]
		var button := $PanelContainer/HBoxContainer/GridContainer.get_node_or_null(node_name) as Button
		if button != null:
			_button_lookup[i] = button
			_button_lookup[node_name] = button


func _is_level_unlocked(index: int) -> bool:
	return index <= G.ProgressLvl


func set_button_hover(button_name: String, is_hovered: bool) -> void:
	var button := _button_lookup.get(button_name, null) as Button
	if button == null or button.disabled:
		return

	button.modulate = HOVER_COLOR if is_hovered else NORMAL_COLOR

func _checkGood() -> void:
	for i: int in LEVEL_BUTTON_NAMES.size():
		var button := _button_lookup.get(i, null) as Button
		if button != null:
			button.button_pressed = (i == G.lvl)
			button.modulate = NORMAL_COLOR
		
func _disableOne(i:int) -> void:
	var button := _button_lookup.get(i, null) as Button
	if button != null:
		button.disabled = true
		button.modulate = NORMAL_COLOR

func _enableOne(i:int) -> void:
	var button := _button_lookup.get(i, null) as Button
	if button != null:
		button.disabled = false

func _unCheckAll() -> void:
	for i: int in LEVEL_BUTTON_NAMES.size():
		var button := _button_lookup.get(i, null) as Button
		if button != null:
			button.button_pressed = false
			button.modulate = NORMAL_COLOR
	_checkGood()


func _select_level(index: int) -> void:
	_unCheckAll()
	if not _is_level_unlocked(index):
		return

	G.lvl = index


func _on_lvl_1_pressed() -> void:
	_select_level(0)


func _on_lvl_2_pressed() -> void:
	_select_level(1)


func _on_lvl_3_pressed() -> void:
	_select_level(2)


func _on_lvl_4_pressed() -> void:
	_select_level(3)

func _on_lvl_5_pressed() -> void:
	_select_level(4)

func _on_lvl_6_pressed() -> void:
	_select_level(5)


func _on_lvl_7_pressed() -> void:
	_select_level(6)


func _on_lvl_8_pressed() -> void:
	_select_level(7)


func _on_lvl_9_pressed() -> void:
	_select_level(8)

func _on_play_pressed() -> void:
	G.gameState = G.INGAME


func _on_return_to_main_pressed() -> void:
	G.gameState = G.MAIN
