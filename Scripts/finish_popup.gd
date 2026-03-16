extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if G.gameState == G.INGAME_WIN && visible == false:
		visible = true
		if G.ProgressLvl == G.lvl:
			G.ProgressLvl = G.lvl + 1
	if G.gameState != G.INGAME_WIN && visible != false:
		visible = false
	pass


func _on_play_resume_pressed() -> void:
	pass # Replace with function body.


func _on_main_pressed() -> void:
	pass # Replace with function body.


func _on_settings_pressed() -> void:
	pass # Replace with function body.
