extends Control
var total:float = 0
var active:float = 0
var bar_size:float = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$MarginContainer/VBoxContainer/ActiveBar.custom_minimum_size.x = bar_size * active
	$MarginContainer/VBoxContainer/TotalBar.custom_minimum_size.x = bar_size * total
