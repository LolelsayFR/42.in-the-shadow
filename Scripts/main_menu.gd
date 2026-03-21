# ===============================================================
#  EEEEE    M   M     A     I    L        L        EEEEE    TTTTT
#  E        MM MM    A A    I    L        L        E          T
#  EEEE     M M M   AAAAA   I    L        L        EEEE       T
#  E        M   M   A   A   I    L        L        E          T
#  EEEEE    M   M   A   A   I    LLLLL    LLLLL    EEEEE      T
# ===============================================================
extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _process(_delta:float) -> void:
	if G.ProgressLvl > 0 && $MarginContainer/Hbox/Left/Play_Resume.text != "Resume level : %d " % (G.ProgressLvl + 1):
		$MarginContainer/Hbox/Left/Play_Resume.text = "Resume level : %d " % (G.ProgressLvl + 1)
		$MarginContainer/Hbox/Quit/Reset.visible = true
	elif G.ProgressLvl <= 0 && $MarginContainer/Hbox/Left/Play_Resume.text != "Play ":
		$MarginContainer/Hbox/Left/Play_Resume.text = "Play "
		$MarginContainer/Hbox/Quit/Reset.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_quit_pressed() -> void:
	G.gameState = G.QUIT


func _on_play_resume_pressed() -> void:
	G.sandbox = false
	G.gameState = G.INGAME
	G.lvl = G.ProgressLvl
	if G.main != null:
		G.main.loadLevel(G.lvl)


func _on_settings_pressed() -> void:
	G.sandbox = false
	G.gameState = G.SETTINGS


func _on_level_selector_pressed() -> void:
	G.sandbox = false
	G.gameState = G.LVL_SELECTOR


func _on_sandbox_pressed() -> void:
	G.sandbox = true
	G.gameState = G.LVL_SELECTOR


func _on_reset_pressed() -> void:
	G.ProgressLvl = 0
	G.writeData()
