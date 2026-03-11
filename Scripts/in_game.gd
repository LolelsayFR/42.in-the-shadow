extends Node3D

var go:Node3D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not is_node_ready():
		await ready
	go = $GameObjects
	pass # Replace with function body.


var localQuality:int = -1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if localQuality != G.Quality:
		localQuality = G.Quality
		if localQuality <= G.QUALITY.FULL:
			$Stand.visible = true
			$Plane.visible = false
			$World.visible = true
			pass
		if localQuality <= G.QUALITY.MID:
			pass
		if localQuality == G.QUALITY.POTATO:
			$Stand.visible = false
			$Plane.visible = true
			$World.visible = false
	$Label3D.text = "Percent : %d%%" % go.get_meta("percent")
	$Label3D2.text = "Total percent : %d%%" % go.get_meta("totalPercent")
	$Label3D3.text = "Rot Mode : %s" % G.rotMod
	$GameUi.active =  float(go.get_meta("percent")) / 100
	$GameUi.total = float(go.get_meta("totalPercent")) / 100
	pass


func getGameObject() -> Node3D:
	return $GameObjects
