extends KinematicBody

var open_door = false
var obj_in_rad = []
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if obj_in_rad.has("Guard1") or obj_in_rad.has("CPlayer"):
		open_door = true
	if open_door:
		if not (translation.x > -13 and translation.x < -12):
			translation.x += 0.05


func _on_Area_body_entered(body):
	obj_in_rad.append(body.name)
	
