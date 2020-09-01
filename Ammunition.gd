extends KinematicBody

var velocity = Vector3()
var gravity = -9.8 * 4
var ammo_type
var obj_in_rad = []
func _ready():
	set_ammo_type()

func set_ammo_type():
	if $".".name.similarity("Rifle") > 0:
		print($".".name)
		ammo_type = 1
	if $".".name.similarity("Pistolammo") > 0:
		print($".".name)
		ammo_type = 2
	if $".".name.similarity("Shells") > 0:
		print($".".name)
		ammo_type = 3
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.y += gravity * delta
	move_and_slide(velocity)

	for i in obj_in_rad:
		i.gain_ammo(ammo_type)
		if i.gained_ammo == false:
			show()
		if i.gained_ammo == true:
			#i.gained_ammo = false
			queue_free()

func _on_Hitbox_body_entered(body):
	if "Player" in body.name:
		obj_in_rad.append(body)

		
		
#			body.gain_ammo(ammo_type)
#		if body.gained_ammo == false:
#			show()
#			else:
#				body.gained_ammo = false
#				queue_free()
	
	

func _on_Hitbox_body_exited(body):
	if "Player" in body.name:
		obj_in_rad.clear()
