extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if G.gameState != G.INGAME && visible:
		visible = false
	if G.gameState == G.INGAME && not visible:
		visible = true
	pass
