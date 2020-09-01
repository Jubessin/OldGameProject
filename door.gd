extends KinematicBody

var door_open = false
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !door_open:
		$CollisionShape.disabled = false
		if not ($rightdoor.translation.x > 0.14 and $rightdoor.translation.x < 0.15):
			$rightdoor.translation.x -= 0.08
		if not ($leftdoor.translation.x > 0.125 and $leftdoor.translation.x < 0.135):
			$leftdoor.translation.x += 0.08
		
	if door_open:
		if not ($leftdoor.translation.x > -1.55 and $leftdoor.translation.x < -1.45):
			$leftdoor.translation.x -= 0.08
		if not ($rightdoor.translation.x > 1.73 and $rightdoor.translation.x < 1.83):
			$rightdoor.translation.x += 0.08
		$CollisionShape.disabled = true

func _on_Area_body_entered(body):
	if "Player" in body.name:
		door_open = true
	if body.is_in_group('mobs'):
		door_open = true

func _on_Area_body_exited(body):
	if "Player" in body.name:
		door_open = false
	if body.is_in_group('mobs'):
		door_open = false
