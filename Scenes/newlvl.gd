extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


var factor:int = 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if G.notifyNewLvl && G.gameState == G.MAIN:
		$PanelContainer/Blur/Left/TitlePage.text = "Level %d unlocked" % (G.ProgressLvl + 1)
		visible = true
		G.lvl = G.ProgressLvl
		G.notifyNewLvl = false
	$PanelContainer/Blur/Left/TitlePage.position.y = clamp((delta * factor) * 40 + $PanelContainer/Blur/Left/TitlePage.position.y, -10, 10)
	if $PanelContainer/Blur/Left/TitlePage.position.y >= 10:
		factor = -1
	if $PanelContainer/Blur/Left/TitlePage.position.y <= -10:
		factor = 1
	pass


func _on_play_resume_pressed() -> void:
	visible = false
	G.lvl = 0
	pass # Replace with function body.
