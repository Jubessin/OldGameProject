extends KinematicBody

var in_pos
var timer = 0
var timer_start = false
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func move():
	if $".".translation.x > -188 and $".".translation.x < -187:
		return
	if not ($".".translation.x > -188 and $".".translation.x < -187):
		$".".translation.x += 1.5 * 0.01666
		timer_start = true
func _process(delta):
	if timer_start:
		timer += 1
	if timer == 500:
		get_parent().get_parent().trapdoor = true
