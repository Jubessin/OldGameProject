extends AudioStreamPlayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_tree().paused:
		if $".".volume_db > -27:
			volume_db -= 0.1
	if not get_tree().paused:
		if $".".volume_db < -17:
			volume_db += 0.1 
