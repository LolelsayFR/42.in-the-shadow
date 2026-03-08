extends Node
var masterVol:float = 1
var soundVol:float = 1
var musicVol:float = 1
var moveVol:float = 0
var meloVol:float = 0
var kickVol:float = 1
var drumsVol:float = 1
var bassVol:float = 0
var muffler:float = 80

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if G.gameState == G.PAUSE:
		if  muffler < 100:
			muffler += 0.6
	else:
		if  muffler > 80:
			muffler += -0.6
	if masterVol != G.MasterVol:
		masterVol = G.MasterVol
	if musicVol != G.MusicVol:
		musicVol = G.MusicVol
	if soundVol != G.SoundVol:
		soundVol = G.SoundVol
	_setVolume()
	pass

func _setVolume() -> void:
	$"Bass".volume_db = (masterVol * (musicVol * bassVol) * 80) - muffler
	$"Drums".volume_db = (masterVol * (musicVol * drumsVol) * 80) - muffler
	$"Kick".volume_db = (masterVol * (musicVol * kickVol) * 80) - muffler
	$"Melo".volume_db = (masterVol * (musicVol * meloVol) * 80) - muffler
	$"Move".volume_db = (masterVol * (soundVol * moveVol) * 80) - muffler
