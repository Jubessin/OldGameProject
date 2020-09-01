extends KinematicBody
const LASER_SPEED = 1460
var time_to_hit = 0
var hit = false
var dmg

func _ready():
	set_laser_dmg()
	

func set_rotation(rot):
	.rotate_z(rot)

func set_laser_dmg():
	randomize()
	dmg = round(rand_range(31.0, 54.8))
		 
func _process(delta):
	var forward_dir = -global_transform.basis.z.normalized()

	move_and_slide(forward_dir * LASER_SPEED * delta)
	time_to_hit += 1
	
	if time_to_hit == 55:
		queue_free()
func _on_Area_body_entered(body):
	if "GridMap" in body.name:
		queue_free()
	if "ForestMob" in body.name:
		body.lose_health(dmg)
		body.see_player = true
	if "KnightMob" in body.name:
		body.lose_health(dmg)
		body.see_player = true
	if "NightFMob" in body.name:
		body.lose_health(dmg)
		body.see_player = true
	if "ForestBoss" in body.name:
		body.lose_health(dmg)
		body.see_player = true
	if "HumanMob" in body.name:
		body.lose_health(dmg)