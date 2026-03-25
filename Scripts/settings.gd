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
	
	setSettingsVisualValue()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		_on_undobutton_pressed()
		_on_close_button_pressed()

func _on_close_button_pressed() -> void:
	G.play_ui_click()
	visible = false
	G.writeData()
	if G.gameState == G.INGAME_SETTINGS:
		G.gameState = G.PAUSE
	elif G.gameState == G.SETTINGS:
		G.gameState = G.MAIN

func setSettingsVisualValue() -> void:
	$MarginContainer/PanelContainer/MarginContainer/Left/MasterVolumeOption2/MasterOther.value = G.MasterVol * 100.0
	$MarginContainer/PanelContainer/MarginContainer/Left/SongVolumeOption/VolumeSong.value = G.MusicVol * 100.0
	$MarginContainer/PanelContainer/MarginContainer/Left/OtherVolumeOption/VolumeOther.value = G.SoundVol * 100.0
	$MarginContainer/PanelContainer/MarginContainer/Left/other/ax/ViewAxis2.button_pressed = G.ViewAxis
	$MarginContainer/PanelContainer/MarginContainer/Left/other/ez/Ezmod.button_pressed = G.ezmode
	$MarginContainer/PanelContainer/MarginContainer/Left/QualityOption/Quality.selected = G.Quality
	$MarginContainer/PanelContainer/MarginContainer/Left/ScreenOption/Resolution.selected = G.Resolution
	
func on_open_button_pressed() -> void:
	G.gameState = G.SETTINGS
	setSettingsVisualValue()

func _on_reset_button_pressed() -> void:
	G.play_ui_click()
	G.Quality = G.defaultQuality
	G.Resolution = G.defaultResolution
	G.MasterVol = G.defaultMasterVol
	G.SoundVol = G.defaultSoundVol
	G.MusicVol = G.defaultMusicVol
	G.ViewAxis = G.defaultViewAxis
	G.ezmode = G.defaultEzmode
	setSettingsVisualValue()


func _on_volume_other_value_changed(value: float) -> void:
	G.SoundVol = value / 100


func _on_volume_song_value_changed(value: float) -> void:
	G.MusicVol = value / 100


func _on_master_other_value_changed(value: float) -> void:
	G.MasterVol = value / 100


func _on_view_axis_toggled(toggled_on: bool) -> void:
	G.ViewAxis = toggled_on

func _on_undobutton_pressed() -> void:
	G.play_ui_click()
	G.readData()
	setSettingsVisualValue()


func _on_resolution_item_selected(index: int) -> void:
	G.Resolution = index


func _on_quality_item_selected(index: int) -> void:
	G.Quality = index


func _on_ezmod_toggled(toggled_on: bool) -> void:
	G.ezmode = toggled_on
