extends Node3D

var go:Node3D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not is_node_ready():
		await ready
	go = $GameObject
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Label3D.text = "Percent : %d%%" % go.get_meta("percent")
	$Label3D2.text = "Total percent : %d%%" % go.get_meta("totalPercent")
	$Label3D3.text = "Rot Mode : %s" % go.tracked_lvl.rotMdl(0,0, null)
	pass


func getGameObject() -> Node3D:
	return $GameObject
