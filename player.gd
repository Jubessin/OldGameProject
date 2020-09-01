extends KinematicBody
var camera_angle = 0
var mouse_sensitivity = 0.3
var velocity = Vector3()
var direction = Vector3()
var is_shooting = false
var is_reloading = false
var shoottimer = 0
var reloadtimer = 0
const JUMP_SPEED = 20
const JUMP_ACCEL =  3
var jump_height = 15
const MAX_SPEED = 18
const MAX_RUN_SPEED = 30
var gravity = -9.8 * 4
const ACCEL = 2
const DECEL = 6
var has_contact = false
const MAX_SLOPE_ANGLE = 45
var spare_ammo = 48
var health = 500
var chance_dodge
const BULLET = preload("res://bullet.tscn")
var health_delay = 100
func _ready():
	update_ammo_counts()
	update_health()

func reload():
	if (Input.is_action_pressed("reload") and not Input.is_action_pressed("sprint") and not Input.is_action_just_pressed("shoot")) and (is_on_floor() or $RayCast.is_colliding()):
		if $ProgressBar.value < 12 and spare_ammo > 0:
			is_reloading = true
			$head/Camera/AnimatedSprite3D.play("reload")
			var difference = (12 - $ProgressBar.value)
			$ProgressBar.value += spare_ammo
			spare_ammo -= difference
			update_ammo_counts()
func lose_health():
	randomize()
	chance_dodge = randi()%100
	if chance_dodge > 82:
		health = health
		chance_dodge = 0
	else:
		health -= rand_range(50.0, 100.0)
	health_delay = 0

func lose_more_health():
	randomize()
	chance_dodge = randi()%100
	if chance_dodge > 92:
		health = health
		chance_dodge = 0
	else:
		health -= rand_range(200.0, 300.0)
	health_delay = 0
func update_health():
	if get_slide_count() > 0:
		for i in range(get_slide_count()):
			if "GridMap" in get_slide_collision(i).collider.name and health_delay > 100:
				lose_health()
			if "Boss" in get_slide_collision(i).collider.name and health_delay > 100:
				lose_more_health()

func update_ammo_counts():
	$RichTextLabel.clear()
	$RichTextLabel.add_text(String($ProgressBar.value))
	$RichTextLabel.add_text("\n 	/")
	if spare_ammo > 0:
		$RichTextLabel.add_text("\n\n		" + String(spare_ammo))
	if spare_ammo < 0:
		$RichTextLabel.add_text("\n\n		0")

func _input(event):
	if event is InputEventMouseMotion:
		$head.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		var change = -event.relative.y * mouse_sensitivity
		if change + camera_angle < 90 and change + camera_angle > -90:
			$head/Camera.rotate_x(deg2rad(change))
			camera_angle += change

func _physics_process(delta):
	walk(delta)
	reload()
	update_health()
	$healthbar.health_value = health
	if health_delay < 105:
		health_delay += 1
	if is_shooting == false and is_reloading == false:
		$head/Camera/AnimatedSprite3D.play("standing")
	if is_shooting == true:
		shoottimer += 1
	if shoottimer == 30:
		is_shooting = false
		shoottimer = 0
	if is_reloading == true and is_shooting == false:
		$head/Camera/AnimatedSprite3D.play("reload")
		reloadtimer += 1
	if reloadtimer == 20:
		is_reloading = false
		reloadtimer = 0
func walk(delta):
	var x = $head.get_global_transform().basis.x
	direction = Vector3()

	var temp_velocity = velocity
	temp_velocity.y = 0

	var speed
	var aim = $head/Camera.get_global_transform().basis
	if Input.is_action_pressed("sprint") and Input.is_action_pressed("forward"):
		speed = MAX_RUN_SPEED
		direction -= aim.z
	else:
		speed = MAX_SPEED
	var acceleration
	if direction.dot(temp_velocity) > 0:
		acceleration = ACCEL
	else:
		acceleration = DECEL
	if Input.is_action_pressed("forward") and not Input.is_action_pressed("sprint"):
		direction -= aim.z
	if Input.is_action_pressed("backwards"):
		direction += aim.z
	if Input.is_action_pressed("left"):
		direction -= aim.x
	if Input.is_action_pressed("right"):
		direction += aim.x
	if Input.is_action_just_pressed("shoot") and not Input.is_action_pressed("sprint"):
		if $ProgressBar.value > 0:
			is_shooting = true
			if shoottimer < 30:
				$head/Camera/AnimatedSprite3D.play("shoot")
			$ProgressBar.value -= 1
			var bullet = BULLET.instance()
			bullet.global_transform = $head/Camera/Position3D.get_global_transform()
			bullet.set_rotation($head.rotation.x)
			get_parent().add_child(bullet)


	direction.y = 0
	direction = direction.normalized()

	if Input.is_action_just_pressed("jump") and has_contact:
		velocity.y = jump_height
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

func _on_ProgressBar_value_changed(value):
	update_ammo_counts()
