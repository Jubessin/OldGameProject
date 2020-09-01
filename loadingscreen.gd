extends Node2D

var time_to_load = 0
var time_passed = 11
var shot = false
var mouse_in_rad = false
var changed = true
var score = 0
func _ready():
	update_text()
	randomize()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$CanvasLayer/KinematicBody2D.position.x = rand_range(0, 1600)
	$CanvasLayer/KinematicBody2D.position.y = rand_range(100, 1100)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func change_pos():
	if changed:
		return
	else:
		randomize()
		$CanvasLayer/KinematicBody2D.position.x = rand_range(100, 1600)
		$CanvasLayer/KinematicBody2D.position.y = rand_range(100, 1100)
		changed = true
func play_theme():
	if $theme.playing:
		return
	else:
		$theme.play(0.0)
		
func play_shot():
	$AudioStreamPlayer2D.play(0.0)

func update_text():
	$RichTextLabel.clear()
	$RichTextLabel.add_text("Score:" + str(score))
func _process(delta):
	play_theme()
	if $theme.volume_db < 13:
		$theme.volume_db += 0.1
	print($ProgressBar.value)
	$ProgressBar.value += 3
	if $ProgressBar.value > 9995:
		get_tree().change_scene(Global.next_map)
	print(mouse_in_rad)
	$CanvasLayer/hairs.global_position = get_global_mouse_position()
	if mouse_in_rad and Input.is_action_just_pressed("shoot") and time_passed > 10:
		score += 1
		play_shot()
		shot = true
		changed = false
		change_pos()
		update_text()
		time_passed = 0
	if shot:
		time_passed += 1
	if time_passed == 11:
		shot = false
func _on_Area2D_mouse_entered():
	mouse_in_rad = true

func _on_Area2D_mouse_exited():
	mouse_in_rad = false
