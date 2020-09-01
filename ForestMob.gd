extends KinematicBody

#State variables
var is_attacking = false
var can_attack = false
var attack_timer = 24
var aggro_timer = 0
var see_player = false
var has_seen = false
var is_dead = false
var health 
var start_health
var base_health = 250
var aggroed = false
var obj_in_rad = []
var has_seen_timeout = 0
var hass_start = false
var damage

#For difficulty settings
var dmg_scale
var health_scale

#Item Drops
const PAMMO = preload("res://Pistol.tscn")
const RAMMO = preload("res://Rifle.tscn")
const SHELLS = preload("res://Shotgunammo.tscn")
#Timers
var dead_timer = -32
var seen_timer = 0
#Motion Variables
var chase_speed = round(rand_range(240, 255))
var aggro_speed = round(rand_range(330, 360))
var speed
var velocity = Vector3()
var gravity = -9.8 * 4
var grunted = false
var will_grunt
#Item Variables
var item_chance
var item
func set_level(level):
	health = floor(sqrt(base_health * level) * 20) * health_scale
	start_health = floor(sqrt(base_health * level) * 20) * health_scale
func lookout(degree):
	aggro_timer = 0
	if aggro_timer < 400 or see_player and degree == 1:
		aggroed = true
		speed = aggro_speed 
		$Hitbox/Hitbox.scale *= 1.5
		
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
	will_grunt = randi()%100
	item_chance = randi()% 100
	if item_chance <= 0:
		item = null
	if item_chance > 0 and item_chance < 30:
		item = 1
	if item_chance >= 30 and item_chance < 60:
		item = 2
	if item_chance >= 60:
		item = 3


func seen():
	if grunted == false and will_grunt > 45:
		$grunt.play(0.0)
		grunted = true

func death_sound():
	if not $AudioStreamPlayer3D.playing:
		$AudioStreamPlayer3D.play(0.0)

func lose_health(damage):
	randomize()
	health -= damage
	if damage == null:
		return
	if health > start_health / 2:
		lookout(1)
	
func dead():
	is_dead = true
	if dead_timer == -30:
		death_sound()
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

func attack_sound():
	if $attack.playing:
		return
	else:
		$attack.play(0.0)
func _physics_process(delta):
	if is_dead == false:
		if not $attack.playing:
			$attack.unit_db = -100
		else:
			$attack.unit_db = 49
			
		aggro_timer += 1
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
			speed = chase_speed 
			
		if see_player:
			seen()
			has_seen = true
			hass_start = true
			has_seen_timeout = 0
			
		if hass_start:
			has_seen_timeout += 1
		
		if has_seen and has_seen_timeout < 800:
			move_and_slide(vec_to_player * speed * delta)
		if !see_player and has_seen_timeout >= 300:
			global_transform = global_transform
			
		
		if is_attacking:
			attack_timer += 1
			if attack_timer >= 25:
				can_attack = true
				attack_sound()
				attack_timer = 0
				
			else:
				can_attack = false
		if is_attacking != true or obj_in_rad.empty():
			$attack.stop()
			$AnimatedSprite3D.play("walk")
		velocity.y += gravity * delta
		for i in obj_in_rad:
			is_attacking = true
			if can_attack and !i.is_grabbed:
				randomize()
				damage = round(rand_range(10, 45)) * dmg_scale
				i.lose_health(damage)
				$AnimatedSprite3D.play("attack")
	if health < 1:
		dead()
	if is_dead == true:
		see_player = false
		$"/root/Global".player_in_battle = false
		dead_timer += 1

func _on_Hitbox_body_exited(body):
	if obj_in_rad.has(body):
		obj_in_rad.clear()
		


func _on_Hitbox_body_entered(body):
	if "Player" in body.name:
		see_player = true
		obj_in_rad.append(body)
#		is_attacking = true
#		body.lose_health(floor(rand_range(10.0, 65.0)))
#		$AnimatedSprite3D.play("attack")
#		attack_timer = 0
