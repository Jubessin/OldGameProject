extends KinematicBody
var velocity = Vector3()
var gravity = -9.8 * 4
var pot_type
var pot
var pot_taken = false
var wait = 1
var go = 0
var goo = 0
var collidingbodies = []
var take_timer = 0
var just_clicked = false
var last_click = 0
func _ready():
	set_treasure()

func set_treasure():
	if get_child(2).name == "health":
		pot = "health"
	if get_child(2).name == "stamina":
		pot = "stamina"
	if get_child(2).name == "strength":
		pot = "strength"
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.y += gravity * delta
	var player = get_parent().get_child(1)
	take_timer += 1
	move_and_slide(velocity)
	wait += 1
	print(collidingbodies)
	collidingbodies = $Area.get_overlapping_bodies()
	if wait < 0:
		go += 1
	if wait > 1000:
		goo += 1
	if just_clicked:
		last_click += 1
	if last_click > 50:
		just_clicked = false
		last_click = 0
	if collidingbodies.has(player) and Input.is_action_just_pressed("open") and pot_taken == false and take_timer > 20 and not just_clicked:
		get_parent().get_child(1).pick_up(pot)
		just_clicked = true
	
	if get_parent().get_child(1).item_taken == true:
		collidingbodies.clear()
		wait = -100
		if go == 45:
			pot_taken = true
			get_parent().get_child(1).equipped_weapon.visible = true
			get_parent().get_child(1).hairs.visible = true
			get_parent().get_child(1).textbox.visible = true
			get_parent().get_child(1).hand.visible = false
			go = 0
	else:
		get_parent().get_child(1).item_taken = false
		wait = 1005
	if goo == 65:
		get_parent().get_child(1).equipped_weapon.visible = true
		get_parent().get_child(1).hairs.visible = true
		get_parent().get_child(1).textbox.visible = true
		get_parent().get_child(1).hand.visible = false
		goo = 0
	if pot_taken == true and go == 7:
		get_parent().get_child(1).item_taken = false
		leave()

func leave():
	queue_free()	
		



		


func _on_Area_body_entered(body):
	if "Player" in body.name:
		collidingbodies.insert(0, "Player")


func _on_Area_body_exited(body):
	if "Player" in body.name:
		collidingbodies.clear()
