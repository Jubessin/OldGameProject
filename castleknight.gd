extends KinematicBody

#State variables
var is_attacking = false
var can_attack = false
var attack_timer = 34
var see_player = false
var has_seen = false
var sword_sound = true
var obj_in_rad = []
var has_seen_timeout = 0
var hass_start = false

var seen_timer = 0

#Motion Variables
const CHASE_SPEED = 370

var speed
var velocity = Vector3()
var gravity = -9.8 * 4

func _ready():
	pass
	
func unsheathe():
	if sword_sound == true:
		$sword.play(0.0)
		sword_sound = false
	

func _physics_process(delta):
	speed = CHASE_SPEED
	if !$GroundRay.is_colliding():
		move_and_slide(velocity) 
	var vec_to_player = Vector3(get_parent().get_child(1).translation.x, get_parent().get_child(1).translation.y - 0.5, get_parent().get_child(1).translation.z) - translation
	vec_to_player = vec_to_player.normalized()
	if see_player == false:
		$RayCast.rotation_degrees.y += 1
		$SkyRay.rotation_degrees.z += 1
		$RayCast2.rotation_degrees.y -= 1
	var n = $RayCast.get_collider()
	var m = $RayCast2.get_collider()
	var o = $SkyRay.get_collider()
#		if ($RayCast.is_colliding() and $RayCast.get_collider().name != "Player") and ($RayCast2.is_colliding() and $RayCast2.get_collider().name != "Player") and ($SkyRay.is_colliding() and $SkyRay.get_collider().name != "Player"):
#			see_player = false
#		
	if ($RayCast.is_colliding() and !n.is_in_group("persistent")) and ($RayCast2.is_colliding() and !m.is_in_group("persistent")) and ($SkyRay.is_colliding() and !o.is_in_group("persistent")):
		see_player = false
	if $RayCast.is_colliding() == false and $RayCast2.is_colliding() == false and $SkyRay.is_colliding() == false:
		see_player = false
#		
	if ($RayCast.is_colliding() and n.is_in_group("persistent")) or ($RayCast2.is_colliding() and m.is_in_group("persistent")) or ($SkyRay.is_colliding() and o.is_in_group("persistent")):
		see_player = true
	else:
		see_player = false 
	if see_player:
		unsheathe()
		has_seen = true
		hass_start = true
		has_seen_timeout = 0

	if has_seen:
		move_and_slide(vec_to_player * speed * delta)

	
	if is_attacking:
		attack_timer += 1
		if attack_timer >= 35:
			can_attack = true
			attack_timer = 0
		else:
			can_attack = false
	if is_attacking != true or obj_in_rad.empty():
		$AnimatedSprite3D.play("forward")
	velocity.y += gravity * delta
	for i in obj_in_rad:
		is_attacking = true
		if can_attack:
			i.lose_health(rand_range(10.0, 65.0))
			$AnimatedSprite3D.play("attack")


func _on_HitBox_body_exited(body):
	if obj_in_rad.has(body):
		obj_in_rad.clear()
		


func _on_HitBox_body_entered(body):
	if "CPlayer" in body.name:
		see_player = true
		obj_in_rad.append(body)

