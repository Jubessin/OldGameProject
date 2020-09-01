extends Area

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player = get_parent().get_parent().get_child(1)
	if self.get_overlapping_bodies().has(player):
		Global.can_leave = true
	else:
		Global.can_leave = false
