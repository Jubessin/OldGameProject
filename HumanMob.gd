extends KinematicBody
#Difficulty
var health_scale
var dmg_scale
var dmg = round(rand_range(21, 35))
#State variables
var is_attacking = false
var can_attack = false
var attack_timer = 34
var aggro_timer = 0
var time_off = 0
var see_player = false
var has_seen = false
var is_dead = false
var health 
var start_health
var base_health = 500
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
var chase_speed = round(rand_range(170, 210))
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

func lose_health(damage):
	randomize()
	health -= damage
	if damage == null:
		return
	
	
func dead():
	is_dead = true
#	if dead_timer == -70:
#		$dead.play(0.0)
	if dead_timer == -40:
		$AnimatedSprite3D.play("dead")
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
	if is_dead == false:
		var player = get_parent().get_child(1)
		aggro_timer += 1
		if !$GroundRay.is_colliding():
			time_off += 1
		else:
			time_off = 0
		if time_off > 40:
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
		
		speed = chase_speed
		if see_player:
			has_seen = true
			hass_start = true
			has_seen_timeout = 0
			
		if hass_start:
			has_seen_timeout += 1
		
		if has_seen and has_seen_timeout < 800:
			move_and_slide(vec_to_player * speed * delta)
			$AnimatedSprite3D.play("walkf")
		if !see_player and has_seen_timeout >= 300:
			global_transform = global_transform
			
		
		if is_attacking:
			attack_timer += 1
			if attack_timer >= 15:
				can_attack = true
				attack_timer = 0
			else:
				can_attack = false
		if is_attacking != true or obj_in_rad.empty():
			$AnimatedSprite3D.play("walkf")
		velocity.y += gravity * delta
		if see_player:
			is_attacking = true
			if can_attack:
				$AnimatedSprite3D.play("shoot")
				randomize()
				var chance_miss = randi()%100
				if chance_miss > 65:
					player.lose_health(dmg * dmg_scale)
				else: 
					pass

	if health < 1:
		dead()
	if is_dead == true:
		see_player = false
		$"/root/Global".player_in_battle = false
		dead_timer += 1

