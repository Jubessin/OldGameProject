extends KinematicBody
var velocity = Vector3()
var gravity = -9.8 * 4
var gun
var gun_taken = false
var wait = 1
var go = 0
var goo = 0
var collidingbodies = []
var take_timer = 0
func _ready():
	set_treasure()

func set_treasure():
	if get_child(1).name == "Pistol":
		gun = "Pistol"
	if get_child(1).name == "Rifle":
		gun = "Rifle"
	if get_child(1).name == "Shotgun":
		gun = "Shotgun"
	if get_child(1).name == "Laser":
		gun = "Laser"
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.y += gravity * delta
	var player = get_parent().get_child(1)
	take_timer += 1
	move_and_slide(velocity)
	wait += 1
	collidingbodies = $Area.get_overlapping_bodies()
	if wait < 0:
		go += 1
	if wait > 1000:
		goo += 1
	if collidingbodies.has(player) and Input.is_action_just_pressed("open") and gun_taken == false and take_timer > 20:
		get_parent().get_child(1).pick_up(gun)

	if player.item_taken == true:
		collidingbodies.clear()
		wait = -100
		if go == 45:
			gun_taken = true
			if gun == "Pistol":
				
				get_parent().get_child(1).hairs.visible = true
				get_parent().get_child(1).textbox.visible = true
				get_parent().get_child(1).hand.visible = false
			else:
				get_parent().get_child(1).equipped_weapon.visible = true
				get_parent().get_child(1).hairs.visible = true
				get_parent().get_child(1).textbox.visible = true
				get_parent().get_child(1).hand.visible = false
			go = 0
	else:
		get_parent().get_child(1).item_taken = false
		wait = 1005
	if goo == 65:
		if gun == "Pistol":
			get_parent().get_child(1).hairs.visible = true
			get_parent().get_child(1).textbox.visible = true
			get_parent().get_child(1).hand.visible = false
		else:
			get_parent().get_child(1).equipped_weapon.visible = true
			get_parent().get_child(1).hairs.visible = true
			get_parent().get_child(1).textbox.visible = true
			get_parent().get_child(1).hand.visible = false
		goo = 0
	if gun_taken == true and go == 7:
		player.item_taken = false
		if gun == "Shotgun":
			get_parent().trap = true
		leave()

func leave():
	queue_free()







func _on_Area_body_entered(body):
	if "Player" in body.name:
		collidingbodies.insert(0, "Player")


func _on_Area_body_exited(body):
	if "Player" in body.name:
		collidingbodies.clear()