extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_close_button_pressed() -> void:
	visible = false
	if G.gameState == G.INGAME_SETTINGS:
		G.gameState = G.PAUSE
	elif G.gameState == G.SETTINGS:
		G.gameState = G.MAIN
	pass # Replace with function body.

func on_open_button_pressed() -> void:
	visible = true
	if G.gameState == G.PAUSE:
		G.gameState = G.INGAME_SETTINGS
	elif G.gameState == G.MAIN:
		G.gameState = G.SETTINGS
	pass # Replace with function body.
