extends KinematicBody
const BULLET_SPEED = 80
var time_to_hit = 0
var hit = false
var dmg

func _ready():
	set_bullet_dmg(Global.str_pot_used)
	
func set_rotation(rot):
	.rotate_y(rot)

func _process(delta):
	time_to_hit += 1
	var forward_dir = -global_transform.basis.z.normalized()
	global_translate(forward_dir * BULLET_SPEED * delta)
	if time_to_hit == 15:
		queue_free()

func set_bullet_dmg(i):
	randomize()
	if i == null or i == false:
		dmg = round(rand_range(52.5, 71.7))
	if i == true:
		dmg = round(rand_range(73.5, 92.85))
	

func _on_b1_body_entered(body):
	if "GridMap" in body.name:
		queue_free()
	if "KnightMob" in body.name:
		body.lose_health(dmg)
		queue_free()
	if "Bossmob" in body.name:
		body.lose_health(dmg)
		queue_free()
	if "ForestMob" in body.name:
		body.lose_health(dmg)
		queue_free()
	if "NightFMob" in body.name:
		body.lose_health(dmg)
		queue_free()
	if "ForestBoss" in body.name:
		body.lose_health(dmg)
		queue_free()
	if "HumanMob" in body.name:
		body.lose_health(dmg)
		queue_free()
		
func _on_b2_body_entered(body):
	if "GridMap" in body.name:
		queue_free()
	if "KnightMob" in body.name:
		body.lose_health(dmg)
		queue_free()
	if "Bossmob" in body.name:
		body.lose_health(dmg)
		queue_free()
	if "ForestMob" in body.name:
		body.lose_health(dmg)
		queue_free()
	if "NightFMob" in body.name:
		body.lose_health(dmg)
		queue_free()
	if "ForestBoss" in body.name:
		body.lose_health(dmg)
		queue_free()
	if "HumanMob" in body.name:
		body.lose_health(dmg)
		queue_free()
		
func _on_b3_body_entered(body):
	if "GridMap" in body.name:
		queue_free()
	if "KnightMob" in body.name:
		body.lose_health(dmg)
		queue_free()
	if "Bossmob" in body.name:
		body.lose_health(dmg)
		queue_free()
	if "ForestMob" in body.name:
		body.lose_health(dmg)
		queue_free()
	if "NightFMob" in body.name:
		body.lose_health(dmg)
		queue_free()
	if "ForestBoss" in body.name:
		body.lose_health(dmg)
		queue_free()
	if "HumanMob" in body.name:
		body.lose_health(dmg)
		queue_free()