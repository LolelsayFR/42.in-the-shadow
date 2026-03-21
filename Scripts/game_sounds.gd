# ===============================================================
#  EEEEE    M   M     A     I    L        L        EEEEE    TTTTT
#  E        MM MM    A A    I    L        L        E          T
#  EEEE     M M M   AAAAA   I    L        L        EEEE       T
#  E        M   M   A   A   I    L        L        E          T
#  EEEEE    M   M   A   A   I    LLLLL    LLLLL    EEEEE      T
# ===============================================================
extends Node

const MUFFLER_PAUSE_TARGET:float = 100.0
const MUFFLER_NORMAL_TARGET:float = 80.0
const MUFFLER_STEP:float = 0.6
const VOLUME_DB_SCALE:float = 80.0

var masterVol:float = 1
var soundVol:float = 1
var musicVol:float = 1
var moveVol:float = 0
var meloVol:float = 0
var kickVol:float = 1
var drumsVol:float = 1
var bassVol:float = 0
var muffler:float = MUFFLER_NORMAL_TARGET

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if G.gameState == G.PAUSE:
		if  muffler < MUFFLER_PAUSE_TARGET:
			muffler += MUFFLER_STEP
	else:
		if  muffler > MUFFLER_NORMAL_TARGET:
			muffler += -MUFFLER_STEP
	if masterVol != G.MasterVol:
		masterVol = G.MasterVol
	if musicVol != G.MusicVol:
		musicVol = G.MusicVol
	if soundVol != G.SoundVol:
		soundVol = G.SoundVol
	_setVolume()

func _setVolume() -> void:
	$"Bass".volume_db = (masterVol * (musicVol * bassVol) * VOLUME_DB_SCALE) - muffler
	$"Drums".volume_db = (masterVol * (musicVol * drumsVol) * VOLUME_DB_SCALE) - muffler
	$"Kick".volume_db = (masterVol * (musicVol * kickVol) * VOLUME_DB_SCALE) - muffler
	$"Melo".volume_db = (masterVol * (musicVol * meloVol) * VOLUME_DB_SCALE) - muffler
	$"Move".volume_db = (masterVol * (soundVol * moveVol) * VOLUME_DB_SCALE) - muffler
