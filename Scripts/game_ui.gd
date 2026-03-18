extends Control
var total:float = 0
var active:float = 0
var bar_size:float = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. '_delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$"PanelContainer/BoxContainer/Percent _".text = "Percent : %d%%" % G.percent
	$"PanelContainer/BoxContainer/Percent _2".text = "Total percent : %d%%" % G.total_percent
	$PanelContainer/BoxContainer/Rot.text = "Rot Mode : %s" % G.rotMod
	pass
