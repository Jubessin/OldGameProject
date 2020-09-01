extends KinematicBody
#Difficulty
var health_scale
var dmg_scale
var dmg = round(rand_range(47, 105))
#State variables
var is_attacked = false
var is_attacking = false
var can_attack = false
var attack_timer = 34
var aggro_timer = 0
var see_player = false
var has_seen = false
var is_dead = false
var health 
var start_health
var base_health = 5500
var aggroed = false
var sword_sound = true
var obj_in_rad = []
var has_seen_timeout = 0
var hass_start = false
#Item Drops
const PAMMO = preload("res://Pistol.tscn")
const RAMMO = preload("res://Rifle.tscn")
const SHELLS = preload("res://Shotgunammo.tscn")
#Timers
var dead_timer = -72
var seen_timer = 0
#Motion Variables
const CHASE_SPEED = 170
const AGGRO_SPEED = 250
var speed
var velocity = Vector3()
var gravity = -9.8 * 4

#Item Variables
var item_chance
var item
func set_level(level):
	health = floor(sqrt(base_health * level) * 20) * health_scale
	start_health = floor(sqrt(base_health * level) * 20) * health_scale

func _ready():
	$AnimatedSprite3D.play('idle')
	if settings.difficulty == "Easy":
		dmg_scale = 0.5
		health_scale = 0.7
	if settings.difficulty == "Medium":
		dmg_scale = 1.2
		health_scale = 1.5
	if settings.difficulty == "Hard":
		dmg_scale = 2.0
		health_scale = 2.0
	set_level(1)
	if health == null:
		health = base_health
	randomize()
	item_chance = randi()% 100
	if item_chance <= 0:
		item = null
	if item_chance > 0 and item_chance < 30:
		item = 1
	if item_chance >= 30 and item_chance < 60:
		item = 2
	if item_chance >= 60:
		item = 3
	if Global.player_unfound_weps.has("Rifle") and item == 2:
		item = 1
	if Global.player_unfound_weps.has("Shotgun") and item == 3:
		if Global.player_unfound_weps.has("Rifle"):
			item = 1
		else:
			item = round(rand_range(1, 2))
	if Global.player_unfound_weps.has("Smg") and item == 4:
		item = round(rand_range(1, 3))
func unsheathe():
	if sword_sound == true:
		$sword.play(0.0)
		sword_sound = false
func lose_health(damage):
	is_attacked = true
	randomize()
	health -= damage
	if damage == null:
		return
	
func dead():
	is_dead = true
	if dead_timer == -70:
		$dead.play(0.0)
	if item == 1:
		var item_drop = PAMMO.instance()
		item_drop.translation = translation
		if dead_timer == 20:
			get_parent().add_child(item_drop)
	
	if item == 2:
		var item_drop = RAMMO.instance()
		item_drop.translation = translation
		if dead_timer == 20:
			get_parent().add_child(item_drop)
	if item == 3:
		var item_drop = SHELLS.instance()
		item_drop.translation = translation
		if dead_timer == 20:
			get_parent().add_child(item_drop)
	if dead_timer == 30:
		hide()
		queue_free()
		
func _physics_process(delta):
	if !$GroundRay.is_colliding():
		move_and_slide(velocity) 
	if is_attacked:
		get_parent().gk_attacked = true
	if is_dead == false and is_attacked:
		aggro_timer += 1
		
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
#		if $RayCast.is_colliding():
#			if "Player" in $RayCast.get_collider().name:
#				see_player = true
#		if $RayCast2.is_colliding():
#			if "Player" in $RayCast2.get_collider().name:
#				see_player = true
#
#		if $SkyRay.is_colliding():
#			if "Player" in $RayCast2.get_collider().name:
#				see_player = true
		if ($RayCast.is_colliding() and n.is_in_group("persistent")) or ($RayCast2.is_colliding() and m.is_in_group("persistent")) or ($SkyRay.is_colliding() and o.is_in_group("persistent")):
			see_player = true
		else:
			see_player = false
		if !aggroed:
			speed = CHASE_SPEED 
		if see_player:
			$AnimatedSprite3D.play('move')
			unsheathe()
			has_seen = true
			hass_start = true
			has_seen_timeout = 0
			
		if hass_start:
			has_seen_timeout += 1
		
		if has_seen and has_seen_timeout < 800:
			$"/root/Global".player_in_battle = true
			move_and_slide(vec_to_player * speed * delta)
		if has_seen and has_seen_timeout >= 800:
			$"/root/Global".player_in_battle = false
			$AnimatedSprite3D.play("idle")
		if is_attacking:
			attack_timer += 1
			if attack_timer >= 35:
				can_attack = true
				attack_timer = 0
			else:
				can_attack = false
		velocity.y += gravity * delta
		for i in obj_in_rad:
			is_attacking = true
			if can_attack:
				i.lose_health(dmg * dmg_scale)
				$AnimatedSprite3D.play("attack")
	if health < 1:
		dead()
	if is_dead == true:
		see_player = false
		$"/root/Global".player_in_battle = false
		dead_timer += 1
	if !is_attacked:
		if get_parent().gk_move == false and get_parent().gk_move2 == false:
			$AnimatedSprite3D.play('idle')
		global_transform = global_transform

func _on_Hitbox_body_entered(body):
	if "Player" in body.name:
		see_player = true
		obj_in_rad.append(body)
#		is_attacking = true
#		body.lose_health(floor(rand_range(10.0, 65.0)))
#		$AnimatedSprite3D.play("attack")
#		attack_timer = 0

func _on_Hitbox_body_exited(body):
	if obj_in_rad.has(body):
		obj_in_rad.clear()
