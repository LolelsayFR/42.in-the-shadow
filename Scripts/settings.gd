extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setSettingsVisualValue()
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

func setSettingsVisualValue() -> void:
	$MarginContainer/PanelContainer/MarginContainer/Left/MasterVolumeOption2/MasterOther.value = G.MasterVol * 100
	$MarginContainer/PanelContainer/MarginContainer/Left/SongVolumeOption/VolumeSong.value = G.MusicVol * 100
	$MarginContainer/PanelContainer/MarginContainer/Left/OtherVolumeOption/VolumeOther.value = G.SoundVol * 100
	$MarginContainer/PanelContainer/MarginContainer/Left/Others/AngleMod/AngleMod.button_pressed = G.AngleMode
	$MarginContainer/PanelContainer/MarginContainer/Left/Others/ViewAxis/ViewAxis.button_pressed = G.ViewAxis
	
func on_open_button_pressed() -> void:
	G.gameState = G.SETTINGS
	setSettingsVisualValue()
	pass # Replace with function body.

func _on_reset_button_pressed() -> void:
	G.Quality = G.defaultQuality
	G.Resolution = G.defaultResolution
	G.MasterVol = G.defaultMasterVol
	G.SoundVol = G.defaultSoundVol
	G.MusicVol = G.defaultMusicVol
	setSettingsVisualValue()
	pass # Replace with function body.


func _on_volume_other_value_changed(value: float) -> void:
	G.SoundVol = value / 100
	pass # Replace with function body.


func _on_volume_song_value_changed(value: float) -> void:
	G.MusicVol = value / 100
	pass # Replace with function body.


func _on_master_other_value_changed(value: float) -> void:
	G.MasterVol = value / 100
	pass # Replace with function body.


func _on_view_axis_toggled(toggled_on: bool) -> void:
	G.ViewAxis = toggled_on
	pass # Replace with function body.


func _on_angle_mod_toggled(toggled_on: bool) -> void:
	G.AngleMode = toggled_on
	pass # Replace with function body.
