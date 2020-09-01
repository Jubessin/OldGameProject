extends KinematicBody

#State variables
var is_attacking = false
var aggro_timer = 0
var see_player = false
var has_seen = false
var is_dead = false
var health 
var start_health
var base_health = 3400
var aggroed = false

#Timers
var dead_timer = -72
var seen_timer = 0
#Motion Variables
const CHASE_SPEED = 160
const AGGRO_SPEED = 290
const LASER = preload("res://Laserspawn.tscn")
var speed
var velocity = Vector3()
var gravity = -9.8 * 4
var player
var attack_delay = 0
#Item Variables
var item_chance
var item
var chance_miss

func lookout(degree):
	aggro_timer = 0
	if aggro_timer < 400 or see_player and degree == 1:
		aggroed = true
		speed = AGGRO_SPEED 
		$RayCast.cast_to.y = -55
		$RayCast2.cast_to.y = 55
		$SkyRay.cast_to.z = 50
		$Area/CollisionShape.scale *= 1.25
		
	if aggro_timer < 500 or see_player and degree == 2:
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
	$footsteps.play(0.0)
	see_player = true

		
func lose_health(damage):
	randomize()
	start_health -= damage
	if damage == null:
		return
	if start_health > base_health / 2:
		lookout(1)
	if start_health < base_health / 2:
		lookout(2)
	if start_health < base_health / 4:
		lookout(3)
		
func shoot_player():
	randomize()
	player = get_parent().get_child(1)
	$AnimatedSprite3D.play("shoot")
	$Laser.play(0.0)
	$roar.play(0.0)
	#var laser = LASER.instance()
	# you get the position of the player
	#var player_origin = get_parent().get_child(1).get_global_transform().origin

# you get the position of the enemy
	#var enemy_origin = .get_global_transform().origin
	#laser.translation = ((($".".translation - player.translation) / 2 ) + player.translation)
	#laser.set_rotation($Player.rotation.x)
	#laser.player_origin = player_origin
	#laser.enemy_origin = enemy_origin
	#get_parent().add_child(laser)
	chance_miss = round(randi()%100)
	if chance_miss < 65:
		player.lose_health(round(rand_range(50, 200)))

func dead():
	is_dead = true
	var lasergun = LASER.instance()
	lasergun.global_transform = self.global_transform
	Global.boss_killed = true
	$AnimatedSprite3D.play("dead")
	see_player = false
	if dead_timer == 15:
		get_parent().add_child(lasergun)
	if dead_timer == 20:
		hide()
		queue_free()
		
func _physics_process(delta):
	if is_dead == false:
		var player = get_parent().get_child(1)
		
		aggro_timer += 1
		if !$groundray.is_colliding():
			move_and_slide(velocity) 
		var vec_to_player = Vector3(get_parent().get_child(1).translation.x, get_parent().get_child(1).translation.y - 0.5, get_parent().get_child(1).translation.z) - translation
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
		
		if see_player == false:
			is_attacking = false
			$AnimatedSprite3D.play("walk")
		if !aggroed:
			speed = CHASE_SPEED 
		if see_player:
			$Player.cast_to = player.get_child(1).translation
			has_seen = true
			move_and_slide((vec_to_player / 2) * speed * delta)
			if attack_delay == 30:
				shoot_player()
				attack_delay = 0
			attack_delay += 1
		
		if has_seen:
			move_and_slide((vec_to_player / 2) * speed * delta)
		velocity.y += gravity * delta

	if start_health < 1:
		dead()
	if is_dead == true:
		see_player = false
		Global.spawn_boss = false
		$"/root/Global".player_in_battle = false
		dead_timer += 1
func _on_Area_body_entered(body):
	if "Player" in body.name:
		is_attacking = true
		body.lose_health(floor(rand_range(10.0, 65.0)))
		$AnimatedSprite3D.play("shoot")
		

		