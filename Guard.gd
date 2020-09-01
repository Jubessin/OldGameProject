extends KinematicBody
var path = []
var path_ind = 0

var speed
const WALK_SPEED = 1
var patience = 0
var gravity = -9.8 * 4
var p1 = false
var p2 = false
var p3 = false
var p4 = false
var p5 = false
var p6 = false
var p7 = false
var p8 = false
var p9 = false
var p10 = false
var p11
var time_go = 0
var jump = false
func _ready():
	$AnimatedSprite3D.play("left")
	speed = WALK_SPEED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player = get_parent().get_parent().get_child(1)
	if p6:
		p7 = true
#	print(global_transform.origin)
#	var vec_to_point = (Vector3(get_parent().get_child(7).get_child(0).global_transform.origin.x, 2.1, get_parent().get_child(7).get_child(0).global_transform.origin.z))
#	vec_to_point = vec_to_point.normalized()
#
#	if translation.x > -14 and translation.x < -13 and translation.z > -26 and translation.z < -25:
#		print("y")
#	translate(vec_to_point * speed * delta)
	if $".".name == "Guard1":
		if not (translation.x > -15 and translation.x < -14) and p1 == false:
			translation.x -= 1.5 * delta
		if translation.x > -15 and translation.x < -14:
			p1 = true
			
		if p1 and not p2:
			$AnimatedSprite3D.play("idle")
			time_go += 1
			if time_go == 220:
				p2 = true
		if p2 and not (translation.x > 24.7 and translation.x < 25.0):
			$AnimatedSprite3D.play("forward")
			translation.x += 2.8 * delta
		if p2 and translation.x > 24.7 and translation.x < 25.0:
			$AnimatedSprite3D.play("idle")
			p3 = true
			p2 = false
	if $".".name == "Guard2":
		if not p4 and not p6 and not p7:
			$AnimatedSprite3D.play("idle")
		if p4:
			$AnimatedSprite3D.play("forward")
			if not ($".".translation.z > 14.5 and $".".translation.z < 15.5):
				$".".translation.z += 2.5 * delta
			if $".".translation.z > 13.5 and $".".translation.z < 14.5:
				p5 = true
			if p5 and not ($".".translation.x > -70 and $".".translation.x < -69):
				$".".translation.x -= 3.1 * delta
			if $".".translation.x > -70 and $".".translation.x < -69:
				p5 = false
				p6 = true
				p4 = false
		if p6:
			if not ($".".translation.z > -1.5 and $".".translation.z < -0.5):
				translation.z -= 3.2 * delta
			if $".".translation.z > -1.5 and $".".translation.z < -0.5:
				$AnimatedSprite3D.play("idle")
				p8 = true
				p6 = false
	
	if $".".name == "Guard3":
		
		if p8:
			if $".".name == "Guard1":
				$".".queue_free()
			if $".".name == "Guard2":
				$".".queue_free()
			if not ($".".translation.x > -97.7 and $".".translation.x < -96.7):
				$".".translation.x -= 2.2 * delta
				$AnimatedSprite3D.play("forward")
			if $".".translation.x > -97.7 and $".".translation.x < -96.7:
				p9 = true
		
		if p9: 
			if not ($".".translation.z > 7 and $".".translation.z < 8):
				$".".translation.z += 3.5 * delta
			if $".".translation.z > 7 and $".".translation.z < 8:
				p10 = true
		if p10:
			$AnimatedSprite3D.play("idle")
				
		
#		if translation.z > -21 and translation.z < -20:
#			jump = true
#		if translation.z > -19 and translation.z < -18:
#			jump = true
#		if translation.z > -18 and translation.z < -17:
#			jump = true
#		if translation.z > -17 and translation.z < -16:
#			jump = true
#		if translation.z > -16 and translation.z < -15:
#			jump = true
#		if translation.z > -15 and translation.z < -14:
#			jump = true
	if $".".name == "Guard4":
		$AnimatedSprite3D.play("idle")
func _on_Area_body_entered(body):
	if "CPlayer" in body.name:
		p4 = true


func _on_Area2_body_entered(body):
	if "CPlayer" in body.name:
		p8 = true
