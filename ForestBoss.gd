extends KinematicBody

#State variables

var aggro_timer = 0
var see_player = false
var has_seen = false
var is_dead = false
var health 
var start_health
var base_health = 9100
var aggroed = false
var is_grabbing = false
var obj_in_rad = []
var grabbed = false
#Timers
var dead_timer = -72
var seen_timer = 0
#Motion Variables
const CHASE_SPEED = 270
const AGGRO_SPEED = 370
const HALF_SPEED = 320
var speed
var velocity = Vector3()
var gravity = -9.8 * 4
var player
var grab_timer = 0
var grabbed_timer = 0
var just_grabbed = false
const GRABBED_TIMEOUT = 100
const GRAB_TIMEOUT = 150
const MOB = preload("res://ForestMob.tscn")

#Item Variables
var item_chance
var item
var chance_miss

func lookout(degree):
	aggro_timer = 0
	if (aggro_timer < 400 or see_player) and degree == 1:
		aggroed = true
		speed = AGGRO_SPEED 
		$RayCast.cast_to.y = -55
		$RayCast2.cast_to.y = 55
		$SkyRay.cast_to.z = 50
		$Area/CollisionShape.scale *= 1.25
		
	if (aggro_timer < 500 or see_player) and degree == 2:
		aggroed = true
		speed = AGGRO_SPEED * 1.1
		$RayCast.cast_to.y = -60
		$RayCast2.cast_to.y = 60
		$SkyRay.cast_to.z = 55
		$Area/CollisionShape.scale *= 1.5
		
	if see_player and degree == 3:
		aggroed = true
		speed = AGGRO_SPEED * 1.25
		$RayCast.cast_to.y = -65
		$RayCast2.cast_to.y = 65
		$SkyRay.cast_to.z = 65
		$Area/CollisionShape.scale *= 2
func _ready():
	start_health = base_health
	see_player = true
	get_parent().boss_health = start_health
	get_parent().boss_base_health = base_health

func grab_anim():
	if $AnimatedSprite3D.animation == "grab":
		grabbed = true
		return
	else:
		if grabbed == false:
			$AnimatedSprite3D.play("grab")
func lose_health(damage):
	randomize()
	start_health -= damage
	if damage == null:
		return
	if start_health > base_health / 2:
		lookout(1)
	if start_health < base_health / 2:
		lookout(2)
		collision_layer = 2
	if start_health < base_health / 4:
		lookout(3)


func dead():
	is_dead = true
	Global.boss_killed = true
	$AnimatedSprite3D.play("dead")
	see_player = false
	if dead_timer == 15:
		for i in obj_in_rad:
			i.lose_more_health(round(rand_range(100, 300)))
		get_parent().block = false
	if dead_timer == 17:
		hide()
		queue_free()
		
func _physics_process(delta):
	if is_dead == false:
		if start_health < base_health / 2:
			speed = HALF_SPEED
		get_parent().boss_health = start_health
		get_parent().boss_base_health = base_health
		var player = get_parent().get_child(1)
		
		aggro_timer += 1
		
		var vec_to_player = Vector3(player.translation.x, player.translation.y + 0.25, player.translation.z) - translation
		vec_to_player = vec_to_player.normalized()
		if see_player == false:
			$RayCast.rotation_degrees.y += 1
			$SkyRay.rotation_degrees.y += 1
			$RayCast2.rotation_degrees.y -= 1
		if ($RayCast.is_colliding() and $RayCast.get_collider().name != "Player") and ($RayCast2.is_colliding() and $RayCast2.get_collider().name != "Player") and ($SkyRay.is_colliding() and $SkyRay.get_collider().name != "Player"):
			see_player = false
		elif $RayCast.is_colliding() == false and $RayCast2.is_colliding() == false and $SkyRay.is_colliding() == false:
			see_player = false
		
		if $RayCast.is_colliding():
			if "Player" in $RayCast.get_collider().name:
				see_player = true
		if $RayCast2.is_colliding():
			if "Player" in $RayCast2.get_collider().name:
				see_player = true
			
		if $SkyRay.is_colliding():
			if "Player" in $SkyRay.get_collider().name:
				see_player = true
		
		if is_grabbing == false:
			grab_timer = 0
			$AnimatedSprite3D.play("walk")
			
		if is_grabbing:
			grab_timer += 1
			
		if grab_timer == GRAB_TIMEOUT:
			grab_timer = 0
			is_grabbing = false
			player.is_grabbed = false
			player.knocked_back = true
			just_grabbed = true
		
		if just_grabbed:
			grabbed_timer += 1
		
		if grabbed_timer >= GRABBED_TIMEOUT:
			just_grabbed = false
			grabbed_timer = 0
			
		if !aggroed:
			speed = CHASE_SPEED 
			
		if see_player:
			has_seen = true

		if has_seen:
			move_and_slide((vec_to_player) * speed * delta)
			
	if obj_in_rad.size() > 0:
		if !just_grabbed:
			
			is_grabbing = true
			grab_anim()
			for i in obj_in_rad:
				i.lose_health(round(rand_range(0.25, 1)))
				i.is_grabbed = true
		
	else:
		is_grabbing = false

	if start_health < 1:
		dead()
		
	if is_dead == true:
		see_player = false
		Global.spawn_boss = false
		$"/root/Global".player_in_battle = false
		dead_timer += 1

func _on_Area_body_entered(body):
	if "Player" in body.name:
		obj_in_rad.append(body)
		
		

		

func _on_Area_body_exited(body):
	if "Player" in body.name:
		body.is_grabbed = false
		obj_in_rad.clear()
		grabbed = false