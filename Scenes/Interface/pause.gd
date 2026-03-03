extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_resume_pressed() -> void:
	visible = false
	G.gameState = G.INGAME
	pass # Replace with function body.


func _on_settings_pressed() -> void:
	$"../Settings".on_open_button_pressed()
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
