extends Control

var _buttons: Array[Button] = []
var _play_button: Button = null
var _return_button: Button = null

const SELECTED_COLOR: Color = Color.WHITE
const NORMAL_COLOR: Color = Color(0.82, 0.82, 0.82, 1.0)
const DISABLED_COLOR: Color = Color(0.35, 0.35, 0.35, 1.0)
const BORDER_WIDTH: int = 6
const BORDER_COLOR: Color = Color.WHITE
const PADDING: int = 10

func _ready() -> void:
	var grid = $PanelContainer/HBoxContainer/GridContainer
	for i in range(1, 10):
		var button = grid.get_node("Lvl%d" % i) as Button
		if button:
			_buttons.append(button)
			button.pressed.connect(_on_level_pressed.bind(i - 1))
	
	_play_button = $PanelContainer/HBoxContainer/Play as Button
	if _play_button:
		_play_button.pressed.connect(_on_play_pressed)
	
	_return_button = $"PanelContainer/HBoxContainer/Return to main" as Button
	if _return_button:
		_return_button.pressed.connect(_on_return_to_main_pressed)
	
	_apply_button_styles()
	_update_buttons()

func _process(_delta:float) -> void:
	_update_buttons()

func _apply_button_styles() -> void:
	var all_buttons = _buttons.duplicate()
	if _play_button:
		all_buttons.append(_play_button)
	if _return_button:
		all_buttons.append(_return_button)
	
	for button in all_buttons:
		_apply_state_style(button, Color(0.14, 0.14, 0.14, 1.0), Color(0.25, 0.25, 0.25, 1.0), 2)

func _update_buttons() -> void:
	for i in range(_buttons.size()):
		var button = _buttons[i]
		var is_unlocked = i <= G.ProgressLvl or G.sandbox
		var is_selected = i == G.lvl
		
		button.disabled = not is_unlocked
		
		if is_selected and is_unlocked:
			_apply_state_style(button, Color(0.17, 0.17, 0.17, 1.0), BORDER_COLOR, BORDER_WIDTH)
			button.modulate = SELECTED_COLOR
		elif is_unlocked:
			_apply_state_style(button, Color(0.14, 0.14, 0.14, 1.0), Color(0.25, 0.25, 0.25, 1.0), 2)
			button.modulate = NORMAL_COLOR
		else:
			_apply_state_style(button, Color(0.07, 0.07, 0.07, 1.0), Color(0.1, 0.1, 0.1, 1.0), 1)
			button.modulate = DISABLED_COLOR
	
	if _play_button:
		_apply_state_style(_play_button, Color(0.14, 0.14, 0.14, 1.0), Color(0.25, 0.25, 0.25, 1.0), 2)
		_play_button.modulate = NORMAL_COLOR
	if _return_button:
		_apply_state_style(_return_button, Color(0.14, 0.14, 0.14, 1.0), Color(0.25, 0.25, 0.25, 1.0), 2)
		_return_button.modulate = NORMAL_COLOR

func _apply_state_style(button: Button, bg_color: Color, border_color: Color, border_width: int) -> void:
	var style_normal = StyleBoxFlat.new()
	style_normal.border_width_left = border_width
	style_normal.border_width_right = border_width
	style_normal.border_width_top = border_width
	style_normal.border_width_bottom = border_width
	style_normal.border_color = border_color
	style_normal.bg_color = bg_color
	style_normal.set_content_margin_all(PADDING)

	var style_pressed = style_normal.duplicate()
	style_pressed.bg_color = bg_color.darkened(0.2)

	button.add_theme_stylebox_override("normal", style_normal)
	button.add_theme_stylebox_override("hover", style_normal)
	button.add_theme_stylebox_override("pressed", style_pressed)
	button.add_theme_stylebox_override("focus", style_normal)
	button.add_theme_stylebox_override("disabled", style_normal)

func _on_level_pressed(index: int) -> void:
	if not (_is_level_unlocked(index)):
		return
	G.lvl = index

func _is_level_unlocked(index: int) -> bool:
	if G.sandbox:
		return true
	return index <= G.ProgressLvl

func _on_play_pressed() -> void:
	G.gameState = G.INGAME
	$"../../../..".loadLevel(G.lvl)

func _on_return_to_main_pressed() -> void:
	G.gameState = G.MAIN
