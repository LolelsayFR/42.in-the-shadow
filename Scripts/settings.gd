extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	setSettingsVisualValue()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		_on_undobutton_pressed()
		_on_close_button_pressed()
	pass

func _on_close_button_pressed() -> void:
	visible = false
	G.writeData()
	if G.gameState == G.INGAME_SETTINGS:
		G.gameState = G.PAUSE
	elif G.gameState == G.SETTINGS:
		G.gameState = G.MAIN
	pass # Replace with function body.

func setSettingsVisualValue() -> void:
	$MarginContainer/PanelContainer/MarginContainer/Left/MasterVolumeOption2/MasterOther.value = G.MasterVol * 100.0
	$MarginContainer/PanelContainer/MarginContainer/Left/SongVolumeOption/VolumeSong.value = G.MusicVol * 100.0
	$MarginContainer/PanelContainer/MarginContainer/Left/OtherVolumeOption/VolumeOther.value = G.SoundVol * 100.0
	$MarginContainer/PanelContainer/MarginContainer/Left/ViewAxis/ViewAxis.button_pressed = G.ViewAxis
	$MarginContainer/PanelContainer/MarginContainer/Left/QualityOption/Quality.selected = G.Quality
	$MarginContainer/PanelContainer/MarginContainer/Left/ScreenOption/Resolution.selected = G.Resolution
	
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

func _on_undobutton_pressed() -> void:
	G.readCData()
	setSettingsVisualValue()
	pass # Replace with function body.


func _on_resolution_item_selected(index: int) -> void:
	G.Resolution = index
	pass # Replace with function body.


func _on_quality_item_selected(index: int) -> void:
	G.Quality = index
	pass # Replace with function body.
