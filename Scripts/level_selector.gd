# ===============================================================
#  EEEEE    M   M     A     I    L        L        EEEEE    TTTTT
#  E        MM MM    A A    I    L        L        E          T
#  EEEE     M M M   AAAAA   I    L        L        EEEE       T
#  E        M   M   A   A   I    L        L        E          T
#  EEEEE    M   M   A   A   I    LLLLL    LLLLL    EEEEE      T
# ===============================================================
extends Control

# Style resources loaded from Materials folder
@export var _style_button:StyleBoxFlat = null
@export var _style_button_selected:StyleBoxFlat = null
@export var _style_button_disabled:StyleBoxFlat = null
@export var _style_button_pressed:StyleBoxFlat = null

var _buttons:Array[Button] = []
var _play_button:Button = null
var _return_button:Button = null

var _last_lvl:int = -1
var _last_progress:int = -1
var _last_sandbox:bool = false
var _needs_update:bool = false

const SELECTED_COLOR:Color = Color.WHITE
const NORMAL_COLOR:Color = Color(0.82, 0.82, 0.82, 1.0)
const DISABLED_COLOR:Color = Color(0.35, 0.35, 0.35, 1.0)

func _ready() -> void:
	# Load style resources from Materials folder
	_style_button = load("res://Materials/button.tres")
	_style_button_selected = load("res://Materials/button_selected.tres")
	_style_button_disabled = load("res://Materials/button_disabled.tres")
	_style_button_pressed = load("res://Materials/button_pressed.tres")
	_buttons.clear()
	
	var grid:GridContainer = $PanelContainer/HBoxContainer/GridContainer
	if grid == null:
		return
	for i in range(1, 10):
		var button:Button = grid.get_node("Lvl%d" % i) as Button
		if button:
			_buttons.append(button)
			var level_pressed_cb:Callable = Callable(self, "_on_level_pressed").bind(i - 1)
			if not button.pressed.is_connected(level_pressed_cb):
				button.pressed.connect(level_pressed_cb)
	
	_play_button = $PanelContainer/HBoxContainer/Play as Button
	if _play_button:
		var play_pressed_cb:Callable = Callable(self, "_on_play_pressed")
		if not _play_button.pressed.is_connected(play_pressed_cb):
			_play_button.pressed.connect(play_pressed_cb)
	
	_return_button = $"PanelContainer/HBoxContainer/Return to main" as Button
	if _return_button:
		var return_pressed_cb:Callable = Callable(self, "_on_return_to_main_pressed")
		if not _return_button.pressed.is_connected(return_pressed_cb):
			_return_button.pressed.connect(return_pressed_cb)
	
	_needs_update = true
	_apply_button_styles()
	_update_buttons()

func _process(_delta:float) -> void:
	# Only update if game state changed
	if _last_lvl != G.lvl or _last_progress != G.ProgressLvl or _last_sandbox != G.sandbox:
		_needs_update = true
		_last_lvl = G.lvl
		_last_progress = G.ProgressLvl
		_last_sandbox = G.sandbox
	
	if _needs_update:
		_update_buttons()
		_needs_update = false

func _apply_button_styles() -> void:
	var all_buttons:Array[Button] = _buttons.duplicate()
	if _play_button:
		all_buttons.append(_play_button)
	if _return_button:
		all_buttons.append(_return_button)
	
	for button in all_buttons:
		_apply_button_theme(button)

func _update_buttons() -> void:
	for i in range(_buttons.size()):
		var button:Button = _buttons[i]
		var is_unlocked:bool = i <= G.ProgressLvl or G.sandbox
		var is_selected:bool = i == G.lvl
		
		button.disabled = not is_unlocked
		
		if is_selected and is_unlocked:
			button.add_theme_stylebox_override("normal", _style_button_selected)
			button.add_theme_stylebox_override("hover", _style_button_selected)
			button.add_theme_stylebox_override("pressed", _style_button_pressed)
			button.add_theme_stylebox_override("focus", _style_button_selected)
			button.add_theme_stylebox_override("disabled", _style_button_selected)
			button.modulate = SELECTED_COLOR
		elif is_unlocked:
			button.add_theme_stylebox_override("normal", _style_button)
			button.add_theme_stylebox_override("hover", _style_button)
			button.add_theme_stylebox_override("pressed", _style_button_pressed)
			button.add_theme_stylebox_override("focus", _style_button)
			button.add_theme_stylebox_override("disabled", _style_button)
			button.modulate = NORMAL_COLOR
		else:
			button.add_theme_stylebox_override("normal", _style_button_disabled)
			button.add_theme_stylebox_override("hover", _style_button_disabled)
			button.add_theme_stylebox_override("pressed", _style_button_pressed)
			button.add_theme_stylebox_override("focus", _style_button_disabled)
			button.add_theme_stylebox_override("disabled", _style_button_disabled)
			button.modulate = DISABLED_COLOR
	
	if _play_button:
		_apply_button_theme(_play_button)
		_play_button.modulate = NORMAL_COLOR
	if _return_button:
		_apply_button_theme(_return_button)
		_return_button.modulate = NORMAL_COLOR

func _apply_button_theme(button:Button) -> void:
	button.add_theme_stylebox_override("normal", _style_button)
	button.add_theme_stylebox_override("hover", _style_button)
	button.add_theme_stylebox_override("pressed", _style_button_pressed)
	button.add_theme_stylebox_override("focus", _style_button)
	button.add_theme_stylebox_override("disabled", _style_button)

func _on_level_pressed(index:int) -> void:
	if not (_is_level_unlocked(index)):
		return
	G.lvl = index

func _is_level_unlocked(index: int) -> bool:
	if G.sandbox:
		return true
	return index <= G.ProgressLvl

func _on_play_pressed() -> void:
	G.gameState = G.INGAME
	if G.main != null:
		G.main.loadLevel(G.lvl)

func _on_return_to_main_pressed() -> void:
	G.gameState = G.MAIN
