extends KinematicBody

var velocity = Vector3()
var gravity = -9.8 * 4
var treasure_type
var treasure
var item 
var item_type
var can_open = false
var item_taken = false
var animation_timer = 0
const PAMMO = preload("res://Pistol.tscn")
const RAMMO = preload("res://Rifle.tscn")
const HEALTHPOT = preload("res://healthpot.tscn")
const STAMINAPOT = preload("res://staminapot.tscn")
const STRENGTHPOT = preload("res://strengthpot.tscn")
const GRENADE = preload("res://Grenadespawn.tscn")
const SHELLS = preload("res://Shotgunammo.tscn")
const ARIFLE = preload("res://Riflespawn.tscn")
const SHOTGUN = preload("res://Shotgunspawn.tscn")
var spawn

var pAmmo = PAMMO.instance()
var rAmmo = RAMMO.instance()
var healthpot = HEALTHPOT.instance()
var staminapot = STAMINAPOT.instance()
var strengthpot = STRENGTHPOT.instance()
var grenade = GRENADE.instance()
var shells = SHELLS.instance()
var assault_rifle = ARIFLE.instance()
var shotgun = SHOTGUN.instance()
func _ready():
	randomize()
	if $".".name.similarity("Common") > 0.45:
		treasure_type = round(rand_range(1, 2.0))
	if $".".name.similarity("Rare") > 0.45:
		treasure_type = round(rand_range(1.0, 5.0))
	if $".".name == "gun":
		treasure_type = 6
	if $".".name == "ARifle":
		treasure_type = 3
	if $".".name == "Shotgun":
		treasure_type = 4
	if treasure_type == 1 or treasure_type == 3:
		treasure = "Pot"
	if treasure_type == 2:
		treasure = "Ammo"
	if treasure_type > 2:
		treasure = "Weapon"
	set_treasure()

func set_treasure():
	randomize()
	if $".".name.similarity("Common") > 0.45:
		if treasure == "Pot":
			item_type = randi()% 100
			if item_type < 50:
				item = "Health Potion"
			if item_type >= 50 and item_type < 80:
				item = "Stamina Potion"
			if item_type >= 80 and item_type < 101:
				item = "Strength Potion"
		if treasure == "Ammo":
			item_type = randi()% 100
			if item_type < 30:
				item = "Pistol Ammo"
			if item_type >= 30 and item_type < 60:
				item = "Rifle Ammo"
			if item_type >= 60:
				item = "Shells"
			if Global.player_unfound_weps.has("Rifle"):
				item = "Pistol Ammo"
			if Global.player_unfound_weps.has("Shotgun"):
				if Global.player_unfound_weps.has("Rifle"):
					item = "Pistol Ammo"
				else:
					item_type = rand_range(0, 59)
				if item_type < 30:
					item = "Pistol Ammo"
				if item_type < 60 and item_type >= 30:
					item = "Rifle Ammo"
	if $".".name.similarity("Rare") > 0.5:
		if treasure == "Powerup":
			item_type = randi()% 100
			if item_type < 50:
				item = "Stamina Potion"
			if item_type >= 50 and item_type < 80:
				item = "Strength Potion"
			if item_type >= 80 and item_type < 101:
				item = "Health Potion"
		if treasure == "Ammo":
			item = "Grenade"
		if treasure == "Weapon":
			item_type = randi() % 1000
			if item_type < 500:
				item = "Shotgun"
			if item_type >= 500:
				item = "Smg"
			pass
	if $".".name == "gun":
		item = "Launcher"
	if $".".name == "ARifle":
		item = "Rifle"
	if $".".name == "Shotgun":
		item = "Shotgun"
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if item == "Pistol Ammo":
		spawn = pAmmo
	if item == "Rifle Ammo":
		spawn = rAmmo
	if item == "Shells":
		spawn = shells
	if item == "Stamina Potion":
		spawn = staminapot 
	if item == "Health Potion":
		spawn = healthpot
	if item == "Strength Potion":
		spawn = strengthpot
	if item == "Grenade":
		spawn = grenade
	if item == "Rifle":
		spawn = assault_rifle
	if item == "Shotgun":
		spawn = shotgun
	velocity.y += gravity * delta
	move_and_slide(velocity)
	animation_timer += 1
	var player = get_parent().get_child(1)
	if $OpenBox.get_overlapping_bodies().size() > 0 and $OpenBox.get_overlapping_bodies().has(player) and Input.is_action_pressed("open") and item_taken == false:
		animation_timer = 0
		get_parent().get_child(1).open_treasure(item)
		$AnimatedSprite3D.play("open")
		
		item_taken = true
#	if get_parent().get_child(1).is_opening:
#		get_parent().get_child(1).equipped_weapon.hide()
			
		
	if item_taken:
		if animation_timer == 10:
			if item == "Pistol Ammo":
				spawn.translation = Vector3(translation.x, translation.y + 1, translation.z)
			if item == "Rifle Ammo":
				spawn.translation = Vector3(translation.x, translation.y + 1, translation.z)
			if item == "Shells":
				spawn.translation = Vector3(translation.x, translation.y + 1, translation.z)
			if item == "Stamina Potion" or item == "Health Potion" or item == "Strength Potion":
				spawn.translation = Vector3(translation.x, translation.y, translation.z)
			if item == "Grenade":
				spawn.translation = Vector3(translation.x, translation.y + 1, translation.z)
			if item == "Rifle" or item == "Shotgun":
				spawn.translation = Vector3(translation.x, translation.y + 1, translation.z)
			get_parent().add_child(spawn)
			
		if animation_timer > 50:
			$AnimatedSprite3D.play("opened")	
		if animation_timer == 80:
			get_parent().get_child(1).is_opening = false
			get_parent().get_child(1).hand.hide()
		

func _on_OpenBox_body_exited(body):
	if "Player" in body.name:
		if "CPlayer" in body.name:
			body.hand.visible = false
			return
		else:
#			body.equipped_weapon.visible = true
			body.hairs.visible = true
			body.textbox.visible = true
			body.hand.visible = false

