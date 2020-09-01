extends ProgressBar

var health_value
var wait = false
var boss = ""
func _physics_process(delta):
	print(health_value)
	if get_parent().get_parent().get_parent().get_child(2).name == "Bossmob":
		boss = get_parent().get_parent().get_parent().get_child(2)
		health_value = boss.start_health
		max_value = boss.base_health
		if $".".value > health_value:
			$".".value -= 9
			wait = true
		if $".".value < health_value:
			$".".value += 10
			wait = true
	
	if get_parent().get_parent().get_parent().get_child_count() > 27:
		if get_parent().get_parent().get_parent().get_child(28).name == "ForestBoss":
			boss = get_parent().get_parent().get_parent().get_child(28) 
		
			max_value = boss.base_health
			health_value = boss.start_health
			if $".".value > health_value:
				$".".value -= 9
				wait = true
			if $".".value < health_value:
				$".".value += 10
				wait = true
	
	if not health_value == null or health_value == null:
		queue_free()
	if health_value <= 0:
		queue_free()