extends KinematicBody

# Player mechanics
var camera_angle = 0
var mouse_sensitivity = 0.3

# is_doing something variables

var is_dead = false
var is_moving = false
var in_cutscene = true

# timer variables

var health_delay = 100
var death_timer = 0
var heartbeat_timer = 0

# Motion Variables
const JUMP_SPEED = 8
const JUMP_ACCEL =  3
var jump_height = 9
const MAX_SPEED = 12

#Speed change based on eqp
var unfound_weapons = ["Launcher", "Smg", "Shotgun", "Pistol", "Rifle"]
var gravity = -9.8 * 4
const ACCEL = 2
const DECEL = 6
var has_contact = false
const MAX_SLOPE_ANGLE = 45
var velocity = Vector3()
var direction = Vector3()
var speed = 0
# Status variables
var health = 500
var delay_start = false
onready var staminabar = $staminabar
var hb_start = false
var hand
var MAX_STAIR_ANGLE = 40
var STAIR_JUMP_HEIGHT = 5
var cutscene
var scene_start = 0
var c1 = false
var in_pos = false
var in_pos2 = false
func _ready():
	save()
	$"/root/savedfiles".save_game()
	cutscene = "jail"

func open_treasure(item):
	if item == "Launcher":
		pick_up("Launcher")
	$head/Camera/Hand.visible = true
		
	
func lose_health(amount):
	health -= amount
	$head/Camera/Particles2D.emitting = true
	health_delay = 0
	if health < 200:
		if !$AudioStreamPlayer.playing:
			hb_start = true
			heartbeat_timer = 0
		if heartbeat_timer < 150 and !$AudioStreamPlayer.playing:
			$AudioStreamPlayer.play(0.0)
		
func lose_more_health(amount):
	health -= amount
	$head/Camera/Particles2D.emitting = true
	health_delay = 0

	if health < 200:
		if !$AudioStreamPlayer.playing:
			hb_start = true
			heartbeat_timer = 0
		if heartbeat_timer < 150 and !$AudioStreamPlayer.playing:
			$AudioStreamPlayer.play(0.0)

func _input(event):
	if is_dead == false and not in_cutscene:
		if event is InputEventMouseMotion:
			$head.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
			var change = -event.relative.y * mouse_sensitivity
			if change + camera_angle < 90 and change + camera_angle > -90:
				$head/Camera.rotate_x(deg2rad(change))
				camera_angle += change
func play_cutscene(cutscene):
	if cutscene == "jail":
		if not ($".".rotation_degrees.y > 0 and $".".rotation_degrees.y < 1):
			$".".rotation_degrees.y += 0.1
		if not ($".".rotation_degrees.z > 0 and $".".rotation_degrees.z < 1):
			$".".rotation_degrees.z += 0.1
		if ($".".rotation_degrees.y > 0 and $".".rotation_degrees.y < 1) and ($".".rotation_degrees.z > 0 and $".".rotation_degrees.z < 1):
			in_cutscene = false
			c1 = true
			scene_start = 0
	if cutscene == "Throneroom":
		in_pos2 = false
		in_pos = false
		if not ($".".translation.x > -164 and $".".translation.x < -163):
			$".".translation.x -= 0.05
		if $".".translation.x > -164 and $".".translation.x < -163:
			in_pos = true
		if not ($".".translation.z > 11.5 and translation.z < 13.5) and in_pos == true:
			$".".translation.z += 0.05
		if $".".translation.z > 9.5 and $".".translation.z < 10.5:
			in_pos2 = true

			
		if in_pos and in_pos2:
			get_parent().char_in_pos = true
func _physics_process(delta):
	hand = $head/Camera/Hand
	print(Global.player_unfound_weps)
	scene_start += 1
	if scene_start > 150 and c1 == false:
		play_cutscene("jail")
	if cutscene == "Throneroom":
		play_cutscene("Throneroom")
	$healthbar.health_value = health
	if health_delay < 105:
		health_delay += 1
	if health_delay > 25:
		$head/Camera/Particles2D.emitting = false
	if health < 1:
		is_dead = true
		dead()
	if !in_cutscene:
		walk(delta)
	if $".".translation.y < -10:
		$head/Camera/CanvasLayer/AnimatedSprite.visible = true
		$head/Camera/CanvasLayer/AnimatedSprite.play("default")
		save()
		savedfiles.save_game()
	if $head/Camera/CanvasLayer/AnimatedSprite.frame == 12:
		$head/Camera/CanvasLayer/AnimatedSprite.play("finish")
		Global.next_map = "cavemap.tscn"
		get_tree().change_scene("loadingscreen.tscn")

func pick_up(item):
	if item == "Launcher":
		unfound_weapons.erase("Launcher")
		Global.player_unfound_weps = unfound_weapons
	
		

func walk(delta):

	var x = $head.get_global_transform().basis.x
	direction = Vector3()
	var temp_velocity = velocity
	temp_velocity.y = 0


	var aim = $head/Camera.get_global_transform().basis
	
	if !Input.is_action_pressed("sprint"):
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
	if $RayCast2.is_colliding() and is_on_floor():
		velocity.y += 3
	velocity = move_and_slide(velocity, Vector3(0, 1, 0))
	$RayCast2.translation.z = direction.z
	$RayCast2.translation.x = direction.x
	if (direction.length() > 0) and ($RayCast2.is_colliding()):
		var stair_normal = $RayCast2.get_collision_normal()
		var stair_angle = rad2deg(acos(stair_normal.dot(Vector3(0, 1, 0))))
		if stair_angle < MAX_STAIR_ANGLE:
			velocity.y = STAIR_JUMP_HEIGHT
			has_contact = false
func dead():

	$head/Camera/Particles2D.emitting = false
	death_timer += 1
	if death_timer < 80:
		$head/Camera.translation.z += 0.2
	if death_timer < 100:
		$head/Camera.translation.y += 0.05
	if death_timer == 400:
		get_tree().change_scene("deathscene.tscn")
	$head.rotate_y(0.01)
	
func save():
	var save_dict = {
		"parent" : get_parent().filename,
		"pos": {
			x = global_transform.origin.x,
			y = global_transform.origin.y,
			z = global_transform.origin.z
		},
		"health" : health,
		"p_spare_ammo" : 0,
		"r_spare_ammo" : 0,
		"eqp" : 0,
		"unfound_weapons" : unfound_weapons,
		"spare_hpots" : 0,
		"spare_spots" : 0,
		"spare_stpots" : 0,
		"spare_grenades" : 0,
		"boss_killed": $"/root/Global".boss_killed
	}
	return save_dict



	
	
	
	
	

func _on_Area5_body_entered(body):
	if "CPlayer" in body.name:
		in_cutscene = true
		cutscene = "Throneroom"
