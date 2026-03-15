extends Control
var total:float = 0
var active:float = 0
var bar_size:float = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse_click") || Input.is_action_just_pressed("mouse_click2") && G.gameState == G.INGAME:
		$"../Circle".scale = Vector2(1.5,1.5)
		$"../Circle".visible = true
		$"../Circle".position = get_viewport().get_mouse_position()
	if !Input.is_action_pressed("mouse_click") && !Input.is_action_pressed("mouse_click2")  && $"../Circle".scale <= Vector2(0.5,0.5):
		$"../Circle".visible = false
	if $"../Circle".scale > Vector2(0.5,0.5):
		$"../Circle".scale -= delta * 10 * Vector2(0.5,0.5)
	if $"../Circle".scale < Vector2(0.5,0.5):
		$"../Circle".scale = Vector2(0.5,0.5)
	if G.gameState != G.INGAME:
		total = 0
		active = 0
	$MarginContainer/VBoxContainer/ActiveBar.custom_minimum_size.x = bar_size * active
	$MarginContainer/VBoxContainer/TotalBar.custom_minimum_size.x = bar_size * total
