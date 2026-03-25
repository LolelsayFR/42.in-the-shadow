extends Label

const baseH:float = 580.0
const hideH:float = 660.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

const tips:Array[String] = [
	"Tips: Try rotating on one axis at a time, small adjustments can change the shadow a lot.",
	"Tips: When you're close, avoid big moves and use tiny rotations to fine-tune.",
	"Note: This game was developed as part of a specialization project at 42 Le Havre.",
	"Tips: Be sure to check out the original game: Shadowmatic",
]
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if G.gameState == G.INGAME && visible == false:
		visible = true
	if G.gameState != G.INGAME && visible == true:
		visible = false
	var i:int = 0
	if $Timer.time_left > 1 && size.y > baseH:
		size.y -= delta * 100
	elif $Timer.time_left < 1 && size.y < hideH:
		size.y += delta * 100
	if size.y >= hideH:
		i += 1
		text = tips[i % tips.size() + 1]
	pass
