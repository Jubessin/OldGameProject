extends Node2D

var difficulty = "Medium" 
const CONTROLMENU = preload("res://Controls.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
func play_theme():
	if $AudioStreamPlayer2D.playing:
		return
	else:
		$AudioStreamPlayer2D.play(0.0)
func update_values():
	$MSensSlider/RichTextLabel.clear()
	$MSensSlider/RichTextLabel.add_text(String(round($MSensSlider.value)))
func exit():
	get_tree().change_scene(Global.previous_scene)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $AudioStreamPlayer2D.volume_db < -9:
		$AudioStreamPlayer2D.volume_db += 0.1
	play_theme()
	if $".".visible == false:
		$Control/Hard.disabled = true
		$Control/Easy.disabled = true
		$Control/Medium.disabled = true
	else:
		$Control/Hard.disabled = false
		$Control/Medium.disabled = false
		$Control/Easy.disabled = false
	if $Controls.pressed and Input.is_action_just_pressed("shoot"):
		var controls = CONTROLMENU.instance()
		.add_child(controls)
	if $Back.pressed:
		$sword/AcceptDialog.popup_centered(Vector2(781, 500))
		
	if $Control/Hard.pressed:
		difficulty = "Hard"
	if $Control/Medium.pressed:
		difficulty = "Medium"
	if $Control/Easy.pressed:
		difficulty = "Easy"
	$"/root/settings".difficulty = difficulty
	
	update_values()
	$"/root/settings".mouse_sensitivity = $MSensSlider.value
	settings.difficulty

func _on_AcceptDialog_confirmed():
	get_tree().change_scene(Global.previous_scene)
