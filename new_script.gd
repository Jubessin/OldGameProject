extends KinematicBody

var velocity = Vector3()
var gravity = -9.8 * 4
var scratch_or_bite = 0
var is_moving = true
var speed = 1
var animation_timer = 0
var in_motion = false
var is_attacking = false

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.y += gravity * delta
	move_and_slide(velocity)
	velocity.z = 100 * delta