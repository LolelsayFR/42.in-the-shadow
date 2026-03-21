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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_play_resume_pressed() -> void:
	visible = false
	G.gameState = G.INGAME


func _on_settings_pressed() -> void:
	$"../Settings".on_open_button_pressed()
	G.gameState = G.INGAME_SETTINGS


func _on_main_pressed() -> void:
	G.gameState = G.MAIN
