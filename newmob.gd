extends KinematicBody

var velocity = Vector3()
var gravity = -9.8 * 6
var scratch_or_bite = 0
var is_moving = true
var speed = 1
var animation_timer = 0
var in_motion = false
var is_attacking = false
var x = 0
var z = 0
var dir_timer = -1
var forward_dir = 0
var backward_dir = 0
var left_dir = 0
var right_dir = 0
var spin = 0.1
var motion = translate(Vector3(x, 0, z))
func _ready():
	randomize()
	x = rand_range(-10, 10)
	z = rand_range(-10, 10)
	rotation.y = ((x*0.1 + z*0.1)/2) * 270
	
func _physics_process(delta):
	randomize()
	#print(rad2deg(tan(z/x)))
	print(rad2deg(atan2(4,3)))
	rotation_degrees.y = rad2deg(atan2(x * delta, z * delta))
	var roty = int(rotation.y)
	var rdirrot = int(right_dir + 1.3)
	var ldirrot = int(left_dir - 1.3)
	var bdirrot = int(backward_dir + 1.3)
	var fdirrot = int(forward_dir - 1.3)
	dir_timer += 1
	
	if dir_timer > 250:
		x = 3
		z = 4 
		dir_timer = 0
	
	forward_dir = -global_transform.basis.z.x
	backward_dir = global_transform.basis.z.x
	left_dir = global_transform.basis.x.x
	right_dir = -global_transform.basis.x.x
	
	if in_motion == false:
		animation_timer += 1
	if is_attacking == false and animation_timer > 70:
		motion = translate(Vector3(x * delta, 0, z * delta))
		$AnimationPlayer.play("Walk-Cycle (Baked)")
	velocity.y = 0
	velocity.x = 0
	velocity.y += gravity * delta
	move_and_slide(velocity)

func _on_AttackBox_body_entered(body):
	if "Player" in body.name:
		is_attacking = true
		velocity.z = 0
		velocity.x = 0
		animation_timer = 0
		is_moving = true
		randomize()
		scratch_or_bite = randi()% 100
		if scratch_or_bite > 50:
			$AnimationPlayer.play("Attack_Bite (Baked)")
		else:
			$AnimationPlayer.play("Attack_Hit (Baked)")
		is_attacking = false