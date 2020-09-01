extends Sprite3D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_color(can_hit):
	if can_hit == true:
		$".".material_override.albedo_color = Color.red
#		.set_modulate(Color.red)
	if can_hit == false:
		$".".material_override.albedo_color = Color.white
#		.set_modulate(Color.white)
func _physics_process(delta):
	pass