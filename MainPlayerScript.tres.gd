extends KinematicBody

# Player mechanics
var camera_angle = 0
onready var mouse_sensitivity = settings.mouse_sensitivity / 10
# is_doing something variables
var is_opening = false
var is_shooting = false
var is_reloading = false
var is_dashing = false
var is_dead = false
var is_leaning = false
var is_crouched = false
var stance
var hpot_used = false
var stam_pot_used = false
var str_pot_used = false
var can_rest = false
var can_leave = false
var is_throwing = false
var has_thrown = false
var is_moving = false
var in_cutscene = false
var is_resting = false
var is_overheating = false
var is_grabbed = false
var knocked_back = false

# timer variables
var shoottimer = 0
var reloadtimer = 0
var bullet_timer = 0
var laser_delay = 0
var overheat_timer = 0
var health_delay = 100
var stamina_recharge = 0
var dash_timer = 0
var death_timer = 0
var stam_pot_timer = 0
var str_pot_timer = 0
var throw_timer = 0
var heartbeat_timer = 0
var knockback_timer = 0
const KNOCKBACK_TIMEOUT = 40
var text_timer = 0
var vchar_timer = 0

# Motion Variables
const JUMP_SPEED = 15
const JUMP_ACCEL =  3
var jump_height = 15
const MAX_SPEED = 7 
const MAX_RUN_SPEED = 13
const DASH_SPEED = 20
const LEAN_SPEED = 3
const CROUCH_SPEED = 3
const KNOCKBACK_SPEED = 60
var lean_dir = 0

#Speed change based on eqp
var gravity = -9.8 * 4
const ACCEL = 2
const DECEL = 6
var has_contact = false
const MAX_SLOPE_ANGLE = 45
var velocity = Vector3()
var direction = Vector3()
var last_key_delta = 0
const DASH_TIMEOUT = 0.1
var dash_type = null
var speed = 0
# Status variables
var health = 1
var in_battle




#Instances
const BULLET = preload("res://bullet.tscn")
const RBULLET = preload("res://Rbullet.tscn")
const SHELL = preload("res://Shells.tscn")
const LASER = preload("res://Laser.tscn")
const ITEMBOX = preload("res://ItemGainedLabel.tscn")
const INVENTORY = preload("res://Inventory/inventory.tscn")
const GRENADE = preload("res://Grenade.tscn")
const REST = preload("res://Rest.tscn")
#Ammunition
var p_spare_ammo = 48
var r_spare_ammo = 84
var s_spare_ammo = 22
var ammo_gained
var gained_ammo
#Weapons
var default_weapon = "Pistol"
var equipped_weapon = ""
var unfound_weapons = [ "Smg"]
var alternate_weapons = ["Rifle", "Laser"]
var eqp
var eqpname
var r_type

#Inventory
var spare_hpots
var spare_spots
var spare_stpots
var max_hpots = 6
var max_spots = 2
var max_stpots = 2
var item_taken = false
var grenades = 0
var max_grenades = 3
#Miscelanneous
var chance_dodge
var hand
var hairs
var textbox
var itembox
var enemies_in_sight = []
var pistol_delay = 0
var delay_start = false
var overheat_start = false
var ldelay_start = false
onready var staminabar = $staminabar
var hb_start = false
var a = false
var rested = false
var dialogue = false

func _ready():
	update_player()
	update_ammo_counts()
	

func update_global():
	$"/root/Global".player_health = health
	$"/root/Global".player_pammo = $PistolAmmo.value
	$"/root/Global".player_rammo = $RifleAmmo.value
	$"/root/Global".player_sammo = $Shotgunammo.value
	$"/root/Global".player_spare_pammo = p_spare_ammo
	$"/root/Global".player_spare_rammo = r_spare_ammo
	$"/root/Global".player_spare_sammo = s_spare_ammo
	$"/root/Global".player_alt_weps = alternate_weapons
	$"/root/Global".player_eqp_wep = eqp
	$"/root/Global".player_unfound_weps = unfound_weapons
	spare_hpots = $"/root/Global".spare_hpots
	spare_spots = $"/root/Global".spare_spots
	spare_stpots = $"/root/Global".spare_stpots
	$"/root/Global".spare_grenades = grenades
	
func update_player():
	health = $"/root/Global".player_health
	$PistolAmmo.value = $"/root/Global".player_pammo
	$RifleAmmo.value = $"/root/Global".player_rammo
	$Shotgunammo.value = $"/root/Global".player_sammo
	p_spare_ammo = $"/root/Global".player_spare_pammo
	r_spare_ammo = $"/root/Global".player_spare_rammo
	s_spare_ammo =$"/root/Global".player_spare_sammo
	eqp = $"/root/Global".player_eqp_wep
	spare_hpots = $"/root/Global".spare_hpots
	spare_spots = $"/root/Global".spare_spots
	spare_stpots = $"/root/Global".spare_stpots
	grenades = $"/root/Global".spare_grenades
	unfound_weapons =  $"/root/Global".player_unfound_weps
	alternate_weapons = $"/root/Global".player_alt_weps
	in_cutscene = $"/root/Global".in_cutscene
	
	if p_spare_ammo == null:
		p_spare_ammo = 48
	if r_spare_ammo == null:
		r_spare_ammo = 102
	if s_spare_ammo == null:
		s_spare_ammo = 22
	if $PistolAmmo.value == 0:
		$PistolAmmo.value = 12
	if $RifleAmmo.value == 0:
		$RifleAmmo.value = 21
	if $Shotgunammo.value == 0:
		$Shotgunammo.value = 2
	if health == null:
		health = 1000
	if equipped_weapon == null:
		equipped_weapon = default_weapon
	if unfound_weapons == null:
		unfound_weapons = unfound_weapons
	if eqp == null:
		equipped_weapon = default_weapon
	if spare_hpots == null:
		spare_hpots = 0
	if spare_spots == null:
		spare_spots = 0
	if spare_stpots == null:
		spare_stpots = 0

func rest():
	if not is_throwing and not is_reloading:
		if Input.is_action_just_pressed("ui_accept"):
			save()
			$"/root/Global".current_scene = get_parent().scene
			var rest = REST.instance()
			is_resting = true
			get_child(1).add_child(rest)
			$restlabel.hide()
#			Global.player_health = Global.reset_health
			health = Global.reset_health


func leave_area():
	if not is_throwing and not is_reloading:
		if Input.is_action_just_pressed("ui_accept"):
			if get_parent().name == "Cave":
				Global.next_map = "grasslands.tscn"
				get_tree().change_scene("loadingscreen.tscn")
			if get_parent().name == "Forest":
				get_tree().change_scene("teleport.tscn")
			

func change_weapon():
	if !is_throwing and !is_reloading and !is_grabbed and !knocked_back:
		if Input.is_action_just_released('weapon_change') and alternate_weapons.size() > 0:
			equipped_weapon.hide()
#			if alternate_weapons.size() == 1:
			alternate_weapons.push_back(equipped_weapon.name)
#			if alternate_weapons.size() == 2:
#				alternate_weapons.pop_back(equipped_weapon.name)
#			if alternate_weapons.size() == 3:
#				alternate_weapons.insert(3, equipped_weapon.name)
			equipped_weapon = alternate_weapons[0]
			#alternate_weapons.sort()
		if eqpname == "Pistol":
			eqp = 2
		if eqpname == "Rifle":
			eqp = 1
		if eqpname == "Shotgun":
			eqp = 3
		if eqpname == "Laser":
			eqp = 5
		update_global()

func change_stance():
	if !is_grabbed:
		if stance == null and $".".scale.y > 0.3:
			$".".scale.y -= 0.31
			is_crouched = true
			$".".is_crouched = false
		if stance == 1 and $".".scale.y < 0.6:
			$".".scale.y += 0.31
			is_crouched = false
			Global.is_crouched = false
		if stance == 0 and $".".scale.y > 0.3:
			$".".scale.y -= 0.31
			is_crouched = true
	
func open_treasure(item):
	if !is_throwing and has_contact and !is_reloading:
		is_opening = true
		equipped_weapon.hide()
		hairs.hide()
		textbox.hide()
		$head/Camera/Hand.visible = true

func pick_up(item):
	if !is_throwing and !is_dashing and has_contact and !is_reloading:
		if not item == "Pistol":
			equipped_weapon.hide()
		hairs.hide()
		textbox.hide()
		$head/Camera/Hand.visible = true
		
		if spare_hpots >= max_hpots:
			itembox = ITEMBOX.instance()
			itembox.set_text("You can take no more " + item + " pots")
			item_taken = false
			add_child(itembox)
			
		if item == "health":
			if spare_hpots < max_hpots:
				spare_hpots += 1
				item_taken = true
				Global.spare_hpots += 1
				
			
		if spare_spots >= max_spots:
			itembox = ITEMBOX.instance()
			itembox.set_text("You can take no more " + item + " pots")
			item_taken = false
			add_child(itembox)
	
		if item == "stamina":
			if spare_spots < max_spots:
				item_taken = true
				spare_spots += 1
				Global.spare_spots += 1
	
		if spare_stpots >= max_stpots:
			itembox = ITEMBOX.instance()
			itembox.set_text("You can take no more " + item + " pots")
			item_taken = false
			add_child(itembox)
			
		if item == "strength":
			if spare_stpots < max_stpots:
				spare_stpots += 1
				item_taken = true
				Global.spare_stpots += 1
		
		if item == "grenade":
			if grenades < max_grenades:
				grenades += 1
				item_taken = true
				Global.spare_grenades += 1
		
		if item == "Pistol":
			unfound_weapons.erase("Pistol")
			eqp = 2
			eqpname = "Pistol"
			item_taken = true
			
		if item == "Rifle":
			unfound_weapons.erase("Rifle")
			alternate_weapons.push_back(eqpname)
			eqpname = "Rifle"
			eqp = 1
			item_taken = true
		
		if item == "Shotgun" or item == "Shotgun":
			unfound_weapons.erase("Shotgun")
			alternate_weapons.push_back(eqpname)
			eqpname = "Shotgun"
			eqp = 3
			item_taken = true
		if item == "Laser":
			unfound_weapons.erase("Laser")
			alternate_weapons.push_back(eqpname)
			eqpname = "Laser"
			eqp = 5
			item_taken = true
		eqp = 0
		hairs.hide()
		textbox.hide()
		$head/Camera/Hand.visible = true
	update_global()
func gain_ammo(ammo_type):
	if ammo_type == 2:
		ammo_gained = round(rand_range(6.0, 14.0))
		if p_spare_ammo == 48:
			gained_ammo = false
		if p_spare_ammo < 48:
			gained_ammo = true
			p_spare_ammo += ammo_gained
		if p_spare_ammo > 48:
			p_spare_ammo = 48

	if ammo_type == 1:
		ammo_gained = round(rand_range(17.0, 29.0))
		if r_spare_ammo == 84:
			gained_ammo = false
		if r_spare_ammo < 84:
			r_spare_ammo += ammo_gained
			gained_ammo = true
		if r_spare_ammo > 84:
			r_spare_ammo = 84

	if ammo_type == 3:
		ammo_gained = round(rand_range(2, 6))
		if s_spare_ammo == 22:
			gained_ammo = false
		if s_spare_ammo < 22:
			s_spare_ammo += ammo_gained
			gained_ammo = true
		if s_spare_ammo > 22:
			s_spare_ammo = 22
			
	update_ammo_counts()
	update_global()

func reload():
	if !is_throwing and !is_grabbed:
		if (Input.is_action_just_pressed("reload") and not Input.is_action_pressed("sprint") and not Input.is_action_just_pressed("shoot")) and (is_on_floor() or $RayCast.is_colliding()):
			if eqp == 2:
				if $PistolAmmo.value < 12 and p_spare_ammo > 0:
					is_reloading = true
					$head/Camera/Pistol.play("reload")
					var difference = (12 - $PistolAmmo.value)
					$PistolAmmo.value += p_spare_ammo
					p_spare_ammo -= difference
					update_global()
					
			if eqp == 1:
				if $RifleAmmo.value < 21 and r_spare_ammo > 0:
					is_reloading = true
					$head/Camera/Rifle.play("reload")
					var difference = (21 - $RifleAmmo.value)
					$RifleAmmo.value += r_spare_ammo
					r_spare_ammo -= difference
					update_global()
			if eqp == 3:
				if $Shotgunammo.value == 1 and s_spare_ammo > 0:
					r_type = 1
					is_reloading = true
					$head/Camera/Shotgun.play("reload1")
					$head/Camera/Shotgun/reload.play(0.0)
					var difference = (2 - $Shotgunammo.value)
					$Shotgunammo.value += s_spare_ammo
					s_spare_ammo -= difference
					update_global()
				if $Shotgunammo.value == 0 and s_spare_ammo > 0:
					r_type = 2
					is_reloading = true
					$head/Camera/Shotgun.play("reload2")
					$head/Camera/Shotgun/reload.play(0.0)
					var difference = (2 - $Shotgunammo.value)
					$Shotgunammo.value += s_spare_ammo
					s_spare_ammo -= difference
					update_global()
		if eqp == 5 and $Laserammo.value == 0:
			is_reloading = true
			overheat_start = true
			is_overheating = true
		if overheat_timer > 298:
			$Laserammo.value += 5
			
	update_ammo_counts()
func lose_health(amount):
	randomize()
	chance_dodge = randi()%100
	if chance_dodge > 82:
		health = health
		chance_dodge = 0
	else:
		health -= amount
		$head/Camera/Particles2D.emitting = true
	health_delay = 0
	update_global()
	if health < 200:
		if !$AudioStreamPlayer.playing:
			hb_start = true
			heartbeat_timer = 0
		if heartbeat_timer < 150 and !$AudioStreamPlayer.playing:
			$AudioStreamPlayer.play(0.0)
	if not $pain.playing:
		$pain.play(0.0)
		
func lose_more_health(amount):
	randomize()
	if !$AudioStreamPlayer.playing:
		hb_start = true
	chance_dodge = randi()%100
	if chance_dodge > 87 or (is_dashing and chance_dodge > 71):
		health = health
		chance_dodge = 0
	else:
		health -= amount
		$head/Camera/Particles2D.emitting = true
	health_delay = 0
	update_global()
	if health < 200:
		if !$AudioStreamPlayer.playing:
			hb_start = true
			heartbeat_timer = 0
		if heartbeat_timer < 150 and !$AudioStreamPlayer.playing:
			$AudioStreamPlayer.play(0.0)
	if not $pain.playing:
		$pain.play(0.0)

func update_ammo_counts():
	$RichTextLabel.clear()
	if eqp == 2:
		$RichTextLabel.add_text(String($PistolAmmo.value))
		$RichTextLabel.add_text("\n 	/")
		if p_spare_ammo > 0:
			$RichTextLabel.add_text("\n\n		" + String(p_spare_ammo))
		if p_spare_ammo <= 0:
			$RichTextLabel.add_text("\n\n		0")
	if eqp == 1:
		$RichTextLabel.add_text(String($RifleAmmo.value))
		$RichTextLabel.add_text("\n 	/")
		if r_spare_ammo > 0:
			$RichTextLabel.add_text("\n\n		" + String(r_spare_ammo))
		if r_spare_ammo <= 0:
			$RichTextLabel.add_text("\n\n		0")
	if eqp == 3:
		$RichTextLabel.add_text(String($Shotgunammo.value))
		$RichTextLabel.add_text("\n 	/")
		if s_spare_ammo > 0:
			$RichTextLabel.add_text("\n\n		" + String(s_spare_ammo))
		if s_spare_ammo <= 0:
			$RichTextLabel.add_text("\n\n		0")
	if eqp == 5:
		$RichTextLabel.add_text(String($Laserammo.value))
		$RichTextLabel.add_text("\n 	/")
		$RichTextLabel.add_text("\n\n		/")

func lean():
	var forwarddir = $head.get_global_transform().basis.x
	if !is_dashing and has_contact and !is_grabbed and !knocked_back:
		if Input.is_action_pressed("lean_right"):
			is_leaning = true
			speed = LEAN_SPEED
			lean_dir = 1
			if $head.rotation_degrees.z > -20:
				if forwarddir.x > 0.003:
					$head.rotation_degrees.z -= 1 
				else:
					$head.rotation_degrees.z -= 1 
		if Input.is_action_pressed("lean_left"):
			is_leaning = true
			speed = LEAN_SPEED
			lean_dir = -1
			if $head.rotation_degrees.z < 20:
				if forwarddir.x < 0.003:
					$head.rotation_degrees.z += 1 
				else:
					$head.rotation_degrees.z += 1 

func throw_grenade(time_held):
		$head/Camera/grenade.play("throw")
		is_throwing = true
		$head/Camera/grenade.show()
		var grenade = GRENADE.instance()
		equipped_weapon.hide()
		grenade.grenade_timer = time_held
		grenade.global_transform = $head/Camera/Grenadepos.global_transform
		if time_held < 4:
			grenade.apply_impulse($head/Camera/Grenadepos.translation, $head/Camera/Grenadepos.global_transform.basis.z.normalized() * -(27 * (time_held)))
		if time_held >= 4:
			grenade.apply_impulse(Vector3(0,0,0), $head/Camera/Grenadepos.global_transform.basis.z.normalized() * 0)
		get_parent().add_child(grenade)
		grenades -= 1
		is_throwing = false
		equipped_weapon.show()
		hairs.show()
		textbox.show()
		update_global()
		
func knockback(delta):
	
	speed = KNOCKBACK_SPEED
	var x = $head.get_global_transform().basis.x
	direction = Vector3()
	
	var temp_velocity = velocity
	temp_velocity.y = 0
	var aim = $head/Camera.get_global_transform().basis
	direction += aim.z
	var acceleration
	direction.y = 0
	direction = direction.normalized()
	if direction.dot(temp_velocity) > 0:
		acceleration = ACCEL
	else:
		acceleration = DECEL
	
	var target = direction * speed
	
	temp_velocity = velocity.linear_interpolate(target, acceleration * delta)
	velocity.x = temp_velocity.x
	velocity.z = temp_velocity.z
	velocity = move_and_slide(velocity, Vector3(0, 1, 0))


func _input(event):
	if is_dead == false and not in_cutscene and !is_grabbed:
		if event is InputEventMouseMotion:
			$head.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
			var change = -event.relative.y * mouse_sensitivity
			if change + camera_angle < 90 and change + camera_angle > -90:
				$head/Camera.rotate_x(deg2rad(change))
				camera_angle += change
	
		if is_dashing == false and !is_leaning and !is_throwing:
			if event is InputEventKey and(Input.is_action_just_pressed("left"))  and event.pressed and !event.is_echo():
				if last_key_delta > DASH_TIMEOUT or staminabar.value == 0:
					dash_type = null
					is_dashing = false
				if Input.is_action_just_pressed("left") and last_key_delta < DASH_TIMEOUT and staminabar.value > 0:
					dash_type = "left"
					is_dashing = true
#				last_key_delta = 0
			if event is InputEventKey and (Input.is_action_just_pressed("backwards")) and event.pressed and !event.is_echo():
				if last_key_delta > DASH_TIMEOUT or staminabar.value == 0:
					dash_type = null
					is_dashing = false
				if Input.is_action_just_pressed("backwards") and last_key_delta < DASH_TIMEOUT and staminabar.value > 0:
					dash_type = "back"
					is_dashing = true
#				last_key_delta = 0
			if event is InputEventKey and (Input.is_action_just_pressed("right"))  and event.pressed and !event.is_echo():
				if last_key_delta > DASH_TIMEOUT or staminabar.value == 0:
					dash_type = null
					is_dashing = false
				if Input.is_action_just_pressed("right") and last_key_delta < DASH_TIMEOUT and staminabar.value > 0:
					dash_type = "right"
					is_dashing = true
#				last_key_delta = 0
			if Input.is_action_pressed("left") and Input.is_action_pressed("right"):
				dash_type = null
				is_dashing = false
			if Input.is_action_pressed("left") and Input.is_action_pressed("backwards"):
				dash_type = null
				is_dashing = false
			if Input.is_action_pressed("backwards") and Input.is_action_pressed("right"):
				dash_type = null
				is_dashing = false
			if Input.is_action_pressed("left") and Input.is_action_pressed("right") and Input.is_action_pressed("forward"):
				dash_type = null
				is_dashing = false
		last_key_delta = 0
	
func dialogue(scene, t):
	if scene == "Forest":
		$ForestDialogue.clear()
		if t == 1:
			$ForestDialogue.add_text("...So. You're still alive then.")
		if t == 2:
			$ForestDialogue.add_text("...Do not shoot. We share similar stories...")
		if t == 3:
			$ForestDialogue.add_text("...I could no longer serve that tyrant.")
		if t == 4:
			$ForestDialogue.add_text("You have more courage than I.")
		if t == 5:
			$ForestDialogue.add_text("...I was unable to fight against his evil.")
		if t == 6:
			$ForestDialogue.add_text("...But it appears you can..")
		if t == 7:
			$ForestDialogue.add_text("I know not where this leads..")
		if t == 8:
			$ForestDialogue.add_text("But I know this path leads forwards...")
		if t == 9:
			$ForestDialogue.add_text("Go on... and do what must be done.")
		if t == 10:
			$ForestDialogue.add_text("...So be it then..")
func _physics_process(delta):
	if is_dead == true or in_cutscene or is_resting:
		
		$".".hide()
		$healthbar.hide()
		$staminabar.hide()
		$RichTextLabel.hide()
	
		
	else:
		print(last_key_delta)
		if eqp == 0 and unfound_weapons.size() == 5:
			equipped_weapon.hide()
		if hb_start:
			heartbeat_timer += 1
		if health < 200 and heartbeat_timer > 150:
			$AudioStreamPlayer.stop()
		if is_opening:
			if not str(equipped_weapon) == "":
				equipped_weapon.hide()
		if eqp == 2:
			$head/EnemyRay.cast_to.y = -50.5
		if eqp == 1:
			$head/EnemyRay.cast_to.y = -32.3
		if eqp == 3:
			$head/EnemyRay.cast_to.y = -29.5
		if eqp == 5:
			$head/EnemyRay.cast_to.y = -37
		$".".show()
		$healthbar.show()
		$staminabar.show()
		$RichTextLabel.show()
		#Fix health going > 1000
		in_cutscene = $"/root/Global".in_cutscene
		#Stance changing (crouch, stand)
		
		
		if Input.is_action_pressed("throw") and grenades > 0 and !is_dashing and has_contact and speed < MAX_RUN_SPEED and !is_reloading:
			is_throwing = true
			equipped_weapon.hide()
			hairs.hide()
			textbox.hide()
			$head/Camera/grenade.show()
			$head/Camera/grenade.play("pin")
			throw_timer += delta
		if Input.is_action_just_released("throw") and throw_timer > 0:
			is_throwing = true
			equipped_weapon.hide()
			throw_grenade(throw_timer)
			throw_timer = 0
		
		if !is_throwing:
			$head/Camera/grenade.hide()
		can_rest = Global.can_rest
		
		can_leave = Global.can_leave
		if in_battle == false and has_contact and can_rest == true:
			$restlabel.show()
			rest()
		else:
			$restlabel.hide()
		if !in_battle and can_leave:
			$leavelabel.show()
			leave_area()
		else:
			$leavelabel.hide()
		if $".".scale.y > 0.2 and $".".scale.y < 0.3:
			stance = 1
		else:
			stance = 0
		if Input.is_action_just_pressed("stance_change"):
			change_stance()
			
		#forward direction of player
		var forwarddir = $head.get_global_transform().basis.x
		
		#Allowing for mouse wheel input
		set_process_input(true)
		
		#Key timer for dashing.
		last_key_delta += delta
		
		#Constant check and call for changing weapons.
		change_weapon()
		
		#Disable dashing under conditions
		if staminabar.value == 0:
			dash_type = null
			is_dashing = false
			speed = MAX_SPEED
			
		#Check if leaning is occuring.
		if Input.is_action_just_released("lean_left") or Input.is_action_just_released("lean_right"):
			is_leaning = false
			
		#Process for when player is not leaning.
		if is_leaning == false:
			if lean_dir == 1 and not ($head.rotation_degrees.z > -0.5 and $head.rotation_degrees.z < 0.5):
				$head.rotation_degrees.z += 1 
			if lean_dir == -1 and not ($head.rotation_degrees.z > -0.5 and $head.rotation_degrees.z < 0.5):
				$head.rotation_degrees.z -= 1
	
		#Stamina recharge timer increases when dashing is false and value < max. 
		if is_dashing == false and staminabar.value < staminabar.max_value and !speed == 13 and has_contact and !is_grabbed:
			stamina_recharge += 1
		else:
			stamina_recharge = 0
		
		#Increases stamina bar under conditions.
		if stam_pot_timer >= 850:
			$"/root/Global".sta_pot_used = false
			stam_pot_timer = 0
			
		if $"/root/Global".sta_pot_used:
			stam_pot_timer += 1
			if staminabar.value < staminabar.max_value and stamina_recharge > 50:
				staminabar.value += 1
				
		if !$"/root/Global".sta_pot_used and staminabar.value < staminabar.max_value and stamina_recharge > 150:
			staminabar.value += 1
			
		#Decreases stamina bar and increases dash timer when dashing.
		if speed == 20:
			dash_timer += 1
			staminabar.value -= 2
		if speed == 13:
			staminabar.value -= 1
		if is_grabbed:
			if translation.y < 3:
				translation.y += 0.1
			if translation.y > 3:
				translation.y -= 0.1
			staminabar.value -= 0.5
		if not has_contact:
			staminabar.value -= 0.3
		#Increases bullet strength under conditions.
		if str_pot_timer >= 550:
			$"/root/Global".str_pot_used = false
			str_pot_timer = 0
			
		#Code for using health pots.
		if $"/root/Global".str_pot_used:
			str_pot_timer += 1

		if $"/root/Global".hpot_used == true:
			health += 150
			$"/root/Global".hpot_used = false
		
		#Defining variables to be used.
		hand = $head/Camera/Hand
		hairs = $head/Camera/hairs
		textbox = $RichTextLabel
		$healthbar.health_value = health
		in_battle = $"/root/Global".player_in_battle
		#Set crosshair color
		var n = $head/EnemyRay.get_collider()
		if $head/EnemyRay.is_colliding():
			if n.is_in_group("mobs"):
				hairs.set_color(true)
		
		if $head/EnemyRay.is_colliding():
			if !n.is_in_group("mobs"):
				hairs.set_color(false)
				
		if unfound_weapons.size() > 4:
			hairs.hide()
		bullet_timer += 1
		if bullet_timer == 11:
			bullet_timer = 0
			
		#Setting the equipped weapon to be displayed/hidden.
		if "Rifle" in equipped_weapon:
			eqp = 1

		if "Pistol" in equipped_weapon:
			eqp = 2

		if "Shotgun" in equipped_weapon:
			eqp = 3
		
		if "Laser" in equipped_weapon:
			eqp = 5
			
		if ("Pistol" in equipped_weapon or eqp == 2) and !is_throwing:
			alternate_weapons.erase("Pistol")
			eqpname = $head/Camera/Pistol.name
			equipped_weapon = $head/Camera/Pistol
			equipped_weapon.visible = true

		if ("Rifle" in equipped_weapon or eqp == 1) and !is_throwing:
			equipped_weapon = $head/Camera/Rifle
			eqpname = $head/Camera/Rifle.name
			alternate_weapons.erase("Rifle")
			equipped_weapon.visible = true
		
		if ("Shotgun" in equipped_weapon or eqp == 3) and !is_throwing:
			equipped_weapon = $head/Camera/Shotgun
			alternate_weapons.erase("Shotgun")
			eqpname = $head/Camera/Shotgun.name
			equipped_weapon.visible = true

		if ("Laser" in equipped_weapon or eqp == 5) and !is_throwing:
			equipped_weapon = $head/Camera/Laser
			alternate_weapons.erase("Laser")
			eqpname = $head/Camera/Laser.name
			equipped_weapon.visible = true
			
		if "Hand" in equipped_weapon:
			equipped_weapon = $head/Camera/Hand
			eqpname = $head/Camera/Hand.name

		#Constant call and check on functions.
		if !is_grabbed:
			walk(delta)
			reload()
			lean()
		action(delta)
		if dialogue:
			text_timer += 1
			vchar_timer += 1
			if get_parent().name == "Forest":
				if !get_parent().gk_attacked:
					if text_timer == 50:
						dialogue(get_parent().name, 1)
					if text_timer == 250:
						$ForestDialogue.visible_characters = 0
						dialogue(get_parent().name, 2)
					if text_timer == 650:
						$ForestDialogue.visible_characters = 0
						dialogue(get_parent().name, 3)
					if text_timer == 660:
						get_parent().gk_move = true
					if text_timer == 1000:
						$ForestDialogue.visible_characters = 0
						dialogue(get_parent().name, 4)
					if text_timer == 1300:
						$ForestDialogue.visible_characters = 0
						dialogue(get_parent().name, 5)
					if text_timer == 1600:
						$ForestDialogue.visible_characters = 0
						dialogue(get_parent().name, 6)
					if text_timer == 1900:
						$ForestDialogue.visible_characters = 0
						dialogue(get_parent().name, 7)
					if text_timer == 2200:
						$ForestDialogue.visible_characters = 0
						dialogue(get_parent().name, 8)
					if text_timer == 2500:
						$ForestDialogue.visible_characters = 0
						dialogue(get_parent().name, 9)
					if text_timer == 2600:
						get_parent().gk_move2 = true
					if text_timer == 2800:
						dialogue = false
				if get_parent().gk_timer == 1:
					$ForestDialogue.visible_characters = 0
					dialogue(get_parent().name, 10)
				if vchar_timer == 6:
					if $ForestDialogue.visible_characters < 70:
						$ForestDialogue.visible_characters += 1
				if vchar_timer == 7:
					vchar_timer = 0
		#Setting delays for player to be hit, blood splatter to display.
		if health_delay < 105:
			health_delay += 1
		if health_delay > 25:
			$head/Camera/Particles2D.emitting = false

		if is_shooting == false and is_reloading == false and eqp == 2 and !is_throwing:
			$head/Camera/Pistol.play("standing")
		if is_shooting == false and is_reloading == false and eqp == 1 and !is_throwing:
			$head/Camera/Rifle.play("idle")
		if is_shooting == false and is_reloading == false and eqp == 3 and !is_throwing:
			$head/Camera/Shotgun.play("stand")
		if is_shooting == false and is_overheating == false and eqp == 5 and !is_throwing:
			$head/Camera/Laser.play("idle")
		if is_shooting == true:
			shoottimer += 1
		if shoottimer == 20:
			is_shooting = false
			shoottimer = 0
		if delay_start == true:
			pistol_delay += 1
		if pistol_delay > 11:
			delay_start = false
			pistol_delay = 0
		if is_reloading == true and is_shooting == false and eqp == 2:
			$head/Camera/Pistol.play("reload")
			reloadtimer += 1
		if is_reloading == true and is_shooting == false and eqp == 1:
			$head/Camera/Rifle.play("reload")
			reloadtimer += 1
		if is_reloading == true and is_shooting == false and eqp == 3:
			reloadtimer += 1
		if reloadtimer == 20 and not eqp == 3:
			is_reloading = false
			reloadtimer = 0
		if reloadtimer == 90 and r_type == 1:
			is_reloading = false
			reloadtimer = 0
		if reloadtimer == 150 and r_type == 2:
			is_reloading = false
			reloadtimer = 0
		if reloadtimer == 50 and r_type == 2 and is_reloading:
			$head/Camera/Shotgun/reload.play(0.0)
		if is_overheating and is_shooting == false and eqp == 5:
			$head/Camera/Laser.play("overheat")
		if overheat_start:
			overheat_timer += 1
		if overheat_timer > 299:
			is_overheating = false
			overheat_start = false
			overheat_timer = 0
		if is_overheating == false and eqp == 5:
			is_reloading = false
		if ldelay_start:
			laser_delay += 1
		if laser_delay > 25:
			ldelay_start = false
			laser_delay = 0
			
	if knocked_back:
		knockback_timer += 1
		knockback(delta)
		
	if knockback_timer == KNOCKBACK_TIMEOUT:
		knocked_back = false
		knockback_timer = 0
	
	if health < 1:
		is_dead = true
		dead()
		
func walk(delta):

	var x = $head.get_global_transform().basis.x
	direction = Vector3()
	var temp_velocity = velocity
	temp_velocity.y = 0


	var aim = $head/Camera.get_global_transform().basis
	if Input.is_action_pressed("sprint") and Input.is_action_pressed("forward") and !is_crouched and staminabar.value > 0:
		speed = MAX_RUN_SPEED
		direction -= aim.z
	if !Input.is_action_pressed("sprint") and dash_type == null and is_leaning == false and !is_crouched:
		speed = MAX_SPEED

	if !dash_type == null and !is_crouched:
		speed = DASH_SPEED
	if last_key_delta > delta*3:
		is_dashing = false
	if speed == 20 and dash_timer > 10 and !is_crouched:
		dash_type = null
		dash_timer = 0
		speed = MAX_SPEED
	if is_crouched:
		speed = CROUCH_SPEED
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

	if Input.is_action_just_pressed("jump") and has_contact and !is_leaning and !is_crouched and staminabar.value > 0:
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
	
func action(delta):
	if Input.is_action_just_pressed("shoot") and not Input.is_action_pressed("sprint") and is_reloading == false and !is_throwing and pistol_delay == 0:
		if eqp == 2:
			if $PistolAmmo.value > 0:
				$head/Camera/Pistol.play("shoot")
				is_shooting = true
				$PistolAmmo.value -= 1
				var bullet = BULLET.instance()
				bullet.global_transform = $head/Camera/Position3D.get_global_transform()
				bullet.set_rotation($head.rotation.x)
				$head/Camera/Pistol/AudioStreamPlayer3D.play(0.0)
				get_parent().add_child(bullet)
				delay_start = true

	if Input.is_action_pressed("shoot") and not Input.is_action_pressed('sprint') and is_reloading == false and !is_throwing:
		if eqp == 1:
			if $RifleAmmo.value > 0:
				is_shooting = true
				if shoottimer < 30:
					$head/Camera/Rifle.play("shoot")
				if bullet_timer == 10 or bullet_timer == 9:
					$RifleAmmo.value -= 1
					var rbullet = RBULLET.instance()
					$head/Camera/Rifle/AudioStreamPlayer3D.play(0.01)
					rbullet.global_transform = $head/Camera/Position3D.get_global_transform()
					rbullet.set_rotation($head.rotation.x)
					get_parent().add_child(rbullet)
	
	if Input.is_action_just_pressed("shoot") and not Input.is_action_pressed('sprint') and is_reloading == false and !is_throwing:
		if eqp == 3:
			if $Shotgunammo.value > 0:
				is_shooting = true
				if shoottimer < 30:
					$head/Camera/Shotgun.play("shoot")
				$Shotgunammo.value -= 1
				var shell = SHELL.instance()
				$head/Camera/Shotgun/shoot.play(0.00)
				shell.global_transform = $head/Camera/Position3D.get_global_transform()
				shell.set_rotation($head.rotation.x)
				get_parent().add_child(shell)
	
	if Input.is_action_just_pressed("shoot") and not Input.is_action_pressed('sprint') and is_reloading == false and !is_throwing and laser_delay == 0:
		if eqp == 5:
			if $Laserammo.value > 0 and not is_overheating:
				ldelay_start = true
				is_shooting = true
				if shoottimer < 25:
					$head/Camera/Laser.play("shoot")
				$Laserammo.value -= 1
				var laser = LASER.instance()
				$head/Camera/Laser/shoot.play(0.00)
				laser.global_transform = $head/Camera/Position3D.get_global_transform()
				get_parent().add_child(laser)
				
		pistol_delay = 0

	if Input.is_action_just_pressed("inventory") and (is_on_floor() or $RayCast.is_colliding()):
		var inventory = INVENTORY.instance()
		get_parent().add_child(inventory)
		get_tree().paused = true
	
func _on_PistolAmmo_value_changed(value):
	update_ammo_counts()
	if $PistolAmmo.value < 4 and eqp == 2:
		$Reloadlabel.play("default")
		$Reloadlabel.visible = true
	else:
		$Reloadlabel.stop()
		$Reloadlabel.visible = false
		
func _on_RifleAmmo_value_changed(value):
	update_ammo_counts()
	if $RifleAmmo.value < 8 and eqp == 1:
		$Reloadlabel.play("default")
		$Reloadlabel.visible = true
	else:
		$Reloadlabel.stop()
		$Reloadlabel.visible = false
		
func _on_Shotgunammo_value_changed(value):
	update_ammo_counts()
	if $Shotgunammo.value < 2 and eqp == 3:
		$Reloadlabel.play("default")
		$Reloadlabel.visible = true
	else:
		$Reloadlabel.stop()
		$Reloadlabel.visible = false
		
func dead():
	$dead.show()
	hairs.hide()
	equipped_weapon.hide()
	$head/Camera/Particles2D.emitting = false
	death_timer += 1
	if death_timer < 80:
		$head/Camera.translation.z += 0.2
	if death_timer < 100:
		$head/Camera.translation.y += 0.05
	if death_timer == 400:
		update_global()
		health = 1000
		Global.previous_scene = get_tree().current_scene.name + ".tscn"
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
		"p_spare_ammo" : p_spare_ammo,
		"r_spare_ammo" : r_spare_ammo,
		"eqp" : eqp,
		"alternate_weapons" : alternate_weapons,
		"unfound_weapons" : unfound_weapons,
		"spare_hpots" : spare_hpots,
		"spare_spots" : spare_spots,
		"spare_stpots" : spare_stpots,
		"spare_grenades" : grenades,
		"boss_killed": $"/root/Global".boss_killed,
		"mouse_sensitivity" : mouse_sensitivity,
		"difficulty" : settings.difficulty
	}
	return save_dict




func _on_ProgressBar_value_changed(value):
	update_ammo_counts()


func _on_Campfire_body_entered(body):
	if "Player" in body.name:
		Global.can_rest = true


func _on_Campfire2_body_entered(body):
	if "Player" in body.name:
		Global.can_rest = true


func _on_Campfire2_body_exited(body):
	if "Player" in body.name:
		Global.can_rest = false


func _on_Campfire_body_exited(body):
	if "Player" in body.name:
		Global.can_rest = false
