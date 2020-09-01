extends KinematicBody

var patience = 0
var passed = false
var speed = 150
var is_attacking = false
var obj_in_rad = []
var velocity = Vector3()
var gravity = -9.8 * 4
var attack_timer = 34
var can_attack = false
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var vec_to_player = Vector3(get_parent().get_parent().get_child(1).translation.x, get_parent().get_parent().get_child(1).translation.y - 0.5, get_parent().get_parent().get_child(1).translation.z) - translation
	vec_to_player = vec_to_player.normalized()
	patience += 1
	if patience > 1 and not passed:
		move_and_slide(vec_to_player * speed * delta)
	if is_attacking:
		attack_timer += 1
		if attack_timer >= 35:
			can_attack = true
			attack_timer = 0
		else:
			can_attack = false
	if is_attacking != true or obj_in_rad.empty():
		$AnimatedSprite3D.play("forward")
	velocity.y += gravity * delta
	for i in obj_in_rad:
		is_attacking = true
		if can_attack:
			i.lose_health(rand_range(10.0, 65.0))
			$AnimatedSprite3D.play("attack")


func _on_HitBox_body_exited(body):
	if obj_in_rad.has(body):
		obj_in_rad.clear()
		


func _on_Hitbox_body_entered(body):
	if "CPlayer" in body.name:
		obj_in_rad.append(body)
		
func _on_Area_body_entered(body):
	if "CPlayer" in body.name:
		 passed = true
