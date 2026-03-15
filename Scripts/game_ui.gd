extends Control
var total:float = 0
var active:float = 0
var bar_size:float = 200
var totalPercent:int = 0
var percent:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$"PanelContainer/BoxContainer/Percent _".text = "Percent : %d%%" % percent
	$"PanelContainer/BoxContainer/Percent _2".text = "Total percent : %d%%" % totalPercent
	$PanelContainer/BoxContainer/Rot.text = "Rot Mode : %s" % G.rotMod
	pass
