extends Area
var new_point
var obj_in_rad = []
func _ready():
	new_point = round(rand_range(1, 35))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#func spawn_point(point):
#	get_parent().spawn(new_point)
#	queue_free()
##	pass
#
##func _on_Area_area_shape_entered(area_id, area, area_shape, self_shape):
##	print(area)
##	if area.name.similarity("Bullet") > 0:
##		obj_in_rad.append(area)
#
#
#
#func _on_Area_area_entered(area):
#	print(area)
#	
#
#
#func _on_Area_body_entered(body):
#	print(body)


func _on_Target_body_entered(body):
	if "RBullet" in body.name:
		obj_in_rad.append(body)
	if "Bullet" in body.name:
		obj_in_rad.append(body)