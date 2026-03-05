extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match G.lvl:
		0: $MarginContainer/HBoxContainer/Lvl1.button_pressed = true
		1: $MarginContainer/HBoxContainer/Lvl2.button_pressed = true
		2: $MarginContainer/HBoxContainer/Lvl3.button_pressed = true
		3: $MarginContainer/HBoxContainer/Lvl4.button_pressed = true
		4: $MarginContainer/HBoxContainer/Lvl5.button_pressed = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unCheckAll() -> void:
	$MarginContainer/HBoxContainer/Lvl1.button_pressed = false
	$MarginContainer/HBoxContainer/Lvl2.button_pressed = false
	$MarginContainer/HBoxContainer/Lvl3.button_pressed = false
	$MarginContainer/HBoxContainer/Lvl4.button_pressed = false
	$MarginContainer/HBoxContainer/Lvl5.button_pressed = false


func _on_lvl_1_pressed() -> void:
	G.lvl = 0
	_unCheckAll()
	$MarginContainer/HBoxContainer/Lvl1.button_pressed = true
	pass # Replace with function body.


func _on_lvl_2_pressed() -> void:
	G.lvl = 1
	_unCheckAll()
	$MarginContainer/HBoxContainer/Lvl2.button_pressed = true
	pass # Replace with function body.


func _on_lvl_3_pressed() -> void:
	G.lvl = 2
	_unCheckAll()
	$MarginContainer/HBoxContainer/Lvl3.button_pressed = true
	pass # Replace with function body.


func _on_lvl_4_pressed() -> void:
	G.lvl = 3
	_unCheckAll()
	$MarginContainer/HBoxContainer/Lvl4.button_pressed = true
	pass # Replace with function body.



func _on_lvl_5_pressed() -> void:
	G.lvl = 4
	_unCheckAll()
	$MarginContainer/HBoxContainer/Lvl5.button_pressed = true
	pass # Replace with function body.


func _on_play_pressed() -> void:
	G.gameState = G.INGAME
	pass # Replace with function body.


func _on_return_to_main_pressed() -> void:
	G.gameState = G.MAIN
	pass # Replace with function body.
