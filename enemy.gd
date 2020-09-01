extends KinematicBody

var velocity = Vector3()
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_slide(velocity)
	velocity.z += 1 * delta
	$AnimatedSprite3D.play("forward")
	$AnimatedSprite3D2.play("forward")

func _on_Area_body_entered(body):
	if "Player" in body.name:
		$AnimatedSprite3D.play("attack")
