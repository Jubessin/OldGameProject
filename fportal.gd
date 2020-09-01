extends AnimatedSprite3D

var timer = 0
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += 1
	if timer == 100:
		queue_free()
