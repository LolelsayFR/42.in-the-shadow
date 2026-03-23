# ===============================================================
#  EEEEE    M   M     A     I    L        L        EEEEE    TTTTT
#  E        MM MM    A A    I    L        L        E          T
#  EEEE     M M M   AAAAA   I    L        L        EEEE       T
#  E        M   M   A   A   I    L        L        E          T
#  EEEEE    M   M   A   A   I    LLLLL    LLLLL    EEEEE      T
# ===============================================================
extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. '_delta' is the elapsed time since the previous frame.
func _process(__delta: float) -> void:
	if $Blur/Left/TitlePage.text != "Level %d complete !" % G.lvl:
		$Blur/Left/TitlePage.text = "Level %d complete !" % G.lvl
	if G.sandbox && $Blur/Left/buttons/Play_Resume.text != "Return to selection ":
		$Blur/Left/buttons/Play_Resume.text = "Return to selection "
	elif not G.sandbox && $Blur/Left/buttons/Play_Resume.text != "Retry " && G.ProgressLvl >= G.maxLvl - 1:
		$Blur/Left/buttons/Play_Resume.text = "Retry "
	elif not G.sandbox && $Blur/Left/buttons/Play_Resume.text != "Next level " && G.ProgressLvl < G.maxLvl - 1:
		$Blur/Left/buttons/Play_Resume.text = "Next level "
	if G.gameState == G.INGAME_WIN && visible == false:
		visible = true
		if G.ProgressLvl == G.lvl && G.sandbox == false:
			if G.ProgressLvl < G.maxLvl - 1:
				G.ProgressLvl = G.lvl + 1
			G.writeData()
	if G.gameState != G.INGAME_WIN && visible != false:
		visible = false


func _on_play_resume_pressed() -> void:
	if not G.sandbox:
		if G.lvl < G.ProgressLvl:
			G.lvl += 1
		G.gameState = G.INGAME
		if G.main != null:
			G.main.loadLevel(G.lvl)
	else: 
		G.gameState = G.LVL_SELECTOR


func _on_main_pressed() -> void:
	G.gameState = G.MAIN


func _on_quit_pressed() -> void:
	G.gameState = G.QUIT
