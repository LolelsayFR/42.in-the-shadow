extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. '_delta' is the elapsed time since the previous frame.
func _process(__delta: float) -> void:
	if G.sandbox && $Blur/Left/buttons/Play_Resume.text != "Return to selection ":
		$Blur/Left/buttons/Play_Resume.text = "Return to selection "
	elif not G.sandbox && $Blur/Left/buttons/Play_Resume.text != "Next level ":
		$Blur/Left/buttons/Play_Resume.text = "Next level "
	if G.gameState == G.INGAME_WIN && visible == false:
		visible = true
		if G.ProgressLvl == G.lvl && G.sandbox == false:
			if G.ProgressLvl < G.maxLvl:
				G.ProgressLvl = G.lvl + 1
			G.writeData()
	if G.gameState != G.INGAME_WIN && visible != false:
		visible = false
	pass


func _on_play_resume_pressed() -> void:
	if not G.sandbox:
		if G.lvl < G.ProgressLvl:
			G.lvl += 1
		G.gameState = G.INGAME
		$"../..".loadLevel(G.lvl)
	else: 
		G.gameState = G.LVL_SELECTOR
	pass # Replace with function body.


func _on_main_pressed() -> void:
	G.gameState = G.MAIN
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	G.gameState = G.QUIT
	pass # Replace with function body.
