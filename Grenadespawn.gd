extends KinematicBody

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var collidingbodies = []
var wait = 1
var go = 0
var goo = 0
var picked = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(collidingbodies)
	var player = get_parent().get_child(1)
	collidingbodies = $Area.get_overlapping_bodies()
	wait += 1
	if wait < 0:
		go += 1
	if wait > 1000:
		goo += 1
	if collidingbodies.has(player) and Input.is_action_just_pressed("open") and picked == false:
		get_parent().get_child(1).pick_up("grenade")
	
	if get_parent().get_child(1).item_taken == true:
		collidingbodies.clear()
		wait = -100
		if go == 45:
			picked = true
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
	if picked == true and go == 7:
		get_parent().get_child(1).item_taken = false
		leave()

func leave():
	queue_free()

