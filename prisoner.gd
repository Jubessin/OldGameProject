extends KinematicBody

#State variables
var see_player = false
var has_seen = false
var obj_in_rad = []
var has_seen_timeout = 0
var hass_start = false

#Timers
var seen_timer = 0
#Motion Variables
const CHASE_SPEED = 300
var speed
var velocity = Vector3()
var gravity = -9.8 * 4

#Item Variables

func _ready():
	pass


func _physics_process(delta):
	var vec_to_player = Vector3(get_parent().get_parent().get_child(1).translation.x, get_parent().get_parent().get_child(1).translation.y - 0.5, get_parent().get_parent().get_child(1).translation.z) - translation
	vec_to_player = vec_to_player.normalized()
	speed = CHASE_SPEED
	if see_player:
		has_seen = true
		hass_start = true
		has_seen_timeout = 0
		
	if hass_start:
		has_seen_timeout += 1
	
	if has_seen and has_seen_timeout < 800:
		move_and_slide(vec_to_player * speed * delta)

	if not obj_in_rad.has("CPlayer"):
		$Animsprite.play("walk")
		translation.x = 10
		translation.z = -14
	if obj_in_rad.has("CPlayer"):
		see_player = true
		if translation.z < -19:
			$Animsprite.play("attack")
	velocity.y += gravity * delta
	
		


func _on_Area_body_entered(body):
	if "CPlayer" in body.name:
		obj_in_rad.append(body.name)
