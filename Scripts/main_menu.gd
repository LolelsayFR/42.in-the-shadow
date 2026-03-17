extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(_delta:float) -> void:
	if $MarginContainer/Hbox/Left/Play_Resume.text.find("Play") && G.ProgressLvl > 1:
		$MarginContainer/Hbox/Left/Play_Resume.text = "Resume "

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_quit_pressed() -> void:
	G.gameState = G.QUIT
	pass # Replace with function body.


func _on_play_resume_pressed() -> void:
	G.gameState = G.INGAME
	G.lvl = G.ProgressLvl
	$"..".loadLevel(G.lvl)
	pass # Replace with function body.


func _on_settings_pressed() -> void:
	G.gameState = G.SETTINGS
	pass # Replace with function body.


func _on_level_selector_pressed() -> void:
	G.gameState = G.LVL_SELECTOR
	pass # Replace with function body.
