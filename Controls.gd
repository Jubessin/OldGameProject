extends Node2D

var timer = 0

func _ready():
	$".".visible = true
	$Control.visible = true
	$Additional.visible = false
func change_screen():
	if $Control.visible:
		$Control.hide()
		$Additional.visible = true
		return
	if $Additional.visible:
		$Additional.hide()
		$Control.visible = true
		return
func _process(delta):
	timer += 1
	if $Back.pressed:
		queue_free()
	if $Additional2.pressed and Input.is_action_just_pressed("shoot") and timer > 15:
		change_screen()
		timer = 0
