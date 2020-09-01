extends KinematicBody
var camera_angle = 0
var mouse_sensitivity = 0.3
var velocity = Vector3()
var direction = Vector3()
const JUMP_SPEED = 20
const JUMP_ACCEL =  3
var jump_height = 15
const MAX_SPEED = 15
const MAX_RUN_SPEED = 30
var gravity = -9.8 * 4
const ACCEL = 2
const DECEL = 6
var has_contact = false
const MAX_SLOPE_ANGLE = 35
func _input(event):
	if event is InputEventMouseMotion:
		$head.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		$RobotArmature/Skeleton.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		var change = event.relative.y * mouse_sensitivity
		if change + camera_angle < 90 and change + camera_angle > - 90:
			$head/Camera.rotate_x(deg2rad(change))
			camera_angle += change

func _physics_process(delta):
	walk(delta)
func walk(delta):
	
	direction = Vector3()
	
	var temp_velocity = velocity
	temp_velocity.y = 0
	
	var speed
	var aim = $head/Camera.get_global_transform().basis
	if Input.is_action_pressed("sprint") and Input.is_action_pressed("forward") and is_on_floor():
		speed = MAX_RUN_SPEED
		direction -= aim.z
		$AnimationPlayer.play("Robot_Running")
	else:
		speed = MAX_SPEED
	var acceleration 
	if direction.dot(temp_velocity) > 0:
		acceleration = ACCEL
	else:
		acceleration = DECEL
	if Input.is_action_pressed("forward") and not Input.is_action_pressed("sprint"):
		direction -= aim.z
		$AnimationPlayer.play("Robot_Walking")
	if Input.is_action_pressed("backwards"):
		direction += aim.z
	if Input.is_action_pressed("left"):
		direction -= aim.x
	if Input.is_action_pressed("right"):
		direction += aim.x
		
	direction.y = 0
	direction = direction.normalized()
	
	if Input.is_action_just_pressed("jump") and has_contact:
		velocity.y = jump_height
		get_parent().get_child(2).play("Robot_Jump")
		has_contact = false
		
	if (is_on_floor()):
		has_contact = true
		var n = $RayCast.get_collision_normal()
		var floor_angle = rad2deg(acos(n.dot(Vector3(0, 1, 0))))
		if floor_angle > MAX_SLOPE_ANGLE:
			velocity.y += gravity * delta
	else:
		if !$RayCast.is_colliding():
			has_contact = false
		velocity.y += gravity * delta
	if (has_contact and !is_on_floor()):
		move_and_collide(Vector3(0, -1, 0))
	var target = direction * speed
	
	temp_velocity = velocity.linear_interpolate(target, acceleration * delta)
	velocity.x = temp_velocity.x
	velocity.z = temp_velocity.z
	velocity = move_and_slide(velocity, Vector3(0, 1, 0))